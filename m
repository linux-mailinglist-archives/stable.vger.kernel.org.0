Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E68467C84
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 18:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353312AbhLCRbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 12:31:13 -0500
Received: from mail-bn8nam11on2068.outbound.protection.outlook.com ([40.107.236.68]:7092
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245736AbhLCRbN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Dec 2021 12:31:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nhcOk8A4rT3VKeeK/x1AV0l7NfeZwFDVbJCM1w0pxP1RSeQl/SsFWRJM4if9bvsVwjnt4q9p0KrSPfHk7FKOQbhY1ljEBrN5uDFyLknRE7yLiDQPwGYBQaWAIWUrr1N2m3Ld3c0/WzhYKE6KrjxI93258m7YUrlAcxPcrR4FIh+kDZWswhauyrn+2Dk5g1wlM9loHzW297fQ2KJREu5mgKCSf5BVSZM/ZDvxIfsIs5CjILYktAvEaYKkn+bvu405nFMeGgHzpgtLWtuIOXd4FZYX0yDy2yCNZbO3Nn/3JIGzfjRupv/+pUqitv+U9LbhE2zy7fPZJq/h5hxY/12NPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7dNUWoclLZKSQ6yyYYvVu/EfTEg2Q7q1RAPDJZ/+Cds=;
 b=QcoqtqhJx1xYVE+Kl7qb/mH4EGXxa5zrmaUneIfsKSFN7B9w65PBDWi57Z1R+eVnGWsaqF8uahY9RSrChCzixIilWlOixymCkIU2PvthN62pgCWGoqV/yx8XUBnoz+2BeHSA5ZFfuRiytSnVjZzxlswt1V4qHIwUTvlHMKm1NnUFldC2pQNIhTgq0WMDaKQNs/+FVVVsAZUt49YeGQdNSuquh0kzNqthkJoDJ3fCTxE/FuDrmpFIwivnhTqmiCqv3gCWtrleJYYzTjLtY6V9GlSiMUYUMEqy6Bu5NSelI5j1Hd+7+UpHG4ipCRNOQWDUXYWizL96mmVDK6ZMbQ2wUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7dNUWoclLZKSQ6yyYYvVu/EfTEg2Q7q1RAPDJZ/+Cds=;
 b=PT6j2HYUuguTzeURfw39VNVcHzbLogUV4hUp5OGmOb/8JMBym3qb7fDSVZdgh3LcdMBD8V3iwsKNzIsNwJMoo0zHKcG63HRpKcSRVM7EzrECOHv07lnHWBTiCznlSYxCDxES1c9LQ2hgA1KonKIjFXvu+BdNCM9BRkVRXTM+RlI=
Received: from DM5PR11CA0010.namprd11.prod.outlook.com (2603:10b6:3:115::20)
 by BY5PR12MB4901.namprd12.prod.outlook.com (2603:10b6:a03:1c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Fri, 3 Dec
 2021 17:27:46 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:115:cafe::50) by DM5PR11CA0010.outlook.office365.com
 (2603:10b6:3:115::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend
 Transport; Fri, 3 Dec 2021 17:27:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4755.13 via Frontend Transport; Fri, 3 Dec 2021 17:27:45 +0000
Received: from work_495456.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 3 Dec
 2021 11:27:42 -0600
From:   James Zhu <James.Zhu@amd.com>
To:     <stable@vger.kernel.org>
CC:     <jzhums@gmail.com>, <alexander.deucher@amd.com>,
        <kolAflash@kolahilft.de>, Yifan Zhang <yifan1.zhang@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5/5] drm/amdkfd: fix boot failure when iommu is disabled in Picasso.
Date:   Fri, 3 Dec 2021 12:27:32 -0500
Message-ID: <1638552452-4198-6-git-send-email-James.Zhu@amd.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1638552452-4198-1-git-send-email-James.Zhu@amd.com>
References: <1638552452-4198-1-git-send-email-James.Zhu@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ad9e4ad-e887-40ea-bf57-08d9b6823884
X-MS-TrafficTypeDiagnostic: BY5PR12MB4901:
X-Microsoft-Antispam-PRVS: <BY5PR12MB49015FE2D94D6B4E0B75B6FAE46A9@BY5PR12MB4901.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:302;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zztUfnSr5Jm2W17yirPwXb9gaLdzZFNUq1BpeKU8yEcn1z/SAzy+LjrGM4Azrbs8FNhBa0/piOn9TitAkxVcFIfbp+zwD5T3O/D5P/j9ihofiD42xR95ftECHKgsCCAd06LELo1UV5Cj5GYLc+e5zsV0RzfoGOWFREAYYkgLsnr/Pl9h0Q+v7e2fSgceWZXUIdMcy2vdPiR0BPT0Zh77ra4Ux2fpM0sb9e6qkzjcYpa8kUE/SOerrw1gxHeiccMyd/bUTJ44r85aEcYz0DgOxIoFxqHhn5TTln5+ZsTjaIxyyEdVyRSUwzcKNBy3J7DoSfye02iBdsDr8Tvs6dVFIGFuKYTYge2o4mcG9VPtOQM+GesX/H65xeDu4qP9UdXLTli0ZeLBLgsO0pAebtybNZOJGI1xqvLOZW5yfIW8yfMb8PboAKI4E7E79X3Je+nB3glF/SWv85nZey4FF5gos+aGgo3WR8z8JQ5fSM6yksz0d4iYBnrDs2miXoqHzb0cw/2MacuK+W/6lsItFREwk7I/9xnaInc31w9APdKKGd9oG56Gk+pj1BnBbdSJoFKa2YHwkIt/4fjbpCOpYwJFZPX0NVfTk3lksHIBSpmRxDdYqatNIOd1AHg4ewXf/8f6LAyMaE8SFMiQumLophw9VhC7McwMNQhS2JtK0z2q42tb0EwnjmeElPuxU6UXbMDC2GZpqq+T8avY9xJ1ST00IrIoeGMA/765GJ7j5s9/93bYgSMyS0BIsSIpOqQ8arKuwL+06bl+4xKWsgIKsf+NFQs5DgIVHn8Vv7Dx8rmsQgQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(2906002)(2616005)(426003)(336012)(8676002)(6666004)(40460700001)(8936002)(36860700001)(36756003)(5660300002)(26005)(81166007)(54906003)(508600001)(356005)(186003)(47076005)(70206006)(6916009)(7696005)(82310400004)(4326008)(83380400001)(86362001)(70586007)(316002)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 17:27:45.8769
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ad9e4ad-e887-40ea-bf57-08d9b6823884
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4901
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifan Zhang <yifan1.zhang@amd.com>

commit afd18180c07026f94a80ff024acef5f4159084a4 upstream.

When IOMMU disabled in sbios and kfd in iommuv2 path, iommuv2
init will fail. But this failure should not block amdgpu driver init.

Reported-by: youling <youling257@gmail.com>
Tested-by: youling <youling257@gmail.com>
Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ----
 drivers/gpu/drm/amd/amdkfd/kfd_device.c    | 3 +++
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 488e574..f262c4e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2255,10 +2255,6 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 		amdgpu_xgmi_add_device(adev);
 	amdgpu_amdkfd_device_init(adev);
 
-	r = amdgpu_amdkfd_resume_iommu(adev);
-	if (r)
-		goto init_failed;
-
 	amdgpu_fru_get_product_info(adev);
 
 init_failed:
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 1204dae..b35f0af 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -751,6 +751,9 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 
 	kfd_cwsr_init(kfd);
 
+	if (kgd2kfd_resume_iommu(kfd))
+		goto device_iommu_error;
+
 	if (kfd_resume(kfd))
 		goto kfd_resume_error;
 
-- 
2.7.4

