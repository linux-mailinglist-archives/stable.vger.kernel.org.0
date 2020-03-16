Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 824FE186667
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 09:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbgCPI2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 04:28:16 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35796 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730056AbgCPI2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 04:28:16 -0400
Received: by mail-wr1-f66.google.com with SMTP id d5so19663728wrc.2
        for <stable@vger.kernel.org>; Mon, 16 Mar 2020 01:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=szWYYRkGahxA61hsmRUJ5tS74K70qXB8+PDKduH3nHs=;
        b=l3Gqhn+/M4Ha0UXVm0T3q6iV8ObxlaoHrtfqnRe+mfq3J/sCzFKJf4x7NlK7oimIwz
         tN1cuQljn0V24A6ikzf7Lh2Z5FZgBuhhcvzzlycmoWTw5AO/wLuLWUbxFwyAxd0Jt38q
         /YbIiOe4knXylQmu+M/SKDnkj5Ce2vCTOSweGQH50Ef2xnZ4js/HFbH2hFYpHx3TALhu
         4wjaB4vv3tSbPvQLG21Ggst/b5DfZRjtQt537OaHLyEY5TqcODhqXaffxWBzdSqdvD78
         jTvX9ZUunrrWo00MZaFdHDpcGEp9sBOUca60V1fbLklrtGD+8Iu+s+9w+fpmj5Vravvv
         5iNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=szWYYRkGahxA61hsmRUJ5tS74K70qXB8+PDKduH3nHs=;
        b=FCF7gFD2Y2OTrzqBF3B0AmKOpYNHXG+ZZ6tM7qj/6j2iFyd9wQpxNTtIf9ziMthUX9
         eYL+7YzkzJ6bZQAFA8zfW/YRgJPuShsGFiFZaQIBFSIYxe8i2qH4EIeijaJ1UzyKxKus
         dbxjjrB1cyq1SzaSs+8NzA0weDGagi9KvdXZeIgiJxtM9n86MSkG8SweR7iESZE68up+
         7rYz8KyPIyQC3h7aZSBRTgtAAyc7Kvm5wW1OHMlE/njEx/W1qChzXi5hpf7eh8US7V35
         wxDzQx/CQIiFZDJeD1eo0esI/AyLKWsTjE5U3Z8pu2SneOV4UvjY2lRfZzd8f4GRQs75
         gqig==
X-Gm-Message-State: ANhLgQ1Hkkj4bAFPoaSctPn6xa1I61SCi21mYyalqyPJ6RiO6ImKf8Lh
        9N27gTmj7iDGeGuOKpMHkpmhhg==
X-Google-Smtp-Source: ADFU+vtF0RfkG0k25HaWGkNvoj16Mvu5LgZ52qoUMhowQkFr4iYwgmRJjGLbQodQSmkECLChCJor9w==
X-Received: by 2002:a5d:530e:: with SMTP id e14mr34558588wrv.245.1584347293228;
        Mon, 16 Mar 2020 01:28:13 -0700 (PDT)
Received: from localhost (cag06-3-82-243-161-21.fbx.proxad.net. [82.243.161.21])
        by smtp.gmail.com with ESMTPSA id k133sm30082169wma.11.2020.03.16.01.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 01:28:12 -0700 (PDT)
References: <20200316023411.1263-1-sashal@kernel.org> <20200316023411.1263-8-sashal@kernel.org>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>
Subject: Re: [PATCH AUTOSEL 5.4 08/35] ASoC: meson: g12a: add tohdmitx reset
In-reply-to: <20200316023411.1263-8-sashal@kernel.org>
Date:   Mon, 16 Mar 2020 09:28:11 +0100
Message-ID: <1ja74gg0v8.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Mon 16 Mar 2020 at 03:33, Sasha Levin <sashal@kernel.org> wrote:

> From: Jerome Brunet <jbrunet@baylibre.com>
>
> [ Upstream commit 22946f37557e27697aabc8e4f62642bfe4a17fd8 ]
>
> Reset the g12a hdmi codec glue on probe. This ensure a sane startup state.
>
> Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
> Link: https://lore.kernel.org/r/20200221121146.1498427-1-jbrunet@baylibre.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Hi Sasha,

The tohdmitx reset property is not in the amlogic g12a DT in v5.4.
Backporting this patch on v5.4 would break the hdmi sound, and probably
the related sound card since the reset is not optional.

Could you please drop this from v5.4 stable ?
It is ok to keep it for v5.5.

Thanks
Jerome

> ---
>  sound/soc/meson/g12a-tohdmitx.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/sound/soc/meson/g12a-tohdmitx.c b/sound/soc/meson/g12a-tohdmitx.c
> index 9cfbd343a00c8..8a0db28a6a406 100644
> --- a/sound/soc/meson/g12a-tohdmitx.c
> +++ b/sound/soc/meson/g12a-tohdmitx.c
> @@ -8,6 +8,7 @@
>  #include <linux/module.h>
>  #include <sound/pcm_params.h>
>  #include <linux/regmap.h>
> +#include <linux/reset.h>
>  #include <sound/soc.h>
>  #include <sound/soc-dai.h>
>  
> @@ -378,6 +379,11 @@ static int g12a_tohdmitx_probe(struct platform_device *pdev)
>  	struct device *dev = &pdev->dev;
>  	void __iomem *regs;
>  	struct regmap *map;
> +	int ret;
> +
> +	ret = device_reset(dev);
> +	if (ret)
> +		return ret;
>  
>  	regs = devm_platform_ioremap_resource(pdev, 0);
>  	if (IS_ERR(regs))

