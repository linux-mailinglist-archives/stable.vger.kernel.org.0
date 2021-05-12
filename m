Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB0237BB3A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhELKs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:48:28 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:52213 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230160AbhELKs1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:48:27 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 4DDB712A4;
        Wed, 12 May 2021 06:47:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 12 May 2021 06:47:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=D40wLy
        iVduHLnOxqGrT1sBgm4vemeB1wcmmfq2TvipI=; b=KPdte+JczFYwXnrMUtWiyX
        59dSo9MoQ+AHCSUGW/0Bqh7/ha0vbr4gog2bWu7qG40UZ51/RrUtpr8ESoqlExjC
        /5+XVbIgonqvL1g85xGTTaRpHsUhhsuNrJURL+4BgrvdLAyEmqdFi8qb8lxMyWiC
        ttvS3FjlclPmbWitgi7o6bUeHnmN/MrpxGemDY3gHzYPL7MqEGeUe85sOtcVS18s
        Ltd+wn2CmOHJd/Zspb9p/3Q53rxH7s1HMSwzwuLwa95kItDxjHP+xSIZWd1Lnape
        8o5eKjc1TNc02X/2cS3Ka4Opd+h9Cxxp03Po1ycftsZeKJZ1V8sUOlazKPiuJYjw
        ==
X-ME-Sender: <xms:NLKbYFmZDOcvsZHsDO-PuZKIUWHbDFVlkjLkP2GPmhkJ0hv6_tp4IQ>
    <xme:NLKbYA1dJYZGLsL427qJJ3KP-ZL8zstbLm4P3YviMgj4jHMgNhLNpc6sFyD7qyk3B
    fiA_1kgNSJ0nQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:NLKbYLqk3rTrypUOhtHpGP96_21xGTUgHtzDULM6qnXhEYZNBO3e6w>
    <xmx:NLKbYFmrJncDS_MSvgBhFZN_RnSdBqCankEZSRE7CSAV99hq6upznA>
    <xmx:NLKbYD2vuNkvPilZO967yKUOf5P7tA-YviZQKfR-8mSqxjoB2qfA4g>
    <xmx:NbKbYM9onIYv6THwKcUMPRqlTEBOhBuDwLVhdkQcj_KFnhJmvWQsY3lYw7A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:47:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: Stop looking for coalesced MMIO zones if the bus is" failed to apply to 4.9-stable tree
To:     seanjc@google.com, pbonzini@redhat.com, sunhao.th@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:47:07 +0200
Message-ID: <1620816427180146@kroah.com>
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

From 5d3c4c79384af06e3c8e25b7770b6247496b4417 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 12 Apr 2021 15:20:49 -0700
Subject: [PATCH] KVM: Stop looking for coalesced MMIO zones if the bus is
 destroyed

Abort the walk of coalesced MMIO zones if kvm_io_bus_unregister_dev()
fails to allocate memory for the new instance of the bus.  If it can't
instantiate a new bus, unregister_dev() destroys all devices _except_ the
target device.   But, it doesn't tell the caller that it obliterated the
bus and invoked the destructor for all devices that were on the bus.  In
the coalesced MMIO case, this can result in a deleted list entry
dereference due to attempting to continue iterating on coalesced_zones
after future entries (in the walk) have been deleted.

Opportunistically add curly braces to the for-loop, which encompasses
many lines but sneaks by without braces due to the guts being a single
if statement.

Fixes: f65886606c2d ("KVM: fix memory leak in kvm_io_bus_unregister_dev()")
Cc: stable@vger.kernel.org
Reported-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210412222050.876100-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d17e3ff1138d..82b066db37cb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -192,8 +192,8 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 		    int len, void *val);
 int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 			    int len, struct kvm_io_device *dev);
-void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
-			       struct kvm_io_device *dev);
+int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
+			      struct kvm_io_device *dev);
 struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 					 gpa_t addr);
 
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 62bd908ecd58..f08f5e82460b 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -174,21 +174,36 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
 					   struct kvm_coalesced_mmio_zone *zone)
 {
 	struct kvm_coalesced_mmio_dev *dev, *tmp;
+	int r;
 
 	if (zone->pio != 1 && zone->pio != 0)
 		return -EINVAL;
 
 	mutex_lock(&kvm->slots_lock);
 
-	list_for_each_entry_safe(dev, tmp, &kvm->coalesced_zones, list)
+	list_for_each_entry_safe(dev, tmp, &kvm->coalesced_zones, list) {
 		if (zone->pio == dev->zone.pio &&
 		    coalesced_mmio_in_range(dev, zone->addr, zone->size)) {
-			kvm_io_bus_unregister_dev(kvm,
+			r = kvm_io_bus_unregister_dev(kvm,
 				zone->pio ? KVM_PIO_BUS : KVM_MMIO_BUS, &dev->dev);
 			kvm_iodevice_destructor(&dev->dev);
+
+			/*
+			 * On failure, unregister destroys all devices on the
+			 * bus _except_ the target device, i.e. coalesced_zones
+			 * has been modified.  No need to restart the walk as
+			 * there aren't any zones left.
+			 */
+			if (r)
+				break;
 		}
+	}
 
 	mutex_unlock(&kvm->slots_lock);
 
+	/*
+	 * Ignore the result of kvm_io_bus_unregister_dev(), from userspace's
+	 * perspective, the coalesced MMIO is most definitely unregistered.
+	 */
 	return 0;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c771d40737c9..f84b126c32d6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4621,15 +4621,15 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 }
 
 /* Caller must hold slots_lock. */
-void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
-			       struct kvm_io_device *dev)
+int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
+			      struct kvm_io_device *dev)
 {
 	int i, j;
 	struct kvm_io_bus *new_bus, *bus;
 
 	bus = kvm_get_bus(kvm, bus_idx);
 	if (!bus)
-		return;
+		return 0;
 
 	for (i = 0; i < bus->dev_count; i++)
 		if (bus->range[i].dev == dev) {
@@ -4637,7 +4637,7 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 		}
 
 	if (i == bus->dev_count)
-		return;
+		return 0;
 
 	new_bus = kmalloc(struct_size(bus, range, bus->dev_count - 1),
 			  GFP_KERNEL_ACCOUNT);
@@ -4662,7 +4662,7 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 	}
 
 	kfree(bus);
-	return;
+	return new_bus ? 0 : -ENOMEM;
 }
 
 struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,

