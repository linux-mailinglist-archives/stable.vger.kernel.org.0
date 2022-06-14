Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C2854B2A0
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 15:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbiFNN5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 09:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiFNN5t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 09:57:49 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20607.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::607])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C3C27FD0
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 06:57:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqRcx6S++5g2ItsCsRB7E1h5jgxpPIYjcATdtE9+Ou4qVPGOvoJsnBZ3LnU7+a13zGqPNgrvxnJuld5WNpjlguigtXFCBtfS8GDsxP43dit5jAcTRLMutF1E+D8YdSk1Hk22FSkNbzB64BUyGkK9a5S6TNUycJiLNv/0AygPG+k6hdXcptDpHlhvF/6mRY9p8FOR12PfAEqVKfuQZQ/rQ4HJolcs+1Vq51hCTEavwWaIhvrE0nMy30iyJREVI1L1MtzHAcD+fRmdmYQv36T9Q4dHCfCmyl1UcbKbvgO2Oh5l7c5iPIpf+eHwD2SwTeu5EBY3lIKcQYJOBbc0fXgLnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+iAjMBZjXSNlV7k7R5ro159IcTkFFIqAgGX376PVugM=;
 b=KdYHBmGrQN4evZz6gm2pjbX4sSaSafy3YhbXkOD1vISzOxmupw6ywSeznrvuqaYYPB4GbAQ8M9xvHWTzPYITM9JBfdBQrMLUYaPEbbADOLttdNR9ma2BOlAHHCeuWfHk8tHSs6+ZGjPKsUD+E7zi5ZFJ0DM0bzKOscmYVrcC/yHh37XHHsk/9yNEo6uJZjCU4+KHPMGD3ut76yQJEawmfG4QKJPel9FHUcR0X0fi61pobeCl7Jaf/GFTfMXz7H5/xZYmwRYszlGQXNRNmpPwpr7mmm+VGg37GKlBbOJRBzkU1eBqrDuiI7pRWhf1/nNM/NKdcDq4RzLKICGdK6i2WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+iAjMBZjXSNlV7k7R5ro159IcTkFFIqAgGX376PVugM=;
 b=WrBOacuryfPcdO64rFsCxF175bDE/AWKpBcJyYqWXqsEbkdAx9/+XcY9+tNfhwPlqHSxWAzhCR6VNu5v9c5B5P+hqwaf10uDFSqUGHW0qQ5NgdY7omxCzDGZbl9CyB0VcnXF77zHv9IBCj/II9zv9lhC1mZv3u2NtS5lOColFCc=
Received: from BN0PR03CA0009.namprd03.prod.outlook.com (2603:10b6:408:e6::14)
 by DM5PR1201MB0123.namprd12.prod.outlook.com (2603:10b6:4:50::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Tue, 14 Jun
 2022 13:57:43 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::65) by BN0PR03CA0009.outlook.office365.com
 (2603:10b6:408:e6::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13 via Frontend
 Transport; Tue, 14 Jun 2022 13:57:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5332.12 via Frontend Transport; Tue, 14 Jun 2022 13:57:43 +0000
Received: from Philip-Dev.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 14 Jun
 2022 08:57:42 -0500
From:   Philip Yang <Philip.Yang@amd.com>
To:     <stable@vger.kernel.org>, <Felix.Kuehling@amd.com>,
        <alexander.deucher@amd.com>
CC:     Philip Yang <Philip.Yang@amd.com>
Subject: [PATCH 1/1] drm/amdkfd: Fix partial migration bugs
Date:   Tue, 14 Jun 2022 09:57:09 -0400
Message-ID: <20220614135709.7186-1-Philip.Yang@amd.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b52248c1-db7b-4cca-34f4-08da4e0dda58
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0123:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB01230F13EE3098C83F652C5BE6AA9@DM5PR1201MB0123.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jIKt+RcTBMwnnkK37i8b3jT0IAVkg3VLh02LNEzOcqGtgnQ/jxNfIuP7Z+sLMTrsV4Rf2unCkUyY+QH5B+Ykry/AEzcxtE310uUr54k4Rc3uT93uJiDNT8OHGcqac6G2tKADP4n71q4y5H+TwWu8JYnKzHDLKBuAEVsukOsaKuIQ4DCHChXpOlN/fwRvAutO+yFsMpI3YsxdB7mYl8raXxW/yBnWTFdB4vf/OP3ZvTf6vAjV/qCDdNfG0KBcXgU9siG6ZJNaeeU6hU6I3zppiFq305aoAeSU0kk1x/d2BJ78tiM7xr5zP7QhvKzoCSJkdZwfHGv7Q8mbkUiCz7pn42fJyxQiLJlp7zefG+YKvLQRlY01duW12GttL43GD8gjxvj8wFqPAhr4rKjmvP52hSiiODo05Tu46bW5jVU4pX0MFMkFhcwjLfx+eLBGkWgthXB0wgnpnI/ifMsuAFzbL63kJeiATX59k9Jq2JOM7+UuiOd+m+j8bu649mJ3olYhnLnu6ATdkA60mN2OXKDVhoHgP7gSQnPgi9Ek0lS6K6Kgv234+T5DHKP8sdNDQXqTYcswtou4fHKqv1SIUwgEBGzjJJagCQFyW+2QaJv68mF4dFgtQHw8OVy1cBWwiyvXtGanl5hrpXeb+wk76/cEXDIQ49PucYmPQQKajfi4fGuSeEOfGE6/XBY46EE4SAtjlvV9qEt80zbjFdrlNbcJ6g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(46966006)(40470700004)(36840700001)(47076005)(1076003)(40460700003)(186003)(16526019)(2616005)(426003)(336012)(356005)(81166007)(36860700001)(70206006)(8936002)(5660300002)(70586007)(316002)(82310400005)(8676002)(2906002)(7696005)(6666004)(110136005)(6636002)(26005)(4326008)(508600001)(83380400001)(86362001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 13:57:43.0320
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b52248c1-db7b-4cca-34f4-08da4e0dda58
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0123
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit <88467db6e2f46a2e79b1b67ce6873c284e4cf417> upstream

Backport from upstream to match function amdgpu_vm_bo_update_mapping
change.

Migration range from system memory to VRAM, if system page can not be
locked or unmapped, we do partial migration and leave some pages in
system memory. Several bugs found to copy pages and update GPU mapping
for this situation:

1. copy to vram should use migrate->npage which is total pages of range
as npages, not migrate->cpages which is number of pages can be migrated.

2. After partial copy, set VRAM res cursor as j + 1, j is number of
system pages copied plus 1 page to skip copy.

3. copy to ram, should collect all continuous VRAM pages and copy
together.

4. Call amdgpu_vm_update_range, should pass in offset as bytes, not
as number of pages.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 6 +++---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c     | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index ed5385137f48..9d5324b6298c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -299,7 +299,7 @@ svm_migrate_copy_to_vram(struct amdgpu_device *adev, struct svm_range *prange,
 			 struct migrate_vma *migrate, struct dma_fence **mfence,
 			 dma_addr_t *scratch)
 {
-	uint64_t npages = migrate->cpages;
+	uint64_t npages = migrate->npages;
 	struct device *dev = adev->dev;
 	struct amdgpu_res_cursor cursor;
 	dma_addr_t *src;
@@ -346,7 +346,7 @@ svm_migrate_copy_to_vram(struct amdgpu_device *adev, struct svm_range *prange,
 						mfence);
 				if (r)
 					goto out_free_vram_pages;
-				amdgpu_res_next(&cursor, j << PAGE_SHIFT);
+				amdgpu_res_next(&cursor, (j + 1) << PAGE_SHIFT);
 				j = 0;
 			} else {
 				amdgpu_res_next(&cursor, PAGE_SIZE);
@@ -593,7 +593,7 @@ svm_migrate_copy_to_ram(struct amdgpu_device *adev, struct svm_range *prange,
 			continue;
 		}
 		src[i] = svm_migrate_addr(adev, spage);
-		if (i > 0 && src[i] != src[i - 1] + PAGE_SIZE) {
+		if (j > 0 && src[i] != src[i - 1] + PAGE_SIZE) {
 			r = svm_migrate_copy_memory_gart(adev, dst + i - j,
 							 src + i - j, j,
 							 FROM_VRAM_TO_RAM,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index f2805ba74c80..6d108dbbabdc 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1275,7 +1275,7 @@ svm_range_map_to_gpu(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 		r = amdgpu_vm_bo_update_mapping(adev, bo_adev, vm, false, false,
 						NULL, last_start,
 						prange->start + i, pte_flags,
-						last_start - prange->start,
+						(last_start - prange->start) << PAGE_SHIFT,
 						NULL, dma_addr,
 						&vm->last_update,
 						&table_freed);
-- 
2.35.1

