Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38DE4E8755
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 13:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbiC0LMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 07:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbiC0LMG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 07:12:06 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5908637BCB
        for <stable@vger.kernel.org>; Sun, 27 Mar 2022 04:10:27 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id h16so6802844wmd.0
        for <stable@vger.kernel.org>; Sun, 27 Mar 2022 04:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=+BzHZSvsn/H69wlmb/H6rNB8e3j/o17VqP5fAwR3vQU=;
        b=n+TM4caOAp7aEq8To+f6jO0BS7LMe0+DMBVCErD3nIzBkOALI2ZJlInZiWkvYKLyqB
         H+4F7iYjKqYaLj/OPPzW9gq+l/M9Z0u6a8WTTf6LH/6M+0VXHjVNWfLpj5h9WLbTDly9
         PJkw2fhaZ+69LqpOJ+zOCsrcktLX2QSq48Td+AlXqCzNCKa9dO0WK70MfS6fKUQC9Wtk
         +fFh+kf/2aZXUIKt7Qtoq42+r5NKVrbBQryKeKWeDT12xPt7ASgtSsTKwm8D0eA3DWUo
         8Zs14hKV4x0VtL+2deVPC7sbA3/beiz2cDtnHAf4stM2aEO3tYUFOqpZX9yriEm4A7M+
         Mq6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=+BzHZSvsn/H69wlmb/H6rNB8e3j/o17VqP5fAwR3vQU=;
        b=a708hMBL1sO6oybBUqdPgrjsAHZcmLMGXGfD8r/ZT8BMvOu1PTPRxNHqIgi+f8x5Z3
         OCRxzr/m4eJz0FukOUEwPSHD7nxJey6WWAuLtlfDk1zRwxt5JFphVhgpB0Ad/WyoQxGI
         GKcEGtvhLzfsFH2NJg3tkoQlD450mpSxn46yqdD4dL5ZTotEjYvmjUjxl/EfnzyRmwVk
         h3s8FJOYFIVXugDeXK99mPkR+4aDuO8Q16bOdNXgZ4duBytzzoRlmjZHX5x6/vKrZ56X
         FJ2zpY22W9elTxz5JzrrzrMi4lSQFwPMmZKltqoYtuWz1uXamTBLrG6cZOhR61RdnwtM
         6zBQ==
X-Gm-Message-State: AOAM532HurqFoqU2852Fk5mcrchjWl/HBBBLIPW1VCkjXGnuu2ZiOyR+
        u/B84mM7iAKwLnco+q6HSkdEcQ==
X-Google-Smtp-Source: ABdhPJzw8TxaeNM+RLDCb4Y1lZLHWqMHpKjAx9JRCVm8lX0y2gwyKrD4U6GXSV5yvfD0ii3RXeXiXw==
X-Received: by 2002:a05:600c:1c8e:b0:38c:a386:26aa with SMTP id k14-20020a05600c1c8e00b0038ca38626aamr19308151wms.204.1648379425745;
        Sun, 27 Mar 2022 04:10:25 -0700 (PDT)
Received: from localhost (82-65-169-74.subs.proxad.net. [82.65.169.74])
        by smtp.gmail.com with ESMTPSA id g6-20020a5d5406000000b001f049726044sm9577806wrv.79.2022.03.27.04.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 04:10:24 -0700 (PDT)
References: <20220327081850.13456-1-xiam0nd.tong@gmail.com>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.com,
        narmstrong@baylibre.com, khilman@baylibre.com
Cc:     martin.blumenstingl@googlemail.com, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] soc: meson: fix a missing check on list iterator
Date:   Sun, 27 Mar 2022 13:03:14 +0200
In-reply-to: <20220327081850.13456-1-xiam0nd.tong@gmail.com>
Message-ID: <1jk0cf6480.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Sun 27 Mar 2022 at 16:18, Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:

> The bug is here:
> 	*dai_name = dai->driver->name;
>
> For for_each_component_dais(), just like list_for_each_entry,
> the list iterator 'runtime' will point to a bogus position
> containing HEAD if the list is empty or no element is found.
> This case must be checked before any use of the iterator,
> otherwise it will lead to a invalid memory access.
>
> To fix the bug, just move the assignment into loop and return
> 0 when element is found, otherwise return -EINVAL;

Except we already checked that the id is valid and know an element will
be be found once we enter the loop. No bug here and this patch does not
seem necessary to me.

>
> Cc: stable@vger.kernel.org
> Fixes: 6ae9ca9ce986b ("ASoC: meson: aiu: add i2s and spdif support")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>  sound/soc/meson/aiu.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/sound/soc/meson/aiu.c b/sound/soc/meson/aiu.c
> index d299a70db7e5..b52915c6f53b 100644
> --- a/sound/soc/meson/aiu.c
> +++ b/sound/soc/meson/aiu.c
> @@ -61,14 +61,14 @@ int aiu_of_xlate_dai_name(struct snd_soc_component *component,
>  		return -EINVAL;
>  
>  	for_each_component_dais(component, dai) {
> -		if (id == 0)
> -			break;
> +		if (id == 0) {
> +			*dai_name = dai->driver->name;
> +			return 0;
> +		}
>  		id--;
>  	}
>  
> -	*dai_name = dai->driver->name;
> -
> -	return 0;
> +	return -EINVAL;
>  }
>  
>  static int aiu_cpu_of_xlate_dai_name(struct snd_soc_component *component,

