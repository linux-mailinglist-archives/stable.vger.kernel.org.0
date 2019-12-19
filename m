Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF632125D30
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 10:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLSJDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 04:03:32 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49557 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726609AbfLSJDb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 04:03:31 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 929322236F;
        Thu, 19 Dec 2019 04:03:30 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 19 Dec 2019 04:03:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7Q1gEJ
        Jkf+6Q+8SlZxIB/VoOSuU3aY0e0hvG9dLxPTQ=; b=UXdJmGkuxKMn5KGERV37Qp
        urbE3RF5OtJKhCYMhPL/WVGDIKzs6m2Gulst5WzEqyi2b5XgQDhXCtsUqLePc3NY
        y17FamHqgOgtjvb0/5NQNJybVKZCkAyvFxcmHxY75OFeweQK5r+4GMtFjHIcy/LB
        AN5GSq8mVI8EQRF/AfRTjXV/KZKa3jXFUBLHnnnu3d5jKsJrXamspWY3Nkwn3qSZ
        UfZMNCPsY+f/fIzk+p3BDI5Qpy2azasLHT039y+TbSVz4LHF53fvx29X1ZHdLj5+
        59xuit+09zdDYLGx2h4xsmHZeOXFjt/x4nmWEzI2GK7CrCeSOP6N0hysUzGM/TAg
        ==
X-ME-Sender: <xms:4Tz7Xb49mGoKSdLHb9--gnU1mxhXNP4FVn6B-VLt5fv48WDzrzYUgw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdduudcutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttdflne
    cuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgqeen
    ucffohhmrghinheprhgvnhgvshgrshdrtghomhdptghfihhnihhtrdhtohenucfkphepke
    efrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhr
    ohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:4Tz7XXUfPeP1I1DGKw4KL9heCuNZPihUCybJbb9fvezPghrsYFtedQ>
    <xmx:4Tz7Xf82NOu7jPf9G-zQJm1H8Ohrrz6h-dUV9Y0loWQwMTiSR5jqqw>
    <xmx:4Tz7XUiScmKM6yJkRmIc5Q73M3EsrsIlAS3uoE_znAj1tqopeq-Bqw>
    <xmx:4jz7XcyMiil6eyrq_-JptgBROeRKWrhwFPoQ_ZwZVfLW28t8U6q7eg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 23DA480060;
        Thu, 19 Dec 2019 04:03:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] PCI: rcar: Fix missing MACCTLR register setting in" failed to apply to 4.19-stable tree
To:     yoshihiro.shimoda.uh@renesas.com, erosca@de.adit-jv.com,
        geert+renesas@glider.be, lorenzo.pieralisi@arm.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 19 Dec 2019 10:03:27 +0100
Message-ID: <1576746207205192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7c7e53e1c93df14690bd12c1f84730fef927a6f1 Mon Sep 17 00:00:00 2001
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Tue, 5 Nov 2019 19:51:29 +0900
Subject: [PATCH] PCI: rcar: Fix missing MACCTLR register setting in
 initialization sequence

The R-Car Gen2/3 manual - available at:

https://www.renesas.com/eu/en/products/microcontrollers-microprocessors/rz/rzg/rzg1m.html#documents

"RZ/G Series User's Manual: Hardware" section

strictly enforces the MACCTLR inizialization value - 39.3.1 - "Initial
Setting of PCI Express":

"Be sure to write the initial value (= H'80FF 0000) to MACCTLR before
enabling PCIETCTLR.CFINIT".

To avoid unexpected behavior and to match the SW initialization sequence
guidelines, this patch programs the MACCTLR with the correct value.

Note that the MACCTLR.SPCHG bit in the MACCTLR register description
reports that "Only writing 1 is valid and writing 0 is invalid" but this
"invalid" has to be interpreted as a write-ignore aka "ignored", not
"prohibited".

Reported-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Fixes: c25da4778803 ("PCI: rcar: Add Renesas R-Car PCIe driver")
Fixes: be20bbcb0a8c ("PCI: rcar: Add the initialization of PCIe link in resume_noirq()")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: <stable@vger.kernel.org> # v5.2+

diff --git a/drivers/pci/controller/pcie-rcar.c b/drivers/pci/controller/pcie-rcar.c
index 40d8c54a17d1..94ba4fe21923 100644
--- a/drivers/pci/controller/pcie-rcar.c
+++ b/drivers/pci/controller/pcie-rcar.c
@@ -91,8 +91,11 @@
 #define  LINK_SPEED_2_5GTS	(1 << 16)
 #define  LINK_SPEED_5_0GTS	(2 << 16)
 #define MACCTLR			0x011058
+#define  MACCTLR_NFTS_MASK	GENMASK(23, 16)	/* The name is from SH7786 */
 #define  SPEED_CHANGE		BIT(24)
 #define  SCRAMBLE_DISABLE	BIT(27)
+#define  LTSMDIS		BIT(31)
+#define  MACCTLR_INIT_VAL	(LTSMDIS | MACCTLR_NFTS_MASK)
 #define PMSR			0x01105c
 #define MACS2R			0x011078
 #define MACCGSPSETR		0x011084
@@ -613,6 +616,8 @@ static int rcar_pcie_hw_init(struct rcar_pcie *pcie)
 	if (IS_ENABLED(CONFIG_PCI_MSI))
 		rcar_pci_write_reg(pcie, 0x801f0000, PCIEMSITXR);
 
+	rcar_pci_write_reg(pcie, MACCTLR_INIT_VAL, MACCTLR);
+
 	/* Finish initialization - establish a PCI Express link */
 	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
 
@@ -1235,6 +1240,7 @@ static int rcar_pcie_resume_noirq(struct device *dev)
 		return 0;
 
 	/* Re-establish the PCIe link */
+	rcar_pci_write_reg(pcie, MACCTLR_INIT_VAL, MACCTLR);
 	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
 	return rcar_pcie_wait_for_dl(pcie);
 }

