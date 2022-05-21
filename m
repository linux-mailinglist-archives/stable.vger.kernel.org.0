Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148C052FDDA
	for <lists+stable@lfdr.de>; Sat, 21 May 2022 17:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241600AbiEUP3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 May 2022 11:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239767AbiEUP3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 May 2022 11:29:00 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E276161B;
        Sat, 21 May 2022 08:28:56 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id u27so14212103wru.8;
        Sat, 21 May 2022 08:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=474y7UfCRTsp7NYIaB401zDajP8fumzJCkbTMejJvAo=;
        b=egau6YuJmG0rUfjr1WGwMPgtoGz0oaIp6jir0ySrR8KpYY3iin1mA0DLxw5CgXjfmc
         8Pg42jto7J+ozkNb9HbVEhYlqvqH4BtHlUo4rXCr+jAjl1tjQ2ZqgttnN4Izo2t40GST
         A1hfPqiAqa7o6bjunCs93ODy20hN4Cpze5TQGbYi+VaJFFKtO2caZKXJY+7oKTtEp5zC
         9xd+l7B+cLL4tJ/iq+Ao7KoFSdJ1b4E817c8IHf+et8KUEHpCwKk6SUslDlOyIuIeMAE
         ThymgL9Xn/M92z4lnjAsadLaBnXW4LW3XJpVntRz3gKqG8xXDKzwTh3ilh6Vhfblp+Gm
         wC1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=474y7UfCRTsp7NYIaB401zDajP8fumzJCkbTMejJvAo=;
        b=tjMTTx/9+X6+0ZbUOE+5Fz262sUgNeIa85bQfwJ059GsK7RI5ZQyYoajz6SYjhD5We
         wQUsTDbS6N5/7V6Lut1BHDOCjyCi+1/mmn6L7SosYbsY3qbxCv172pfsaJW1muLSeaqs
         KhUR8sIXYgq8LEc2/vHXvDtwm57jfCuNs+seuY8bZua6j1Frv9zhbGLCh16d5SK6KfmJ
         koalLhJXA6zAzYb8/npAr00ePNYcwo/vOMc3Ee5UDSsCaBcbw40omH7RcAxdsu60KT90
         7E/BnPCqmuhMIqkQvr8HJzDG5hAAAwJHXcvAno/Rd6iTv7u7ylDxSBunU4Ezy+SEwrCL
         Cpeg==
X-Gm-Message-State: AOAM532SNQM/Gl796iP6hIEOml+l4OddbikWD8bgeuETm8eW7uxhac8L
        2Ua93D7giLQW01LMKoCjQ4asBDkTX3PhYBBRoprO0pGF
X-Google-Smtp-Source: ABdhPJy1gy3TcT6tbHE9HFuEjS++I3T9N2yFEV3c8NSNJllsZt4VZryxiLQf35/3BKKO+BCfqLJt0T3F6KUfSvF/NSQ=
X-Received: by 2002:a5d:598c:0:b0:20c:6912:6870 with SMTP id
 n12-20020a5d598c000000b0020c69126870mr12311621wri.465.1653146934778; Sat, 21
 May 2022 08:28:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220417181538.57fa1303@blackhole> <CA+E=qVeX2aU0hiDMxLXzVk-YiMsqKKFKpm=cc=72joMhZmNV1g@mail.gmail.com>
 <CA+E=qVdEtx8wVbcrMQYGB1ur1ykvNRp1L174mVSMkB0zeOPYNQ@mail.gmail.com>
 <20220428175759.13f75c21@blackhole.lan> <CA+E=qVcNasK=q8o0g1teqK3+cD3aywy+1bgtTJC4VvaZvfZtGA@mail.gmail.com>
 <20220519153952.7c6c412b@blackhole>
In-Reply-To: <20220519153952.7c6c412b@blackhole>
From:   Vasily Khoruzhick <anarsoul@gmail.com>
Date:   Sat, 21 May 2022 08:28:27 -0700
Message-ID: <CA+E=qVeQNy3ACATMq+HPqx9Anxm1U_X2mWPo8J4_3yxiKBn9Pg@mail.gmail.com>
Subject: Re: [PATCH] drm/bridge: fix anx6345 power up sequence
To:     Torsten Duwe <duwe@lst.de>
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Thierry Reding <treding@nvidia.com>,
        Lyude Paul <lyude@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Harald Geyer <harald@ccbib.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 19, 2022 at 6:40 AM Torsten Duwe <duwe@lst.de> wrote:
>
> On Wed, 18 May 2022 09:53:58 -0700
> Vasily Khoruzhick <anarsoul@gmail.com> wrote:
>
> > On Thu, Apr 28, 2022 at 8:58 AM Torsten Duwe <duwe@lst.de> wrote:
>
> > > power on the eDP bridge? Could there be any leftovers from that
> > > mechanism? I use a hacked-up U-Boot with a procedure similar to the
> > > kernel driver as fixed by this change.
>
> I was asking because I recall an ugly hack in some ATF code to power up
> the chip correctly. Did you patch ATF, and maybe call functions of it
> at runtime?

Initially it's powered on by ATF on system power up. ATF parses DTB
and finds the regulators that it needs to enable and enables them.
It's done in ATF because u-boot SPL didn't have enough space to fit in
the AXP803 driver. It's only done at startup and once linux takes
over, ATF doesn't touch these regulators.

> > >
> > > But the main question is: does this patch in any way worsen the
> > > situation on the pinebook?
> >
> > I don't think it worsens anything, but according to the datasheet the
> > change makes no sense. Could you try increasing T2 instead of changing
> > the power sequence?
>
> According to the datasheet, there is also T3, I realise now. The
> diagram talks about "System Clock", but both Teres and Pinebook have a
> passive resonator circuit there. Correct me if I'm wrong, but without
> chip power, there is little to resonate. What if that driving clock
> circuit is powered by Vdd25? Maybe the earlier provision of 2V5 is
> enough for Teres' Q4, but Pinebook X4 takes even longer? The start-up
> times can be in the range of milliseconds.

That's plausible, but can you please try just increasing the delays
without changing the power sequence?

>         Torsten
