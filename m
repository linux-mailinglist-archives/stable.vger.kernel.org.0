Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F5F33ADE3
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCOIuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:50:51 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:55513 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhCOIup (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 04:50:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 22F55194197A;
        Mon, 15 Mar 2021 04:50:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 15 Mar 2021 04:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=e4zHzh
        PkESdC3Lk4o4TXrlr2gvH3JKlENfG+InprTP8=; b=QKGUkp22Ozg94+r8LRaGyg
        ASWbcVEPg+Kbfy5g9rcCRbRGZw+9HxstcuRd2V+hnHJtcCTeFEcqEKMw3qh36vFG
        QsT24LY+6BCqk+c/FtHq4+1J/uNlx93n/BpYqQ7eLCQzVHFumeio4Ejt3BmVPLk9
        N2DvYHR7ftYSf8e/USiyFkMPyHFmTi2SMYg46XB1+enOYoy9OfeuquGfgL8Awk9V
        51+lRDiVbV9hJSWnODccupY8xb2hIL9Z4DkrOuPKMtSvCPRvCGJ3+jStrMaDpQ0n
        fMr7Y6Lepk4dFd6hT1I9Wp7k4WoNGOeM149k2gZHo7+SWjMvlSlsGw5AZaGH2ctA
        ==
X-ME-Sender: <xms:5B9PYBjDGMqaO3M_psfECcEBP5Rzdg4HhqFxzkM6sBe8NDzfDcXr1g>
    <xme:5B9PYGC96D2ohrbQtSbY1nGM7VS3dkzWx_bZBIa0Ipn_gydf2EcirwwbyuIfw2jMG
    V-jmRWVWGs26Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvkedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:5B9PYBE6HULwQNYWjCChOfFXlQhOKsQQCypMNiIW-BbYomLY_UxJsw>
    <xmx:5B9PYGRrLPO3lsK-qCZErdDxyO2zzjQLnxR-PxKidAGtyafGfWj-Fw>
    <xmx:5B9PYOxV2Wbig1O_eSQjKwXrlfEUTzAjIAZga4kf7OxCXEcUgSonWw>
    <xmx:5R9PYDr_N6wO6Phh0-5kMOl-6XkJAD3-PBVTwjS-xdE44h76_hgz3A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6B4E2240054;
        Mon, 15 Mar 2021 04:50:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: Fix exclusive limit for IPA size" failed to apply to 4.19-stable tree
To:     maz@kernel.org, drjones@redhat.com, eric.auger@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 09:50:42 +0100
Message-ID: <1615798242657@kroah.com>
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

From 262b003d059c6671601a19057e9fe1a5e7f23722 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Thu, 11 Mar 2021 10:00:16 +0000
Subject: [PATCH] KVM: arm64: Fix exclusive limit for IPA size

When registering a memslot, we check the size and location of that
memslot against the IPA size to ensure that we can provide guest
access to the whole of the memory.

Unfortunately, this check rejects memslot that end-up at the exact
limit of the addressing capability for a given IPA size. For example,
it refuses the creation of a 2GB memslot at 0x8000000 with a 32bit
IPA space.

Fix it by relaxing the check to accept a memslot reaching the
limit of the IPA space.

Fixes: c3058d5da222 ("arm/arm64: KVM: Ensure memslots are within KVM_PHYS_SIZE")
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Andrew Jones <drjones@redhat.com>
Link: https://lore.kernel.org/r/20210311100016.3830038-3-maz@kernel.org

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 77cb2d28f2a4..8711894db8c2 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1312,8 +1312,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 * Prevent userspace from creating a memory region outside of the IPA
 	 * space addressable by the KVM guest IPA space.
 	 */
-	if (memslot->base_gfn + memslot->npages >=
-	    (kvm_phys_size(kvm) >> PAGE_SHIFT))
+	if ((memslot->base_gfn + memslot->npages) > (kvm_phys_size(kvm) >> PAGE_SHIFT))
 		return -EFAULT;
 
 	mmap_read_lock(current->mm);

