Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2AC20B384
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 16:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgFZO03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 10:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgFZO03 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 10:26:29 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868D1C03E979
        for <stable@vger.kernel.org>; Fri, 26 Jun 2020 07:26:28 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id e4so10557146ljn.4
        for <stable@vger.kernel.org>; Fri, 26 Jun 2020 07:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ydXogxGnnDZ2r59m2obuewmfbFqOJqbRjgAf5MjFDpw=;
        b=ibBcboR7ssYzAdzLHTH8SKVutCH12kcnOjYnxbHlABZkDL9Scr/e8Nlfw/cxute79y
         FxtBzevCJhalrZDYbad/bXfKQh/wPSNIgj4cuIoTsZh8xtrRSXfdWf1xVvcG1aLwDVE5
         loRaJIODqwOkDjiJz0YIUDZVrHGvbz2lR/JWWCKbOT+5e/9mrDCPu85f/WA4Fym/duNF
         G7TYJkRL0UND0NG/d/8yPp0a/XBdmuBoUs7Vpx3Fa8n5SY0FZNTkCtUESRyPaQo6451X
         64xNP5M30vYWCyZLyZtTD/mnHWIP1AdLnmX3PcUcS32WFA9AeLxAf6mCY/9svdCFGB8R
         7V3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ydXogxGnnDZ2r59m2obuewmfbFqOJqbRjgAf5MjFDpw=;
        b=UUON7wDKqQirabDo5czvndn7+GtUk4WgUFjbVeoL21nqV3P3QvPt95O6K3dNINbl5W
         Bzh9JZL3JDZDbsyceklrf7+3c7lXdj8AWi2WN81rOPV1Ik9hs6Y+dhM4SlsjmXAipf5w
         tqc/LMAlmP+E4sIaepdRKRgMAQG8vx+fMiT07H1NsVgE93wTHwiMIocPEw/X10bRvNxV
         ak4SaZP6hF8d3rBRM+2eJbTebvWnqIYkwL16pG118hn3ZOk96bGDnbC149sBi1x46846
         uFNp0yOzSuHq5SPYstPNfKDT4ul2xQnhw8g4MLY0DlniUw3qkFI/HHJpVqoSOy48NOd4
         MwFQ==
X-Gm-Message-State: AOAM532H/QQ5d70YKAoiBifZfzC3K8g65n3uCkPzlGiKclICIlOqy64s
        xDgK7+f6Wg2Ai2Cw9aMkJB9yfib2yleN8igDD2pyxxtN9A8=
X-Google-Smtp-Source: ABdhPJxotlV+334Nj6VheKT7myoDGbbmplXVdfjZGb6f7vSrFXO3zyVVSKgECucaT9fiEflUbRZC45YDQrhD5lDiY+Q=
X-Received: by 2002:a2e:9a44:: with SMTP id k4mr1530737ljj.139.1593181585713;
 Fri, 26 Jun 2020 07:26:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200626113558.GA32542@unset.einval.com> <20200626134132.GB4024297@kroah.com>
In-Reply-To: <20200626134132.GB4024297@kroah.com>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 26 Jun 2020 16:25:59 +0200
Message-ID: <CAG48ez3fQroA2Drx3vCUB38=f82Bv0t+MnR6chhH3GM7y-SziQ@mail.gmail.com>
Subject: Re: Repeatable hard lockup running strace testsuite on 4.19.98+ onwards
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Steve McIntyre <steve@einval.com>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>, 963493@bugs.debian.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 26, 2020 at 3:41 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Jun 26, 2020 at 12:35:58PM +0100, Steve McIntyre wrote:
> > I'm the maintainer in Debian for strace. Trying to reproduce
> > https://bugs.debian.org/963462 on my machine (Thinkpad T470), I've
> > found a repeatable hard lockup running the strace testsuite. Each time
> > it seems to have failed in a slightly different place in the testsuite
> > (suggesting it's not one particular syscall test that's triggering the
> > failure). I initially found this using Debian's current Buster kernel
> > (4.19.118+2+deb10u1), then backtracking I found that 4.19.98+1+deb10u1
> > worked fine.
> >
> > I've bisected to find the failure point along the linux-4.19.y stable
> > branch and what I've got to is the following commit:
> >
> > e58f543fc7c0926f31a49619c1a3648e49e8d233 is the first bad commit
> > commit e58f543fc7c0926f31a49619c1a3648e49e8d233
> > Author: Jann Horn <jannh@google.com>
> > Date:   Thu Sep 13 18:12:09 2018 +0200
> >
> >     apparmor: don't try to replace stale label in ptrace access check
> >
> >     [ Upstream commit 1f8266ff58840d698a1e96d2274189de1bdf7969 ]
> >
> >     As a comment above begin_current_label_crit_section() explains,
> >     begin_current_label_crit_section() must run in sleepable context because
> >     when label_is_stale() is true, aa_replace_current_label() runs, which uses
> >     prepare_creds(), which can sleep.
> >     Until now, the ptrace access check (which runs with a task lock held)
> >     violated this rule.
> >
> >     Also add a might_sleep() assertion to begin_current_label_crit_section(),
> >     because asserts are less likely to be ignored than comments.
> >
> >     Fixes: b2d09ae449ced ("apparmor: move ptrace checks to using labels")
> >     Signed-off-by: Jann Horn <jannh@google.com>
> >     Signed-off-by: John Johansen <john.johansen@canonical.com>
> >     Signed-off-by: Sasha Levin <sashal@kernel.org>
> >
> > :040000 040000 ca92f885a38c1747b812116f19de6967084a647e 865a227665e460e159502f21e8a16e6fa590bf50 M security
> >
> > Considering I'm running strace build tests to provoke this bug,
> > finding the failure in a commit talking about ptrace changes does look
> > very suspicious...!
> >
> > Annoyingly, I can't reproduce this on my disparate other machines
> > here, suggesting it's maybe(?) timing related.

Does "hard lockup" mean that the HARDLOCKUP_DETECTOR infrastructure
prints a warning to dmesg? If so, can you share that warning?

If you don't have any way to see console output, and you don't have a
working serial console setup or such, you may want to try re-running
those tests while the kernel is booted with netconsole enabled to log
to a different machine over UDP (see
https://www.kernel.org/doc/Documentation/networking/netconsole.txt).

You may want to try setting the sysctl kernel.sysrq=1 , then when the
system has locked up, press ALT+PRINT+L (to generate stack traces for
all active CPUs from NMI context), and maybe also ALT+PRINT+T and
ALT+PRINT+W (to collect more information about active tasks).

(If you share stack traces from these things with us, it would be
helpful if you could run them through scripts/decode_stacktrace.pl
from the kernel tree first, to add line number information.)


Trying to isolate the problem:

__end_current_label_crit_section and end_current_label_crit_section
are aliases of each other (via #define), so that line change can't
have done anything.

That leaves two possibilities AFAICS:
 - the might_sleep() call by itself is causing issues for one of the
remaining users of begin_current_label_crit_section() (because it
causes preemption to happen more often where it didn't happen on
PREEMPT_VOLUNTARY before, or because it's trying to print a warning
message with the runqueue lock held, or something like that)
 - the lack of "if (aa_replace_current_label(label) == 0)
aa_put_label(label);" in __begin_current_label_crit_section() is
somehow causing issues

You could try to see whether just adding the might_sleep(), or just
replacing the begin_current_label_crit_section() call with
__begin_current_label_crit_section(), triggers the bug.


If you could recompile the kernel with CONFIG_DEBUG_ATOMIC_SLEEP - if
that isn't already set in your kernel config -, that might help track
down the problem, unless it magically makes the problem stop
triggering (which I guess would be conceivable if this indeed is a
race).
