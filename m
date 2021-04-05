Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E78354746
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 22:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbhDEUB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 16:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233412AbhDEUBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 16:01:25 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAA2C06178C
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 13:01:18 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 82so3090234yby.7
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 13:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pIFMsp1xtnQm4fljPPOMNWkY8KrPxBHkP5mmYwWGYOg=;
        b=mAbehSQyEDZIVj209oPai5x0WzcM3FBJI+fXL28yXmj51FYUXWIfYHCDhQNPeK/eBV
         33oYC4LCRTZylzp6DhIYO40quEbp+B97DRda5Td/KiYCfZA6W0h5BaEZaMwm6i4ONeCw
         CKWzvz6dXtwRR9nbUg0F1RSYy8T/beXJb99VRaJrqqL1O5ovi8KGf8nPUDevefJuyFMP
         W3ff45YKrKvpkmEtrFA0Dw4hyi8R+pCP+REF4Rz48wVZs1aSMdK2zW2PlFl9aRS1CMZS
         MJ90HeVpgtNCVIZKOL9bZx+ynL+MEwYCsN47pHtICQbRdIYUp2rELGgS4+gaz4DwZySZ
         SFVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pIFMsp1xtnQm4fljPPOMNWkY8KrPxBHkP5mmYwWGYOg=;
        b=K7lXkr904F1KdJV26tIY/v3Ji47hWEuZil2WBIfURqE/NY8VBVzLEqkhy7xsL7pp0Y
         etQub6x7KgF3xCvaY0sskzl7SCwhbaJhQwtYWY9Jdqx0wj7jhEexSDi1g/kLkdo7Mc2v
         05UQtAywdWIKUCFpEyel+0bzrPNJy5+zmC0LhWBp65E85JPTtf6mx1XYlTZppFvbB2+E
         NWLeu+yddGJsO2gaffRijAUoEV2zDVtJw7kwoTCPAIzfvBq1dJvf3RDQ9Izk0ed1AXyg
         3stwPEGIzZ7FzfkwAVRC+XXzM4nbjFlndvF4YlZnKLz+bGGIYHsP2dv38E2cj4DsUDW/
         HVuA==
X-Gm-Message-State: AOAM533uNrFp+OqEP787tg6yRTmpJ/F78rAbzHIaPW9qg8el8bjaFOx+
        0qPFzU7VPssSZfvJUZHakuA6xzk8zdprikPDxOwJpQ==
X-Google-Smtp-Source: ABdhPJzEz4Bacy1Qyh6foMuxZWgQ4WwrTvcePdu/RGd29dTLOPzSZhs71CTh5wKDRXclrsHmhYPATlDOgex29PQYZD4=
X-Received: by 2002:a25:c985:: with SMTP id z127mr40988055ybf.20.1617652876933;
 Mon, 05 Apr 2021 13:01:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210405031436.2465475-1-ilya.lipnitskiy@gmail.com>
In-Reply-To: <20210405031436.2465475-1-ilya.lipnitskiy@gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Mon, 5 Apr 2021 13:00:40 -0700
Message-ID: <CAGETcx9ifDoWeBN1KR4zKfs-q73iGo9C-joz4UqayeE3euDQWg@mail.gmail.com>
Subject: Re: [PATCH] of: property: do not create device links from *nr-gpios
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

On Sun, Apr 4, 2021 at 8:14 PM Ilya Lipnitskiy
<ilya.lipnitskiy@gmail.com> wrote:
>
> [<vendor>,]nr-gpios property is used by some GPIO drivers[0] to indicate
> the number of GPIOs present on a system, not define a GPIO. nr-gpios is
> not configured by #gpio-cells and can't be parsed along with other
> "*-gpios" properties.
>
> scripts/dtc/checks.c also has a special case for nr-gpio{s}. However,
> nr-gpio is not really special, so we only need to fix nr-gpios suffix
> here.

The only example of this that I see is "snps,nr-gpios". I personally
would like to deprecate such overlapping/ambiguous definitions.

Maybe fix up the DT? This warning is a nice reminder that the DT needs
to be updated (if it can be). Outside of that, it's not causing any
issues that I know of.

If they are, then we can pick up a patch similar to this. I'd also
limit this fix to "snps,nr-gpios" so that future attempts to use
-gpios for anything other than listing GPIOs triggers a warning.

Rob, thoughts?

Thanks,
Saravana

>
> [0]: nr-gpios is referenced in Documentation/devicetree/bindings/gpio:
>  - gpio-adnp.txt
>  - gpio-xgene-sb.txt
>  - gpio-xlp.txt
>  - snps,dw-apb-gpio.yaml
>
> Fixes errors such as:
>   OF: /palmbus@300000/gpio@600: could not find phandle
>
> Call Trace:
>   of_phandle_iterator_next+0x8c/0x16c
>   __of_parse_phandle_with_args+0x38/0xb8
>   of_parse_phandle_with_args+0x28/0x3c
>   parse_suffix_prop_cells+0x80/0xac
>   parse_gpios+0x20/0x2c
>   of_link_to_suppliers+0x18c/0x288
>   of_link_to_suppliers+0x1fc/0x288
>   device_add+0x4e0/0x734
>   of_platform_device_create_pdata+0xb8/0xfc
>   of_platform_bus_create+0x170/0x214
>   of_platform_populate+0x88/0xf4
>   __dt_register_buses+0xbc/0xf0
>   plat_of_setup+0x1c/0x34
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
> index 2bb3158c9e43..24672c295603 100644
> --- a/drivers/of/property.c
> +++ b/drivers/of/property.c
> @@ -1271,7 +1271,16 @@ DEFINE_SIMPLE_PROP(pinctrl8, "pinctrl-8", NULL)
>  DEFINE_SIMPLE_PROP(remote_endpoint, "remote-endpoint", NULL)
>  DEFINE_SUFFIX_PROP(regulators, "-supply", NULL)
>  DEFINE_SUFFIX_PROP(gpio, "-gpio", "#gpio-cells")
> -DEFINE_SUFFIX_PROP(gpios, "-gpios", "#gpio-cells")
> +
> +static struct device_node *parse_gpios(struct device_node *np,
> +                                      const char *prop_name, int index)
> +{
> +       if (!strcmp_suffix(prop_name, "nr-gpios"))
> +               return NULL;
> +
> +       return parse_suffix_prop_cells(np, prop_name, index, "-gpios",
> +                                      "#gpio-cells");
> +}
>
>  static struct device_node *parse_iommu_maps(struct device_node *np,
>                                             const char *prop_name, int index)
> --
> 2.31.1
>
