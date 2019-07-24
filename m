Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E19772B58
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 11:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbfGXJ16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 05:27:58 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33363 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfGXJ16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 05:27:58 -0400
Received: by mail-lf1-f66.google.com with SMTP id x3so31553700lfc.0;
        Wed, 24 Jul 2019 02:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/lxoFTV2NP07iGG4lrW/6fB0F5OOcDNXPeCFzJNVz7Q=;
        b=L8Kx6mdNwCiNdks/Ub1/XRaxPlBWUyUA6Z7rOLPfTJv3ob+28AWMKZOeaulfXRDStb
         580dKVEKg5WA3d9k9xXFv8ksCo5tm5FPTFpkinNvmJA0h7++UKQt8gvTdQ5Wn95V6tDC
         PTt0au5EZ3nPeVlKH49pqPWLytt9k5oW4RWTBE/FdITkrhEsenT6ApGSeO8efK8RU0uf
         tBbI9QEL7Ie8n3bkSGLVIfVOknRxHYkaOQ0KSPjT2hEgQn2tgXfKEMeCx90myDYuGTLg
         l6UP5Qv+b3VvSwj5lB1Uq9XhDBQN6xLkLKlg0eEWr0Wx7kol8EOTOCYwnEXMp6qOO5Dy
         13ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/lxoFTV2NP07iGG4lrW/6fB0F5OOcDNXPeCFzJNVz7Q=;
        b=r+qKAEKTePxh4nDY/v05i1Rg7tdXW7ylFSwusiV+KtBz7Hu66qb30EdBfRqRWPm7RP
         w2bs2PSmDEV/ZEX9fm8tpX0279wQ7+6rjacQ2HdcZVw8TZMqjrLWtHIY2sFVkOVA6fvy
         dRwe80o8OGUureCq4vS/U3lzXrq3aBcB5Sug/CLRuvJCZhUxqCZiz8uvyY61+iMhHrY/
         u1bN80Vbysy+BGI63BU9PibELtI3I5q4UhtLQz06wfTDP5SiR7fpwdRT5X4KUIkjl4ly
         p6bwG4kmloKHOOiVX77pdqZfURBQ/zXC0wTK4ZmaeshXiH4TiS4Xfm46PughzXjdV+/W
         kJjQ==
X-Gm-Message-State: APjAAAVjrr0QbHtGrKeK510qoaSWmSj5/vCTkav0EB87SOuYbOxVD5lv
        1cC5zz4K5uy1hdCKQKIRXGJ0oFO1
X-Google-Smtp-Source: APXvYqxkdfUPCviiU+7pkuJRFja9wGYPlnRqvkcXlLqCZbpgvZrsXKxAar2CS3a4ltu5Twt5BsrlMA==
X-Received: by 2002:ac2:5dfb:: with SMTP id z27mr37827658lfq.128.1563960475646;
        Wed, 24 Jul 2019 02:27:55 -0700 (PDT)
Received: from [192.168.2.145] (ppp91-78-220-99.pppoe.mtu-net.ru. [91.78.220.99])
        by smtp.googlemail.com with ESMTPSA id z22sm8561005ljz.20.2019.07.24.02.27.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 02:27:54 -0700 (PDT)
Subject: Re: [PATCH v3] drm/tegra: sor: Enable HDA interrupts at plug-in
To:     Viswanath L <viswanathl@nvidia.com>, thierry.reding@gmail.com,
        jonathanh@nvidia.com
Cc:     airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1563885610-27198-1-git-send-email-viswanathl@nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <0ba35efb-44ec-d56c-b559-59f1daa3e6e4@gmail.com>
Date:   Wed, 24 Jul 2019 12:27:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1563885610-27198-1-git-send-email-viswanathl@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

23.07.2019 15:40, Viswanath L пишет:
> HDMI plugout calls runtime suspend, which clears interrupt registers
> and causes audio functionality to break on subsequent plug-in; setting
> interrupt registers in sor_audio_prepare() solves the issue.
> 
> Signed-off-by: Viswanath L <viswanathl@nvidia.com>

Yours signed-off-by always should be the last line of the commit's
message because the text below it belongs to a person who applies this
patch, Thierry in this case. This is not a big deal at all and Thierry
could make a fixup while applying the patch if will deem that as necessary.

Secondly, there is no need to add "stable@vger.kernel.org" to the
email's recipients because the patch will flow into stable kernel
versions from the mainline once it will get applied. That happens based
on the stable tag presence, hence it's enough to add the 'Cc' tag to the
commit's message in order to get patch backported.

Lastly, next time please add everyone to the email's recipients whom
you're expecting to get a reply. Otherwise there is a chance that patch
will be left unnoticed.

Everything else looks good to me, thanks!

Reviewed-by: Dmitry Osipenko <digetx@gmail.com>

> Fixes: 8e2988a76c26 ("drm/tegra: sor: Support for audio over HDMI")
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/gpu/drm/tegra/sor.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
> index 5be5a08..0470cfe 100644
> --- a/drivers/gpu/drm/tegra/sor.c
> +++ b/drivers/gpu/drm/tegra/sor.c
> @@ -2164,6 +2164,15 @@ static void tegra_sor_audio_prepare(struct tegra_sor *sor)
>  
>  	value = SOR_AUDIO_HDA_PRESENSE_ELDV | SOR_AUDIO_HDA_PRESENSE_PD;
>  	tegra_sor_writel(sor, value, SOR_AUDIO_HDA_PRESENSE);
> +
> +	/*
> +	 * Enable and unmask the HDA codec SCRATCH0 register interrupt. This
> +	 * is used for interoperability between the HDA codec driver and the
> +	 * HDMI/DP driver.
> +	 */
> +	value = SOR_INT_CODEC_SCRATCH1 | SOR_INT_CODEC_SCRATCH0;
> +	tegra_sor_writel(sor, value, SOR_INT_ENABLE);
> +	tegra_sor_writel(sor, value, SOR_INT_MASK);
>  }
>  
>  static void tegra_sor_audio_unprepare(struct tegra_sor *sor)
> @@ -2913,15 +2922,6 @@ static int tegra_sor_init(struct host1x_client *client)
>  	if (err < 0)
>  		return err;
>  
> -	/*
> -	 * Enable and unmask the HDA codec SCRATCH0 register interrupt. This
> -	 * is used for interoperability between the HDA codec driver and the
> -	 * HDMI/DP driver.
> -	 */
> -	value = SOR_INT_CODEC_SCRATCH1 | SOR_INT_CODEC_SCRATCH0;
> -	tegra_sor_writel(sor, value, SOR_INT_ENABLE);
> -	tegra_sor_writel(sor, value, SOR_INT_MASK);
> -
>  	return 0;
>  }
>  
> 

