Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA314CB05D
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 21:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbiCBU5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 15:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbiCBU5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 15:57:44 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADFBDBD10
        for <stable@vger.kernel.org>; Wed,  2 Mar 2022 12:57:00 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id u10so3062417wra.9
        for <stable@vger.kernel.org>; Wed, 02 Mar 2022 12:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6m8ZXVt3gsVdrzxVC8JllSQVNEx6QTb1mEh+7upFh28=;
        b=P/BJCbPhr3EFi1OjA3obUGrt/mcSR/mp1opeoARbnNuSuJ9YQwj6ZMnPetoxbd74H5
         o7o2G0SStFrgiZCyP1x6pcYnn5TiC9zQ8MpmS4cjEncaZe/JSsYrVyId32+aSN5e+/zO
         wzIJPyT1bbLYPZViuO8v0CVpgcGJ5z/wO2N0qaIE29s3HPqeU+gLvnUZ7GbAew/l2xZj
         WqSR7qfQB7pWj3E8ysCbryLeiDml+VU33LPfTcEeckyw8WDZqdVRO0kz28NWUUcWSrbt
         M7gTzGv/0V+bIK1QS0dp+cuc5P+WL+mJ6I3/POuAcC3PUYXtT78KEVSp0AwU2vo7ZeaB
         R1Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6m8ZXVt3gsVdrzxVC8JllSQVNEx6QTb1mEh+7upFh28=;
        b=bo+Vi2k89VE1IyOi854X0bnBCbYzYHrIOWKIMJOcsk9aSxMvc62+Yv+N1jXug2EeMB
         Z1sf7jtNooNj7RyeZ88PMsRo07nkddkdnhV3NA8H/bQjIl2++Ejl/EknI4NBzw6iLc6f
         F38saTMxvx2Ss364dqEsQz89vheEZ7+tCfCoPfhckl5wN7Roi9FbuevMXV4FGRY6MYNU
         kBogLdi+QaI8S2jGTvj6Cqq5XLt8+Oo7OuDdPbCvaoXQuljXkcGTHdlGUVMQuEMWDlYb
         MT0+2BDNuUtomzSmrMKJzoHqQyGnI+4vxrXk5hB1o6J+a9u8TcqOkZgI7tnwvsjKCXyf
         g7YQ==
X-Gm-Message-State: AOAM532Qy8QjxqEI4g/WC3oFWeI/bbgSp2PnC3ycaW2ne3BYtho4ebxi
        YaGP6j/chQSxL+X+etOaoJg=
X-Google-Smtp-Source: ABdhPJw7438QJ0O7TTsoSVENZs/lZ7CaqR+AzJp17juBZvusHUHzOdrAa7zz3oJo6mnW2Z10iWrS3w==
X-Received: by 2002:adf:e401:0:b0:1ed:c254:d51f with SMTP id g1-20020adfe401000000b001edc254d51fmr23996588wrm.49.1646254619052;
        Wed, 02 Mar 2022 12:56:59 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id l13-20020a05600002ad00b001ea78a5df11sm122940wry.1.2022.03.02.12.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 12:56:58 -0800 (PST)
Date:   Wed, 2 Mar 2022 20:56:57 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     yebin10@huawei.com, axboe@kernel.dk, ming.lei@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] block: Fix fsync always failed if once
 failed" failed to apply to 4.19-stable tree
Message-ID: <Yh/aGJzX72KtYa/8@debian>
References: <164302349921124@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CI+6eu9h73GoCyIW"
Content-Disposition: inline
In-Reply-To: <164302349921124@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CI+6eu9h73GoCyIW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Jan 24, 2022 at 12:24:59PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--CI+6eu9h73GoCyIW
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-block-Fix-fsync-always-failed-if-once-failed.patch"

From 05fb4b866dddcb184dc2988943c4924d77add70a Mon Sep 17 00:00:00 2001
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
index 256fa1ccc2bd..dc71da0e6b0e 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -239,8 +239,10 @@ static void flush_end_io(struct request *flush_rq, blk_status_t error)
 			return;
 		}
 
-		if (fq->rq_status != BLK_STS_OK)
+		if (fq->rq_status != BLK_STS_OK) {
 			error = fq->rq_status;
+			fq->rq_status = BLK_STS_OK;
+		}
 
 		hctx = blk_mq_map_queue(q, flush_rq->mq_ctx->cpu);
 		if (!q->elevator) {
-- 
2.30.2


--CI+6eu9h73GoCyIW--
