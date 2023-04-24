Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80576EC734
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 09:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbjDXHds convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 24 Apr 2023 03:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbjDXHdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 03:33:47 -0400
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DCAE46;
        Mon, 24 Apr 2023 00:33:45 -0700 (PDT)
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-b980e16b27bso2748583276.2;
        Mon, 24 Apr 2023 00:33:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682321625; x=1684913625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DaY5onaWw+pL1z9HGbzp+KYK0d+t+vOPMGHk+vaMImM=;
        b=NAhFApzQmwW836yoAmw5Q2RH5mpUt209f9fhM8b5MY3+mhj8XNqbiH6P3rCKjaOKjt
         cilr8hX8lPSZ6wtipQMk/NAs7BL78T0jMQ1/vOD8O6JJStZHR9dNCEJhCoxejkdAeBAe
         mETTEONVS64cMDXoFiT4oppwyEGTGHpEOelGAY4PK7Vh980DEnL5e9hGTdlgCdqHdgam
         crj4RWF7cfiDKT9av6bweGmnnYQdc2UZg62E91rzIpZVfdTZeBNJQ1f/QiYTdO6h44oZ
         iLn4y9hg8NxbWtjslRfygY0PmficM09ogWbNRt+BFRkyNVO+P3h2yQDehip1A64+yJSy
         226Q==
X-Gm-Message-State: AAQBX9cVT3QaPFllw3sVfEqXDOubasAv9GBH82aF2ZC7lmHbayKRcsni
        VW2uEqBr1M8n40el36/9rVxrQIAQdTfJZQ==
X-Google-Smtp-Source: AKy350ZD8C++bze1uT/TjyLaZsi+tSacC66gNzblXt+2k/3SvZVV3idUrsUxNwS25QKRuP98Z+N/Fg==
X-Received: by 2002:a25:ae51:0:b0:b8e:ef6c:fe5 with SMTP id g17-20020a25ae51000000b00b8eef6c0fe5mr8696188ybe.20.1682321624601;
        Mon, 24 Apr 2023 00:33:44 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id u44-20020a25ab2f000000b00b999ed81794sm482160ybi.0.2023.04.24.00.33.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 00:33:44 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-b99489836aaso1622625276.0;
        Mon, 24 Apr 2023 00:33:44 -0700 (PDT)
X-Received: by 2002:a25:2786:0:b0:b96:5262:ea40 with SMTP id
 n128-20020a252786000000b00b965262ea40mr7094245ybn.24.1682321624116; Mon, 24
 Apr 2023 00:33:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230412095509.2196162-1-cyril@debamax.com> <20230412095509.2196162-3-cyril@debamax.com>
In-Reply-To: <20230412095509.2196162-3-cyril@debamax.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 24 Apr 2023 09:33:32 +0200
X-Gmail-Original-Message-ID: <CAMuHMdW4rZn4p=gQZRWQQSEbQPmzZUd5eN+kP_Yr7bLgTHyvig@mail.gmail.com>
Message-ID: <CAMuHMdW4rZn4p=gQZRWQQSEbQPmzZUd5eN+kP_Yr7bLgTHyvig@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/ofdrm: Update expected device name
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
> Given the code similarity it is likely to affect ofdrm in the same way.
>
> It might be better to iterate on all possible nodes, but updating the
> hardcoded device from "of-display" to "of-display.0" is likely to help
> as a first step.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=217328
> Link: https://bugs.debian.org/1033058
> Fixes: 241d2fb56a18 ("of: Make OF framebuffer device names unique")
> Cc: stable@vger.kernel.org # v6.2+
> Signed-off-by: Cyril Brulebois <cyril@debamax.com>

Thanks for your patch, which is now commit 3a9d8ea2539ebebd
("drm/ofdrm: Update expected device name") in fbdev/for-next.

> --- a/drivers/gpu/drm/tiny/ofdrm.c
> +++ b/drivers/gpu/drm/tiny/ofdrm.c
> @@ -1390,7 +1390,7 @@ MODULE_DEVICE_TABLE(of, ofdrm_of_match_display);
>
>  static struct platform_driver ofdrm_platform_driver = {
>         .driver = {
> -               .name = "of-display",
> +               .name = "of-display.0",
>                 .of_match_table = ofdrm_of_match_display,
>         },
>         .probe = ofdrm_probe,

Same comment as for "[PATCH 1/2] fbdev/offb: Update expected device
name".

https://lore.kernel.org/r/CAMuHMdVGEeAsmb4tAuuqqGJ-4+BBETwEwYJA+M9NyJv0BJ_hNg@mail.gmail.com

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
