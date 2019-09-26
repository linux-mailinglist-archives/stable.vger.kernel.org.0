Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A449BEA60
	for <lists+stable@lfdr.de>; Thu, 26 Sep 2019 04:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbfIZCEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 22:04:49 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34627 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728077AbfIZCEt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Sep 2019 22:04:49 -0400
Received: by mail-lj1-f196.google.com with SMTP id j19so433741lja.1
        for <stable@vger.kernel.org>; Wed, 25 Sep 2019 19:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iqIvO1/cRY3REy92QSmyBb/XxrlUuFl4iRm+RuLwMC8=;
        b=NugwTEW4rRZD2qAs8X3uEZ9BKyuMoKS5D5w+bks29qqIEOGaOsBREORPdjhVUoUSHS
         pCY5Zg4EuicvpuihX9HT7PHYEmZC2DqUaNcST/sR6rP1ZnwpB9enQycL0eMF+j8KBnDV
         AykipfJVrJzJruuXcGTEw+f6u1BdZpk1ya///n1PUDPUqs1XB3ut//E53xuFSyGgrm5F
         o+p1PLVFby++tHnOE8+sExz5w8i6tzlEmI+Mzht8sgheaKOQOu+NFM9JfKdRfzS8l4b3
         66eImMyYdm0krsN9jV0ynhBYhcRldlEqLfcvHi/yfpKkeposa9FPnVT+eeQh+GNTlUzo
         gf8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iqIvO1/cRY3REy92QSmyBb/XxrlUuFl4iRm+RuLwMC8=;
        b=E+GSJgu0eD+hdh3fMjauTNIzQrKFX3NS1fYrvzWTAiWzhpEJ6xMsEHcZn4+jGgvSpc
         bk5OHD02EhTDbzStL8pKAQM6ISouVN6QDwDHB1GP1Z0OQubArfF4ZhXqgZCign1ygS5c
         c7erGgUkUefXr0YmqydXMnj6wejXi/thhXDpVQMaNZ5me4UG1lgDqiYIqDgbjwq6klLa
         AV27MrIAVudQQ2wI2ucEfXmiaX4cY9FqJYd/jS4LoGe+zuK4HbH0U50LdN/mMZBnw3ul
         owFCYVURZkBGGRkz4Qconz5HYFRv8mKTStVGD/f0dGSdLWMAQ9W2EDfstBP2jkJiFXCk
         TVwA==
X-Gm-Message-State: APjAAAU+qv9IauGQT1r+YHL546C3SDAaOswJaNpetbH8cACKo406xRLe
        HE42CHepEhZZGUnylXZdGS5VeXu3Y7eFE9GfTIK34w==
X-Google-Smtp-Source: APXvYqzr4GSxqb6AjtMPnutvvMqRRvOEPmaJrXJguS0rhSU/wUbzDgKSpgPMW4V3/Z8S7tqO6sLkZPfZV/pSy3857wU=
X-Received: by 2002:a2e:a0c5:: with SMTP id f5mr795667ljm.114.1569463487576;
 Wed, 25 Sep 2019 19:04:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1569405445.git.baolin.wang@linaro.org> <4ac2e84637ceaf5ec67cfc11ad58c489778693a8.1569405445.git.baolin.wang@linaro.org>
 <87e81724-9f1a-8716-5b4f-f2aac6f25c5a@redhat.com>
In-Reply-To: <87e81724-9f1a-8716-5b4f-f2aac6f25c5a@redhat.com>
From:   Baolin Wang <baolin.wang@linaro.org>
Date:   Thu, 26 Sep 2019 10:04:35 +0800
Message-ID: <CAMz4ku+1STvcpQ=WBVMdkAfcORiCxM4Q885eqWzNoUYMETM3Bg@mail.gmail.com>
Subject: Re: [BACKPORT 4.14.y v3 1/3] locking/lockdep: Add debug_locks check
 in __lock_downgrade()
To:     Waiman Long <longman@redhat.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 25 Sep 2019 at 22:05, Waiman Long <longman@redhat.com> wrote:
>
> On 9/25/19 6:01 AM, Baolin Wang wrote:
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
> >
> > diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> > index 565005a..5c370c6 100644
> > --- a/kernel/locking/lockdep.c
> > +++ b/kernel/locking/lockdep.c
> > @@ -3650,6 +3650,9 @@ static int reacquire_held_locks(struct task_struct *curr, unsigned int depth,
> >       unsigned int depth;
> >       int i;
> >
> > +     if (unlikely(!debug_locks))
> > +             return 0;
> > +
> >       depth = curr->lockdep_depth;
> >       /*
> >        * This function is about (re)setting the class of a held lock,
>
> Apparently, there are 2 such patches in the upstream kernel - commit
> 513e1073d52e55b8024b4f238a48de7587c64ccf and
> 71492580571467fb7177aade19c18ce7486267f5. These are probably caused by
> the fact that there are 2 places in the code that can match the hunks.
> Anyway, this looks like it is applying to the wrong function. It should
> be applied to __lock_downgrade. Though it shouldn't harm if it is
> applied to the wrong function.

Ah, I noticed there are 2 commits with the same commit message, though
513e1073d52e55b8024b4f238a48de7587c64ccf patch did not change the
__lock_downgrade(), which is really confusing. This patch
(513e1073d52e55b8024b4f238a48de7587c64ccf) did the right thing, and
71492580571467fb7177aade19c18ce7486267f5 patch should be applied to
__lock_downgrade.

I'll backport commit 71492580571467fb7177aade19c18ce7486267f5 too in
future. Thanks.

-- 
Baolin Wang
Best Regards
