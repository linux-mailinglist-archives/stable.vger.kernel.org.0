Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855DF406DD0
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 16:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbhIJO5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 10:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbhIJO5j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 10:57:39 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E83FC061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 07:56:28 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id f65so2083844pfb.10
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 07:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GRcINDlVIY7WvQg4YCekT9GW07u7rNX7Q3Tv6SVeVWA=;
        b=xZTETtfZICMYzNhGYBGXDRJnrQfSGBFH7e+d1+FXObkTQgNXWTKXi6Kr5IlDOHy9jd
         OHNBMagXMmZjeuU2dA9yoL36Xj//2MEcEo9JPJeSwk9fTESfzvw21EsXkwK+d0o+LPYf
         Wdq8O0HouZqVHGiTN7h7awwRUC7GzHXKr2T0lP7Kbm2FMt2NI3VphpbzbUYNYG9HaZMl
         YWJMR1xGit4KRy6t/IktVvCYUdbo7X4KDUNapdlBG0PoQ9I8JpEdkPDI8CPs72eOIoV+
         wEUFD+8NqBk6DK56dNzpLoYtWOLdWQpA9pfERwgUDi2CoUnF4CmdBnwYS+OdBrssKyMu
         XvRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GRcINDlVIY7WvQg4YCekT9GW07u7rNX7Q3Tv6SVeVWA=;
        b=cXdfnnJ6+iNWY+/5hbce3vM2I/o1wY1qU+/YuGc3QEii4S/OBetX5VHK4DmVM41WD2
         3Ma0R3E0+snRlNkT74TQGJ7P2reFUvY9HlN1Kngc7729yfaOsgUtW432cJbAAvNR/7XT
         RsHyeFCjanh/4xu18lj4NdYPrYJXoBkglznYB4cdu+LTW+8gV+pol17f9mOlvkwLxF41
         cLSU7GA2XC+FDAv1I2ECGgEpDV3TwftN7U1VKK5J3s4V3iwEk2095FjNQiBM+/8A5eLX
         G0bkfp8vb5IVBPlf3uTKOTwp5L2+Ul1xDsJo9Jpi0Ly6u2znIASW6Q/Z3I7BQrUn6VBA
         uUDw==
X-Gm-Message-State: AOAM533orClYp+rEO+dxekg1WrKcfMQ1WPkNeljmh+6DDBoQOZJOADjM
        RaqBksG2JIXLE9+RKw7YJadHVapMt00O6peTLvMAUA==
X-Google-Smtp-Source: ABdhPJxS49E7IO0mDp/lByI3jUEd8WbW7c0pAJEaNPt+nU+cq+ZgLY90STb6N1TtMicvnL35QGvBtpEMVX4OZk3+Azw=
X-Received: by 2002:a63:1262:: with SMTP id 34mr7596743pgs.356.1631285787615;
 Fri, 10 Sep 2021 07:56:27 -0700 (PDT)
MIME-Version: 1.0
References: <163072203373.2250120.8373702699578427249.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163072204525.2250120.16615792476976546735.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAHC9VhTNu8E9WkzUHbQC9xKK5U74L8oqetUtPXGX2RSofMcqgw@mail.gmail.com>
 <CAPcyv4gR+WbYf-dT0niT23UY8jZZVBXMk4R-1_0exPcbHrs=0Q@mail.gmail.com>
 <CAHC9VhTo-eV4oUF-ia67X-KK-qyB=M0xDv-=p0-xA-4=0BJ6uA@mail.gmail.com> <CAFqZXNvSu2-nL8YEfKhEdT9csm1=nxecoo31FF+jgwyCVdjPMw@mail.gmail.com>
In-Reply-To: <CAFqZXNvSu2-nL8YEfKhEdT9csm1=nxecoo31FF+jgwyCVdjPMw@mail.gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 10 Sep 2021 07:56:16 -0700
Message-ID: <CAPcyv4iTFXdAdv_G_cf+wE9ZqQia-F-T3RwJDAwuwAJE+PFziA@mail.gmail.com>
Subject: Re: [PATCH 2/6] cxl/pci: Fix lockdown level
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>, linux-cxl@vger.kernel.org,
        Ben Widawsky <ben.widawsky@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        stable <stable@vger.kernel.org>,
        "Schofield, Alison" <alison.schofield@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 10, 2021 at 5:55 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
>
> On Tue, Sep 7, 2021 at 9:47 PM Paul Moore <paul@paul-moore.com> wrote:
> > On Tue, Sep 7, 2021 at 1:39 PM Dan Williams <dan.j.williams@intel.com> wrote:
> > > On Fri, Sep 3, 2021 at 8:57 PM Paul Moore <paul@paul-moore.com> wrote:
> > > >
> > > > On Fri, Sep 3, 2021 at 10:20 PM Dan Williams <dan.j.williams@intel.com> wrote:
> > > > >
> > > > > A proposed rework of security_locked_down() users identified that the
> > > > > cxl_pci driver was passing the wrong lockdown_reason. Update
> > > > > cxl_mem_raw_command_allowed() to fail raw command access when raw pci
> > > > > access is also disabled.
> > > > >
> > > > > Fixes: 13237183c735 ("cxl/mem: Add a "RAW" send command")
> > > > > Cc: Ben Widawsky <ben.widawsky@intel.com>
> > > > > Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > > > > Cc: <stable@vger.kernel.org>
> > > > > Cc: Ondrej Mosnacek <omosnace@redhat.com>
> > > > > Cc: Paul Moore <paul@paul-moore.com>
> > > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > > > ---
> > > > >  drivers/cxl/pci.c |    2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > Hi Dan,
> > > >
> > > > Thanks for fixing this up.  Would you mind if this was included in
> > > > Ondrej's patchset, or would you prefer to merge it via another tree
> > > > (e.g. cxl)?
> > >
> > > I was planning to merge this via the cxl tree for v5.15-rc1.
> >
> > Okay, thanks.
>
> And I can see the patch is now in Linus' tree, so if Paul agrees I'll
> rebase the patch on top of v5.15-rc1 once it's tagged and do one more
> respin. There are a few other minor conflicts and one new
> security_locked_down() call to cover, anyway.
>
> Dan, is it okay if I preserve your Acked-by from the last version?

Sure.

> There will be no other change in the cxl area than rebasing on top of
> this patch.
>
> Thank you for taking care of the fix!

Thanks for the patience as I circled back.
