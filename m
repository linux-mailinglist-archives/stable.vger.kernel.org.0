Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89A64B829D
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 09:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbiBPIJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 03:09:04 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiBPIJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 03:09:04 -0500
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E047241D81;
        Wed, 16 Feb 2022 00:08:52 -0800 (PST)
Received: by mail-ua1-f50.google.com with SMTP id 60so738005uae.1;
        Wed, 16 Feb 2022 00:08:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WYSo5EgLaZzQKeOlQb07NB5X6ckWjcKbBmLtEm4WWR4=;
        b=dj7H0tsUpGZilzlDD/sqsDcsCdMT3wtYLwzBWEsSDkzf8g0gab1+T147hxK1kDdt/G
         mk5ZMRiuSBcr3/m2zmVM+UMcrBfmhrg/SEAJ8KDF9HHqTcHPmdc1GnICjwrPbshohOV8
         wJK6ARaWMNpx/6m8kyAIe3Hu9gA9/cokLh/+djvUx5OMkOQ+O9PgnEVhYCPXtIsG8jQ6
         Z+/UZ8KMPnaDdWBgts5rxJn1Lc2L8tCQj/5HQe5O38hpfqLzO+rvPlg1Wvyphx6QKQfL
         Twe+FX2aeRWFI0gdWdB+mhYeo6BEfHlVqkSL3cAs6Xr/ujVJRcfLTACMUAUrgvLcDfh1
         P0SQ==
X-Gm-Message-State: AOAM532CK+8mcygkqykm0ErGhmjyJPk9FNXBgvvssNQ9f0OI4Ff3G1aO
        jf4b5qPyjtGaWJosTGBpqpnsUQTDcgv2CQ==
X-Google-Smtp-Source: ABdhPJwmdYpXaYbSh5qh2RLIgVntYbsKk7sBNm9blL1M6fUbqYyLom3KBqLMElkOLLCsOl0m9DLn7w==
X-Received: by 2002:ab0:4982:0:b0:33c:8dbc:ffc8 with SMTP id e2-20020ab04982000000b0033c8dbcffc8mr602420uad.48.1644998931594;
        Wed, 16 Feb 2022 00:08:51 -0800 (PST)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com. [209.85.217.51])
        by smtp.gmail.com with ESMTPSA id 128sm5981452vsz.4.2022.02.16.00.08.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 00:08:51 -0800 (PST)
Received: by mail-vs1-f51.google.com with SMTP id e6so1545281vsa.8;
        Wed, 16 Feb 2022 00:08:51 -0800 (PST)
X-Received: by 2002:a67:e113:0:b0:30e:303d:d1d6 with SMTP id
 d19-20020a67e113000000b0030e303dd1d6mr514682vsl.38.1644998931129; Wed, 16 Feb
 2022 00:08:51 -0800 (PST)
MIME-Version: 1.0
References: <20220216072625.16947-1-schmitzmic@gmail.com>
In-Reply-To: <20220216072625.16947-1-schmitzmic@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 16 Feb 2022 09:08:40 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWMqpo9G+h7zteqUct2P0O4SaYDO3wtGxG=UnnYG7SJQQ@mail.gmail.com>
Message-ID: <CAMuHMdWMqpo9G+h7zteqUct2P0O4SaYDO3wtGxG=UnnYG7SJQQ@mail.gmail.com>
Subject: Re: [PATCH v1] video/fbdev: Atari 2 bpp (STe) palette bugfix
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     Helge Deller <deller@gmx.de>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        stable <stable@vger.kernel.org>
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

On Wed, Feb 16, 2022 at 8:26 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> The code to set the shifter STe palette registers has a long
> standing operator precedence bug, manifesting as colors set
> on a 2 bits per pixel frame buffer coming up with a distinctive
> blue tint.
>
> Add parentheses around the calculation of the per-color palette
> data before shifting those into their respective bit field position.
>
> This bug goes back a long way (2.4 days at the very least) so there
> won't be a Fixes: tag.
>
> Tested on ARAnyM as well on Falcon030 hardware.
>
> Cc: stable@vger.kernel.org
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Link: https://lore.kernel.org/all/CAMuHMdU3ievhXxKR_xi_v3aumnYW7UNUO6qMdhgfyWTyVSsCkQ@mail.gmail.com
> Tested-by: Michael Schmitz <schmitzmic@gmail.com>
> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>

Thanks, fixes the issue for me.
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
