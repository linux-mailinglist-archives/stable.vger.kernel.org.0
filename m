Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8BA2D9996
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 15:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439175AbgLNOQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 09:16:42 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:43815 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439133AbgLNOQi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 09:16:38 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 035F6194286A;
        Mon, 14 Dec 2020 09:15:51 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 14 Dec 2020 09:15:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lOtCrN
        j3ctz3bVqG9gpxawgwLOwsKq4HcN/oAt+KwfY=; b=lRM7UHCr3JuVJE7lvNzx/F
        /1nM4q2gJ0naoG4+ri9Nimu401uQoU9yNpyk5JbXcH9LHRe+HI9zDHY/PRraa/cq
        BQuJwxoqcRbfNQrqSziKUvOynyaD5ROt7WSiCJNxiU/G5Fue4znCqFkXjWrktZlx
        RkFDHzAmnHplqgCNA27kd0lU1LxLRacGsDJ8ZUbKCRLWZfZSCPmKYUv0INhDP2qT
        okipd8KMW2RUP9N+sNH9IfwzdycLCKeSxXb3wcVNSOMuLjn93rq2rY2o99vmP/S4
        q2D995uJJITen5uxke5nPZndnfP5rWC2KxmUHEJ4ey9441ENuQgJhA4zZUWFG33Q
        ==
X-ME-Sender: <xms:lnPXX_YCwCe1ui07JzHh3V4Al2tnnr6XFmfp7F1A1U2LuCjgueJddA>
    <xme:lnPXX-XHp-ZN4X0hwq6DOOhxR8UYPaw2Rc0WYOqCeaiTlpm3uz_hTaNTKgV22jxuc
    GdxlKaPFmffuw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:lnPXX-3PSHE6hnLPbGMWoL1oEvKNfuiuvCqduJXwrbGYU7Llp3GONw>
    <xmx:lnPXX9Zi9py_VE7ExTmFqPjhD56ERsz5i6eAHl2oXa_PK_rcH-uy9A>
    <xmx:lnPXX5pi-_G4RYwEv4jhaDmswsjdoe4RNn_RfSx-Ecd0GkHEfe1ZZg>
    <xmx:l3PXXzpBLI1oP8GM8hZlBFSHXveyFR5T8XWFYqPqPZXickOfxTe_dA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 56A2D108005B;
        Mon, 14 Dec 2020 09:15:50 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: mmu: Fix SPTE encoding of MMIO generation upper half" failed to apply to 5.4-stable tree
To:     maciej.szmigiero@oracle.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Dec 2020 15:16:48 +0100
Message-ID: <1607955408254166@kroah.com>
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

From 34c0f6f2695a2db81e09a3ab7bdb2853f45d4d3d Mon Sep 17 00:00:00 2001
From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Date: Sat, 5 Dec 2020 01:48:08 +0100
Subject: [PATCH] KVM: mmu: Fix SPTE encoding of MMIO generation upper half

Commit cae7ed3c2cb0 ("KVM: x86: Refactor the MMIO SPTE generation handling")
cleaned up the computation of MMIO generation SPTE masks, however it
introduced a bug how the upper part was encoded:
SPTE bits 52-61 were supposed to contain bits 10-19 of the current
generation number, however a missing shift encoded bits 1-10 there instead
(mostly duplicating the lower part of the encoded generation number that
then consisted of bits 1-9).

In the meantime, the upper part was shrunk by one bit and moved by
subsequent commits to become an upper half of the encoded generation number
(bits 9-17 of bits 0-17 encoded in a SPTE).

In addition to the above, commit 56871d444bc4 ("KVM: x86: fix overlap between SPTE_MMIO_MASK and generation")
has changed the SPTE bit range assigned to encode the generation number and
the total number of bits encoded but did not update them in the comment
attached to their defines, nor in the KVM MMU doc.
Let's do it here, too, since it is too trivial thing to warrant a separate
commit.

Fixes: cae7ed3c2cb0 ("KVM: x86: Refactor the MMIO SPTE generation handling")
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Message-Id: <156700708db2a5296c5ed7a8b9ac71f1e9765c85.1607129096.git.maciej.szmigiero@oracle.com>
Cc: stable@vger.kernel.org
[Reorganize macros so that everything is computed from the bit ranges. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/Documentation/virt/kvm/mmu.rst b/Documentation/virt/kvm/mmu.rst
index 1c030dbac7c4..5bfe28b0728e 100644
--- a/Documentation/virt/kvm/mmu.rst
+++ b/Documentation/virt/kvm/mmu.rst
@@ -455,7 +455,7 @@ If the generation number of the spte does not equal the global generation
 number, it will ignore the cached MMIO information and handle the page
 fault through the slow path.
 
-Since only 19 bits are used to store generation-number on mmio spte, all
+Since only 18 bits are used to store generation-number on mmio spte, all
 pages are zapped when there is an overflow.
 
 Unfortunately, a single memory access might access kvm_memslots(kvm) multiple
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index fcac2cac78fe..c51ad544f25b 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -40,8 +40,8 @@ static u64 generation_mmio_spte_mask(u64 gen)
 	WARN_ON(gen & ~MMIO_SPTE_GEN_MASK);
 	BUILD_BUG_ON((MMIO_SPTE_GEN_HIGH_MASK | MMIO_SPTE_GEN_LOW_MASK) & SPTE_SPECIAL_MASK);
 
-	mask = (gen << MMIO_SPTE_GEN_LOW_START) & MMIO_SPTE_GEN_LOW_MASK;
-	mask |= (gen << MMIO_SPTE_GEN_HIGH_START) & MMIO_SPTE_GEN_HIGH_MASK;
+	mask = (gen << MMIO_SPTE_GEN_LOW_SHIFT) & MMIO_SPTE_GEN_LOW_MASK;
+	mask |= (gen << MMIO_SPTE_GEN_HIGH_SHIFT) & MMIO_SPTE_GEN_HIGH_MASK;
 	return mask;
 }
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 5c75a451c000..2b3a30bd38b0 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -56,11 +56,11 @@
 #define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
 
 /*
- * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
+ * Due to limited space in PTEs, the MMIO generation is a 18 bit subset of
  * the memslots generation and is derived as follows:
  *
  * Bits 0-8 of the MMIO generation are propagated to spte bits 3-11
- * Bits 9-18 of the MMIO generation are propagated to spte bits 52-61
+ * Bits 9-17 of the MMIO generation are propagated to spte bits 54-62
  *
  * The KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS flag is intentionally not included in
  * the MMIO generation number, as doing so would require stealing a bit from
@@ -69,18 +69,29 @@
  * requires a full MMU zap).  The flag is instead explicitly queried when
  * checking for MMIO spte cache hits.
  */
-#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(17, 0)
 
 #define MMIO_SPTE_GEN_LOW_START		3
 #define MMIO_SPTE_GEN_LOW_END		11
-#define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
-						    MMIO_SPTE_GEN_LOW_START)
 
 #define MMIO_SPTE_GEN_HIGH_START	PT64_SECOND_AVAIL_BITS_SHIFT
 #define MMIO_SPTE_GEN_HIGH_END		62
+
+#define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
+						    MMIO_SPTE_GEN_LOW_START)
 #define MMIO_SPTE_GEN_HIGH_MASK		GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
 						    MMIO_SPTE_GEN_HIGH_START)
 
+#define MMIO_SPTE_GEN_LOW_BITS		(MMIO_SPTE_GEN_LOW_END - MMIO_SPTE_GEN_LOW_START + 1)
+#define MMIO_SPTE_GEN_HIGH_BITS		(MMIO_SPTE_GEN_HIGH_END - MMIO_SPTE_GEN_HIGH_START + 1)
+
+/* remember to adjust the comment above as well if you change these */
+static_assert(MMIO_SPTE_GEN_LOW_BITS == 9 && MMIO_SPTE_GEN_HIGH_BITS == 9);
+
+#define MMIO_SPTE_GEN_LOW_SHIFT		(MMIO_SPTE_GEN_LOW_START - 0)
+#define MMIO_SPTE_GEN_HIGH_SHIFT	(MMIO_SPTE_GEN_HIGH_START - MMIO_SPTE_GEN_LOW_BITS)
+
+#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
+
 extern u64 __read_mostly shadow_nx_mask;
 extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
 extern u64 __read_mostly shadow_user_mask;
@@ -228,8 +239,8 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 {
 	u64 gen;
 
-	gen = (spte & MMIO_SPTE_GEN_LOW_MASK) >> MMIO_SPTE_GEN_LOW_START;
-	gen |= (spte & MMIO_SPTE_GEN_HIGH_MASK) >> MMIO_SPTE_GEN_HIGH_START;
+	gen = (spte & MMIO_SPTE_GEN_LOW_MASK) >> MMIO_SPTE_GEN_LOW_SHIFT;
+	gen |= (spte & MMIO_SPTE_GEN_HIGH_MASK) >> MMIO_SPTE_GEN_HIGH_SHIFT;
 	return gen;
 }
 

