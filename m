Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7F83A5812
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 13:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbhFMLv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 07:51:57 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:52379 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhFMLv4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 07:51:56 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 4951711E7;
        Sun, 13 Jun 2021 07:49:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 13 Jun 2021 07:49:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Hz54mY
        E9DIARnDPUPtdG0JJdBLySc5mnWCQRROb2v3c=; b=lofnObpS4LNNXiYGC60WvD
        EKhheXXxJidCZHqzJhiBZzw4oU4VX9kfcv4XDQGyXsji/HCjgmpzcDycxN60gU95
        gAjkuYxmeoeosM+SHgyxXP+hpifD37+3CnWPAnXXKH47ru49JB21SH0x+ZgAVsqc
        aJSqEgXHs6Y79JVQpWTzWxQ0KquTIaH8Z//1qLLIcO2GsXu9CDRsp+w+wUFOyn9P
        dw8yZJ7yQpuwYSY7ELOhd9HqGYi0pLRNcTYN5L7Nlv+MtrOcz/HaSvvxehri+tiV
        OEQK29Pg18alw2UkygaijmuEESrHkCfnHLI43WikeUPvIb8gUqTFGxyARizU3tDw
        ==
X-ME-Sender: <xms:3_DFYHUF40722CqrNNCp98N81BkyseTsJL3P9lGDSNPdfc_UoV8h1g>
    <xme:3_DFYPmMYlP_CoyPc9sgUFu6fh4aXwfRLzI5ptA3JG9bmy5ert7dN3jd1HWg8k6CH
    SybPDT_bwc58Q>
X-ME-Received: <xmr:3_DFYDYUiuZGyItQnDjMq8AhNI4mU9vjjfJQM0RAnNkX5gkMx4K-HKX6iN0s8saTM3OhR_6gp29aB0zcDlTtJpkH-HD7npaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:3_DFYCWLnvGZXspBMgE3G4619H8C88L8KCf2InoaiNe7eYPsuQP6TA>
    <xmx:3_DFYBlB5OlmKJuyGsi74GKHmxdchAuZoy-evuwXh-i61ZqoLwklfg>
    <xmx:3_DFYPfJntrVoQEalr4zdah-efgLJmCCUBs_5MnFZ_77V30Vs-riEw>
    <xmx:4fDFYG-iPxVP4XjUjPNzt9ZRHdO-ET5CNShNprrsbmj65WZbQOy2sLLPharIBI9g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 07:49:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bcache: avoid oversized read request in cache missing code" failed to apply to 5.10-stable tree
To:     colyli@suse.de, axboe@kernel.dk, bcache@mfedv.net,
        diego.ercolani@gmail.com, ealex1979@gmail.com, hch@lst.de,
        jan.szubiak@linuxpolska.pl, kent.overstreet@gmail.com,
        linux@thorsten-knabe.de, me@dblsaiko.net, nix@esperi.org.uk,
        rolf@rolffokkens.nl, tiwai@suse.com, victor@westerhu.is,
        vojtech@suse.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 13:49:49 +0200
Message-ID: <16235849893166@kroah.com>
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

From 41fe8d088e96472f63164e213de44ec77be69478 Mon Sep 17 00:00:00 2001
From: Coly Li <colyli@suse.de>
Date: Mon, 7 Jun 2021 20:50:52 +0800
Subject: [PATCH] bcache: avoid oversized read request in cache missing code
 path

In the cache missing code path of cached device, if a proper location
from the internal B+ tree is matched for a cache miss range, function
cached_dev_cache_miss() will be called in cache_lookup_fn() in the
following code block,
[code block 1]
  526         unsigned int sectors = KEY_INODE(k) == s->iop.inode
  527                 ? min_t(uint64_t, INT_MAX,
  528                         KEY_START(k) - bio->bi_iter.bi_sector)
  529                 : INT_MAX;
  530         int ret = s->d->cache_miss(b, s, bio, sectors);

Here s->d->cache_miss() is the call backfunction pointer initialized as
cached_dev_cache_miss(), the last parameter 'sectors' is an important
hint to calculate the size of read request to backing device of the
missing cache data.

Current calculation in above code block may generate oversized value of
'sectors', which consequently may trigger 2 different potential kernel
panics by BUG() or BUG_ON() as listed below,

1) BUG_ON() inside bch_btree_insert_key(),
[code block 2]
   886         BUG_ON(b->ops->is_extents && !KEY_SIZE(k));
2) BUG() inside biovec_slab(),
[code block 3]
   51         default:
   52                 BUG();
   53                 return NULL;

All the above panics are original from cached_dev_cache_miss() by the
oversized parameter 'sectors'.

Inside cached_dev_cache_miss(), parameter 'sectors' is used to calculate
the size of data read from backing device for the cache missing. This
size is stored in s->insert_bio_sectors by the following lines of code,
[code block 4]
  909    s->insert_bio_sectors = min(sectors, bio_sectors(bio) + reada);

Then the actual key inserting to the internal B+ tree is generated and
stored in s->iop.replace_key by the following lines of code,
[code block 5]
  911   s->iop.replace_key = KEY(s->iop.inode,
  912                    bio->bi_iter.bi_sector + s->insert_bio_sectors,
  913                    s->insert_bio_sectors);
The oversized parameter 'sectors' may trigger panic 1) by BUG_ON() from
the above code block.

And the bio sending to backing device for the missing data is allocated
with hint from s->insert_bio_sectors by the following lines of code,
[code block 6]
  926    cache_bio = bio_alloc_bioset(GFP_NOWAIT,
  927                 DIV_ROUND_UP(s->insert_bio_sectors, PAGE_SECTORS),
  928                 &dc->disk.bio_split);
The oversized parameter 'sectors' may trigger panic 2) by BUG() from the
agove code block.

Now let me explain how the panics happen with the oversized 'sectors'.
In code block 5, replace_key is generated by macro KEY(). From the
definition of macro KEY(),
[code block 7]
  71 #define KEY(inode, offset, size)                                  \
  72 ((struct bkey) {                                                  \
  73      .high = (1ULL << 63) | ((__u64) (size) << 20) | (inode),     \
  74      .low = (offset)                                              \
  75 })

Here 'size' is 16bits width embedded in 64bits member 'high' of struct
bkey. But in code block 1, if "KEY_START(k) - bio->bi_iter.bi_sector" is
very probably to be larger than (1<<16) - 1, which makes the bkey size
calculation in code block 5 is overflowed. In one bug report the value
of parameter 'sectors' is 131072 (= 1 << 17), the overflowed 'sectors'
results the overflowed s->insert_bio_sectors in code block 4, then makes
size field of s->iop.replace_key to be 0 in code block 5. Then the 0-
sized s->iop.replace_key is inserted into the internal B+ tree as cache
missing check key (a special key to detect and avoid a racing between
normal write request and cache missing read request) as,
[code block 8]
  915   ret = bch_btree_insert_check_key(b, &s->op, &s->iop.replace_key);

Then the 0-sized s->iop.replace_key as 3rd parameter triggers the bkey
size check BUG_ON() in code block 2, and causes the kernel panic 1).

Another kernel panic is from code block 6, is by the bvecs number
oversized value s->insert_bio_sectors from code block 4,
        min(sectors, bio_sectors(bio) + reada)
There are two possibility for oversized reresult,
- bio_sectors(bio) is valid, but bio_sectors(bio) + reada is oversized.
- sectors < bio_sectors(bio) + reada, but sectors is oversized.

From a bug report the result of "DIV_ROUND_UP(s->insert_bio_sectors,
PAGE_SECTORS)" from code block 6 can be 344, 282, 946, 342 and many
other values which larther than BIO_MAX_VECS (a.k.a 256). When calling
bio_alloc_bioset() with such larger-than-256 value as the 2nd parameter,
this value will eventually be sent to biovec_slab() as parameter
'nr_vecs' in following code path,
   bio_alloc_bioset() ==> bvec_alloc() ==> biovec_slab()
Because parameter 'nr_vecs' is larger-than-256 value, the panic by BUG()
in code block 3 is triggered inside biovec_slab().

From the above analysis, we know that the 4th parameter 'sector' sent
into cached_dev_cache_miss() may cause overflow in code block 5 and 6,
and finally cause kernel panic in code block 2 and 3. And if result of
bio_sectors(bio) + reada exceeds valid bvecs number, it may also trigger
kernel panic in code block 3 from code block 6.

Now the almost-useless readahead size for cache missing request back to
backing device is removed, this patch can fix the oversized issue with
more simpler method.
- add a local variable size_limit,  set it by the minimum value from
  the max bkey size and max bio bvecs number.
- set s->insert_bio_sectors by the minimum value from size_limit,
  sectors, and the sectors size of bio.
- replace sectors by s->insert_bio_sectors to do bio_next_split.

By the above method with size_limit, s->insert_bio_sectors will never
result oversized replace_key size or bio bvecs number. And split bio
'miss' from bio_next_split() will always match the size of 'cache_bio',
that is the current maximum bio size we can sent to backing device for
fetching the cache missing data.

Current problmatic code can be partially found since Linux v3.13-rc1,
therefore all maintained stable kernels should try to apply this fix.

Reported-by: Alexander Ullrich <ealex1979@gmail.com>
Reported-by: Diego Ercolani <diego.ercolani@gmail.com>
Reported-by: Jan Szubiak <jan.szubiak@linuxpolska.pl>
Reported-by: Marco Rebhan <me@dblsaiko.net>
Reported-by: Matthias Ferdinand <bcache@mfedv.net>
Reported-by: Victor Westerhuis <victor@westerhu.is>
Reported-by: Vojtech Pavlik <vojtech@suse.cz>
Reported-and-tested-by: Rolf Fokkens <rolf@rolffokkens.nl>
Reported-and-tested-by: Thorsten Knabe <linux@thorsten-knabe.de>
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Nix <nix@esperi.org.uk>
Cc: Takashi Iwai <tiwai@suse.com>
Link: https://lore.kernel.org/r/20210607125052.21277-3-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index ab8ff18df32a..6d1de889baeb 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -882,6 +882,7 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 	int ret = MAP_CONTINUE;
 	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 	struct bio *miss, *cache_bio;
+	unsigned int size_limit;
 
 	s->cache_missed = 1;
 
@@ -891,7 +892,10 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 		goto out_submit;
 	}
 
-	s->insert_bio_sectors = min(sectors, bio_sectors(bio));
+	/* Limitation for valid replace key size and cache_bio bvecs number */
+	size_limit = min_t(unsigned int, BIO_MAX_VECS * PAGE_SECTORS,
+			   (1 << KEY_SIZE_BITS) - 1);
+	s->insert_bio_sectors = min3(size_limit, sectors, bio_sectors(bio));
 
 	s->iop.replace_key = KEY(s->iop.inode,
 				 bio->bi_iter.bi_sector + s->insert_bio_sectors,
@@ -903,7 +907,8 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 
 	s->iop.replace = true;
 
-	miss = bio_next_split(bio, sectors, GFP_NOIO, &s->d->bio_split);
+	miss = bio_next_split(bio, s->insert_bio_sectors, GFP_NOIO,
+			      &s->d->bio_split);
 
 	/* btree_search_recurse()'s btree iterator is no good anymore */
 	ret = miss == bio ? MAP_DONE : -EINTR;

