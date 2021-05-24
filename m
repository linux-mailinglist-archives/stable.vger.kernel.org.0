Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F13138E40E
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 12:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhEXKdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 06:33:01 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:32867 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232445AbhEXKdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 06:33:01 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 46200194032B;
        Mon, 24 May 2021 06:31:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 24 May 2021 06:31:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KEbOZf
        2N+SeOoWwSVAeKlRK4wEAK1mU8pVh/wcjrjyU=; b=PS3QZCue/csi+JiNJXZq9U
        2n4h7mFmHL+KBeAeU1PTLWwp2ePcn1GIUQz1bkLL4F+D12PIek1IqjLePOY17Sqg
        4kumWyxatSZ7CQ8N7KSe4M5129sgGi5wyhLhnkcQEoDeeq+vv48NGDLHKzQSOfpb
        N9vLWUg8pET0iz6E1FlERxnowl6lM4ijMpv4qQKaWswRoj8bFkQzP+IyZsvsMrOY
        3fxgGAdaqC7pNe105UiX7r+W8iJGAITqaj0ECHjaS1x/tQw03VLLR/D3b8DlI407
        yfLoPq/GRHaS+dSvd1Y9bnLlY0N8jz6RpA3kgVPHk4HcqJnjdHh35+1nw0vS7JBQ
        ==
X-ME-Sender: <xms:hICrYHhNjdbZMCsj7ovmmD83bx9Xb7_7vDOQdy2hGWHq-VTdiHceQw>
    <xme:hICrYEDoWRBse0fHkTDrFdTNWW9s5YxEROP04NvzLVm2jcZz9QYeyVa_Ebf35e44h
    eDsMyc8tyF3GQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejledgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:hICrYHG7UU8FohZDCjLHnB9zQj3WWPd0Byr2W_CiKNh5KPIZXwi-gg>
    <xmx:hICrYETBQ0M8qqrT2TLqBpD7z0bBbcnYvgKkMlb5vwOcqQ3fn3zKgw>
    <xmx:hICrYEwmcOJU0QpsD3MthegJG7fbawly3j1lkajez28qxt3Jhzwm_A>
    <xmx:hYCrYBox8AYH-PUvF-HjNZv-qzlFXUJjIO98eBXIxSko5HRJOWE9og>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 24 May 2021 06:31:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] xen-pciback: redo VF placement in the virtual topology" failed to apply to 4.4-stable tree
To:     jbeulich@suse.com, boris.ostrovsky@oracle.com, jgross@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 May 2021 12:31:31 +0200
Message-ID: <1621852291138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4ba50e7c423c29639878c00573288869aa627068 Mon Sep 17 00:00:00 2001
From: Jan Beulich <jbeulich@suse.com>
Date: Tue, 18 May 2021 18:13:42 +0200
Subject: [PATCH] xen-pciback: redo VF placement in the virtual topology

The commit referenced below was incomplete: It merely affected what
would get written to the vdev-<N> xenstore node. The guest would still
find the function at the original function number as long as
__xen_pcibk_get_pci_dev() wouldn't be in sync. The same goes for AER wrt
__xen_pcibk_get_pcifront_dev().

Undo overriding the function to zero and instead make sure that VFs at
function zero remain alone in their slot. This has the added benefit of
improving overall capacity, considering that there's only a total of 32
slots available right now (PCI segment and bus can both only ever be
zero at present).

Fixes: 8a5248fe10b1 ("xen PV passthru: assign SR-IOV virtual functions to separate virtual slots")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/8def783b-404c-3452-196d-3f3fd4d72c9e@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>

diff --git a/drivers/xen/xen-pciback/vpci.c b/drivers/xen/xen-pciback/vpci.c
index 4162d0e7e00d..cc7450f2b2a9 100644
--- a/drivers/xen/xen-pciback/vpci.c
+++ b/drivers/xen/xen-pciback/vpci.c
@@ -70,7 +70,7 @@ static int __xen_pcibk_add_pci_dev(struct xen_pcibk_device *pdev,
 				   struct pci_dev *dev, int devid,
 				   publish_pci_dev_cb publish_cb)
 {
-	int err = 0, slot, func = -1;
+	int err = 0, slot, func = PCI_FUNC(dev->devfn);
 	struct pci_dev_entry *t, *dev_entry;
 	struct vpci_dev_data *vpci_dev = pdev->pci_dev_data;
 
@@ -95,22 +95,25 @@ static int __xen_pcibk_add_pci_dev(struct xen_pcibk_device *pdev,
 
 	/*
 	 * Keep multi-function devices together on the virtual PCI bus, except
-	 * virtual functions.
+	 * that we want to keep virtual functions at func 0 on their own. They
+	 * aren't multi-function devices and hence their presence at func 0
+	 * may cause guests to not scan the other functions.
 	 */
-	if (!dev->is_virtfn) {
+	if (!dev->is_virtfn || func) {
 		for (slot = 0; slot < PCI_SLOT_MAX; slot++) {
 			if (list_empty(&vpci_dev->dev_list[slot]))
 				continue;
 
 			t = list_entry(list_first(&vpci_dev->dev_list[slot]),
 				       struct pci_dev_entry, list);
+			if (t->dev->is_virtfn && !PCI_FUNC(t->dev->devfn))
+				continue;
 
 			if (match_slot(dev, t->dev)) {
 				dev_info(&dev->dev, "vpci: assign to virtual slot %d func %d\n",
-					 slot, PCI_FUNC(dev->devfn));
+					 slot, func);
 				list_add_tail(&dev_entry->list,
 					      &vpci_dev->dev_list[slot]);
-				func = PCI_FUNC(dev->devfn);
 				goto unlock;
 			}
 		}
@@ -123,7 +126,6 @@ static int __xen_pcibk_add_pci_dev(struct xen_pcibk_device *pdev,
 				 slot);
 			list_add_tail(&dev_entry->list,
 				      &vpci_dev->dev_list[slot]);
-			func = dev->is_virtfn ? 0 : PCI_FUNC(dev->devfn);
 			goto unlock;
 		}
 	}

