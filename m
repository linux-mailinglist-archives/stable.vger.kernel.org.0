Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D893937BB36
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhELKsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:48:04 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:42807 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230185AbhELKsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:48:03 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id CBB7112BE;
        Wed, 12 May 2021 06:46:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 06:46:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bBd1hZ
        3ekGRJUJJ95ZJ1s7eNWyHGeAsrvKliaROK0wI=; b=B92AI08duhtYVhRcGkB3/Z
        L/y3Yv9WkI4dbGytAHzSh5RgzDmRFuUlAsVS+Z2dVMZF3qxS+bBF2ptwiNLY3lSa
        4ZhDk8+xxPFT54/4D3k4MOyIuueEWBYPDcbWN8sqHlMIMCGVwQ7Ov9nEGDwxESWw
        5kq7j/ZG6D0Fr88Br7JrCIAkrG/Y4LEgIqxzpVrjmijljG8b1vTGEs7aZN3cIuAj
        aNdrMAm38WD2DTgjFG/tgfpkg8A90QnYoFyoxuIovTlH/IVQHSfPpj/8qJyvoelp
        474ypjxqZzqNXy4yrpzNAcamgdVGspmfpZMropRYUfL/DbuQfG4p7ry1p5/onFBw
        ==
X-ME-Sender: <xms:H7KbYEYHIdJzEnjJLDfXPnd_J6TFkO8qyDADXAg5WGJeHYE54Jf2ug>
    <xme:H7KbYPYYF9UNqypq8QLCxlQgDMCXVkb4nQ_KoaVgRxiVQNn2vNU_yKOj0qUMl6YMG
    rdOVLo6ew0ErA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:H7KbYO_8asmfmh1Dzesk47IWKWXLwgmqJ0TEHGLV9KGCHW9cmeN6rQ>
    <xmx:H7KbYOrXA5WemGd2sm9z0vUCrvIUxdj_08rTJpZVLBKlBNEHZ_M7KA>
    <xmx:H7KbYPrumhpDpW865ZkCh_CHT_AiqiOlxdhFE1WyTZY7ahK1rXf3GQ>
    <xmx:H7KbYOQou5Ezr1T4KbhZSFuKUnIE9CHrNlCDYfd8Kh4_VJWwwglf1ggHp30>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:46:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: Destroy I/O bus devices on unregister failure _after_" failed to apply to 4.9-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:46:43 +0200
Message-ID: <1620816403120246@kroah.com>
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

From 2ee3757424be7c1cd1d0bbfa6db29a7edd82a250 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 12 Apr 2021 15:20:48 -0700
Subject: [PATCH] KVM: Destroy I/O bus devices on unregister failure _after_
 sync'ing SRCU

If allocating a new instance of an I/O bus fails when unregistering a
device, wait to destroy the device until after all readers are guaranteed
to see the new null bus.  Destroying devices before the bus is nullified
could lead to use-after-free since readers expect the devices on their
reference of the bus to remain valid.

Fixes: f65886606c2d ("KVM: fix memory leak in kvm_io_bus_unregister_dev()")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210412222050.876100-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 529cff1050d7..c771d40737c9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4646,7 +4646,13 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 		new_bus->dev_count--;
 		memcpy(new_bus->range + i, bus->range + i + 1,
 				flex_array_size(new_bus, range, new_bus->dev_count - i));
-	} else {
+	}
+
+	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
+	synchronize_srcu_expedited(&kvm->srcu);
+
+	/* Destroy the old bus _after_ installing the (null) bus. */
+	if (!new_bus) {
 		pr_err("kvm: failed to shrink bus, removing it completely\n");
 		for (j = 0; j < bus->dev_count; j++) {
 			if (j == i)
@@ -4655,8 +4661,6 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 		}
 	}
 
-	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
-	synchronize_srcu_expedited(&kvm->srcu);
 	kfree(bus);
 	return;
 }

