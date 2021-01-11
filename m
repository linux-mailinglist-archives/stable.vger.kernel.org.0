Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913A62F0E80
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 09:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbhAKItT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:49:19 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:42603 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727948AbhAKItT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:49:19 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 5EAC32561;
        Mon, 11 Jan 2021 03:48:33 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:48:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=XMgfek
        xfGlKZumDWkdf4QQiw0ddmxM2R4hYDgYwPYQA=; b=hV5WCQ7g8JbPjBazDpG0zZ
        4S97jmeX92tcHXFZNqS8KBJYfFbEXHP7yGZKxNTNyXFrHBzCWhg3dWT9Ak0DoV41
        9aIRfhhLBtVmpZEzb1d5bUcK4ItgLSd5vybRpETMr+k6lMeX5ZDWtEOHQdgWjiUc
        dAXpkUvLDc9CYlnH79ODi59dJm+nO6uovCSKntgPGT4TJZR3yWtwyOprPVLr0bPt
        pZiZcr8icLfBH/5AAwfIo85DGjXvtHia6yQ4kU3GOPio8UQKhITQwltgdENxZHg9
        7D+dtuywk5EWkhpS6DTpSd6JqgJYocIzMk7EwyG2awiEPKVhnoMzXnQSa46Zu9RQ
        ==
X-ME-Sender: <xms:4BD8X6sykHd0fw_xJoEMlAQbT8qLUZDIZUYScz1_HVx5CnVLVCtDOA>
    <xme:4BD8X_dQhb0oQttNIJ12Um93I3rH6ska7I9oc7EUp9L5JVZw_IWZffxqXkAnLMFfJ
    EeT0AHEBV_uQw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:4BD8X1y7lUW_7rnULlg_aroeutsTs_FvkdcUCEOqHJHH-Blf-yQmeQ>
    <xmx:4BD8X1PayOxtGzONhHKYpCK6bDC3tNamQx8VSR3ZlA3qk4AQvtxScA>
    <xmx:4BD8X69Lc8BfgOvvuvEGXKMOzEBpjO9yqiUGV13EIa_MkmTXYrF5UA>
    <xmx:4RD8X_FnRFjEsboPg8TzQdcuGG3g5cIvYmVsEbbEwChKMdg8flSpzWKSnRU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A7BD31080063;
        Mon, 11 Jan 2021 03:48:32 -0500 (EST)
Subject: FAILED: patch "[PATCH] kvm: check tlbs_dirty directly" failed to apply to 4.9-stable tree
To:     laijs@linux.alibaba.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:49:43 +0100
Message-ID: <1610354983131238@kroah.com>
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

From 88bf56d04bc3564542049ec4ec168a8b60d0b48c Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@linux.alibaba.com>
Date: Thu, 17 Dec 2020 23:41:18 +0800
Subject: [PATCH] kvm: check tlbs_dirty directly

In kvm_mmu_notifier_invalidate_range_start(), tlbs_dirty is used as:
        need_tlb_flush |= kvm->tlbs_dirty;
with need_tlb_flush's type being int and tlbs_dirty's type being long.

It means that tlbs_dirty is always used as int and the higher 32 bits
is useless.  We need to check tlbs_dirty in a correct way and this
change checks it directly without propagating it to need_tlb_flush.

Note: it's _extremely_ unlikely this neglecting of higher 32 bits can
cause problems in practice.  It would require encountering tlbs_dirty
on a 4 billion count boundary, and KVM would need to be using shadow
paging or be running a nested guest.

Cc: stable@vger.kernel.org
Fixes: a4ee1ca4a36e ("KVM: MMU: delay flush all tlbs on sync_page path")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20201217154118.16497-1-jiangshanlai@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3abcb2ce5b7d..19dae28904f7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -485,9 +485,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	kvm->mmu_notifier_count++;
 	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
 					     range->flags);
-	need_tlb_flush |= kvm->tlbs_dirty;
 	/* we've to flush the tlb before the pages can be freed */
-	if (need_tlb_flush)
+	if (need_tlb_flush || kvm->tlbs_dirty)
 		kvm_flush_remote_tlbs(kvm);
 
 	spin_unlock(&kvm->mmu_lock);

