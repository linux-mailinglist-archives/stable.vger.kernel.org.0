Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995EA1E7282
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 04:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404988AbgE2CSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 22:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404786AbgE2CSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 22:18:01 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82361C08C5C7
        for <stable@vger.kernel.org>; Thu, 28 May 2020 19:17:59 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id v16so638629ljc.8
        for <stable@vger.kernel.org>; Thu, 28 May 2020 19:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vJ9gTWfjqaGlpCPsXTDGoSd7Y0WPXEnUn4OlpmNxO6I=;
        b=c+VYr0ZVdU3iMPGuzHmmoxf6LEmKKBoJczjatsGoUG8CGFdTOy3VWdUN/y2iKgZF6J
         /PTpay60je5Kj8cZtv20gACm1Qw1CVeZL+zjTZJpv7PmnbYnkLSn6/o3vpYedc/tbmB3
         v3vhimV/M/mZn2nQBihFznTL5ciTjwDDfoGww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vJ9gTWfjqaGlpCPsXTDGoSd7Y0WPXEnUn4OlpmNxO6I=;
        b=X6EuHbgPqS3Vd1vLSZl987Pl6SMDKJ/njJe4j1D/+jCrlYPQbeLNWyOS0eIP6A3IbW
         jhOoR684ChPBHU68G8AHh71kHHy5u6RE2w2+y3RnSMri2L6GTFuRPcYYuKWo/+aoAV/7
         LYyKkMWvndWsmMgh9diTXQfNa+LKnSEIelgtjjkRPg7/cylNC90O5Hg4IeaTR0UvwO2o
         +Mn0qxPNtXm0PbTbunDMOb+TaRJYz2lOSjMbmURh/pz8VeV1pg78U2/zkWbWA7P6nxpp
         gOHOdqxXMCrFsCObotZ5AO8gGCcczPRD9vVUXBCW91Vba7Se5aFaYN6ygvWFBbTYSkiv
         INeQ==
X-Gm-Message-State: AOAM533CAXjAWde/tRWLjO36JG5INrxIm4wSSddzxlx1EgF/vmdlbc/k
        PMOertsV0e5nvydWbs1ddDCnmJeZdH0=
X-Google-Smtp-Source: ABdhPJy+eg+UXcPVKpTftFgzlA/mPLAQ/Q0akEVGnJSfBGPyeMMHzZyonLqoZk7LaQh2dmLwKIlvSw==
X-Received: by 2002:a2e:b4a5:: with SMTP id q5mr1332379ljm.186.1590718676140;
        Thu, 28 May 2020 19:17:56 -0700 (PDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id l15sm1737365ljc.73.2020.05.28.19.17.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 19:17:55 -0700 (PDT)
Received: by mail-lj1-f175.google.com with SMTP id b6so682511ljj.1
        for <stable@vger.kernel.org>; Thu, 28 May 2020 19:17:54 -0700 (PDT)
X-Received: by 2002:a2e:9f43:: with SMTP id v3mr3141974ljk.285.1590718674086;
 Thu, 28 May 2020 19:17:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200528135552.GA87103@google.com> <CAHk-=wjgtD6drydXP5h_r90v0sCSQe7BMk7AiYADhJ-x9HGgkg@mail.gmail.com>
 <20200528230859.GB225299@google.com> <CAHk-=whf6b=OijDL=+PUTBsrhURzLZQ5xAq5tWDqOQpTmePFDA@mail.gmail.com>
 <20200529014524.GA38759@google.com>
In-Reply-To: <20200529014524.GA38759@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 28 May 2020 19:17:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgO86MS-=G2D=aDpOvZVYARD2kBZ43sofX6WwK0OAzmwg@mail.gmail.com>
Message-ID: <CAHk-=wgO86MS-=G2D=aDpOvZVYARD2kBZ43sofX6WwK0OAzmwg@mail.gmail.com>
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 28, 2020 at 6:45 PM Joel Fernandes <joel@joelfernandes.org> wrote:
>
>  glibc's <sched.h> already defines struct sched_param (which is a POSIX
>  struct), so my inclusion of <linux/sched/types.h> above which is a UAPI
>  header exported by the kernel, breaks because the following commit moved
>  sched_param into the UAPI:
>  e2d1e2aec572a ("sched/headers: Move various ABI definitions to <uapi/linux/sched/types.h>")
>
>  Simply reverting that part of the patch also fixes it, like below. Would
>  that be an acceptable fix? Then I can go patch glibc to get struct
>  sched_attr by including the UAPI's <linux/sched/types.h>. Otherwise, I
>  suspect glibc will also break if it tried to include the UAPI header.

Hmm.

Reverting that commit makes some sense as a "it broke things", and
yes, if this was some recent change that caused problems with user
headers, that would be what we should do (at least to then think about
it a bit more).

But that commit was done three years ago and you're the first person
to report breakage.

So for all I know, modern glibc source bases have already fixed
themselves up, and take advantage of the new UAPI location. Or they
just did that kernel header sync many years ago, and will fix it up
the next time they do a header sync.

So then reverting things (or adding the __KERNEL__ guard) would only
break _those_ cases instead and make for only more problems.

Basically, I think you should treat this as a glibc header bug, not a
kernel header bug.

And when you say

> The reason is, since <sched.h> did not provide struct sched_attr as the
> manpage said, so I did the include of uapi's linux/sched/types.h myself:

instead of starting to include the kernel uapi header files - that
interact at a deep level with those system header files - you should
just treat it as a glibc bug.

And then you can either work around it locally, or make a glibc
bug-report and hope it gets fixed that way.

The "work around it locally" might be something like a
"glibc-sched-h-fixup.h" header file that does

  #ifndef SCHED_FIXUP_H
  #define SCHED_FIXUP_H
  #include <sched.h>

  /* This is documented to come from <sched.h>, but doesn't */
  struct sched_attr {
        __u32 size;

        __u32 sched_policy;
        __u64 sched_flags;

        /* SCHED_NORMAL, SCHED_BATCH */
        __s32 sched_nice;

        /* SCHED_FIFO, SCHED_RR */
        __u32 sched_priority;

        /* SCHED_DEADLINE */
        __u64 sched_runtime;
        __u64 sched_deadline;
        __u64 sched_period;

        /* Utilization hints */
        __u32 sched_util_min;
        __u32 sched_util_max;

  };
  #end /* SCHED_FIXUP_H */

in your build environment (possibly with configure magic etc to find
the need for this fixup, depending on how fancy you want to be).

Because when we have a change that is three+ years old, we can't
reasonably change the kernel back again without then likely just
breaking some other case that depends on that uapi file that has been
there for the last few years.

glibc and the kernel aren't developed in sync, so glibc generally
takes a snapshot of the kernel headers and then works with that. That
allows glibc developers to work around any issues they have with our
uapi headers (we've had lots of namespace issues, for example), but it
also means that the system headers aren't using some "generic kernel
UAPI headers". They are using a very _particular_ set of kernel uapi
headers from (likely) several years ago, and quite possibly then
further edited too.

Which is why you can't then mix glibc system headers that are years
old with kernel headers that are modern (or vice versa).

Well, with extreme luck and/or care you can. But not in general.

                Linus
