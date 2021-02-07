Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1299731255C
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 16:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBGPbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 10:31:47 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:42649 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229646AbhBGPbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Feb 2021 10:31:45 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id 00DA4194039F;
        Sun,  7 Feb 2021 10:30:58 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 07 Feb 2021 10:30:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LKb2dF
        HaQNyXfBCb4PErzmHOllc8D1GOMpOnLpGJTJw=; b=QBd0IEGPf5mYdx/6whTv+0
        /uBr41QLHTaWAWl6zRZgkdyrw9RMMpzQnJ4jq4R3mdWtFqe1Ob3WZl9fjK3+Fb+B
        D18SDPX2nvVqxVNz9DDRf/gUyXKHstcCJfaD/6zq7ntRPaafdKK83q8VWIirjUXS
        VBidJR9HQehIqze+CH6UyXQJOL+Vf02XNSq/QPfJf0F0VwGqlvaIW4CFsPPuBvmi
        Jgq1K2zK65NxWsSy/H737GoL9eRJOXLmx5wVvJIajPLNTJLb00Uvea0oL53LxHiZ
        w/T0F2QU+xwX+IB/BX8J/ME7DJ7UPaV6juiz37WisGEr3VI374CiiA1SxdK+ZBqQ
        ==
X-ME-Sender: <xms:sAcgYMKf1W1wYV_RWs-zbXp3wIA0VCDtiPwhXJo6s5oJZ49LeWPv1A>
    <xme:sAcgYOK8d7ADmQe8FAAJtJxuye5n1G8bv3b4OWDXmge2ObREPL9umuT4NfKm1PkR7
    p1W3fuUDJ-OaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedugdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekjefgffetgfevgeeghedugfelheektdehtdeihfeile
    eiteevjedvgfdvleejleenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:sQcgYGH5eztgmBHuGHx8LCKRsvI_zjqdMhP77aSs4slyuJeQ0odm1g>
    <xmx:sQcgYLlJZ1rSA7wTqZ1NyDtwxNUeJmBp2LxBv-0d5oCoavwtJLSG4g>
    <xmx:sQcgYLKGbXDGje38oMeXUa_-puEfinJqJ3jI5g_FCYOxBJejdR_ZEg>
    <xmx:sQcgYAWsPlXuueETH9Vs-z2XBfXa9BY5QheRpqTvWm3vroXoSnfIYw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A69BF1080057;
        Sun,  7 Feb 2021 10:30:56 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: host: xhci: mvebu: make USB 3.0 PHY optional for Armada" failed to apply to 5.4-stable tree
To:     pali@kernel.org, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org,
        tmn505@gmail.com, yoshihiro.shimoda.uh@renesas.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Feb 2021 16:30:54 +0100
Message-ID: <1612711854148237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3241929b67d28c83945d3191c6816a3271fd6b85 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Mon, 1 Feb 2021 16:08:03 +0100
Subject: [PATCH] usb: host: xhci: mvebu: make USB 3.0 PHY optional for Armada
 3720
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Older ATF does not provide SMC call for USB 3.0 phy power on functionality
and therefore initialization of xhci-hcd is failing when older version of
ATF is used. In this case phy_power_on() function returns -EOPNOTSUPP.

[    3.108467] mvebu-a3700-comphy d0018300.phy: unsupported SMC call, try updating your firmware
[    3.117250] phy phy-d0018300.phy.0: phy poweron failed --> -95
[    3.123465] xhci-hcd: probe of d0058000.usb failed with error -95

This patch introduces a new plat_setup callback for xhci platform drivers
which is called prior calling usb_add_hcd() function. This function at its
beginning skips PHY init if hcd->skip_phy_initialization is set.

Current init_quirk callback for xhci platform drivers is called from
xhci_plat_setup() function which is called after chip reset completes.
It happens in the middle of the usb_add_hcd() function and therefore this
callback cannot be used for setting if PHY init should be skipped or not.

For Armada 3720 this patch introduce a new xhci_mvebu_a3700_plat_setup()
function configured as a xhci platform plat_setup callback. This new
function calls phy_power_on() and in case it returns -EOPNOTSUPP then
XHCI_SKIP_PHY_INIT quirk is set to instruct xhci-plat to skip PHY
initialization.

This patch fixes above failure by ignoring 'not supported' error in
xhci-hcd driver. In this case it is expected that phy is already power on.

It fixes initialization of xhci-hcd on Espressobin boards where is older
Marvell's Arm Trusted Firmware without SMC call for USB 3.0 phy power.

This is regression introduced in commit bd3d25b07342 ("arm64: dts: marvell:
armada-37xx: link USB hosts with their PHYs") where USB 3.0 phy was defined
and therefore xhci-hcd on Espressobin with older ATF started failing.

Fixes: bd3d25b07342 ("arm64: dts: marvell: armada-37xx: link USB hosts with their PHYs")
Cc: <stable@vger.kernel.org> # 5.1+: ea17a0f153af: phy: marvell: comphy: Convert internal SMCC firmware return codes to errno
Cc: <stable@vger.kernel.org> # 5.1+: f768e718911e: usb: host: xhci-plat: add priv quirk for skip PHY initialization
Tested-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com> # On R-Car
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com> # xhci-plat
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20210201150803.7305-1-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/host/xhci-mvebu.c b/drivers/usb/host/xhci-mvebu.c
index 60651a50770f..8ca1a235d164 100644
--- a/drivers/usb/host/xhci-mvebu.c
+++ b/drivers/usb/host/xhci-mvebu.c
@@ -8,6 +8,7 @@
 #include <linux/mbus.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/phy/phy.h>
 
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
@@ -74,6 +75,47 @@ int xhci_mvebu_mbus_init_quirk(struct usb_hcd *hcd)
 	return 0;
 }
 
+int xhci_mvebu_a3700_plat_setup(struct usb_hcd *hcd)
+{
+	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
+	struct device *dev = hcd->self.controller;
+	struct phy *phy;
+	int ret;
+
+	/* Old bindings miss the PHY handle */
+	phy = of_phy_get(dev->of_node, "usb3-phy");
+	if (IS_ERR(phy) && PTR_ERR(phy) == -EPROBE_DEFER)
+		return -EPROBE_DEFER;
+	else if (IS_ERR(phy))
+		goto phy_out;
+
+	ret = phy_init(phy);
+	if (ret)
+		goto phy_put;
+
+	ret = phy_set_mode(phy, PHY_MODE_USB_HOST_SS);
+	if (ret)
+		goto phy_exit;
+
+	ret = phy_power_on(phy);
+	if (ret == -EOPNOTSUPP) {
+		/* Skip initializatin of XHCI PHY when it is unsupported by firmware */
+		dev_warn(dev, "PHY unsupported by firmware\n");
+		xhci->quirks |= XHCI_SKIP_PHY_INIT;
+	}
+	if (ret)
+		goto phy_exit;
+
+	phy_power_off(phy);
+phy_exit:
+	phy_exit(phy);
+phy_put:
+	of_phy_put(phy);
+phy_out:
+
+	return 0;
+}
+
 int xhci_mvebu_a3700_init_quirk(struct usb_hcd *hcd)
 {
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
diff --git a/drivers/usb/host/xhci-mvebu.h b/drivers/usb/host/xhci-mvebu.h
index 3be021793cc8..01bf3fcb3eca 100644
--- a/drivers/usb/host/xhci-mvebu.h
+++ b/drivers/usb/host/xhci-mvebu.h
@@ -12,6 +12,7 @@ struct usb_hcd;
 
 #if IS_ENABLED(CONFIG_USB_XHCI_MVEBU)
 int xhci_mvebu_mbus_init_quirk(struct usb_hcd *hcd);
+int xhci_mvebu_a3700_plat_setup(struct usb_hcd *hcd);
 int xhci_mvebu_a3700_init_quirk(struct usb_hcd *hcd);
 #else
 static inline int xhci_mvebu_mbus_init_quirk(struct usb_hcd *hcd)
@@ -19,6 +20,11 @@ static inline int xhci_mvebu_mbus_init_quirk(struct usb_hcd *hcd)
 	return 0;
 }
 
+static inline int xhci_mvebu_a3700_plat_setup(struct usb_hcd *hcd)
+{
+	return 0;
+}
+
 static inline int xhci_mvebu_a3700_init_quirk(struct usb_hcd *hcd)
 {
 	return 0;
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 4d34f6005381..c1edcc9b13ce 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -44,6 +44,16 @@ static void xhci_priv_plat_start(struct usb_hcd *hcd)
 		priv->plat_start(hcd);
 }
 
+static int xhci_priv_plat_setup(struct usb_hcd *hcd)
+{
+	struct xhci_plat_priv *priv = hcd_to_xhci_priv(hcd);
+
+	if (!priv->plat_setup)
+		return 0;
+
+	return priv->plat_setup(hcd);
+}
+
 static int xhci_priv_init_quirk(struct usb_hcd *hcd)
 {
 	struct xhci_plat_priv *priv = hcd_to_xhci_priv(hcd);
@@ -111,6 +121,7 @@ static const struct xhci_plat_priv xhci_plat_marvell_armada = {
 };
 
 static const struct xhci_plat_priv xhci_plat_marvell_armada3700 = {
+	.plat_setup = xhci_mvebu_a3700_plat_setup,
 	.init_quirk = xhci_mvebu_a3700_init_quirk,
 };
 
@@ -330,7 +341,14 @@ static int xhci_plat_probe(struct platform_device *pdev)
 
 	hcd->tpl_support = of_usb_host_tpl_support(sysdev->of_node);
 	xhci->shared_hcd->tpl_support = hcd->tpl_support;
-	if (priv && (priv->quirks & XHCI_SKIP_PHY_INIT))
+
+	if (priv) {
+		ret = xhci_priv_plat_setup(hcd);
+		if (ret)
+			goto disable_usb_phy;
+	}
+
+	if ((xhci->quirks & XHCI_SKIP_PHY_INIT) || (priv && (priv->quirks & XHCI_SKIP_PHY_INIT)))
 		hcd->skip_phy_initialization = 1;
 
 	if (priv && (priv->quirks & XHCI_SG_TRB_CACHE_SIZE_QUIRK))
diff --git a/drivers/usb/host/xhci-plat.h b/drivers/usb/host/xhci-plat.h
index 1fb149d1fbce..561d0b7bce09 100644
--- a/drivers/usb/host/xhci-plat.h
+++ b/drivers/usb/host/xhci-plat.h
@@ -13,6 +13,7 @@
 struct xhci_plat_priv {
 	const char *firmware_name;
 	unsigned long long quirks;
+	int (*plat_setup)(struct usb_hcd *);
 	void (*plat_start)(struct usb_hcd *);
 	int (*init_quirk)(struct usb_hcd *);
 	int (*suspend_quirk)(struct usb_hcd *);

