Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE352760A4
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 20:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgIWS7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 14:59:22 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:39159 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgIWS7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 14:59:21 -0400
Received: from mail-qt1-f180.google.com ([209.85.160.180]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MHWzP-1kGVAE350r-00DZiz; Wed, 23 Sep 2020 20:59:19 +0200
Received: by mail-qt1-f180.google.com with SMTP id e7so795745qtj.11;
        Wed, 23 Sep 2020 11:59:19 -0700 (PDT)
X-Gm-Message-State: AOAM531wP72iA0pbmJE5KBpH6cKsCYf/WxXicRDnjpCtkpqw9aCTvJlJ
        EF/cJw14rzQRsvYr3MFHAxxRvPAq2HMp5IJvIfw=
X-Google-Smtp-Source: ABdhPJwme+rb5RoO6LECQNeo8izrVwlnHxry8TaPntfd7H7TZLiqhZzguIxt8lKcD7A5risH74SRBfnVMBOeFQ1ENqU=
X-Received: by 2002:aed:2ce5:: with SMTP id g92mr1583405qtd.204.1600887558368;
 Wed, 23 Sep 2020 11:59:18 -0700 (PDT)
MIME-Version: 1.0
References: <1600627038-40000-1-git-send-email-clabbe@baylibre.com>
 <1600627038-40000-5-git-send-email-clabbe@baylibre.com> <CAK8P3a34V16PUoVJjoUOVCik_rdb6vAy=54qRzWdO+aJcwUwsg@mail.gmail.com>
 <20200923180608.GA26666@Red>
In-Reply-To: <20200923180608.GA26666@Red>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 23 Sep 2020 20:59:02 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2s_mJaK+Z1_vvY_oCax1x2ksyiOVBd7MytA47bQ6tVfw@mail.gmail.com>
Message-ID: <CAK8P3a2s_mJaK+Z1_vvY_oCax1x2ksyiOVBd7MytA47bQ6tVfw@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] crypto: sun4i-ss: handle BigEndian for cipher
To:     LABBE Corentin <clabbe@baylibre.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, "# 3.4.x" <stable@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:Ffk0sIPApP9DGKKBthlUPcFIrquo0PFCB2U91OY+rfsvP8EcTBt
 xSgoOt3nR4v6AJ/G66vt7yKV+EpgVVmVNAQ/u3ft53yF8EJ4hG9woEvRM39HD82t3Im7hVY
 S6QLI/YwlnQQgIQWIvd9HyFCOhXxw47DSXODks1Hjiz4Kl/cKmFDw5wWwfyDSOurEUe6xUF
 VSVxqwa0Rgh5dtTgzzutg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:T7JvNbskoq0=:IdcnmBiMJGzWYlKdmp1CIU
 S4Cg7RxeWWa0TGMIx7wSYU4EjkMm7SSM5EKP8wQvHkf1qA49umQPq6/0Yq/b53g4vspDV3nQI
 5aZGZkH/EXXQzoIpEWRZqXdsa2+EIxKU1AdkLHboaQWNF27OkCaRP117wzZQCCCf10kH4/JMN
 q8S9mOlybsdBL9VnTWZiAtzbR4Y9eI0DjR+LDH9wVbyCJpkoHG9LG2fPzSZ5v6ANALK1MizqK
 gHwHTdmNb9r+Lrrs0RfKUSMtfs//sujITiJmzRCKvjNeEyR2sTwB1wXE7OpqslPLN1AiCQQ32
 FDZ6tLaJgFJY27jG/RVB48smOjTLeeEI18A2lC5YETACUaLITipMu4NXYd8T8O9pNdEW0W3hK
 EgIhDMMFekwKfcw3uhqy4O0LrLpQBpYr1JAMGu6cEvA6f32SGZSK+Z654wcFYhlFZDGpsXwg/
 u6cSnXv5ho7wWFzZDO3thITHERXFSXFxCqougP46u1TjaO1Nnz9FqFJ/eFqxV7SI4kDOrwE17
 PhzkcyAgUe+JaMQ3ZurbVIzxclQ90ccBQ5AoFBafckJ3HA9malbkkgNKFfvu7P0HHK2JTMKs7
 5RYlFJxvInF2Hk0rEAVhbbb6Gia61oqvRGn/N+LBmq+8bW/Tc4QtR5jkNhLh7J6C1VMeeBYk/
 Q2E+3msI/mCQAH+JAoRhi2Bz8EZ4UoD4GQH7Big/oqr7EUfE6MmBEBxHmBun3hFyvwbU0r6SH
 cj+dqtRPYfnrZfjB5AIKsyLwQQHe3HT+Z60nJoMnAv/yvXkzNqeu0NrCAzgjqEzeMWztWw8JH
 kYITKJGzRFYxVf1XaGG2TGnb5oYkSTD+5dvIWJWTDT0J0/6XQ9d74wT59S2RgBc4MwiNuqZYZ
 5+2kSNBTXe/WeClBePF+KsulQ13HZUHISnt5rKfKC9THge9KXynV+1Zc3FhEfE7lp927WlyCq
 jwjAxulYxaFcigkGeL8IoTlBe95Xk7QJd9ttw4xIOX/22RrR40CUD
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 23, 2020 at 8:08 PM LABBE Corentin <clabbe@baylibre.com> wrote:
> On Wed, Sep 23, 2020 at 04:00:32PM +0200, Arnd Bergmann wrote:
> > On Sun, Sep 20, 2020 at 8:37 PM Corentin Labbe <clabbe@baylibre.com> wrote:
> > > diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> > > index c6c25204780d..a05889745097 100644
> > > --- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> > > +++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> > > @@ -52,13 +52,13 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
> > >
> > >         spin_lock_irqsave(&ss->slock, flags);
> > >
> > > -       for (i = 0; i < op->keylen; i += 4)
> > > -               writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
> > > +       for (i = 0; i < op->keylen / 4; i++)
> > > +               writel(cpu_to_le32(op->key[i]), ss->base + SS_KEY0 + i * 4);
> >
> > I suspect what you actually want here is writesl() in place of the
> > loop. This skips the byteswap on big-endian, rather than swapping
> > each word twice.
> >
> > The point is that this register seems to act as a FIFO for a byte-stream
> > rather than a 32-bit fixed-endian register.
>
> Thanks, using writesl() fixes the warning, but I need to keep the loop
> since the register is different each time.

Ah, I see. I thought we had an interface for that as well, but I can't
find it now. I see memcpy_toio32() in one driver, but that implementation
appears to be wrong here (and probably also wrong for the machine
it was meant for)

There is the regular memcpy_toio(), but on big-endian Arm that
turns into a per-byte copy, which might either not work on your
hardware or be too slow.

There is also __iowrite32_copy(), which is not what I had remembered
but does seem to do what you want here.

> Or does it is better to use directly __raw_writel() ?

__raw_writel() is not very portable, so I would avoid that in normal
device drivers even when you only run them on specific hardware.

      Arnd
