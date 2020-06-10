Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0BD1F55E2
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 15:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbgFJNea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 09:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbgFJNe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 09:34:29 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AC1C03E96B
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 06:34:27 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id v13so1703438otp.4
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 06:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KR2Z0uMZikclqC7v+FOinXbfrshilDx4BriE2vaMAm0=;
        b=nkY8b5pZlzyS6NlKWPMAvPG/f7NASNXkoB4SqFMn0oDUZ1RN/ZSwGGagvbB/K2WLL8
         /Wz86bnjaP061O4rPeuRiXCJZ9WW51ljPMc0DqIhB6X3q1HlPdJgaH7vUiXr53Ma0Dah
         pPpXinz+P6ybjsTYmM66X2iGYDnudFcN9XuHg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KR2Z0uMZikclqC7v+FOinXbfrshilDx4BriE2vaMAm0=;
        b=AVhD00b6rBMDwU2QuUyBkmN0Qx4H6I7Qy/BcufgO8uCx8AP5/NHsSbqGsP3gNBUoXi
         tXmr7wqUW93c2y76iILQ37dNbBTBdIQsc3n9gzNu1HqlHDjj6V3YUi6BYpHnr1cB6PR0
         5eLWkDaeGbzKKdqxY62mPom3Uw26zAaHsyCvp0HXlY9lgTdK2lCPu5UvHrY/bL35Eo17
         kmTG57fBl7xruGQb613rUurQahevy9mcuqce25Y2QDRydx3+O1oXMMzdbjWeHRhVl+N0
         hPoaonsQSSc3pUQsGFpDY2SDQZDgksMZoL0YUorNoGaA8fux0HJCuLg7YUnh3RZ1EBGb
         4KVw==
X-Gm-Message-State: AOAM531gnSAWWsMHWJuX1x3CS2YZx4vXIgBKFz56vSGcBtC0WPqSRwf+
        q16zSInyikGh9lTIYT9j691I/wP3pKD7t+gXBmJ3jASk
X-Google-Smtp-Source: ABdhPJwLC+z5cTs57NeQPmyYyOdiy+r6meK8ToY4TxEYnVBjd33+BHAfFy7n6J0qBv+2aN/B3od7fau9z1UQYCZ3Cqg=
X-Received: by 2002:a9d:7751:: with SMTP id t17mr2792626otl.334.1591796067200;
 Wed, 10 Jun 2020 06:34:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200521144841.7074-1-lmb@cloudflare.com> <20200522000934.GM33628@sasha-vm>
 <CACAyw9-FH7e5fXAU923xSN9ENtyBo+FkqHnd7WAbpyhnz=X9MA@mail.gmail.com>
 <20200610114956.GA1896587@kroah.com> <CACAyw98w=hQX+ZKc-wdGfUN_XmvrRJJ9y=1TB5=XuYSgUUnffA@mail.gmail.com>
 <20200610122413.GA1900758@kroah.com>
In-Reply-To: <20200610122413.GA1900758@kroah.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 10 Jun 2020 14:34:16 +0100
Message-ID: <CACAyw99_zMbHJ1Rzs_r7hHm7D10SBt1nkqWW1MUP9khEHqC2Nw@mail.gmail.com>
Subject: Re: [PATCH 4.19.y] selftests: bpf: fix use of undeclared RET_IF macro
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>,
        kernel test robot <rong.a.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Jun 2020 at 13:24, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jun 10, 2020 at 01:10:14PM +0100, Lorenz Bauer wrote:
> > On Wed, 10 Jun 2020 at 12:50, Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Wed, Jun 10, 2020 at 11:16:16AM +0100, Lorenz Bauer wrote:
> > > > On Fri, 22 May 2020 at 01:09, Sasha Levin <sashal@kernel.org> wrote:
> > > > >
> > > > > On Thu, May 21, 2020 at 03:48:41PM +0100, Lorenz Bauer wrote:
> > > > > >commit 634efb750435 ("selftests: bpf: Reset global state between
> > > > > >reuseport test runs") uses a macro RET_IF which doesn't exist in
> > > > > >the v4.19 tree. It is defined as follows:
> > > > > >
> > > > > >        #define RET_IF(condition, tag, format...) ({
> > > > > >                if (CHECK_FAIL(condition)) {
> > > > > >                        printf(tag " " format);
> > > > > >                        return;
> > > > > >                }
> > > > > >        })
> > > > > >
> > > > > >CHECK_FAIL in turn is defined as:
> > > > > >
> > > > > >        #define CHECK_FAIL(condition) ({
> > > > > >                int __ret = !!(condition);
> > > > > >                int __save_errno = errno;
> > > > > >                if (__ret) {
> > > > > >                        test__fail();
> > > > > >                        fprintf(stdout, "%s:FAIL:%d\n", __func__, __LINE__);
> > > > > >                }
> > > > > >                errno = __save_errno;
> > > > > >                __ret;
> > > > > >        })
> > > > > >
> > > > > >Replace occurences of RET_IF with CHECK. This will abort the test binary
> > > > > >if clearing the intermediate state fails.
> > > > > >
> > > > > >Fixes: 634efb750435 ("selftests: bpf: Reset global state between reuseport test runs")
> > > > > >Reported-by: kernel test robot <rong.a.chen@intel.com>
> > > > > >Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > > > >
> > > > > Thanks for the backport Lorenz. We'll need to wait for it to make it
> > > > > into Linus's tree before queueing up for the stable trees.
> > > >
> > > > Apologies for sending the patch too early (?), I'm still new to this process.
> > > > I've just hit this on 4.19.127. Do you want me to re-submit the patch somewhere?
> > >
> > > Is this patch in Linus's tree yet?  If so, just tell us the git commit
> > > id.  If not, it needs to go there first before we can take it to any
> > > stable tree.
> >
> > The patch isn't in Linus' tree because the problem doesn't exist
> > there. It fixes a build problem on
> > v4.19 which was introduced by the backport of an earlier fix of mine,
> > commit 634efb750435
> > ("selftests: bpf: Reset global state between reuseport test runs").
> >
> > There is a similar fix from Andrii Nakryiko that went into 5.4 as
> > commit aee43146cc10
> > ("selftest/bpf: fix backported test_select_reuseport selftest
> > changes"), which I hadn't seen
> > at the time.
>
> Ah, ok, that wasn't very obvious, sorry.  I'll queue this up after the
> next round of kernels are released in a day or so...

No, it was my bad. What can I do to avoid this next time?
I've tried to follow the -stable FAQ, but that didn't work as you
can see ;)

Lorenz

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
