Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74BF5A9B9E
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 17:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbiIAP1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 11:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234576AbiIAP06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 11:26:58 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F8C86B4A
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 08:26:51 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id b16so23068297edd.4
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 08:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=CupWNrebEeHWD5CryUcMGye9WGGQg9AJZQR9fbHNhhQ=;
        b=qZtszoq14zz7yib302Mksn1qbyc0cYdzLKdDfoArXawxGb7OGwNsJyRn9Xg3V/4Lj4
         5XbTLM5LxiS7ip+30c0OHXLRADkHVdfhTVWNunvo9NwRn3chrHKQlUnpNxulfgtzpVbE
         W18vv8tgYrzSGqlPtz+PLmkKh0SFPEeraPPOo9zhbpJd/h2h07HzGTsItG/4PfhXsFyq
         zC96WCCzgi8Eyp7MFPVrBoRqZmrjWqUGGaquZevNc0Ub9OoN+8+IWAgVg6ZJSlFtMYic
         wtmYsl70dN5dGuO0uYerwQb8WfjoIkrZFVn7ePNqtyQBe48Zjd+953N3n3KHs2u50LUa
         EZIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=CupWNrebEeHWD5CryUcMGye9WGGQg9AJZQR9fbHNhhQ=;
        b=Am6YYV9+3X4JCI/XbRqevDpbmYXMG1wdg3T0dssVYeOkOE5rIJK0TCH+cH4YpIRyBg
         OSCHZCNJGdsrkc8qf2CMtP9jFiHjGhWTAHLEWlv0E36eAPAR2yJ1NWlqCkcyS3BOeQif
         +98jWL2tZDHgSkWAnrd07PYynVLCeEGzVEEBvjhNwTOSoEi9cJwYOSqZ3cciB6vjTLF7
         UO5IIV9T2UAKA0s/qBEKGrfXdEIkDjUAJilsZV4QUGpxWAzpnoATuRuzEe74rWKGqVRp
         N1DlX/wkWn1kz6D1nwE/u98a/2lSJKTPu+DqN8opqOr6Ei9zPaBcXNwBXRP1nTOgYr4q
         DLJQ==
X-Gm-Message-State: ACgBeo3ZPPHLgMzRMNoegYi2QNnoL5N0Pr8fQ3FLW3V+L3SM8Ou3+D2e
        8uSP56DVp9LouQUkCBQ2RyH0J3hcW1Q=
X-Google-Smtp-Source: AA6agR4YOHKz2fSD3ParoBaAwof/nBKiJzn7GlI0HRjrcf68/cR8sXMFqjZV9su51ou2wyWyAeGrBQ==
X-Received: by 2002:a05:6402:68a:b0:447:981a:4f09 with SMTP id f10-20020a056402068a00b00447981a4f09mr29387624edy.181.1662046009097;
        Thu, 01 Sep 2022 08:26:49 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::202f? ([2620:10d:c092:600::2:554f])
        by smtp.gmail.com with ESMTPSA id q18-20020a17090676d200b00730860b6c43sm8606013ejn.173.2022.09.01.08.26.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 08:26:48 -0700 (PDT)
Message-ID: <756d8d67-7a63-62a1-51e4-1e966f40610d@gmail.com>
Date:   Thu, 1 Sep 2022 16:25:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH stable-5.10 1/1] io_uring: disable polling pollfree files
Content-Language: en-US
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <4f4668f469baa8f1387e746fd2533ec662500f3a.1662042761.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4f4668f469baa8f1387e746fd2533ec662500f3a.1662042761.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/1/22 16:16, Pavel Begunkov wrote:
> Older kernels lack io_uring POLLFREE handling. As only affected files
> are signalfd and android binder the safest option would be to disable
> polling those files via io_uring and hope there are no users.

It differs from how it's fixed upstream, but IMHO porting is too
difficult to be reliable enough, this one is quick and simple.
The upstream fix:

commit 791f3465c4afde02d7f16cf7424ca87070b69396
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Fri Jan 14 11:59:10 2022 +0000

     io_uring: fix UAF due to missing POLLFREE handling


I also forgot Fixes tag if required:

Fixes: 221c5eb233823 ("io_uring: add support for IORING_OP_POLL")


> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   drivers/android/binder.c | 1 +
>   fs/io_uring.c            | 5 +++++
>   fs/signalfd.c            | 1 +
>   include/linux/fs.h       | 1 +
>   4 files changed, 8 insertions(+)
> 
> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> index 366b12405708..a5d5247c4f3e 100644
> --- a/drivers/android/binder.c
> +++ b/drivers/android/binder.c
> @@ -6069,6 +6069,7 @@ const struct file_operations binder_fops = {
>   	.open = binder_open,
>   	.flush = binder_flush,
>   	.release = binder_release,
> +	.may_pollfree = true,
>   };
>   
>   static int __init init_binder_device(const char *name)
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index a952288b2ab8..9654b60a06a5 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5198,6 +5198,11 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
>   	struct io_ring_ctx *ctx = req->ctx;
>   	bool cancel = false;
>   
> +	if (req->file->f_op->may_pollfree) {
> +		spin_lock_irq(&ctx->completion_lock);
> +		return -EOPNOTSUPP;
> +	}
> +
>   	INIT_HLIST_NODE(&req->hash_node);
>   	io_init_poll_iocb(poll, mask, wake_func);
>   	poll->file = req->file;
> diff --git a/fs/signalfd.c b/fs/signalfd.c
> index b94fb5f81797..41dc597b78cc 100644
> --- a/fs/signalfd.c
> +++ b/fs/signalfd.c
> @@ -248,6 +248,7 @@ static const struct file_operations signalfd_fops = {
>   	.poll		= signalfd_poll,
>   	.read		= signalfd_read,
>   	.llseek		= noop_llseek,
> +	.may_pollfree	= true,
>   };
>   
>   static int do_signalfd4(int ufd, sigset_t *mask, int flags)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 42d246a94228..c8f887641878 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1859,6 +1859,7 @@ struct file_operations {
>   				   struct file *file_out, loff_t pos_out,
>   				   loff_t len, unsigned int remap_flags);
>   	int (*fadvise)(struct file *, loff_t, loff_t, int);
> +	bool may_pollfree;
>   } __randomize_layout;
>   
>   struct inode_operations {

-- 
Pavel Begunkov
