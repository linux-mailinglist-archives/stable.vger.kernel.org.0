Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A8E1A12D9
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 19:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgDGRkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 13:40:05 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40837 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgDGRkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 13:40:04 -0400
Received: by mail-lj1-f193.google.com with SMTP id 142so141119ljj.7
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 10:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ex03nfQpPCZeA5+yn7tSblnxDu6ASBCOFJtNAPyZWrM=;
        b=QOrZewsDVgAhhR0NNMGT6ZzX6PUyBuqHSlmSqH9UdRXoM3m03w5yTICDKyAVbPwqQQ
         99crxFriNn197nfvF7GUfYQJ1jLRgRuOcN5ENFuMnI4E37VyA4O+Ve1f8JFqOeCIM15W
         8p40DbVI2SvKuc1+5O3tfXMav7+0XIUi5G4JA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ex03nfQpPCZeA5+yn7tSblnxDu6ASBCOFJtNAPyZWrM=;
        b=ltODn2bdTM6/BPeQRPGVywTKZ6G6AB8UBZ8ZsOPVKGtU847+RELixlBGuURczGha2u
         ZaeApnjfYiAv3LZPB0y5f2QaCEMwgE297qjKwHUmlyOjHH+0K6lGIfgO3ChS7ZOxSyRn
         5inBotLQj5NKTt7QkiJF/b05LLLQm9RjTwtUoOlaUnH7DLC8iQBTg+ZFKhD7NbNzuXPM
         BzUCOfVLDiQ0UqiUGaBKTgKUkglOSeZ7KjL5fk5GdNy+pQJd5LbWw8RTF4sawOumXT+a
         mB4YlLet01DcwxUghJoa9knyCeFrl0lBsYysq9dnRVcetNnPut+Fn9wG/alRko128Mbo
         f+MQ==
X-Gm-Message-State: AGi0PuY2UCt082+UK5myIyug/68jKqfHrVLZcZ0IZVcRL6srDYkWsPx2
        C6XFN6SY0WpkzL7mEvNt0CaXopXez2c=
X-Google-Smtp-Source: APiQypL1jzzRsKbBlG1HvVsBgk+5qAZnAIEfuZYPI+cbgtVca1gx0fEHc9LHbrVJetvvbFoGOifUmg==
X-Received: by 2002:a2e:b018:: with SMTP id y24mr2493967ljk.268.1586281199314;
        Tue, 07 Apr 2020 10:39:59 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id f28sm13644020lfh.10.2020.04.07.10.39.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 10:39:58 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id r24so4711268ljd.4
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 10:39:57 -0700 (PDT)
X-Received: by 2002:a2e:b4cb:: with SMTP id r11mr2493242ljm.201.1586281196972;
 Tue, 07 Apr 2020 10:39:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
 <20200407031042.8o-fYMox-%akpm@linux-foundation.org> <CAHk-=wi1h-wBC3Kg2qBhs_R1UGyocGq0cT1eO+12pwBsO+d1ww@mail.gmail.com>
 <158627540139.8918.10102358634447361335@build.alporthouse.com> <CAHk-=wjTmay+NhnZ5Q+GM9buDioT0ie8njJgcquTFGD_qQhXpw@mail.gmail.com>
In-Reply-To: <CAHk-=wjTmay+NhnZ5Q+GM9buDioT0ie8njJgcquTFGD_qQhXpw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 Apr 2020 10:39:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wirjD+SAZWsUDfJAYHc4DSrwV89c9uDdmdoHTF2S2sFfQ@mail.gmail.com>
Message-ID: <CAHk-=wirjD+SAZWsUDfJAYHc4DSrwV89c9uDdmdoHTF2S2sFfQ@mail.gmail.com>
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

On Tue, Apr 7, 2020 at 10:28 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> There may be something really subtle going on, but it really smells
> like "two threads are modifying the same list at the same time".
>
> And there's no way that the READ_ONCE() will fix that bug, it will
> only make KASAN shut up about it.

[ And by KASAN I obviously meant KCSAN every time ]

An alternative is that it's just a KCSAN bug or false positive for
some other reason. Which is possible. But the more I look at this, the
more I think you really have a bug in your list handling.

I'm just not convinced the whole "we have a race where we randomly add
a tail object" in another thread is a valid reason for making those
"safe" list accessors use READ_ONCE.

The thing is, they were never designed to be safe wrt concurrent
accesses. They are safe from the _same_ thread removing the current
entry, not from other threads changing the entries - whether it be the
last one or not.

Because if _another_ thread removes (or adds) an entry, you have a
whole new set of issues. READ_ONCE() isn't sufficient. You need to
have memory ordering guarantees etc.

For example, the thread that adds another entry that might - or might
not - be visible without locking, would have to fully initialize the
entry, and set the ->next pointer on it, before it adds it to the
list.

I suspect you could use the RCU list walkers for a use-case like this.
So __list_add_rcu() for example uses the proper rcu_assign_pointer()
(which uses smp_store_release()) to make sure that the newly added
entry is actually _ordered_ wrt the stores to the entry.

But the "safe" list functions simply do not have those kinds of
ordering guarantees, and doing concurrent list_add() simply *CANNOT*
be right. Adding a READ_ONCE() does not in any way make it right
(although it might work in practice on x86).

               Linus
