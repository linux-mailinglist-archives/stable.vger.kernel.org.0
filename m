Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F948467C81
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 18:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352986AbhLCRbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 12:31:09 -0500
Received: from mail-dm6nam10on2073.outbound.protection.outlook.com ([40.107.93.73]:29170
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245736AbhLCRbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Dec 2021 12:31:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hy0wdGpcb2UYVZnEX+YQ2pEildoXSkHpF36lRajhCHjeQ1/RyIFpDRCXXrtddl3P/6MVohVnm3XbizxaNS9EUtbxQJt+1O7LrMgpFs02/UAxiCdnMaxQQXBjOBVPIUjVUqLftLHj/pjkA1jUUEE80534Y3eBZy9DTwcfy2E6sP1jaHp+XXKY49WEuk2ZdjiBURAAnl/4a6mvtc11JBf03debdasLNgO0U5wAICAsusvukh7QtuFKHINrBFJRBKstiaogY52WrClRluE4G0NnzDVClsRyNRQwh1y5GQZ3Du7Ofp+dj+wty3xzZ5z/yKNmKmpquwGAS9/qK4GIdD9cfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ANsZij44C7/Fy1zls4fh3xROtLTRYn7ylEGDikfaK1w=;
 b=PfHBBXbk3urEa72V5T8NT3Pcs5z4CVTz13xpwkGJc070zrYKTKemu673i7lcOfPaJ17UnU2qOOl/djChyHl8cC92Wk0i36DjQaWkujOi2+PSnhpcA5R9mTDLqbqtoaRWZ6iHrSWlgwdnOJJHVvFBYqEwandc3O74uQsQZl5ablYvefaeLWS3KCFOC1hV8iQwzOif6MDP6fL1NeJwiqGikQPGQhSNQ61gi0TU2Efqr4hQUOmhbrrFKqEszt0f+WAeIfe+/sZuA0R5RxKkMBvxeU4hkbJHvJkZHflqEjfIBQohmPtWhbrXxcUBFPcK0uV78MT81oKrl+CKPQqhATp/GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANsZij44C7/Fy1zls4fh3xROtLTRYn7ylEGDikfaK1w=;
 b=D1pUO1RE2Xt8zwpLI9WVeki1kNsP6+yAIwE/1Bg6nxMedE5WvnRRr44/XKixOG1DW3nrWvpk0QDoTMp1SJHZ6FNsRFL5u1TW+cHsk3damcvPTu4tzPzm1woz4dB04EYBfIobCTPE42r9bbce61dfpSCYFqqsujnTQRjdIdSibEs=
Received: from DM5PR11CA0007.namprd11.prod.outlook.com (2603:10b6:3:115::17)
 by BYAPR12MB2741.namprd12.prod.outlook.com (2603:10b6:a03:62::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.19; Fri, 3 Dec
 2021 17:27:42 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:115:cafe::da) by DM5PR11CA0007.outlook.office365.com
 (2603:10b6:3:115::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend
 Transport; Fri, 3 Dec 2021 17:27:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4755.13 via Frontend Transport; Fri, 3 Dec 2021 17:27:41 +0000
Received: from work_495456.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 3 Dec
 2021 11:27:40 -0600
From:   James Zhu <James.Zhu@amd.com>
To:     <stable@vger.kernel.org>
CC:     <jzhums@gmail.com>, <alexander.deucher@amd.com>,
        <kolAflash@kolahilft.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/5] drm/amdkfd: separate kfd_iommu_resume from kfd_resume
Date:   Fri, 3 Dec 2021 12:27:28 -0500
Message-ID: <1638552452-4198-2-git-send-email-James.Zhu@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6b19a671-f246-44bf-5d14-08d9b682362e
X-MS-TrafficTypeDiagnostic: BYAPR12MB2741:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2741EC50E84364C0DE523F19E46A9@BYAPR12MB2741.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:233;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SOdEcyoEwJmSYsdfrDfBL2YxUfLYddPvyniwbEZF9Uab9tJJIscU4i7bXx8/X3Kb0YolhLmNre30RvtC4bQOdDsArlpizUN29tcWRx3BozSmI+C0Cmyqs+qs0JBUGSSFpv5HQ2hYbI2ay8fZdTlP1a2gLQ0fJdIVDZJqf6xTae2MZ72WkeAkt21o0KNqK4sfS4kCPPRBhkg3MnKhlWYlfI3xSt5eJzKmM6SlSNeELb3HKPb2up2dZWuIJPOdESz5IvCoh1rhrCAfi65uFopaYSBTnxEir/mSnmZ/oA60RxXZCKQaqzE+lLmSSHA/sGK64jikuxsLaCNfcuIvT4/egwAWkjQlst79lXqmMbG4C4TaHB6PKpeaURQtjM6Jr4owuTj+SuS+8mVrG+ec7IJe01gKA86CTMKW6ySJRTN95hv3RUGs7j5lt/RAktLGRCWYK2ZHwp3i0JWy9CegNJDnA+EtacuKS186Tkqkj61u3qGcGMRt5pDjNYDfU2Mqxy7IDooNsMtz3LhR7/ajGmZM6nv+NtFJ99kfPvzIPIQgnPpIe0gDn+AVLWgnntBbKlQJJRtFvXFDu3vZQNPLfys2D9cAD5wUFGxB7WUqTB5QnsnweGYAMwPuSH0IkiRN4w10CRIjx+9gQkbMSkkrWMzJBd8jtoc+0Y0nZNpAZ3ky1GWMcjzjUnAyRMNKNXVkw26GT52oUFPmwop/lPSCczz1phRzN0MY/Ioe5fyKFDhuxC5FJAOYuE+b+7QWInRgfNVYksZnRmo/7wZYzHZxibp8ksSK5hpWmEk8GXntwOrKfegMX4AlbqJQ7bYer49iKnYBIykW+27NuFWHE6PFgHEmelVKW41mpUdYH0kC0rL8iV7ZLu2SIkZNRi3VTI1jZsyN
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(26005)(83380400001)(36756003)(426003)(186003)(4326008)(82310400004)(356005)(81166007)(40460700001)(36860700001)(2906002)(5660300002)(6916009)(70206006)(966005)(54906003)(70586007)(7696005)(316002)(8936002)(16526019)(86362001)(336012)(8676002)(47076005)(508600001)(2616005)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 17:27:41.9554
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b19a671-f246-44bf-5d14-08d9b682362e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2741
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fefc01f042f44ede373ee66773b8238dd8fdcb55 upstream.

Separate kfd_iommu_resume from kfd_resume for fine-tuning
of amdgpu device init/resume/reset/recovery sequence.

v2: squash in fix for !CONFIG_HSA_AMD

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211277
Signed-off-by: James Zhu <James.Zhu@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |  1 +
 drivers/gpu/drm/amd/amdkfd/kfd_device.c    | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index ea391ca..7f78bcf 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -262,6 +262,7 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 			 const struct kgd2kfd_shared_resources *gpu_resources);
 void kgd2kfd_device_exit(struct kfd_dev *kfd);
 void kgd2kfd_suspend(struct kfd_dev *kfd, bool run_pm);
+int kgd2kfd_resume_iommu(struct kfd_dev *kfd);
 int kgd2kfd_resume(struct kfd_dev *kfd, bool run_pm);
 int kgd2kfd_pre_reset(struct kfd_dev *kfd);
 int kgd2kfd_post_reset(struct kfd_dev *kfd);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 5751bdd..1204dae 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -896,17 +896,21 @@ int kgd2kfd_resume(struct kfd_dev *kfd, bool run_pm)
 	return ret;
 }
 
-static int kfd_resume(struct kfd_dev *kfd)
+int kgd2kfd_resume_iommu(struct kfd_dev *kfd)
 {
 	int err = 0;
 
 	err = kfd_iommu_resume(kfd);
-	if (err) {
+	if (err)
 		dev_err(kfd_device,
 			"Failed to resume IOMMU for device %x:%x\n",
 			kfd->pdev->vendor, kfd->pdev->device);
-		return err;
-	}
+	return err;
+}
+
+static int kfd_resume(struct kfd_dev *kfd)
+{
+	int err = 0;
 
 	err = kfd->dqm->ops.start(kfd->dqm);
 	if (err) {
-- 
2.7.4

