Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223AA454A78
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 17:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237015AbhKQQI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 11:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238903AbhKQQI0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 11:08:26 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A4CC061570;
        Wed, 17 Nov 2021 08:05:27 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id g14so13445452edz.2;
        Wed, 17 Nov 2021 08:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HcJuavFk/01gq0GKRAkMY7+ZgXIr8DpqwilLF/2rGBY=;
        b=dvGYsbDHhqgDXpJ+RdC3GmU5lVrIVjLV0cecgrDMXWqPCjdf8SVwSoCTQARgQKsMUH
         c7/UqGKDDJKB9uS80y56MzFVdV5O77oz7g7sfgtYgpo5c7LHS4Ihb0HgrP6pVykubmew
         B+jwbn44EkXEBTN7XdZ43b9FzNl5QWO1WO3Ajf8oJt5In3c32DDyKIxTB47M7j8aF/ED
         UtUDjxw01ivtjOzy0qvWNzxTlUNY71+KdtSnCSUYZ9MyGLmwbmTOtY0NSeNMAvnJfB3f
         sr/tXc99E9Ax9A6Nt/wpwTtav9uPDXC1QRkyekTYflwug26eUlqp2K9GlGXKXPxMyHKr
         tg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HcJuavFk/01gq0GKRAkMY7+ZgXIr8DpqwilLF/2rGBY=;
        b=w64dptUTMwQI5/p8kG9PQ15vWfLg5k7XKbFUn3ZbpxVrttplXMPVdixosVdbp3NW00
         B0cK0kCsDVTQPGlQqg5OEIBBESSxILpDoM6JM3savRAfuQutl9f6KO69a4KfqlHU2ijI
         BY0Te8MZvZT5I9uEHHr+VN37KmfUseZ0bNKrdyXH4r+m92m7Ilyox1O4yqtCc/uxLag2
         X4yAYBb15PjC2xRgj0eK/AOUMw3kaJEdEynplZAqrtD0ZhBNIy+/pyB28/YaT5/2ajyv
         E0cTAE4J10ExHs+rxRDEVwiYjYtUnw2VShIy4P3ddbNpuuN6//YX9CnWW24/hdLN0Snp
         /MIA==
X-Gm-Message-State: AOAM531hTWg0IU2paUj/dUNlEyiEcNTqMP+zV8UnQj2CzVFusCld+wrr
        ZLBpdNS/oYLOBDjX4/kr2DgXcjjP2JZzyRAcFfo=
X-Google-Smtp-Source: ABdhPJwLF5u38ZpHNPUlbHGGxI10yFk6qGT+M0wZ5OAYZ17W6+0f0qff2ikd4TwQzB8lLfvk5KccVaLFf7DMdKWgbbk=
X-Received: by 2002:a17:907:94d4:: with SMTP id dn20mr23177741ejc.379.1637165125817;
 Wed, 17 Nov 2021 08:05:25 -0800 (PST)
MIME-Version: 1.0
References: <20211116142631.571909964@linuxfoundation.org> <4ef11d86-28f6-69c8-ed79-926d39bdc13d@gmail.com>
 <CAPOoXdHjqm=9K5BHc8p48NEf0jzZ92yiZZFQwmhGMxcTAX020w@mail.gmail.com> <YZS3gwvOOXu0Vmzv@kroah.com>
In-Reply-To: <YZS3gwvOOXu0Vmzv@kroah.com>
From:   Scott Bruce <smbruce@gmail.com>
Date:   Wed, 17 Nov 2021 08:05:13 -0800
Message-ID: <CAPOoXdEWFWpeFtLkWqOVOZFJv3=7zyG2vrZtrZ9fHsODyPaf+A@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/927] 5.15.3-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

5.16-rc1 boots fine with the commit in, it's just the 5.15.3-rc builds
with it that are giving me trouble.

cheers,
Scott

On Wed, Nov 17, 2021 at 12:04 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Nov 16, 2021 at 09:41:07PM -0800, Scott Bruce wrote:
> > On 11/16/21 13:59, Scott Bruce wrote:
> > > On 11/16/21 07:01, Greg Kroah-Hartman wrote:
> > >> This is the start of the stable review cycle for the 5.15.3 release.
> > >> There are 927 patches in this series, all will be posted as a response
> > >> to this one.  If anyone has any issues with these being applied, please
> > >> let me know.
> > >>
> > >> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> > >> Anything received after that time might be too late.
> > >>
> > >> The whole patch series can be found in one patch at:
> > >>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc2.gz
> > >>
> > >> or in the git tree and branch at:
> > >>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > >> linux-5.15.y
> > >> and the diffstat can be found below.
> > >>
> > >> thanks,
> > >>
> > >> greg k-h
> > >>
> > >
> > > Regression found on x86-64 AMD (ASUS GA503QR, Cezanne platform)
> > > somewhere between 7f9a9d5d9983 and 5.15.3-rc1. The very early -rc1 tag
> > > from a day and a half ago boots fine, -rc1 final and -rc2 boot into a
> > > kernel panic during init.
> > >
> > > Unfortunately I can't gather any useful debug info from the panic as the
> > > relevant bits are instantly pushed off the screen by rest of the dump.
> > >
> > > Here's what I'm left with on screen after the panic, hopefully someone
> > > can get something useful out of it:
> > > https://photos.app.goo.gl/6FrYPfZCY6YdnPDz6
> > >
> > > I'll bisect and try to narrow this down some today but I'm running
> > > builds on my laptop while I work so it won't be super quick.
> > >
> > > Scott
> >
> > Reverting c3fc9d9e8f2dc518a8ce3c77f833a11b47865944 "x86: Fix
> > __get_wchan() for !STACKTRACE" resolves this issue.
> >
> > With this revert in place 5.15.3-rc2 boots successfully with no dmesg
> > regressions on my AMD Cezanne laptop, I'll wait for actual use
> > tomorrow to leave a proper
> > tested by.
>
> This is odd.  Do you see the same issues in 5.16-rc1?  We want this
> commit in here as we "need" bc9bbb81730e ("x86: Fix get_wchan() to
> support the ORC unwinder") because it fixes things that are reported to
> be broken.
>
> thanks,
>
> greg k-h
