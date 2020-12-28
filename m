Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A8D2E34D5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 08:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgL1HuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 02:50:20 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:44005 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726242AbgL1HuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 02:50:20 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 66E34731;
        Mon, 28 Dec 2020 02:49:34 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 02:49:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PCZiLr
        93eb4hvJ3ewX7Bvl/iF3LYZ1zDChZL64VKcY4=; b=A/pF/DoPLp06XrfHY7mVVe
        aLp+K3v1jgADEP+e3Ym7WfvXXWgv8Oikaj6HBRx9qfgGr2juuEsNPLFXMQxiLaoa
        xWFNbEjp1w6caZfACQMBvDWj51xjux2CWwN3Y4jOsZVPbTG4niRDGmi2pzTXHDJy
        oDzTE+G9F+6SmpnDab5uZAaaYG1+fsiYAcYy5lFmQKnzSSV2Zheznaa2ruCuFRjP
        aI7Gf2/EyPmhCZhLUaR3TkisiqrhjyfMR0/yZQZOYZHygPQkDudOyFegFph5OCwP
        LVAJ/hzts2pvqh7tR8/wnfAp0xzS4DjkoIkScr0Ddv4TdE4iHgQQeJqi2QV+UF8g
        ==
X-ME-Sender: <xms:DY7pX-0Ksjn-3XKa1e3rsvECdmRQGvgyWd-_WVWMNY-rExKElNSxoA>
    <xme:DY7pXxGxEWef-ChyAlPDbfmcnw1THknE6ojo1EaNHKwaE8ISqcIKWDy79IwqsdYHY
    2wJrd84w-7fXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddukedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:DY7pX24Cqrg_2oleRtOF-T_YM__-uEi9LUHo7VToNIQeWoyh6mC4Tg>
    <xmx:DY7pX_1I3UQisZit-T9CXLkxwmsmzqfFL2jMMWhoGM3wk5k9nVyjgw>
    <xmx:DY7pXxEmSw2EWaT_cK9dN-QzjhjfemPDqeOmlglK_Fw3QSxQTVtBjQ>
    <xmx:Do7pX0O_nzlGGWxUtZInB5HLm_TxeXEYEGvnoQHFHBPEUbU6_acdKhHkTUY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A87C2108005B;
        Mon, 28 Dec 2020 02:49:33 -0500 (EST)
Subject: FAILED: patch "[PATCH] vfio/pci: Move dummy_resources_list init in vfio_pci_probe()" failed to apply to 4.19-stable tree
To:     eric.auger@redhat.com, alex.williamson@redhat.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 08:50:48 +0100
Message-ID: <1609141848167167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 16b8fe4caf499ae8e12d2ab1b1324497e36a7b83 Mon Sep 17 00:00:00 2001
From: Eric Auger <eric.auger@redhat.com>
Date: Fri, 13 Nov 2020 18:52:02 +0100
Subject: [PATCH] vfio/pci: Move dummy_resources_list init in vfio_pci_probe()

In case an error occurs in vfio_pci_enable() before the call to
vfio_pci_probe_mmaps(), vfio_pci_disable() will  try to iterate
on an uninitialized list and cause a kernel panic.

Lets move to the initialization to vfio_pci_probe() to fix the
issue.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Fixes: 05f0c03fbac1 ("vfio-pci: Allow to mmap sub-page MMIO BARs if the mmio page is exclusive")
CC: Stable <stable@vger.kernel.org> # v4.7+
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index e6190173482c..47ebc5c49ca4 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -161,8 +161,6 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
 	int i;
 	struct vfio_pci_dummy_resource *dummy_res;
 
-	INIT_LIST_HEAD(&vdev->dummy_resources_list);
-
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
 		int bar = i + PCI_STD_RESOURCES;
 
@@ -1966,6 +1964,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mutex_init(&vdev->igate);
 	spin_lock_init(&vdev->irqlock);
 	mutex_init(&vdev->ioeventfds_lock);
+	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	mutex_init(&vdev->vma_lock);
 	INIT_LIST_HEAD(&vdev->vma_list);

