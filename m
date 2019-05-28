Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB6752D0A7
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 22:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfE1UsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 16:48:02 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:40233 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfE1UsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 16:48:02 -0400
Received: by mail-it1-f196.google.com with SMTP id h11so6208193itf.5;
        Tue, 28 May 2019 13:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LFTmISDOpToJAYI9xiYodY0/ymmT3aFnC+eXeyWSay0=;
        b=m+ijoieuI2Q5AoznyEWu7Ah+4dfaAshTJOVihWAKBwpkDxbw3Np5wBgBGNN1TqSNhP
         v8dmA2qSIOm3pkPK920nRHvFOvF+xAUaq6D/TP1qqICC2mFGnDevbuseJhui0woW80bZ
         qgnbi2YBfPdokAAFdDMA1f9eN9T3CY3OBDnSO4vy6cZc/EVVrcTMjtyYTULGHVIXc3x2
         tCcBoozlZJWLoKUzz+WrRLBNyjlSFfsPeYSmuptqufdR4eiKjA6Ejkn5mXut97vUyaq7
         GcF/lYLbdYW2RGpYFVwDTyNuXXO6zgRF1mmWC8aUvszugl/d2tk/ShyKCMObLsOpq8sh
         oYSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LFTmISDOpToJAYI9xiYodY0/ymmT3aFnC+eXeyWSay0=;
        b=DO2pszPn359/Fu5/pQunQSTR2CBw/zjnysiz39elDxZ1TVKp8jGKPavmxp5yt0kaUq
         rJfkku8gnB9jRDki8TNxuE2bVBcvGyJyv8Lh99zALQ49CNi4lQgAhlNFcagEf31SG7X0
         ZOj8ulk9Oiw8RjVhsgLD8JN5oBkQ+fDP++ojIuctnDBRk0aEAxvH+ScwgEuB8G41GKEd
         HVhYCoJ+kd3WppUQ/lp1cexNnkqCw8QulB371kyW3C5W8ZO9saM9sCNiYIscJgZNoYxR
         jiLOw4ERChjXIra8RBviiSnF+UgOiODp2azJhtal3wPppDXZcTsw/290GTijfa5/iUrM
         ZCJw==
X-Gm-Message-State: APjAAAWH9Ri3ZPrISxUwu2JoX8226VQb3VfoBLNf7/oX9DZC0MdjTUXQ
        JddGIGWENpbu9CbCxCplvGNgFUwVxNvKUaw84oM=
X-Google-Smtp-Source: APXvYqwCstUVHiNHKuq+B8xRc5Ddii2BYUzoNbtcVsxHyYISvQQtSxAjQvX9Y0VQICv+bOsXrBQCwl3alKglk8D5b+c=
X-Received: by 2002:a24:e084:: with SMTP id c126mr4522175ith.124.1559076481674;
 Tue, 28 May 2019 13:48:01 -0700 (PDT)
MIME-Version: 1.0
References: <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com>
 <20190523145944.GB23070@redhat.com> <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com>
 <20190523163604.GE23070@redhat.com> <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com>
 <CABeXuvo-wey+NHWb4gi=FSRrjJOKkVcLPQ-J+dchJeHEbhGQ6g@mail.gmail.com>
 <20190524141054.GB2655@redhat.com> <CABeXuvqSzy+v=3Y5NnMmfob7bvuNkafmdDqoex8BVENN3atqZA@mail.gmail.com>
 <20190524163310.GG2655@redhat.com> <CABeXuvrUKZnECj+NgLdpe5uhKBEmSynrakD-3q9XHqk8Aef5UQ@mail.gmail.com>
 <20190527150409.GA8961@redhat.com>
In-Reply-To: <20190527150409.GA8961@redhat.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Tue, 28 May 2019 13:47:28 -0700
Message-ID: <CABeXuvouBzZuNarmNcd9JgZgvonL1N_p21gat=O_x0-1hMx=6A@mail.gmail.com>
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

On Mon, May 27, 2019 at 8:04 AM Oleg Nesterov <oleg@redhat.com> wrote:
>
> Deepa,
>
> it seems that we both are saying the same things again and again, and we
> simply can't understand each other.

Oleg, I'm sorry for the confusion.  Maybe I should point out what I
agree with also.

I agree that signal handller being called and return value not being
altered is an issue with other syscalls also. I was just wondering if
some userspace code assumption would be assuming this. This is not a
kernel bug.

But, I do not think we have an understanding of what was wrong in
854a6ed56839a anymore since you pointed out that my assumption was not
correct that the signal handler being called without errno being set
is wrong.

One open question: this part of epoll_pwait was already broken before
854a6ed56839a. Do you agree?

if (err == -EINTR) {
                   memcpy(&current->saved_sigmask, &sigsaved,
                          sizeof(sigsaved));
                    set_restore_sigmask();
  } else
                   set_current_blocked(&sigsaved);

What to do next?
We could just see if your optimization patch resolves Eric's issue.
Or, I could revert the signal_pending() check and provide a fix
something like below(not a complete patch) since mainline has this
regression. Eric had tested something like this works also. And, I can
continue to look at what was wrong with 854a6ed56839a in the first
place. Let me know what you prefer:

-void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
+int restore_user_sigmask(const void __user *usigmask, sigset_t
*sigsaved, int sig_pending)
 {

        if (!usigmask)
               return;

        /*
         * When signals are pending, do not restore them here.
         * Restoring sigmask here can lead to delivering signals that the above
         * syscalls are intended to block because of the sigmask passed in.
         */
+       if (sig_pending) {
                current->saved_sigmask = *sigsaved;
                set_restore_sigmask();
               return;
           }

@@ -2330,7 +2330,8 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct
epoll_event __user *, events,

        error = do_epoll_wait(epfd, events, maxevents, timeout);

-       restore_user_sigmask(sigmask, &sigsaved);
+       signal_detected = restore_user_sigmask(sigmask, &sigsaved,
error == -EINTR);

-Deepa
