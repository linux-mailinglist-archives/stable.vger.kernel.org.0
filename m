Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD242743E2
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 16:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgIVOOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 10:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbgIVOOY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 10:14:24 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1804FC061755
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 07:14:24 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id q9so3513749wmj.2
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 07:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fooishbar-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=09aMBDkPJux1mOBtGcc/fyhx1X6XV4+R4LwQfh2kMPU=;
        b=B5np/HrBFPNZ/G2O3WjCvtixGWYcqMjEluiig3iewAlWg+Cfa8cziRu6OHmTKT4ECW
         gNBrlaVJmxR0amUAv2BAmoVTdkDo/f/QdzbVJhcZTUB7+GUvJvwIJoN0NAqizyZ0VKvW
         1Cb5nc+lR1kWQscJ1Y/4LGB0wDCJzhnAE8NXh277COKJ8yqFnpAbgyoJ2d+yjkWHed3j
         NRQdFtldSUlTR70rPny/jSF/PZ1MIklMPOj0jg+eM4Ey1HbZwt+vHb8ajj7U0LlisjLD
         CQ7Vt0/9jxVSDovZnZb0BgMBMz4V0CdsSsl/HbqHsC59IoDzQ6032Hlrxkk5ghEb0g/b
         3M5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=09aMBDkPJux1mOBtGcc/fyhx1X6XV4+R4LwQfh2kMPU=;
        b=IhkI9mC2o0JuFNeqR0QD9d/3CUbMy2ZpSnzYU4T6rUrC06TgtoJbncpmubJUZIYDkF
         PL8YTFlb0pF+QlGFIMYKV2wb7M2D4qSkPH9hYu6nxZwD6rPmJADZ8PKhqko6cD92mvcc
         iu4eyCPWV2y8UXMvzWgVx1nXkMJae/q80Vm1pvno5aFr4z96hk2EdeiBn4ubQgM0YovF
         SUIlbIVvk8DsUkFBxA4Vu6ZmabgV8pkPzKxhyGislS1e0CWxyD8Zwm0TquB+WUZJBrQz
         zsHSyNun38ib3vsPpeXS26dnFlDeBK+m1xHDQO9/eTALga2IwqQ/USHh23xaZpp903Ew
         XYeg==
X-Gm-Message-State: AOAM5303muK3KCiA4tRZGa8gWrqR4RmQxmfJDd4R38LCzHBRIlB0jIIL
        /AklFnPm+xeEW9JoUZFZ8QvILKwF0WK21QXmlYT9AeDRg0Y=
X-Google-Smtp-Source: ABdhPJyRiNmKIR+ib/A/iCuGpj88zEWajj+OMCgabJvnHMLyXhDDYeenoXnXVC6GmPgUV0l3AKahFTpQsIFvPdot2XA=
X-Received: by 2002:a7b:c241:: with SMTP id b1mr1275471wmj.98.1600784062650;
 Tue, 22 Sep 2020 07:14:22 -0700 (PDT)
MIME-Version: 1.0
References: <20180705101043.4883-1-daniel.vetter@ffwll.ch> <20180705102121.5091-1-daniel.vetter@ffwll.ch>
 <CAPj87rN48S8+pLd0ksOX4pdCTqtO=bDgjhkPxpWr_AnpVvgaSQ@mail.gmail.com>
 <20200922133636.GA2369@xpredator> <CAKMK7uHCeFan4+agMn0sr-z9UDyZwEJv0_dL-K-gA1n0=m+A2w@mail.gmail.com>
In-Reply-To: <CAKMK7uHCeFan4+agMn0sr-z9UDyZwEJv0_dL-K-gA1n0=m+A2w@mail.gmail.com>
From:   Daniel Stone <daniel@fooishbar.org>
Date:   Tue, 22 Sep 2020 15:14:11 +0100
Message-ID: <CAPj87rNLzFjn7xyePmEBEY8teL7TnL-HrQHXbp7C1tXDdWgeUA@mail.gmail.com>
Subject: Re: [PATCH] drm: avoid spurious EBUSY due to nonblocking atomic modesets
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Marius Vlad <marius.vlad@collabora.com>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 22 Sep 2020 at 15:04, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Tue, Sep 22, 2020 at 3:36 PM Marius Vlad <marius.vlad@collabora.com> wrote:
> > Gentle ping. I've tried out Linus's master tree and, and like Pekka,
> > I've noticed this isn't integrated/added.
>
> Defacto the uapi we have now is that userspace needs to ignore "spurious" EBUSY.

This really, really, really, bites.

I think we need a guarantee that this never happens if ALLOW_MODESET
is always used in blocking mode, plus in future a cap we can use to
detect that we won't be getting spurious EBUSY events.

I really don't want to ever paper over this, because it's one of the
clearest indications that userspace has its timing/signalling wrong.

Cheers,
Daniel
