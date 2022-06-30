Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF52B562326
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 21:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236820AbiF3Tb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 15:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236786AbiF3Tb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 15:31:26 -0400
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FFB433B7;
        Thu, 30 Jun 2022 12:31:25 -0700 (PDT)
Received: by mail-qv1-f41.google.com with SMTP id y14so689101qvs.10;
        Thu, 30 Jun 2022 12:31:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZgxuFddNswMaFAXw3XokbvDGJHJxBrbwCZoDWZ01t3w=;
        b=7UB47xqQUvaAzQj8y2rFP9U+E7hXGC/pl60UVOoK12w8O7IAp9VPnVBsTNPAYzGfXy
         pK1Cy1QLEtk1TT51WOqZN0NmevGHFxGnF5J6SlLH2DHGVSeZIrcXa1ifiLb/ROIj5exY
         nTgjREyIiphYHDnlaUMH0BM0F6bLA6jwICzRBYY8QoKnXEtXQbcCTFiCdanwCJpcHgZd
         Ue4mJ20Pkv2OHxYwARUcCo0F0x9HDQJDwdkfjgSEBIegxkKtSPGR6gNq2BXOuKat9D3r
         wItWcoNql5SgItqVbcEO0XKz0eqUja6Ni2om3ezdwUqv4TyduAylCQS0es9yg5UPZZ6Y
         7kGg==
X-Gm-Message-State: AJIora+rNN1je4sm/C8HbJPJ4f0PqcW2ziIUP8GlizDK2XaYjktLJYLz
        lnzubtlKP+DbdbYAPP7h506Fw4YdYd0pMQ==
X-Google-Smtp-Source: AGRyM1tjbYoi+H4sY8LKK6TBoRDRGWdbQpaib6CIbSslw/AYG4s8dkrCUfNqY+N5GOQBa/nT19cWNw==
X-Received: by 2002:a05:6214:3001:b0:46e:762d:e53e with SMTP id ke1-20020a056214300100b0046e762de53emr13185836qvb.125.1656617483944;
        Thu, 30 Jun 2022 12:31:23 -0700 (PDT)
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com. [209.85.128.175])
        by smtp.gmail.com with ESMTPSA id o1-20020a05620a2a0100b006a6f68c8a87sm6849385qkp.126.2022.06.30.12.31.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 12:31:23 -0700 (PDT)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-3178acf2a92so3260657b3.6;
        Thu, 30 Jun 2022 12:31:22 -0700 (PDT)
X-Received: by 2002:a81:a092:0:b0:318:5c89:a935 with SMTP id
 x140-20020a81a092000000b003185c89a935mr12869945ywg.383.1656617482577; Thu, 30
 Jun 2022 12:31:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220628022657.597208-1-sashal@kernel.org> <20220628022657.597208-8-sashal@kernel.org>
In-Reply-To: <20220628022657.597208-8-sashal@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 30 Jun 2022 21:31:11 +0200
X-Gmail-Original-Message-ID: <CAMuHMdV4xPPGv0U4QZkyA-AT07AjYVGGJdKjpQyZCtAH4hYKWQ@mail.gmail.com>
Message-ID: <CAMuHMdV4xPPGv0U4QZkyA-AT07AjYVGGJdKjpQyZCtAH4hYKWQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.9 08/13] video: fbdev: simplefb: Check before
 clk_put() not needed
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Yihao Han <hanyihao@vivo.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Helge Deller <deller@gmx.de>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Tue, Jun 28, 2022 at 4:32 AM Sasha Levin <sashal@kernel.org> wrote:
> From: Yihao Han <hanyihao@vivo.com>
>
> [ Upstream commit 5491424d17bdeb7b7852a59367858251783f8398 ]
>
> clk_put() already checks the clk ptr using !clk and IS_ERR()

While I think that is true for all clock implementations in v5.19-rc4,
it is not true for v4.9.320.

> so there is no need to check it again before calling it.
>
> Signed-off-by: Yihao Han <hanyihao@vivo.com>
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Helge Deller <deller@gmx.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

> --- a/drivers/video/fbdev/simplefb.c
> +++ b/drivers/video/fbdev/simplefb.c
> @@ -231,8 +231,7 @@ static int simplefb_clocks_init(struct simplefb_par *par,
>                 if (IS_ERR(clock)) {
>                         if (PTR_ERR(clock) == -EPROBE_DEFER) {
>                                 while (--i >= 0) {
> -                                       if (par->clks[i])
> -                                               clk_put(par->clks[i]);
> +                                       clk_put(par->clks[i]);
>                                 }
>                                 kfree(par->clks);
>                                 return -EPROBE_DEFER;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
