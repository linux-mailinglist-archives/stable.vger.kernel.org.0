Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC8C45CBB8
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 19:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242895AbhKXSEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 13:04:49 -0500
Received: from mail-bn7nam10on2087.outbound.protection.outlook.com ([40.107.92.87]:58465
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242911AbhKXSEs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 13:04:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZuZUtVGtYuIRO/sIG0AcR7W6XioW9OyTOG+DNqu1U6ehdl9vQQI6+Cwl7q2VGY2BaVc6sMTK/BADTHpFFvnOaDyQmau+PExCtVqHBLugtrKH6ChgH6DO/gNNSoH+S6bZ89pWSJ6KYXEjhaGMVGiK6+yxTF5PycKnYUreDTPZSZlMwdG55zGMq420Ysd74jh1vPhOe0DhAntszCBXJadOujQaOaR24o7S3SfL0kTar4VXvJ96kKNm1RU/eZWo5E/UIuamLbV8kCHffLuXY5FcBWaac3KvHcZxRJznZGnDR4ftb/ASLfVLNylq85V4kxRnMz2+Vd17qTRzWtGBlEaKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KoTnJujxs618VJZtHG0+xguvBdxQVKQsiSTHvdv32HI=;
 b=R38d7p4TW16rcpLo89ZAUaKZciwR5rmLZO5QcmbLaHg/yKx6ddKHs69mDHZ5L9y41V7qkEh06SvUJLZQTtlOZtf2J86y3AIhGvGqklEgv9vHhj9WqVvYvxGNJjowk0Mbx6PZO9jYPtJiuFH/1sy3botcdkSUDXmbY/78BQeKxY1oEnqC++JuhqxygGG4giKRgN1Y5z28NOa3uO7yEX2JV8yn+ZdWdPq9tjY1i5xAuiDecEr4+CkHt2rSK/F9An/V+xYPxH9bbgzHI1xT+c9jjXL9WanniEly9PhyvtgI1VnFOT1s23Y7eUs4/5w7JZrOrQp8HiTr82RMZDvyJnk5Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KoTnJujxs618VJZtHG0+xguvBdxQVKQsiSTHvdv32HI=;
 b=QSjOphtdV6H98sBEQEqsIuTAG7+oOc0d0Nn3ttZ15wbVsF2zl47WEZ16pxQK9fqiW+R6xYidA9qEVoPUrPJ+Z+FHZm/Qs2ZV9u/Izvum415VmUXewbjUzuxkTmNIHtUJ8qM2egj+QS9tMqCZNoOKFqX7v2PBWfm8iUgTy5PaKfI=
Received: from DS7P222CA0012.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::15) by
 BY5PR12MB4260.namprd12.prod.outlook.com (2603:10b6:a03:206::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 24 Nov
 2021 18:01:37 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2e:cafe::e0) by DS7P222CA0012.outlook.office365.com
 (2603:10b6:8:2e::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend
 Transport; Wed, 24 Nov 2021 18:01:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4713.20 via Frontend Transport; Wed, 24 Nov 2021 18:01:36 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Wed, 24 Nov
 2021 12:01:35 -0600
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <stable@vger.kernel.org>
CC:     Roman Li <Roman.Li@amd.com>,
        =?UTF-8?q?Samuel=20=C4=8Cavoj?= <samuel@cavoj.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jasdeep Dhillon <Jasdeep.Dhillon@amd.com>
Subject: [PATCH] drm/amd/display: Fix OLED brightness control on eDP
Date:   Wed, 24 Nov 2021 13:01:22 -0500
Message-ID: <20211124180122.2736457-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8b2d740-bd5e-4c15-333c-08d9af74753d
X-MS-TrafficTypeDiagnostic: BY5PR12MB4260:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4260A9C591CA0F90C4F6FC63F7619@BY5PR12MB4260.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:318;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KaY0VO2CCntMlW+/Nywxs80Vq+Z5N8opXGjHQ3oEOqF/mB5KYMFROLw/uWTJEGxsUi/AiPGBs+J5UrqNv+p+pUP1KeFWAXfuQisf+wb/5wUXevvttCUIka+EgbxttQ8uM8d5K3n9mUD0EpZYYiymz/0heIkIC5i3kQrcwAiT+qqjBWjvREO1LXMupdebiw0MfXmQdc8XK8jVrfPTIDDDG1rWDZtDp0YHUv1bhohar6gXxiAyYv0Tnzl1phllEuya1b/9xFxwgVnjg2IHUMbYZSQtN5lkfJHNyNtUzpVxE6e7GIQX3oWU1iWE/+hvZwGFbu873TydKMg6hqf66MBpCdZ6qgsI8T+kCmMKC++AsqTPXC52NfQmXGGLMBPDMNlqPfA4hwdwf14ZkimNzxyECo9jh4Bicho1CIIiI1GCdXweICuPwuJh6AReBXKMYeC87+KhHyudz7o2kne4urCOpgAUqC1ETFtyBDdYQfS8rvXuHG84OnAElwnXLUDVNCOsBGjFxHBQKHPdAHNlHWIHdblCswzanqwg5KirJV2BIUD4qwUYqYvhT+4P1O+s/k064g10eLu3ruBHmwQADBGf1ZfFTnHpwS79PKRvK9geIKKmEWzZqWQa7SUBG0bRuoBIyKr/7p6BbHDN7Ff3nnfLw2s+yywzoM9U4WK3F75gvXXNM4k0NdTEJ63eiHDnAI4gPDpswJJXtc+IrNfymFVI7V/51zzHSqxxtzX7NM99ZRpgpmHNsZ3Aw57NEg+iZIJdicYSsUj6p5ICdyhFU5sXMClWWC1FRvPv14tK5pGh6ukYnqY0+khImv2Wawyn+vyX
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(186003)(86362001)(47076005)(2906002)(66574015)(336012)(2616005)(54906003)(83380400001)(36756003)(316002)(70206006)(36860700001)(81166007)(82310400004)(4326008)(16526019)(426003)(508600001)(356005)(5660300002)(966005)(7696005)(8936002)(8676002)(1076003)(6916009)(6666004)(26005)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 18:01:36.6848
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b2d740-bd5e-4c15-333c-08d9af74753d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4260
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <Roman.Li@amd.com>

[Why]
After commit ("drm/amdgpu/display: add support for multiple backlights")
number of eDPs is defined while registering backlight device.
However the panel's extended caps get updated once before register call.
That leads to regression with extended caps like oled brightness control.

[How]
Update connector ext caps after register_backlight_device

Fixes: 7fd13baeb7a3a4 ("drm/amdgpu/display: add support for multiple backlights")
Link: https://www.reddit.com/r/AMDLaptops/comments/qst0fm/after_updating_to_linux_515_my_brightness/

Signed-off-by: Roman Li <Roman.Li@amd.com>
Tested-by: Samuel Čavoj <samuel@cavoj.net>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Jasdeep Dhillon <Jasdeep.Dhillon@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
(cherry picked from commit dab60582685aabdae2d4ff7ce716456bd0dc7a0f)
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 1ea31dcc7a8b..a70c57e73cce 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3839,6 +3839,9 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 		} else if (dc_link_detect(link, DETECT_REASON_BOOT)) {
 			amdgpu_dm_update_connector_after_detect(aconnector);
 			register_backlight_device(dm, link);
+
+			if (dm->num_of_edps)
+				update_connector_ext_caps(aconnector);
 			if (amdgpu_dc_feature_mask & DC_PSR_MASK)
 				amdgpu_dm_set_psr_caps(link);
 		}
-- 
2.31.1

