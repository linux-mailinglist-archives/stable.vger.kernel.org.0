Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6B129C9F
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 19:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390210AbfEXRBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 13:01:48 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39808 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390532AbfEXRBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 13:01:48 -0400
Received: by mail-io1-f68.google.com with SMTP id r185so3410116iod.6;
        Fri, 24 May 2019 10:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wi5iXQAuQRuJb87dDlNdyPBw5MwH0ZxO9RU+lAP+m88=;
        b=n+9qKethpxgvbN01CCm/ntTwbzKvY57e+2N0itpKvqNUR0BkF8REmtX3MrkOwN1ZVg
         N5AGM26ZiMuM8yq9VldaVCE0ESFpPQfAISsdaZTelCfIxn91pnTgKHDzvHnhMWfa02FW
         NbL9J6VfYPLR/voilyW4uAF4/ocTAFKYaExFYsXTa2RP7nVRgRd8wHpqPRd7KQi+S2qe
         PyJ5fwvGNrTUyInLe7LYQ0gUbw7R7evl3LONcks+3tOjzNPoZqQ+BEuxiLChW+A/nLyb
         eaUfrBsO/uaswiZ8oZpjR7Ur9R6y1QIjYEjoyLbokCey+HCgD96FXob1NO4eFJsmvjgX
         QFPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wi5iXQAuQRuJb87dDlNdyPBw5MwH0ZxO9RU+lAP+m88=;
        b=dqxsy76Xxab/zo0qV8+ilOlXINuBrxZK06c4JS9VfOFttNC7Me7jiAoaPGGOK1roXo
         jaN09WRWCRZ1oNvvrDAKuCrXmWTRUeVwVPM5wyhxt8OqBlzHcpVaWvSrEliNGYp0hig+
         mXA4wOYnQVqF8UXA2hZNl8eO18IF4sZJgJwvLt3c9UDlIdNMBWMmuWavfJD4iw5Wdgho
         UDRvR9+c7sno4lEd3T9BS67D4zH4r71q2GA08quR4COGyWf4JkD2LnAITefx/5/b3c8Y
         bxbFJiqRSEzZvEuwpztt0cNmcHZ5JDmoHdY+Q8G8pG0ISxZ/C6nnF1bpeUaSTjjU40yI
         PFqA==
X-Gm-Message-State: APjAAAXGhdQZSDj2H4q9iHEi4acqU4QVqjbGyj61zKetfMhFfg3jK+Lt
        DNOfh/D8KIofChEerz9iaqiWLfPXS9E/V7TM+q0=
X-Google-Smtp-Source: APXvYqx1kYvKHTOKnp8yYdox48+3r2bIuMfvOK2BV3xJgnIWA+AVqzhi6xBBSa8FqgGcBWUg8NSomAy0gHvMDZrq5Es=
X-Received: by 2002:a6b:c411:: with SMTP id y17mr3164801ioa.265.1558717307374;
 Fri, 24 May 2019 10:01:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190522161407.GB4915@redhat.com> <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
 <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com> <20190523145944.GB23070@redhat.com>
 <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com> <20190523163604.GE23070@redhat.com>
 <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com> <CABeXuvo-wey+NHWb4gi=FSRrjJOKkVcLPQ-J+dchJeHEbhGQ6g@mail.gmail.com>
 <20190524141054.GB2655@redhat.com> <CABeXuvqSzy+v=3Y5NnMmfob7bvuNkafmdDqoex8BVENN3atqZA@mail.gmail.com>
 <20190524163310.GG2655@redhat.com>
In-Reply-To: <20190524163310.GG2655@redhat.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Fri, 24 May 2019 10:01:32 -0700
Message-ID: <CABeXuvrUKZnECj+NgLdpe5uhKBEmSynrakD-3q9XHqk8Aef5UQ@mail.gmail.com>
Subject: Re: [PATCH v2] signal: Adjust error codes according to restore_user_sigmask()
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     David Laight <David.Laight@aculab.com>,
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

On Fri, May 24, 2019 at 9:33 AM Oleg Nesterov <oleg@redhat.com> wrote:
>
> On 05/24, Deepa Dinamani wrote:
> >
> > On Fri, May 24, 2019 at 7:11 AM Oleg Nesterov <oleg@redhat.com> wrote:
> > >
> > > On 05/23, Deepa Dinamani wrote:
> > > >
> > > > Ok, since there has been quite a bit of argument here, I will
> > > > backtrack a little bit and maybe it will help us understand what's
> > > > happening here.
> > > > There are many scenarios being discussed on this thread:
> > > > a. State of code before 854a6ed56839a
> > >
> > > I think everything was correct,
> >
> > There were 2 things that were wrong:
> >
> > 1. If an unblocked signal was received, after the ep_poll(), then the
> > return status did not indicate that.
>
> Yes,
>
> > This is expected behavior
> > according to man page. If this is indeed what is expected then the man
> > page should note that signal will be delivered in this case and return
> > code will still be 0.
> >
> > "EINTR
> > The call was interrupted by a signal handler before either any of the
> > requested events occurred or the timeout expired; see signal(7)."
>
> and what do you think the man page could say?

Maybe clarify that a signal handler can be invoked even if the syscall
return indicates a success.

Maybe a crude userspace application could do something like this:

sig_handler()
{
  set global abort = 1
}

poll_the_fds()
{
           ret = epoll_pwait()
           if (ret)
              return ret
          if (abort)              # but this abort should be ignored
if ret was 0.
            return try_again

}

> This is obviously possible for any syscall, and we can't avoid this. A signal
> can come right after syscall insn completes. The signal handler will be called
> but this won't change $rax, user-space can see return code == 0 or anything else.
>
> And this doesn't differ from the case when the signal comes before syscall returns.

But, these syscalls are depending on there signals. I would assume for
the purpose of these syscalls that the execution is done when we
updated the saved_sigmask. We can pick a different point per syscall
like ep_poll() also, but then we need to probably make it clear for
each such syscall.

> > 2. The restoring of the sigmask is done right in the syscall part and
> > not while exiting the syscall and if you get a blocked signal here,
> > you will deliver this to userspace.
>
> So I assume that this time you are talking about epoll_pwait() and not epoll_wait()...

Yes.

> And I simply can't understand you. But yes, if the original mask doesn't include
> the pending signal it will be delivered while the syscall can return success/timout
> or -EFAULT or anything.
>
> This is correct, see above.

Look at the code before 854a6ed56839a:

  /*
        * If we changed the signal mask, we need to restore the original one.
        * In case we've got a signal while waiting, we do not restore the
        * signal mask yet, and we allow do_signal() to deliver the signal on
        * the way back to userspace, before the signal mask is restored.
        */
       if (sigmask) {
              ####### This err has not been changed since ep_poll()
              ####### So if there is a signal before this point, but
err = 0, then we goto else.
               if (err == -EINTR) {
                       memcpy(&current->saved_sigmask, &sigsaved,
                              sizeof(sigsaved));
                       set_restore_sigmask();
               } else
                     ############ This is a problem if there is signal
pending that is sigmask should block.
                     ########### This is the whole reason we have
current->saved_sigmask?
                       set_current_blocked(&sigsaved);
       }

> > > > b. State after 854a6ed56839a
> > >
> > > obviously buggy,
> >
> > Ok, then can you point out what specifically was wrong with
> > 854a6ed56839a?
>
> Cough. If nothing else the lost -EINTR?

This was my theory. My basis behind the theory was [1](the issue with
return value not being updated) above. And, you are saying this is ok.

854a6ed56839a also has timing differences compared to the original
code. So unless we are sure what was uncovered because of
854a6ed56839a, we might just be masking a pre-existing problem by
reverting it. So I think we should code review 854a6ed56839a and
figure out what is wrong programatically before just reverting it.

> > And, not how it could be more simple?

Oh, I was not asking here. I was saying let's please discuss what's
wrong before simplifying the code.

-Deepa
