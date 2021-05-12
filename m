Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB8537BB37
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhELKsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:48:06 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:46497 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230185AbhELKsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:48:06 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 3552312DF;
        Wed, 12 May 2021 06:46:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 06:46:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=0kw3dC
        WtV3mR/8CtqBllLzmFHzlP8nLjyKWbMlTawGY=; b=av61qLXQtpKJ/KcFCral+3
        LSPZjVJZS1sjW2qL/KaJTXXPdpCWAxO8gVbeKlUqWIYXn0Hn0qFilJSP6Ye0SqE0
        /7H/VBJthm0B0GMW6wLlivFUzQ9pBr49Ld1Bnv8Kmdl9A52bN5WuZHjH939aB6zw
        t4y+tCdadcsNbG2cZMOKXemisRzBItMcH0XxoO3VPg2H9Bi38/wYA42Y+6aT+73+
        razPcsvox7aXX9JrBQ9UZmMcN5QBvRzmF4RcS7eNqk8ROb666RuWGwNIovg1Vlc0
        a5R5Uaqyy1nArERPcdzJyQnbG+yGoETabM04mrMl8IU8/CwMUG60fjG/OtcVYfJQ
        ==
X-ME-Sender: <xms:IbKbYENXxqeYcls_BOdBYsvj68Woh0hUk-sl2h69H24dE6kiDBtZ6Q>
    <xme:IbKbYK91k3VVkSK4q2HOvXgcfn5adbtlRZvyfKDoXZ21QfgBNFkHNCXBhp-gOqobP
    3SadAh_0r6R2w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepleenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:IbKbYLStOMIrUeqUdrpmFKMmz8zNC7wVE2WubM_9-Bdqytuz4rAabA>
    <xmx:IbKbYMsZBR2HSnXwUkV0GjZAXvX5zk61UL0VEQHitB-RnQfTTjJiHQ>
    <xmx:IbKbYMchwP2vx33GtHvEhNAGn3XOf35Wa-vbWYPiT090aXfFO2mQfg>
    <xmx:IbKbYElNgkxyxYEPMa5i6v3fed3j3uDcLZRADSBMeQOI1RZNQjxbueznnZ0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:46:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: Destroy I/O bus devices on unregister failure _after_" failed to apply to 5.4-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:46:44 +0200
Message-ID: <1620816404179206@kroah.com>
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

