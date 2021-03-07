Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3999330153
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhCGNoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:44:20 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:58259 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231423AbhCGNoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:44:00 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 43BCF186F;
        Sun,  7 Mar 2021 08:44:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:44:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=v0AdcU
        m14X5igm7GY+QWWhKF4QkOMcjIZPAcT5P8EII=; b=lmF7zP8SNxIJ8GvtKTrtFa
        WDI8hsYcdIJ84akELZx3x3I0QIY230FBqKO3aVSQJIfG3Lf1GO9XJsnjsmLnJBMY
        oeV5qn4cPATJl7fV03ZWNYcOcMh4dgKHXKM4y/jaDWwL65Em4goQDmDZA/tVldIo
        ZFjL384PxVp6Nl8c/j1CfDGJWLJnqeUWDWqTAmWVh16TrLGlVVmipqk+dZlwUN3e
        H59ZDMx+FYjZxQ/YC/0bepO8aaOdNHjEZTz6K9cBTf6Jjr20yDVQPw2PWzxtZ2Br
        d/oPvEdkTKYDKR4XJYMvkGc5iK9TsxueDB9oqXJYP9pTutGTEaYvNCAyEl2Tp/Dg
        ==
X-ME-Sender: <xms:n9hEYFOdJo_hIlNGrVyVrQNgYWPHYarGZrd8X131cfne1u08vlUiGA>
    <xme:n9hEYH-qQ-_DC2seryYk2siJd_hY9-0hIwS6oHWlSlEsc_BbiVwDMAFnX222kFfXR
    uuCS_YJdlTxcA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:n9hEYEQKcvEXjQyZRcdEHGGj5ir4Y2ZURPJ6AcdoPncopA-rcpokag>
    <xmx:n9hEYBvjWvZyzodidup8X1NQvZHpSHfhLSfQTH1Wrbm0BQ8--2SkFw>
    <xmx:n9hEYNe45I9nYQFZv4lRkyeisnroGoUavZjJAQdP-hot9r5C7DKt6A>
    <xmx:n9hEYNmrNNTHk2XEa96n_xYgPUWycojnuV5SuOqFxl14BXsE0vjA47F81Io>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6FB74108005C;
        Sun,  7 Mar 2021 08:43:59 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: fix raid6 qstripe kmap" failed to apply to 4.4-stable tree
To:     ira.weiny@intel.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:43:58 +0100
Message-ID: <161512463810984@kroah.com>
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

From d70cef0d46729808dc53f145372c02b145c92604 Mon Sep 17 00:00:00 2001
From: Ira Weiny <ira.weiny@intel.com>
Date: Wed, 27 Jan 2021 22:15:03 -0800
Subject: [PATCH] btrfs: fix raid6 qstripe kmap

When a qstripe is required an extra page is allocated and mapped.  There
were 3 problems:

1) There is no corresponding call of kunmap() for the qstripe page.
2) There is no reason to map the qstripe page more than once if the
   number of bits set in rbio->dbitmap is greater than one.
3) There is no reason to map the parity page and unmap it each time
   through the loop.

The page memory can continue to be reused with a single mapping on each
iteration by raid6_call.gen_syndrome() without remapping.  So map the
page for the duration of the loop.

Similarly, improve the algorithm by mapping the parity page just 1 time.

Fixes: 5a6ac9eacb49 ("Btrfs, raid56: support parity scrub on raid56")
CC: stable@vger.kernel.org # 4.4.x: c17af96554a8: btrfs: raid56: simplify tracking of Q stripe presence
CC: stable@vger.kernel.org # 4.4.x
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 5394641541f7..abf17fae0912 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2362,16 +2362,21 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 	SetPageUptodate(p_page);
 
 	if (has_qstripe) {
+		/* RAID6, allocate and map temp space for the Q stripe */
 		q_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
 		if (!q_page) {
 			__free_page(p_page);
 			goto cleanup;
 		}
 		SetPageUptodate(q_page);
+		pointers[rbio->real_stripes - 1] = kmap(q_page);
 	}
 
 	atomic_set(&rbio->error, 0);
 
+	/* Map the parity stripe just once */
+	pointers[nr_data] = kmap(p_page);
+
 	for_each_set_bit(pagenr, rbio->dbitmap, rbio->stripe_npages) {
 		struct page *p;
 		void *parity;
@@ -2381,16 +2386,8 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 			pointers[stripe] = kmap(p);
 		}
 
-		/* then add the parity stripe */
-		pointers[stripe++] = kmap(p_page);
-
 		if (has_qstripe) {
-			/*
-			 * raid6, add the qstripe and call the
-			 * library function to fill in our p/q
-			 */
-			pointers[stripe++] = kmap(q_page);
-
+			/* RAID6, call the library function to fill in our P/Q */
 			raid6_call.gen_syndrome(rbio->real_stripes, PAGE_SIZE,
 						pointers);
 		} else {
@@ -2411,12 +2408,14 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 
 		for (stripe = 0; stripe < nr_data; stripe++)
 			kunmap(page_in_rbio(rbio, stripe, pagenr, 0));
-		kunmap(p_page);
 	}
 
+	kunmap(p_page);
 	__free_page(p_page);
-	if (q_page)
+	if (q_page) {
+		kunmap(q_page);
 		__free_page(q_page);
+	}
 
 writeback:
 	/*

