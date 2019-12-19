Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A20A212709D
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 23:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfLSWYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 17:24:25 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54444 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726880AbfLSWYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 17:24:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576794264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YlAOJ564DCiTwUBpLD6aJrL63dSFsWe/ODHnLeml7F8=;
        b=jQdx6nfEyA5jKJqll5qV9DJs1ov5BT0w7JiucbVjbA4UhyVzcx4tkxfJfCYYbGhBkxPwXg
        Ph0ccJYwh7kOKun6/qtY4fyFKmNRbD+GZjSNGp8d2c2eNPRsaF1Gn8uhWwYmbbJFt6X0w8
        gMeZuhsAiDlov2ADpTP1zqEdMzqXra0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-GOMj_zldNcS0KDcWyEijsw-1; Thu, 19 Dec 2019 17:24:22 -0500
X-MC-Unique: GOMj_zldNcS0KDcWyEijsw-1
Received: by mail-qt1-f197.google.com with SMTP id t4so4686405qtd.3
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 14:24:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YlAOJ564DCiTwUBpLD6aJrL63dSFsWe/ODHnLeml7F8=;
        b=pAOK7kKcnybT6SJ4C+glDJeEzXPgjOHNucXnkowSFtu3Vgk4k/xGPhKS2WzqXV6Nbg
         IBZ36lvg1DpiP/TkCnHFhbDpr8N45cnN24V3k/g+504toUMXhNDuYK5donglnSSJp6HG
         o75hWTFtlEEHbWdqGbBr296T1W4GxK85rVN7eQxwRZ5x06ovbcqZrQ2C5pLugmRUDYwa
         xhoo0p9L1wQo/qnaAy4B16uwuJ/w2TppUFnXhB2ELkCzk3r33SVejjN3jx2RuDoQiqh6
         RbnNRUkz7ScCQnl72xSiIQLUwLerLeMmnUFJ4PlA/6j8wRC5qB1BtfX5aRc+du2varRF
         owYw==
X-Gm-Message-State: APjAAAUwwNCg39GoxjIBdLNN7WiFcUVYuri427zoowsPCnLubbJZCSea
        VE/HBQemS7By77IaV2RBzygvIq74+6aQzoujUKJmwupACi5CFHKTX8A3CLr7craiBa2udWofc1N
        vOylPEGKr04Hlg05V
X-Received: by 2002:ac8:4151:: with SMTP id e17mr9406763qtm.234.1576794262086;
        Thu, 19 Dec 2019 14:24:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqx0bAoxo2brlO+i/yKqn1CLHFIyH0XHC6NNRdPncrFRgct9msCtWAeqEfIE6xkpc4P8Ml+aDg==
X-Received: by 2002:ac8:4151:: with SMTP id e17mr9406746qtm.234.1576794261822;
        Thu, 19 Dec 2019 14:24:21 -0800 (PST)
Received: from [192.168.1.157] (pool-96-235-39-235.pitbpa.fios.verizon.net. [96.235.39.235])
        by smtp.gmail.com with ESMTPSA id h34sm2368203qtc.62.2019.12.19.14.24.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2019 14:24:21 -0800 (PST)
Subject: Re: broken sound since 5.4.3
To:     Stefani Seibold <stefani@seibold.net>, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
References: <02def6201f9533106e0f195afed1422981215eb0.camel@seibold.net>
From:   Laura Abbott <labbott@redhat.com>
Message-ID: <240a7610-577a-8253-e880-b55182460c17@redhat.com>
Date:   Thu, 19 Dec 2019 17:24:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <02def6201f9533106e0f195afed1422981215eb0.camel@seibold.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/19/19 3:59 PM, Stefani Seibold wrote:
> Hi,
> 
> the current Linux Kernel is going kills my speakers of my monitor.
> 
> Audio level is always 100 at percent.
> 
> I broke down the issue to the following patch:
> 
> diff --git a/sound/hda/hdac_stream.c b/sound/hda/hdac_stream.c
> index d8fe7ff0cd58..f9707fb05efe 100644
> --- a/sound/hda/hdac_stream.c
> +++ b/sound/hda/hdac_stream.c
> @@ -96,12 +96,14 @@ void snd_hdac_stream_start(struct hdac_stream *azx_dev, bool fresh_start)
>   			      1 << azx_dev->index,
>   			      1 << azx_dev->index);
>   	/* set stripe control */
> -	if (azx_dev->substream)
> -		stripe_ctl = snd_hdac_get_stream_stripe_ctl(bus, azx_dev->substream);
> -	else
> -		stripe_ctl = 0;
> -	snd_hdac_stream_updateb(azx_dev, SD_CTL_3B, SD_CTL_STRIPE_MASK,
> -				stripe_ctl);
> +	if (azx_dev->stripe) {
> +		if (azx_dev->substream)
> +			stripe_ctl = snd_hdac_get_stream_stripe_ctl(bus, azx_dev->substream);
> +		else
> +			stripe_ctl = 0;
> +		snd_hdac_stream_updateb(azx_dev, SD_CTL_3B, SD_CTL_STRIPE_MASK,
> +					stripe_ctl);
> +	}
>   	/* set DMA start and interrupt mask */
>   	snd_hdac_stream_updateb(azx_dev, SD_CTL,
>   				0, SD_CTL_DMA_START | SD_INT_MASK);
> @@ -118,7 +120,10 @@ void snd_hdac_stream_clear(struct hdac_stream *azx_dev)
>   	snd_hdac_stream_updateb(azx_dev, SD_CTL,
>   				SD_CTL_DMA_START | SD_INT_MASK, 0);
>   	snd_hdac_stream_writeb(azx_dev, SD_STS, SD_INT_MASK); /* to be sure */
> -	snd_hdac_stream_updateb(azx_dev, SD_CTL_3B, SD_CTL_STRIPE_MASK, 0);
> +	if (azx_dev->stripe) {
> +		snd_hdac_stream_updateb(azx_dev, SD_CTL_3B, SD_CTL_STRIPE_MASK, 0);
> +		azx_dev->stripe = 0;
> +	}
>   	azx_dev->running = false;
>   }
>   EXPORT_SYMBOL_GPL(snd_hdac_stream_clear);
> 
> 
> 

I think this is fixed by 6fd739c04ffd ("ALSA: hda: Fix regression by strip mask fix")
This is already tagged for stable but it would be nice to pick it up sooner.

Thanks,
Laura

