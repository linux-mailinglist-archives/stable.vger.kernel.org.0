Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E2F1A4863
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 18:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgDJQ0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 12:26:30 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:42181 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgDJQ03 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Apr 2020 12:26:29 -0400
Received: by mail-oi1-f196.google.com with SMTP id e4so1787418oig.9
        for <stable@vger.kernel.org>; Fri, 10 Apr 2020 09:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yMpjPxGLH2Lp2A4mAz8ncaxXmDPUVi4Uv45pydJcVpE=;
        b=kuywN1klF3kBcJFwWdJ5ijaZAm+7utN3CT2xbbOKo0hdFunF60vX+2OTdGiWqQDzyB
         /c5UIni7YWWpnEyFGbWYryN+NJkGWUg6axBuEC//gAgOjVcZml1B58XL8q1p2ER5uQar
         hnUs3jKdxIMZjfN0XJIlCMoFVIjlbVAsWNAs/ZIIQDRT9QS5evCuVaHBhwdMGw+73ekN
         c5GV4iy+scAFfCAKFuWKZj1Wwp7iNKk/TmUb1amSqhBMxLZeMUSai++DcBgA5CnAtzEM
         S2jm3GMt7afBQSNUkMPnd+RQ5HMbH2IN0KIXb3tDH4vZTS2ZDh40rJ/GNjI5IJmN68nZ
         KKuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yMpjPxGLH2Lp2A4mAz8ncaxXmDPUVi4Uv45pydJcVpE=;
        b=obZZEBpqyr6n/jOGic73SJD6feu8Dwkpom/qGN0r1nqOO3EUfSIzvk+QsOUD0bdZGY
         XNmHsDGlxmUKOiWe552Kx7ATEaA8OnXvjAXqX4UZlx1K1yLL16/U/rRizbWHakPb8vXp
         M7j8J7FzwUslZsuG3oVDpLPpbaNulsM0VeFrP6eUkmiZkVV/aY2HI9f1ZFAVaSEhY8kk
         SDbzcM1djo24ZkwzY2f3UHkiB6d1WPLmuVqa3AnrPEBU5LNAHhoDVOPVburwblPexMLG
         a2YC9ldtb/UcBCuqOQyanTHwmZCiUgLXA5lBDPAs3P+rGOn8vYSQT0ab7LLKKSNDUCn2
         hXTQ==
X-Gm-Message-State: AGi0PuZlDRDnpwRiL2oC63+YSHqsEBTm/vrsqvtOGGq4/GzTe9TM5ub6
        wVhCF+MPMXzwuPgpKMbRk47+S6YmdriGdoXeHKZA8g==
X-Google-Smtp-Source: APiQypLwu3CIER9GRUCXG/kaBErHqHIU1JKtWh1Oqv6yRwp2XcMnJ2Wqf+F/NUj5ULxwn4dcYERJFvFH0f97UW/gKwI=
X-Received: by 2002:aca:682:: with SMTP id 124mr3967570oig.69.1586535987677;
 Fri, 10 Apr 2020 09:26:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200410034634.7731-1-sashal@kernel.org> <20200410034634.7731-14-sashal@kernel.org>
 <20200410062931.GD1663372@kroah.com> <CAGETcx9Kp6JvuyF770XKsMTCY6=rC2zuBTG07oB18bya0owgWw@mail.gmail.com>
 <20200410065227.GA1665508@kroah.com>
In-Reply-To: <20200410065227.GA1665508@kroah.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Fri, 10 Apr 2020 09:25:51 -0700
Message-ID: <CAGETcx8RBjr6rzR7=m6LuA=OQOT2Hh4ioPndUP8mkpYLve+6yw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.6 14/68] driver core: Reevaluate
 dev->links.need_for_probe as suppliers are added
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 9, 2020 at 11:52 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Apr 09, 2020 at 11:39:55PM -0700, Saravana Kannan wrote:
> > On Thu, Apr 9, 2020 at 11:29 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Apr 09, 2020 at 11:45:39PM -0400, Sasha Levin wrote:
> > > > From: Saravana Kannan <saravanak@google.com>
> > > >
> > > > [ Upstream commit 1745d299af5b373abad08fa29bff0d31dc6aff21 ]
> > > >
> > > > A previous patch 03324507e66c ("driver core: Allow
> > > > fwnode_operations.add_links to differentiate errors") forgot to update
> > > > all call sites to fwnode_operations.add_links. This patch fixes that.
> > > >
> > > > Legend:
> > > > -> Denotes RHS is an optional/potential supplier for LHS
> > > > => Denotes RHS is a mandatory supplier for LHS
> > > >
> > > > Example:
> > > >
> > > > Device A => Device X
> > > > Device A -> Device Y
> > > >
> > > > Before this patch:
> > > > 1. Device A is added.
> > > > 2. Device A is marked as waiting for mandatory suppliers
> > > > 3. Device X is added
> > > > 4. Device A is left marked as waiting for mandatory suppliers
> > > >
> > > > Step 4 is wrong since all mandatory suppliers of Device A have been
> > > > added.
> > > >
> > > > After this patch:
> > > > 1. Device A is added.
> > > > 2. Device A is marked as waiting for mandatory suppliers
> > > > 3. Device X is added
> > > > 4. Device A is no longer considered as waiting for mandatory suppliers
> > > >
> > > > This is the correct behavior.
> > > >
> > > > Fixes: 03324507e66c ("driver core: Allow fwnode_operations.add_links to differentiate errors")
> > > > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > > > Link: https://lore.kernel.org/r/20200222014038.180923-2-saravanak@google.com
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > > >  drivers/base/core.c | 8 ++++++--
> > > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > > > index dbb0f9130f42d..d32a3aefff32f 100644
> > > > --- a/drivers/base/core.c
> > > > +++ b/drivers/base/core.c
> > > > @@ -523,9 +523,13 @@ static void device_link_add_missing_supplier_links(void)
> > > >
> > > >       mutex_lock(&wfs_lock);
> > > >       list_for_each_entry_safe(dev, tmp, &wait_for_suppliers,
> > > > -                              links.needs_suppliers)
> > > > -             if (!fwnode_call_int_op(dev->fwnode, add_links, dev))
> > > > +                              links.needs_suppliers) {
> > > > +             int ret = fwnode_call_int_op(dev->fwnode, add_links, dev);
> > > > +             if (!ret)
> > > >                       list_del_init(&dev->links.needs_suppliers);
> > > > +             else if (ret != -ENODEV)
> > > > +                     dev->links.need_for_probe = false;
> > > > +     }
> > > >       mutex_unlock(&wfs_lock);
> > > >  }
> > >
> > > For some reason this wasn't for stable kernels, but I can't remember.
> >
> > It *is* for stable kernels too. It is an actual bug that's fixable in
> > stable kernels. I think this might have been the one patch that I
> > bundled into an unrelated series, but called it out as an unrelated
> > bug. Maybe my wording in that email threw you off?
>
> I think it did, sorry.  So no problem adding this to the stable trees so
> I can go add it right now?

Yes, please do.

-Saravana
