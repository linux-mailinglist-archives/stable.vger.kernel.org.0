Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461E5644328
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 13:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbiLFMau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 07:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbiLFMat (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 07:30:49 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C352937B;
        Tue,  6 Dec 2022 04:30:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1sPawe5sCahdM/iQhn7FYXddix3g2MW0Sc83ToKMnsS8OnsjnNMxO5jzStD4SCNk0xromY3pZCLbIlknqecNYnh0pzDCNfXFcPcivdf+q0oia6hLMLYZHI7AtQpAke8JLMlQC/n6rS7UtyW0sqF1LTPH5I3VOw2RZZrP4Lc9r2q9Xgco8MTM4gD+5Vyk5LC6Fqd62IRLUaAPlTd3AHucvwXIdWtgG33YgrymOReCQhzgGg9eMAUR7YPEeZ8OVH1vpbty3R8NDQKfW4i9s8far9U3x15Y+zudevxkjI5jfrCEJzixLZ8GQpDp8w7FEZdNUFNEpUtv2AV8FrD5oAhKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JFfpI7/0TtSX4KMWhYMdq34Q82yHawYoksyCtH9abIg=;
 b=WxSbSnx6tr7c83AGMqzE/J/cm9Hpf9HTLYcuXlzxNVc8ZofAMg13daeRxe6Ez/V1WgVPdSP6HZxuPH+MDFoKbBLyIpclm+OHoGZT1s7r+yfOOfj20vT16yqevQi/cfP6xqLl3mBJV2VwaKzSemJxtZWCQoUx1ThxfzVWh++yZqYAddoEOPU+9vAM/mZTxfb1v7l8zepz0eA8/gFyvZOqJPlA4fuZ6Sx4/fkwNYa8JTurIn3hylxI1QGNxMjhk8XlMiP+IkSfdPEx0hPx0CmUluC7SJVcdNskzyGQbsMwt3bMVvq08hqz0Q9w8QRHDQ24/+Ed1Xi6Lmd68lqqFp/+ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFfpI7/0TtSX4KMWhYMdq34Q82yHawYoksyCtH9abIg=;
 b=mropk1IxXIjUqNIh+LVQCleBDPebsVQx1neKWqgu8ok3SQ+SHKb0e8KIGz+u5enR7JcH2mVkVXOe26+UU3/GKpI+n+BAtwKTuXIAYEokPlFk4Nam6D6vWGp5zpYfZ2Owgbhz3/dxn3FieMAYmNvRrlIlab8oWvjNYD3vh8VzsXg=
Received: from BN8PR15CA0020.namprd15.prod.outlook.com (2603:10b6:408:c0::33)
 by MW3PR12MB4347.namprd12.prod.outlook.com (2603:10b6:303:2e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 12:30:43 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::c6) by BN8PR15CA0020.outlook.office365.com
 (2603:10b6:408:c0::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Tue, 6 Dec 2022 12:30:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Tue, 6 Dec 2022 12:30:41 +0000
Received: from andbang9.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 06:30:35 -0600
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linaro-mm-sig@lists.linaro.org>
CC:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Mythri PK <Mythri.Pandeshwarakrishna@amd.com>,
        Jeshwanth <JESHWANTHKUMAR.NK@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        <stable@vger.kernel.org>,
        "Jens Wiklander" <jens.wiklander@linaro.org>
Subject: [PATCH 1/1] crypto: ccp - Allocate TEE ring and cmd buffer using DMA APIs
Date:   Tue, 6 Dec 2022 18:00:19 +0530
Message-ID: <43568d5e6395fcab48262fa5b3d1a5112918fbe8.1669372199.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT047:EE_|MW3PR12MB4347:EE_
X-MS-Office365-Filtering-Correlation-Id: 94fbe9aa-315d-4c45-cd76-08dad785b058
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YFvh7EEaNmJxGd1BZnQjkQ3k/RFpzwsG36phUiawvl4NqjKcDr/MrEMMLVClMMszN4lioce6her30DxqXc1Ls+yOC820HWWymTb25MNMB2wPb3/kkBvXdNiF6q7VuFx9s1Cfp+nszo8LJI9qI8qyLO9dzxPy4l/q3ZyFUrwojfbN8Ea5ZeZCW71y69JPHfK7tiUmTxKsrOTj4zE3JO9RWJdxlodbZiXUijD2oNu4dneLX1AWXgfy9LTm2vBQQwvjiSnqiqy2PbTJbOnAq1IasSIyuLivEqPA11KRK44Jv0GrilpkpyqbnonN4kg+LKVvtk7F2OdpCF5+ns7OzjfamGpvsmCYR8VpZPERQpl9XYjJrjTfLOi0ghD1eePaFDyL+AvA2VqdLg7xJIYj8n7smDp78PMlhZqec5369s9axpv2YxaG/o/uKqBwcIiqNxaZXSebsP9cD38rr7mQFGiqIQmTkHXxxzxzRBTfwUFqG3/b13JAqu0osQJVm97xPHYYOAkuAb3TM2E/z5JFBSYbqJxjLbv7eUongG6Z+cnHPPJdLl49AC9Rcn6C9JJ5SEnAVOaF/41UbENFzER/XcHE/HGiTuKxsoAxZdihjJp8+db+h2h7xQSUv/H2djUuiga4Hm7H56JBUziMUxyrwizxnGmaHB7rHOEjroVl8LWy3UydYO8mqJt0gY6WN8l9gFxTr6qfHxPdKOEOGZl6Ijprvj8YdvBQcXsZldtWuIE7AXhEbjrI5vTDnmP610h+YAiN
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(136003)(346002)(451199015)(40470700004)(46966006)(36840700001)(83380400001)(7696005)(2906002)(921005)(86362001)(54906003)(110136005)(16526019)(186003)(26005)(336012)(2616005)(41300700001)(40460700003)(82310400005)(30864003)(5660300002)(36756003)(47076005)(7416002)(426003)(316002)(8936002)(70586007)(70206006)(36860700001)(66899015)(82740400003)(81166007)(356005)(478600001)(6666004)(4326008)(8676002)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 12:30:41.5266
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94fbe9aa-315d-4c45-cd76-08dad785b058
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4347
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For AMD Secure Processor (ASP) to map and access TEE ring buffer, the
ring buffer address sent by host to ASP must be a real physical
address and the pages must be physically contiguous.

In a virtualized environment though, when the driver is running in a
guest VM, the pages allocated by __get_free_pages() may not be
contiguous in the host (or machine) physical address space. Guests
will see a guest (or pseudo) physical address and not the actual host
(or machine) physical address. The TEE running on ASP cannot decipher
pseudo physical addresses. It needs host or machine physical address.

To resolve this problem, use DMA APIs for allocating buffers that must
be shared with TEE. This will ensure that the pages are contiguous in
host (or machine) address space. If the DMA handle is an IOVA,
translate it into a physical address before sending it to ASP.

This patch also exports two APIs (one for buffer allocation and
another to free the buffer). This API can be used by AMD-TEE driver to
share buffers with TEE.

Fixes: 33960acccfbd ("crypto: ccp - add TEE support for Raven Ridge")
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
Co-developed-by: Jeshwanth <JESHWANTHKUMAR.NK@amd.com>
Signed-off-by: Jeshwanth <JESHWANTHKUMAR.NK@amd.com>
Reviewed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
---
 drivers/crypto/ccp/psp-dev.c |   6 +-
 drivers/crypto/ccp/tee-dev.c | 116 ++++++++++++++++++++++-------------
 drivers/crypto/ccp/tee-dev.h |   9 +--
 include/linux/psp-tee.h      |  47 ++++++++++++++
 4 files changed, 127 insertions(+), 51 deletions(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index c9c741ac8442..2b86158d7435 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -161,13 +161,13 @@ int psp_dev_init(struct sp_device *sp)
 		goto e_err;
 	}
 
+	if (sp->set_psp_master_device)
+		sp->set_psp_master_device(sp);
+
 	ret = psp_init(psp);
 	if (ret)
 		goto e_irq;
 
-	if (sp->set_psp_master_device)
-		sp->set_psp_master_device(sp);
-
 	/* Enable interrupt */
 	iowrite32(-1, psp->io_regs + psp->vdata->inten_reg);
 
diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 5c9d47f3be37..1631d9851e54 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -12,8 +12,9 @@
 #include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/dma-direct.h>
+#include <linux/iommu.h>
 #include <linux/gfp.h>
-#include <linux/psp-sev.h>
 #include <linux/psp-tee.h>
 
 #include "psp-dev.h"
@@ -21,25 +22,64 @@
 
 static bool psp_dead;
 
+struct dma_buffer *psp_tee_alloc_dmabuf(unsigned long size, gfp_t gfp)
+{
+	struct psp_device *psp = psp_get_master_device();
+	struct dma_buffer *dma_buf;
+	struct iommu_domain *dom;
+
+	if (!psp || !size)
+		return NULL;
+
+	dma_buf = kzalloc(sizeof(*dma_buf), GFP_KERNEL);
+	if (!dma_buf)
+		return NULL;
+
+	dma_buf->vaddr = dma_alloc_coherent(psp->dev, size, &dma_buf->dma, gfp);
+	if (!dma_buf->vaddr || !dma_buf->dma) {
+		kfree(dma_buf);
+		return NULL;
+	}
+
+	dma_buf->size = size;
+
+	dom = iommu_get_domain_for_dev(psp->dev);
+	if (dom)
+		dma_buf->paddr = iommu_iova_to_phys(dom, dma_buf->dma);
+	else
+		dma_buf->paddr = dma_buf->dma;
+
+	return dma_buf;
+}
+EXPORT_SYMBOL(psp_tee_alloc_dmabuf);
+
+void psp_tee_free_dmabuf(struct dma_buffer *dma_buf)
+{
+	struct psp_device *psp = psp_get_master_device();
+
+	if (!psp || !dma_buf)
+		return;
+
+	dma_free_coherent(psp->dev, dma_buf->size,
+			  dma_buf->vaddr, dma_buf->dma);
+
+	kfree(dma_buf);
+}
+EXPORT_SYMBOL(psp_tee_free_dmabuf);
+
 static int tee_alloc_ring(struct psp_tee_device *tee, int ring_size)
 {
 	struct ring_buf_manager *rb_mgr = &tee->rb_mgr;
-	void *start_addr;
 
 	if (!ring_size)
 		return -EINVAL;
 
-	/* We need actual physical address instead of DMA address, since
-	 * Trusted OS running on AMD Secure Processor will map this region
-	 */
-	start_addr = (void *)__get_free_pages(GFP_KERNEL, get_order(ring_size));
-	if (!start_addr)
+	rb_mgr->ring_buf = psp_tee_alloc_dmabuf(ring_size,
+						GFP_KERNEL | __GFP_ZERO);
+	if (!rb_mgr->ring_buf) {
+		dev_err(tee->dev, "ring allocation failed\n");
 		return -ENOMEM;
-
-	memset(start_addr, 0x0, ring_size);
-	rb_mgr->ring_start = start_addr;
-	rb_mgr->ring_size = ring_size;
-	rb_mgr->ring_pa = __psp_pa(start_addr);
+	}
 	mutex_init(&rb_mgr->mutex);
 
 	return 0;
@@ -49,15 +89,8 @@ static void tee_free_ring(struct psp_tee_device *tee)
 {
 	struct ring_buf_manager *rb_mgr = &tee->rb_mgr;
 
-	if (!rb_mgr->ring_start)
-		return;
+	psp_tee_free_dmabuf(rb_mgr->ring_buf);
 
-	free_pages((unsigned long)rb_mgr->ring_start,
-		   get_order(rb_mgr->ring_size));
-
-	rb_mgr->ring_start = NULL;
-	rb_mgr->ring_size = 0;
-	rb_mgr->ring_pa = 0;
 	mutex_destroy(&rb_mgr->mutex);
 }
 
@@ -81,35 +114,36 @@ static int tee_wait_cmd_poll(struct psp_tee_device *tee, unsigned int timeout,
 	return -ETIMEDOUT;
 }
 
-static
-struct tee_init_ring_cmd *tee_alloc_cmd_buffer(struct psp_tee_device *tee)
+struct dma_buffer *tee_alloc_cmd_buffer(struct psp_tee_device *tee)
 {
 	struct tee_init_ring_cmd *cmd;
+	struct dma_buffer *cmd_buffer;
 
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (!cmd)
+	cmd_buffer = psp_tee_alloc_dmabuf(sizeof(*cmd),
+					  GFP_KERNEL | __GFP_ZERO);
+	if (!cmd_buffer)
 		return NULL;
 
-	cmd->hi_addr = upper_32_bits(tee->rb_mgr.ring_pa);
-	cmd->low_addr = lower_32_bits(tee->rb_mgr.ring_pa);
-	cmd->size = tee->rb_mgr.ring_size;
+	cmd = (struct tee_init_ring_cmd *)cmd_buffer->vaddr;
+	cmd->hi_addr = upper_32_bits(tee->rb_mgr.ring_buf->paddr);
+	cmd->low_addr = lower_32_bits(tee->rb_mgr.ring_buf->paddr);
+	cmd->size = tee->rb_mgr.ring_buf->size;
 
 	dev_dbg(tee->dev, "tee: ring address: high = 0x%x low = 0x%x size = %u\n",
 		cmd->hi_addr, cmd->low_addr, cmd->size);
 
-	return cmd;
+	return cmd_buffer;
 }
 
-static inline void tee_free_cmd_buffer(struct tee_init_ring_cmd *cmd)
+static inline void tee_free_cmd_buffer(struct dma_buffer *cmd_buffer)
 {
-	kfree(cmd);
+	psp_tee_free_dmabuf(cmd_buffer);
 }
 
 static int tee_init_ring(struct psp_tee_device *tee)
 {
 	int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
-	struct tee_init_ring_cmd *cmd;
-	phys_addr_t cmd_buffer;
+	struct dma_buffer *cmd_buffer;
 	unsigned int reg;
 	int ret;
 
@@ -123,21 +157,19 @@ static int tee_init_ring(struct psp_tee_device *tee)
 
 	tee->rb_mgr.wptr = 0;
 
-	cmd = tee_alloc_cmd_buffer(tee);
-	if (!cmd) {
+	cmd_buffer = tee_alloc_cmd_buffer(tee);
+	if (!cmd_buffer) {
 		tee_free_ring(tee);
 		return -ENOMEM;
 	}
 
-	cmd_buffer = __psp_pa((void *)cmd);
-
 	/* Send command buffer details to Trusted OS by writing to
 	 * CPU-PSP message registers
 	 */
 
-	iowrite32(lower_32_bits(cmd_buffer),
+	iowrite32(lower_32_bits(cmd_buffer->paddr),
 		  tee->io_regs + tee->vdata->cmdbuff_addr_lo_reg);
-	iowrite32(upper_32_bits(cmd_buffer),
+	iowrite32(upper_32_bits(cmd_buffer->paddr),
 		  tee->io_regs + tee->vdata->cmdbuff_addr_hi_reg);
 	iowrite32(TEE_RING_INIT_CMD,
 		  tee->io_regs + tee->vdata->cmdresp_reg);
@@ -157,7 +189,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
 	}
 
 free_buf:
-	tee_free_cmd_buffer(cmd);
+	tee_free_cmd_buffer(cmd_buffer);
 
 	return ret;
 }
@@ -167,7 +199,7 @@ static void tee_destroy_ring(struct psp_tee_device *tee)
 	unsigned int reg;
 	int ret;
 
-	if (!tee->rb_mgr.ring_start)
+	if (!tee->rb_mgr.ring_buf->vaddr)
 		return;
 
 	if (psp_dead)
@@ -256,7 +288,7 @@ static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,
 	do {
 		/* Get pointer to ring buffer command entry */
 		cmd = (struct tee_ring_cmd *)
-			(tee->rb_mgr.ring_start + tee->rb_mgr.wptr);
+			(tee->rb_mgr.ring_buf->vaddr + tee->rb_mgr.wptr);
 
 		rptr = ioread32(tee->io_regs + tee->vdata->ring_rptr_reg);
 
@@ -305,7 +337,7 @@ static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,
 
 	/* Update local copy of write pointer */
 	tee->rb_mgr.wptr += sizeof(struct tee_ring_cmd);
-	if (tee->rb_mgr.wptr >= tee->rb_mgr.ring_size)
+	if (tee->rb_mgr.wptr >= tee->rb_mgr.ring_buf->size)
 		tee->rb_mgr.wptr = 0;
 
 	/* Trigger interrupt to Trusted OS */
diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
index 49d26158b71e..9238487ee8bf 100644
--- a/drivers/crypto/ccp/tee-dev.h
+++ b/drivers/crypto/ccp/tee-dev.h
@@ -16,6 +16,7 @@
 
 #include <linux/device.h>
 #include <linux/mutex.h>
+#include <linux/psp-tee.h>
 
 #define TEE_DEFAULT_TIMEOUT		10
 #define MAX_BUFFER_SIZE			988
@@ -48,17 +49,13 @@ struct tee_init_ring_cmd {
 
 /**
  * struct ring_buf_manager - Helper structure to manage ring buffer.
- * @ring_start:  starting address of ring buffer
- * @ring_size:   size of ring buffer in bytes
- * @ring_pa:     physical address of ring buffer
  * @wptr:        index to the last written entry in ring buffer
+ * @ring_buf:    ring buffer allocated using DMA api
  */
 struct ring_buf_manager {
 	struct mutex mutex;	/* synchronizes access to ring buffer */
-	void *ring_start;
-	u32 ring_size;
-	phys_addr_t ring_pa;
 	u32 wptr;
+	struct dma_buffer *ring_buf;
 };
 
 struct psp_tee_device {
diff --git a/include/linux/psp-tee.h b/include/linux/psp-tee.h
index cb0c95d6d76b..c0fa922f24d4 100644
--- a/include/linux/psp-tee.h
+++ b/include/linux/psp-tee.h
@@ -13,6 +13,7 @@
 
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/dma-mapping.h>
 
 /* This file defines the Trusted Execution Environment (TEE) interface commands
  * and the API exported by AMD Secure Processor driver to communicate with
@@ -40,6 +41,20 @@ enum tee_cmd_id {
 	TEE_CMD_ID_UNMAP_SHARED_MEM,
 };
 
+/**
+ * struct dma_buffer - Structure for a DMA buffer.
+ * @dma:    DMA buffer address
+ * @paddr:  Physical address of DMA buffer
+ * @vaddr:  CPU virtual address of DMA buffer
+ * @size:   Size of DMA buffer in bytes
+ */
+struct dma_buffer {
+	dma_addr_t dma;
+	phys_addr_t paddr;
+	void *vaddr;
+	unsigned long size;
+};
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 /**
  * psp_tee_process_cmd() - Process command in Trusted Execution Environment
@@ -75,6 +90,28 @@ int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf, size_t len,
  */
 int psp_check_tee_status(void);
 
+/**
+ * psp_tee_alloc_dmabuf() - Allocates memory of requested size and flags using
+ * dma_alloc_coherent() API.
+ *
+ * This function can be used to allocate a shared memory region between the
+ * host and PSP TEE.
+ *
+ * Returns:
+ * non-NULL   a valid pointer to struct dma_buffer
+ * NULL       on failure
+ */
+struct dma_buffer *psp_tee_alloc_dmabuf(unsigned long size, gfp_t gfp);
+
+/**
+ * psp_tee_free_dmabuf() - Deallocates memory using dma_free_coherent() API.
+ *
+ * This function can be used to release shared memory region between host
+ * and PSP TEE.
+ *
+ */
+void psp_tee_free_dmabuf(struct dma_buffer *dma_buffer);
+
 #else /* !CONFIG_CRYPTO_DEV_SP_PSP */
 
 static inline int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf,
@@ -87,5 +124,15 @@ static inline int psp_check_tee_status(void)
 {
 	return -ENODEV;
 }
+
+static inline
+struct dma_buffer *psp_tee_alloc_dmabuf(unsigned long size, gfp_t gfp)
+{
+	return NULL;
+}
+
+static inline void psp_tee_free_dmabuf(struct dma_buffer *dma_buffer)
+{
+}
 #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
 #endif /* __PSP_TEE_H_ */
-- 
2.25.1

