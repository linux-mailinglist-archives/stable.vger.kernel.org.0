Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959FC52D649
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 16:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiESOmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 10:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiESOmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 10:42:04 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723CBD0295
        for <stable@vger.kernel.org>; Thu, 19 May 2022 07:42:02 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id n6-20020a05600c3b8600b0039492b44ce7so2821474wms.5
        for <stable@vger.kernel.org>; Thu, 19 May 2022 07:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=r+uBqYoKaFLMlJFkouWl/5PTcXxMB19lbTmZGFqcCCM=;
        b=D6mMBSrvo09EHXEQq3XQU8GzgnRvUOea4O2bzStvjq8BKr3bG5lAS6V1OkxFEm/S+u
         GBWRQX83f9tsbhBeVP6dVdLLsCta2LtTDvwNUAuHyrkDhk/yl6N452uLH6B8/KHEQGOv
         aE7Z5WmIUorJ4pFZRN5UVBybbTVlrKZ+a8eeEBvPmgP6VXnSW2Nva80h2YwGlIkDM1p4
         rXOA9cJMbhODALhEBvahW1jgJZqqEs0uvWpmSt1JjNjmrzqIS8JE+NFvYjpVCpU1trWZ
         P/YV8MfiU2CXniG2BC+9Tzazpd9zkJsuAj6/49r4K5paQ5bQLY3ksTYRZlU6LVzGhOM9
         v4wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=r+uBqYoKaFLMlJFkouWl/5PTcXxMB19lbTmZGFqcCCM=;
        b=6j1q/nLbRRHMQ4R5QZ4zWUrNSzDX9PKzY1EfaDixrZizVDLVs7IY9ePrAfDfYtD7Lv
         8CtWjXVuB+osRvco3wjffPYgHyYHBvnPdc89YSpS5lp9wrohSnAOzctu5F5g0Cg9+Wc3
         Vg38kj5EFGm9aMaZruupUK3doSeKALO4ljK2eOgbWzun+ZfUq/C0iuakEsh6IfOtvOqv
         FUVGQe2j+qhdzb7o73F3+H8To5+Gk+pW2Ux1etncHQ/6TNKVjcco2OJUclsG3szKxFk8
         nPsDBIIlZCfZ73e59yrh0W0Krff4wnBEvVFmd4dRh7ZwH2NEcen7Rzy/jtTOVoLjyRJD
         8c/w==
X-Gm-Message-State: AOAM531n//HYOVhcWz90Q6buD5ZuqK/upVfj1pysdmFC91ejG+nmW0Mk
        HnddlCyHgLsab++qg02TyNjEw1kVu7yJDg==
X-Google-Smtp-Source: ABdhPJxFATn885MCD3k8abKmuIx4lR7ujS9VmVqucacttmXp7wIaHdjK5ET3s1084IMpmwub1IjR0A==
X-Received: by 2002:a7b:cb47:0:b0:393:dd9f:e64a with SMTP id v7-20020a7bcb47000000b00393dd9fe64amr4609360wmj.170.1652971320873;
        Thu, 19 May 2022 07:42:00 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id l9-20020a5d6d89000000b0020c5253d8f3sm6170338wrs.63.2022.05.19.07.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 07:42:00 -0700 (PDT)
Date:   Thu, 19 May 2022 15:41:58 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Patch for 5.10-stable
Message-ID: <YoZXNjl8LmcWCQa9@google.com>
References: <543c3909-a7b6-23ac-2c2e-ce10dd2433e8@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <543c3909-a7b6-23ac-2c2e-ce10dd2433e8@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 19 May 2022, Jens Axboe wrote:

> Hi,
> 
> Can we get this queued up for 5.10-stable? Thanks!
> 

> From b1da21187de121e2ed2dc2e0c70d5aabce469691 Mon Sep 17 00:00:00 2001
> From: Jens Axboe <axboe@kernel.dk>
> Date: Thu, 19 May 2022 06:05:27 -0600
> Subject: [PATCH] io_uring: always grab file table for deferred statx
> 
> Lee reports that there's a use-after-free of the process file table.
> There's an assumption that we don't need the file table for some
> variants of statx invocation, but that turns out to be false and we
> end up with not grabbing a reference for the request even if the
> deferred execution uses it.
> 
> Get rid of the REQ_F_NO_FILE_TABLE optimization for statx, and always
> grab that reference.
> 
> This issues doesn't exist upstream since the native workers got
> introduced with 5.12.
> 
> Link: https://lore.kernel.org/io-uring/YoOJ%2FT4QRKC+fAZE@google.com/
> Reported-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Tested-by: Lee Jones <lee.jones@linaro.org>

> ---
>  fs/io_uring.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 4330603eae35..3ecf71151fb1 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4252,12 +4252,8 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
>  	struct io_statx *ctx = &req->statx;
>  	int ret;
>  
> -	if (force_nonblock) {
> -		/* only need file table for an actual valid fd */
> -		if (ctx->dfd == -1 || ctx->dfd == AT_FDCWD)
> -			req->flags |= REQ_F_NO_FILE_TABLE;
> +	if (force_nonblock)
>  		return -EAGAIN;
> -	}
>  
>  	ret = do_statx(ctx->dfd, ctx->filename, ctx->flags, ctx->mask,
>  		       ctx->buffer);


-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
