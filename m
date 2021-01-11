Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086F82F0E81
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 09:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbhAKItU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:49:20 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:58547 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728003AbhAKItU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:49:20 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 99A9E2576;
        Mon, 11 Jan 2021 03:48:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:48:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Uqri2R
        wsOFKAbMqE2HIEVo3FZ0AFs3PwiHKGp89sZqY=; b=eMDL1kLMO3t2u/OEyR+8jA
        NPUbpuNXPCjtCDhDRiXKRrrZRrOh+Sa2hBhXweC5yUwJHJXtLiuQEtWz4PyA+dkZ
        nJ00fHWA7M0AYFB+5/co8HaGvHxfi/7pb6LvlUYf7/r4VVHJVNIhgk6CJK694ThD
        wlVDnpR8qpxG1a0lk/dzne+JVGFNmJkrUp2NqQlA2U4IAUdZ4WbiZE7MjeveNarc
        DSBnS/Z+WOC01JSrLQjZVtCjyerWeBTT48U108wp2dDrOn/nBDmXQREcgamiqPrj
        ns/MPFKdGd2nGI5UAJiYOO+8Zlc+4GZZ0ZAtsWXJopPwGwDzjSzUH+yq5SHtT0pQ
        ==
X-ME-Sender: <xms:4hD8X_Zew8fivBxC_zyX_sI504EExboWZ8ENRlgho3bZgfOArWE8Sw>
    <xme:4hD8X11qGiZWKIJNeV-xRw7vlvwjqyitBaieMl_MLJsd1rq4Y7eFsFHaOB7kNKstl
    RqHYMGwVytHhA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:4hD8X_XfCN214T03qDqRjxMiww6YfKSWmAlvUP1iXr2yssREk5SNRQ>
    <xmx:4hD8X_X8o-oL2I6CFxQp21J6dIT-aHgOkpUFPw9lMfJSI67OMFvvGQ>
    <xmx:4hD8X-dNVE9W1lHcOh3jb6-Q684zRqtLbW40betIEDXeFJb6yDyWJg>
    <xmx:4hD8X_ja_5l8hrjcbdMn3-rwC8Hvw6srwLXBYXO9bfQ208izs41H5BFqVwY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0732324005E;
        Mon, 11 Jan 2021 03:48:33 -0500 (EST)
Subject: FAILED: patch "[PATCH] kvm: check tlbs_dirty directly" failed to apply to 4.14-stable tree
To:     laijs@linux.alibaba.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:49:44 +0100
Message-ID: <161035498424207@kroah.com>
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

