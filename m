Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E48E323E39
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbhBXN2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236566AbhBXNV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 08:21:27 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AB0C061793;
        Wed, 24 Feb 2021 05:20:47 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id mm21so2733212ejb.12;
        Wed, 24 Feb 2021 05:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DrE6hUOCy8cpTW/dJYXPieQ0j8wSEBwcz7BOrsmrQsA=;
        b=XSkiWhOXyN/mC/k9hQnBim6HrS5Ei05QsdwR5kF7Ib6yWM/4igcrzGjmrmshJA+XFi
         ot/jAskrtZWRSB5NkeAz76CseQyckBAXDBO8uaNrZ+1IlB9W0J41awaQ2cRUqEk8gLWM
         MTSTBKz1Wb8Ax2/BZMI/kNQeKR9VT+EVKptlfEocs0fALQtafBc6vxkTLlvLPsHxpwsx
         P7nQceCNvhOCC4TC3nGR/6rQD93AKbpkjJ54v0hAW0TrmXMhWEyykYwlD5MTFyT3tv9q
         MBl+6vTb+I+PFpiC9BSaIybNSIks7Y1+NOGlZBsYcw+Tcdnr7pY/rdeUFD8BD99K9V3m
         WDMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DrE6hUOCy8cpTW/dJYXPieQ0j8wSEBwcz7BOrsmrQsA=;
        b=qIMQHNGU69LqMydUo1iFdEVxicJWfDDkUTie+0V7q4o+6nd49AHQtJ1MWnKQ8at3dw
         +mL1i3HzXbvCwuSEMDAM1kIht2NEXUPTuHXfvgYFAwvuhcOM0QbbXRGLiv561Jl8Tm4p
         f8tnUrNPddv8t5xhlCYegKzbzsOlTqBw2y7HOYQbE8uO20kUNMYCssKZnhDBhqcZiYmE
         fosHNuQY9ZlnghCCC4NdObLdcTN1SFEyv7aur0i0qWYrThwzaymYsgraY8IxK2oXUwtT
         IkT056rCUyVnhCro1qRFQlRsbaiITk5FbvTe/PBILLipCOQ8bngWrE1wSuN8kr/dESYg
         Kq4w==
X-Gm-Message-State: AOAM532lufL7XLnMHu5wjbFUxrfmxqsqeXhgOxhJiTBnPJyQZJja9CH9
        EEb5vSlYsitNvevy3jAqtdeTs3SbWvECoQ==
X-Google-Smtp-Source: ABdhPJxinPGRn8stnhzy9lBYWu1HjOY75ilh9v1OIkio9JZdgsKb8WEHiZP+HV/J9mWBWjbeM7xc5A==
X-Received: by 2002:a17:907:1b21:: with SMTP id mp33mr26424602ejc.358.1614172845687;
        Wed, 24 Feb 2021 05:20:45 -0800 (PST)
Received: from anparri (host-82-59-6-76.retail.telecomitalia.it. [82.59.6.76])
        by smtp.gmail.com with ESMTPSA id h4sm1631213edv.80.2021.02.24.05.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 05:20:45 -0800 (PST)
Date:   Wed, 24 Feb 2021 14:20:42 +0100
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Juan Vazquez <juvazq@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 30/40] Drivers: hv: vmbus: Resolve race
 condition in vmbus_onoffer_rescind()
Message-ID: <20210224132042.GE1920@anparri>
References: <20210224125340.483162-1-sashal@kernel.org>
 <20210224125340.483162-30-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224125340.483162-30-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 07:53:30AM -0500, Sasha Levin wrote:
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
> index 452307c79e4b9..dd4e890cf1b1d 100644
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@ -1048,6 +1048,18 @@ static void vmbus_onoffer_rescind(struct vmbus_channel_message_header *hdr)
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
> index 67d9b5a374600..51e2134b32a21 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -734,6 +734,7 @@ struct vmbus_channel {
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
