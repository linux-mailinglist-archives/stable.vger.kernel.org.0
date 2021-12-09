Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4DA46F68C
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 23:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhLIWNy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 17:13:54 -0500
Received: from mail-bn1nam07on2045.outbound.protection.outlook.com ([40.107.212.45]:35463
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233309AbhLIWNx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Dec 2021 17:13:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LtIjn/ilL70P4URgQFLpH3cWzxQNtfp5Zjqfeyv6Zj6l20YBOs2RoPgJSfI81P4FMGmaaJFuK7UJ/b8Jxijr0uG0y+swe0cctB7ajdrNb7EW+qz/8HQ9Sp+gnAyEgeuXKuZjlxJdXB/eXg0vjgUJbfvUGawolKOxVmDrOP7h+hgrq3TV6iQnpjdhxeXzQvK9fpa3tZy3Czu7zOokzz1zC0QdxSKDN9cld8JOx2+Rm85DX7BkSOBNwO9VHxvHXff4vHoG3SMFF8GBoMG/PeCSdiqJpmiiVGrw+rRuPJVNlUxRRTgMlqwnwWaqQyT6Ywj6XbPQZsCq/V8J25H0PI5CaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFTNycloEb8en6iHWWHcZY4BxUNSq4QAfawFE9p5cVw=;
 b=A6p8tjC/DQKo9xTwPiQPUdbm6yGWIVSvTFmxfg2k6E9ardt2hteL6uFmLFewy/3IpZrkv0OiTrCBHaFpFnLnAamE3xkZXyrg7eyDnvlXqwqJ2BgZCbBIk4xj6W19FCM54IYKHyXefkixrTtcgZv2mTSHfj0qfx1ifdG7sV8+gVSOxo7m4AClWu1LppiRj63QLrRI3xjp73oOBEtSy1nEDr+tr3QZ6PU190Y9d7ZyxAhO+pgid8duxVVzXDtEUAEIR5RNOAsVxcK4aiqtSVATbWfvJ/9SLjVnrLmiHvEzAigcXxtwUYFniMOOFPMQRJKYIL6jN4cj4wWjPEJLqjnbxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFTNycloEb8en6iHWWHcZY4BxUNSq4QAfawFE9p5cVw=;
 b=XzOtvclnzaUzGAvgVUJWq198W7TZVAcz0BbnCqWOdFmtdJ56K380T3vF3+5CaXyqiE22eyGKsVOSId+mKCSSdclnXdGGjUQbxCI3DdOTCL4TOJLJKTcm179K+TUlS90vDAv9gh5d9SKr029Gqe9JEGOVoDwGi+0PORAy7AwuqGI=
Received: from DS7PR06CA0044.namprd06.prod.outlook.com (2603:10b6:8:54::20) by
 MWHPR12MB1312.namprd12.prod.outlook.com (2603:10b6:300:11::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.24; Thu, 9 Dec 2021 22:10:17 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::29) by DS7PR06CA0044.outlook.office365.com
 (2603:10b6:8:54::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend
 Transport; Thu, 9 Dec 2021 22:10:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4755.13 via Frontend Transport; Thu, 9 Dec 2021 22:10:16 +0000
Received: from jz-tester.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 9 Dec
 2021 16:10:15 -0600
From:   James Zhu <James.Zhu@amd.com>
To:     <stable@vger.kernel.org>
CC:     <jzhums@gmail.com>, <alexander.deucher@amd.com>,
        <kolAflash@kolahilft.de>, Yifan Zhang <yifan1.zhang@amd.com>,
        youling <youling257@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: [PATCH 6/6] drm/amdkfd: fix boot failure when iommu is disabled in Picasso.
Date:   Thu, 9 Dec 2021 17:09:56 -0500
Message-ID: <20211209220956.3466442-7-James.Zhu@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209220956.3466442-1-James.Zhu@amd.com>
References: <20211209220956.3466442-1-James.Zhu@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7210f378-d16b-4e8f-d81a-08d9bb60ae92
X-MS-TrafficTypeDiagnostic: MWHPR12MB1312:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1312E3803A19FA5D80A2FE7DE4709@MWHPR12MB1312.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:302;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xwp7eHI7HGTUurpu1oJEstP9qpaMfyl0/I+ig8fgLbQ56Tlh6Q1kxwIBO21NLHhdo2cqltbjDa3eztMzLMgqarLVkwCviGXfw9iBKoBQU9MkRwUWhFNhCL3GAJaSX6w54/fO1RarOecdNCj53WTTbioHMOciiN+m38oVFGnHrvQK+Hc714HL0bd7o3dO9cGSdiGH54nhQPk/9+dSzJumF327zVE61M7gEUqzhMaYobkdVUjgRmY099OTaihQMGNsUZMwbd3JWSV56tmpcVPRMDernHM2IpBnEhVb0Fa3aqSqOdLI9IzTolBuJDs75GOGhMcEAQRY4cLpTkKC6BoZMxIb8h3AjI6UuAWSTVbfav8vzLt+qKlZ7mW0EwbhVsrLzRgEuTLR5Mn38aOb4sfHTAoq9nugLrGXpkoBkhDgZnBB4TeCjJQqn12t6Hh9kxxc8mgRiwLrgRmwtHBXngcjsYSRx9SEwvLwaoJNi99pdJBYTCOgrIFEoY6TmkXt1tugPADTF/3gr1pLN4UBAQX6d+b7tOqiM0Nwc55rxty6qQJFwt54kiDi5OI+AlAcvgomS3H+ttNc2y7Fqf/wCqB+k4S8RY19wKTk8JoLZ9tv4YRK0kQ9R4PKY7nYwQ3HIccpcf0qu/DDPsh1yKIlZaDideNzoIl/S+0QTnXcxfIlBDdd0CifBmfqTRphZnuljv6agK6+uoO6Znp4OsEcyPlunCnGGA34BTvqC51WOrx2VmlURzM9Y/5Tkt4Cw5tuU0kQsNRrQO7rYBx2eJqIcqyr+2eycrjWbKs1aUgBtbf/SnE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(2616005)(83380400001)(1076003)(2906002)(40460700001)(508600001)(8936002)(426003)(86362001)(36860700001)(5660300002)(6666004)(36756003)(336012)(316002)(4326008)(186003)(26005)(54906003)(47076005)(70206006)(6916009)(70586007)(8676002)(7696005)(81166007)(82310400004)(16526019)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 22:10:16.8655
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7210f378-d16b-4e8f-d81a-08d9bb60ae92
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1312
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
Signed-off-by: James Zhu <James.Zhu@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ----
 drivers/gpu/drm/amd/amdkfd/kfd_device.c    | 3 +++
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 488e574f5da1..f262c4e7a48a 100644
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
index 1204dae85797..b35f0af71f00 100644
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
2.25.1

