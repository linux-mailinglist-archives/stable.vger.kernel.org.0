Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B776A64CD
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 02:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjCABaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 20:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCABaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 20:30:21 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8789EC9;
        Tue, 28 Feb 2023 17:30:19 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id o12so47688556edb.9;
        Tue, 28 Feb 2023 17:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vZS4srdzYPX5rwf8hBmS3h/CSWlxeptJDidxpQ52/rY=;
        b=jAZJqxNnaCbGp3Cn7I115sC3pbOLIoFPvymD9tvjSPw0mD8MYApBCMMkCAcdj8mh4M
         CYNw1xXXsUQgDqAQwJSWMhpwGV560MZ6TvUwZPW5XxlgGBOVUQxzgAgWb/FAlfACMBTH
         MSAmXvY5yDuOu8EgKMsqpKhQTl1+tPDCB02CE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vZS4srdzYPX5rwf8hBmS3h/CSWlxeptJDidxpQ52/rY=;
        b=QfSPywj9Sd7jh4Rbx/uQ++iJdnn3aL+WzENboIAzjwlAN+Y6mBHQ0C+Hfjt7ui9Bi5
         cDFbM6IYbAo9d0MGRHgBN8YSxMa2PEt3hBz61+3wIhg2Vv/O6Z6MzNwn6KvhEtHwZfXd
         s+GrN40HrZYkX2HlvQlYTqYrLE9B4GyQ7ZcQ9klsPWyI/Rlh78SDj5AWOM4wH47AXZTq
         DKKOO/UFy82WIDatQ+IJDpFd78On5oqLD3eCmArUeyXwyBkxXOeB9CCQmRpMZqvhvNAO
         2bsrzYvjkPKbzq0XnPLR32T+xVUyZfad2PS4C7LgoBaNWXGB0h0sBTByBrH4OOzUSCeq
         uTJQ==
X-Gm-Message-State: AO0yUKU/m86dgsQjJf/EX6Jd45k57thUwMO53CcGMVtJZcYeC6AskzGi
        Bupypk2HxNJ+RCggHzAci9TA2GGthlNXtRgV2S8=
X-Google-Smtp-Source: AK7set/PW9p3+rsDwfdQvTVOa0cA7HHEYagI+NeYdL0zp0aQTvVe97kOvNfE5b67MEGgt5lDe1NN/RWcCezxLJstPSQ=
X-Received: by 2002:a17:906:d82:b0:87b:db55:4887 with SMTP id
 m2-20020a1709060d8200b0087bdb554887mr2237966eji.4.1677634218221; Tue, 28 Feb
 2023 17:30:18 -0800 (PST)
MIME-Version: 1.0
References: <20230224000400.12226-1-zev@bewilderbeest.net> <20230224000400.12226-4-zev@bewilderbeest.net>
In-Reply-To: <20230224000400.12226-4-zev@bewilderbeest.net>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 1 Mar 2023 01:30:05 +0000
Message-ID: <CACPK8XdFT=+VJJ=iDhcmWPh9m9of2b+2UYxkrAisp6tdmWOWKg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ARM: dts: aspeed: asrock: Correct firmware flash
 SPI clocks
To:     Zev Weiss <zev@bewilderbeest.net>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>
Cc:     Andrew Jeffery <andrew@aj.id.au>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 24 Feb 2023 at 00:04, Zev Weiss <zev@bewilderbeest.net> wrote:
>
> While I'm not aware of any problems that have occurred running these
> at 100 MHz, the official word from ASRock is that 50 MHz is the
> correct speed to use, so let's be safe and use that instead.

:(

Validated with which driver?

C=C3=A9dric, do you have any thoughts on this?

>
> Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
> Cc: stable@vger.kernel.org
> Fixes: 2b81613ce417 ("ARM: dts: aspeed: Add ASRock E3C246D4I BMC")
> Fixes: a9a3d60b937a ("ARM: dts: aspeed: Add ASRock ROMED8HM3 BMC")
> ---
>  arch/arm/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts | 2 +-
>  arch/arm/boot/dts/aspeed-bmc-asrock-romed8hm3.dts | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts b/arch/arm=
/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts
> index 67a75aeafc2b..c4b2efbfdf56 100644
> --- a/arch/arm/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts
> +++ b/arch/arm/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts
> @@ -63,7 +63,7 @@ flash@0 {
>                 status =3D "okay";
>                 m25p,fast-read;
>                 label =3D "bmc";
> -               spi-max-frequency =3D <100000000>; /* 100 MHz */
> +               spi-max-frequency =3D <50000000>; /* 50 MHz */
>  #include "openbmc-flash-layout.dtsi"
>         };
>  };
> diff --git a/arch/arm/boot/dts/aspeed-bmc-asrock-romed8hm3.dts b/arch/arm=
/boot/dts/aspeed-bmc-asrock-romed8hm3.dts
> index 00efe1a93a69..4554abf0c7cd 100644
> --- a/arch/arm/boot/dts/aspeed-bmc-asrock-romed8hm3.dts
> +++ b/arch/arm/boot/dts/aspeed-bmc-asrock-romed8hm3.dts
> @@ -51,7 +51,7 @@ flash@0 {
>                 status =3D "okay";
>                 m25p,fast-read;
>                 label =3D "bmc";
> -               spi-max-frequency =3D <100000000>; /* 100 MHz */
> +               spi-max-frequency =3D <50000000>; /* 50 MHz */
>  #include "openbmc-flash-layout-64.dtsi"
>         };
>  };
> --
> 2.39.1.438.gdcb075ea9396.dirty
>
