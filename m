Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E7A304B87
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbhAZEj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:39:29 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:50547 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729615AbhAYOmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 09:42:24 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 5547E19538CC;
        Mon, 25 Jan 2021 09:14:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 Jan 2021 09:14:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PBFj+X
        nVQ4v2N1jfRlqc1xg+ebE4dLTVPbsp5toR2eI=; b=raJL2kIkM29xbrm78SQ4T9
        YJwcJTHtezyTG95VnLB9oY5Rt5cgoHVSemvVtwXrbpItFhCCvVZPDLxa587w/V2C
        fafS2sdgVKX07tyuhvTpCbSKjFUa5bn0rtrd1i3+FcxgpiapbmoWdlYTEGtDfmOk
        66Rz1SSd60cR3Tw7JYfPdwJ8OJqQQHtcOeSBq9pn1zZ6jcY940O8bcnYjeRhNTlU
        NzlRZ09oPJn3XjASyLiN/4QHfD28idhs4rZ6oWEiAOWZtzZ3iduRcd9G3FBD8iCX
        RlQ+X9U8rVzf5qImFWVrgnslwxAICXKHYiCE8xJKWbmWdkTI7FAIDuK4dNYrKvqA
        ==
X-ME-Sender: <xms:W9IOYEvEJ-44zBkxwS6JEfH09sY32QMmtgNLbPoNdwc7xHM7dB5oVA>
    <xme:W9IOYBcSZGgRe3368jYrRSwyBVg4-l1AwogfhwnQHHCFPfgzN0qOLkum2mnrcPpxQ
    sh16XFbxagHSQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeimdenucfjughrpefuvffhff
    fkgggtgfesthekredttddtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhu
    nhgurghtihhonhdrohhrgheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetge
    dugeffgffhudffuddukeegfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgv
    lhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpe
    dvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:W9IOYPy1cPFjNXsFhVuZ0EMr95-cwlv4BVKCBDDnoF4g2oOqSAnFIw>
    <xmx:W9IOYHNQsaEjBiQ53qXR9n1SIvZyJ4eH6l3J2DEx1pO0Ri7afRWOIQ>
    <xmx:W9IOYE9XDkcQFSAx9fXt5vIxqNvFEQIRldSf6zkwk1mQMg-jdF9_Ag>
    <xmx:XdIOYEzSCoVmBfK-B08WvyuPnpJuUXjZqiiuGv-pUZ7NQNHjoHBnGw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D4E2A240062;
        Mon, 25 Jan 2021 09:14:50 -0500 (EST)
Subject: FAILED: patch "[PATCH] mm: fix page reference leak in soft_offline_page()" failed to apply to 5.10-stable tree
To:     dan.j.williams@intel.com, akpm@linux-foundation.org, cai@lca.pw,
        david@redhat.com, mhocko@suse.com, naoya.horiguchi@nec.com,
        osalvador@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 15:14:49 +0100
Message-ID: <16115840891069@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dad4e5b390866ca902653df0daa864ae4b8d4147 Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Jan 2021 21:01:52 -0800
Subject: [PATCH] mm: fix page reference leak in soft_offline_page()

The conversion to move pfn_to_online_page() internal to
soft_offline_page() missed that the get_user_pages() reference taken by
the madvise() path needs to be dropped when pfn_to_online_page() fails.

Note the direct sysfs-path to soft_offline_page() does not perform a
get_user_pages() lookup.

When soft_offline_page() is handed a pfn_valid() && !pfn_to_online_page()
pfn the kernel hangs at dax-device shutdown due to a leaked reference.

Link: https://lkml.kernel.org/r/161058501210.1840162.8108917599181157327.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: feec24a6139d ("mm, soft-offline: convert parameter to pfn")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 04d9f154a130..e9481632fcd1 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1885,6 +1885,12 @@ static int soft_offline_free_page(struct page *page)
 	return rc;
 }
 
+static void put_ref_page(struct page *page)
+{
+	if (page)
+		put_page(page);
+}
+
 /**
  * soft_offline_page - Soft offline a page.
  * @pfn: pfn to soft-offline
@@ -1910,20 +1916,26 @@ static int soft_offline_free_page(struct page *page)
 int soft_offline_page(unsigned long pfn, int flags)
 {
 	int ret;
-	struct page *page;
 	bool try_again = true;
+	struct page *page, *ref_page = NULL;
+
+	WARN_ON_ONCE(!pfn_valid(pfn) && (flags & MF_COUNT_INCREASED));
 
 	if (!pfn_valid(pfn))
 		return -ENXIO;
+	if (flags & MF_COUNT_INCREASED)
+		ref_page = pfn_to_page(pfn);
+
 	/* Only online pages can be soft-offlined (esp., not ZONE_DEVICE). */
 	page = pfn_to_online_page(pfn);
-	if (!page)
+	if (!page) {
+		put_ref_page(ref_page);
 		return -EIO;
+	}
 
 	if (PageHWPoison(page)) {
 		pr_info("%s: %#lx page already poisoned\n", __func__, pfn);
-		if (flags & MF_COUNT_INCREASED)
-			put_page(page);
+		put_ref_page(ref_page);
 		return 0;
 	}
 

