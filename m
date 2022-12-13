Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8AFE64B3E0
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 12:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235379AbiLMLLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 06:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234981AbiLMLLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 06:11:16 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BC41CB37;
        Tue, 13 Dec 2022 03:10:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzPXtSi+EQ2rVtMzlgffsz6DReVs1JqPVEssxOx6tYttgEv6klS34TGsuc/qxZzdO0JzmeMUtyqleJcnoYjWJ6ATgYvO6GdQAPHYwVPX74FAj7PSJ5vOOObcbO0X/0flKtndEAhDoucjKPGMncVkFL66PLH2WuzsCpFVxgxKNShkAQMyzSXJYFk8tKma4G5OSIK8R8n9Mwejfr4paU9Ue/6ZTMEXpauBZzlnVBWSJwErADlHFvqDnjTlA+759CaoeabGJ+WcMYSS+GAO+nzivoKNUaYKvUSAfXYywdt6a0SuqVsDNWojAz7BP7fwYBq7xXysiS6eqJyEhLTbxFdx4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yYvUiap/vDHYJK4KsDxvJa0XZvumRQD9sn0y3XrB3wM=;
 b=LSCt+A7oZ7H7jTPSEBEg96LCAZhqlVigIn5zPcPouvRLC2EIscggBlCxnVVqphV/WEY2QpmToiCho/KdX+TyWQoRho+Jw4GqFxSqXECrTLnWPwdZR6Y9XJta0OacJ/IaWUmrEewzzz80baFv1h9enJsBm2glKU0SwqN+TKnSziuB+L2qt/whacRD8B/aIpFiErcVgm/2cuMle9kerim4lVqcil6Exsnj/1C39W9CF6iK1Uv7aUHC87yp3b17nKMN9xgYgpRpI+Xwrxcbd110sbTSy1D6djtUP41ko+4Ng56WrEvjTLkFlp4auDbPfFHd0QXpAqj2AHNYPHXvTu7yIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yYvUiap/vDHYJK4KsDxvJa0XZvumRQD9sn0y3XrB3wM=;
 b=PJe01EMZ4P1x66pN3G8khyBh+CQY/EOAnC7TvXltLZ8oEr8Lv6rQAUi3FrG/+hfm/8NxjrKsbKO3UrKqPeseaWCyGou2U003CaEiRvrmiqWpKQNZOMyLoUz53fhoRfvL3qWOEc2rh+3aj9lO+Xxtn+By9AFToDOXadMvJbbfiUA=
Received: from CY5PR19CA0010.namprd19.prod.outlook.com (2603:10b6:930:15::14)
 by CH3PR12MB7668.namprd12.prod.outlook.com (2603:10b6:610:14d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 11:10:53 +0000
Received: from CY4PEPF0000C97B.namprd02.prod.outlook.com
 (2603:10b6:930:15:cafe::d) by CY5PR19CA0010.outlook.office365.com
 (2603:10b6:930:15::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Tue, 13 Dec 2022 11:10:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C97B.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.9 via Frontend Transport; Tue, 13 Dec 2022 11:10:52 +0000
Received: from andbang9.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 13 Dec
 2022 05:10:46 -0600
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
Subject: [PATCH v2] crypto: ccp - Allocate TEE ring and cmd buffer using DMA APIs
Date:   Tue, 13 Dec 2022 16:40:27 +0530
Message-ID: <651349f55060767a9a51316c966c1e5daa57a644.1670919979.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C97B:EE_|CH3PR12MB7668:EE_
X-MS-Office365-Filtering-Correlation-Id: 66af9d5d-ffb6-48e1-ad29-08dadcfab2de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wDtS3tgD+PB7KhFXkrGlGSUDvL54CNVBWyF6ggM6mbHI5avCEZAUCBcO/SOFA1nnu00sDbX+uuv5xrGe/PzEtsdTJH57Sj5X9WC1e1/A9NZpn05AVb7u4vD4HorCuiYvhQpi06qNjsHtUXoBohkmgaEs8kkkRA/kBqIR7GR0FiOKnNDlSZjYEBG1kEhkDdKxsMeHysGOVEqPDZsQuEQ3ppJHW8Jr1hsFIyPFjZICiPB/gFflrHAdRCJXmTVXpQMnUYY1Sd9yWhDIslyFj5uRShXsL0zJ3MaAesm7XZfLsyehXB9Hcyg4HcNwSvnSfOej7lbVrxaSfDBelGcDEX5nqBNAMVMy58dx9awBM/yWqLk1oV/RZ0vggFNNfQcmJ1ENXvHgbP1pmBspOk/nW3g9Lg78oslz14IRTIi48MDJ088FCJu1wGh2rl5NIq7k1y706VDLaHp1AWXdLwN9w2H98aVa32iimRc8uCdXk3LTtpJ+OEmtX/v5ffnW7FP12HG14o7tJ+zgibaD93rcSi+6gd49THmnBMV64ynxe4fAfBE7r5Pc46V5NzM3DpDS5t3UCTHt3/8euxmxjNfwTtJ3faW87lbjhqDqjtX/PnDXwPmOOLlxCnuUmXi56Bn+dR2R3BuVNqzZbnlf41WBtNqY9mEXS46pii7SfO+BptqNSvDZzY+WiOp6dHOHvsfRkgr4REjsexvoNWZiqVuqv2ybuR60wjvr3YjXB19SI+A4m6Y3/D43QSc2+pkRcRiQBnpF
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199015)(46966006)(36840700001)(40470700004)(6666004)(7696005)(316002)(54906003)(30864003)(110136005)(478600001)(66899015)(8936002)(2906002)(8676002)(4326008)(2616005)(70586007)(70206006)(336012)(186003)(41300700001)(16526019)(83380400001)(426003)(5660300002)(7416002)(47076005)(36756003)(40480700001)(36860700001)(86362001)(26005)(82310400005)(82740400003)(81166007)(40460700003)(356005)(921005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 11:10:52.6125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66af9d5d-ffb6-48e1-ad29-08dadcfab2de
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C97B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7668
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
v2:
 * Removed references to dma_buffer.
 * If psp_init() fails, clear reference to master device.
 * Handle gfp flags within psp_tee_alloc_buffer() instead of passing it as
   a function argument.
 * Added comments within psp_tee_alloc_buffer() to serve as future
   documentation.

 drivers/crypto/ccp/psp-dev.c |  13 ++--
 drivers/crypto/ccp/tee-dev.c | 124 +++++++++++++++++++++++------------
 drivers/crypto/ccp/tee-dev.h |   9 +--
 include/linux/psp-tee.h      |  49 ++++++++++++++
 4 files changed, 142 insertions(+), 53 deletions(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index c9c741ac8442..380f5caaa550 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -161,13 +161,13 @@ int psp_dev_init(struct sp_device *sp)
 		goto e_err;
 	}

-	ret = psp_init(psp);
-	if (ret)
-		goto e_irq;
-
 	if (sp->set_psp_master_device)
 		sp->set_psp_master_device(sp);

+	ret = psp_init(psp);
+	if (ret)
+		goto e_clear;
+
 	/* Enable interrupt */
 	iowrite32(-1, psp->io_regs + psp->vdata->inten_reg);

@@ -175,7 +175,10 @@ int psp_dev_init(struct sp_device *sp)

 	return 0;

-e_irq:
+e_clear:
+	if (sp->clear_psp_master_device)
+		sp->clear_psp_master_device(sp);
+
 	sp_free_psp_irq(psp->sp, psp);
 e_err:
 	sp->psp_data = NULL;
diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 5c9d47f3be37..5c43e6e166f1 100644
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
@@ -21,25 +22,73 @@

 static bool psp_dead;

+struct psp_tee_buffer *psp_tee_alloc_buffer(unsigned long size)
+{
+	struct psp_device *psp = psp_get_master_device();
+	struct psp_tee_buffer *buf;
+	struct iommu_domain *dom;
+
+	if (!psp || !size)
+		return NULL;
+
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	/* The pages allocated for PSP Trusted OS must be physically
+	 * contiguous in host (or machine) address space. Therefore,
+	 * use DMA API to allocate memory.
+	 */
+
+	buf->vaddr = dma_alloc_coherent(psp->dev, size, &buf->dma,
+					GFP_KERNEL | __GFP_ZERO);
+	if (!buf->vaddr || !buf->dma) {
+		kfree(buf);
+		return NULL;
+	}
+
+	buf->size = size;
+
+	/* Check whether IOMMU is present. If present, convert IOVA to
+	 * physical address. In the absence of IOMMU, the DMA address
+	 * is actually the physical address.
+	 */
+
+	dom = iommu_get_domain_for_dev(psp->dev);
+	if (dom)
+		buf->paddr = iommu_iova_to_phys(dom, buf->dma);
+	else
+		buf->paddr = buf->dma;
+
+	return buf;
+}
+EXPORT_SYMBOL(psp_tee_alloc_buffer);
+
+void psp_tee_free_buffer(struct psp_tee_buffer *buf)
+{
+	struct psp_device *psp = psp_get_master_device();
+
+	if (!psp || !buf)
+		return;
+
+	dma_free_coherent(psp->dev, buf->size, buf->vaddr, buf->dma);
+
+	kfree(buf);
+}
+EXPORT_SYMBOL(psp_tee_free_buffer);
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
+	rb_mgr->ring_buf = psp_tee_alloc_buffer(ring_size);
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
@@ -49,15 +98,8 @@ static void tee_free_ring(struct psp_tee_device *tee)
 {
 	struct ring_buf_manager *rb_mgr = &tee->rb_mgr;

-	if (!rb_mgr->ring_start)
-		return;
-
-	free_pages((unsigned long)rb_mgr->ring_start,
-		   get_order(rb_mgr->ring_size));
+	psp_tee_free_buffer(rb_mgr->ring_buf);

-	rb_mgr->ring_start = NULL;
-	rb_mgr->ring_size = 0;
-	rb_mgr->ring_pa = 0;
 	mutex_destroy(&rb_mgr->mutex);
 }

@@ -81,35 +123,35 @@ static int tee_wait_cmd_poll(struct psp_tee_device *tee, unsigned int timeout,
 	return -ETIMEDOUT;
 }

-static
-struct tee_init_ring_cmd *tee_alloc_cmd_buffer(struct psp_tee_device *tee)
+static struct psp_tee_buffer *tee_alloc_cmd_buffer(struct psp_tee_device *tee)
 {
+	struct psp_tee_buffer *cmd_buffer;
 	struct tee_init_ring_cmd *cmd;

-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (!cmd)
+	cmd_buffer = psp_tee_alloc_buffer(sizeof(*cmd));
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
+static inline void tee_free_cmd_buffer(struct psp_tee_buffer *cmd_buffer)
 {
-	kfree(cmd);
+	psp_tee_free_buffer(cmd_buffer);
 }

 static int tee_init_ring(struct psp_tee_device *tee)
 {
 	int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
-	struct tee_init_ring_cmd *cmd;
-	phys_addr_t cmd_buffer;
+	struct psp_tee_buffer *cmd_buffer;
 	unsigned int reg;
 	int ret;

@@ -123,21 +165,19 @@ static int tee_init_ring(struct psp_tee_device *tee)

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
@@ -157,7 +197,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
 	}

 free_buf:
-	tee_free_cmd_buffer(cmd);
+	tee_free_cmd_buffer(cmd_buffer);

 	return ret;
 }
@@ -167,7 +207,7 @@ static void tee_destroy_ring(struct psp_tee_device *tee)
 	unsigned int reg;
 	int ret;

-	if (!tee->rb_mgr.ring_start)
+	if (!tee->rb_mgr.ring_buf->vaddr)
 		return;

 	if (psp_dead)
@@ -256,7 +296,7 @@ static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,
 	do {
 		/* Get pointer to ring buffer command entry */
 		cmd = (struct tee_ring_cmd *)
-			(tee->rb_mgr.ring_start + tee->rb_mgr.wptr);
+			(tee->rb_mgr.ring_buf->vaddr + tee->rb_mgr.wptr);

 		rptr = ioread32(tee->io_regs + tee->vdata->ring_rptr_reg);

@@ -305,7 +345,7 @@ static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,

 	/* Update local copy of write pointer */
 	tee->rb_mgr.wptr += sizeof(struct tee_ring_cmd);
-	if (tee->rb_mgr.wptr >= tee->rb_mgr.ring_size)
+	if (tee->rb_mgr.wptr >= tee->rb_mgr.ring_buf->size)
 		tee->rb_mgr.wptr = 0;

 	/* Trigger interrupt to Trusted OS */
diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
index 49d26158b71e..ee22d60177a2 100644
--- a/drivers/crypto/ccp/tee-dev.h
+++ b/drivers/crypto/ccp/tee-dev.h
@@ -16,6 +16,7 @@

 #include <linux/device.h>
 #include <linux/mutex.h>
+#include <linux/psp-tee.h>

 #define TEE_DEFAULT_TIMEOUT		10
 #define MAX_BUFFER_SIZE			988
@@ -48,16 +49,12 @@ struct tee_init_ring_cmd {

 /**
  * struct ring_buf_manager - Helper structure to manage ring buffer.
- * @ring_start:  starting address of ring buffer
- * @ring_size:   size of ring buffer in bytes
- * @ring_pa:     physical address of ring buffer
+ * @ring_buf:    ring buffer allocated for sharing with TEE
  * @wptr:        index to the last written entry in ring buffer
  */
 struct ring_buf_manager {
 	struct mutex mutex;	/* synchronizes access to ring buffer */
-	void *ring_start;
-	u32 ring_size;
-	phys_addr_t ring_pa;
+	struct psp_tee_buffer *ring_buf;
 	u32 wptr;
 };

diff --git a/include/linux/psp-tee.h b/include/linux/psp-tee.h
index cb0c95d6d76b..670bb7877456 100644
--- a/include/linux/psp-tee.h
+++ b/include/linux/psp-tee.h
@@ -13,6 +13,7 @@

 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/dma-mapping.h>

 /* This file defines the Trusted Execution Environment (TEE) interface commands
  * and the API exported by AMD Secure Processor driver to communicate with
@@ -40,6 +41,22 @@ enum tee_cmd_id {
 	TEE_CMD_ID_UNMAP_SHARED_MEM,
 };

+/**
+ * struct psp_tee_buffer - Structure that has buffer details of memory that can
+ * be shared with PSP TEE.
+ *
+ * @dma:    DMA address of memory
+ * @paddr:  Physical address of memory
+ * @vaddr:  CPU virtual address of memory
+ * @size:   Size of memory in bytes
+ */
+struct psp_tee_buffer {
+	dma_addr_t dma;
+	phys_addr_t paddr;
+	void *vaddr;
+	unsigned long size;
+};
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 /**
  * psp_tee_process_cmd() - Process command in Trusted Execution Environment
@@ -75,6 +92,28 @@ int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf, size_t len,
  */
 int psp_check_tee_status(void);

+/**
+ * psp_tee_alloc_buffer() - Allocates memory of requested size using
+ * dma_alloc_coherent() API.
+ *
+ * This function can be used to allocate a shared memory region between the
+ * host and PSP TEE.
+ *
+ * Returns:
+ * non-NULL   a valid pointer to struct psp_tee_buffer
+ * NULL       on failure
+ */
+struct psp_tee_buffer *psp_tee_alloc_buffer(unsigned long size);
+
+/**
+ * psp_tee_free_buffer() - Deallocates memory using dma_free_coherent() API.
+ *
+ * This function can be used to release shared memory region between host
+ * and PSP TEE.
+ *
+ */
+void psp_tee_free_buffer(struct psp_tee_buffer *buffer);
+
 #else /* !CONFIG_CRYPTO_DEV_SP_PSP */

 static inline int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf,
@@ -87,5 +126,15 @@ static inline int psp_check_tee_status(void)
 {
 	return -ENODEV;
 }
+
+static inline
+struct psp_tee_buffer *psp_tee_alloc_buffer(unsigned long size)
+{
+	return NULL;
+}
+
+static inline void psp_tee_free_buffer(struct psp_tee_buffer *buffer)
+{
+}
 #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
 #endif /* __PSP_TEE_H_ */
--
2.25.1

