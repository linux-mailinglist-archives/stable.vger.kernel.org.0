Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EFC312F44
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbhBHKmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:42:14 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:56757 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232530AbhBHKkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:40:02 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8D16E1940EB5;
        Mon,  8 Feb 2021 05:39:14 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 05:39:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mMYQqx
        tsAhnjLpy8Zr/K1zdBRRKajfghBvfcLyV9NGk=; b=GIr13esdgus4aRaSsHh9u7
        XBz6AlSmWK/MfexX6B5dQ1waWfNuiVIFv5oaH4Vq5LCeotXoaTU98tnr/Tsh7tY1
        8q2cWfmb+D+7HEPoL9O3fieDLFdQHkjZTCLiiU3QdqjoFugFr1Bb+iyjrHA5BWhc
        JJPiD3Bvqost8OIEbm54p5rwSgBd3UWUbCVePUFLLx9IVdYgSXJ7ynkevXC3YMP/
        NqdZR5pGQ0H+mqRGQlZ5BJZBISlQ9pZNGL+hamLh7ypCnqON05QlVpXrC8UN8oVp
        fK/0cUAt5jkgkMjjoi250XlPcB99EnFreHfESSjjQVO/o+37iMZPn9ED+GmmZt0A
        ==
X-ME-Sender: <xms:0RQhYIi6Wrl6sfgr_mwlmyf6PdtGN9P1qt7CuOmwxdSfiB9mOInFuQ>
    <xme:0RQhYBC4jZxs9Alj0k2IQxm0MZVCEfDBaruzGqVHHvv8ejGR0FnOxT344Oc5DjuXJ
    TNzTzT6ODocwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:0RQhYAEX1oHWVODN9CVq3ITvLEUXNSZInLxFMyeUftXWoHNWiUprjw>
    <xmx:0RQhYJQdovgAnJN_eqdY8umLJYYa9QX8Ud0mT9lUJeCIYHw57az8Cg>
    <xmx:0RQhYFxUTVzqZeUGmPpLvhIXj6MS6FCW8MzfwwbDyuqsdOWA7wUHjQ>
    <xmx:0hQhYExmFTUWzN0L8N_ottFcFOKZZ3US-hbeYRtyg_2ounOb5C866w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6B40E1080059;
        Mon,  8 Feb 2021 05:39:13 -0500 (EST)
Subject: FAILED: patch "[PATCH] Fix unsynchronized access to sev members through" failed to apply to 5.4-stable tree
To:     pgonda@google.com, brijesh.singh@amd.com, hpa@zytor.com,
        joro@8bytes.org, mingo@redhat.com, pbonzini@redhat.com,
        seanjc@google.com, tglx@linutronix.de, thomas.lendacky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 11:39:11 +0100
Message-ID: <16127807510201@kroah.com>
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

