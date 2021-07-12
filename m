Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F4C3C62BB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 20:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbhGLSlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 14:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhGLSlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 14:41:45 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EDEC0613E5
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 11:38:57 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id 128-20020a4a11860000b029024b19a4d98eso4757694ooc.5
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 11:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FZWI809EM0kWSYKdDeR8M3Ek3N/OKceTmzxiJRrMjv0=;
        b=U/qz5/PV6oqvmMd/Zt16iUeVPD3wWnzAUca3PgKD2HuN28lr4NPCgx6/NISCFp3Lvf
         6NnmIqLkvibjMtlj4qMqP4PURjO1zanRe/ubXj94xzlYNIrJ1A6uZsOF6LWwg/0dAY7M
         4ycBW0KE8kBx+CyIvNgS+m5OR9aU+vOSCtF2w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FZWI809EM0kWSYKdDeR8M3Ek3N/OKceTmzxiJRrMjv0=;
        b=BkTY7hvZtX/VDaaBZkNpVBjSQRdL7UV9X6U7WZBsir+7vnWwkvvxzDWgXga5I16x2C
         gqhEZTFuh2OSJEF61Rh4EySVWtLFttegJ1bOA1Hqzn/gRDxw1vr7fyGXB1EVrIX4OB6y
         iYP7HvT1scfCldZjU/m5SMi3I6ARDPXEKtBkNDDIKV+KvigAaPJ4mrkEC+K1WMuUS8D1
         0CdUxcYFSC4dH3noOraZFzhYSGoFyTCC0gEw50uQ61eWHKCv5YLo4J8zJp52tYwuGIq3
         YRaXkeDTBO/pu7JOPnO3z5x37JwJb80j71CRk36yc326dg7FpaPv2OxJKZlgsf1VG192
         uhzA==
X-Gm-Message-State: AOAM531lLFiFHXTS5RzKCELTHrcUrV6FqdGFVO8z5rf1QulOSUGhHqQI
        6R7t1CE4lflO3M3aH/oNxCoTmr6MmhPlcg==
X-Google-Smtp-Source: ABdhPJwR0dHEuWhG/iBfJ5ac1VAUJKQShbSQpUCvfgodtIf08+GHt46Sh9yA0NvqdUmkDsDbop2QKA==
X-Received: by 2002:a4a:e907:: with SMTP id z7mr484003ood.20.1626115136154;
        Mon, 12 Jul 2021 11:38:56 -0700 (PDT)
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com. [209.85.167.178])
        by smtp.gmail.com with ESMTPSA id u18sm1904784ooq.36.2021.07.12.11.38.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 11:38:55 -0700 (PDT)
Received: by mail-oi1-f178.google.com with SMTP id w194so2257762oie.5
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 11:38:55 -0700 (PDT)
X-Received: by 2002:a05:6808:112:: with SMTP id b18mr3729139oie.77.1626115134537;
 Mon, 12 Jul 2021 11:38:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210711141634.6133-1-len.baker@gmx.com> <b0811e08c4a04d2093f3251c55c0edb8@realtek.com>
In-Reply-To: <b0811e08c4a04d2093f3251c55c0edb8@realtek.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 12 Jul 2021 11:38:43 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOC_dqhf84kP4LsbenJuqeDyKcNFj=EaemrvfJy1oZi_Q@mail.gmail.com>
Message-ID: <CA+ASDXOC_dqhf84kP4LsbenJuqeDyKcNFj=EaemrvfJy1oZi_Q@mail.gmail.com>
Subject: Re: [PATCH] rtw88: Fix out-of-bounds write
To:     Pkshih <pkshih@realtek.com>
Cc:     Len Baker <len.baker@gmx.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 11, 2021 at 6:43 PM Pkshih <pkshih@realtek.com> wrote:
> > -----Original Message-----
> > From: Len Baker [mailto:len.baker@gmx.com]
> >
> > In the rtw_pci_init_rx_ring function the "if (len > TRX_BD_IDX_MASK)"
> > statement guarantees that len is less than or equal to GENMASK(11, 0) or
> > in other words that len is less than or equal to 4095. However the
> > rx_ring->buf has a size of RTK_MAX_RX_DESC_NUM (defined as 512). This
> > way it is possible an out-of-bounds write in the for statement due to
> > the i variable can exceed the rx_ring->buff size.
> >
> > Fix it using the ARRAY_SIZE macro.
> >
> > Cc: stable@vger.kernel.org
> > Addresses-Coverity-ID: 1461515 ("Out-of-bounds write")

Coverity seems to be giving a false warning here. I presume it's
taking the |len| comparison as proof that |len| might be as large as
TRX_BD_IDX_MASK, but as noted below, that's not really true; the |len|
comparison is really just dead code.

> > Fixes: e3037485c68ec ("rtw88: new Realtek 802.11ac driver")
> > Signed-off-by: Len Baker <len.baker@gmx.com>

> To prevent the 'len' argument from exceeding the array size of rx_ring->buff, I
> suggest to add another checking statement, like
>
>         if (len > ARRAY_SIZE(rx_ring->buf)) {
>                 rtw_err(rtwdev, "len %d exceeds maximum RX ring buffer\n", len);
>                 return -EINVAL;
>         }

That seems like a better idea, if we really need to patch anything.

> But, I wonder if this a false alarm because 'len' is equal to ARRAY_SIZE(rx_ring->buf)
> for now.

Or to the point: rtw_pci_init_rx_ring() is only ever called with a
fixed constant -- RTK_MAX_RX_DESC_NUM (i.e., 512) -- so the alleged
overflow cannot happen.

Brian
