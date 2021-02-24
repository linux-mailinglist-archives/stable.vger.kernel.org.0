Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE01323E0B
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236144AbhBXNYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbhBXNSk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 08:18:40 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8964C06178B;
        Wed, 24 Feb 2021 05:16:09 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id j9so2470614edp.1;
        Wed, 24 Feb 2021 05:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ybq7RMjn9hsdU3yUVvJeduTNiXaxFp9VeeC1XcARtv8=;
        b=kK6Ceh9V43eJSJbZIYNJyliPkn06F05XmgT9o2Ly6bCeiWTU2vbOcaocEF6JDRj2va
         msZZIjz6DAvd5tEbkFUaty74DUhxQzrSmErn0lIc+ioLi8pz4GXnSotGpDrNg5dUbgTH
         5d27wwMxsPFxFYDgIUXOmyHxZz5oDEBIkv5A9s6uZqoVNRG4AR8LDZHMSM+QegJqQNv3
         feQGIHdK124gMqU5LdXW+p+YPqLhT8vMfOhnYNeYuaq5Kh9vIoDc2ZM3otMC5gRbMt6D
         xvQUzG+uKuPRJfzKKUm2AOCZw1Bjf0zZBjZ1pBETs7gDve2a/dqJ7kCdqZsWMCYgXupX
         adhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ybq7RMjn9hsdU3yUVvJeduTNiXaxFp9VeeC1XcARtv8=;
        b=kzfMQeoW6PM6DUTduhL9q5hGIRgDUYI6rpUeb+Q8yjpMrHINC7Ruo2vTWEDTJbv+DI
         jR+enK12MuA3JJJyqKWE2yNF7jfgz11JTDjpfhujfMyzF2VEX1ipCp0+VPfpSNF0sF8X
         2ztnH/3iX+UMMMUMZpTk3uSpXA2oP8ZOEhGeurjGiEOzPrJCr2WTIKXNPqUN8djzIT3I
         HaJkw/U4LYGl8u1KAP3pIJAFatLEe9tAX3xqX4NfQ3dx0G2OqeTrV0s0hERHBtphTWrP
         eJkhyBikX8RZ14V/fT1u2S0RY6OfKjqYMIZeYgx6kNY2q43cSP+DHqL0exJ0Z1zuS9Lt
         8RxQ==
X-Gm-Message-State: AOAM532WyDpaeB732976gn+anl+Q3fhtgnZmXpd1P/+5L1QBVvDJa+2R
        rk3BPXs+KNwt+B1/zL7KyLM=
X-Google-Smtp-Source: ABdhPJxrxEufi/KWDHe/kkJ3+G5EZOGQ68uGrFF4/06H9HCi+wPfjfqx7Pd/Ui6Tj+aGWcck6fk6Ow==
X-Received: by 2002:a50:bf47:: with SMTP id g7mr32569077edk.323.1614172568363;
        Wed, 24 Feb 2021 05:16:08 -0800 (PST)
Received: from anparri (host-82-59-6-76.retail.telecomitalia.it. [82.59.6.76])
        by smtp.gmail.com with ESMTPSA id a26sm1638418edm.15.2021.02.24.05.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 05:16:08 -0800 (PST)
Date:   Wed, 24 Feb 2021 14:16:00 +0100
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Juan Vazquez <juvazq@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 50/67] Drivers: hv: vmbus: Initialize memory
 to be sent to the host
Message-ID: <20210224131457.GA1920@anparri>
References: <20210224125026.481804-1-sashal@kernel.org>
 <20210224125026.481804-50-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224125026.481804-50-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 07:50:08AM -0500, Sasha Levin wrote:
> From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
> 
> [ Upstream commit e99c4afbee07e9323e9191a20b24d74dbf815bdf ]
> 
> __vmbus_open() and vmbus_teardown_gpadl() do not inizialite the memory
> for the vmbus_channel_open_channel and the vmbus_channel_gpadl_teardown
> objects they allocate respectively.  These objects contain padding bytes
> and fields that are left uninitialized and that are later sent to the
> host, potentially leaking guest data.  Zero initialize such fields to
> avoid leaking sensitive information to the host.
> 
> Reported-by: Juan Vazquez <juvazq@microsoft.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> Link: https://lore.kernel.org/r/20201209070827.29335-2-parri.andrea@gmail.com
> Signed-off-by: Wei Liu <wei.liu@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Sasha - This patch is one of a group of patches where a Linux guest running on
Hyper-V will start assuming that hypervisor behavior might be malicious, and
guards against such behavior.  Because this is a new assumption, these patches
are more properly treated as new functionality rather than as bug fixes.  So I
would propose that we *not* bring such patches back to stable branches.

Thanks,
  Andrea


> ---
>  drivers/hv/channel.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> index 6fb0c76bfbf81..0bd202de79600 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -618,7 +618,7 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
>  		goto error_clean_ring;
>  
>  	/* Create and init the channel open message */
> -	open_info = kmalloc(sizeof(*open_info) +
> +	open_info = kzalloc(sizeof(*open_info) +
>  			   sizeof(struct vmbus_channel_open_channel),
>  			   GFP_KERNEL);
>  	if (!open_info) {
> @@ -745,7 +745,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
>  	unsigned long flags;
>  	int ret;
>  
> -	info = kmalloc(sizeof(*info) +
> +	info = kzalloc(sizeof(*info) +
>  		       sizeof(struct vmbus_channel_gpadl_teardown), GFP_KERNEL);
>  	if (!info)
>  		return -ENOMEM;
> -- 
> 2.27.0
> 
