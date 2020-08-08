Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9690923F74A
	for <lists+stable@lfdr.de>; Sat,  8 Aug 2020 13:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgHHLCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 07:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgHHLCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Aug 2020 07:02:46 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E4DC061756
        for <stable@vger.kernel.org>; Sat,  8 Aug 2020 04:02:45 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id l84so4375961oig.10
        for <stable@vger.kernel.org>; Sat, 08 Aug 2020 04:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L/55pZGPIDLXEhKEN5lU7vD29On+SSemR1MbCPSEFkc=;
        b=Txc9wXgLl4lIVxktcRBgQHAIcyUPV2xOaseTWezQWdDesXAS4oFMs5wT5u529CEsLN
         6InK/JVKbENTe6goOhx+/QhccvQu+9H76ZtQ2UVtMA2+Q5ySxpf7OzB66v3YinESLM90
         9AIisL5hzIuO7GqkpEBJAPvGXGugSd6TKvm2A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L/55pZGPIDLXEhKEN5lU7vD29On+SSemR1MbCPSEFkc=;
        b=aD1jayPowI8lIkjwxcfI+JemLGZKoeU894rAzcvJ5vHMPu/V8CqV09w2tFKPySDMfJ
         cR8vNO1CHbPsSWyS1soTgMMsQJyjmjFKMOjpqFdcS+4WRCcw8jd9HHejjvfKu63NrCKS
         86eml2CG7Ej1Ql5U4fEg2lw7/U5W6qiG2qvzHC3KOfxadLuyVS7hbwK0c7PWGs6OFSUx
         boXk2qL2K/TRhEIW6tZRNJ932lOMreIXeG0077MZ73gjyRG2ZWyoJl+Dwcm1SA2ChptI
         jfpcKXT1GCU8fWEmh1qOQwMBTkyixabXoE3+LitUyDT6Ry59khOZ9qdQXGIwrJpMS12d
         8bzQ==
X-Gm-Message-State: AOAM531z+b711JiAdBVs8E3EnIc19CafR2TLiG2VtTvy/saB1xeJTMAM
        bj2Dzf1iy9OKgmHyrABCvTNBMiBhLRiWLkBGJ+X0eA==
X-Google-Smtp-Source: ABdhPJwRra8AsKT1jx5v2RE8XA39xz63ylAzCehQgRTg4imFh/aya+veG8dUwb5RKzSvLYY5i4OIZGCxsQLKUKjzfCM=
X-Received: by 2002:aca:da03:: with SMTP id r3mr14994183oig.14.1596884565271;
 Sat, 08 Aug 2020 04:02:45 -0700 (PDT)
MIME-Version: 1.0
References: <159680700523135@kroah.com> <a92e73b9-c3da-76f6-9405-b2456fe68ce6@suse.de>
 <CAKMK7uFJVzm1avAOZd0kPAzRUQkTQv3LtrjafjpjXh4K8TaAHg@mail.gmail.com> <20200808102512.GA3039253@kroah.com>
In-Reply-To: <20200808102512.GA3039253@kroah.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Sat, 8 Aug 2020 13:02:34 +0200
Message-ID: <CAKMK7uF2zeOS714mq2Y29TgjLB7h3A51FhKs70YL+kK84DCyRQ@mail.gmail.com>
Subject: Re: WTF: patch "[PATCH] drm/mgag200: Remove declaration of
 mgag200_mmap() from header" was seriously submitted to be applied to the
 5.8-stable tree?
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>, armijn@tjaldur.nl,
        Emil Velikov <emil.velikov@collabora.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        =?UTF-8?Q?Noralf_Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 8, 2020 at 12:24 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sat, Aug 08, 2020 at 11:13:54AM +0200, Daniel Vetter wrote:
> > On Fri, Aug 7, 2020 at 3:54 PM Thomas Zimmermann <tzimmermann@suse.de> wrote:
> > >
> > > Hi
> > >
> > > Am 07.08.20 um 15:30 schrieb gregkh@linuxfoundation.org:
> > > > The patch below was submitted to be applied to the 5.8-stable tree.
> > > >
> > > > I fail to see how this patch meets the stable kernel rules as found at
> > > > Documentation/process/stable-kernel-rules.rst.
> > > >
> > > > I could be totally wrong, and if so, please respond to
> > > > <stable@vger.kernel.org> and let me know why this patch should be
> > > > applied.  Otherwise, it is now dropped from my patch queues, never to be
> > > > seen again.
> > >
> > > Sorry for the noise. There's no reason this should go into stable.
> >
> > We have a little script in our maintainer toolbox for bugfixes, which
> > generates the Fixes: line, adds everyone from the original commit to
> > the cc: list and also adds Cc: stable if that sha1 the patch fixes is
> > in a release already.
> >
> > I guess we trained people a bit too much on using Fixes: tags like
> > that with the tooling, since they often do that for checkpatch stuff
> > and spelling fixes like this here too. I think the autoselect bot also
> > loves Fixes: tags a bit too much for its own good.
> >
> > Not sure what to do, since telling people to "please sprinkle less
> > Fixes: tags" doesn't sound great either. I also don't want to tell
> > people to use the maintainer toolbox less, the autogenerated cc: list
> > is generally the right thing to do. Maybe best if the stable team
> > catches the obvious ones before adding them to the stable queue, if
> > you're ok with that Greg?
>
> As I think this is the first time that I've had this problem for a DRM
> submission, I don't think it's a big issue yet at all, so whatever you
> are doing today is fine.
>
> I do think that the number of patches submitted for stable for
> drm-related issues feels very very low given the rate of change and
> number of overall patches you all submit to the kernel, so if anything,
> you all should be increasing the number of times you tag stuff for
> stable, not reducing it :)

Ok, sounds like we should encourage people to use the Fixes: tag and
auto-cc tooling more, not less.

I also crunched some quick numbers:
commits with cc: stable in drm/amd: 2.6%
... in drm/i915: 2.5%
... drm overall: 2.3%
drivers/ overall: 3.1%

So from a quick look no big outliers at least, maybe not quite enough
cc: stable from smaller drivers (i915+amd is about 60% of everything
in drm). This is for the past year. Compared to drivers/ overall a bit
lower, but not drastically so. At least if I didn't screw up my
scripting.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
