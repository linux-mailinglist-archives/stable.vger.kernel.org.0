Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329861D4AE6
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 12:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgEOK2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 06:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbgEOK2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 May 2020 06:28:02 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA01FC061A0C;
        Fri, 15 May 2020 03:28:00 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id b6so604793uak.6;
        Fri, 15 May 2020 03:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3n9AM9nUet+cKV+6rKTLJ2mxhROsEpoAkrE2eV2F+EI=;
        b=GBd2GeA6ataobGDg4jQ4FXSHegGNPaQOmwt2GXy5yXDDA4iYjmYrAyuXfpcqPOa5YC
         SF9w+wnW3gVanphCuwC/a4oviMWmCoXQneufhGcsnrpK5Ad0ik3r1jHO8tUXr5h1LNTz
         58e7y69b+tbJCwxalQ7E3P5ZZF80hxgfXQ6Pz+ouc8M8+xqhJyP5mL1aE/msDqlsnlNj
         0H95XbJIIBUk+cC+t4q5msndpSKxlWiQmNeJ23MscOK28PbdH7u9kpaJRqF2V4m3xHZL
         m1zPrVnnHk8NJc221dc+9pBZrYE8pk2/kHML83MaIZRvBw27+h4eO9R5Y8xIEb13e1xY
         bZ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3n9AM9nUet+cKV+6rKTLJ2mxhROsEpoAkrE2eV2F+EI=;
        b=udsFXlncpptlTixSpJ4oeREjZwf9xBNDXc7rXeJaJePVyASiBqIwEklW4mWghTwy7f
         Uln6KOAtTfhgpBC0EyGSGW5XS+djsMavFJl0Dl6pGPHiQVdb88vUSMA3qsWj/Ul1tNqx
         Ot7R/Xze2H6ShJ2pSoqivcb8wcGp7HXzQ9Lze3n8GEKR2RFDnQWO3Wr6Aegc9ctieEzz
         Q1zMxzPnRjsfj9u93uJngOKZOC9DV9MClB+nHZcFqI+h+YXduHJHyTw/uIxCocN2w3VE
         D4ZLCIrxVgeFQiN/gLI1U7uXpZ4GaMKY9ZqlY9T5mqcIx1QwIUfTpQlVeKfwye6lZAta
         N0xw==
X-Gm-Message-State: AOAM531uhpCJu75pofPb6csZRPFviTkDPrEF9g8vGKx8GnKwrpfgtxdA
        PZ4PNKsyv97OLUrv+b6YiqJe1en5wlsm06kT+pQ=
X-Google-Smtp-Source: ABdhPJwklJ5H1ic2J2YXfycgYALz3yo5uNGEUuzlAu3/5Yu2QHdMkr06dR+9Ff99k9fEmbwDkLDnmKHi4E+YFv57mes=
X-Received: by 2002:ab0:662:: with SMTP id f89mr2162219uaf.118.1589538479980;
 Fri, 15 May 2020 03:27:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200511123846.96594-1-christian.gmeiner@gmail.com>
 <CAH9NwWcJNhUVkzd0KAfJyxNZJ9a71KLzipW+qRwhgEWUmnnxmg@mail.gmail.com>
 <X0BDAQ.L99CTJZCDEJE3@crapouillou.net> <a51cb70623c4c2441bb8df8385f56c99392b8435.camel@pengutronix.de>
In-Reply-To: <a51cb70623c4c2441bb8df8385f56c99392b8435.camel@pengutronix.de>
From:   Christian Gmeiner <christian.gmeiner@gmail.com>
Date:   Fri, 15 May 2020 12:27:48 +0200
Message-ID: <CAH9NwWc6zUvoJ0xep9zO2Ocm8BzR7nRNx9=EQuwb5DXsX-J0Zw@mail.gmail.com>
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

Am Fr., 15. Mai 2020 um 12:24 Uhr schrieb Lucas Stach <l.stach@pengutronix.=
de>:
>
> Am Freitag, den 15.05.2020, 12:12 +0200 schrieb Paul Cercueil:
> > Hi Christian,
> >
> > Le ven. 15 mai 2020 =C3=A0 12:09, Christian Gmeiner
> > <christian.gmeiner@gmail.com> a =C3=A9crit :
> > > Am Mo., 11. Mai 2020 um 14:38 Uhr schrieb Christian Gmeiner
> > > <christian.gmeiner@gmail.com>:
> > > >  The GC860 has one GPU device which has a 2d and 3d core. In this
> > > > case
> > > >  we want to expose perfmon information for both cores.
> > > >
> > > >  The driver has one array which contains all possible perfmon domai=
ns
> > > >  with some meta data - doms_meta. Here we can see that for the GC86=
0
> > > >  two elements of that array are relevant:
> > > >
> > > >    doms_3d: is at index 0 in the doms_meta array with 8 perfmon
> > > > domains
> > > >    doms_2d: is at index 1 in the doms_meta array with 1 perfmon
> > > > domain
> > > >
> > > >  The userspace driver wants to get a list of all perfmon domains an=
d
> > > >  their perfmon signals. This is done by iterating over all domains
> > > > and
> > > >  their signals. If the userspace driver wants to access the domain
> > > > with
> > > >  id 8 the kernel driver fails and returns invalid data from doms_3d
> > > > with
> > > >  and invalid offset.
> > > >
> > > >  This results in:
> > > >    Unable to handle kernel paging request at virtual address 000000=
00
> > > >
> > > >  On such a device it is not possible to use the userspace driver at
> > > > all.
> > > >
> > > >  The fix for this off-by-one error is quite simple.
> > > >
> > > >  Reported-by: Paul Cercueil <paul@crapouillou.net>
> > > >  Tested-by: Paul Cercueil <paul@crapouillou.net>
> > > >  Fixes: ed1dd899baa3 ("drm/etnaviv: rework perfmon query
> > > > infrastructure")
> > > >  Cc: stable@vger.kernel.org
> > > >  Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
> > > >  ---
> > > >   drivers/gpu/drm/etnaviv/etnaviv_perfmon.c | 2 +-
> > > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > >  diff --git a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> > > > b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> > > >  index e6795bafcbb9..35f7171e779a 100644
> > > >  --- a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> > > >  +++ b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> > > >  @@ -453,7 +453,7 @@ static const struct etnaviv_pm_domain
> > > > *pm_domain(const struct etnaviv_gpu *gpu,
> > > >                  if (!(gpu->identity.features & meta->feature))
> > > >                          continue;
> > > >
> > > >  -               if (meta->nr_domains < (index - offset)) {
> > > >  +               if ((meta->nr_domains - 1) < (index - offset)) {
> > > >                          offset +=3D meta->nr_domains;
> > > >                          continue;
> > > >                  }
> > > >  --
> > > >  2.26.2
> > > >
> > >
> > > ping
> >
> > I'll merge it tomorrow if there's no further feedback.
>
> Huh? Etnaviv patches are going through the etnaviv tree.
>
> We now have two different solutions to the same issue. I first want to
> dig into the code to see why two developers can get confused enough by
> the code to come up with totally different fixes.
>

You will see that the solutions are not totally different. I really hoped t=
o
get this fixed in the 5.7 release.. but I think its now too late.

--=20
greets
--
Christian Gmeiner, MSc

https://christian-gmeiner.info/privacypolicy
