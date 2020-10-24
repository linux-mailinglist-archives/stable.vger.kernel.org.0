Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA84B297BBB
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 11:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756701AbgJXJux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 05:50:53 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:56151 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751760AbgJXJuw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 05:50:52 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id AA055BDC;
        Sat, 24 Oct 2020 05:50:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 24 Oct 2020 05:50:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=OjxNrN
        UFzIFP9yCrfpuqa+gTEMAhuk5+Y906ukZ4uy4=; b=pMUsrmgXWv+SgrHJ+8usEE
        Cm6S3BKTs3TYAoGOBCBjb9H28hJqE89xuYv//JHFFtDwDTN1PwiyVRf+LpIscKfk
        5wAAukREnyeA11yCpOtHi/qZ5scmvcQyPy9LZkEUiOyrbiB1LN7HK+EAzMGEBBX7
        uSAMLHc4bLIJklcK5DA1sJhWeUEYkuPwj243q2PJnVWCEj3xpTxeRVX+rKp2Ehrr
        CjTJrbqLIaMsFAqdxZOiiwLoggEqQiO5yzj2TyAWeXv2mX3N6SDTOiar0klErO29
        2wIC+oqUBgiIPXyvC3LYwiSOW8ZvUsT8HJXQhFA6/BzROOA7tYYowzPfhUYfo8/g
        ==
X-ME-Sender: <xms:-_iTXytMSpRIgWCZiFNu8smmsw6OWIrRngT6_cxqNknBRTW8LxVRKA>
    <xme:-_iTX3csq62eH6rHXG6qcpCuc0_KIvlrPeeXOhIdOS3c3qvNYcxvMscvf9--H1wNs
    1jfGmT-i2TpEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgddvtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:-_iTX9ww6eL5jfwtQLuIqBYiFYOFSTkr7ZsC2-t8P5UBR6EA3k2E4Q>
    <xmx:-_iTX9Ph4jYBIUXF5MtMcbdgnc7zh0rKRU9nszxDXwVcHNxDSxa0DQ>
    <xmx:-_iTXy99RZol5Rc8pkdXHLYfxmjOwWSA84UNEJ2Wu3aRrPVsvXlH-g>
    <xmx:-_iTX0JhSxGngytkTyLfriOBdJYS7sMRsJzMy-hHMx-iLu5l5K8Hqdklwz0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E66DB3280059;
        Sat, 24 Oct 2020 05:50:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Intercept LA57 to inject #GP fault when it's" failed to apply to 4.19-stable tree
To:     laijs@linux.alibaba.com, jiangshanlai@gmail.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Oct 2020 11:51:25 +0200
Message-ID: <160353308558219@kroah.com>
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

From 6e1d849fa3296526e64b75fa227b6377cd0fd3da Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@linux.alibaba.com>
Date: Tue, 29 Sep 2020 21:16:55 -0700
Subject: [PATCH] KVM: x86: Intercept LA57 to inject #GP fault when it's
 reserved

Unconditionally intercept changes to CR4.LA57 so that KVM correctly
injects a #GP fault if the guest attempts to set CR4.LA57 when it's
supported in hardware but not exposed to the guest.

Long term, KVM needs to properly handle CR4 bits that can be under guest
control but also may be reserved from the guest's perspective.  But, KVM
currently sets the CR4 guest/host mask only during vCPU creation, and
reworking flows to change that will take a bit of elbow grease.

Even if/when generic support for intercepting reserved bits exists, it's
probably not worth letting the guest set CR4.LA57 directly.  LA57 can't
be toggled while long mode is enabled, thus it's all but guaranteed to
be set once (maybe twice, e.g. by BIOS and kernel) during boot and never
touched again.  On the flip side, letting the guest own CR4.LA57 may
incur extra VMREADs.  In other words, this temporary "hack" is probably
also the right long term fix.

Fixes: fd8cb433734e ("KVM: MMU: Expose the LA57 feature to VM.")
Cc: stable@vger.kernel.org
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
[sean: rewrote changelog]
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200930041659.28181-2-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index cfe83d4ae625..ca0781b41df9 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -7,7 +7,7 @@
 #define KVM_POSSIBLE_CR0_GUEST_BITS X86_CR0_TS
 #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
-	 | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_PGE | X86_CR4_TSD)
+	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD)
 
 #define BUILD_KVM_GPR_ACCESSORS(lname, uname)				      \
 static __always_inline unsigned long kvm_##lname##_read(struct kvm_vcpu *vcpu)\

