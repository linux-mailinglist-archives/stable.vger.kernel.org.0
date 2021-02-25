Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FFE324CBD
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 10:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbhBYJYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 04:24:25 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:60807 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236359AbhBYJYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 04:24:12 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id ECA14D65;
        Thu, 25 Feb 2021 04:23:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 25 Feb 2021 04:23:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NKqhnn
        UKcw40JG0jKgniK7aN0tOgpRf4nl8TVPpikJw=; b=a8N2Ejc5KdEBflv2IcOp2o
        RWTer1JhlMQtKli3FMh9es+Dl9EXC9Hfv5aP8Kw/r/8+zC1l+3zdOprzP7Jhzyhp
        IhAbXBv2iveUMVPFy3k8hAXVuip5Ub6EHpMsDYpsl5AOofAwZu8fwePbYCG+S246
        g2x3nGT+yZ2xKhbR/fcnrF34Eg7Sbn76xdTH59ij/psgEUOzapjCTK/rq9edCVhx
        U2Cu7wIHqeiBSbFrtbF3YZoqrCh22xNjF5tnI3VLdr8oBWjbsgk62RGADownISdP
        7hSLyZYWYka+HQxFhtmODmxuGOpaUdUBqTaknH6llK2uCe6oal8BagmuAtRTFbgQ
        ==
X-ME-Sender: <xms:eWw3YOZZ3elb8m4DOzpMelZkmEExGDQ7TnQFmXArb_2SpIJFaO6UTg>
    <xme:eWw3YBYHAg5CBa6DVLt7RPYzeHigVVAKACgE_64EADUet9hAJgjWTEOBpmo8cQZGE
    xne-eDJcwBQcg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeelgddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:eWw3YI8g41zIORZfLdV57rJITMNngSEVIrzgKqN6SlmBkIczvkUP9w>
    <xmx:eWw3YArDrOZY21WqtBFQX4ZXTeQzKB1A0Wjd1XzN1xX6_nZ0TbnT3g>
    <xmx:eWw3YJrLRSQmz_G93nicNSF3rAyUmPcjionX5a6VDV6oFIPdgMGPhA>
    <xmx:eWw3YA3ygNY1RgRPQ5ys3WL2bA7_yUgQkay9d6CE_mDZLJavr1xN57bZ4VA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E3F3B1080064;
        Thu, 25 Feb 2021 04:23:04 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: do not assume PTE is writable after follow_pfn" failed to apply to 4.19-stable tree
To:     pbonzini@redhat.com, jannh@google.com, jgg@ziepe.ca,
        stevensd@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Feb 2021 10:22:59 +0100
Message-ID: <161424497946158@kroah.com>
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

From bd2fae8da794b55bf2ac02632da3a151b10e664c Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 1 Feb 2021 05:12:11 -0500
Subject: [PATCH] KVM: do not assume PTE is writable after follow_pfn

In order to convert an HVA to a PFN, KVM usually tries to use
the get_user_pages family of functinso.  This however is not
possible for VM_IO vmas; in that case, KVM instead uses follow_pfn.

In doing this however KVM loses the information on whether the
PFN is writable.  That is usually not a problem because the main
use of VM_IO vmas with KVM is for BARs in PCI device assignment,
however it is a bug.  To fix it, use follow_pte and check pte_write
while under the protection of the PTE lock.  The information can
be used to fail hva_to_pfn_remapped or passed back to the
caller via *writable.

Usage of follow_pfn was introduced in commit add6a0cd1c5b ("KVM: MMU: try to fix
up page faults before giving up", 2016-07-05); however, even older version
have the same issue, all the way back to commit 2e2e3738af33 ("KVM:
Handle vma regions with no backing page", 2008-07-20), as they also did
not check whether the PFN was writable.

Fixes: 2e2e3738af33 ("KVM: Handle vma regions with no backing page")
Reported-by: David Stevens <stevensd@google.com>
Cc: 3pvd@google.com
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8367d88ce39b..335a1a2b8edc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1904,9 +1904,11 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       kvm_pfn_t *p_pfn)
 {
 	unsigned long pfn;
+	pte_t *ptep;
+	spinlock_t *ptl;
 	int r;
 
-	r = follow_pfn(vma, addr, &pfn);
+	r = follow_pte(vma->vm_mm, addr, NULL, &ptep, NULL, &ptl);
 	if (r) {
 		/*
 		 * get_user_pages fails for VM_IO and VM_PFNMAP vmas and does
@@ -1921,14 +1923,19 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 		if (r)
 			return r;
 
-		r = follow_pfn(vma, addr, &pfn);
+		r = follow_pte(vma->vm_mm, addr, NULL, &ptep, NULL, &ptl);
 		if (r)
 			return r;
+	}
 
+	if (write_fault && !pte_write(*ptep)) {
+		pfn = KVM_PFN_ERR_RO_FAULT;
+		goto out;
 	}
 
 	if (writable)
-		*writable = true;
+		*writable = pte_write(*ptep);
+	pfn = pte_pfn(*ptep);
 
 	/*
 	 * Get a reference here because callers of *hva_to_pfn* and
@@ -1943,6 +1950,8 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	 */ 
 	kvm_get_pfn(pfn);
 
+out:
+	pte_unmap_unlock(ptep, ptl);
 	*p_pfn = pfn;
 	return 0;
 }

