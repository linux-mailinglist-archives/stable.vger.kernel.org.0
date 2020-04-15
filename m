Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2025F1AAFF0
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 19:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411414AbgDORif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 13:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411219AbgDORi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 13:38:28 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1605C061A0E
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 10:38:26 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id r24so4647811ljd.4
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 10:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sHqR2C2kxuUQojnOegpnVpnZsXBDzDgx0iHXx8OBUys=;
        b=Vy4tGFrR/UDz2J5FSZuzqmOKo1GCzxTWtZYw44vcauEzWQop68wvIG9gTD/GD6vSVx
         XU/sx8wBiHWMnElHjd+vgG43Pu0fwjE3OO6i10GBubZa9VgOL7U0dcLRL7z//U4t7RVc
         yLc9JmltDVJ99nNme9B93oOoyJNrRlTztgoU7PoT7uk9kJpOkDNL2nlKBeZazkdblE01
         TYsbPQTSf+oLWvQov5xMyKCCjZmXaHOs4Oj2N8do8WbBa1c82XNc6T+bPgKB33ZBEsEE
         wlFNw5pM/M5kzUb6Trl6SkDgQkpS5pamRzWGqC8x2YCx0gKHq/ICFrqJXnZTr9ti2G55
         KnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sHqR2C2kxuUQojnOegpnVpnZsXBDzDgx0iHXx8OBUys=;
        b=Zp5BBx09Qnaccb7yOlSP2spL9t0rbqEftpGO8E4SDEB6yfQg9fqdkeRSqO17Nq2COa
         Riir+Ajx8Z2hn0lFCG9RyIN1n1dGjR3kBt7DvAI0TRt1fY2YqTGZlX6Ec9ge2bPl0nDj
         iZXNPqxp+SnhRha7Mzl12F24DjEeIyp05Fsu2vmb9kbtJBKBARE3UJD6+68YpNFDoFg4
         66x4/sFhG7rvvNRkvSxAcSY3Z3wTeY64fgM+xpJyLV2TQPSgOblunugELcB+BZukPwFZ
         o6z2zY8RO8vmYp7isKMW/1mOjZJqax558WsHWUu19Y+dnLxeEpqCKQqNUwzaSpn+WKTB
         n5+w==
X-Gm-Message-State: AGi0PuY6tA8ZkPR6hq+eKqaYZcETFIpI3At8jLvzNCMfWaQn7zo9/F3s
        DpuiFSqyrek0zwXNOdoEs7i236bNm2MsVcuxA6lxLA==
X-Google-Smtp-Source: APiQypLDAmF2P6A5YCpLFM2PBnROKXHaBtzTgdG+1WeYnzrJQ57PGXzD+r87BQuOOpT+tLulD2nVxdXC0mh6T+pWCAQ=
X-Received: by 2002:a2e:9455:: with SMTP id o21mr3998409ljh.245.1586972304780;
 Wed, 15 Apr 2020 10:38:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200228103752.1944629-1-christian.gmeiner@gmail.com> <4a5436201ff4345194f64aac1553f9656887203a.camel@pengutronix.de>
In-Reply-To: <4a5436201ff4345194f64aac1553f9656887203a.camel@pengutronix.de>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 15 Apr 2020 23:08:13 +0530
Message-ID: <CA+G9fYvVC8TYk1u-B98MvABqQUuG6hEB6Y7AYd0Qnzs0=-pFUw@mail.gmail.com>
Subject: Re: [PATCH v2] drm/etnaviv: rework perfmon query infrastructure
To:     Lucas Stach <l.stach@pengutronix.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux- stable <stable@vger.kernel.org>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, etnaviv@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 3 Mar 2020 at 17:19, Lucas Stach <l.stach@pengutronix.de> wrote:
>
> On Fr, 2020-02-28 at 11:37 +0100, Christian Gmeiner wrote:
> > Report the correct perfmon domains and signals depending
> > on the supported feature flags.
> >
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Fixes: 9e2c2e273012 ("drm/etnaviv: add infrastructure to query perf counter")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
>
> Thanks, applied to etnaviv/next.
>
> Regards,
> Lucas
>
> >
> > ---
> > Changes V1 -> V2:
> >   - Handle domain == NULL case better to get rid of BUG_ON(..) usage.
> > ---
> >  drivers/gpu/drm/etnaviv/etnaviv_perfmon.c | 59 ++++++++++++++++++++---
> >  1 file changed, 52 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> > index 8adbf2861bff..e6795bafcbb9 100644
> > --- a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> > +++ b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> > @@ -32,6 +32,7 @@ struct etnaviv_pm_domain {
> >  };
> >
> >  struct etnaviv_pm_domain_meta {
> > +     unsigned int feature;
> >       const struct etnaviv_pm_domain *domains;
> >       u32 nr_domains;
> >  };
> > @@ -410,36 +411,78 @@ static const struct etnaviv_pm_domain doms_vg[] = {
> >
> >  static const struct etnaviv_pm_domain_meta doms_meta[] = {
> >       {
> > +             .feature = chipFeatures_PIPE_3D,

make modules failed for arm architecture on stable rc 4.19 branch.

drivers/gpu/drm/etnaviv/etnaviv_perfmon.c:392:14: error:
'chipFeatures_PIPE_3D' undeclared here (not in a function)
   .feature = chipFeatures_PIPE_3D,
              ^~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/etnaviv/etnaviv_perfmon.c:397:14: error:
'chipFeatures_PIPE_2D' undeclared here (not in a function); did you
mean 'chipFeatures_PIPE_3D'?
   .feature = chipFeatures_PIPE_2D,
              ^~~~~~~~~~~~~~~~~~~~
              chipFeatures_PIPE_3D
drivers/gpu/drm/etnaviv/etnaviv_perfmon.c:402:14: error:
'chipFeatures_PIPE_VG' undeclared here (not in a function); did you
mean 'chipFeatures_PIPE_2D'?
   .feature = chipFeatures_PIPE_VG,
              ^~~~~~~~~~~~~~~~~~~~
              chipFeatures_PIPE_2D


ref:
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.19/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/511/consoleText
