Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A908C28594
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 20:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731107AbfEWSGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 14:06:49 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45548 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731093AbfEWSGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 14:06:49 -0400
Received: by mail-io1-f66.google.com with SMTP id b3so228796iob.12;
        Thu, 23 May 2019 11:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XdOS1jq8b2ZAmKzwdek6sp8pOeqK25qgZhjMRx+3kPc=;
        b=NWtL07zFOCFP4lBu8Iphuhtalv/5o3pmtac06X4fCcWHWCwJ66NC+/eZo76l5v4fzJ
         /8EOn/fQ7zeG+DPayQVmNufQw84O/o9H1oOCw0fQfaLZ3sxud2tVSPtfN7Q/HEw7lmxX
         ouLciFoIAhTvk+ZpGNrpd0iDMLKtjqmCnryYJdyjMrDjqEm5VbOzB5Kc4RsmvChBgu7Y
         lbD6+axWrJgt+FmL44NWrR2x6diOBV1cHanRkGbk8DpyJJOyMv326+sSpAp4fOxHOESR
         E3j9rND/5Bml3JxdmQHl5AWGJG69qz+8idDIEcMfQCvBxbKt8bYBJlfTonsCRISMqiz3
         PcIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XdOS1jq8b2ZAmKzwdek6sp8pOeqK25qgZhjMRx+3kPc=;
        b=ZNNI5zfvoh7rqkoGsYMz4q6pRzdD/FF+vCU4Xhv19AR/lXo0UQzKQFxMOk17J3+TFk
         xB9JcCtG56MsClZZHYnZpWHeSOaGN1qva0Yk44Vg5M2bQpB17di3yULCHiKF8iY1m/em
         DkjOZ1Im+vWOscwSrDSAOJkCEYGwTA8HGoIsP0OL3AgwmlzgTMa8F6jJYalpx1Jt/i/Q
         MiISGoTu4Re/jci818uEXxVYFqwvEXv3FbkfxxxXPFvR7r2NLkYIi8SFIzFCIJw/ZFvX
         4eSFImCclbjVGaciUcjzlAE3omL6bOZEhFeGuFiUbTosHeUM9xF3W4+EO6KxrHJalS4X
         gsJA==
X-Gm-Message-State: APjAAAUmmCbG8ORP/VO2G41IUYNNcqIzOcHttOlPJeF/j58NaMBB9cSQ
        FKK+k/sA3UPwODraimJpcph4i7CyIeUWVk1dWGQ=
X-Google-Smtp-Source: APXvYqyXvLulnivo5Zhy2pYfrQZo94/GrgWZbNEIX2qy7Qee+RUyI7AyGkRhqzwfHnEEtS/npGnzsNF16tkWzAUuAgQ=
X-Received: by 2002:a6b:c411:: with SMTP id y17mr4123111ioa.265.1558634808133;
 Thu, 23 May 2019 11:06:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190522150505.GA4915@redhat.com> <CABeXuvrPM5xvzqUydbREapvwgy6deYreHp0aaMoSHyLB6+HGRg@mail.gmail.com>
 <20190522161407.GB4915@redhat.com> <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
 <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com> <20190523145944.GB23070@redhat.com>
 <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com> <20190523163604.GE23070@redhat.com>
 <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com>
In-Reply-To: <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Thu, 23 May 2019 11:06:37 -0700
Message-ID: <CABeXuvo-wey+NHWb4gi=FSRrjJOKkVcLPQ-J+dchJeHEbhGQ6g@mail.gmail.com>
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

Ok, since there has been quite a bit of argument here, I will
backtrack a little bit and maybe it will help us understand what's
happening here.
There are many scenarios being discussed on this thread:
a. State of code before 854a6ed56839a
b. State after 854a6ed56839a
c. Proposed fix as per the patchset in question.

Oleg, I will discuss these first and then we can discuss the
additional changes you suggested.

Some background on why we have these syscalls that take sigmask as an
argument. This is just for the sake of completeness of the argument.

These are particularly meant for a scenario(d) such as below:

1. block the signals you don't care about.
2. syscall()
3. unblock the signals blocked in 1.

The problem here is that if there is a signal that is not blocked by 1
and such a signal is delivered between 1 and 2(since they are not
atomic), the syscall in 2 might block forever as it never found out
about the signal.

As per [a] and let's consider the case of epoll_pwait only first for simplicity.

As I said before, ep_poll() is what checks for signal_pending() and is
responsible for setting errno to -EINTR when there is a signal.

So if a signal is received after ep_poll() and ep_poll() returns
success, it is never noticed by the syscall during execution.
So the question is does the userspace have to know about this signal
or not. From scenario [d] above, I would say it should, even if all
the fd's completed successfully.
This does not happen in [a]. So this is what I said was already broken.

What [b] does is to move the signal check closer to the restoration of
the signal. This way it is good. So, if there is a signal after
ep_poll() returns success, it is noticed and the signal is delivered
when the syscall exits. But, the syscall error status itself is 0.

So now [c] is adjusting the return values based on whether extra
signals were detected after ep_poll(). This part was needed even for
[a].

Let me know if this clarifies things a bit.

-Deepa
