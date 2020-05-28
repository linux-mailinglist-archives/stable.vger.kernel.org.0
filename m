Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27751E705D
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 01:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437504AbgE1XXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 19:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437485AbgE1XXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 19:23:46 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9EEC08C5C6
        for <stable@vger.kernel.org>; Thu, 28 May 2020 16:23:46 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id z22so184536lfd.0
        for <stable@vger.kernel.org>; Thu, 28 May 2020 16:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lvntbN5poYtMfSoKiCXpDz0H9PHNUtXkgX3txl3QBqg=;
        b=Owg3ySC84uxhuGKf6i2dNH2q/RD4VDxW4n+bdjTUEA6SmcwJChlGAG9o1ZFxzpK1Nh
         nY6SPtEKeisN9g2MeJWXi6V8e9llGjbJu5nh52W1rAF6P824ju3OUk4J4RBFThk0Muul
         r/SE9uKEOWNO53I3VkXf8ZjvR0cIpy6y6Gck4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lvntbN5poYtMfSoKiCXpDz0H9PHNUtXkgX3txl3QBqg=;
        b=aCC3G6TNTGeV/qPExALbVhc9xH/Ht/zdKFBC1n55uv8ESMH5Q7NDh9pYQenVUuy7Bj
         LbSl1CygYjybLDbTSpz1dEJX6aVsdYWdKZY30wGUxpA7r3zzJ43qL4mUKjWe97cMcVbT
         KbC3RnLxNSSG/977oM9h3zHZtTYjlPlK1pHA0fFVsmNiybJGGD7QIUsMZIXW+tlxKdDW
         R8I7iTUAgna11uUG7NQRX3aACvlAWS9XryaVh3I/esnJuA/954xdMOb3wOiBWgIbGf7d
         9if+BcKPvcuK7suVziDfJL6oBWmEplhgp8hUQxlGQ4dG4a1gvMob2nrr7e+OklFEYs/m
         dfRQ==
X-Gm-Message-State: AOAM532a07S4t1vRVkujeLwo6Pyv/LQF/sNivjD9KzsJ94QJmat+h9rC
        rM2027cl7w9Fycm/xZ+tNPIw1DgxwWQ=
X-Google-Smtp-Source: ABdhPJyNAesDUENyBUmHFZgLFFjfkgKoWxAZogiBEUah/EIydCpe5fM9WgnoYUdpJ13SlFV4JaY16Q==
X-Received: by 2002:a05:6512:3139:: with SMTP id p25mr2857276lfd.214.1590708224229;
        Thu, 28 May 2020 16:23:44 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id m11sm1889049lfl.70.2020.05.28.16.23.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 16:23:43 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id m18so282259ljo.5
        for <stable@vger.kernel.org>; Thu, 28 May 2020 16:23:42 -0700 (PDT)
X-Received: by 2002:a2e:b16e:: with SMTP id a14mr2499699ljm.70.1590708222167;
 Thu, 28 May 2020 16:23:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200528135552.GA87103@google.com> <CAHk-=wjgtD6drydXP5h_r90v0sCSQe7BMk7AiYADhJ-x9HGgkg@mail.gmail.com>
 <20200528230859.GB225299@google.com>
In-Reply-To: <20200528230859.GB225299@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 28 May 2020 16:23:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=whf6b=OijDL=+PUTBsrhURzLZQ5xAq5tWDqOQpTmePFDA@mail.gmail.com>
Message-ID: <CAHk-=whf6b=OijDL=+PUTBsrhURzLZQ5xAq5tWDqOQpTmePFDA@mail.gmail.com>
Subject: Re: [PATCH] sched/headers: Fix sched_setattr userspace compilation breakage
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Blecker <matthewb@google.com>,
        Jesse Barnes <jsbarnes@google.com>,
        Mike Frysinger <vapier@google.com>,
        Christian Brauner <christian@brauner.io>,
        vpillai <vpillai@digitalocean.com>, vineethrp@gmail.com,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 28, 2020 at 4:09 PM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> > So no, this patch is fundamentally wrong. It negates the whole point
> > of having a uapi header at all.
>
> Sorry, I naively assumed that headers in 'include/uapi/' are safe to include
> from userspace. I feel terrible.

Well, they "kind of" are safe to include.

It's just that normally they are meant for system integrators to
include as part of the system header files. So they are designed not
to be safe for normal programs, but for library writers.

And to make things more confusing, sometimes people _do_ include
kernel header files directly, just because they want to get features
that either haven't been exposed by the system libraries, or because
the system libraries copied the uapi header files for an older version
of the kernel, and you want the shiny new feature, so...

And some of those header files are easier to do that with than others...

> The problem is <sched.h> still does not get us 'struct sched_attr' even
> though the manpage of sched_setattr(2) says including <sched.h> is all that's
> needed.

Ouch. But clearly you get it from -somewhere- since it then complains
about the double declaration.

Strange.

> Also, even if glibc included 'include/uapi/linux/sched/types.h' to get struct
> sched_attr's definition, we would run into the same issue I reported right?
> The 'struct sched_param' is already defined by glibc, and this header
> redefines it.

That's kind of the point: glibc sets up whatever system headers it
wants. The uapi ones are there to _help_ it, but it's not like glibc
_has_ to use them.

In fact, traditionally we didn't have any uapi header files at all,
and we just expected the system libraries to scrape them and make
their own private copies.

The uapi headers are _meant_ to make that easier, and to allow system
headers to then co-exists with the inevitable "I need to get newer
headers because I'm using a bleeding edge feature that glibc isn't
exposing" crowd.

Put another way: a very non-portable programs _could_ include the uapi
headers directly, if the system library headers were set up that way.

More commonly, what bleeding edge people do when the system header
files don't play nice, is to just build their very own libraries and
copy the bleeding-edge features directly from the kernel. So you'll
find things like

  #ifndef __NR_clone3
  #define __NR_clone3 435
  #endif

                syscall(__NR_clone3, ...);

in user space that wants to use the clone3 system call, but knows that
it hasn't made it into the glibc headers yet, so the program just
forced the local knowledge of it.

That's obviously generally easier to do with macro defines like the
above, exactly because you can trivially _test_ whether they've been
exposed or not.

So yes, this is a horrid mess.

But the *intent* is that the uapi header files should be things that
system library implementations can just use directly, and then the
"special" users could mix-and-match if everything is wonderful.

Which it seldom is.

But that's why putting those interface declarations inside a #ifdef
__KERNEL__ would completely destroy the whole point.

              Linus
