Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EF544BAD6
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 05:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhKJEg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 23:36:56 -0500
Received: from mail-sn1anam02on2059.outbound.protection.outlook.com ([40.107.96.59]:20194
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230273AbhKJEg4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 23:36:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAZeAJgWryGjRCZtiw1grEEumt+8siHCTBBTsi2lOyqWg96N6NERgNedTyeEWUDHms6j7divzjZ+CmthfHHGvABvFoX4sGnYKOX9sAW5ItlOookaDhqy9KyouVwG3/wOawHICQWq0PAV7UiL7w+8GDqHganPEmqNEYj7qD6nW/u3FoIRq5KjockT3Q5nL895+1Dc2NUdModZ7Bx/oNsmQAl5HQTSS/sqHjlZ5Bwhk/VTBPYV57bNVC4VOpCwnbdHW6jn1tCLrUUG82/69FljPFeayCTBvSCvltvQs0YdOOVdDOrVGrL7nR4ZnpJ6OqUjmFahmPoEcf+74ubYvV0Xvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pUWwWOdv2rUQI0P8OO1qfJ7hH45ytnsQ97K9I0GusXw=;
 b=GsgydpBme9J0FZuEjqsVQ/pfWIP6TyHQPMVNe9jJ8+ljpcKZISzMrP4WrOjfejfyD1CfsEEHyMSuQfBZMckP8zDXiniaYzQTf57jA+dtH2SfTVmI0YLUDZkOJGU1PIbYoEcCq+3gt5HPUT6dVzjQwboimWBsfI415Z5kbiP5ZEuSHwvB23OizN6p5qJoJnLJUqFHmuj4X7Ah6lqw3v/G0KPMBmTk3mAOPq+FrRiMttnepe+2TN8GpjpbaPICftwottVOt5eJhfKyYGj2LQoS6ZgPSYUFk/MIOqhi7thAgzo5S0lr+fyVRbwHOrJQQS/ZAnJtZ3EiXhZwTN51+AGB8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pUWwWOdv2rUQI0P8OO1qfJ7hH45ytnsQ97K9I0GusXw=;
 b=orceaipSB6F7UulumgNETQham+kD2CnTSu1aHIBmr+oArV0Wyw2jxrp3tp1kR6r4+gu6uqwxy9FmkpcE9uH2o6a279NGAtyepPQkFBA8Pf8fy8nxNYPUbLLCqiKb2MG7Gu5KnSAPQSa7iihME2PaSjDvAIVpy5jwrn5np7HoDDU=
Received: from MW4PR03CA0314.namprd03.prod.outlook.com (2603:10b6:303:dd::19)
 by BYAPR12MB3286.namprd12.prod.outlook.com (2603:10b6:a03:139::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15; Wed, 10 Nov
 2021 04:34:04 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::1b) by MW4PR03CA0314.outlook.office365.com
 (2603:10b6:303:dd::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16 via Frontend
 Transport; Wed, 10 Nov 2021 04:34:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4690.15 via Frontend Transport; Wed, 10 Nov 2021 04:34:04 +0000
Received: from pp-server-two.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Tue, 9 Nov
 2021 22:33:59 -0600
From:   xinhui pan <xinhui.pan@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <christian.koenig@amd.com>, <dri-devel@lists.freedesktop.org>,
        xinhui pan <xinhui.pan@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/2] drm/ttm: Put BO in its memory manager's lru list
Date:   Wed, 10 Nov 2021 12:31:48 +0800
Message-ID: <20211110043149.57554-1-xinhui.pan@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e8285e8-9229-4453-4997-08d9a4035390
X-MS-TrafficTypeDiagnostic: BYAPR12MB3286:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3286F1FDD873B6A1CB39107887939@BYAPR12MB3286.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pnBj7yKhY75O1DAjQpZ4o7JZLQs+Ct+9VNGY1z1afCO9dXLYSO6zvj3FhVVQ1lYzpOpbmr70C1OLfCU473hrhZ258AeO7aWIPgkc7/DZ4AUdjaT/JwcjxFQKRSTnelfdZrANo7WR56YLcy57lWB9z8lwGCnNDyAv9a23iPfnRv5MfqCDY9EkSPOX8GrOdd/K1h5NQjw2QWV28BHj03WpqSc3RXTKN7nSOuvKOPMhbYxvmySNS1LjnY3sDYYah+DJypacyhzm9lWh2xUnASWnsGFBWP5IfxScQtvF8ANTAVH0KoEoZx3OXi3XNb62vlX1bdB9gq0+2JS5IdbGXVMl1lzNjjyr7FB5usVXP8DyCwhpsJ33Yt18hjRKMeeXT/AEfAy/YB6/Go3GrX3bbZscSkXfr6zRW3mhTV+heni1st2jobHoTR0j+wsYUQUUMbZB9cabODEfOv5I5QkVjQL8MlCi1PgznxwYEkzivRnI84prgQgQqq1EWvY6iJSx+sdOOIylZt9+KCXHgC2NK0PH7ik23xDHoWG1FbEkO9axpSfIgazZepyWuf4eqBZdD7JVeOXaYv+MrroALOWSppZFNOPwWMrS2dmHeURBhPIuYrFvF1DgtIiiUWL6NBmb+zxzcDuvQ+g8r6+Fzr3S366uG0KLD65TpdQlF7TluJeGv6zsNlyi5K2/rbq/k57aFqcIxzWhjY9F4yGx/Zw6I3TIXyCZ+bPKLNT6nCrY/xtnX6Y=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(5660300002)(4744005)(336012)(70206006)(508600001)(6916009)(81166007)(7696005)(356005)(4326008)(83380400001)(70586007)(36756003)(2906002)(426003)(36860700001)(8936002)(8676002)(86362001)(186003)(316002)(47076005)(6666004)(82310400003)(54906003)(16526019)(1076003)(66574015)(2616005)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 04:34:04.1618
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e8285e8-9229-4453-4997-08d9a4035390
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3286
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After we move BO to a new memory region, we should put it to
the new memory manager's lru list regardless we unlock the resv or not.

Cc: stable@vger.kernel.org
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: xinhui pan <xinhui.pan@amd.com>
---
 drivers/gpu/drm/ttm/ttm_bo.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index f1367107925b..e307004f0b28 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -701,6 +701,8 @@ int ttm_mem_evict_first(struct ttm_device *bdev,
 	ret = ttm_bo_evict(bo, ctx);
 	if (locked)
 		ttm_bo_unreserve(bo);
+	else
+		ttm_bo_move_to_lru_tail_unlocked(bo);
 
 	ttm_bo_put(bo);
 	return ret;
-- 
2.25.1

