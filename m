Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A67133ADEC
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbhCOIv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:51:26 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:53013 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229518AbhCOIuy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 04:50:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id B55E8194195B;
        Mon, 15 Mar 2021 04:50:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 15 Mar 2021 04:50:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Xs7GeU
        83KbLhRrgPLHTtN5+ArAoKhtyRMbSRWk4sK0s=; b=LA5jY8pj3lin2sAkyN1veY
        xTHcENiQ4mi7plO9Iuwh9PyxTqX+6eabDo+5MUlqZYHVTykgG0m+R5l95MSaQKEO
        d0aQsySx9cc/XbcQiGDONNPmSa9IpmLtyLedSLJjAvaxFYub0d2+TMEjtOBLHCFG
        UIF8X1tQKKrSs+2Eeu7PvBOXnhFao32u+wFarINXdAI+0itUKXtqQfTYYQdjU1O7
        oXyru+IOXn++kw1UNLMO6cypTdEbXmUlco3ppBGWuhHR6L4Aenop50D7ZZv5b3jy
        PK3ZBtIjFaRJ1FyYAFofQcdYCwD2xyGVZavQqEj61LQ/5NDZGl5qDFbWdHv8YDiA
        ==
X-ME-Sender: <xms:7R9PYJrl002jw0yjARj-eDj7jbFr12NDNU8zQNcDQFqo1NU9U2lHFA>
    <xme:7R9PYLo6bwFSjpJTkdRxA7O4Ke5yloOhrRt0li3fnvJS8mRQhqVN_gSRKs-NuLjZS
    FkmFgCVe04xNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvkedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:7R9PYGN19_FmjkrVFVrAtJTItFK7vTmpmVYTJ8VwJRWo5CKD0A1Pug>
    <xmx:7R9PYE5Z-6-MXC-bxJDwFYj3CNb5CFEqCgg3LD8RK1-ifjKEMgOZ8A>
    <xmx:7R9PYI7ebPRSxQ4Pko8L3gKZJIzbsldTOcDuJZA9yHpTMeWFiE4d5A>
    <xmx:7R9PYGQAe0EvID2KCG9MaHQ2EGGoJNfqXodgZQeCw-50COnpv2TFVQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 60B6C1080057;
        Mon, 15 Mar 2021 04:50:53 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: Fix exclusive limit for IPA size" failed to apply to 4.4-stable tree
To:     maz@kernel.org, drjones@redhat.com, eric.auger@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 09:50:43 +0100
Message-ID: <1615798243183250@kroah.com>
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

