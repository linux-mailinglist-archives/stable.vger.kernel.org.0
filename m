Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837EE46F68B
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 23:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbhLIWNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 17:13:53 -0500
Received: from mail-dm6nam10on2068.outbound.protection.outlook.com ([40.107.93.68]:46880
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233309AbhLIWNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Dec 2021 17:13:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ms9S7KTF+sBiT7fhxqsjFcGPRskLXthvKljw0mFDP6ImV/MUnp7Da/XaZRMOD9d6YMy7mOAOaDE85qG6HMW3nwiHDByPWqnR4dlGDKuBOBAzfvej4UKDGP0CL79aIKMsPlW0OlvP3SvcOxDJZrA9Ia2PkiQs8DTvKr78eTXbinQMCqy6qMcq07IofTCZBdVADHIC0MLMJCEkdZFqrD46jz5i9mAfgeO85UcGPeyvzXXopmPNo/IT8r/lXRbM6hktZZpE30tbNQTUdqDdZxTnUEcEAIzMnAbW7S9pR2+KshDCipk3nQ/j3dvAEOrV4z3oJIQx71++QUWDSEkxarg7Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VBr94AIweTai0pQ5RuPdqqYUfwK69cuu/bni5Y6csBQ=;
 b=hZnoixezXGXQgwaWxZ57LCwt+c1WVQmR9yNJVB36go8I+8aT9nGpcpaDS3rnNqJy4jbeeN1jxOpK2DbDfA7NPMu55bdHNo2gb7AIkY7Qsmkrv83XNEh4wEYxwU1iENmyWENHefPpeD2lULCfl0P8Njnr53jDB7zE67VjgPDg2Z0q0wxXL03hJFZtI2YyvBpod9g0WE542Q70htytrkaYqjHhx1XRUCPl9eNJ7wRtwbejtYobnxsfTo0mwgXZZL9WfTlybNUw45CBZGR3fAaRlYkHRb0IMfLV1Xj1Zqry2a81+oSHkWmUGMTi/iBeH2MZM0Ma2CKCAADlOoRxz72OBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBr94AIweTai0pQ5RuPdqqYUfwK69cuu/bni5Y6csBQ=;
 b=0kPkHIetkvv9ZSECnxtzVVKC8RbL+D7K7PPKwREeO4la3mcL6DADpD4ZqmFLtJPr/WWzwGVM+IOM2N9zk6fJ2Co1MQN3indcRzp/Uim0KVrxaE+xZj6DpM+iPG28QWDr4pqoCngqaa75BE5a8mgWolLPd05NlG9r/KPn4Ckenv4=
Received: from DM5PR06CA0050.namprd06.prod.outlook.com (2603:10b6:3:37::12) by
 BYAPR12MB3222.namprd12.prod.outlook.com (2603:10b6:a03:12c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 22:10:13 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:37:cafe::dc) by DM5PR06CA0050.outlook.office365.com
 (2603:10b6:3:37::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12 via Frontend
 Transport; Thu, 9 Dec 2021 22:10:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4755.13 via Frontend Transport; Thu, 9 Dec 2021 22:10:13 +0000
Received: from jz-tester.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 9 Dec
 2021 16:10:11 -0600
From:   James Zhu <James.Zhu@amd.com>
To:     <stable@vger.kernel.org>
CC:     <jzhums@gmail.com>, <alexander.deucher@amd.com>,
        <kolAflash@kolahilft.de>, Felix Kuehling <Felix.Kuehling@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/6] drm/amdkfd: separate kfd_iommu_resume from kfd_resume
Date:   Thu, 9 Dec 2021 17:09:52 -0500
Message-ID: <20211209220956.3466442-3-James.Zhu@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: dfcf17cb-cd8e-4172-53f8-08d9bb60ac84
X-MS-TrafficTypeDiagnostic: BYAPR12MB3222:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB322295B804FBB6A3555BE5C9E4709@BYAPR12MB3222.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:233;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IxN/Aipb7a8eulGEg34S+ktp8uFA53Hs83yykHIYIN6+ccYw7lTOCU7qjH1iBOuk/WmOWjt10HBzfd9tfFtdBSRaVID8clGW9QLfmsqFGqEia25tPSpCETC4pqaPRxSHOmYIDTtoiRguyFCZ9oSgxNIKscboV18kTT+YYbg24R1eFcKC7ZOwUly9s4dKbRq6HTQ2liACMNH39W42tK385ru3suSVSHddZW0gb445bzIKZQJxQpnYSqxED0J5YRgIaMRU7xK2qeaQurtz1JIC6doVp4uQ7g2qPuVTOEFN3QGee2FCOJofACqaNY0Hi0X/SZwB43bD+4x69JHvxqXBFl41xHpmLRtVued7mp9HcdyvejlL3bPSmhUsFIYH863mAh7vR+eP563zKfLPcpdSmjEBXaEiCFgdVDlDttiXoHUQfRWSrZC0mtSeyBHLjRtX/pwCCbpdlnIsHllKsUmm/Qox77D+Qd6k4hpJBnWKqIDLeQTbczMQvhU72HhCQwGGmTE8Ym98OTBJfeEXx0O4BIUKo49xmHRe83Z2oVInOAYM0NeDdAPuvObyW9TD0i01BjQzBR4+7qj+hGVpIi0ipgKOu9U+TSQP2AxU+/Jyw6mRkx/eKTYpao7kT9zvEXHjvcYxffOi3r6JzxFtW9LQqCiGvjlNnPjjafNW4K+3G7xeMvGRJ3RdLyNX9H1n/XgNijqqHGDFkgTqV3H/duANfFWot7tYwWfvbx88HXnnJEijhef9VMWGj0dwwu/vqO8FFYmtphlLMPSnJym19ZgiPM71xrErHMRECtUT8mwm8d4JjZcgVjNj+4dchnL9eMWBcUA37bb9K/D10OzWwhhsxYZ0sp+EWn4h/cGfL+r62SdeiXNLCxBwL+7/o0dIOTcK
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(36756003)(6916009)(70586007)(70206006)(83380400001)(508600001)(5660300002)(2906002)(966005)(8936002)(47076005)(2616005)(26005)(426003)(356005)(16526019)(8676002)(40460700001)(4326008)(336012)(1076003)(186003)(316002)(86362001)(54906003)(7696005)(6666004)(82310400004)(81166007)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 22:10:13.4306
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dfcf17cb-cd8e-4172-53f8-08d9bb60ac84
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3222
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
Signed-off-by: James Zhu <James.Zhu@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |  6 ++++++
 drivers/gpu/drm/amd/amdkfd/kfd_device.c    | 12 ++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index a81d9cacf9b8..8a402a3df412 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -305,6 +305,7 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 			 const struct kgd2kfd_shared_resources *gpu_resources);
 void kgd2kfd_device_exit(struct kfd_dev *kfd);
 void kgd2kfd_suspend(struct kfd_dev *kfd, bool run_pm);
+int kgd2kfd_resume_iommu(struct kfd_dev *kfd);
 int kgd2kfd_resume(struct kfd_dev *kfd, bool run_pm);
 int kgd2kfd_pre_reset(struct kfd_dev *kfd);
 int kgd2kfd_post_reset(struct kfd_dev *kfd);
@@ -343,6 +344,11 @@ static inline void kgd2kfd_suspend(struct kfd_dev *kfd, bool run_pm)
 {
 }
 
+static int __maybe_unused kgd2kfd_resume_iommu(struct kfd_dev *kfd)
+{
+	return 0;
+}
+
 static inline int kgd2kfd_resume(struct kfd_dev *kfd, bool run_pm)
 {
 	return 0;
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 5751bddc9cad..1204dae85797 100644
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
2.25.1

