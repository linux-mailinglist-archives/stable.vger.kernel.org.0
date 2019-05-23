Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D986027B09
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 12:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbfEWKsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 06:48:33 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33039 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726310AbfEWKsc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 06:48:32 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B735D373EB;
        Thu, 23 May 2019 06:48:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 23 May 2019 06:48:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=MrSeWr
        Kp5zmemEeRakRMQCHHFN+3hjHn/foB4w6G0GM=; b=vu6qxNPpuZHb8sTvHoSY0j
        y4Hl9mDCiBa8Bjg0n9Kdx/F6bidcGl0rVl3zFi/87Jl7EqwtxHWm9qSMYHKj4MN5
        UHoYATjPRjl5hLmtLD/QjT/BxTRxOxb4i78/oYykRy87+jKB2W76Pt4AWfblvT5X
        19mmVuRuRp165nO4/O0vaMl6BjsrIN9qDy5EAseia5lwV8wyX250bE0XokMuS4Z1
        SEawHswBYz79OF+Cgva6jXqKK+cN8cAXq0ZZzQYZqrZ6NTYKQkbBwx91xGQ+XCLZ
        XfbgWf4tXCuIAuxwWpbndIiCD5mntjmZ8aKXHAQeZbsOLwgbuv4DzVKqNDQXN6VA
        ==
X-ME-Sender: <xms:f3rmXNzHO2XHANwyHNWyDniVo_1G8eJIntlEg0R7EvXqwkaarHEJdQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:f3rmXIVnyDwC5jR9QbUGQ9QzdoBxjdllX6RT73QF7vUt-GNkisYsFw>
    <xmx:f3rmXPYgdowvWhhscRyMO_NhmHne1K1sm_BHqgt6S7H9dA29u5MNcA>
    <xmx:f3rmXBxGGVNWxAW4d2Pvv9WA3Mgj557eM8h2tZVmzHjzhNZNA6skew>
    <xmx:f3rmXBVyx-mvUZvT3vSHcjD_IfRQqsrMaJOooF7b_PL7D9L5vavujQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1AD308005A;
        Thu, 23 May 2019 06:48:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: rcar: Add the initialization of PCIe link in" failed to apply to 4.9-stable tree
To:     kaz-ikeda@xc.jp.nec.com, gaku.inami.xw@bp.renesas.com,
        geert+renesas@glider.be, horms+renesas@verge.net.au,
        lorenzo.pieralisi@arm.com, marek.vasut+renesas@gmail.com,
        phil.edworthy@renesas.com, wsa+renesas@sang-engineering.com,
        wsa@the-dreams.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 May 2019 12:48:21 +0200
Message-ID: <1558608501190210@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

