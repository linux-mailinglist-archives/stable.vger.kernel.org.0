Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C304323E3B
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbhBXN27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236432AbhBXNUm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 08:20:42 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8D6C061574;
        Wed, 24 Feb 2021 05:19:23 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id d8so3015009ejc.4;
        Wed, 24 Feb 2021 05:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=T8vKWox1z8PK0XVn5zyALzpg2C9Em5deMKrbzZZg5Zo=;
        b=h/RjM/KU1WkN71EG4hLlf52GxLbjESNN3ptRra+T7dPTWbBvsdlHK/6EFhngrUyk+m
         n5P2m1gplxOSyVyNDeUfEwpRodw0obsEzp7qWEZ6/YEDL5hiaEBC8g7bIHXrwzLSE6ZZ
         4lBW41HQdAgX8g/eFtWxNeQ5vgPMBEjFbkHhNon9n2h+Hjsz7GM318WhcmTojoXZgGMm
         UnIMKePHJY22D8HRJHLzCGuJ6jWKNJAnwxXn2ziqgOi9g+d5Sl0igpMGAPstEQhIRRcZ
         l4s+ijArxYELefo2w4OJJo5Df2+qTzVp7PV+nezSS7e0Z4L+z8DwrFHbRMd2WJ70gRxo
         ZAXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T8vKWox1z8PK0XVn5zyALzpg2C9Em5deMKrbzZZg5Zo=;
        b=W1i376kba8U9mXb64e4vQmDXCxp42ytCRy07Lqc5TwU733AqPOJgjv/LeKOaiuyHr2
         yXhOdYQ1a0lJVCT/dfxJawRrmKgwTW1IezygDu94AAuP1340/apiVjIB+qoBMCnv/ZAz
         dzaWT6b9kTPL+pfCGsExzha+xTO8SSl2Nwu+dTN01iUxkfrU5GExmYbnrvricm4Kd7QN
         +MuFW1gWZzWfv8wu/DSadfPKtx5uKYKvapnZ6XJy5+sfsT2E9yt94wkVwa7kA3DhnmUY
         5oJdmPtVJo423YxXVcbXW+M/7Y7TGmlNsCISAPs3QLDvLxLIk5rCi04uIoNidCOKzqMo
         x+7w==
X-Gm-Message-State: AOAM531pd0sZC7Ete5S5dGadC8+T/xBjWFH2wlGByPhX6FWKOZwWV4yn
        9dR/wJ+P47HrqPZckJrZGFKABtPLWV/JEg==
X-Google-Smtp-Source: ABdhPJwb/7Bjqh2bUtHoyLPMeAoywBuzyuCcya/O5QXPLGdpoZPePTEl/8bFKAVSSw/u+Mp8x89gvw==
X-Received: by 2002:a17:906:81cf:: with SMTP id e15mr21907567ejx.131.1614172762401;
        Wed, 24 Feb 2021 05:19:22 -0800 (PST)
Received: from anparri (host-82-59-6-76.retail.telecomitalia.it. [82.59.6.76])
        by smtp.gmail.com with ESMTPSA id x25sm1326489ejc.27.2021.02.24.05.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 05:19:22 -0800 (PST)
Date:   Wed, 24 Feb 2021 14:19:19 +0100
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Juan Vazquez <juvazq@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 40/56] Drivers: hv: vmbus: Initialize memory
 to be sent to the host
Message-ID: <20210224131919.GC1920@anparri>
References: <20210224125212.482485-1-sashal@kernel.org>
 <20210224125212.482485-40-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224125212.482485-40-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 07:51:56AM -0500, Sasha Levin wrote:
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

Same here.

  Andrea


> ---
>  drivers/hv/channel.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> index fbdda9938039a..f9f04b5cd303f 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -548,7 +548,7 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
>  		goto error_clean_ring;
>  
>  	/* Create and init the channel open message */
> -	open_info = kmalloc(sizeof(*open_info) +
> +	open_info = kzalloc(sizeof(*open_info) +
>  			   sizeof(struct vmbus_channel_open_channel),
>  			   GFP_KERNEL);
>  	if (!open_info) {
> @@ -674,7 +674,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
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
