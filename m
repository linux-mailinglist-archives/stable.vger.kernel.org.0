Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E42128B9D
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 22:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387559AbfEWUl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 16:41:29 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43547 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387533AbfEWUl3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 16:41:29 -0400
Received: by mail-io1-f68.google.com with SMTP id v7so5983263iob.10;
        Thu, 23 May 2019 13:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RIktXmsvo5WeogzuSAj6+oDuP7plh2sTZtJRWQFt6ug=;
        b=dPufqnuehyMrtZdGMJMje631CgWkoo4SYi03r1LoKlrNFi7pECzlXfviVjwgdwt6qr
         +0Va5D/ErNExW6RowUCW0ND57vVQn6ITR4sf6P890Tqhz7Y786dRhVOx5Pg0eAnS7A03
         +OUZCte2B3TYRxxwY4M/nWN4Tu9zlwquT2eEn0u4HGTP0PTzVil0VOTj2k2q7ppbyr73
         9+makKUyYdkDFQAlLzkQFN7BNedXjkVQqfESJP8vH+Bpr08s6PnZM7gdJJLGwjZjn4Fy
         QZztAOBYVwtso5wLUbSnyxSUmfFg3xgCt3k6aNetkQzuoQPAMiuSHqHNnOZKXq2BAdAP
         3HLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RIktXmsvo5WeogzuSAj6+oDuP7plh2sTZtJRWQFt6ug=;
        b=f5kcP7LRxfKr1KSZM4VwuwSKUlERgvOWiSSsrfKXgFcunvYlPm8ZtbC53FJzKLyOl7
         PTcG6DeaViSna6kjdOZvxUGWVvn5ZNcUpQBtOCbiDqzMWl6wghHgqIml3tONmz/FSNk+
         D8ybVn3nAsnNoY+q7FqG6wc26UKcPBHYSnEDoNE9cYcWS+KNA2AASGEKikaj1TtKtp9/
         +d3yqHukk84IJvSr60eWpb/m8HFAcw0GD82P5As2zKnBkx5fSKPVISzQL/B3Zf1ZUAXW
         1WnW7VNcZTseAjtNu1AcpATgYoScUmviRSNnV7+og8NSe+OPOF8sAhz5n3i22E5fQ35a
         q9SQ==
X-Gm-Message-State: APjAAAWcyuUJHzAfWVdP/vpW6lCzu+5VMglrd7T+zFdxwZS9rVbGrGAH
        VNlvmzb/u0OACbCMdibOPJWkcJ5W9ztXkl8PmEW/OW95
X-Google-Smtp-Source: APXvYqxSRGm6r6onYkeAL6+ZAdjWQ9BrX9WJmnzdsWUIvnq+aNXOjwLElz/r07/BYQuWzF5aUUlZeEQQ7S8RNL0pxUI=
X-Received: by 2002:a6b:b843:: with SMTP id i64mr30640iof.81.1558644088494;
 Thu, 23 May 2019 13:41:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190522150505.GA4915@redhat.com> <CABeXuvrPM5xvzqUydbREapvwgy6deYreHp0aaMoSHyLB6+HGRg@mail.gmail.com>
 <20190522161407.GB4915@redhat.com> <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
 <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com> <20190523145944.GB23070@redhat.com>
 <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com> <20190523163604.GE23070@redhat.com>
 <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com> <CABeXuvo-wey+NHWb4gi=FSRrjJOKkVcLPQ-J+dchJeHEbhGQ6g@mail.gmail.com>
In-Reply-To: <CABeXuvo-wey+NHWb4gi=FSRrjJOKkVcLPQ-J+dchJeHEbhGQ6g@mail.gmail.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Thu, 23 May 2019 13:41:17 -0700
Message-ID: <CABeXuvo5Y0aHgo-xMzmW7V02g+ysGqAkdoCAkW7L6LkukdvAcg@mail.gmail.com>
Subject: Re: [PATCH v2] signal: Adjust error codes according to restore_user_sigmask()
To:     David Laight <David.Laight@aculab.com>
Cc:     Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "dbueso@suse.de" <dbueso@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, Eric Wong <e@80x24.org>,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        Omar Kilani <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 23, 2019 at 11:06 AM Deepa Dinamani <deepa.kernel@gmail.com> wrote:
>
> Ok, since there has been quite a bit of argument here, I will
> backtrack a little bit and maybe it will help us understand what's
> happening here.
> There are many scenarios being discussed on this thread:
> a. State of code before 854a6ed56839a
> b. State after 854a6ed56839a
> c. Proposed fix as per the patchset in question.
>
> Oleg, I will discuss these first and then we can discuss the
> additional changes you suggested.
>
> Some background on why we have these syscalls that take sigmask as an
> argument. This is just for the sake of completeness of the argument.
>
> These are particularly meant for a scenario(d) such as below:
>
> 1. block the signals you don't care about.
> 2. syscall()
> 3. unblock the signals blocked in 1.
>
> The problem here is that if there is a signal that is not blocked by 1
> and such a signal is delivered between 1 and 2(since they are not
> atomic), the syscall in 2 might block forever as it never found out
> about the signal.
>
> As per [a] and let's consider the case of epoll_pwait only first for simplicity.
>
> As I said before, ep_poll() is what checks for signal_pending() and is
> responsible for setting errno to -EINTR when there is a signal.
>
> So if a signal is received after ep_poll() and ep_poll() returns
> success, it is never noticed by the syscall during execution.
> So the question is does the userspace have to know about this signal
> or not. From scenario [d] above, I would say it should, even if all
> the fd's completed successfully.
> This does not happen in [a]. So this is what I said was already broken.
>
> What [b] does is to move the signal check closer to the restoration of
> the signal. This way it is good. So, if there is a signal after
> ep_poll() returns success, it is noticed and the signal is delivered
> when the syscall exits. But, the syscall error status itself is 0.
>
> So now [c] is adjusting the return values based on whether extra
> signals were detected after ep_poll(). This part was needed even for
> [a].
>
> Let me know if this clarifies things a bit.

Just adding a little more clarification, there is an additional change
between [a] and [b].
As per [a] we would just restore the signal instead of changing the
saved_sigmask and the signal could get delivered right then. [b]
changes this to happen at syscall exit:

void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
{

           <snip>

          /*
           * When signals are pending, do not restore them here.
           * Restoring sigmask here can lead to delivering signals
that the above
           * syscalls are intended to block because of the sigmask passed in.
           */
           if (signal_pending(current)) {
           current->saved_sigmask = *sigsaved;
           set_restore_sigmask();
           return;
}

-Deepa
