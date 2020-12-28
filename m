Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A952E34D6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 08:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgL1Huc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 02:50:32 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:53023 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726242AbgL1Huc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 02:50:32 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B4A6172F;
        Mon, 28 Dec 2020 02:49:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 02:49:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Rvb9W2
        uASWhV5MABCzyJ19FadU/WfpjtexavPpvsZ1U=; b=eg8xPLstknORA9dp8/7eEt
        YMGcKcqqxp+6IbbwJtnEXyw/LiMRhVqOc00RTHZ3gE85TbcE4+m7IfpmyvGd+ILt
        edIcc4CYEV1Jn2UfQjo1Mz5nBX40Z1NvvUmT0hv2Ye1XDn3TILV6M956gVfe6Cmh
        WhHGzrOL3LbXg9abqfVIcsB6/hIua3eHSICdSf9/Dpw/UFDWAaD0BMCP8FpoS7He
        4of9C4pPQNv0a8GDcV40Vk+q4lOCwIwP11GU4aNi7qtBj6nrm9RG6+WGK2nnPrkx
        BRSdOCxJAlpKZZxvOWEZwL2kE6XjmFjsm99rH/7gKnOdEQAIs4VTTszoi1HcJChg
        ==
X-ME-Sender: <xms:BI7pX-Z5IY3bxmNiE45kGh5Z7ONakrvmAsp_dOQ3FBmkn0UlR8pwSQ>
    <xme:BI7pXxanw0YzyXZ5i9X2wCiqxS39b8mxyr23CdjOmx-7p3Cfh7PKCeRXkPae54VaM
    OPewMpaAjXobw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddukedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:BI7pX49AFP0ZlF6_NTJospDPT2EDTT_tEAnr0BiWdm_QZrSlaGPUMw>
    <xmx:BI7pXwpjV76BHVsLJ_1XqdazwWzMul-nl6CLZnwSspcOQ_HXpSHdGw>
    <xmx:BI7pX5rrq8MKNyBJX_HjgJpxqqXpByUv-WOpY0NzphChzUazgwi8_w>
    <xmx:BY7pX4RArYHQnDU8_AdXX7zSLaRNMf2fiMuFFGBwcBqtNvfCUaTzU9mL90A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8D53D24005C;
        Mon, 28 Dec 2020 02:49:24 -0500 (EST)
Subject: FAILED: patch "[PATCH] vfio/pci: Move dummy_resources_list init in vfio_pci_probe()" failed to apply to 5.4-stable tree
To:     eric.auger@redhat.com, alex.williamson@redhat.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 08:50:48 +0100
Message-ID: <16091418481137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

