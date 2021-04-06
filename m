Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D34355F3C
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 01:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbhDFXJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 19:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbhDFXJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 19:09:56 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8B2C06174A
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 16:09:48 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id l187so11862143ybl.4
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 16:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y6OSfvw2JXRLchQT/g4OM5pjorvMrh2aWfsdWLGR9gE=;
        b=ajc9PJAU/6AhhM0RhU0k1Mux2Yl+3pnFstkqg8+oM2TYiRXR+skoQr1Z1VkTCft7GN
         AnYuq70p0b/LRP6MrmyKfs7O8sci7KHn8wkfT4m24ss3Xu0kIQmK2nCQxq3bhZt4+gwc
         eVBeiZ0dMUn0s3nAnQtKH9D+zc2shuf6Q+agPMmGL6OLJigGjhzHrdDlEv2M62riuqlz
         eZJMjz1ysW5Har69nUCu8X2s44NHjMjNx/py5ZtVUXxPID5rjZEyOP06GFDI3ZzrdKFs
         JPKyD98eLlSssi71FnxAx8IVVgSHNGLiMa0L4w3ybM3yqKakpNNylvKlWT3RYFeplZJy
         v/lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y6OSfvw2JXRLchQT/g4OM5pjorvMrh2aWfsdWLGR9gE=;
        b=RIH7mzIGaSVdrexkLBuaDCR/0+4dFR7q/k5odSmTmorQfMEipLIJWPu6KJkPWaowdh
         TMKaKq6DHc+L6heISLvAk2jxxMReieGPb0OxC6Tqx01ot4fGkHeGqeCZAmxdCoG723mG
         OkaKa+nV2HfswYRtA7PojhzyrURysXWrKenX2sROvUVx6j3hdkhcPOFj7TcUPWIcwBaS
         0a1Jio3B3y3HCt1fBSgyrl+QPWpIZq+H/kcEpHQcwPJXzx4qfJQlrl847ccaiPKPbfja
         yQb9jc6u528K4MiWFiJQUUmhJ55yX8B2UgsYOk0uhbvoqsbZCfoOGKOl2COra1pQ7Qvc
         Tufw==
X-Gm-Message-State: AOAM531ggrCIjgNDg6H6+N5aPviVv3K0yHk1I8jz4Q+N167OLvbOQwq/
        3GoXXxaSut0gHg60uwn87gtpWGrdKOzU5AbY+D4hYA==
X-Google-Smtp-Source: ABdhPJwCdBdvb5yTh7D1SqaHPTDXJjMGadzUqlEpmyyfYz34QIUr5kDhWWv6sCMTO/prGFa0DpCneK2qiPBI53cOpgM=
X-Received: by 2002:a25:6003:: with SMTP id u3mr651056ybb.96.1617750586821;
 Tue, 06 Apr 2021 16:09:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210405031436.2465475-1-ilya.lipnitskiy@gmail.com> <20210405222540.18145-1-ilya.lipnitskiy@gmail.com>
In-Reply-To: <20210405222540.18145-1-ilya.lipnitskiy@gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 6 Apr 2021 16:09:10 -0700
Message-ID: <CAGETcx-gF4r1TeY2AA4Vwb5e+5O+_O3E2ENo5tKhh=n_EOJnEQ@mail.gmail.com>
Subject: Re: [PATCH v2] of: property: fw_devlink: do not link ".*,nr-gpios"
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 5, 2021 at 3:26 PM Ilya Lipnitskiy
<ilya.lipnitskiy@gmail.com> wrote:
>
> [<vendor>,]nr-gpios property is used by some GPIO drivers[0] to indicate
> the number of GPIOs present on a system, not define a GPIO. nr-gpios is
> not configured by #gpio-cells and can't be parsed along with other
> "*-gpios" properties.
>
> nr-gpios without the "<vendor>," prefix is not allowed by the DT
> spec[1], so only add exception for the ",nr-gpios" suffix and let the
> error message continue being printed for non-compliant implementations.
>
> [0]: nr-gpios is referenced in Documentation/devicetree/bindings/gpio:
>  - gpio-adnp.txt
>  - gpio-xgene-sb.txt
>  - gpio-xlp.txt
>  - snps,dw-apb-gpio.yaml
>
> [1]:
> Link: https://github.com/devicetree-org/dt-schema/blob/cb53a16a1eb3e2169ce170c071e47940845ec26e/schemas/gpio/gpio-consumer.yaml#L20
>
> Fixes errors such as:
>   OF: /palmbus@300000/gpio@600: could not find phandle
>
> Fixes: 7f00be96f125 ("of: property: Add device link support for interrupt-parent, dmas and -gpio(s)")
> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> Cc: Saravana Kannan <saravanak@google.com>
> Cc: <stable@vger.kernel.org> # 5.5.x
> ---
>  drivers/of/property.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/of/property.c b/drivers/of/property.c
> index 2046ae311322..1793303e84ac 100644
> --- a/drivers/of/property.c
> +++ b/drivers/of/property.c
> @@ -1281,7 +1281,16 @@ DEFINE_SIMPLE_PROP(pinctrl7, "pinctrl-7", NULL)
>  DEFINE_SIMPLE_PROP(pinctrl8, "pinctrl-8", NULL)
>  DEFINE_SUFFIX_PROP(regulators, "-supply", NULL)
>  DEFINE_SUFFIX_PROP(gpio, "-gpio", "#gpio-cells")
> -DEFINE_SUFFIX_PROP(gpios, "-gpios", "#gpio-cells")
> +
> +static struct device_node *parse_gpios(struct device_node *np,
> +                                      const char *prop_name, int index)
> +{
> +       if (!strcmp_suffix(prop_name, ",nr-gpios"))
> +               return NULL;

Ah I somehow missed this patch. This gives a blanked exception for
vendor,nr-gpios. I'd prefer explicit exceptions for all the instances
of ",nr-gpios" we are grandfathering in. Any future additions should
be rejected. Can we do that please?

Rob, you okay with making this list more explicit?

-Saravana
