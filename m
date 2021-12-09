Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25AB46F68D
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 23:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbhLIWNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 17:13:55 -0500
Received: from mail-dm6nam10on2045.outbound.protection.outlook.com ([40.107.93.45]:20466
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233308AbhLIWNy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Dec 2021 17:13:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eBVmTY6uMpo4jeAfA+s4NOxmLkJans1s+nxJyvUMj9RoQbUYTVdPvgfHF9BQd8ysXDj3epX6QAeAD8oHpmrSAcDtUAJxv1v+h60MnqQ5rdeI2RUUC+8cBLAeO7Iqz6C3Bx+yiFtEmfGp3yuYNE3Ch3sgYbkL1nTGXhbLhr1u6mYjMAeZ22MbZTEaBpoO48ePvXrK0CMPnrjG/W3LWGuMwm2Tgv2rI3hgtOsItZIENFDct9XkXvW8c52YcrutHH0FqhxaOtHXDHIe0hmYWPpXesLqB3NZ6dws+25dNxNt2gFpWWg6/ooQu8ctIPZS0hSqyN2oNGBSRVKHn28XzIvXcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GdrUi9L83+ioa7+XEyIEQoByH4Je26BV5deJVA6tmpA=;
 b=dO/PkwhFu+hV2MLh/GZbBLFcbfoUA8gsxrHwZ7Nhw0Ga0lDvLwuhxab17h1n9dX1BVTi+A1/mOUHt0WlX12YmHG1/tXHFATSYGs+2fL5RbByMPC/OcL1uZLPuTHGqNZ++QCtuJkYDi5PMFulgf1IH/+REbj8h9DuDE+UPK18qkhTMortDQNrc9di/U5XMP3Gh/hqOz4PPKcqQ2cN004uhffGwob0Q5yO6niHtZOsK+/ukEcVlJtJzsSYvIC5Wclu4bh4JQvL1lIm4dWF60LA4BFPJOGXmksjPhXURZ5UjsaLwTNYdlFCeOnIYvgXLf2YS9wmzreZAJ4/qXHEEDWDBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GdrUi9L83+ioa7+XEyIEQoByH4Je26BV5deJVA6tmpA=;
 b=DBXAppqpuVfZSRJIL8SSz0rl0/fgLmoAYvkpbi2km6ndc5YfM1y1qpoRAjnIZjKIMRxt5s6URwom2FQR5b/vEGQ9M3prHwspMvufzd+AocPF53pb35JyhIPlVUkPkvkG+jSawoB9m9mN0Ds85Nkq8UTZelyMlHxfv7h29KQ4UPs=
Received: from DM5PR06CA0063.namprd06.prod.outlook.com (2603:10b6:3:37::25) by
 MN2PR12MB3391.namprd12.prod.outlook.com (2603:10b6:208:c3::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.22; Thu, 9 Dec 2021 22:10:14 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:37:cafe::30) by DM5PR06CA0063.outlook.office365.com
 (2603:10b6:3:37::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend
 Transport; Thu, 9 Dec 2021 22:10:14 +0000
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
 2021 16:10:12 -0600
From:   James Zhu <James.Zhu@amd.com>
To:     <stable@vger.kernel.org>
CC:     <jzhums@gmail.com>, <alexander.deucher@amd.com>,
        <kolAflash@kolahilft.de>, Felix Kuehling <Felix.Kuehling@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 3/6] drm/amdgpu: add amdgpu_amdkfd_resume_iommu
Date:   Thu, 9 Dec 2021 17:09:53 -0500
Message-ID: <20211209220956.3466442-4-James.Zhu@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 76e0384c-b93c-44f4-c45e-08d9bb60acd7
X-MS-TrafficTypeDiagnostic: MN2PR12MB3391:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB33912CC2BE7B6802B6DF9D2CE4709@MN2PR12MB3391.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:167;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aYqgGxlxqU/h9raazIRnxtd0GSxylcItsXTItXQ545LuUDXYrfxu4rPK1Npw8sSVElNnqWffngGIU6utDR9TKgqs0++TjuLz8fH4N5R40czL4udAmXMDA4jpT9/gLROr5jb4OF9fJl1kB32n7OJ35kqW/TCqpywqR8ILISkR21DhH77at7Q0VrRFVNmKQyRS2LS/34XjSrZwRrpe0oR14+/GPTTQKMEiLVoGIjsD1vBsKyElOt4UZY6pVmnKCSEE3O4OFe+Hb52Cbbb5kh8b4GZiSG2R8h2roq8QC3nQFzCnjWvg0UpzD7mbjvihyTYBd6xZL1qj69nDE7EsUT7FatiDNkrLXh3rf6nvTTcPqik4JUUfKrZmVSUGkFE398Cz0N5wQnfv9fjIYcFyJdlaKLQrk313P/YmtzwLeFQwDU/YKb98nywipzYbA91FBAkTyyvHWtj75D/ZhlLnWJnNe1TDXFPBj+byNX2CNhQdYaUsLSOjpgIAeYfxAAGzXriV9PYev1qd7hW8ojxNgVMbikqLQJD2A9p4vaauKEFIjSbUyr6cTowwxsX0xhkyqmJMqMGs6Y5tQbud08kBLDnlsZwCkWuSD8OMGiu5xGD/G8SR4aRz3ztD+lUSio1hsr1oj18Q7oF2PEPu9yigb09TjUfQNHS208kfn8yxSm/c2XJJ/5VwLAHgZruVLk7sD240TIAdbbezYjwUTOXwQsRFWX0oWXn/U1+B202Y1ec6vj0WuVtmQdUInQbbAdQ/ifdzK+fJkJjl20820+I+FZKLEqQZhyeujkx3LuSpHx8f+EmBDy1CS7QXfNVlcPNJGII+QUYnczu2GPJHKDZzIZkbIGX3Ne1qiM57xBHMEs+EzAWClsKc1eqocdr/oT4fJ67T
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(4326008)(8676002)(70206006)(47076005)(40460700001)(81166007)(70586007)(356005)(36756003)(26005)(7696005)(86362001)(82310400004)(83380400001)(6666004)(36860700001)(6916009)(508600001)(1076003)(2906002)(426003)(54906003)(336012)(186003)(966005)(2616005)(16526019)(8936002)(5660300002)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 22:10:13.9618
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e0384c-b93c-44f4-c45e-08d9bb60acd7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3391
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 8066008482e533e91934bee49765bf8b4a7c40db upstream.

Add amdgpu_amdkfd_resume_iommu for amdgpu.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211277
Signed-off-by: James Zhu <James.Zhu@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: James Zhu <James.Zhu@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c | 10 ++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
index b23b31dc570e..fb6230c62daa 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -190,6 +190,16 @@ void amdgpu_amdkfd_suspend(struct amdgpu_device *adev, bool run_pm)
 		kgd2kfd_suspend(adev->kfd.dev, run_pm);
 }
 
+int amdgpu_amdkfd_resume_iommu(struct amdgpu_device *adev)
+{
+	int r = 0;
+
+	if (adev->kfd.dev)
+		r = kgd2kfd_resume_iommu(adev->kfd.dev);
+
+	return r;
+}
+
 int amdgpu_amdkfd_resume(struct amdgpu_device *adev, bool run_pm)
 {
 	int r = 0;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index 8a402a3df412..32e385f287cb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -121,6 +121,7 @@ int amdgpu_amdkfd_init(void);
 void amdgpu_amdkfd_fini(void);
 
 void amdgpu_amdkfd_suspend(struct amdgpu_device *adev, bool run_pm);
+int amdgpu_amdkfd_resume_iommu(struct amdgpu_device *adev);
 int amdgpu_amdkfd_resume(struct amdgpu_device *adev, bool run_pm);
 void amdgpu_amdkfd_interrupt(struct amdgpu_device *adev,
 			const void *ih_ring_entry);
-- 
2.25.1

