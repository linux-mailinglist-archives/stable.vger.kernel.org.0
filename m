Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10EE948B776
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 20:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237077AbiAKTkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 14:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236898AbiAKTkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 14:40:35 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4141DC06173F
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 11:40:35 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id k21so538508lfu.0
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 11:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=72nCaH0D5cVWOpCSRc18GR2eFwD5HF2lWhLZ438H8+E=;
        b=IbI2Ue6xwevdXzForB3sPC7JLpGCLW4aJaiaqGPQM519ZpN4Iw53D7dK6TEvItwJQM
         lU0w7yPNWbufVbo7aTy0WNF/06ot4HROv5RcW7EH+B/47POEIinAhzsJIzijm2pqH0rA
         32W/JrQJcTgkaHK2M1qJ6iERelYscbkX2JYhs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=72nCaH0D5cVWOpCSRc18GR2eFwD5HF2lWhLZ438H8+E=;
        b=UIvwaFzP4Z4GyDFcgvg8hmzsSi8tC1+Rs5w1J4VSJHncXZFHK8ZZjpphMajvFprTpI
         ExU1ONYiH8cWjzgr+F1Uv1+crBTXpxCjzJgdMe9MwEcJvQAGHHNbrFJKc4n/RqssP1Z6
         7KOnYoT039sb9D8Uoua0lqSrQ+AwwmyJhE1TJ/uVSgGVmayIhgRgzjBWXWFFexK6gh9C
         ODZZGiZLo6EE8Wxs2dRvMLsE606Wd9TQKoOD87VeABcwY2LXg+eVDUpT8fpXtgzxRas5
         cY1ZKP9VETxQgNAf8ecGdUYJ3yseMEXuJwlfOynsznrVUTCxnK+CRrpiJ/daUoO1Lt+D
         g6ZQ==
X-Gm-Message-State: AOAM531STVtoqBBlDmeaDWPaGW8XHp7fgbRi+pOyw8g/akwavRVmixKC
        BcKvYvUVQSA9H6EBFsYNveFlCgowko+BM3sKQYY=
X-Google-Smtp-Source: ABdhPJw447/C4kNT1tgehEwRPkA6AKBpo2tNFbm7m1Scbx7YYWpm5G9euUO+WwZ5eUTi6Jmbmzu9uw==
X-Received: by 2002:a05:6512:3311:: with SMTP id k17mr4373989lfe.392.1641930033458;
        Tue, 11 Jan 2022 11:40:33 -0800 (PST)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id j4sm1425976lfg.147.2022.01.11.11.40.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 11:40:33 -0800 (PST)
Received: by mail-lf1-f47.google.com with SMTP id j11so393534lfg.3
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 11:40:33 -0800 (PST)
X-Received: by 2002:adf:c74e:: with SMTP id b14mr5117431wrh.97.1641929709117;
 Tue, 11 Jan 2022 11:35:09 -0800 (PST)
MIME-Version: 1.0
References: <20220111071212.1210124-1-surenb@google.com> <Yd3RClhoz24rrU04@sol.localdomain>
 <CAHk-=wgwb6pJjvHYmOMT-yp5RYvw0pbv810Wcxdm5S7dWc-s0g@mail.gmail.com> <CAJuCfpE3feNU=36qRUdCJsk41rxQBv1gRYy5R1dB1djMd0NLjg@mail.gmail.com>
In-Reply-To: <CAJuCfpE3feNU=36qRUdCJsk41rxQBv1gRYy5R1dB1djMd0NLjg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 11 Jan 2022 11:34:53 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj9-9mFcoaD3rdHd+HKYpyTXkkE2iJkPoTTCrp-+sD=ew@mail.gmail.com>
Message-ID: <CAHk-=wj9-9mFcoaD3rdHd+HKYpyTXkkE2iJkPoTTCrp-+sD=ew@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
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

On Tue, Jan 11, 2022 at 11:27 AM Suren Baghdasaryan <surenb@google.com> wrote:
>
> Thanks for the explanation!
> So, it sounds like the best (semantically correct) option I have here
> is smp_store_release() to set the pointer, and then smp_load_acquire()
> to read it. Is my understanding correct?

Yeah, that's the clearest one from a memory ordering standpoint, and
is generally also cheap.

                Linus
