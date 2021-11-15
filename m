Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E224508A9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 16:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbhKOPjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 10:39:54 -0500
Received: from mail-sn1anam02on2064.outbound.protection.outlook.com ([40.107.96.64]:32998
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231562AbhKOPjx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 10:39:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aM3+nG34Bh7tIXIelV5E5JdntGFMexDa0YxwwZ6k3Vtz9xjRIxCUHxgD+qc1LKZugUmlLNslBUwgy7SgMG/cosFymUIEQOLoIyqtLc1C0Fc0KkemaGI9ViW8w7ykJnWQPMUjqXKbiJHa62y/n1SGfHb707Bzc2IGmYfZ1o1dSkwQm2HoHE7DoZmtvTvojV5tXbVcBQbI+WPZGQJMRk2q/mar3kvvtHA5PSDlbbar8lnYahidILcX8FhDL7fsvQREjBv503ZMCKQJYtn/QXwMKU3QfxFU4V862WCrufT3bNxbvtvBdeXRF6UqEilmj3jbe1xDPZ5rsmrkPdUO8ygFpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dv8hyQKk//hVHioRYzY6XxqtZLvVAdvDawBLDG+1CGk=;
 b=WxY8MkA3lUMnxhIAwYBbXZyDkR/gXlTWiUc9l7bsLO71J0TH2kNn2S1hIT3IVKm+sZiXd/jHikDt1Jo9227Kzv3EndQ23dPHW9sUxoLW58WXedUKJnj/ETN9FyMzBJOfJNPfx7QeyNv52sheyQDiX/Xr5fgRkHXU/1l0oooPqdP9gPkuM0DI50JFfybW3gS9p0ARCOp46ut05SNb0Vkz9v/fOIERfuTcUq+8WdiLG0mrrutcBmABRT79/1ssXdeLYRP8TRCrZ5Z3AuvpSmsK2p3HrQc34MZMQLqFa1qV0U7iVr+lu4JFNF1YcAaXHWAYNwSzYtcqru1JZlWwREx0mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dv8hyQKk//hVHioRYzY6XxqtZLvVAdvDawBLDG+1CGk=;
 b=gMwzCNp6+OA0yB9wl1jLT1JD/U6WNOSRmEfC8KqrzCfH+dhJ3jfW9DbhNz/CsPW4rHCQ10P+fCm2q6g2/SDtZssQCvbXn9Twp0vxrDMVckCVDiizHVJNQ5nvQLoDbWKmLpkqJ4ge6kmwL80wZtQMfOU7xezcNJ4ZIvWzTtCfS7o=
Received: from MW4P223CA0017.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::22)
 by SN1PR12MB2541.namprd12.prod.outlook.com (2603:10b6:802:24::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Mon, 15 Nov
 2021 15:36:56 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::e7) by MW4P223CA0017.outlook.office365.com
 (2603:10b6:303:80::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend
 Transport; Mon, 15 Nov 2021 15:36:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4690.15 via Frontend Transport; Mon, 15 Nov 2021 15:36:55 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 15 Nov
 2021 09:36:54 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH v2] drm/amd/display: Look at firmware version to determine using dmub on dcn21
Date:   Mon, 15 Nov 2021 09:36:55 -0600
Message-ID: <20211115153655.4870-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74080905-e042-4cbd-07fe-08d9a84dc127
X-MS-TrafficTypeDiagnostic: SN1PR12MB2541:
X-Microsoft-Antispam-PRVS: <SN1PR12MB254197A6521F3013F1FED5E1E2989@SN1PR12MB2541.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:635;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H5dpzdWSEdQvNAqFCCQnSJpzAbmREATNfsmPVxZRq7klGEuXb+XJI1nH1BUbPHp+E1ugfLXDW2mGJzHK4B80V5DSw4zvcIemx3Bnfauq8lvdaiELYEK5EUg3X1b2fA8uXUs7g4yJ/fyZtgUGMuL+fhxlC6F6FXvd8ZaMy95ZZO1ySbBDMWAnaUWThx09AXtztfZM16rQwxxIvS06wUdw96G8gu/KO0rap6ZSpo2iDRx+K5Z2seDmxJY0YOmk7ihne4sw5wOQv/IRwnYPd0Kf7y/UEtJRic5Jc3Ds8I+/0IFfCyY03XhVHy8Es1O9qSiWc0nu6KD+Qce52lX5Bugu9DZC2M9oxqN6t2KpCG4eDRiYWSgaLcpJsDppv8BgH8MsQo0Y99Dx5WujesfxXxgMFyd/tCnqy8PWXYS4Eta+UKOSEn+LNqfNM4Om9M97RvbDqkIerIPqpo/flZopEQk95UFLplK3p8B05s7V7BFFAKMmRyd68j2FsnpN31gUqrDfR8Nl4VpjpN8zjrRHJ1rAwyTGWNL1yEmqKITS65K2bruQFIJeYLQ+qsicAcX/fKqLeTmmcIfl1pgRyV8Wgy5uHTZGI6rqF65WkhvADpvuenrQVC27RdvV6GveH6dJHhrYM8gpGrJ2ukwDNDPT2e4cymNNw2G+DChl4Q1JBwp7gMYp8bOkKmeuKtwivokMYolWqLGxcZsJ4rUUyEMfEtU9DC9uTgQlv4skcCaxEtFohy8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(8936002)(7696005)(2906002)(86362001)(426003)(70206006)(336012)(36756003)(26005)(44832011)(4326008)(186003)(16526019)(5660300002)(36860700001)(2616005)(81166007)(8676002)(316002)(54906003)(356005)(82310400003)(83380400001)(508600001)(966005)(47076005)(1076003)(6916009)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 15:36:55.4545
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74080905-e042-4cbd-07fe-08d9a84dc127
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2541
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 91adec9e0709 ("drm/amd/display: Look at firmware version to
determine using dmub on dcn21")

Newer DMUB firmware on Renoir and Green Sardine do not need to disable
dmcu and this actually causes problems with DP-C alt mode for a number of
machines.

Backport the fix from this from hand modified backport because mainline
switched to IP version checking which doesn't exist in linux-stable.

BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1772
BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1735
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
---
Changes from v1->v2:
 * Update commit message syntax for hand modified commit
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

