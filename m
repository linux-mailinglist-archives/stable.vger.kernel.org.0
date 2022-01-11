Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0896748B738
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 20:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243833AbiAKTUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 14:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350535AbiAKTUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 14:20:01 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FE8C033272
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 11:18:53 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id a18so288651edj.7
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 11:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B44bvcGMR7HJrF8RjjxVk6yTIMoiYipBLak96y+Vc5U=;
        b=b2vOkvqM6CrU97KTnO6tCUMPeqtx4Tb9raQiqg+DsCBvIm5TjoldAmKmEfiOSjOJi8
         Q2wHU19wTfiKrO4kFP5KoxmIJN/5uCNBtFVo+DFeoT5q8s6S7/g7wbRMshY/F57KQpZc
         HByWVJ89WRq9xPL/+lWSfsSWUMQUEeyGZRwaA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B44bvcGMR7HJrF8RjjxVk6yTIMoiYipBLak96y+Vc5U=;
        b=eY62Yjrc/chmoRoWiaiAkEZCJa0q7dcUNKm2NPcfosD+6HLaOZGXQmlPcIk+8RjC34
         hfyg4KMAWWNdVrgOwFsGlwOH8+aZ3kr+WtzYPbW1Zp9UiLw/v8THMnk1dgYpOcTHllgL
         9nqlQYWY9icl1akzP4EroeEKIw7HHy7tnt3x5lDgXBoofpvPKl/yrEH6yCauEaIZW2rP
         pOpbobRlQTop2UDnZWwNAqfGx3KbN0M49mNrhoNDXJacSsjlkTNrMZxdmBdBrJQiqmKI
         e8MpLq5QQnaw4lCyQdxukq+3JNfVWD68PwWWCLTlZ7sL0/mOccywQqOhaZym1qbuKqBe
         xU8w==
X-Gm-Message-State: AOAM530/aDd2IImbqUVmzZ0MYzigTZ5s8wV4oQ4x+POTX0wp9rkTYrqX
        uymDLHoE5YoNNKVz6KE81fCY3UWk04IzCSBDmx8=
X-Google-Smtp-Source: ABdhPJwBfVOr540ZQ05VbdOpN7aRhKQgnqoT0KBvYHdI7OP2O7NXZsjw9bPM2B+ixyLgcslGbXC2Og==
X-Received: by 2002:a17:906:d555:: with SMTP id cr21mr5055345ejc.299.1641928731670;
        Tue, 11 Jan 2022 11:18:51 -0800 (PST)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id 21sm3831365ejx.83.2022.01.11.11.18.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 11:18:51 -0800 (PST)
Received: by mail-ed1-f46.google.com with SMTP id z22so193365edd.12
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 11:18:51 -0800 (PST)
X-Received: by 2002:a5d:6083:: with SMTP id w3mr1539236wrt.281.1641928308184;
 Tue, 11 Jan 2022 11:11:48 -0800 (PST)
MIME-Version: 1.0
References: <20220111071212.1210124-1-surenb@google.com> <Yd3RClhoz24rrU04@sol.localdomain>
In-Reply-To: <Yd3RClhoz24rrU04@sol.localdomain>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 11 Jan 2022 11:11:32 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgwb6pJjvHYmOMT-yp5RYvw0pbv810Wcxdm5S7dWc-s0g@mail.gmail.com>
Message-ID: <CAHk-=wgwb6pJjvHYmOMT-yp5RYvw0pbv810Wcxdm5S7dWc-s0g@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Suren Baghdasaryan <surenb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        syzbot <syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 11, 2022 at 10:48 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> The write here needs to use smp_store_release(), since it is paired with the
> concurrent READ_ONCE() in psi_trigger_poll().

A smp_store_release() doesn't make sense pairing with a READ_ONCE().

Any memory ordering that the smp_store_release() does on the writing
side is entirely irrelevant, since the READ_ONCE() doesn't imply any
ordering on the reading side. Ordering one but not the other is
nonsensical.

So the proper pattern is to use a WRITE_ONCE() to pair with a
READ_ONCE() (when you don't care about memory ordering, or you handle
it explicitly), or a smp_load_acquire() with a smp_store_release() (in
which case writes before the smp_store_release() on the writing side
will be ordered wrt accesses after smp_load_acquire() on the reading
side).

Of course, in practice, for pointers, the whole "dereference off a
pointer" on the read side *does* imply a barrier in all relevant
situations. So yes, a smp_store_release() -> READ_ONCE() does work in
practice, although it's technically wrong (in particular, it's wrong
on alpha, because of the completely broken memory ordering that alpha
has that doesn't even honor data dependencies as read-side orderings)

But in this case, I do think that since there's some setup involved
with the trigger pointer, the proper serialization is to use
smp_store_release() to set the pointer, and then smp_load_acquire() on
the reading side.

Or just use the RCU primitives - they are even better optimized, and
handle exactly that case, and can be more efficient on some
architectures if release->acquire isn't already cheap.

That said, we've pretty much always accepted that normal word writes
are not going to tear, so we *have* also accepted just

 - do any normal store of a value on the write side

 - do a READ_ONCE() on the reading side

where the reading side doesn't actually care *what* value it gets, it
only cares that the value it gets is *stable* (ie no compiler reloads
that might show up as two different values on the reading side).

Of course, that has the same issue as WRITE_ONCE/READ_ONCE - you need
to worry about memory ordering separately.

> > +     seq->private = new;
>
> Likewise here.

Yeah, same deal, except here you can't even use the RCU ones, because
'seq->private' isn't annotated for RCU.

Or you'd do the casting, of course.

              Linus
