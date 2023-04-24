Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 669C16EC727
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 09:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbjDXHbj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 24 Apr 2023 03:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjDXHbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 03:31:38 -0400
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC7DE53;
        Mon, 24 Apr 2023 00:31:37 -0700 (PDT)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-54fb8a8a597so47517507b3.0;
        Mon, 24 Apr 2023 00:31:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682321496; x=1684913496;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qVjrUBePw3Nq2ZtrxyHKPMRQvOHRrO/KkUf1wauFdNw=;
        b=ea2MBIlaqIwk5Lfmy+zqkz4+NFguM+X1843WzISN/DWq3Uok+unGyaHDs5so0PC1K2
         eij6nrkhckidB3wpuYNdexEZQd3GJOQrCvCAzd4nZVBgEKZRvYTuMCI9f5oyuS2z/AXF
         s2+WNi3dDWw6rLghaHXI/W1uL7v28cV6qdONYQrRnA+iO2ruytkTX93JVNAmeb+uqIIk
         nXxnFgLW751wgVRyY/tm+y6ciqgcz2BPPjp/t3dlKgBT3ZvMi1u4lvZ8wZ4KHAWpjQjX
         Rtaq8LAlwsxvPNe3gtEDU1CWDEU0QE84HjFgmz1cJ9QD7xGyiGu4hpHZ5mQ27SrHoZYT
         rJJQ==
X-Gm-Message-State: AAQBX9dyu3NZuNXrw3909YGmfRuovOO6bfjXgndS/GIezGR/X/IwOAXc
        eflLg7afVCIVd8S15ZXbvYoyL/nSqNGatg==
X-Google-Smtp-Source: AKy350ZgTk5EZ9Q6HUOqqPstIxZQjg22N4lWhyH1GKFCi8CeFD5n+BzYT2bnzDD31KRqdMj06OEOtA==
X-Received: by 2002:a81:a0cb:0:b0:54f:8cf7:c114 with SMTP id x194-20020a81a0cb000000b0054f8cf7c114mr7497255ywg.46.1682321495654;
        Mon, 24 Apr 2023 00:31:35 -0700 (PDT)
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com. [209.85.128.175])
        by smtp.gmail.com with ESMTPSA id s2-20020a817702000000b00545a08184b5sm2748529ywc.69.2023.04.24.00.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 00:31:35 -0700 (PDT)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-54f9d6eccf3so47456937b3.2;
        Mon, 24 Apr 2023 00:31:35 -0700 (PDT)
X-Received: by 2002:a81:6d93:0:b0:54f:e2ae:21e1 with SMTP id
 i141-20020a816d93000000b0054fe2ae21e1mr6851865ywc.36.1682321494895; Mon, 24
 Apr 2023 00:31:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230412095509.2196162-1-cyril@debamax.com> <20230412095509.2196162-2-cyril@debamax.com>
In-Reply-To: <20230412095509.2196162-2-cyril@debamax.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 24 Apr 2023 09:31:22 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVGEeAsmb4tAuuqqGJ-4+BBETwEwYJA+M9NyJv0BJ_hNg@mail.gmail.com>
Message-ID: <CAMuHMdVGEeAsmb4tAuuqqGJ-4+BBETwEwYJA+M9NyJv0BJ_hNg@mail.gmail.com>
Subject: Re: [PATCH 1/2] fbdev/offb: Update expected device name
To:     Cyril Brulebois <cyril@debamax.com>
Cc:     linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Rob Herring <robh@kernel.org>,
        Michal Suchanek <msuchanek@suse.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Cyril,

CC DT

On Wed, Apr 12, 2023 at 12:05 PM Cyril Brulebois <cyril@debamax.com> wrote:
> Since commit 241d2fb56a18 ("of: Make OF framebuffer device names unique"),
> as spotted by Frédéric Bonnard, the historical "of-display" device is
> gone: the updated logic creates "of-display.0" instead, then as many
> "of-display.N" as required.
>
> This means that offb no longer finds the expected device, which prevents
> the Debian Installer from setting up its interface, at least on ppc64el.
>
> It might be better to iterate on all possible nodes, but updating the
> hardcoded device from "of-display" to "of-display.0" is confirmed to fix
> the Debian Installer at the very least.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=217328
> Link: https://bugs.debian.org/1033058
> Fixes: 241d2fb56a18 ("of: Make OF framebuffer device names unique")
> Cc: stable@vger.kernel.org
> Signed-off-by: Cyril Brulebois <cyril@debamax.com>

Thanks for your patch, which is now commit 27c74ea74be805cc
("fbdev/offb: Update expected device name") in fbdev/for-next

> --- a/drivers/video/fbdev/offb.c
> +++ b/drivers/video/fbdev/offb.c
> @@ -698,7 +698,7 @@ MODULE_DEVICE_TABLE(of, offb_of_match_display);
>
>  static struct platform_driver offb_driver_display = {
>         .driver = {
> -               .name = "of-display",
> +               .name = "of-display.0",
>                 .of_match_table = offb_of_match_display,
>         },
>         .probe = offb_probe_display,

This looks like the wrong fix for me: platform drivers' names must
not contain the device index, and DT-based devices are probed using
the compatible value (which is "display") instead of the node name.

I think the problem is with the of_platform_default_populate_init()
function, which should create proper name@unit-address device nodes,
with unique unit addresses, and with the correct compatible value.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
