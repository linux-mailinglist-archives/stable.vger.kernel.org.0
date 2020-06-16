Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C03C1FBC0B
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbgFPQpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728861AbgFPQph (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 12:45:37 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4584C061573
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 09:45:36 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id y11so24426307ljm.9
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 09:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ojS0vDru9fTrq1Mv/1eBqOhqEQ42MWJ21f/Z7mU3Bag=;
        b=X0Z6z8Qf0pIUiViUi7GoTkdAu/GoL17LdIbxdj7hPDG6/pzHcy4ZfCsAQUqGPIIb+R
         qlI0tFRzi2njD5j45wyM9GFqP/49P6TbO1jE+83jK+mcq6uE97iTfdcrmUfw2M7ZsyJl
         GOJmMPzKZsnZNWzM+8SOGmQf5V7YJVKhzn0pnyHJYhkZPT1ahlpDL4v3Jl1neJnfQEPb
         x03S4sJ7M+OM7a5O/nUSI72Z4mIL55zaOGlOuMvB7wMveHCuRMEvD+S7NAh8m6rTh5Qo
         tr0myMeLAXZ93/zAYbIJwLBoiph3IPmoVy28fJkCOxqbruEO+SfEodb7I8DfemQkBp93
         XXEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ojS0vDru9fTrq1Mv/1eBqOhqEQ42MWJ21f/Z7mU3Bag=;
        b=K5DmjuANweW7qcg2LtNRnZWLG9BVzOIXaU7O6EJRE5N2R/MtsGukoKVam+eqt6aYBD
         Ly/pIMrEQWZzdrbZgC7Vi0gZSAtXkbgg45SzC0uXlquLN3tHxYwk9PPxp8fgecXX9ZLg
         CycHpiQfy9PTT8KYd1EpETT+BtGzZqvToTpGjZ+XohxxR+Y0uMxEhCDIJORb3GhiPtl0
         bGzgNU8WZmthSUjUa2y63WNWzo2F+d9sYid1sBxp3vNYhjxrQRxPpb3TkEVfsYXH6+zb
         WOC6un1gDNxYYt6pcjVm1cM5SrkaaKwn03NAY/MegNNT7SLYYRu80Yz2lxCAQ/AuY52l
         mxXw==
X-Gm-Message-State: AOAM531MvffsqrxwcU7Y6l+0KLbjmrQljHYGJcqiNPCSXhFOZ0Ciwh9n
        1REtZudySwz5zvqDsgtALi4SJWvyOF+kSa5WEzsI8A==
X-Google-Smtp-Source: ABdhPJz0Vmkjm7m/UpwwmcCFdLtmiueLtjCsD19/idnQD34/aqQjptQ1VICEmzkJl7xtRbwZqA0PGdMd63qVVvh/ae8=
X-Received: by 2002:a2e:9c91:: with SMTP id x17mr2034241lji.366.1592325934986;
 Tue, 16 Jun 2020 09:45:34 -0700 (PDT)
MIME-Version: 1.0
References: <159065034721114@kroah.com> <CA+G9fYtSmkcCAeKVzUj3B5Yj3ZZw-wiMyQAMwqUOSyiPRB2Byg@mail.gmail.com>
 <20200616071857.GL2428291@smile.fi.intel.com>
In-Reply-To: <20200616071857.GL2428291@smile.fi.intel.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Jun 2020 22:15:23 +0530
Message-ID: <CA+G9fYuQVxt9iP0uUCS1uvzNQ2MROuZ=RbbLW7F0jmuErPdgrw@mail.gmail.com>
Subject: Re: patch "serial: imx: Initialize lock for non-registered console"
 added to tty-next
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Jun 2020 at 12:48, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Tue, Jun 16, 2020 at 11:45:18AM +0530, Naresh Kamboju wrote:
> > On Thu, 28 May 2020 at 12:49, <gregkh@linuxfoundation.org> wrote:
> > >
> > >
> > > This is a note to let you know that I've just added the patch titled
> > >
> > >     serial: imx: Initialize lock for non-registered console
> > >
> > > to my tty git tree which can be found at
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
> > > in the tty-next branch.
> > >
> > > The patch will show up in the next release of the linux-next tree
> > > (usually sometime within the next 24 hours during the week.)
> > >
> > > The patch will also be merged in the next major kernel release
> > > during the merge window.
> > >
> > > If you have any questions about this process, please let me know.
> > >
> > >
> > > From 8f065acec7573672dd15916e31d1e9b2e785566c Mon Sep 17 00:00:00 2001
> > > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > Date: Mon, 25 May 2020 13:59:52 +0300
> > > Subject: serial: imx: Initialize lock for non-registered console
> > >
> > > The commit a3cb39d258ef
> > > ("serial: core: Allow detach and attach serial device for console")
> > > changed a bit logic behind lock initialization since for most of the console
> > > driver it's supposed to have lock already initialized even if console is not
> > > enabled. However, it's not the case for Freescale IMX console.
> > >
> > > Initialize lock explicitly in the ->probe().
> > >
> > > Note, there is still an open question should or shouldn't not this driver
> > > register console properly.
> > >
> > > Fixes: a3cb39d258ef ("serial: core: Allow detach and attach serial device for console")
> > > Reported-by: Guenter Roeck <linux@roeck-us.net>
> > > Cc: stable <stable@vger.kernel.org>
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > Link: https://lore.kernel.org/r/20200525105952.13744-1-andriy.shevchenko@linux.intel.com
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  drivers/tty/serial/imx.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
> > > index 986d902fb7fe..6b078e395931 100644
> > > --- a/drivers/tty/serial/imx.c
> > > +++ b/drivers/tty/serial/imx.c
> > > @@ -2404,6 +2404,9 @@ static int imx_uart_probe(struct platform_device *pdev)
> > >                 }
> > >         }
> > >
> > > +       /* We need to initialize lock even for non-registered console */
> > > +       spin_lock_init(&sport->port.lock);
> >
> > On arm64 Hikey devices running stable-rc 5.7 branch kernel reported following
> > kernel INFO while booting.
>
> Does backporting (applying)
>
> 8508f4cba308 ("serial: amba-pl011: Make sure we initialize the port.lock spinlock")
>
> fix the issue?

Cherry-pick is successful in the stable-rc/linux-5.7.y branch
and the reported problem seems to be fixed.
However,I will test with 100 loop iteration and will confirm again.
---
$ git cherry-pick  8508f4cba30
[stable-rc-linux-5.7.y 4133416ed382] serial: amba-pl011: Make sure we
initialize the port.lock spinlock
 Author: John Stultz <john.stultz@linaro.org>
 Date: Tue Apr 28 18:40:50 2020 +0000
 1 file changed, 1 insertion(+)


- Naresh
