# Original MySQL export

Your source of truth is the uploaded dss_db(1).sql (25 SmartStock tables, MySQL 8.4.x).
The Laravel migrations in this project are guarded with Schema::hasTable(): they create absent tables, and do not recreate existing imported tables. Never re-import the original SQL without a backup: that export includes DROP TABLE statements.
The two order-item line_total columns are GENERATED STORED in MySQL: write only quantity and unit_cost or unit_price; MySQL computes line_total. Some original tables have created_at only or no timestamps: their Eloquent models are configured accordingly.
Migration 000004 safely adds critical CHECK constraints/index guards on either installation path. Migrations deliberately don't drop adopted tables on rollback.
