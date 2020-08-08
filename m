Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0820B23F80A
	for <lists+stable@lfdr.de>; Sat,  8 Aug 2020 17:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgHHPZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 11:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbgHHPZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Aug 2020 11:25:06 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8FEC061756
        for <stable@vger.kernel.org>; Sat,  8 Aug 2020 08:25:06 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id h16so3941978oti.7
        for <stable@vger.kernel.org>; Sat, 08 Aug 2020 08:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yrzy+JsBJ0EGnxyVed9IcWy040CRV7UWXCXtzolHvWE=;
        b=RgX+TPj8G+wiUGjYdNqs9iNtNoGZxaMb3nNOKlcOZ5HuGC6OeiIIOV1glNKkWHkf5n
         XAJbsp6NY3+lumfUUACsZyyG3cp3ulidw8FtiibtS7MYhV12P9syIKIq3BJhdDwJuIC3
         mgL+QtPFLbbjddn42N+mrW8Q8ODfTh4hIrhy0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yrzy+JsBJ0EGnxyVed9IcWy040CRV7UWXCXtzolHvWE=;
        b=BdXgldzjl4rPFNGzFEVN94JmTi2nwvLMQPrtjFNaRUyKTjlWjriWerFtjwhMdm3P0j
         InmeEHiI4Tv1cyCi2pcc/UBQO46pSXjPuN4OglM+fgdXaVbVJyOmBSz0omCTFH3ackz2
         +NYGjU86FOZYC0QTlS0jV/EwdoDFStkXboBht5NX3XvFCPDFxMDYxhasMya4EFS8FiOf
         P8npJAGmuWCqje55RAKQfZh9fxWX1/pqdrlA/eTdRJ58bcZe09VhYQXVf2KRivfCFqyK
         ky7HMXdSbdYC7Q5E/bWmV1O74ColWqyh4njlOWsTnGrwaAxDQ0emIM8uEIJorTEyXX+n
         VJnQ==
X-Gm-Message-State: AOAM532NxOs4Da21qOa8x/UgbLxvhw6Bs3/K8LF8AMA8R0GvH0BtIHkj
        XKhNpU/7c6jyPgDix9EEYPv+HsWcxegLYHbWsjCq4w==
X-Google-Smtp-Source: ABdhPJyNi+AcjHkhM/4cX7gxxdeO4yF4kEtw/u2Zp6FOhIQlQmVmEXfAegn6YxYmU8p8fClfAxubJiffUhhTc+QXhm4=
X-Received: by 2002:a9d:f29:: with SMTP id 38mr17444971ott.281.1596900305490;
 Sat, 08 Aug 2020 08:25:05 -0700 (PDT)
MIME-Version: 1.0
References: <159680700523135@kroah.com> <a92e73b9-c3da-76f6-9405-b2456fe68ce6@suse.de>
 <CAKMK7uFJVzm1avAOZd0kPAzRUQkTQv3LtrjafjpjXh4K8TaAHg@mail.gmail.com>
 <20200808102512.GA3039253@kroah.com> <CAKMK7uF2zeOS714mq2Y29TgjLB7h3A51FhKs70YL+kK84DCyRQ@mail.gmail.com>
 <20200808112908.GA3063898@kroah.com>
In-Reply-To: <20200808112908.GA3063898@kroah.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Sat, 8 Aug 2020 17:24:53 +0200
Message-ID: <CAKMK7uG=JBvmkAAN_Jq-N96zO-Xp5WwN9fQJqRdaxbRqus13ow@mail.gmail.com>
Subject: Re: WTF: patch "[PATCH] drm/mgag200: Remove declaration of
 mgag200_mmap() from header" was seriously submitted to be applied to the
 5.8-stable tree?
To:     Greg KH <gregkh@linuxfoundation.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        "Nikula, Jani" <jani.nikula@linux.intel.com>
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

On Sat, Aug 8, 2020 at 1:28 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sat, Aug 08, 2020 at 01:02:34PM +0200, Daniel Vetter wrote:
> > On Sat, Aug 8, 2020 at 12:24 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Sat, Aug 08, 2020 at 11:13:54AM +0200, Daniel Vetter wrote:
> > > > On Fri, Aug 7, 2020 at 3:54 PM Thomas Zimmermann <tzimmermann@suse.de> wrote:
> > > > >
> > > > > Hi
> > > > >
> > > > > Am 07.08.20 um 15:30 schrieb gregkh@linuxfoundation.org:
> > > > > > The patch below was submitted to be applied to the 5.8-stable tree.
> > > > > >
> > > > > > I fail to see how this patch meets the stable kernel rules as found at
> > > > > > Documentation/process/stable-kernel-rules.rst.
> > > > > >
> > > > > > I could be totally wrong, and if so, please respond to
> > > > > > <stable@vger.kernel.org> and let me know why this patch should be
> > > > > > applied.  Otherwise, it is now dropped from my patch queues, never to be
> > > > > > seen again.
> > > > >
> > > > > Sorry for the noise. There's no reason this should go into stable.
> > > >
> > > > We have a little script in our maintainer toolbox for bugfixes, which
> > > > generates the Fixes: line, adds everyone from the original commit to
> > > > the cc: list and also adds Cc: stable if that sha1 the patch fixes is
> > > > in a release already.
> > > >
> > > > I guess we trained people a bit too much on using Fixes: tags like
> > > > that with the tooling, since they often do that for checkpatch stuff
> > > > and spelling fixes like this here too. I think the autoselect bot also
> > > > loves Fixes: tags a bit too much for its own good.
> > > >
> > > > Not sure what to do, since telling people to "please sprinkle less
> > > > Fixes: tags" doesn't sound great either. I also don't want to tell
> > > > people to use the maintainer toolbox less, the autogenerated cc: list
> > > > is generally the right thing to do. Maybe best if the stable team
> > > > catches the obvious ones before adding them to the stable queue, if
> > > > you're ok with that Greg?
> > >
> > > As I think this is the first time that I've had this problem for a DRM
> > > submission, I don't think it's a big issue yet at all, so whatever you
> > > are doing today is fine.
> > >
> > > I do think that the number of patches submitted for stable for
> > > drm-related issues feels very very low given the rate of change and
> > > number of overall patches you all submit to the kernel, so if anything,
> > > you all should be increasing the number of times you tag stuff for
> > > stable, not reducing it :)
> >
> > Ok, sounds like we should encourage people to use the Fixes: tag and
> > auto-cc tooling more, not less.
> >
> > I also crunched some quick numbers:
> > commits with cc: stable in drm/amd: 2.6%
> > ... in drm/i915: 2.5%
> > ... drm overall: 2.3%
> > drivers/ overall: 3.1%
> >
> > So from a quick look no big outliers at least, maybe not quite enough
> > cc: stable from smaller drivers (i915+amd is about 60% of everything
> > in drm). This is for the past year. Compared to drivers/ overall a bit
> > lower, but not drastically so. At least if I didn't screw up my
> > scripting.
>
> Seems about right, so on those averages, you have missed about 40-50
> patches that should have been cc:ed stable.
>
> However, you are comparing yourself against stuff like drivers/net/
> which shouldn't have cc: stable for most stuff (as per the networking
> workflow), and other subsystems that seem to never want to cc: stable
> for various reasons (offenders not mentioned to be nice...)
>
> So let's bump that number up a bit, maybe you are missing 100 patches
> this past year that should have been backported?
>
> Feels like you all could tag more, even if the number is only 40-50 :)
>
> Oh wait, are you sure you don't count the horrid "double commits" where
> you backport something from your development branch to your "for linus"
> branch, and have cc: stable on both, so that during the -rc1 merge
> window I see a ton of commits that are already in the tree?  That would
> inflate your numbers a lot more so your real percentages might be a lot
> lower...
>
> fun with math.

Even drivers/net has like 1.0% cc: stable or so, but yeah maybe a
third cc: stable might be missing overall in drm. The math aint more
accurate no matter what, but agrees with your "about 100 patches".

And yeah I didn't take out the cherry-picked ones. Trying to grep for
those (yay more fun with math) says there's 37 stable commits I
double-counted, leaving 1.4% left over for drm/i915. That seems indeed
a bit too low :-/

I guess time to add intel maintainers (kinda not my direct business anymore).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
