Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 627621A166E
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 22:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgDGUEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 16:04:44 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41339 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbgDGUEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 16:04:44 -0400
Received: by mail-lj1-f194.google.com with SMTP id n17so5144616lji.8
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 13:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wkftfDZ88z74IMrEpi4bLp+mSOTuhVJsLPyxO6YFQQY=;
        b=PtNK8HACtoVIgsmxwYUTR+Aieqcw4+DsYktfEMrpftyDy/JCtdcK+xAcrtkS5OtIS8
         iAfRqDo6l7Jsft0L0hK4UNgNJriH8zF7FQAQGln2z36HWakUUW7XGWz9KQqFzWzqwgoL
         3byFgErfhA2uq8lHnVO/9GCldYYCBqoFrQheg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wkftfDZ88z74IMrEpi4bLp+mSOTuhVJsLPyxO6YFQQY=;
        b=JptO1qtclv/1900uIV86JNHYvzFJZ4ZSNqqf0PVJ86H0TjkquiQi1AuPHzTRhCnAUa
         T8iafibCS6V0XK5j0A4S5r7/BXFrnkKEQehxPM7+3otw7+VcKYz/HlUC5UjB7shDduGu
         Yw1D64gSVrAXvTFTRE3tAaVEWPkOY14CDIFRNeW8xCDGlcmM+JJNoE8SH1dRLdKTDU4V
         VmYsTTTULRf7W+UYym3xXIJpChS4slDp6LOGVyoTirORk5qkWAA3Mp76Yy4bYemzySmS
         EbmYQudKoulsOhKfsS/GycZJUuAbf16wur6pHDCmXxsOwxmq9jsIZlr783A4JHpMqZlq
         j0kQ==
X-Gm-Message-State: AGi0PuZ0Z1Ja9bpzPPrNsEBie1BDclCe9M+8PmZtZrTLQ4YuSnE1Ylvw
        NQaNdFJzStDhWUp6Ck0bbF+RwRzyKFM=
X-Google-Smtp-Source: APiQypIykWvT7k2VTe//xqCUr5kL78XA0GMY4H8IKltpflgZDW+qnSH+RuSI5R2QrQ+AcsOiE4fldw==
X-Received: by 2002:a05:651c:452:: with SMTP id g18mr2777616ljg.224.1586289881151;
        Tue, 07 Apr 2020 13:04:41 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id t6sm13758853lfb.55.2020.04.07.13.04.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 13:04:40 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id 131so3342680lfh.11
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 13:04:40 -0700 (PDT)
X-Received: by 2002:a19:9109:: with SMTP id t9mr2487716lfd.10.1586289879733;
 Tue, 07 Apr 2020 13:04:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
 <20200407031042.8o-fYMox-%akpm@linux-foundation.org> <CAHk-=wi1h-wBC3Kg2qBhs_R1UGyocGq0cT1eO+12pwBsO+d1ww@mail.gmail.com>
 <158627540139.8918.10102358634447361335@build.alporthouse.com>
 <CAHk-=wjTmay+NhnZ5Q+GM9buDioT0ie8njJgcquTFGD_qQhXpw@mail.gmail.com> <158628265081.8918.1825514020221532657@build.alporthouse.com>
In-Reply-To: <158628265081.8918.1825514020221532657@build.alporthouse.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 Apr 2020 13:04:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj84K2AZNA-qc5DdCo2zUQiSOTK0DOf02KYgPOhw2-DDQ@mail.gmail.com>
Message-ID: <CAHk-=wj84K2AZNA-qc5DdCo2zUQiSOTK0DOf02KYgPOhw2-DDQ@mail.gmail.com>
Subject: Re: [patch 125/166] lib/list: prevent compiler reloads inside 'safe'
 list iteration
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Laight <David.Laight@aculab.com>,
        Marco Elver <elver@google.com>, Linux-MM <linux-mm@kvack.org>,
        Mark Rutland <mark.rutland@arm.com>,
        mm-commits@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 7, 2020 at 11:04 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> That submission can run concurrently to the list iteration, but only
> _after_ the final list_del.

There is no such thing, Chris.

Not without locks and memory ordering.

The "list_del()" is already ordered on the CPU it happens.

And _there_ it's already ordered with the list_for_each_entry_safe()
by the compiler.

> > There may be something really subtle going on, but it really smells
> > like "two threads are modifying the same list at the same time".
>
> In strict succession.

See above.

There is no such thing as strict succession across two CPU's unless
you have memory barriers, locks, or things like release/acquire
operations.

So a "strict succession from list_del()" only makes sense on the
_local_ CPU. Not across threads.

You may be relying on some very subtle consistency guarantee that is
true on x86. For example, x86 does guarantee "causality".

Not everybody else does that.

> There's some more shutting up required for KCSAN to bring the noise down
> to usable levels which I hope has been done so I don't have to argue for
> it, such as

Stop using KCSAN if you can't deal with the problems it introduces.

I do NOT want to see bogus patches in the kernel that are introduced
by bad infrastructure.

That READ_ONCE() is _wrong_.

File a bug with the KCSAN people, don't send garbage upstream.

               Linus
