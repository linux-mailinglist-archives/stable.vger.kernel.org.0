Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCE5B2E4A2
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 20:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbfE2SmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 14:42:23 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:35100 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfE2SmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 14:42:23 -0400
Received: by mail-io1-f66.google.com with SMTP id p2so2775974iol.2;
        Wed, 29 May 2019 11:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ac4wfHXOGpPwgmU9+NyMZSbTQr/j+BDgOZSJk6FL+cU=;
        b=pz4dftM4fTpg7Y0etCDItJltv1TiXyMGLurzZkTgC82QCcMycu+LXgi6ynxqt27jOI
         tv0ZDDfcyNcGZNWZMDeEkoOJzcIxqKnVhMeI0RooHtMkgokw+eDE+wGRX+NS68icKKDR
         LsYD5yoS58k7hDYhkj/ijTP1S9U9SqNegRH6WMTPEQjWZGCId36KmNr2PcRRhDBzTIXH
         gyQi0cqJ5mc9Pen0AjXg0CH17gPGI8Wet+zHnRq6LnZbvJUGzFw3wH2VEK+Re6pvZrA5
         Dcap5QyONoSMp4ZcUHcFcJccKd9chk88/RhpR3XueX2OpX/famGA1D0TbGA0NEMgUdrB
         PPhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ac4wfHXOGpPwgmU9+NyMZSbTQr/j+BDgOZSJk6FL+cU=;
        b=QQkQ725MMp/KD8hmqUjA4+5WEheXVGVuiCI+PWmWNVRMqQTtSJUSGoFg4k3KVqkX0j
         +V1Q7Ypac3MGttMDGkX/qQfq5zaHCFBLlQytabu3U5ZELhjDY5b6yn4iChQT/q7MkjaR
         mjorpeXSPqLbh3jz05NlJcYuJGpQMg6RMD8+zkRhS8TGX0fmbQMouC7cuTKbSjAZOHTs
         Xh5VQXH9P3TMW/Mc6L2PCkup35UtP+xOonMgLFwxd9VlEUYncWAdGQf6JDTzywXZHw79
         hvlEED5Lc1GS5ID8lpVMA9jZKGdqfXOLHcWsDhcEmWphaT3ohGTinwCLNy/njLbX+81l
         ru1A==
X-Gm-Message-State: APjAAAXWfwSEZzhMSSgTAREHiwhZ6lfEePubbmBsJSXRg8x9/lUODei2
        aRBQBjJDkHVOoFP20ZAlihIdYXznFEjNq3GBuXg=
X-Google-Smtp-Source: APXvYqzQDio796G4Lx7zeBpaekA8t5Ss1nQFheXwKT3BzHWDoYIvDIez2PAO6oHIVKTGTiRNKqYB5znXP2b/LOi4buQ=
X-Received: by 2002:a6b:c411:: with SMTP id y17mr13876076ioa.265.1559155340985;
 Wed, 29 May 2019 11:42:20 -0700 (PDT)
MIME-Version: 1.0
References: <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com>
 <20190523163604.GE23070@redhat.com> <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com>
 <CABeXuvo-wey+NHWb4gi=FSRrjJOKkVcLPQ-J+dchJeHEbhGQ6g@mail.gmail.com>
 <20190524141054.GB2655@redhat.com> <CABeXuvqSzy+v=3Y5NnMmfob7bvuNkafmdDqoex8BVENN3atqZA@mail.gmail.com>
 <20190524163310.GG2655@redhat.com> <CABeXuvrUKZnECj+NgLdpe5uhKBEmSynrakD-3q9XHqk8Aef5UQ@mail.gmail.com>
 <20190527150409.GA8961@redhat.com> <CABeXuvouBzZuNarmNcd9JgZgvonL1N_p21gat=O_x0-1hMx=6A@mail.gmail.com>
 <20190529165717.GC27659@redhat.com>
In-Reply-To: <20190529165717.GC27659@redhat.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Wed, 29 May 2019 11:42:09 -0700
Message-ID: <CABeXuvrFqGySKNLFK4f5er2ahQpz_eTbF+RfXCis1TZNT16Ddg@mail.gmail.com>
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

On Wed, May 29, 2019 at 9:57 AM Oleg Nesterov <oleg@redhat.com> wrote:
>
> On 05/28, Deepa Dinamani wrote:
> >
> > I agree that signal handller being called and return value not being
> > altered is an issue with other syscalls also. I was just wondering if
> > some userspace code assumption would be assuming this. This is not a
> > kernel bug.
> >
> > But, I do not think we have an understanding of what was wrong in
> > 854a6ed56839a anymore since you pointed out that my assumption was not
> > correct that the signal handler being called without errno being set
> > is wrong.
>
> Deepa, sorry, I simply can't parse the above... most probably because of
> my bad English.

Ok, All I meant was that I had thought a signal handler being invoked
without the error value reflecting it was wrong. That is what I had
thought was wrong with 854a6ed56839a. Now, that we agree that signal
handler can be invoked without the errno returning success, I thought
I did not know what is wrong with 854a6ed56839a anymore.

But, you now pointed out that the signals we care about should not be
delivered after an event has been ready. This points out to what was
wrong with 854a6ed56839a. Thanks.

> > One open question: this part of epoll_pwait was already broken before
> > 854a6ed56839a. Do you agree?
> >
> > if (err == -EINTR) {
> >                    memcpy(&current->saved_sigmask, &sigsaved,
> >                           sizeof(sigsaved));
> >                     set_restore_sigmask();
> >   } else
> >                    set_current_blocked(&sigsaved);
>
> I do not understand why do you think this part was broken :/

Ok, because of your other statement that the signals the application
cares about do not want to know about signals they care about after an
event is ready this is also not a problem.

> > Or, I could revert the signal_pending() check and provide a fix
> > something like below(not a complete patch)
>
> ...
>
> > -void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
> > +int restore_user_sigmask(const void __user *usigmask, sigset_t
> > *sigsaved, int sig_pending)
> >  {
> >
> >         if (!usigmask)
> >                return;
> >
> >         /*
> >          * When signals are pending, do not restore them here.
> >          * Restoring sigmask here can lead to delivering signals that the above
> >          * syscalls are intended to block because of the sigmask passed in.
> >          */
> > +       if (sig_pending) {
> >                 current->saved_sigmask = *sigsaved;
> >                 set_restore_sigmask();
> >                return;
> >            }
> >
> > @@ -2330,7 +2330,8 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct
> > epoll_event __user *, events,
> >
> >         error = do_epoll_wait(epfd, events, maxevents, timeout);
> >
> > -       restore_user_sigmask(sigmask, &sigsaved);
> > +       signal_detected = restore_user_sigmask(sigmask, &sigsaved,
> > error == -EINTR);
>
> I fail to understand this pseudo-code, sorry. In particular, do not understand
> why restore_user_sigmask() needs to return a boolean.

That was a remnant from the other patch. Return type needs to be void.

> The only thing I _seem to_ understand is the "sig_pending" flag passed by the
> caller which replaces the signal_pending() check.

Correct. This is what is the main change I was proposing.

> Yes, this is what I think we
> should do, and this is what I tried to propose from the very beginning in my
> 1st email in this thread.

This was not clear to me in your first response that you did not want
the signal_pending() check in restore_user_sigmask(). :
https://lore.kernel.org/lkml/20190522150505.GA4915@redhat.com/

"Ugh. I need to re-check, but at first glance I really dislike this change.

I think we can fix the problem _and_ simplify the code. Something like below.
The patch is obviously incomplete, it changes only only one caller of
set_user_sigmask(), epoll_pwait() to explain what I mean.

restore_user_sigmask() should simply die. Although perhaps another helper
makes sense to add WARN_ON(test_tsk_restore_sigmask() && !signal_pending)."

-Deepa
