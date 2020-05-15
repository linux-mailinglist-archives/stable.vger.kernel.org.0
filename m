Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98651D4B49
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 12:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbgEOKoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 06:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728013AbgEOKoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 May 2020 06:44:24 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82710C061A0C;
        Fri, 15 May 2020 03:44:24 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id s5so619739uad.4;
        Fri, 15 May 2020 03:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YgrIIrg4mnIAMD9622ZNs+MTWyUAyrZXO6F1RXxlaUo=;
        b=qBpBRBd+taT5XlFmUkeAv/Lh+hN7eLDn8H6QxhWoJpEpjwIwhm+RO81oNPuFkcPTiU
         t5qFna5c2zvlntgknYHcHd5xd3W4vR8i10sbG3EVVO0S5qFs188+RcwEBhy7JSoCSrxQ
         e4OmdKf5lv3LNLKVCbds2+5jvr0iYU8ItqiknQJz5P8m3VEUhUj1t3EBfNtdaqmwE8gU
         7gvEyQ9YaHs0cvJ/8WPsWL+50Do3WQe6R/0LVv5AqqZfNSa9XbiqrU5NXyixK8CccUd4
         4a5XzGqvgl5Pa4zBNVAfYThXRix4FJ6BTryUrzURbn9/d7u9EmqLX7InwgkwXvFSHJ55
         6WlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YgrIIrg4mnIAMD9622ZNs+MTWyUAyrZXO6F1RXxlaUo=;
        b=mgkWiS+rOTgI1LEP7Gt47YCKK9ByFPqCHgzrsi63ilExICgds3NZypPVf0BByZJP+s
         oLRxMPYREGbUIXtKY/7qGWu6HjwYtb6pFAbt6jPKdg7b24NHO0J38ywXDvjp10/TtBvg
         kW1sH0gS22UUEskQWeH47dnUQGhiOyzxWZqZyufMu3Wo/Le+ivWfNZCJ5TuSNDkx5rFo
         ntimjxib+fwR66hE35lV6pldvtYiNTB7n+IjPq1A7p6w71d6yyi9c0oYEyC4DVRuZPP9
         8EFnTxTLqHsphXO5Pxi+7qHVYb3OjYwUAIus+rnV7xDd5FP8MoH45vbrRQCggZGjarcF
         CeEQ==
X-Gm-Message-State: AOAM532CzrcScuDsdnqEl/GJ6les7rK9AWeRLdw5QD30wthMRbjLbC21
        Adno0vAjpzpGmu+EpLoZwHg6mMnDiRz7s1nZVmM=
X-Google-Smtp-Source: ABdhPJzGP3waNVN9Q8Dt2zJH7viCURTLsKBnUK2Y9VknZqkyRmQ7DRt5B81IjaNpVV5vHr1rgJGqeMMQ4pnGv69SQTA=
X-Received: by 2002:ab0:4ac9:: with SMTP id t9mr2350299uae.40.1589539463686;
 Fri, 15 May 2020 03:44:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200511123846.96594-1-christian.gmeiner@gmail.com>
 <CAH9NwWcJNhUVkzd0KAfJyxNZJ9a71KLzipW+qRwhgEWUmnnxmg@mail.gmail.com>
 <X0BDAQ.L99CTJZCDEJE3@crapouillou.net> <a51cb70623c4c2441bb8df8385f56c99392b8435.camel@pengutronix.de>
 <CAH9NwWc6zUvoJ0xep9zO2Ocm8BzR7nRNx9=EQuwb5DXsX-J0Zw@mail.gmail.com> <ed4688343e443ff76644051be544c70fd8c5345b.camel@pengutronix.de>
In-Reply-To: <ed4688343e443ff76644051be544c70fd8c5345b.camel@pengutronix.de>
From:   Christian Gmeiner <christian.gmeiner@gmail.com>
Date:   Fri, 15 May 2020 12:44:12 +0200
Message-ID: <CAH9NwWctscn-cfU_Y1OV2GV_T3oNn1H2Tmu18OHQOD4=aTYbFA@mail.gmail.com>
Subject: Re: [PATCH] drm/etnaviv: fix perfmon domain interation
To:     Lucas Stach <l.stach@pengutronix.de>
Cc:     Paul Cercueil <paul@crapouillou.net>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        The etnaviv authors <etnaviv@lists.freedesktop.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Fr., 15. Mai 2020 um 12:33 Uhr schrieb Lucas Stach <l.stach@pengutronix.=
de>:
>
> Am Freitag, den 15.05.2020, 12:27 +0200 schrieb Christian Gmeiner:
> > Am Fr., 15. Mai 2020 um 12:24 Uhr schrieb Lucas Stach <l.stach@pengutro=
nix.de>:
> > > Am Freitag, den 15.05.2020, 12:12 +0200 schrieb Paul Cercueil:
> > > > Hi Christian,
> > > >
> > > > Le ven. 15 mai 2020 =C3=A0 12:09, Christian Gmeiner
> > > > <christian.gmeiner@gmail.com> a =C3=A9crit :
> > > > > Am Mo., 11. Mai 2020 um 14:38 Uhr schrieb Christian Gmeiner
> > > > > <christian.gmeiner@gmail.com>:
> > > > > >  The GC860 has one GPU device which has a 2d and 3d core. In th=
is
> > > > > > case
> > > > > >  we want to expose perfmon information for both cores.
> > > > > >
> > > > > >  The driver has one array which contains all possible perfmon d=
omains
> > > > > >  with some meta data - doms_meta. Here we can see that for the =
GC860
> > > > > >  two elements of that array are relevant:
> > > > > >
> > > > > >    doms_3d: is at index 0 in the doms_meta array with 8 perfmon
> > > > > > domains
> > > > > >    doms_2d: is at index 1 in the doms_meta array with 1 perfmon
> > > > > > domain
> > > > > >
> > > > > >  The userspace driver wants to get a list of all perfmon domain=
s and
> > > > > >  their perfmon signals. This is done by iterating over all doma=
ins
> > > > > > and
> > > > > >  their signals. If the userspace driver wants to access the dom=
ain
> > > > > > with
> > > > > >  id 8 the kernel driver fails and returns invalid data from dom=
s_3d
> > > > > > with
> > > > > >  and invalid offset.
> > > > > >
> > > > > >  This results in:
> > > > > >    Unable to handle kernel paging request at virtual address 00=
000000
> > > > > >
> > > > > >  On such a device it is not possible to use the userspace drive=
r at
> > > > > > all.
> > > > > >
> > > > > >  The fix for this off-by-one error is quite simple.
> > > > > >
> > > > > >  Reported-by: Paul Cercueil <paul@crapouillou.net>
> > > > > >  Tested-by: Paul Cercueil <paul@crapouillou.net>
> > > > > >  Fixes: ed1dd899baa3 ("drm/etnaviv: rework perfmon query
> > > > > > infrastructure")
> > > > > >  Cc: stable@vger.kernel.org
> > > > > >  Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
> > > > > >  ---
> > > > > >   drivers/gpu/drm/etnaviv/etnaviv_perfmon.c | 2 +-
> > > > > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > >
> > > > > >  diff --git a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> > > > > > b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> > > > > >  index e6795bafcbb9..35f7171e779a 100644
> > > > > >  --- a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> > > > > >  +++ b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> > > > > >  @@ -453,7 +453,7 @@ static const struct etnaviv_pm_domain
> > > > > > *pm_domain(const struct etnaviv_gpu *gpu,
> > > > > >                  if (!(gpu->identity.features & meta->feature))
> > > > > >                          continue;
> > > > > >
> > > > > >  -               if (meta->nr_domains < (index - offset)) {
> > > > > >  +               if ((meta->nr_domains - 1) < (index - offset))=
 {
> > > > > >                          offset +=3D meta->nr_domains;
> > > > > >                          continue;
> > > > > >                  }
> > > > > >  --
> > > > > >  2.26.2
> > > > > >
> > > > >
> > > > > ping
> > > >
> > > > I'll merge it tomorrow if there's no further feedback.
> > >
> > > Huh? Etnaviv patches are going through the etnaviv tree.
> > >
> > > We now have two different solutions to the same issue. I first want t=
o
> > > dig into the code to see why two developers can get confused enough b=
y
> > > the code to come up with totally different fixes.
> > >
> >
> > You will see that the solutions are not totally different. I really hop=
ed to
> > get this fixed in the 5.7 release.. but I think its now too late.
>
> I didn't have time to look at the full picture, yet. We still have at
> least a week until the final 5.7 release, why would it be too late to
> get a fix upstream?
>

Great - so I count on you that we will have a fix in 5.7 release.

--=20
greets
--
Christian Gmeiner, MSc

https://christian-gmeiner.info/privacypolicy
