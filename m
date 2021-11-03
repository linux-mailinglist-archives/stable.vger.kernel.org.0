Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020D44443EF
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 15:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhKCO4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 10:56:05 -0400
Received: from mail-dm6nam10on2061.outbound.protection.outlook.com ([40.107.93.61]:63809
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231378AbhKCO4E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 10:56:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/gXoDum3dI+KKhS0NhA6pzqOS4XYuWnVHTj0u2kvLaLakzuyZqR1na5kdcmUn0jaXx62uTWcGQ7NORkDxC86EJtyCj2Up9y0uDXsU1c4tgB4LnF1u466YtL7NM1dK2HQvMmKf8CBE+sin5mLoqoWrL1U+aUdhobmfwqVpsbk6tR/JIJZM5N5mRgzxl6sFKhY2vySWPV9Jo8uDraj/zk2DFyBmhVskjqUEn7X5R4RrA9qypinMrZ12EFWE3dPNNUZtU34jz+BgCO9OREAsyoTR4knjTK0i6InyRsaLPUdvHgLrRkTonLW+PN7U/LJL1bZ6JcV3l5ORjFaTQco8w38Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oPucs1nPihHSdvFr0lotJXZIdhJrj45sNshZTowWXAo=;
 b=WEOflvS2KegmcNW8dZGnVzlMTCDrnuTGhujTCGAIEahKrurdekURXcZOQA4a4+ThwL193URttDrO+KqZuHV7ZW/WEqZQA8iMR3LwRzwNR/E2sQhVWMhOybrOezlGgJCpGVtbGeLSFgZi9knLMwZw4ajFUCSEQNY6rAynUfnpSXXkgbvECGZnBMs59QzCqKxyAJt5sM07H3YewDzIjzPE6acsX/M6ezBXcU+1LTm4hyQj59MHMawV7VF2lppcX13nYsZqkIqO73327aOF7/jjJ5hBV6ABgQjHVIabVbd1VFSPtvM/cdI2ZIrGds7KFj29AiZJQGJD6QDG4Dot1yVyuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPucs1nPihHSdvFr0lotJXZIdhJrj45sNshZTowWXAo=;
 b=WHvnQ+6VHVeMu36jQdZfyCElBkZ4fug+Q+Sc5RNOJpGiiVLDsplhWCPqPpr2Op5a4WxZ9f520U0diVu5nbT2zlrwSX34728PPwOMzY0muj6UIjdvi5klc5pmIJaM85XYF91c/rkXAl+gTkwAcmFDMQQVNZ5To9gvjFikhz3TJ3I=
Received: from MWHPR10CA0024.namprd10.prod.outlook.com (2603:10b6:301::34) by
 CY4PR12MB1144.namprd12.prod.outlook.com (2603:10b6:903:3f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.10; Wed, 3 Nov 2021 14:53:24 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:0:cafe::dd) by MWHPR10CA0024.outlook.office365.com
 (2603:10b6:301::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend
 Transport; Wed, 3 Nov 2021 14:53:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4669.10 via Frontend Transport; Wed, 3 Nov 2021 14:53:23 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Wed, 3 Nov
 2021 09:53:22 -0500
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <stable@vger.kernel.org>
CC:     Yifan Zhang <yifan1.zhang@amd.com>, youling <youling257@gmail.com>,
        "James Zhu" <James.Zhu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH] drm/amdkfd: fix boot failure when iommu is disabled in Picasso.
Date:   Wed, 3 Nov 2021 10:52:56 -0400
Message-ID: <20211103145256.1359520-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9940b101-5f71-4a99-efe7-08d99ed9afae
X-MS-TrafficTypeDiagnostic: CY4PR12MB1144:
X-Microsoft-Antispam-PRVS: <CY4PR12MB11448D41EA62B186B609825BF78C9@CY4PR12MB1144.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:345;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +OBam5M/N+ISjsfitXP5ZaM2RTEh43wxcv4XunRjfGzRv/6bVlVZL1Jm1i2gn59oxdIMlRo6N3nWPpGf8W4WvSW8M3Uid7UnMsKtiiXxlt4ycIRu78mRYnOjsf6e/CtiO6rjt1tzwRGn4WWs6sGA0PasflESA6v7nV+63LOd6zgpRkbSovyGKLBd94tBBICQw6qnO1GG/bTTMcC8Lv7RPFQlUwBAND3FU3n3g/Lq/rDASTbgu7WsadavbXtZQQZgAEPvtYTPsToiLpHg4BHLnSOjddWNc+WKObI1aOnK5i+IPH/XhE5dGF5UiZNcbkNInxBfoOhURnA5kp+X3AWWGAlk9/FJv7u8DhOnPRbwvhhWSe6K5I+dqWdXYT78LRbnqzTcazpsrkiejoWbSS7ygOifiT4xipvXnxVItF3HVDUP1EWOFWoCG6IK2yBJuAABUmAHrRAD+Jdqw2noHNWUvSf3xNyqx+LCKZzo0UiRlqn7RnwOUfXzZeo25Rx1evpo247ypMCOtb05oui1qcA+wQlq5lYoHb3l1q2+BxeGB/bFxF0Wg3M1jo+vii0nHVWw6qKtp6xaFg8tB9kvUmFAtMZ1Cd7ZBhByWlnSsYabAQkJIrK2vEXxUqIP0lh84TvWGeaZln8fRhjUuWlchRxhKIbnPibMPGYuesXVIZ1udrEJ9yReMrwcelBk26PHopN3KGDfQdIDM1fzDYaioO/64cdR9512p17yOlP2jI7Yfvptw6R2ScW/xVxuicf2vc5fMW+mRycH1gY02pQGZo9EUfa9BfgBKLxGLZRxgF5gX/cQSrZj7Hj3/7puaroeDcA/
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8676002)(5660300002)(8936002)(26005)(86362001)(70206006)(1076003)(82310400003)(70586007)(83380400001)(186003)(966005)(7696005)(16526019)(6916009)(4326008)(54906003)(81166007)(36756003)(508600001)(6666004)(356005)(426003)(336012)(36860700001)(316002)(2616005)(47076005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 14:53:23.8857
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9940b101-5f71-4a99-efe7-08d99ed9afae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1144
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifan Zhang <yifan1.zhang@amd.com>

When IOMMU disabled in sbios and kfd in iommuv2 path, iommuv2
init will fail. But this failure should not block amdgpu driver init.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=214859
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1770
Reported-by: youling <youling257@gmail.com>
Tested-by: youling <youling257@gmail.com>
Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit afd18180c07026f94a80ff024acef5f4159084a4)
Cc: stable@vger.kernel.org # 5.14.x
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ----
 drivers/gpu/drm/amd/amdkfd/kfd_device.c    | 3 +++
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index cd8cc7d31b49..b0824d2f0e0b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2380,10 +2380,6 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 	if (!adev->gmc.xgmi.pending_reset)
 		amdgpu_amdkfd_device_init(adev);
 
-	r = amdgpu_amdkfd_resume_iommu(adev);
-	if (r)
-		goto init_failed;
-
 	amdgpu_fru_get_product_info(adev);
 
 init_failed:
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 5ba8a4f35344..ef64fb8f1bbf 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -875,6 +875,9 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 
 	svm_migrate_init((struct amdgpu_device *)kfd->kgd);
 
+	if(kgd2kfd_resume_iommu(kfd))
+		goto device_iommu_error;
+
 	if (kfd_resume(kfd))
 		goto kfd_resume_error;
 
-- 
2.31.1

