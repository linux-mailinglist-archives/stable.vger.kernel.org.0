Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7793B2C12
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 12:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhFXKHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 06:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbhFXKHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 06:07:20 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C943C061574;
        Thu, 24 Jun 2021 03:04:56 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y13so2688118plc.8;
        Thu, 24 Jun 2021 03:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u7fPDE7LS6LL4lJCgFRVnUdJTM9D+3lnAYDmthQFD0o=;
        b=WX6vLCad8z3+5opUAFaXnP6l1Df7woOtV0OS8fh/DXdYYvFkAQj6aD75E5TXZFuiQc
         V7Sd25aIg+Ahe2xmXX9+7AWqIRpQnwPqftP2WUcHiaCqGq3I1/qM78UO4vaOZgX4i7v7
         Go83omeoaJPqYZ2Ygt1vlf3OMoNEH0ssoDj4JbT4Y4PMMUslJfPMVmcvpzdhJSCxQ++d
         +WFnC08cvIBPdl+PHUvlbPSyQbnTK+MJBPkRtvaHJKJXW6a/avqX9Q2qMuG0yAOD0Nlw
         usazRK1PMI3yA6GStVE9RTsmw9jqA/CUoVQbVatoVNBkZQygnHGOxXDNJdfvSUGAtzug
         ZlJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u7fPDE7LS6LL4lJCgFRVnUdJTM9D+3lnAYDmthQFD0o=;
        b=d/+2HKxZsEcWe9EpBOFLyCsVH6aKsLFAdcgtbd3t2/dAb68Kf5FB+PZ7dphrKH3Lxm
         kIzacxb49DgRbtq/2+3QuGtleakZwQ7v/Sa3Tyu11Fms+2w39kMcDOacw0Slzut8CCyy
         DJDIcnti0JN7MoiEShuLFPd8FLuXyabw3hs1c8Rx4kWN4XelQ0bEalvyz1ueTfp84i+r
         0yTx/1fZAwHKFXLIWF4Ktag6BTgR3ujUleTCbMTnzRd2c5/9GHgIR4ePpqxAjimgeR/x
         SlLsmHjDM4haPxP3RGQas6wB/uZkNK7EI0175AXgV4rRtvArrXJg1OR/W90vN7C8zbdH
         tiuw==
X-Gm-Message-State: AOAM5327Fe468wEPwdWErtyAj82pdqK7+vOYigk8gWQhjGPlL31a0mL3
        bonY3O4wstCNqZIEal6ysIssaxxod+xJvRo+UTw=
X-Google-Smtp-Source: ABdhPJxDN/nCwpF1k5jpxywlWf3ktR2tQ8glFj6UCpUsjRGUrF7+L+T6ZOewfYc66uNinW5gLm+qnPHjz81UPa9oAwc=
X-Received: by 2002:a17:902:fe0a:b029:11d:81c9:3adf with SMTP id
 g10-20020a170902fe0ab029011d81c93adfmr3669404plj.0.1624529095960; Thu, 24 Jun
 2021 03:04:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210520092131.308959589@linuxfoundation.org> <20210520092145.369052506@linuxfoundation.org>
 <20210520203625.GA6187@amd> <YKc4wSgWcnGh3Bbq@kroah.com> <YKc47AGJRaBn3qIQ@kroah.com>
 <20210623202529.GG8540@amd>
In-Reply-To: <20210623202529.GG8540@amd>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 24 Jun 2021 13:04:18 +0300
Message-ID: <CAHp75VdsYVcPfgLUy5Gu=Q8t9zKyJ_=Ut0-__5WnxCjDhZQ-kA@mail.gmail.com>
Subject: Re: [PATCH 4.19 425/425] scripts: switch explicitly to Python 3
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 23, 2021 at 11:28 PM Pavel Machek <pavel@ucw.cz> wrote:
> On Fri 2021-05-21 06:37:00, Greg Kroah-Hartman wrote:
> > On Fri, May 21, 2021 at 06:36:18AM +0200, Greg Kroah-Hartman wrote:
> > > On Thu, May 20, 2021 at 10:36:26PM +0200, Pavel Machek wrote:

...

> > > > Old distributions may not have python3 installed, and we should not
> > > > change this dependency in the middle of the series.
> > >
> > > What distro that was released in 2017 (the year 4.14.0 was released) did
> > > not have python3 on it?
> >
> > oops, I meant 2018, when 4.19.0 was out, wrong tree...
>
> In anything yocto-based, for example, you explicitely select which
> packages you want. And changing dependencies in middle of stable
> release is surprising and against our documentation.

How is this all relevant?

Scripts where the interpreter changed are not supposed to be used
outside of the (kernel) development process. No user should really
rely on those scripts to produce anything at any point of time or even
be there.

-- 
With Best Regards,
Andy Shevchenko
