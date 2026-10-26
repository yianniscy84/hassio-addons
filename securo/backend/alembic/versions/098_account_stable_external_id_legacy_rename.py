"""rename legacy stable_id to stable_external_id on accounts

Revision ID: 098
Revises: 097
Create Date: 2026-10-26

Addon versions 0.32 and 0.33 carried an early adoption of Enable Banking stable
ids using column name `stable_id` in migration 097. Upstream v0.16.5 officially
merged this feature under the name `stable_external_id` (migration 097).

For databases upgrading from addon 0.32/0.33, the database revision was already
at 097 with column `stable_id`, so upstream's 097 was skipped. This migration
ensures `stable_external_id` exists by renaming `stable_id` if present, or
adding `stable_external_id` if missing.
"""
from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "098"
down_revision: Union[str, None] = "097"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    conn = op.get_bind()
    inspector = sa.inspect(conn)
    columns = [c["name"] for c in inspector.get_columns("accounts")]
    if "stable_external_id" not in columns:
        if "stable_id" in columns:
            op.alter_column("accounts", "stable_id", new_column_name="stable_external_id")
        else:
            op.add_column("accounts", sa.Column("stable_external_id", sa.String(255), nullable=True))


def downgrade() -> None:
    pass
