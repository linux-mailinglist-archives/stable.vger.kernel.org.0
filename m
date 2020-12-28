Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC7C2E34D7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 08:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgL1Hum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 02:50:42 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:56395 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726242AbgL1Hum (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 02:50:42 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 1EE8E745;
        Mon, 28 Dec 2020 02:49:36 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 02:49:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=s/25y0
        rm8ZaNqHmjop9Rep5gXL4+MIAYumart4Pv84c=; b=jtrQFfebE9sfGmzkyouAFw
        67a2LSZC+fQQTirspqoQmvNYNrbORQrVS+V5u/nGzXwN2yFbBbnrVBOUTuKTosrc
        NDQERzcGtFrkeJRq4bXJJZyvZ5ckVD89kDqrp2xIWBTKkQysoSS1MAoj4kEk5Bzt
        UtUcmefAtkWxTkDe8wnQ68DYvHFAuqANwLl3/ICTnexfFU57vrbr0vKHhTvg8ulP
        mW51IFWbx4g78XvmeLzk38yBJnhinE8F9u5Rn6PaUfSNuNpM3JkgkU6sXTHxRAnP
        d+gYHg9n/3mBCRFRJrfMyp5X/wKmjTr3dLRcqoeNcnAmbLyDyBu5uXGDqDzsl/Pg
        ==
X-ME-Sender: <xms:D47pX-R2n_98z_MLTkHVn54OdQhHtbHKISCt-GJS5tKVpHusUWjvDA>
    <xme:D47pXzyT3LXRJrVITg6soCbjUqSajkgulZVwoQh2yGA6oWwaUmwaScU5lMUtSyKnB
    TCcnt0DhagPEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddukedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:D47pX73w4lWEU2ltKjo8H-VZ4EAl-qazLvz5eHyDUSRA91XtnETiQQ>
    <xmx:D47pX6C6CY83PJ8bzPUoyGPBmj-AcuTCt4KsYFfF47Lg7UMLdBnUcg>
    <xmx:D47pX3j6k6zummfkeYfyU1_bLra7DhEV66E6IrD9QHjWPg9yXLq0tw>
    <xmx:D47pX3KIZFxJ7T-21fUpd5oiRp_aYFVcQCkhTP0_oqqrtbK_QAV3kf-GlWM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 507D124005A;
        Mon, 28 Dec 2020 02:49:35 -0500 (EST)
Subject: FAILED: patch "[PATCH] vfio/pci: Move dummy_resources_list init in vfio_pci_probe()" failed to apply to 4.9-stable tree
To:     eric.auger@redhat.com, alex.williamson@redhat.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 08:50:49 +0100
Message-ID: <160914184912691@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

