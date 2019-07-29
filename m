Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC8747932A
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 20:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388072AbfG2SfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 14:35:19 -0400
Received: from mail-io1-f48.google.com ([209.85.166.48]:45400 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388061AbfG2SfS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 14:35:18 -0400
Received: by mail-io1-f48.google.com with SMTP id g20so122247084ioc.12
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 11:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=qsJ3+SXKZ/xHar043EUyqbnMH9KAtxGORRoK9+K0kFQ=;
        b=usWsRFHdDMEG97MHY1qDw6P0hNfQm+lHSQD9Q7IYv12dHhGwkwBeZ9+Tb5F6NzFuzw
         6jWA9DOoMEnpzLI+S1VENVbr21RS8sdqhoCklx05vhVBCoSYRAwx00md+SpNqDY0PT/z
         wo1PRI/GXjGV0Q2ZqGEqTNf4pqI8zJPSFwwFQ1vanUEau9XzYehjzOiYkYox+CFG/13v
         kmihtWJ1+e8iu+oR0+k4b232Es1BeKlqBxcnbQFJKodHe2w1qUxDFnLRjhA5hZ9aGtw2
         LCwla62A+Dp0LrI/yfCIiwY4v1xS0wdnA4lj/MMbN2o29lmXpvi10bS/Xl7muSq+j/k8
         lamQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=qsJ3+SXKZ/xHar043EUyqbnMH9KAtxGORRoK9+K0kFQ=;
        b=EOkMN5lH1y0w/adxGY2Q/WfJP9SlFs5EJ9sIUZw0DgEKAOunLpTd5e99AwXWrFojON
         4Ds4JJd4RjrjPqv3i5FUgy+R7IvOjme3eiLN8vtJ6n8FyLhmPZHEpTxxKX0YUHAP38jt
         ETsPtin+qmnLptSg95v1QGwjC9pAPyJT0QxDaGCQvSAK+KXULpB68x3Zl6/jFC1TmigQ
         XCLBOh1OhKyOhcif34b4eNmiKH0+n9psKMp0noHa6eoFmTyeOrhhnKluyz7PCSCIjMcp
         klKJREdI8J1wVTV3WK0RV1d3QeBsovYi0O8hd8Wn9TBcFL7cMWAL+BUNMtHim8bpYJ2v
         xV3A==
X-Gm-Message-State: APjAAAVpllsOpQByJ9XQhhvMDfUdFMv76U+7DjxRc2mMs9MSPteXlO32
        m4OjPYGfpy7plVN4oUPzFCKr1HQjWu4=
X-Google-Smtp-Source: APXvYqxnzMBfhlcjldppOEAAa5h0K+CJlJIKwcc0AlkHmUPsCaqAk/p8XrfltprMiibf2gnjTMNGew==
X-Received: by 2002:a02:5a02:: with SMTP id v2mr111689595jaa.124.1564425317064;
        Mon, 29 Jul 2019 11:35:17 -0700 (PDT)
Received: from [192.168.1.57] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v3sm6661709ioh.58.2019.07.29.11.35.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 11:35:15 -0700 (PDT)
Subject: Re: fs/io_uring.c stable additions
From:   Jens Axboe <axboe@kernel.dk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <59d14d1f-441a-568c-246e-4ee1ea443278@kernel.dk>
 <20190729181528.GA25613@kroah.com>
 <abd31004-9c2f-ffa9-10b3-77ed4427d411@kernel.dk>
Message-ID: <93699ab7-35b2-338a-967d-bf0b432e8abf@kernel.dk>
Date:   Mon, 29 Jul 2019 12:35:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <abd31004-9c2f-ffa9-10b3-77ed4427d411@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------4A4988F1F9A9FEC29587C279"
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------4A4988F1F9A9FEC29587C279
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/19 12:17 PM, Jens Axboe wrote:
> On 7/29/19 12:15 PM, Greg Kroah-Hartman wrote:
>> On Mon, Jul 29, 2019 at 12:08:28PM -0600, Jens Axboe wrote:
>>> Hi,
>>>
>>> I forgot to mark a few patches for io_uring as stable. In order
>>> of how to apply, can you add the following commits for 5.2?
>>>
>>> f7b76ac9d17e16e44feebb6d2749fec92bfd6dd4
>>0ef67e605d2b1e8300d04fd9134d283bbbf441b9
>> Does not apply :(
>>
>>> c0e48f9dea9129aa11bec3ed13803bcc26e96e49
>>
>> Now queued up.
>>
>>> bd11b3a391e3df6fa958facbe4b3f9f4cca9bd49
>>
>> Does not apply :(
>>
>>> 36703247d5f52a679df9da51192b6950fe81689f
>>
>> Now queued up.
>>
>> You are 2 out of 4 :)
>>
>> Care to send backported versions of the 2 that did not apply?  I'll be
>> glad to queue them up then.
> 
> Huh strange, I applied them to our internal 5.2 tree without conflict.
> Maybe I had backported more...
> 
> I'll send versions for 5.2 in a bit for you.

Here you go, those two on top of the others. Ran it through the
regressions tests here, works for me.

-- 
Jens Axboe


--------------4A4988F1F9A9FEC29587C279
Content-Type: text/x-patch;
 name="0002-io_uring-don-t-use-iov_iter_advance-for-fixed-buffer.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-io_uring-don-t-use-iov_iter_advance-for-fixed-buffer.pa";
 filename*1="tch"

From b00254467e0d2fa90a82b5ffb7d8e990f6fee8df Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sat, 20 Jul 2019 08:37:31 -0600
Subject: [PATCH 2/2] io_uring: don't use iov_iter_advance() for fixed buffers

Hrvoje reports that when a large fixed buffer is registered and IO is
being done to the latter pages of said buffer, the IO submission time
is much worse:

reading to the start of the buffer: 11238 ns
reading to the end of the buffer:   1039879 ns

In fact, it's worse by two orders of magnitude. The reason for that is
how io_uring figures out how to setup the iov_iter. We point the iter
at the first bvec, and then use iov_iter_advance() to fast-forward to
the offset within that buffer we need.

However, that is abysmally slow, as it entails iterating the bvecs
that we setup as part of buffer registration. There's really no need
to use this generic helper, as we know it's a BVEC type iterator, and
we also know that each bvec is PAGE_SIZE in size, apart from possibly
the first and last. Hence we can just use a shift on the offset to
find the right index, and then adjust the iov_iter appropriately.
After this fix, the timings are:

reading to the start of the buffer: 10135 ns
reading to the end of the buffer:   1377 ns

Or about an 755x improvement for the tail page.

Reported-by: Hrvoje Zeba <zeba.hrvoje@gmail.com>
Tested-by: Hrvoje Zeba <zeba.hrvoje@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit bd11b3a391e3df6fa958facbe4b3f9f4cca9bd49)
---
 fs/io_uring.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c47f6bca760f..15e264e57f6c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -999,8 +999,43 @@ static int io_import_fixed(struct io_ring_ctx *ctx, int rw,
 	 */
 	offset = buf_addr - imu->ubuf;
 	iov_iter_bvec(iter, rw, imu->bvec, imu->nr_bvecs, offset + len);
-	if (offset)
-		iov_iter_advance(iter, offset);
+
+	if (offset) {
+		/*
+		 * Don't use iov_iter_advance() here, as it's really slow for
+		 * using the latter parts of a big fixed buffer - it iterates
+		 * over each segment manually. We can cheat a bit here, because
+		 * we know that:
+		 *
+		 * 1) it's a BVEC iter, we set it up
+		 * 2) all bvecs are PAGE_SIZE in size, except potentially the
+		 *    first and last bvec
+		 *
+		 * So just find our index, and adjust the iterator afterwards.
+		 * If the offset is within the first bvec (or the whole first
+		 * bvec, just use iov_iter_advance(). This makes it easier
+		 * since we can just skip the first segment, which may not
+		 * be PAGE_SIZE aligned.
+		 */
+		const struct bio_vec *bvec = imu->bvec;
+
+		if (offset <= bvec->bv_len) {
+			iov_iter_advance(iter, offset);
+		} else {
+			unsigned long seg_skip;
+
+			/* skip first vec */
+			offset -= bvec->bv_len;
+			seg_skip = 1 + (offset >> PAGE_SHIFT);
+
+			iter->bvec = bvec + seg_skip;
+			iter->nr_segs -= seg_skip;
+			iter->count -= (seg_skip << PAGE_SHIFT);
+			iter->iov_offset = offset & ~PAGE_MASK;
+			if (iter->iov_offset)
+				iter->count -= iter->iov_offset;
+		}
+	}
 
 	/* don't drop a reference to these pages */
 	iter->type |= ITER_BVEC_FLAG_NO_REF;
-- 
2.17.1


--------------4A4988F1F9A9FEC29587C279
Content-Type: text/x-patch;
 name="0001-io_uring-fix-counter-inc-dec-mismatch-in-async_list.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io_uring-fix-counter-inc-dec-mismatch-in-async_list.pat";
 filename*1="ch"

From 879d1e652332740de25ecc6091e7c1b82e7a3b24 Mon Sep 17 00:00:00 2001
From: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Date: Tue, 16 Jul 2019 23:26:14 +0800
Subject: [PATCH 1/2] io_uring: fix counter inc/dec mismatch in async_list

We could queue a work for each req in defer and link list without
increasing async_list->cnt, so we shouldn't decrease it while exiting
from workqueue as well if we didn't process the req in async list.

Thanks to Jens Axboe <axboe@kernel.dk> for his guidance.

Fixes: 31b515106428 ("io_uring: allow workqueue item to handle multiple buffered requests")
Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit f7b76ac9d17e16e44feebb6d2749fec92bfd6dd4)
---
 fs/io_uring.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c6598fb786c3..c47f6bca760f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -330,6 +330,9 @@ struct io_kiocb {
 #define REQ_F_SEQ_PREV		8	/* sequential with previous */
 #define REQ_F_IO_DRAIN		16	/* drain existing IO first */
 #define REQ_F_IO_DRAINED	32	/* drain done */
+#define REQ_F_LINK		64	/* linked sqes */
+#define REQ_F_LINK_DONE		128	/* linked sqes done */
+#define REQ_F_FAIL_LINK		256	/* fail rest of links */
 	u64			user_data;
 	u32			error;	/* iopoll result from callback */
 	u32			sequence;
@@ -1696,6 +1699,10 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 		/* async context always use a copy of the sqe */
 		kfree(sqe);
 
+		/* req from defer and link list needn't decrease async cnt */
+		if (req->flags & (REQ_F_IO_DRAINED | REQ_F_LINK_DONE))
+			goto out;
+
 		if (!async_list)
 			break;
 		if (!list_empty(&req_list)) {
@@ -1743,6 +1750,7 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 		}
 	}
 
+out:
 	if (cur_mm) {
 		set_fs(old_fs);
 		unuse_mm(cur_mm);
-- 
2.17.1


--------------4A4988F1F9A9FEC29587C279--
