Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC61E467C80
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 18:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239848AbhLCRbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 12:31:08 -0500
Received: from mail-co1nam11on2050.outbound.protection.outlook.com ([40.107.220.50]:47201
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1352986AbhLCRbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Dec 2021 12:31:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktIaUVab2pkpC/GeKDhPNsYXmSsLth2dIZyW135RIBpRV/oN/Q8bvbkoOtg1sgbP8Glh4MWHscLLE2WFzLxUsAheVXJIMU1mBhhCxILB7NnV2T8Z/tAeURsKY2BU4Cgx4v09m8aiGAZ7L3IIqbOUF2hdetfWXvLoGrhqcvuq/SGBvEQa2VfUfGpCbFV/31j90e0mIqmiwplmeKB7WUmgJhuZmJ0RYmqT1qIcF2Who69p6g34hautma90r/cUDlp8ZZX+22KYGHTqHj3RwJLexNVdp18+PCslRpTFQDIgLMagFhLfcxS6Cs4Ib88hrlv4Iz+PUsRdzIKYmsogDtvBxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AYirALc7U9JZHbayR9kkTOA/QJxN2gzhTpPmO4rIT5Y=;
 b=I9Z4hpHKMrQGgjlMV2xCWKezvRhrX3VO19Y11IEZ4u4P5VEpF77britB0Av8sQzUP2ZTyuVMAHJxkKZckqI387+6NMTq7V4bIvkWWVBRBQjJyqAb/xitKjwMPaHSIhVKT8QGq04cvY3uFPjugRUm1lGANUNXyNG4QYdJURYTJf0pT4AkuZXL85ZzrXQxlX06sAKI1kgK3/apQg/z3b637pzsE5r05Wdo/He/Ec0YO1DgtePPqJagQMoOMZgOC6ZlwEh3PZmN19Ce/2kJR/dD+h/KDK5iHoQWX18EHyEsZrPdgAf8KDdHl6HanAlVvMHS1VFUEKwv0A7JJuL8Bb2/Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYirALc7U9JZHbayR9kkTOA/QJxN2gzhTpPmO4rIT5Y=;
 b=5isyicp9M+Y3PJn+RVq2HYehuy5KZJckB0WNoWydOwkW1EJ7sT2AKiPDt5xBY2cCG0Ko5LNVfPnxmzHfIlWncQzDmSb8Eb3lVcKpkwTTaDGEX4BsD1dtk0F9Nm5cF2L7rq2CKtbYnoBiyjdEn/TTSE8hx21DHDtIWSA4V6pnPzk=
Received: from DM5PR11CA0013.namprd11.prod.outlook.com (2603:10b6:3:115::23)
 by DM4PR12MB5183.namprd12.prod.outlook.com (2603:10b6:5:396::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Fri, 3 Dec
 2021 17:27:42 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:115:cafe::b8) by DM5PR11CA0013.outlook.office365.com
 (2603:10b6:3:115::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend
 Transport; Fri, 3 Dec 2021 17:27:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4755.13 via Frontend Transport; Fri, 3 Dec 2021 17:27:42 +0000
Received: from work_495456.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 3 Dec
 2021 11:27:41 -0600
From:   James Zhu <James.Zhu@amd.com>
To:     <stable@vger.kernel.org>
CC:     <jzhums@gmail.com>, <alexander.deucher@amd.com>,
        <kolAflash@kolahilft.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/5] drm/amdgpu: add amdgpu_amdkfd_resume_iommu
Date:   Fri, 3 Dec 2021 12:27:29 -0500
Message-ID: <1638552452-4198-3-git-send-email-James.Zhu@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: ece05475-a773-4072-0503-08d9b68236bb
X-MS-TrafficTypeDiagnostic: DM4PR12MB5183:
X-Microsoft-Antispam-PRVS: <DM4PR12MB51830CA828B0F2F779D83B1BE46A9@DM4PR12MB5183.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:167;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dDUx3AfQSlzE2YQhhyEAbHZq7xJvi8g2+9GpMu5CInf5kTke2gZOBzcZKzLgxx+xwswCE2FSUcbDtTsYI6053cDRWW2Y1ami8vi8SnyxPiBtduv+ES5TXoTOG3vk8pNE+TxC3cC50kIXQovBwOrL+lZuZ2+XmovWezS5AQd7lNIKv0R3E55CEGWaU0JpOMhvRsOjjtPh+GTgew2fuEKr3lLBOTu+Bsk7qo9JCMe3PIEmpILG1xoqBGzC+ALNoEW4nA9ygl2Q00v8zwZbViYGcXTYDx/Kx//b6N5hkb6KGfkMnRjto0vRVKcNZllep4XwT0xmcDD9zhp+zO5SSmJQ6zr0Gh34dpRi4UXHGZ0y7d/bQA9UIEHSxlIu0bPcJP6b2gDN5hvA7G1xGW/CgM3yeYhhv0rDyFpb5vbIDZBVQZtgkO7XREdFPhn+A3aHTv2pz4N28nZMBXopFTbFAADp20ogM670knQmbHm/UhQtvgHbg1kWRCpHvp+y4X4uXvWFqXwYLUwy4diedqurMgTkitjrrEqK/vcGjYMVGvxNeuLlib5A83IL7HuFYgw8bNpozPp9Ik678/PfUF47ahrbywLHFCWbt6TwV8TWqVPLM18o8BTlUt36mixc4wHh82MjlYoeTnEVMQlF5JieOvGCpc/OjY7rmiGXshN8C+IWi9y/Qvw+hZelSQubLJD766MQZXpiSj9v7sy479oop61H7J7l0NmQj44Yz69jioWwPKuPy3Qfh3u/V10nKpp4WazNLE3nuhKkp7DjGj3bG+KvQEXJSti81/v7msZRtYs2WeSi9Fglz2jQLxfBY+zOseibQBRGLM1hnWU88JmlEE+XRYKjPXSTycsbIGoOJm3XDcb0rdn7papVhTkzThH6zZyw
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(6666004)(8676002)(47076005)(70206006)(83380400001)(2906002)(40460700001)(4326008)(426003)(82310400004)(36860700001)(186003)(336012)(70586007)(5660300002)(81166007)(6916009)(86362001)(26005)(54906003)(316002)(2616005)(16526019)(7696005)(8936002)(36756003)(356005)(966005)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 17:27:42.8772
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ece05475-a773-4072-0503-08d9b68236bb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5183
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
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c | 10 ++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
index 0544460..ef83047 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -194,6 +194,16 @@ void amdgpu_amdkfd_suspend(struct amdgpu_device *adev, bool run_pm)
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
index 7f78bcf..896ae32 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -126,6 +126,7 @@ int amdgpu_amdkfd_init(void);
 void amdgpu_amdkfd_fini(void);
 
 void amdgpu_amdkfd_suspend(struct amdgpu_device *adev, bool run_pm);
+int amdgpu_amdkfd_resume_iommu(struct amdgpu_device *adev);
 int amdgpu_amdkfd_resume(struct amdgpu_device *adev, bool run_pm);
 void amdgpu_amdkfd_interrupt(struct amdgpu_device *adev,
 			const void *ih_ring_entry);
-- 
2.7.4

