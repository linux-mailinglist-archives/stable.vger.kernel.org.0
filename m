Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1746944CDCD
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 00:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbhKJX3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 18:29:02 -0500
Received: from mail-bn8nam12on2083.outbound.protection.outlook.com ([40.107.237.83]:42470
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233965AbhKJX3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 18:29:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b2trfGmaixBawmfmBUrK/IDRyIMT1KL/fBxaFXbnvsbpQQQGbKbj+Bwr8/rR/CKrlFRTrav6SKTfQiNciOZx1ejMnekq9FrGgBioKcUb1+mvIQmyzunpA02bJ49z6n0m9rVxIyk78wpFhv0z8gjFe87SqoSyPDGmSgNIh+4WO2OMWxIF93QGyObOmV1M0gAHgW+/n3UPVLvoyurVJrzizxDy3XbK+oKSoRzGU+hrOb+kfKsVZaR2KfIUlvE1wNubRT1EF+S8UCaVzI9p/0QT+k9iMCFpAFRvlchNeqU3LWaUQwN8CHHnzWESJc8EYpIawpuDxV2kLvzZ/Hg/HmPazA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n15QF2nK5KsiNB3VzMaU/+2daFtqAL+ZoIAK3+40ypk=;
 b=QwXQkgsEz3LMHpzNVqB9bG+bcJlSvPBq1LUhQhFKDFD1QpeP48uVsGq763MOJYcPITYgfR3PHDfkinZBPixcl56qfcogh5LGhMAVyfyleaKAQkKUgtB7MPTHfdoTDx20r8WDOnnZu/9wF+Xi1qihKhyNuP8v/QZ+jmD8MnWuAxxV6/YoBkUSosDGxpQ7y4zzSSK0vqqxtKQzvXTITsRssevt9xMISlGSfrGoedZNObN/pRurvSehPNC4K+MzRYB3bsKpKObhzSnTSAaYKej2q4Z5BJIZlkUfBlLoOKecsRt5c0eCTnd6nZVaQxZwnEOFXeLWXxIcgWtsPpII0ldprg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n15QF2nK5KsiNB3VzMaU/+2daFtqAL+ZoIAK3+40ypk=;
 b=zW67wOj4Tq4d59TgdOj8RzOXiajyVSWnTyEg9dqpvqdWSdOUraikpaHy9qISGBe9qB14SvqOkwn8D+0v2XV7Uyfxq9Pllry3kBJgL50yCCX8lZMSrkcmZxI1sgK8ncOowuSk1LQ/KPy6ZWbgRCRE33HqTKTi9Cd3SxEIbe70I7E=
Received: from DM5PR13CA0018.namprd13.prod.outlook.com (2603:10b6:3:23::28) by
 BN8PR12MB4978.namprd12.prod.outlook.com (2603:10b6:408:76::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.17; Wed, 10 Nov 2021 23:26:10 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:23:cafe::cc) by DM5PR13CA0018.outlook.office365.com
 (2603:10b6:3:23::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend
 Transport; Wed, 10 Nov 2021 23:26:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4690.15 via Frontend Transport; Wed, 10 Nov 2021 23:26:10 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Wed, 10 Nov
 2021 17:26:09 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH] drm/amd/display: Look at firmware version to determine using dmub on dcn21
Date:   Wed, 10 Nov 2021 17:25:54 -0600
Message-ID: <20211110232554.2190-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 595f874a-1869-483c-99bf-08d9a4a17a8b
X-MS-TrafficTypeDiagnostic: BN8PR12MB4978:
X-Microsoft-Antispam-PRVS: <BN8PR12MB497847DCF07BCAF1978EDC4CE2939@BN8PR12MB4978.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z72nE9vg3GfsLjQTxtvyJnRx8nqvIS/hfkxR3pn0k4nNostxDJd1T2MMb52IVMWA3jS+Ek45CULI8IxMYymbU2+T/hz9BD0JS4uBPNg8X1A3QtRhmhNGI0e/gC7+E73Vm7jyuNf3XtDfzMNr/OQ312YORnw6xAEh+2Y2tuvDr3XDTETOwNWB2sIVVgluW0kVv2C/go3Pimvv5f7GbA6fEczZMhOhIfqFKYDb5dnFm15ajqimjV0zdGLkTERXCxQg71dV0EZU8FBaLQEMW2feIlJe31pHJreN1IqDzzyFZwN5KVI4B4h+ghPevgsc+BuSAQhdXCLfuTtXAuNyiDxbJGAL0vM8gk6KjtIOEV9cmLKfOnedM/UoHAcyzuwqvBg6vbNvbqbFsTN5hzeeMhLXfAi9nGqt3E3JEDgCBJ32Kz4MCccaGFIYyU7Z4sIVQExlSRLlOZtLeigy7t7jS1/MYmhSVax38fnn/vMUyofxJ4pMN10Z/UoLVTagV9drv7N+hqnR6uUTxCT1nDI/K8h7XB7z+Odt+/9jo5rl8oqa4eGPu292mWkH1MODn4/JrgYhU3Cw3wEiR8JKEKPk2AL9kk0tQCcofFdcXs0DFgyGQqGrHYrQfm8JEISVJs3owCWOtOEhksNX/8V9IQPSTAOF7y4Rev6rQfLWBC0MHJlhW/oYNCBnmKyn808BFWfoDEmCJFBAX8VGmFBtD+cQj/JQGliuZU+SpUOwD9CsU3gf2+I=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2906002)(4326008)(7696005)(44832011)(5660300002)(36860700001)(6916009)(356005)(8936002)(36756003)(81166007)(47076005)(54906003)(966005)(6666004)(1076003)(82310400003)(26005)(70206006)(70586007)(2616005)(316002)(186003)(8676002)(336012)(86362001)(426003)(16526019)(83380400001)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 23:26:10.1495
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 595f874a-1869-483c-99bf-08d9a4a17a8b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB4978
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Newer DMUB firmware on Renoir and Green Sardine do not need to disable dmcu
and this actually causes problems with DP-C alt mode for a number of machines.

Backport the fix from this from mainline.  It's a hand modified backport because
mainline switched to IP version checking which doesn't exist in linux-stable.

BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1772
BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1735
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
---
Resend, also pick up Alex's tag from last submission
This was previously sent to stable@kernel.org not stable@vger.kernel.org.

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 1ea31dcc7a8b..084491afe540 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1141,8 +1141,15 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	case CHIP_RAVEN:
 	case CHIP_RENOIR:
 		init_data.flags.gpu_vm_support = true;
-		if (ASICREV_IS_GREEN_SARDINE(adev->external_rev_id))
+		switch (adev->dm.dmcub_fw_version) {
+		case 0: /* development */
+		case 0x1: /* linux-firmware.git hash 6d9f399 */
+		case 0x01000000: /* linux-firmware.git hash 9a0b0f4 */
+			init_data.flags.disable_dmcu = false;
+			break;
+		default:
 			init_data.flags.disable_dmcu = true;
+		}
 		break;
 	case CHIP_VANGOGH:
 	case CHIP_YELLOW_CARP:
-- 
2.25.1

