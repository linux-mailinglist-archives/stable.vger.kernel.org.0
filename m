Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF512E0003
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 19:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgLUSiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 13:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbgLUSip (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 13:38:45 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9DBC0613D6;
        Mon, 21 Dec 2020 10:38:05 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id jx16so14796023ejb.10;
        Mon, 21 Dec 2020 10:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ccy82VKjKP31HCUTBpqLGwvjdjA2gjSaaZupd9fPC3w=;
        b=ociRHIH8EepfBOfoBJSMK8J8zmjyQeT9/UiHBc9OYeLXAMrkszCCzRV9MW1DOLykRs
         lkNQTvBekjjy4IsgvG00X+hgMWQj8jfSU2lSkHj1kyQ/3oWNvU1iF0+c/1lrtWV8DCTg
         7iCs0B+g6rRP15LvL08dm35kRRjMIC54AArTwDFwpoNgobhJZ0ccltDC2QmbF1yNlCTP
         yK/fQic75MOz9K3cQorulxa/aruKBXZuIFLwniFJCEz7wsG0M4p3jXzlS+PAvKatqHqo
         614Jqk53jCVl0wla4dgN/4wftWSOWo2ymRZ2h1+2ib3L+jMOln4sQpXzTy2bixkNPsf3
         MHVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ccy82VKjKP31HCUTBpqLGwvjdjA2gjSaaZupd9fPC3w=;
        b=aqZ4T6smSoDMbHsMeMfvlTqKkxDn9qMxBeJEyBHwel5FEj9sTR3ng8+U6FMb4FoiVX
         pFCNMh3rUEz9rIWFP/urWOxkc5G792N/AkgkcrGBMs5uOVeGhhSwtWx+KmWtD3/BFaRV
         gpQuz4AxjQVQQQL/YbcYtNFMoaQ0QPgSySwPnjmkXTvi33C2M+NKZOtCcUTa3ej5Lzh/
         CczQZhK4yWBrhHMD4LAcRWSDlEpRb5EGN9jzmEdNQeJ15kTw84YKR+/zT2GdiA38nQNQ
         fFj3oFrILeAl/HKywHWdyElXO5YSk8dP+XbuJG3qOpGbiKgTh3AydZ9JzzVhBR9k9Fr+
         hnjA==
X-Gm-Message-State: AOAM5310JjuzVTIR1qXEi9ixZAkFTyW4Wcxa3Cw8hLYEiMVHQ6kLJVdq
        Ucigm7iBw17lkeQIqy7B1RN7XxOEP5z2285ZcBG+c4my
X-Google-Smtp-Source: ABdhPJz9cAVpImn8983jP1mmHhrGQtrCi7UUtp2qUnGXZ90Z3yMVXSqyCAaspbPpnMpLbG0/1jqfW0RQZNzO7ekUspU=
X-Received: by 2002:a17:906:a415:: with SMTP id l21mr15501583ejz.2.1608561120613;
 Mon, 21 Dec 2020 06:32:00 -0800 (PST)
MIME-Version: 1.0
References: <20201219125344.671832095@linuxfoundation.org> <20201219125345.376925474@linuxfoundation.org>
 <20201219215139.GA29536@amd> <CAFBinCBRe3Oacqce1EDQpoNmEhXeUxJrA43RTA0+_fVciDJzhg@mail.gmail.com>
 <20201219231312.GA4206@duo.ucw.cz>
In-Reply-To: <20201219231312.GA4206@duo.ucw.cz>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 21 Dec 2020 15:31:49 +0100
Message-ID: <CAFBinCAxa8=bc8CkLzBpjEUL9usBVZ4YVKxRNG6Bv31ao-7Nfw@mail.gmail.com>
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

On Sun, Dec 20, 2020 at 12:13 AM Pavel Machek <pavel@ucw.cz> wrote:
>
> On Sat 2020-12-19 23:38:25, Martin Blumenstingl wrote:
> > Hi Pavel,
> >
> > On Sat, Dec 19, 2020 at 10:51 PM Pavel Machek <pavel@ucw.cz> wrote:
> > [...]
> > > I can't say I like this one:
> > >
> > >
> > > >       clk_configs->m250_mux.reg = dwmac->regs + PRG_ETH0;
> > > > -     clk_configs->m250_mux.shift = PRG_ETH0_CLK_M250_SEL_SHIFT;
> > > > -     clk_configs->m250_mux.mask = PRG_ETH0_CLK_M250_SEL_MASK;
> > > > +     clk_configs->m250_mux.shift = __ffs(PRG_ETH0_CLK_M250_SEL_MASK);
> > >
> > > It replaces constant with computation done at runtime; compiler can't
> > > optimize it as __ffs is implemented with asm().
> > what do you suggest to use instead?
> > personally I don't see a problem because this is only called once at
> > driver probe time.
>
> I believe canonical solution is version before this patch, just with
> fixed values....
OK, thanks for the hint
I will keep it in my for patches in the future


Best regards,
Martin
