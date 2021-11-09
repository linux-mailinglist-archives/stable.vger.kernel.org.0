Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6034A44AC29
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 12:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237907AbhKILCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 06:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236380AbhKILCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 06:02:51 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5488FC061766
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 03:00:05 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id u74so11813773oie.8
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 03:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i7T46wITiJUeW6jS2r6kmyBLCK14Tjsl4Ebda5Sp+pg=;
        b=dwcf3fxtxfw1j05Fr3S5R//jo39L7ugj3h/E3WuzxzekfYfDCtjcFftXxxyHmEo0Io
         12L1mnlBWucUUBD0cJez+52ExKyDppjxsCYQwIFZfucfpgdgyqiARCnuKOqgz7s79njy
         sCsC5FTD9UuAcp5Gf83pQes/e50i0k/4AYu7jI4GLRAvZkTy85N8s8XwVykXs9mLZ6im
         MMXwVaUWBWc5SgWYfcZbcN9t1tnplKTp6eUTtPf2dyZ8RQpgQg7iIAhIrfxs3qrgcZOT
         LI0Zhu/ag/GyzligrWGqiDJ6/t2KNF2o+TPy+vZjTF9akpDy5yLradRXUVN7u/AUD46r
         HZcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i7T46wITiJUeW6jS2r6kmyBLCK14Tjsl4Ebda5Sp+pg=;
        b=5t0hekQ9uFrompGSkweOD2kng7H0rzL9mYuRPw2x9t1/WBWABLejzBbm8Umc/J6Myu
         EEM0AM9jteUwV8RZMDWYQetYNXoIEH+ql7xUDPDKEm8FN+8G3O3ei4+8Ku00V7TAfhY0
         k1jIl63Bf3bkWYhmP+Bbw0k320VoN2Dn4hOJlUkbxxYti0X9bsvdbvXPiFLPEo8Crvoe
         wOntQx4zbw5K12YZdbWnEJcxrZIsXvygb2Ojo4wyl3ZdpOz1JLqDiGl/sd2hqz4IOtn6
         WQ7ZQnw4rA5BaXis2spqkkkRSRpG/2RQMcaq5YlysqOad2TMVB+dJC0jrqLVuBv2gIz5
         4gBA==
X-Gm-Message-State: AOAM5309Po3m0FuhQoA7TQRkt/U90+DLDpDpXdsM1OHjOProI+XG+W7s
        9D3a4cfypJF3aFEPAFHPnMQT8/DhtD+qiW97v66zCA==
X-Google-Smtp-Source: ABdhPJzHymYat3pW3yrmGZC+s27kLCoQfR/5ilImtjijEY251eme6e6QPa1jFhTFBFQvfPwC1D85epuYliezWKYGaZA=
X-Received: by 2002:a54:4791:: with SMTP id o17mr5051916oic.114.1636455604731;
 Tue, 09 Nov 2021 03:00:04 -0800 (PST)
MIME-Version: 1.0
References: <20211031064046.13533-1-sergio.paracuellos@gmail.com>
In-Reply-To: <20211031064046.13533-1-sergio.paracuellos@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 9 Nov 2021 11:59:53 +0100
Message-ID: <CACRpkdb7eVgSvU=1GoYEHFpo7jSO-OAY3i9=Ld2gn-oC=q3Tow@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: ralink: include 'ralink_regs.h' in 'pinctrl-mt7620.c'
To:     Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 31, 2021 at 7:40 AM Sergio Paracuellos
<sergio.paracuellos@gmail.com> wrote:

> mt7620.h, included by pinctrl-mt7620.c, mentions MT762X_SOC_MT7628AN
> declared in ralink_regs.h.
>
> Fixes: 745ec436de72 ("pinctrl: ralink: move MT7620 SoC pinmux config into a new 'pinctrl-mt7620.c' file")
> Cc: stable@vger.kernel.org
> Cc: linus.walleij@linaro.org
>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
> ---
> Changes in v2:
>  - Original patch from Luiz.
>  - I have added Fixes tag and CC Linus Walleij and stable and sent v2.

Fixed up headers and applied for fixes.

Yours,
Linus Walleij
