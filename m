Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B2F50E316
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 16:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiDYObN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 10:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiDYObM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 10:31:12 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85C55FDF
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 07:28:08 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id z19so11400713iof.12
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 07:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=C3MfQbMUzxgF3EhOsLU2Onypxi82Y3Pl9ZqMKnpep/4=;
        b=1Rk+xhhrPKjXIzsLkqa79eNLoErpSBc6kUI1/VfUsNk5mp/yHhK+bPuQQJ+nDbSPxm
         yizm2XHiGw6NmAePTyaZnqHUjjdD1axpkBJN+Rl7c6NPwITwyRbSbrethSX3npZUktRf
         WAkLMsCYrdwiyWoPazF9T3UZuTUk/CNaK01ywkG+b1Va9/hfWyz/LV72g5zpPVMl0jEf
         UPgVZtYijFS1Kcsb6GuRbypuPoZrJOfehMt2lzrACbyMOgnp2hGIdmbTtqxNExFbLYZn
         g5IG/BMpiyDpeju8wKsay3BOIvN1MUYbCbfXYUudnfPLhqkVxhPXvPmkhsDO80ewwFGK
         3Sxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=C3MfQbMUzxgF3EhOsLU2Onypxi82Y3Pl9ZqMKnpep/4=;
        b=bZ/nnm+LXxp4wWzWut13B10uv5DMblDC5u9dr8dvENg6agsRqN6rTjCC0bhT65dTs9
         T4ae7kVfLonIDVxN2RlJj6CpZ+VsX6yUWQKx0pXUWlpiBMszGf5LyE2CwopBCYCbba0/
         hyojAmCsa99d8RXiwXrjgWehoslU4gi9Zxd0Z8XJcEGDo2jAsuSctxuvmZeuWQ0IRFlc
         BMgW0ysc2The/XnmY3PnaBcDOooZso5cSVqnR9SGKzREw5wZtnNUHqoyPmPCL61r45hw
         jfacGbTexvTWIwxWtltkQBVIqSfzOjXMAJVH9TLP+qG4TW0/gbj/8kHXgChSM2P15EHg
         Fypw==
X-Gm-Message-State: AOAM533xz5qShUqTIyahm4Kef55sxO1rkWPVsi3oEiStmdyR4BFjrVYC
        7ssbqz3wz0yZzrrSaGxkklt1+Q==
X-Google-Smtp-Source: ABdhPJwjAJ5V4PfV/5RtLpIxWJ1y6FHA4wxlH6Gz61zh59fxTE0rFINhveia0dw2UXRJt8ZSSLlWLg==
X-Received: by 2002:a05:6638:3727:b0:32a:e9db:22f1 with SMTP id k39-20020a056638372700b0032ae9db22f1mr2740706jav.267.1650896888006;
        Mon, 25 Apr 2022 07:28:08 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id 5-20020a6b1405000000b0065064262ef4sm7377985iou.30.2022.04.25.07.28.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 07:28:07 -0700 (PDT)
Message-ID: <5be49cde-7c90-3be4-7c3c-f9bf8694f9ab@kernel.dk>
Date:   Mon, 25 Apr 2022 08:28:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: FAILED: patch "[PATCH] io_uring: fix leaks on IOPOLL and
 CQE_SKIP" failed to apply to 5.17-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, asml.silence@gmail.com
Cc:     stable@vger.kernel.org
References: <1650891057139245@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1650891057139245@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/25/22 6:50 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.17-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's one for 5.17.


From c0713540f6d55c53dca65baaead55a5a8b20552d Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Sun, 17 Apr 2022 10:10:34 +0100
Subject: [PATCH] io_uring: fix leaks on IOPOLL and CQE_SKIP

io_uring: fix leaks on IOPOLL and CQE_SKIP

commit c0713540f6d55c53dca65baaead55a5a8b20552d upstream.

If all completed requests in io_do_iopoll() were marked with
REQ_F_CQE_SKIP, we'll not only skip CQE posting but also
io_free_batch_list() leaking memory and resources.

Move @nr_events increment before REQ_F_CQE_SKIP check. We'll potentially
return the value greater than the real one, but iopolling will deal with
it and the userspace will re-iopoll if needed. In anyway, I don't think
there are many use cases for REQ_F_CQE_SKIP + IOPOLL.

Fixes: 83a13a4181b0e ("io_uring: tweak iopoll CQE_SKIP event counting")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/5072fc8693fbfd595f89e5d4305bfcfd5d2f0a64.1650186611.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 619c67fd456d..26756101437d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2612,11 +2612,10 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
 		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
+		nr_events++;
 		if (unlikely(req->flags & REQ_F_CQE_SKIP))
 			continue;
-
 		__io_fill_cqe(ctx, req->user_data, req->result, io_put_kbuf(req));
-		nr_events++;
 	}
 
 	if (unlikely(!nr_events))

-- 
Jens Axboe

