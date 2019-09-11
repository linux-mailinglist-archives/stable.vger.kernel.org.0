Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4F6AF4B8
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 05:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfIKDjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 23:39:45 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38154 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfIKDjp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 23:39:45 -0400
Received: by mail-lj1-f194.google.com with SMTP id y23so18182923ljn.5
        for <stable@vger.kernel.org>; Tue, 10 Sep 2019 20:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X6BmCCTqaeiKHBEU2GPvfLm5B6qb+rh7y5TGC07UvGc=;
        b=C2geYC9rtLL8dmbIZEBWbm3xjz9k6i+yIDHM1XIdxCITtiVxhLCl6R2nZChWyynJEL
         Ry4edkMKUde/ELMFU6ZbBMZGEmeZCAQgw5GKCdg+wDWPqKe4cH1fp9Qn1zmxHw2z3gZc
         JYO93qwAObcUrmPQlrK8CQxXWoMPjLZFODuAfXs7uUlf7NTBHeK84hPxtiqkQdU/7Cyp
         dUnIx6fvJYPNDrrNiOOSF4qpTYT2rM4mgJ3GhQ4N3oGWMPgFN4WcRKCGAypdLt8Xg6JN
         P00OEqThepdj6oSpht5HP36Wl2e/Xkdu33sDC7wrz47M1LcMdF8qFGw2oZ7iF2hK5EHo
         KPpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X6BmCCTqaeiKHBEU2GPvfLm5B6qb+rh7y5TGC07UvGc=;
        b=iNsqThDn63wuesQLwKwsAQZL9edL6igRj16/+nY6HYjgCzB7wJdPI6b46oXkyzCIOT
         ej7RBXf+mU29zr6lkUWqGmJNwMw8kOu6Fu6gBt4TodUJAZklso0CafzxNtOYJAxPUoHR
         5NhLM2eBH1Sd4SbaXNdFuRI7mUpT3TexkHVAHGh+5NCSJ8PJbQHfgkkKrJrieJPHDxs8
         Nuu7jJ30IpHTbPaKHicEymmrNQhw9oyBhpnZAsqIW9YOTe/8Pbc4BcqlgEAGH8JKUfJA
         PtCMXwI4c95OBkst4BC9g6fMA8y7ARTdpJLhlY77jb4J6pcUaxq6ornuMg94PnvSi/u0
         Vnnw==
X-Gm-Message-State: APjAAAV65t9mLhQpx9eskHEGzOkA5GyO46YNdl2CLU/EJ/Ff8oL2ZxQc
        I7S90zKk9kMHAVOMLM8z1YO+CRIFSt+jBGiRgN6HaQ==
X-Google-Smtp-Source: APXvYqztK0KSkN6OzOo8bybg+rMbotRq/X+CPb2nZ9FGXiJ/z/JEDFNgeXUBAuv5NCnly7PyJ/J3RfL57jZTG7ltO1E=
X-Received: by 2002:a2e:9705:: with SMTP id r5mr3781953lji.13.1568173182977;
 Tue, 10 Sep 2019 20:39:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1567649728.git.baolin.wang@linaro.org> <7d3d221015cd343df47de4a68ed4776aca2ca0ab.1567649729.git.baolin.wang@linaro.org>
 <20190910143242.GB3362@kroah.com>
In-Reply-To: <20190910143242.GB3362@kroah.com>
From:   Baolin Wang <baolin.wang@linaro.org>
Date:   Wed, 11 Sep 2019 11:39:30 +0800
Message-ID: <CAMz4kuJniq8gzCAGRiCZoLp5D+dH-CfnUCmmkxN6-e1c2xaPNQ@mail.gmail.com>
Subject: Re: [BACKPORT 4.14.y v2 2/6] locking/lockdep: Add debug_locks check
 in __lock_downgrade()
To:     Greg KH <greg@kroah.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, longman@redhat.com,
        Arnd Bergmann <arnd@arndb.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Sep 2019 at 22:32, Greg KH <greg@kroah.com> wrote:
>
> On Thu, Sep 05, 2019 at 11:07:14AM +0800, Baolin Wang wrote:
> > From: Waiman Long <longman@redhat.com>
> >
> > [Upstream commit 513e1073d52e55b8024b4f238a48de7587c64ccf]
> >
> > Tetsuo Handa had reported he saw an incorrect "downgrading a read lock"
> > warning right after a previous lockdep warning. It is likely that the
> > previous warning turned off lock debugging causing the lockdep to have
> > inconsistency states leading to the lock downgrade warning.
> >
> > Fix that by add a check for debug_locks at the beginning of
> > __lock_downgrade().
> >
> > Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> > Reported-by: syzbot+53383ae265fb161ef488@syzkaller.appspotmail.com
> > Signed-off-by: Waiman Long <longman@redhat.com>
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Will Deacon <will.deacon@arm.com>
> > Link: https://lkml.kernel.org/r/1547093005-26085-1-git-send-email-longman@redhat.com
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
> > ---
> >  kernel/locking/lockdep.c |    3 +++
> >  1 file changed, 3 insertions(+)
>
> Why isn't this relevant for 4.19.y?  I can't add a patch to 4.14.y and
> then have someone upgrade to 4.19.y and not have the same fix in there,
> that would be a regression.
>
> So can you redo this series also with a 4.19.y set at the same so we
> don't get out of sync?  I've queued up your first patch already as that
> was in 4.19.y (and also needed in 4.9.y).

I understood, will do. Thanks.

-- 
Baolin Wang
Best Regards
