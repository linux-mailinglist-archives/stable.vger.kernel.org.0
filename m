Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30305312F49
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhBHKmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:42:39 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:51099 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232577AbhBHKke (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:40:34 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id D71251940ECB;
        Mon,  8 Feb 2021 05:39:22 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 05:39:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=SLsl1b
        xy7P6ojhREIit/A008DZQdkrILZYcKnc04iV4=; b=BXKAX+rDO5eJojiN+49dHi
        eFLyqoMA5J3i/TcPkbsa66ko/SbFvd2YSbnhAKQmx7qQM4VjkwXMQYQqVQX/mjIJ
        iGIHevfj75qy0opJ8lDx6AuPpXCh7WbR5aN8MiHhHWFJrUv0tTKAuIi9ojBp/AIl
        4XTRDXp5zUQP0dmGKFDuy7mdyHyon2IuPLZWN8+iCIke39w7uV7Mw2yC3e4P+8Tf
        aJfTH6nFntUwMymM13tLqXVJ9Hy/mNp4aAfGtEAy3hxlHmHDtYyxjCdMsa1ER9x0
        IpuRtye3cuSucnWq0TKbRbLyqmp8kEGK7tRfEyxHHeAMFNoCN58YrlEVJEgemrRA
        ==
X-ME-Sender: <xms:2hQhYJrDQrPmj1QYXs02bFZC45fbj9TGwGZ2l8rwqpd9TNiBV9T2uw>
    <xme:2hQhYLkll5UjkriyswieZl_0lHpU_QJp0c9JQku8feV3_nkmioPNHVk6Xx1I6Uueb
    lN9gpwlZxDZwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:2hQhYDE78FIp1MB0lPVIp2Z_6gbI6Ug_643CX5Vgoq1QUiQ55nJcBQ>
    <xmx:2hQhYMomTvZs5XyVpui0GmLFlb-KvRshe_T9PPPM-KMjMkcCn8gkww>
    <xmx:2hQhYH4JVxPANDbCfBXwIqrCbmhleCH1Td2lFUfB0adfwtyq0fti6g>
    <xmx:2hQhYGtVdAMLiZ5rtITAJqYe85cnReBD9oV_Alc3zFdaganICADKXg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5362924005B;
        Mon,  8 Feb 2021 05:39:22 -0500 (EST)
Subject: FAILED: patch "[PATCH] Fix unsynchronized access to sev members through" failed to apply to 4.19-stable tree
To:     pgonda@google.com, brijesh.singh@amd.com, hpa@zytor.com,
        joro@8bytes.org, mingo@redhat.com, pbonzini@redhat.com,
        seanjc@google.com, tglx@linutronix.de, thomas.lendacky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 11:39:12 +0100
Message-ID: <1612780752159105@kroah.com>
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

From 19a23da53932bc8011220bd8c410cb76012de004 Mon Sep 17 00:00:00 2001
From: Peter Gonda <pgonda@google.com>
Date: Wed, 27 Jan 2021 08:15:24 -0800
Subject: [PATCH] Fix unsynchronized access to sev members through
 svm_register_enc_region

Grab kvm->lock before pinning memory when registering an encrypted
region; sev_pin_memory() relies on kvm->lock being held to ensure
correctness when checking and updating the number of pinned pages.

Add a lockdep assertion to help prevent future regressions.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Fixes: 1e80fdc09d12 ("KVM: SVM: Pin guest memory when SEV is active")
Signed-off-by: Peter Gonda <pgonda@google.com>

V2
 - Fix up patch description
 - Correct file paths svm.c -> sev.c
 - Add unlock of kvm->lock on sev_pin_memory error

V1
 - https://lore.kernel.org/kvm/20210126185431.1824530-1-pgonda@google.com/

Message-Id: <20210127161524.2832400-1-pgonda@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ac652bc476ae..48017fef1cd9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -342,6 +342,8 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	unsigned long first, last;
 	int ret;
 
+	lockdep_assert_held(&kvm->lock);
+
 	if (ulen == 0 || uaddr + ulen < uaddr)
 		return ERR_PTR(-EINVAL);
 
@@ -1119,12 +1121,20 @@ int svm_register_enc_region(struct kvm *kvm,
 	if (!region)
 		return -ENOMEM;
 
+	mutex_lock(&kvm->lock);
 	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
 	if (IS_ERR(region->pages)) {
 		ret = PTR_ERR(region->pages);
+		mutex_unlock(&kvm->lock);
 		goto e_free;
 	}
 
+	region->uaddr = range->addr;
+	region->size = range->size;
+
+	list_add_tail(&region->list, &sev->regions_list);
+	mutex_unlock(&kvm->lock);
+
 	/*
 	 * The guest may change the memory encryption attribute from C=0 -> C=1
 	 * or vice versa for this memory range. Lets make sure caches are
@@ -1133,13 +1143,6 @@ int svm_register_enc_region(struct kvm *kvm,
 	 */
 	sev_clflush_pages(region->pages, region->npages);
 
-	region->uaddr = range->addr;
-	region->size = range->size;
-
-	mutex_lock(&kvm->lock);
-	list_add_tail(&region->list, &sev->regions_list);
-	mutex_unlock(&kvm->lock);
-
 	return ret;
 
 e_free:

