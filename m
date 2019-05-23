Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFFA827B07
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 12:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfEWKs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 06:48:27 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52649 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726310AbfEWKs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 06:48:26 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B2A9E37380;
        Thu, 23 May 2019 06:48:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 23 May 2019 06:48:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=G4rKGU
        xPDvHXm0G976FZEL5+sKXuxCRt1PJwVzuQ4oQ=; b=Pppdx97JbQAuWVduBaP1iO
        PD39zy3UklYqiWBOD3pNswRdlvJSLtns/g3hLaBhZlaS57l3M4kF3/pipOCRlWk3
        +mLRkrnvZAE9vUn8JGC2es+NSYp4daAVJpRzTLbLiJA4xmLP3Yvb5J+5EbMzp2hZ
        AA3ZDxOsf841vOcn6nUMrOfdF7JJAXMHC3kMWndaRoVM0yo3wScC08tyzmlwJ7/m
        i+IcBqLR7K0abhsNRZ/bs5m2x8dWFdDA6hNPUPkXcpy4jS5EsedMWEHM+vTEMSm/
        jpGMHcKNleAgigQ57ONbw0txQCDw2Ed9wm9F/r/qlBqoOZX2tJdHjj5jhTlDb55g
        ==
X-ME-Sender: <xms:d3rmXOBZwPK8aAChK8SvwDnUn4D7SisPz17TFJUKWpKmkT7uIxWRLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:d3rmXPNVYck09YI514_SBaZ3UCwXIUwjoGkZrDBoOVq8t0qR3RqNsg>
    <xmx:d3rmXGA_XAl0hG9zY4N5M40c15_ArYbKuaKIqcvX3f_seswjfl_gqw>
    <xmx:d3rmXK-K97wYGTVm7GW6EQ6w4ZCSLIrIuMehl6JEqQZopEIm0h0RNg>
    <xmx:eXrmXJtWz_oCUAJHTV8iCdQyis6ABnw5xD_4M8cczeFSnWhdBbQotA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D1832380083;
        Thu, 23 May 2019 06:48:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: rcar: Add the initialization of PCIe link in" failed to apply to 4.14-stable tree
To:     kaz-ikeda@xc.jp.nec.com, gaku.inami.xw@bp.renesas.com,
        geert+renesas@glider.be, horms+renesas@verge.net.au,
        lorenzo.pieralisi@arm.com, marek.vasut+renesas@gmail.com,
        phil.edworthy@renesas.com, wsa+renesas@sang-engineering.com,
        wsa@the-dreams.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 May 2019 12:48:20 +0200
Message-ID: <155860850020184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From be20bbcb0a8cb5597cc62b3e28d275919f3431df Mon Sep 17 00:00:00 2001
From: Kazufumi Ikeda <kaz-ikeda@xc.jp.nec.com>
Date: Mon, 25 Mar 2019 20:43:19 +0100
Subject: [PATCH] PCI: rcar: Add the initialization of PCIe link in
 resume_noirq()

Reestablish the PCIe link very early in the resume process in case it
went down to prevent PCI accesses from hanging the bus. Such accesses
can happen early in the PCI resume process, as early as the
SUSPEND_RESUME_NOIRQ step, thus the link must be reestablished in the
driver resume_noirq() callback.

Fixes: e015f88c368d ("PCI: rcar: Add support for R-Car H3 to pcie-rcar")
Signed-off-by: Kazufumi Ikeda <kaz-ikeda@xc.jp.nec.com>
Signed-off-by: Gaku Inami <gaku.inami.xw@bp.renesas.com>
Signed-off-by: Marek Vasut <marek.vasut+renesas@gmail.com>
[lorenzo.pieralisi@arm.com: reformatted commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: stable@vger.kernel.org
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Phil Edworthy <phil.edworthy@renesas.com>
Cc: Simon Horman <horms+renesas@verge.net.au>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-renesas-soc@vger.kernel.org

diff --git a/drivers/pci/controller/pcie-rcar.c b/drivers/pci/controller/pcie-rcar.c
index c8febb009454..6a4e435bd35f 100644
--- a/drivers/pci/controller/pcie-rcar.c
+++ b/drivers/pci/controller/pcie-rcar.c
@@ -46,6 +46,7 @@
 
 /* Transfer control */
 #define PCIETCTLR		0x02000
+#define  DL_DOWN		BIT(3)
 #define  CFINIT			1
 #define PCIETSTR		0x02004
 #define  DATA_LINK_ACTIVE	1
@@ -94,6 +95,7 @@
 #define MACCTLR			0x011058
 #define  SPEED_CHANGE		BIT(24)
 #define  SCRAMBLE_DISABLE	BIT(27)
+#define PMSR			0x01105c
 #define MACS2R			0x011078
 #define MACCGSPSETR		0x011084
 #define  SPCNGRSN		BIT(31)
@@ -1130,6 +1132,7 @@ static int rcar_pcie_probe(struct platform_device *pdev)
 	pcie = pci_host_bridge_priv(bridge);
 
 	pcie->dev = dev;
+	platform_set_drvdata(pdev, pcie);
 
 	err = pci_parse_request_of_pci_ranges(dev, &pcie->resources, NULL);
 	if (err)
@@ -1221,10 +1224,28 @@ static int rcar_pcie_probe(struct platform_device *pdev)
 	return err;
 }
 
+static int rcar_pcie_resume_noirq(struct device *dev)
+{
+	struct rcar_pcie *pcie = dev_get_drvdata(dev);
+
+	if (rcar_pci_read_reg(pcie, PMSR) &&
+	    !(rcar_pci_read_reg(pcie, PCIETCTLR) & DL_DOWN))
+		return 0;
+
+	/* Re-establish the PCIe link */
+	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
+	return rcar_pcie_wait_for_dl(pcie);
+}
+
+static const struct dev_pm_ops rcar_pcie_pm_ops = {
+	.resume_noirq = rcar_pcie_resume_noirq,
+};
+
 static struct platform_driver rcar_pcie_driver = {
 	.driver = {
 		.name = "rcar-pcie",
 		.of_match_table = rcar_pcie_of_match,
+		.pm = &rcar_pcie_pm_ops,
 		.suppress_bind_attrs = true,
 	},
 	.probe = rcar_pcie_probe,

