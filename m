Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF85333ADE4
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbhCOIv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:51:27 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:41011 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229519AbhCOIu4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 04:50:56 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9151C1941980;
        Mon, 15 Mar 2021 04:50:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 15 Mar 2021 04:50:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=K+hpXf
        8nlGwYFdJvV9fGBSD02DDSYiB75BgFsjr08ec=; b=mSEmsVJxVbij4hjSAy/9Np
        +N5kwRSUCn5ZVC4gSTzUhCI79ejT9hlVvq30DzDDhA3O+DmUYmpIcolps696Js++
        k0/jSOGVKotZqeWxq7O2uiho/QxOpZJk7QucM29ItY4B9ZYa+CinJ1jfVAG5U6B7
        2OXE5liz5V9ffVs6ZCW3VIxSyH/7xYYGVJQo/WHWSvrwPXl9+pu9M8E1JENzvL5v
        qJ6mR43zv8tRClCMvkwEzplsGj0QWHrMpA0iCUlpeShHtuLxnZpQze5O5sJZ8Zoz
        7BKRDvX14cQ37us7Rrz7xivBGwC60LDDUdk7lBHFepL0cnEGtUVjWzRkyubpDUgA
        ==
X-ME-Sender: <xms:7x9PYJwS2Jnhk3yLW31ivZ_z0P9GxmuLUIxVgdI2L8HT2ZpO_sSZPA>
    <xme:7x9PYC7HHO3MtcoqP3z6fAK5URAOHm71fmmtU6yKKiyJtdzzs2zt7WOQDLZOD_qk9
    a76HDsyYzCxzg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvkedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:7x9PYDUabgQ0iahrA5PCmY07EtoSMw3amgAnkVDPsp6PyV-OpeOWuw>
    <xmx:7x9PYO3OxiFynuzHaBYjbexJBhXBtkUCgrkr1VZiMEZG06g73ilhXQ>
    <xmx:7x9PYI2M1TDVnWS_GDdf5CvVsVEH0UpXlIZmnfVnE_-W59I3wfXf6w>
    <xmx:7x9PYPCwv__MR_Qb3jcSlAQj4UoCbUTTMrUY_Srz4nacwuEMJ5DsyQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 26F3524005E;
        Mon, 15 Mar 2021 04:50:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: Fix exclusive limit for IPA size" failed to apply to 4.14-stable tree
To:     maz@kernel.org, drjones@redhat.com, eric.auger@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 09:50:43 +0100
Message-ID: <161579824311890@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

