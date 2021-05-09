Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26283776D9
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 15:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhEIN7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 09:59:45 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:35061 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229602AbhEIN7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 09:59:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id E9D851940C91;
        Sun,  9 May 2021 09:58:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 09 May 2021 09:58:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=0obg4/
        AHbYUXut8z1VEw0nbBWHBUfJCfEDIFfq33twU=; b=L/N0TFXAjGGHYJYCK99Fot
        wf4o8/ygrq6jalrzsewAg9Uv9uJH+GUa8s4mpizEIjty3Z4aB5DmDt2OZa7mhrb9
        NUOd+KnG2Qb6rFPTXek2UbWZ9WpaLUWutYzqd3VEgPiQ7KkTXaY1j17AhiuU5Hpv
        wY1mEzReXU+SkW57vZc9SVob3EyzDlv8Dh4pK0u1Anv0HAmDQhCrosWaNKMCJbAv
        nwhNP3k1otgZ5E50zz51UXQz7B0cgqhJ+r+C/S14ebVJ83G/+NubnLwG8BPOuChp
        23cu5VHxqOY5O4BR5gh6dPD5R3EbDOIJx6SLbw/GnYXV2WnSlOCqdZnPkBOF3nYw
        ==
X-ME-Sender: <xms:keqXYGaom7xqFgMaRayAtpnXILngqFgJLbbbHVr8rd4o4Iqu5Ztz_w>
    <xme:keqXYJZzkCFozN6C8bNsG5sQMedHTqSWYF4xNFS2zD08wxC5jKPAqdcetg4HmTosy
    jA4PDU_z_Bqgw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegiedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdluddtmdenucfjughrpefuvf
    fhfffkgggtgfesthekredttddtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihf
    ohhunhgurghtihhonhdrohhrgheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltd
    etgedugeffgffhudffuddukeegfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghr
    nhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:keqXYA9TAqzYJWIQV-nGxQVPMZc8pttrQg4nYOcBYnA9qZub-eWYOg>
    <xmx:keqXYIpDVCwA5QAjtPx-KQm3BmR1zjZ9xySpPF2HMHD7QfwAzktfNA>
    <xmx:keqXYBqCCsDoF9RRyxrDSGgENq8hIHBBLOAcWEWonMQt0t_RrC1aLQ>
    <xmx:keqXYI34tfgCtjSXjQICzQUyMAthtsqInUEHztkxVRa6k7xDeuI2wQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  9 May 2021 09:58:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] fuse: fix write deadlock" failed to apply to 4.4-stable tree
To:     vgoyal@redhat.com, cai@lca.pw, mszeredi@redhat.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 May 2021 15:58:39 +0200
Message-ID: <162056871933139@kroah.com>
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

From 4f06dd92b5d0a6f8eec6a34b8d6ef3e1f4ac1e10 Mon Sep 17 00:00:00 2001
From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 21 Oct 2020 16:12:49 -0400
Subject: [PATCH] fuse: fix write deadlock

There are two modes for write(2) and friends in fuse:

a) write through (update page cache, send sync WRITE request to userspace)

b) buffered write (update page cache, async writeout later)

The write through method kept all the page cache pages locked that were
used for the request.  Keeping more than one page locked is deadlock prone
and Qian Cai demonstrated this with trinity fuzzing.

The reason for keeping the pages locked is that concurrent mapped reads
shouldn't try to pull possibly stale data into the page cache.

For full page writes, the easy way to fix this is to make the cached page
be the authoritative source by marking the page PG_uptodate immediately.
After this the page can be safely unlocked, since mapped/cached reads will
take the written data from the cache.

Concurrent mapped writes will now cause data in the original WRITE request
to be updated; this however doesn't cause any data inconsistency and this
scenario should be exceedingly rare anyway.

If the WRITE request returns with an error in the above case, currently the
page is not marked uptodate; this means that a concurrent read will always
read consistent data.  After this patch the page is uptodate between
writing to the cache and receiving the error: there's window where a cached
read will read the wrong data.  While theoretically this could be a
regression, it is unlikely to be one in practice, since this is normal for
buffered writes.

In case of a partial page write to an already uptodate page the locking is
also unnecessary, with the above caveats.

Partial write of a not uptodate page still needs to be handled.  One way
would be to read the complete page before doing the write.  This is not
possible, since it might break filesystems that don't expect any READ
requests when the file was opened O_WRONLY.

The other solution is to serialize the synchronous write with reads from
the partial pages.  The easiest way to do this is to keep the partial pages
locked.  The problem is that a write() may involve two such pages (one head
and one tail).  This patch fixes it by only locking the partial tail page.
If there's a partial head page as well, then split that off as a separate
WRITE request.

Reported-by: Qian Cai <cai@lca.pw>
Link: https://lore.kernel.org/linux-fsdevel/4794a3fa3742a5e84fb0f934944204b55730829b.camel@lca.pw/
Fixes: ea9b9907b82a ("fuse: implement perform_write")
Cc: <stable@vger.kernel.org> # v2.6.26
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 8cccecb55fb8..eff4abaa87da 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1099,6 +1099,7 @@ static ssize_t fuse_send_write_pages(struct fuse_io_args *ia,
 	struct fuse_file *ff = file->private_data;
 	struct fuse_mount *fm = ff->fm;
 	unsigned int offset, i;
+	bool short_write;
 	int err;
 
 	for (i = 0; i < ap->num_pages; i++)
@@ -1113,32 +1114,38 @@ static ssize_t fuse_send_write_pages(struct fuse_io_args *ia,
 	if (!err && ia->write.out.size > count)
 		err = -EIO;
 
+	short_write = ia->write.out.size < count;
 	offset = ap->descs[0].offset;
 	count = ia->write.out.size;
 	for (i = 0; i < ap->num_pages; i++) {
 		struct page *page = ap->pages[i];
 
-		if (!err && !offset && count >= PAGE_SIZE)
-			SetPageUptodate(page);
-
-		if (count > PAGE_SIZE - offset)
-			count -= PAGE_SIZE - offset;
-		else
-			count = 0;
-		offset = 0;
-
-		unlock_page(page);
+		if (err) {
+			ClearPageUptodate(page);
+		} else {
+			if (count >= PAGE_SIZE - offset)
+				count -= PAGE_SIZE - offset;
+			else {
+				if (short_write)
+					ClearPageUptodate(page);
+				count = 0;
+			}
+			offset = 0;
+		}
+		if (ia->write.page_locked && (i == ap->num_pages - 1))
+			unlock_page(page);
 		put_page(page);
 	}
 
 	return err;
 }
 
-static ssize_t fuse_fill_write_pages(struct fuse_args_pages *ap,
+static ssize_t fuse_fill_write_pages(struct fuse_io_args *ia,
 				     struct address_space *mapping,
 				     struct iov_iter *ii, loff_t pos,
 				     unsigned int max_pages)
 {
+	struct fuse_args_pages *ap = &ia->ap;
 	struct fuse_conn *fc = get_fuse_conn(mapping->host);
 	unsigned offset = pos & (PAGE_SIZE - 1);
 	size_t count = 0;
@@ -1191,6 +1198,16 @@ static ssize_t fuse_fill_write_pages(struct fuse_args_pages *ap,
 		if (offset == PAGE_SIZE)
 			offset = 0;
 
+		/* If we copied full page, mark it uptodate */
+		if (tmp == PAGE_SIZE)
+			SetPageUptodate(page);
+
+		if (PageUptodate(page)) {
+			unlock_page(page);
+		} else {
+			ia->write.page_locked = true;
+			break;
+		}
 		if (!fc->big_writes)
 			break;
 	} while (iov_iter_count(ii) && count < fc->max_write &&
@@ -1234,7 +1251,7 @@ static ssize_t fuse_perform_write(struct kiocb *iocb,
 			break;
 		}
 
-		count = fuse_fill_write_pages(ap, mapping, ii, pos, nr_pages);
+		count = fuse_fill_write_pages(&ia, mapping, ii, pos, nr_pages);
 		if (count <= 0) {
 			err = count;
 		} else {
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 63d97a15ffde..74d888c78fa4 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -912,6 +912,7 @@ struct fuse_io_args {
 		struct {
 			struct fuse_write_in in;
 			struct fuse_write_out out;
+			bool page_locked;
 		} write;
 	};
 	struct fuse_args_pages ap;

