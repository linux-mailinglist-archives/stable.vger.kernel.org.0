Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF812DF201
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 23:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbgLSWjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 17:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgLSWjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 17:39:17 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CC5C0613CF;
        Sat, 19 Dec 2020 14:38:37 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id q22so8447895eja.2;
        Sat, 19 Dec 2020 14:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3kfO/cCpJ6dTCtRANlf2ZvCPmTfbvJvYLOve9Fhsc3I=;
        b=GAZNK58c3CTwPMGH0U4zl4ENKCkxRtPBrZAfMRjcgWV8qZzaeO24jM02RqHRDiR8S4
         s8+nUWsbsvGY6u3o3MVuSdKo0RTQkr9rPGcElU8Hmb4yYcIbEJWYAiCPCpkpE8YM/fRL
         RJnsbqCQUj0q7UwuWtNXnwD2P0Eh9y0e3dwpN5jiMdNzs5uNK8amj9otw5DonKuJQxJ8
         isWEmUEEAFR7aBUFiT8xiuN4hTst7h37gW9acjF7KgpkGCI06TauHVTMomGaECfKOE8M
         4OR1c8FVJnpVsTQGNhYbvGMjqVa0MHYRbtVhqGhBY1pGBEQibhKZumQTcs5fFROCD4R2
         grNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3kfO/cCpJ6dTCtRANlf2ZvCPmTfbvJvYLOve9Fhsc3I=;
        b=tKjqmPpGnBBpmuEdIpN8S7GCN2XyELHxV4vEa/NZI7jbEFECOCbHLXLT+PgMu3R1/K
         bYloxO4gPA0dqiYjidY2MRziUwOdcp5OVYUjVPY8rpvwAfIyVdp6dygM76P8g3sAX3M3
         Bl+YYm4ppyGMv/kK1lEF+MEgMcRq8sv12cfX/kjIhe8Eret2mwwdjPBzjQbRDxAYE5l5
         wfrBJM2hJqtexZBlkpUBzlI7/qIuMPCyJILWG71hi7tQsfyTXuK4TdgQTSV7175QFgJ7
         bTze891zFeEUFeAhAgC/b6hjgPLLb+uowWs9zcuF/EGGrJBNL/vIq1oo9gYF9+G4M5F2
         A5iA==
X-Gm-Message-State: AOAM5337rz7nZuQ7aoAd6SggsEHPozdA/iOJ3iIf5iE+v7KX+Ydvdx0O
        HTTHUFtSE2wZTv9kjIyQTh2Fnn91aa967hXrHxpvtpgG
X-Google-Smtp-Source: ABdhPJxxj3ZMJnTL47PCBo9SvjR6sePakDhWNQrUz+ATv0X2Ps8N+0EhFDIxGBr0RUV1bXeOP1AAr3Sdr1txAmDE8x0=
X-Received: by 2002:a17:906:4050:: with SMTP id y16mr9680503ejj.537.1608417516054;
 Sat, 19 Dec 2020 14:38:36 -0800 (PST)
MIME-Version: 1.0
References: <20201219125344.671832095@linuxfoundation.org> <20201219125345.376925474@linuxfoundation.org>
 <20201219215139.GA29536@amd>
In-Reply-To: <20201219215139.GA29536@amd>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 19 Dec 2020 23:38:25 +0100
Message-ID: <CAFBinCBRe3Oacqce1EDQpoNmEhXeUxJrA43RTA0+_fVciDJzhg@mail.gmail.com>
Subject: Re: [PATCH 5.9 14/49] net: stmmac: dwmac-meson8b: fix mask definition
 of the m250_sel mux
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jerome Brunet <jbrunet@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,

On Sat, Dec 19, 2020 at 10:51 PM Pavel Machek <pavel@ucw.cz> wrote:
[...]
> I can't say I like this one:
>
>
> >       clk_configs->m250_mux.reg = dwmac->regs + PRG_ETH0;
> > -     clk_configs->m250_mux.shift = PRG_ETH0_CLK_M250_SEL_SHIFT;
> > -     clk_configs->m250_mux.mask = PRG_ETH0_CLK_M250_SEL_MASK;
> > +     clk_configs->m250_mux.shift = __ffs(PRG_ETH0_CLK_M250_SEL_MASK);
>
> It replaces constant with computation done at runtime; compiler can't
> optimize it as __ffs is implemented with asm().
what do you suggest to use instead?
personally I don't see a problem because this is only called once at
driver probe time.


Best regards,
Martin
