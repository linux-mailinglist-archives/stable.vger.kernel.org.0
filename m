Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3491F444A35
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 22:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhKCV2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 17:28:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27897 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229968AbhKCV2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 17:28:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635974771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Znlql06AhhI7EaphpwppCQqpnxjsVHdYSJklJrdqL1M=;
        b=EOJbcZovDDx+a2qFSS/xOYnGWXdmec8ETRP5qSd15DlZt3K3SftULTM33dhLU5PJ2Fnv/S
        DC5WH4hjzl0MWkEwNkuZhjxJmHomZN/lh/IRWmzyCXtanvl6wGb5OaqwTM01KOaU+bUjpr
        0VwGNwf+3ifiYFUoHmyzml/Z//N61Sw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-_x8mkV73PUurTa-lwMn9CA-1; Wed, 03 Nov 2021 17:26:10 -0400
X-MC-Unique: _x8mkV73PUurTa-lwMn9CA-1
Received: by mail-wm1-f71.google.com with SMTP id n189-20020a1c27c6000000b00322f2e380f2so3344330wmn.6
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 14:26:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Znlql06AhhI7EaphpwppCQqpnxjsVHdYSJklJrdqL1M=;
        b=BB4Z7o8gATlepBHBogfAiPffBKlQZehd9szTb9xv9bIhTIZh3lPkyXVZ2eRIvz5/Hn
         KZouSZstL6S2qMmLCuFcits0J/06/QVsoIY/cJdUgXP6v1NKPqM0dv4imYf5k4e9pXtu
         f0i4mT5x1iLHOLhvQA4hWVJ/A5t+zT2g9bdjYK8fVD1b43ecgrVoRtAF8ZFtHM1XmOcu
         +EsKkaVY6JAm6WJDyDWKiwPmrd7oCtbcpxyVYhs1YCOutdWsnklC3IY/KU2+xhoc43T7
         BuSHl9gk9aBu6QPdAxEnUf1sx1MhQlbR50E5pd+oBWiTPrRRCkw2tIFbuaQE3k9jZyXk
         PyWg==
X-Gm-Message-State: AOAM530pu6drkeCV/6jrsC25xJlnnSkVltOEnlYGKXovV8Xka8eqWIvC
        sPosDUaU/nRD3SH+2psvjz/fBBr6pmtP4EWlHyniUqotJRemX9QwMBACnVp1LUYkArvmgBMrZqt
        8gRHeRNKVWDZtl7/0TOUCGUSc7uIQ0QjZ
X-Received: by 2002:a05:6000:2ae:: with SMTP id l14mr5061521wry.142.1635974768669;
        Wed, 03 Nov 2021 14:26:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwEJRXkYNzDroD2U2ofyOYD+EctMvHrMm2ahndQNqZj0d+LO2dkGqQ/YFDy55GG7GxIjNBx/OX2kxn9iLDPiU=
X-Received: by 2002:a05:6000:2ae:: with SMTP id l14mr5061507wry.142.1635974768434;
 Wed, 03 Nov 2021 14:26:08 -0700 (PDT)
MIME-Version: 1.0
References: <20211101082511.254155853@linuxfoundation.org> <20211101082518.624936309@linuxfoundation.org>
 <871r3x2f0y.fsf@turtle.gmx.de> <CACO55tsq6DOZnyCZrg+N3m_hseJfN_6+YhjDyxVBAGq9PFJmGA@mail.gmail.com>
 <CACO55tsQVcUHNWAkWcbJ8i-S5pgKhrin-Nb3JYswcBPDd3Wj4w@mail.gmail.com> <87tugt0xx6.fsf@turtle.gmx.de>
In-Reply-To: <87tugt0xx6.fsf@turtle.gmx.de>
From:   Karol Herbst <kherbst@redhat.com>
Date:   Wed, 3 Nov 2021 22:25:57 +0100
Message-ID: <CACO55tsNKKTW6X_+Ym0oySX-iNtikyV6rgHGu01Co7_mDWkxhg@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 5.10 32/77] drm/ttm: fix memleak in ttm_transfered_destroy
To:     Sven Joachim <svenjoac@gmx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Erhard F." <erhard_f@mailbox.org>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Huang Rui <ray.huang@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 3, 2021 at 9:47 PM Sven Joachim <svenjoac@gmx.de> wrote:
>
> On 2021-11-03 21:32 +0100, Karol Herbst wrote:
>
> > On Wed, Nov 3, 2021 at 9:29 PM Karol Herbst <kherbst@redhat.com> wrote:
> >>
> >> On Wed, Nov 3, 2021 at 8:52 PM Sven Joachim <svenjoac@gmx.de> wrote:
> >> >
> >> > On 2021-11-01 10:17 +0100, Greg Kroah-Hartman wrote:
> >> >
> >> > > From: Christian K=C3=B6nig <christian.koenig@amd.com>
> >> > >
> >> > > commit 0db55f9a1bafbe3dac750ea669de9134922389b5 upstream.
> >> > >
> >> > > We need to cleanup the fences for ghost objects as well.
> >> > >
> >> > > Signed-off-by: Christian K=C3=B6nig <christian.koenig@amd.com>
> >> > > Reported-by: Erhard F. <erhard_f@mailbox.org>
> >> > > Tested-by: Erhard F. <erhard_f@mailbox.org>
> >> > > Reviewed-by: Huang Rui <ray.huang@amd.com>
> >> > > Bug: https://bugzilla.kernel.org/show_bug.cgi?id=3D214029
> >> > > Bug: https://bugzilla.kernel.org/show_bug.cgi?id=3D214447
> >> > > CC: <stable@vger.kernel.org>
> >> > > Link: https://patchwork.freedesktop.org/patch/msgid/20211020173211=
.2247-1-christian.koenig@amd.com
> >> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> > > ---
> >> > >  drivers/gpu/drm/ttm/ttm_bo_util.c |    1 +
> >> > >  1 file changed, 1 insertion(+)
> >> > >
> >> > > --- a/drivers/gpu/drm/ttm/ttm_bo_util.c
> >> > > +++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
> >> > > @@ -322,6 +322,7 @@ static void ttm_transfered_destroy(struc
> >> > >       struct ttm_transfer_obj *fbo;
> >> > >
> >> > >       fbo =3D container_of(bo, struct ttm_transfer_obj, base);
> >> > > +     dma_resv_fini(&fbo->base.base._resv);
> >> > >       ttm_bo_put(fbo->bo);
> >> > >       kfree(fbo);
> >> > >  }
> >> >
> >> > Alas, this innocuous looking commit causes one of my systems to lock=
 up
> >> > as soon as run startx.  This happens with the nouveau driver, two ot=
her
> >> > systems with radeon and intel graphics are not affected.  Also I onl=
y
> >> > noticed it in 5.10.77.  Kernels 5.15 and 5.14.16 are not affected, a=
nd I
> >> > do not use 5.4 anymore.
> >> >
> >> > I am not familiar with nouveau's ttm management and what has changed
> >> > there between 5.10 and 5.14, but maybe one of their developers can s=
hed
> >> > a light on this.
> >> >
> >> > Cheers,
> >> >        Sven
> >> >
> >>
> >> could be related to 265ec0dd1a0d18f4114f62c0d4a794bb4e729bc1
> >
> > maybe not.. but I did remember there being a few tmm related patches
> > which only hurt nouveau :/  I guess one could do a git bisect to
> > figure out what change "fixes" it.
>
> Maybe, but since the memory leaks reported by Erhard only started to
> show up in 5.14 (if I read the bugzilla reports correctly), perhaps the
> patch should simply be reverted on earlier kernels?
>

Yeah, I think this is probably the right approach.

> > On which GPU do you see this problem?
>
> On an old GeForce 8500 GT, the whole PC is rather ancient.
>
> Cheers,
>        Sven
>

