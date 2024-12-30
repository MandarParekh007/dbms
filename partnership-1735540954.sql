CREATE TABLE IF NOT EXISTS "Company" (
	"company_id" serial NOT NULL UNIQUE,
	"Name" varchar(255) NOT NULL,
	"domain" varchar(255) NOT NULL,
	PRIMARY KEY ("company_id")
);

CREATE TABLE IF NOT EXISTS "User" (
	"user_id" serial NOT NULL UNIQUE,
	"Company_id" bigint NOT NULL,
	"role" varchar(255) NOT NULL,
	PRIMARY KEY ("user_id")
);

CREATE TABLE IF NOT EXISTS "Partnership" (
	"partnership_id" serial NOT NULL UNIQUE,
	"lead_id" bigint NOT NULL,
	"campeign_id" bigint NOT NULL,
	PRIMARY KEY ("partnership_id")
);

CREATE TABLE IF NOT EXISTS "Partners" (
	"partnership_id" serial NOT NULL UNIQUE,
	"partner_id" bigint NOT NULL,
	PRIMARY KEY ("partnership_id")
);

CREATE TABLE IF NOT EXISTS "Campeign" (
	"Campeign_id" serial NOT NULL UNIQUE,
	"name" varchar(255) NOT NULL,
	"start_date" date NOT NULL,
	"end_date" date NOT NULL,
	"lead_id" bigint NOT NULL,
	"solution_id" bigint NOT NULL,
	PRIMARY KEY ("Campeign_id")
);

CREATE TABLE IF NOT EXISTS "Lead" (
	"lead_id" serial NOT NULL UNIQUE,
	"lead_name" varchar(255) NOT NULL,
	"description" varchar(255) NOT NULL,
	"email" varchar(255) NOT NULL,
	"solution_id" bigint NOT NULL,
	PRIMARY KEY ("lead_id")
);

CREATE TABLE IF NOT EXISTS "Opportunity" (
	"opportunity_id" serial NOT NULL UNIQUE,
	"account_id" bigint NOT NULL,
	"lead_id" bigint NOT NULL,
	"amount" bigint NOT NULL,
	PRIMARY KEY ("opportunity_id")
);

CREATE TABLE IF NOT EXISTS "Account" (
	"account_id" serial NOT NULL UNIQUE,
	"lead_id" bigint,
	"name" varchar(255) NOT NULL,
	"website" varchar(200) NOT NULL,
	PRIMARY KEY ("account_id")
);

CREATE TABLE IF NOT EXISTS "Solution" (
	"solution_id" serial NOT NULL UNIQUE,
	"partnership_id" bigint NOT NULL,
	"solution_name" varchar(255) NOT NULL,
	"description" varchar(255) NOT NULL,
	PRIMARY KEY ("solution_id")
);

CREATE TABLE IF NOT EXISTS "Roles" (
	"role_id" serial NOT NULL UNIQUE,
	"role" varchar(255) NOT NULL,
	PRIMARY KEY ("role_id")
);

CREATE TABLE IF NOT EXISTS "Partnership_roles" (
	"partnership_id" bigint NOT NULL,
	"user_id" bigint NOT NULL,
	"role_id" bigint NOT NULL
);


ALTER TABLE "User" ADD CONSTRAINT "User_fk1" FOREIGN KEY ("Company_id") REFERENCES "Company"("company_id");

ALTER TABLE "User" ADD CONSTRAINT "User_fk2" FOREIGN KEY ("role") REFERENCES "Roles"("role_id");
ALTER TABLE "Partnership" ADD CONSTRAINT "Partnership_fk1" FOREIGN KEY ("lead_id") REFERENCES "Company"("company_id");

ALTER TABLE "Partnership" ADD CONSTRAINT "Partnership_fk2" FOREIGN KEY ("campeign_id") REFERENCES "Campeign"("Campeign_id");
ALTER TABLE "Partners" ADD CONSTRAINT "Partners_fk0" FOREIGN KEY ("partnership_id") REFERENCES "Partnership"("partnership_id");

ALTER TABLE "Partners" ADD CONSTRAINT "Partners_fk1" FOREIGN KEY ("partner_id") REFERENCES "Company"("company_id");
ALTER TABLE "Campeign" ADD CONSTRAINT "Campeign_fk4" FOREIGN KEY ("lead_id") REFERENCES "Lead"("lead_id");

ALTER TABLE "Campeign" ADD CONSTRAINT "Campeign_fk5" FOREIGN KEY ("solution_id") REFERENCES "Solution"("solution_id");
ALTER TABLE "Lead" ADD CONSTRAINT "Lead_fk4" FOREIGN KEY ("solution_id") REFERENCES "Solution"("solution_id");
ALTER TABLE "Opportunity" ADD CONSTRAINT "Opportunity_fk1" FOREIGN KEY ("account_id") REFERENCES "Account"("account_id");

ALTER TABLE "Opportunity" ADD CONSTRAINT "Opportunity_fk2" FOREIGN KEY ("lead_id") REFERENCES "Lead"("lead_id");
ALTER TABLE "Account" ADD CONSTRAINT "Account_fk1" FOREIGN KEY ("lead_id") REFERENCES "Lead"("lead_id");
ALTER TABLE "Solution" ADD CONSTRAINT "Solution_fk1" FOREIGN KEY ("partnership_id") REFERENCES "Partnership"("partnership_id");

ALTER TABLE "Partnership_roles" ADD CONSTRAINT "Partnership_roles_fk0" FOREIGN KEY ("partnership_id") REFERENCES "Partnership"("partnership_id");

ALTER TABLE "Partnership_roles" ADD CONSTRAINT "Partnership_roles_fk1" FOREIGN KEY ("user_id") REFERENCES "User"("user_id");

ALTER TABLE "Partnership_roles" ADD CONSTRAINT "Partnership_roles_fk2" FOREIGN KEY ("role_id") REFERENCES "Roles"("role_id");






SELECT 
    c.Name AS Company_Name,
    SUM(o.amount) AS Total_Amount
FROM 
    Company c
JOIN 
    Partners pt ON c.company_id = pt.partner_id
JOIN 
    Partnership p ON pt.partnership_id = p.partnership_id
JOIN 
    Solution s ON p.partnership_id = s.partnership_id
JOIN 
    Lead l ON s.solution_id = l.solution_id
JOIN 
    Account a ON l.lead_id = a.lead_id
JOIN 
    Opportunity o ON a.account_id = o.account_id
GROUP BY 
    c.Name;
