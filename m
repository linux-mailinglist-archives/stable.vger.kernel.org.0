Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A445338C7B
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbhCLMPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:15:23 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:50847 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230398AbhCLMPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 07:15:07 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 98A901942C96;
        Fri, 12 Mar 2021 07:15:06 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 12 Mar 2021 07:15:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TQ0753
        elvstePirKYU6em1Wc0oNysK9dgl4vF7M6cPA=; b=V6EWkWePZunCC1JlCrT1Wt
        B+Si6BiwrNG0XF4vzm/tAfQXGo6c8Pdg/MBfAo9iLhwhGzH5Yq0av0YLnbwkFKRQ
        n61FUDI1L8HMb85//uclzXrgvL6/vmYJ38o7NErUEtZXPThMErls/eUCmNCNuZft
        4ONnYnNav8ODMacvUD84wpt73F8vUbCPdF9jmBa1ebYYNpDf0PpsDtQF2w4ZfVqI
        TvhwVQWYcYCv0uHfQrsbG5161Fpi69Rp272/D/A0FcEmp4rpTAH+lLIzqAsFfnKu
        kVF5mMZWg24Ygz0j2Hy4k+x8EQZyvdDtWU00d8qdIeO91xmxbj/0QW6FhjN5DoLA
        ==
X-ME-Sender: <xms:SltLYPSgwzmTSfw6TQrY7a4fATBM8HYN2Xo4rVQoRHuwhjKW8_Xlbw>
    <xme:SltLYAzczJuhuc8ZgEiV0wtzR9dYQORqrcKX6veHElKynoiuPoPpH-P6voWsYWyfw
    qutsy8FvnKM9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvvddgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdljedmnecujfgurhepuffvhf
    ffkfggtgfgsehtkeertddttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhho
    uhhnuggrthhiohhnrdhorhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvd
    eiieehheefleevveehjeduteevueevledujeejgfetheenucfkphepkeefrdekiedrjeeg
    rdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:SltLYE3RXJ5n-CWh69SOAHMdkEVxQ4dtuTKDU74606FbnMhBSPgg1w>
    <xmx:SltLYPC3b88-XTzRB0xdtXkvsZepdMoioudpncuUt2k6cVK5lV9htw>
    <xmx:SltLYIi1Vp-wxl78EUUmQdqjsWQ3JWF3PdruAaDulpy0A6jjgeanvg>
    <xmx:SltLYLvrX9ZW0kRKNXn2-YUarTy0n5UQsI_wp9oL2i_j2yXIs5kfWg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 124291080066;
        Fri, 12 Mar 2021 07:15:05 -0500 (EST)
Subject: FAILED: patch "[PATCH] net: enetc: initialize RFS/RSS memories for unused ports too" failed to apply to 5.10-stable tree
To:     vladimir.oltean@nxp.com, davem@davemloft.net,
        jesse.brandeburg@intel.com, michael@walle.cc
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Mar 2021 13:14:56 +0100
Message-ID: <16155512967616@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3222b5b613db558e9a494bbf53f3c984d90f71ea Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Mon, 1 Mar 2021 13:18:12 +0200
Subject: [PATCH] net: enetc: initialize RFS/RSS memories for unused ports too

Michael reports that since linux-next-20210211, the AER messages for ECC
errors have started reappearing, and this time they can be reliably
reproduced with the first ping on one of his LS1028A boards.

$ ping 1[   33.258069] pcieport 0000:00:1f.0: AER: Multiple Corrected error received: 0000:00:00.0
72.16.0.1
PING [   33.267050] pcieport 0000:00:1f.0: AER: can't find device of ID0000
172.16.0.1 (172.16.0.1): 56 data bytes
64 bytes from 172.16.0.1: seq=0 ttl=64 time=17.124 ms
64 bytes from 172.16.0.1: seq=1 ttl=64 time=0.273 ms

$ devmem 0x1f8010e10 32
0xC0000006

It isn't clear why this is necessary, but it seems that for the errors
to go away, we must clear the entire RFS and RSS memory, not just for
the ports in use.

Sadly the code is structured in such a way that we can't have unified
logic for the used and unused ports. For the minimal initialization of
an unused port, we need just to enable and ioremap the PF memory space,
and a control buffer descriptor ring. Unused ports must then free the
CBDR because the driver will exit, but used ports can not pick up from
where that code path left, since the CBDR API does not reinitialize a
ring when setting it up, so its producer and consumer indices are out of
sync between the software and hardware state. So a separate
enetc_init_unused_port function was created, and it gets called right
after the PF memory space is enabled.

Fixes: 07bf34a50e32 ("net: enetc: initialize the RFS and RSS memories")
Reported-by: Michael Walle <michael@walle.cc>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Michael Walle <michael@walle.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index fdb6b9e8da78..eb45830a1667 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -984,7 +984,7 @@ static void enetc_free_rxtx_rings(struct enetc_ndev_priv *priv)
 		enetc_free_tx_ring(priv->tx_ring[i]);
 }
 
-static int enetc_alloc_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
+int enetc_alloc_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
 {
 	int size = cbdr->bd_count * sizeof(struct enetc_cbd);
 
@@ -1005,7 +1005,7 @@ static int enetc_alloc_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
 	return 0;
 }
 
-static void enetc_free_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
+void enetc_free_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
 {
 	int size = cbdr->bd_count * sizeof(struct enetc_cbd);
 
@@ -1013,7 +1013,7 @@ static void enetc_free_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
 	cbdr->bd_base = NULL;
 }
 
-static void enetc_setup_cbdr(struct enetc_hw *hw, struct enetc_cbdr *cbdr)
+void enetc_setup_cbdr(struct enetc_hw *hw, struct enetc_cbdr *cbdr)
 {
 	/* set CBDR cache attributes */
 	enetc_wr(hw, ENETC_SICAR2,
@@ -1033,7 +1033,7 @@ static void enetc_setup_cbdr(struct enetc_hw *hw, struct enetc_cbdr *cbdr)
 	cbdr->cir = hw->reg + ENETC_SICBDRCIR;
 }
 
-static void enetc_clear_cbdr(struct enetc_hw *hw)
+void enetc_clear_cbdr(struct enetc_hw *hw)
 {
 	enetc_wr(hw, ENETC_SICBDRMR, 0);
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index f8275cef3b5c..8b380fc13314 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -310,6 +310,10 @@ int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 void enetc_set_ethtool_ops(struct net_device *ndev);
 
 /* control buffer descriptor ring (CBDR) */
+int enetc_alloc_cbdr(struct device *dev, struct enetc_cbdr *cbdr);
+void enetc_free_cbdr(struct device *dev, struct enetc_cbdr *cbdr);
+void enetc_setup_cbdr(struct enetc_hw *hw, struct enetc_cbdr *cbdr);
+void enetc_clear_cbdr(struct enetc_hw *hw);
 int enetc_set_mac_flt_entry(struct enetc_si *si, int index,
 			    char *mac_addr, int si_map);
 int enetc_clear_mac_flt_entry(struct enetc_si *si, int index);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index d02ecb2e46ae..62ba4bf56f0d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1041,6 +1041,26 @@ static int enetc_init_port_rss_memory(struct enetc_si *si)
 	return err;
 }
 
+static void enetc_init_unused_port(struct enetc_si *si)
+{
+	struct device *dev = &si->pdev->dev;
+	struct enetc_hw *hw = &si->hw;
+	int err;
+
+	si->cbd_ring.bd_count = ENETC_CBDR_DEFAULT_SIZE;
+	err = enetc_alloc_cbdr(dev, &si->cbd_ring);
+	if (err)
+		return;
+
+	enetc_setup_cbdr(hw, &si->cbd_ring);
+
+	enetc_init_port_rfs_memory(si);
+	enetc_init_port_rss_memory(si);
+
+	enetc_clear_cbdr(hw);
+	enetc_free_cbdr(dev, &si->cbd_ring);
+}
+
 static int enetc_pf_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *ent)
 {
@@ -1051,11 +1071,6 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	struct enetc_pf *pf;
 	int err;
 
-	if (node && !of_device_is_available(node)) {
-		dev_info(&pdev->dev, "device is disabled, skipping\n");
-		return -ENODEV;
-	}
-
 	err = enetc_pci_probe(pdev, KBUILD_MODNAME, sizeof(*pf));
 	if (err) {
 		dev_err(&pdev->dev, "PCI probing failed\n");
@@ -1069,6 +1084,13 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 		goto err_map_pf_space;
 	}
 
+	if (node && !of_device_is_available(node)) {
+		enetc_init_unused_port(si);
+		dev_info(&pdev->dev, "device is disabled, skipping\n");
+		err = -ENODEV;
+		goto err_device_disabled;
+	}
+
 	pf = enetc_si_priv(si);
 	pf->si = si;
 	pf->total_vfs = pci_sriov_get_totalvfs(pdev);
@@ -1151,6 +1173,7 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	si->ndev = NULL;
 	free_netdev(ndev);
 err_alloc_netdev:
+err_device_disabled:
 err_map_pf_space:
 	enetc_pci_remove(pdev);
 

