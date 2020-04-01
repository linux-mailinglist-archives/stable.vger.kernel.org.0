Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86A3619A6E6
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 10:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731680AbgDAINF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 04:13:05 -0400
Received: from mail-vk1-f193.google.com ([209.85.221.193]:45658 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728374AbgDAINF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 04:13:05 -0400
Received: by mail-vk1-f193.google.com with SMTP id b187so6462277vkh.12
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 01:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LPFMo42Q/PXHcJqnmxWdonnTjKMxZmPHnUg4mW3GV8Q=;
        b=Bnbvyf80kCzMy/HzJiHlVkJlzQKeYshm8iMgGwQ8hM59duN97ELzyv0TbEBc1SEjgN
         QkhAn4loCT7gQtaF5RpDDnDBLeGgmKjqOQFiBDKuMRWMef7SF6xWZQMsuwWlQ8xSCLs6
         xXPFDtTtRkF5kXRiNSxXEbvoFpUbhdpXJ9zcYbQo/xKe+BXOiN9621bY6Khb1hyfzOc+
         e84ZZAhuHgYUplle2Km4Lxp94ef2sFGOB7XkX0YnVoXUfUb8rYlCp2K7Lwn5glXi1tJV
         w/v4PNFKWbbkHgFNBvPftHtQ0VG6BGzCCMYuJXS0GcqKo3tmdDulnGgzJxUTFpI6AsbV
         P8sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LPFMo42Q/PXHcJqnmxWdonnTjKMxZmPHnUg4mW3GV8Q=;
        b=HZKTWtt4svhb3GvafOtVEaMUYmY5SXdQ24GCGF2ER8aQ3zvoaYqIuiutIxeLHMyjMx
         LD76G8aJr1wAdmH3uBE6Vh7u62N3l0wY5R56tMMfI5QygFHt0Or7gp/YRe+wbMw00Mtl
         id9yrb8tOUGt2t+fDJ482OnvkRUk62fuz4923g+Gb3pOqwMrm/PE12Dq1J6NKBAgMiqM
         iTSqgk4IfOsOlmVHALEbfmWg6OjCEWn4IduCBT1sehLU/9K+mbQPWmaPp6kcBphvhp+m
         qs2kiVdB7+iMFadwBEPogdol8tbCJQ2S4XUYwvGpGp9tst0o8oqbMHEkpzTM2iWcr+vn
         Q+Kw==
X-Gm-Message-State: AGi0PuZuwD4lQbhOX643vvhHjxwBPA/hi56kzBBGSVsjmXsS9naqVKlI
        GaKZhOAa/oOcnInFXhpEzEJ383+fl6gDDLlUQgGf7A==
X-Google-Smtp-Source: APiQypKFe5utV4KbWflnL3GnASHpwHq41QFH7yJgOHXK1dPyrWQvFBQoBdl24M/ViYq171tyP3noIlN/z99qgp79Tg8=
X-Received: by 2002:a1f:7f1d:: with SMTP id o29mr15266963vki.101.1585728784469;
 Wed, 01 Apr 2020 01:13:04 -0700 (PDT)
MIME-Version: 1.0
References: <158523473532132@kroah.com> <CAPDyKFr0Em0-8RX3TnuRTiEEX6qs3Lu+SxFufmv5Mx6_6606=g@mail.gmail.com>
 <20200401060720.GA1904908@kroah.com>
In-Reply-To: <20200401060720.GA1904908@kroah.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 1 Apr 2020 10:12:28 +0200
Message-ID: <CAPDyKFo2SZKDfv9oGpRXrYi-y26jRVPqDd5Xa4XX+7xVAwo-qg@mail.gmail.com>
Subject: Re: patch "driver core: platform: Initialize dma_parms for platform
 devices" added to char-misc-testing
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ludovic Barre <ludovic.barre@st.com>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 1 Apr 2020 at 08:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Mar 31, 2020 at 08:43:25PM +0200, Ulf Hansson wrote:
> > On Thu, 26 Mar 2020 at 15:58, <gregkh@linuxfoundation.org> wrote:
> > >
> > >
> > > This is a note to let you know that I've just added the patch titled
> > >
> > >     driver core: platform: Initialize dma_parms for platform devices
> > >
> > > to my char-misc git tree which can be found at
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
> > > in the char-misc-testing branch.
> > >
> > > The patch will show up in the next release of the linux-next tree
> > > (usually sometime within the next 24 hours during the week.)
> > >
> > > The patch will be merged to the char-misc-next branch sometime soon,
> > > after it passes testing, and the merge window is open.
> > >
> > > If you have any questions about this process, please let me know.
> >
> > Greg, would you mind dropping this one and the other patch for the amba bus?
> >
> > I just sent out a new version (v2), addressing an issue for the
> > platform device when used for OF based platforms.
> >
> > If you prefer to not rebase/drop patches from your branch, I can send
> > an incremental change on top instead, whatever you prefer.
>
> I will just revert these and then send it all on to Linus later today.
> That way you can have the longer development cycle for better testing.

Alright!

Actually, reverting wasn't really necessary as the patches didn't
break anything, just that v1 did fix the complete range of the
problems.

Kind regards
Uffe
