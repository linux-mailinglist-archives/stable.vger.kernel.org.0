Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314023A378D
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 01:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhFJXD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 19:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhFJXD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 19:03:59 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D6FC0617A6
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 16:01:48 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id g142so1619307ybf.9
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 16:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ISgMIsod5G8ygL+wMDpDBYOa0SoO8LXCWRFKeW2i7ps=;
        b=EAaVdN4oMV41AxPZjH7l+EoOIon4Nn8cNB7m0rKPoTzNev6l1j2QZ2oVYMKvvTEaBg
         DyoWJ4DXf/7RGBTYpTLSe2+NvgDb3cd/WLp/Au1vgVeII0zUmor/361uAVaWR3Un63kN
         e1SnW2f3wRch+/aKwhe8KIzspsZiapx8+uuSKDuaqRXXpl79bxF1EZuvQjl9AVAZfMqV
         KhlCM+ImuK7NidTYsEybldgsiaeQd8TaWovxT8ywiTKX4CfF1qzxLCqbTPMWJI/Bx1Z4
         ewV+4FpmdYPtvXZSEqaQKZ5+Wf6U3JckYv43FqFxmGsUTHfYg0D5YFT8IHQGrH4uVbgD
         ngWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ISgMIsod5G8ygL+wMDpDBYOa0SoO8LXCWRFKeW2i7ps=;
        b=RFK6X0IGPzzgNfvsxtiewcR01nB4rZSagWCnHXXezFE6uq1K1x6c6vwIc0rPL6V0dA
         mlceLKBq50miDnfH6zektirJkmkfRsVYe1FlGvu6Sf7hgPOiaFhWdIKF2/zjE1Sg9pRt
         HqNTglpDQ7CWtyvhD2NmIN6HO8bFkMPsMruMb+TKxGbqumxIYeM+p6HFcNL9cai8IMwW
         HLLV2RgdHTHqaTBb+MEOOSUoyNj+kuKVTha9hLZi63evLw/CGTqMwEyZIf/1tNLQZ8R0
         1pAUsouWorRqzL2L1wr5U2M3KdGaynhMAY6Mqac6kD/v++MJADHgZKSVUFDT+y+cM8VS
         g9YA==
X-Gm-Message-State: AOAM532fhYCL8RsyTeJEqYB2yIJlgNFlghf1mnLrSumPErMyRFLAKyWO
        e0cnYhLlccbuH9IznSowlRUK5N3TYZfTM9++jHbuAQ==
X-Google-Smtp-Source: ABdhPJyRUfLS5bW1FKnL1qw7wdbMMm1LxYtRLIGuPjUSbQfYUa6ZN2tQwhboaJtIUDx8pyA4P9k+OQFeVs1JexwZQT8=
X-Received: by 2002:a25:cbc4:: with SMTP id b187mr1638263ybg.466.1623366107795;
 Thu, 10 Jun 2021 16:01:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210603170734.3168284-1-sashal@kernel.org> <20210603170734.3168284-3-sashal@kernel.org>
 <20210606111028.GA20948@wunner.de> <YMJR/FNCwDllHIDG@sashalap>
 <CAGETcx_w8pHs3OXQyVXYWV1CY4qGTWrZ9QNEwz=TL8SLbyq1bA@mail.gmail.com>
 <20210610192608.GA31461@wunner.de> <CAGETcx9xSsBMmxzKzgwkWYTrFbKidxY5ANmCmXsF6LduTMKtbA@mail.gmail.com>
 <20210610222933.GB6120@wunner.de>
In-Reply-To: <20210610222933.GB6120@wunner.de>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 10 Jun 2021 16:01:11 -0700
Message-ID: <CAGETcx8vvN-ATLHtmWLZDsNu0dM5DMxyHxiuq9mD0cRvRD0S3w@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.12 03/43] spi: Fix spi device unregister flow
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Sasha Levin <sashal@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 10, 2021 at 3:29 PM Lukas Wunner <lukas@wunner.de> wrote:
>
> On Thu, Jun 10, 2021 at 12:30:18PM -0700, Saravana Kannan wrote:
> > On Thu, Jun 10, 2021 at 12:26 PM Lukas Wunner <lukas@wunner.de> wrote:
> > >
> > > On Thu, Jun 10, 2021 at 12:22:40PM -0700, Saravana Kannan wrote:
> > > > On Thu, Jun 10, 2021 at 10:55 AM Sasha Levin <sashal@kernel.org> wrote:
> > > > > On Sun, Jun 06, 2021 at 01:10:28PM +0200, Lukas Wunner wrote:
> > > > > >On Thu, Jun 03, 2021 at 01:06:53PM -0400, Sasha Levin wrote:
> > > > > >> From: Saravana Kannan <saravanak@google.com>
> > > > > >>
> > > > > >> [ Upstream commit c7299fea67696db5bd09d924d1f1080d894f92ef ]
> > > > > >
> > > > > >This commit shouldn't be backported to stable by itself, it requires
> > > > > >that the following fixups are applied on top of it:
> > > > > >
> > > > > >* Upstream commit 27e7db56cf3d ("spi: Don't have controller clean up spi
> > > > > >  device before driver unbind")
> > > > > >
> > > > > >* spi.git commit 2ec6f20b33eb ("spi: Cleanup on failure of initial setup")
> > > > > >  https://git.kernel.org/broonie/spi/c/2ec6f20b33eb
> > > > > >
> > > > > >Note that the latter is queued for v5.13, but hasn't landed there yet.
> > > > > >So you probably need to back out c7299fea6769 from the stable queue and
> > > > > >wait for 2ec6f20b33eb to land in upstream.
> > > > > >
> > > > > >Since you've applied c7299fea6769 to v5.12, v5.10, v5.4, v4.14 and v4.19
> > > > > >stable trees, the two fixups listed above need to be backported to all
> > > > > >of them.
> > > > >
> > > > > I took those two patches into 5.12-5.4, but as they needed a more
> > > > > complex backport for 4.14 and 4.19, I've dropped c7299fea67 from those
> > > > > trees.
> > > >
> > > > Sounds good. Also, there was a subsequent "Fixes" for this patch and I
> > > > think another "Fixes" for the "Fixes". So, before picking this up,
> > > > maybe make sure those Fixes patches are pickable too?
> > >
> > > Aren't those the commits I've listed above?  Or did I miss any fixes?
> > > I'm not aware of any others besides these two.
> >
> > Ah, those are the ones. I didn't see them. My bad.
>
> All good.  Sasha says that backporting the fixes is a little more
> involved in the case of 4.14 and 4.19.  Do you consider the issue
> critical enough that it should be addressed in those stable kernels
> as well?  (I assume the issue concerns Android devices, not sure
> in how far those are using 4.14 and 4.19?)

It isn't android specific, but I don't think it's critical for those kernels.

-Saravana
