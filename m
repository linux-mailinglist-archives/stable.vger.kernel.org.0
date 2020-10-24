Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1813E297BB3
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 11:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760497AbgJXJmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 05:42:51 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:37663 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756717AbgJXJmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 05:42:50 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id D55BCB84;
        Sat, 24 Oct 2020 05:42:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 24 Oct 2020 05:42:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=t53kdd
        IBoh/ZYE5xSuX/ymmD6/enWtaUrdDcUF7J17g=; b=o/HWwOo28Opk+Zwy7rU5Y0
        Kc8E7MlRrTWffvosPl34zQ9io7B0gNexmFZ4aJLwtjxpuHaT8lzBt8R796ShhKQa
        W21tjEXja4kk17EFehALXd5//ByaWXYnBl28BjeSiZAZBDL3SK4WadSxMuOeextt
        H9gUv7GUsO/rvptVrZi1hCyvbLwZ6L/iCt/dZfVYT71CCrq0/V9ICCa/PQAQl1Aw
        z4QXnOw0yj7tbkOC8f2QYaZVvbqp//WkZd+RBdJ5IqZyUjvGi4BnxJguUEaHLzOv
        WRJTb3OqPV8HOh4os3DpDzEntmTex5hUcQqE1p+m1x+JIiQRvwLQIG7ESj3/K6eg
        ==
X-ME-Sender: <xms:GfeTX8z2Yb7DDWh_9g4ii1UyQGVuKoY4OIlsP2kW14yKTbVXl1xBog>
    <xme:GfeTXwR5d8fkjKcdN81EH16OTwjuOCE9DjTOSoV5cxA89bPuLa0shixBX4Yrt9vjA
    0iTttdFIi6n9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:GfeTX-V2qEP35g1njFyNSobfgDVoRZIq0zL8-5aGxjQrGl0M8JQAoQ>
    <xmx:GfeTX6jJi59bHb7_8FCw-Sqg49spiL1v7kBaLlEfCKBeonb7-oktBg>
    <xmx:GfeTX-CQ1VhNg8KXiYRHNGUvTh0kxpINsm_OeuB0t7zojlpJYod2Yw>
    <xmx:GfeTX5qr9ewHsmia-TMEfJFMI5V-R7GUQBIOOEfAPdMgEz1VLE4YK8TqdSA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 247A43064674;
        Sat, 24 Oct 2020 05:42:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Reset the segment cache when stuffing guest segs" failed to apply to 4.19-stable tree
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Oct 2020 11:43:24 +0200
Message-ID: <1603532604128176@kroah.com>
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

From fc387d8daf3960c5e1bc18fa353768056f4fd394 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Wed, 23 Sep 2020 11:44:46 -0700
Subject: [PATCH] KVM: nVMX: Reset the segment cache when stuffing guest segs

Explicitly reset the segment cache after stuffing guest segment regs in
prepare_vmcs02_rare().  Although the cache is reset when switching to
vmcs02, there is nothing that prevents KVM from re-populating the cache
prior to writing vmcs02 with vmcs12's values.  E.g. if the vCPU is
preempted after switching to vmcs02 but before prepare_vmcs02_rare(),
kvm_arch_vcpu_put() will dereference GUEST_SS_AR_BYTES via .get_cpl()
and cache the stale vmcs02 value.  While the current code base only
caches stale data in the preemption case, it's theoretically possible
future code could read a segment register during the nested flow itself,
i.e. this isn't technically illegal behavior in kvm_arch_vcpu_put(),
although it did introduce the bug.

This manifests as an unexpected nested VM-Enter failure when running
with unrestricted guest disabled if the above preemption case coincides
with L1 switching L2's CPL, e.g. when switching from a L2 vCPU at CPL3
to to a L2 vCPU at CPL0.  stack_segment_valid() will see the new SS_SEL
but the old SS_AR_BYTES and incorrectly mark the guest state as invalid
due to SS.dpl != SS.rpl.

Don't bother updating the cache even though prepare_vmcs02_rare() writes
every segment.  With unrestricted guest, guest segments are almost never
read, let alone L2 guest segments.  On the other hand, populating the
cache requires a large number of memory writes, i.e. it's unlikely to be
a net win.  Updating the cache would be a win when unrestricted guest is
not supported, as guest_state_valid() will immediately cache all segment
registers.  But, nested virtualization without unrestricted guest is
dirt slow, saving some VMREADs won't change that, and every CPU
manufactured in the last decade supports unrestricted guest.  In other
words, the extra (minor) complexity isn't worth the trouble.

Note, kvm_arch_vcpu_put() may see stale data when querying guest CPL
depending on when preemption occurs.  This is "ok" in that the usage is
imperfect by nature, i.e. it's used heuristically to improve performance
but doesn't affect functionality.  kvm_arch_vcpu_put() could be "fixed"
by also disabling preemption while loading segments, but that's
pointless and misleading as reading state from kvm_sched_{in,out}() is
guaranteed to see stale data in one form or another.  E.g. even if all
the usage of regs_avail is fixed to call kvm_register_mark_available()
after the associated state is set, the individual state might still be
stale with respect to the overall vCPU state.  I.e. making functional
decisions in an asynchronous hook is doomed from the get go.  Thankfully
KVM doesn't do that.

Fixes: de63ad4cf4973 ("KVM: X86: implement the logic for spinlock optimization")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200923184452.980-2-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e8048e01c044..2e0f9dbc0ab6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2411,6 +2411,8 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		vmcs_writel(GUEST_TR_BASE, vmcs12->guest_tr_base);
 		vmcs_writel(GUEST_GDTR_BASE, vmcs12->guest_gdtr_base);
 		vmcs_writel(GUEST_IDTR_BASE, vmcs12->guest_idtr_base);
+
+		vmx->segment_cache.bitmask = 0;
 	}
 
 	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &

