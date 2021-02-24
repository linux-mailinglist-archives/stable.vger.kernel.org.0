Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E33B323E38
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbhBXN1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbhBXNWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 08:22:23 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B918BC06174A;
        Wed, 24 Feb 2021 05:21:41 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id r17so2968924ejy.13;
        Wed, 24 Feb 2021 05:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WDf8bNlXwDREMw2fYtgvyNKs51Rez3p9DgY25iabkKk=;
        b=UbthsDrfAXxLG0Ih3qnLP3LLslxy/TACKjN/AnLLlOGJ1SlJbUB1a9xL6k9bKHtbeZ
         sK19xPjppJcRJYixSaTO7tDYKpxSmIzNM1m4GSQaVFCeLj7nupAC2zQLMQs9K5l5xL5R
         ZEdxS9/4hzM1pY5vKZ5rhfFmY42RK/aMCTucRM8LSksEXXT2gGEvI9Jobl2ssXs8OnVc
         hU3LBJpTbFwpUT4fpgwDzIFsU76GOX5kFxigh0LboXTyRIdX8IYpXevZsTxUzySfkbue
         DGcwKUFo9nlYtEmPXOHHju3kV/sFI85nfbxLoR+C5dCGPCK/WoOwyfBfbyj+g0g+wb/m
         IcUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WDf8bNlXwDREMw2fYtgvyNKs51Rez3p9DgY25iabkKk=;
        b=OCfmXr3lFGRisgCZpkoLaUyzyX7x5hczau4vW8IDaVanWTMuJHakwSUMF3WPfcO1aT
         xa2qLhXKfjfEecb3fEhCfT4zrLIlh8ORBxyJylECtwIgAysoLjlDiCqCrINCeCM17cgD
         6ubcG5Tbk9097CReBVU9Fx1R6N6+Ea6EYjX5Nf2Q3sJf2AASh76kIvdFIT0Nfs42ubgp
         zmF9PDfxNRzT9rRuxHctNxr8YWpqze835DhOKuzQoge0qek+E8brDdZybLAkHgxbDFcJ
         wg0mRTC//YZ+gcIUhAkck+eLfZ0l8V8vNcWnCyrk7hvBQFbvTM8r9L4TqyUJnDv48djP
         85lw==
X-Gm-Message-State: AOAM532kPWnJohtJAV6LUKanea8dYXUdCU1mlP23CmOZyVA58dRqr6Wz
        KdLrWbtx9EyNYzOnCDodZpY=
X-Google-Smtp-Source: ABdhPJwh6Gknd4P3KUjnqmnTzkZbf1deMW7BQeP7kBImLg8i1BN1fFWBO2GjpmdqF/shVI0D2WrwhA==
X-Received: by 2002:a17:906:e0cb:: with SMTP id gl11mr19837093ejb.87.1614172900384;
        Wed, 24 Feb 2021 05:21:40 -0800 (PST)
Received: from anparri (host-82-59-6-76.retail.telecomitalia.it. [82.59.6.76])
        by smtp.gmail.com with ESMTPSA id fi5sm1290151ejc.43.2021.02.24.05.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 05:21:40 -0800 (PST)
Date:   Wed, 24 Feb 2021 14:21:33 +0100
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Juan Vazquez <juvazq@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 21/26] Drivers: hv: vmbus: Resolve race
 condition in vmbus_onoffer_rescind()
Message-ID: <20210224132133.GA2031@anparri>
References: <20210224125435.483539-1-sashal@kernel.org>
 <20210224125435.483539-21-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224125435.483539-21-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 07:54:29AM -0500, Sasha Levin wrote:
> From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
> 
> [ Upstream commit e4d221b42354b2e2ddb9187a806afb651eee2cda ]
> 
> An erroneous or malicious host could send multiple rescind messages for
> a same channel.  In vmbus_onoffer_rescind(), the guest maps the channel
> ID to obtain a pointer to the channel object and it eventually releases
> such object and associated data.  The host could time rescind messages
> and lead to an use-after-free.  Add a new flag to the channel structure
> to make sure that only one instance of vmbus_onoffer_rescind() can get
> the reference to the channel object.
> 
> Reported-by: Juan Vazquez <juvazq@microsoft.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> Link: https://lore.kernel.org/r/20201209070827.29335-6-parri.andrea@gmail.com
> Signed-off-by: Wei Liu <wei.liu@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Same here.

  Andrea


> ---
>  drivers/hv/channel_mgmt.c | 12 ++++++++++++
>  include/linux/hyperv.h    |  1 +
>  2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
> index 7920b0d7e35a7..1322e799938af 100644
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@ -954,6 +954,18 @@ static void vmbus_onoffer_rescind(struct vmbus_channel_message_header *hdr)
>  
>  	mutex_lock(&vmbus_connection.channel_mutex);
>  	channel = relid2channel(rescind->child_relid);
> +	if (channel != NULL) {
> +		/*
> +		 * Guarantee that no other instance of vmbus_onoffer_rescind()
> +		 * has got a reference to the channel object.  Synchronize on
> +		 * &vmbus_connection.channel_mutex.
> +		 */
> +		if (channel->rescind_ref) {
> +			mutex_unlock(&vmbus_connection.channel_mutex);
> +			return;
> +		}
> +		channel->rescind_ref = true;
> +	}
>  	mutex_unlock(&vmbus_connection.channel_mutex);
>  
>  	if (channel == NULL) {
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 35461d49d3aee..59525fe25abde 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -736,6 +736,7 @@ struct vmbus_channel {
>  	u8 monitor_bit;
>  
>  	bool rescind; /* got rescind msg */
> +	bool rescind_ref; /* got rescind msg, got channel reference */
>  	struct completion rescind_event;
>  
>  	u32 ringbuffer_gpadlhandle;
> -- 
> 2.27.0
> 
