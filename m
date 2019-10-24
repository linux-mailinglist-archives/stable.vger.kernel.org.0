Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA5DE35F1
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 16:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409486AbfJXOtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 10:49:47 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43230 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731880AbfJXOtr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 10:49:47 -0400
Received: by mail-qt1-f194.google.com with SMTP id t20so38228891qtr.10
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 07:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pd8O3Eb7qSMRp9Kj05XZyId359rCorPJtmLFzVCz1tU=;
        b=BcaBLSXmWaHk5110Xo0O38xPCC95AqKidjb+KH5ChdckilUoZbt1WyEwYm1yUOa4RM
         RfiRdAcCfWShMq1AjdO4X2NNxO19cCSlBCF7CR4/hwIxt4Qc9ZpW6S48IFadbBdf17cX
         JALXMDwZp1n9/94SF0EcqIO9snuYmxP7M7P7Uz6YvVLb9xy5N6KEnmIYf6UEPboXYSS4
         atki90J22tNTjqSCVObVMuAnhhzK1cJm0cqovSZ96lgg/WHDuWXptOynmVwTtSpq1U9m
         ZexHeZgG4YVPSYrJr3pZGyq4CSR3sZlmC9nig7ZRz43wPKhTVKpcWL8SFOKxwtxlIzAv
         Hxqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pd8O3Eb7qSMRp9Kj05XZyId359rCorPJtmLFzVCz1tU=;
        b=LB+mu0KPsWEkaLvXYM0LTeFTqDot7ZXkKjOHNSEzGlw7haj+MuSXiLcmcGXqIqBF5A
         eW33Re5+3WZSn4topFsG+oudhQxks5fcrdu/AzxYjV+Wo6xgfcRHcmJh/egTekh/Vhoc
         dLctaC+TGw882197LevipDud8GN4e1Bq27K5FGcut38BsQvIcCXa0Smj2qhRxVx8M7Ld
         EJi/87UhssTsRPZSkI4sQaLipov/FF+ZxItMwNAJPSKy7vDyEC6C4C9gTjxYvYPbPKp0
         a0/w4gOxVCGV4uUcMCCXtQ2B9pbEXmnqNjjjYmYMMq6X7sPu3pfYby1wItdDBqp55MLI
         62CA==
X-Gm-Message-State: APjAAAUkBt7/xdPniJFQoP+nuVDYDi+ZFp5Ri6YLdC6sXmQeunt1FEoY
        sc311SSj0xgQJAIHi7XTauOl8On0ljtIV5bbUNU1XQ==
X-Google-Smtp-Source: APXvYqxizfGeXucr8Xm3hiQaEdwpD1zIkSfhY2uthQgN/hAxrw59HH8nPL+eRe3wXdx0aAtlxBla3csbcsZB0vAO3is=
X-Received: by 2002:a0c:fec3:: with SMTP id z3mr15231985qvs.122.1571928585784;
 Thu, 24 Oct 2019 07:49:45 -0700 (PDT)
MIME-Version: 1.0
References: <20191009114809.8643-1-christian.brauner@ubuntu.com>
 <20191021113327.22365-1-christian.brauner@ubuntu.com> <20191023121603.GA16344@andrea.guest.corp.microsoft.com>
 <CACT4Y+Y86HFnQGHyxv+f32tKDJXnRxmL7jQ3tGxVcksvtK3L7Q@mail.gmail.com>
 <20191024113155.GA7406@andrea.guest.corp.microsoft.com> <CACT4Y+Z2-mm6Qk0cecJdiA5B_VsQ1v8k2z+RWrDQv6dTNFXFog@mail.gmail.com>
 <20191024130502.GA11335@andrea.guest.corp.microsoft.com> <CACT4Y+ahUr11pQQ7=dw80Abj5owUPnPdufbMYvsKLM6iDg5QQg@mail.gmail.com>
 <20191024134319.GA12693@andrea.guest.corp.microsoft.com> <CACT4Y+ZXQyqgBvwgb6cy7NP5FTBbktq5j4ZyySp7jrbcJwFUTA@mail.gmail.com>
 <20191024144049.GA13747@andrea.guest.corp.microsoft.com>
In-Reply-To: <20191024144049.GA13747@andrea.guest.corp.microsoft.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 24 Oct 2019 16:49:33 +0200
Message-ID: <CACT4Y+aCSZmrmGv+=LPfzt0VBD5XqjsvSQ+6LHyr8VQW5tN6xg@mail.gmail.com>
Subject: Re: [PATCH v6] taskstats: fix data-race
To:     Andrea Parri <parri.andrea@gmail.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Will Deacon <will@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bsingharora@gmail.com,
        Marco Elver <elver@google.com>,
        stable <stable@vger.kernel.org>,
        syzbot <syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 4:40 PM Andrea Parri <parri.andrea@gmail.com> wrote:
>
> On Thu, Oct 24, 2019 at 03:58:40PM +0200, Dmitry Vyukov wrote:
> > On Thu, Oct 24, 2019 at 3:43 PM Andrea Parri <parri.andrea@gmail.com> wrote:
> > >
> > > > But why? I think kernel contains lots of such cases and it seems to be
> > > > officially documented by the LKMM:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/memory-model/Documentation/explanation.txt
> > > > address dependencies and ppo
> > >
> > > Well, that same documentation also alerts about some of the pitfalls
> > > developers can incur while relying on dependencies.  I'm sure you're
> > > more than aware of some of the debate surrounding these issues.
> >
> > I thought that LKMM is finally supposed to stop all these
> > centi-threads around subtle details of ordering. And not we finally
> > have it. And it says that using address-dependencies is legal. And you
> > are one of the authors. And now you are arguing here that we better
> > not use it :) Can we have some black/white yes/no for code correctness
> > reflected in LKMM please :) If we are banning address dependencies,
> > don't we need to fix all of rcu uses?
>
> Current limitations of the LKMM are listed in tools/memory-model/README
> (and I myself discussed a number of them at LPC recently); the relevant
> point here seems to be:
>
> 1.      Compiler optimizations are not accurately modeled.  Of course,
>         the use of READ_ONCE() and WRITE_ONCE() limits the compiler's
>         ability to optimize, but under some circumstances it is possible
>         for the compiler to undermine the memory model.  [...]
>
>         Note that this limitation in turn limits LKMM's ability to
>         accurately model address, control, and data dependencies.
>
> A less elegant, but hopefully more effective, way to phrase such point
> is maybe "feel free to rely on dependencies, but then do not blame the
> LKMM authors please".  ;-)

We are not going to blame LKMM authors :)

Acquire will introduce actual hardware barrier on arm/power/etc. Maybe
it does not matter here. But I feel if we start replacing all
load-depends/rcu with acquire, it will be noticeable overhead. So what
do we do in the context of the whole kernel?
