Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D2333ADE8
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhCOIv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:51:28 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:40105 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229505AbhCOIu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 04:50:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 82807194195B;
        Mon, 15 Mar 2021 04:50:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 15 Mar 2021 04:50:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xHUr50
        uQRi+LVsHsc9/hu+SBob+HE9Lk+rZsUUyF8NY=; b=Ap5MUKK6g9S5d7jCjnHWvS
        9Kl8emgr4hIa/+B7XQDCkkyWyeLP2pljuDKRLAmk9R9fylPb6RJSktP570xGaQvN
        o0HDojxAxN+zzOZpJ/M47LgWopAh2BvEiNOCyeU22HURn88crIOEorQ88KDhy4IK
        607gInjw7Dy6GmoxHTNxr7I2uvZxIMJECgGW9SfIHSKzmHrCQuYJc7QnWdLmWmWm
        iXxmBKvj9Qd5YvVBPNAhPWI9jj9Qp/NTfR8p/kDhsSH+qmanUHLAi0JUeBrZhBAy
        InqP5olXNAgV/vZG8Yo+xeHpvTaIyS3z5ukYCiIKI+x+W9UuvBt4sJ7gwuWFS/Fg
        ==
X-ME-Sender: <xms:8R9PYIlgaNhXEv7LCWJnSB0hkeJcuxU7ZVV8g_Xvk_xIzltMS5QRPw>
    <xme:8R9PYH1Mbv_AcQ9KrQJ376O1Bv5q3Bkf4HpUkDdheXKnQNQ_nscy09Q5w5HICmCT7
    2Msne9cvB2JUQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvkedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepjeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:8R9PYGo3S7vOlqdcnz07SCstsOWAM7nJzMTk9sQMTMJUz9evVlTrlA>
    <xmx:8R9PYElAa5mF_w2i03H-AhNT9KdHioBKSNX1CTg8YjMxcMBFjUxdew>
    <xmx:8R9PYG25-3vU1z-Phdra-wv8Gd8SfDOfJJ2jBMbwAubRM2hmkYKw0w>
    <xmx:8R9PYL-rpCDlaguBQ__wNV1gyPMzDN_6eDltEajs4j_rG8WfT2Cv4w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 09C041080066;
        Mon, 15 Mar 2021 04:50:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: Fix exclusive limit for IPA size" failed to apply to 4.9-stable tree
To:     maz@kernel.org, drjones@redhat.com, eric.auger@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 09:50:44 +0100
Message-ID: <16157982440181@kroah.com>
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

