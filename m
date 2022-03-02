Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01CA4CB054
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 21:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbiCBUz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 15:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbiCBUz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 15:55:28 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FC1CA0C7
        for <stable@vger.kernel.org>; Wed,  2 Mar 2022 12:54:44 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id p9so4651801wra.12
        for <stable@vger.kernel.org>; Wed, 02 Mar 2022 12:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0k5V8XQT1kIkFBTCHU61QYa67i+DQ43L+fd7B6a3YQo=;
        b=Zx4k6mAeOT+h3fmpwIvQDzTSuQl0Ui38oTVB8KAmNEzcx3SElqjcMnO1VPGfZyu9+6
         Qt9kypT/Zd1Ijo1QWC5gQXqnUWKTZ0QaiPRL6mwhj1MyB9lEIJIFbX4zsGBAWfMs5OUh
         J/U9Tw8oynJ+UWcDAxLEEVLHdfRLgXG+f1iguTox1QG4dTbLYD08uHz+scIbhsaQfMUd
         rAde9PDAFXasGWIVfRA5Zmv2odvQ1kxTWFYZotHoX4ae2eda5RIrwHHAWAvCGrhI6QNE
         j6kFQR82FKlqHWzKOb7ek8opYpuPSfzMuRS8xbHCGEeYgws4v1/qKqwJzA1Ndh423BH2
         rJ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0k5V8XQT1kIkFBTCHU61QYa67i+DQ43L+fd7B6a3YQo=;
        b=BNElcMWlDNKBDDVvW8lu09WWtY/uaLQOW4FfKYnJtUhhRj6XFk/T2SqnFSOzeaadTr
         kQ3mkFj89BjlgvWLnqHtanUEyuO3BIU+nAiVIjG6UdLS65H0ecpOyMRpWTP6aH8rWVcN
         4NvIxyw12VUlRszrmXRbRad8/PJiIN6wp37l6NgJGB9Jy5fpGwOCfrF4QVsg9AlZyyi4
         OQi8BAvs5l+f24CokFYhdvUMLHshjdBwMZoWbXOuJDcgR4Yc3hWs3prszWv7mrXRBg+S
         rTjtsZzgJHnrbr/iBcSz+Dd2H9RHyHt6brQG18MUq0FA8k8FjscCIiwHxgKFUJPz/JT0
         vOkg==
X-Gm-Message-State: AOAM5323l1uzjBEpqrh6hJu0fo8RBwnrCAG++D0ZjH5swQZA+Ysh6cnN
        5SkDEKRKPwnujVwQ8xk5uSI=
X-Google-Smtp-Source: ABdhPJxy1jLhkOjzJb7TfhscTh8JUqwPS+YjcZWVGe0pUPxm3Mf/52QtSHcC9RcySOAp/SvwoN4VNg==
X-Received: by 2002:a5d:614e:0:b0:1f0:2467:fb69 with SMTP id y14-20020a5d614e000000b001f02467fb69mr4711040wrt.120.1646254482441;
        Wed, 02 Mar 2022 12:54:42 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id ay10-20020a5d6f0a000000b001f02d3ec83csm76336wrb.59.2022.03.02.12.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 12:54:41 -0800 (PST)
Date:   Wed, 2 Mar 2022 20:54:39 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     yebin10@huawei.com, axboe@kernel.dk, ming.lei@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] block: Fix fsync always failed if once
 failed" failed to apply to 5.4-stable tree
Message-ID: <Yh/Zj26uAHUXAs2K@debian>
References: <1643023500176181@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XWUWXPEp/xKnkj0X"
Content-Disposition: inline
In-Reply-To: <1643023500176181@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XWUWXPEp/xKnkj0X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Jan 24, 2022 at 12:25:00PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--XWUWXPEp/xKnkj0X
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-block-Fix-fsync-always-failed-if-once-failed.patch"

From d6a901c1842ff2b9fdcbe19a7e785e4b095f6300 Mon Sep 17 00:00:00 2001
From: Ye Bin <yebin10@huawei.com>
Date: Mon, 29 Nov 2021 09:26:59 +0800
Subject: [PATCH] block: Fix fsync always failed if once failed

commit 8a7518931baa8ea023700987f3db31cb0a80610b upstream.

We do test with inject error fault base on v4.19, after test some time we found
sync /dev/sda always failed.
[root@localhost] sync /dev/sda
sync: error syncing '/dev/sda': Input/output error

scsi log as follows:
[19069.812296] sd 0:0:0:0: [sda] tag#64 Send: scmd 0x00000000d03a0b6b
[19069.812302] sd 0:0:0:0: [sda] tag#64 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
[19069.812533] sd 0:0:0:0: [sda] tag#64 Done: SUCCESS Result: hostbyte=DID_OK driverbyte=DRIVER_OK
[19069.812536] sd 0:0:0:0: [sda] tag#64 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
[19069.812539] sd 0:0:0:0: [sda] tag#64 scsi host busy 1 failed 0
[19069.812542] sd 0:0:0:0: Notifying upper driver of completion (result 0)
[19069.812546] sd 0:0:0:0: [sda] tag#64 sd_done: completed 0 of 0 bytes
[19069.812549] sd 0:0:0:0: [sda] tag#64 0 sectors total, 0 bytes done.
[19069.812564] print_req_error: I/O error, dev sda, sector 0

ftrace log as follows:
 rep-306069 [007] .... 19654.923315: block_bio_queue: 8,0 FWS 0 + 0 [rep]
 rep-306069 [007] .... 19654.923333: block_getrq: 8,0 FWS 0 + 0 [rep]
 kworker/7:1H-250   [007] .... 19654.923352: block_rq_issue: 8,0 FF 0 () 0 + 0 [kworker/7:1H]
 <idle>-0     [007] ..s. 19654.923562: block_rq_complete: 8,0 FF () 18446744073709551615 + 0 [0]
 <idle>-0     [007] d.s. 19654.923576: block_rq_complete: 8,0 WS () 0 + 0 [-5]

As 8d6996630c03 introduce 'fq->rq_status', this data only update when 'flush_rq'
reference count isn't zero. If flush request once failed and record error code
in 'fq->rq_status'. If there is no chance to update 'fq->rq_status',then do fsync
will always failed.
To address this issue reset 'fq->rq_status' after return error code to upper layer.

Fixes: 8d6996630c03("block: fix null pointer dereference in blk_mq_rq_timed_out()")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20211129012659.1553733-1-yebin10@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 block/blk-flush.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 5aa6fada2259..f66ff1685531 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -222,8 +222,10 @@ static void flush_end_io(struct request *flush_rq, blk_status_t error)
 		return;
 	}
 
-	if (fq->rq_status != BLK_STS_OK)
+	if (fq->rq_status != BLK_STS_OK) {
 		error = fq->rq_status;
+		fq->rq_status = BLK_STS_OK;
+	}
 
 	hctx = flush_rq->mq_hctx;
 	if (!q->elevator) {
-- 
2.30.2


--XWUWXPEp/xKnkj0X--
