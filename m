Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A980A29A14
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 16:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391619AbfEXO33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 10:29:29 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35696 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390885AbfEXO33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 10:29:29 -0400
Received: by mail-io1-f68.google.com with SMTP id p2so7933130iol.2;
        Fri, 24 May 2019 07:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PF5/kSstL6dB+XBbydanwTKTfO7G7GNRcoy9R05gXJU=;
        b=jBqIdyIcrkxXjas2FWZbfS+W5bempIzwewW+zyCJHL/m95gd42FS3XCJWVJ4ZXvqbw
         JDW9hH3yJt0ZpVtU30w7IAJoTJrMzh3mNzAJKMtJXmBs8QEVMLqp/UiBdgiSUsLXejQY
         kdQODvpc6ac5nkd2kLxkKvjxrcb6itRfHc9fzJjpGwInYB/BMx2e8vnGqX5IZWJiZreB
         wcAsp+2JJY89nyuIxmxCqg3Svn6hyveeyOqFskrrCCdnXjjFe8coM3Pgjky6+ls7cpGx
         1NTPW8GONUHILalvYGEAMCtL3Nh5QHQ/SRjYrDMus9+QOfL5mf/6AiMgtLihtb+xdE+j
         QAHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PF5/kSstL6dB+XBbydanwTKTfO7G7GNRcoy9R05gXJU=;
        b=Ly6BSdb62p5ZE9ZLCwA/GJgiw1WivuYKFrEalwCCNOy8AUL3DW81JW8xf5u/3YKnKh
         T0pXO/ZAOF6SQIZj7vlZbQOWMQaG8kyInjotSTODlCKc6rHO/RtxOt8MzBojuCMNTVtv
         WjfJD+SSPYRx8p75puiiIffz1OBzfREJeigDs6+IFNry6jvhKayLUe6ABqcoFbqTwzy8
         U8oht12NOquyEmh3o0MEcU1oPFeDS0VH97++o50JK3gdcaXL41rW8dVH6EjxeNAF2wZa
         w9bjludmxrYAUL4wNFoyf9ekkcG+aw+mSSDEdVRcHstAaiIAU+PK3rOYz3kPvUiv2K+l
         AetQ==
X-Gm-Message-State: APjAAAVe1lrCU29VmhVnVyXeXWjZ7RCmSOL6czD2XBjd6E/SqCe8v+64
        7WRiMp6aNPs4GvX8OkRV/SlIRWdo9yEwB0MdAGQ=
X-Google-Smtp-Source: APXvYqy2BcasgPRE9jzKYvv6H6TPqErckNncgh5TYWKlw/xGEkAP5UG6X2TwfrwUFif01yaNYwfDbAjzIS7oFb3dptk=
X-Received: by 2002:a6b:6217:: with SMTP id f23mr3327984iog.110.1558708168549;
 Fri, 24 May 2019 07:29:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190522150505.GA4915@redhat.com> <CABeXuvrPM5xvzqUydbREapvwgy6deYreHp0aaMoSHyLB6+HGRg@mail.gmail.com>
 <20190522161407.GB4915@redhat.com> <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
 <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com> <20190523145944.GB23070@redhat.com>
 <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com> <20190523163604.GE23070@redhat.com>
 <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com> <CABeXuvo-wey+NHWb4gi=FSRrjJOKkVcLPQ-J+dchJeHEbhGQ6g@mail.gmail.com>
 <20190524141947.GC2655@redhat.com>
In-Reply-To: <20190524141947.GC2655@redhat.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Fri, 24 May 2019 07:29:13 -0700
Message-ID: <CABeXuvqx9fZGiGSAQEE=7wechoGE0E8YW7icBWoTtXPkWPROUw@mail.gmail.com>
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

I think you are misunderstanding what I said. You are taking things
out of context. I was saying here what I did was inspired by why the
syscall was designed to begin with. The syscall below refers to
epoll_wait and not epoll_pwait.

-Deepa

On Fri, May 24, 2019 at 7:19 AM Oleg Nesterov <oleg@redhat.com> wrote:
>
> On 05/23, Deepa Dinamani wrote:
> >
> > 1. block the signals you don't care about.
> > 2. syscall()
> > 3. unblock the signals blocked in 1.
>
> and even this part of your email is very confusing. because in this case
> we can never miss a signal. I'd say
>
>         1. block the signals you don't care about
>         2. unblock the signals which should interrupt the syscall below
>         3. syscall()
>         4. block the signals unblocked in 2.
>
> Oleg.
>
