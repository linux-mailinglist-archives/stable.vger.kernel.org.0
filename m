Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B930324CBB
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 10:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbhBYJYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 04:24:22 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:52317 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236295AbhBYJXv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 04:23:51 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id BF0D0D1B;
        Thu, 25 Feb 2021 04:23:03 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 25 Feb 2021 04:23:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xt+b+d
        bOoHLC9oUIdf3n+LPtrFWttnipIyLdD3dUCJc=; b=bFIcFPDXxgNQsKu4+u9tTW
        ssiu71gM1NiOopP6moK4sFB28KYzrKvqP5kTE1Ti7Q920OTJH72kFQUYU8v3ZAJD
        haAWvcDEK6Qa6CF12nNweRtO4Aztkm4CCQXiIQCFXNoORj1UIqbythbOCvekXTEx
        TWPoxIHIksCUm4LKcVcF8CvZ5K6hD9Q0AftR9HqFkNs9e0A6MquUt3Mbzyvfp2b+
        34ONyo7fjLdQLOZlTqx41MgmeII7hsTgdk4w1c/wI6j9jj/C3rZMj7ReG2FD/RJM
        SbzUpMunwybu7HJzRnC/9zDzybU9veMH2aeF6i0mPu/KU/ylc+qokFZT9rcCybYA
        ==
X-ME-Sender: <xms:d2w3YL7gg4ap8sLgZEtoHg0CjtofsKD_mYUhd80Md_6VGYaQl1ACRQ>
    <xme:d2w3YA6BL_0wzK_cPXwmEHrvcaR1t5zzQmQoauFxq_U0Y_W3JHKpOcm45cW2Uzm5w
    fwQn2RGtF6Yyw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeelgddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:d2w3YCffdI_6KuqW-WCDZXX47-Z959b-gU1zib5eGZ8ed_0bsr5UUg>
    <xmx:d2w3YMJ5F-Q_gFD0AGwnKchs0G3O5gw3XlvBJOhOUPCh6DPc6OAR2Q>
    <xmx:d2w3YPLnfuwYHgcwbVEeR-Y6Z7yfAVz7HuaUtd71gBDEf09xfWO5MA>
    <xmx:d2w3YGVBMN-QBRegM3HL5ZOoSiAo6QCdGVO5Wn7I8uqGpyZrSuPeN0F8Q5w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0FBE6240067;
        Thu, 25 Feb 2021 04:23:02 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: do not assume PTE is writable after follow_pfn" failed to apply to 4.14-stable tree
To:     pbonzini@redhat.com, jannh@google.com, jgg@ziepe.ca,
        stevensd@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Feb 2021 10:22:57 +0100
Message-ID: <161424497767224@kroah.com>
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

