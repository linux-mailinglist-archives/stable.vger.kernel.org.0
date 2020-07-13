Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7297F21CDE1
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 05:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgGMDvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 23:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgGMDvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jul 2020 23:51:48 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E24C061794
        for <stable@vger.kernel.org>; Sun, 12 Jul 2020 20:51:47 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id d21so7442600lfb.6
        for <stable@vger.kernel.org>; Sun, 12 Jul 2020 20:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PXZYm8YjUP841mdR1yGtgQbyBqro7EalxNIZG50LFuM=;
        b=JZ6Y3SBEjypR0Q/yrJj53ldh8gpnRfjQF/RT1b64yjpHydiLr0yIS3u64B/OW5XJ4/
         tBqykrHxUwjAHq0UxLcdms0xudmr7CC4BSdN8v+rXw8M+XyIrWJaQmCLkL9Q4eyPIlNw
         tfry+uqmdsBjisvh7Qv+FSefQ995KqX6/6xdY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PXZYm8YjUP841mdR1yGtgQbyBqro7EalxNIZG50LFuM=;
        b=dZqMmYkTqtEQr0Zjva05TagilK12LKtIrV2RHrAYmx/e97lCjrWGBdwpPMyhvN6pvL
         cqEOwsvPGW8RVsgS4IJitfpdWhU7F6u4tzk5paaniRbr0lRhY/AgZ6HeJ6KEW8U+woll
         PMJf7UvxuJ0yOwt2yKGKgVYxzVZn6GdHyYLyZM6Uz9EIgjtIxX+2rvgXnsvOm68LgrIG
         dDXaxYILHtbEatqk8M/IKvp38276jCaGNt4nWN4s1llOpSGOWuWJbZjAFhaqA3gXFuhI
         782cOwJTVra/OVBDyPguyHl5p2Xsb4MAprQG86rABH2b2vGDbzIIsFrNYdEDupAsW/4K
         ywtQ==
X-Gm-Message-State: AOAM5337s+5nH/0JaCBgrSobB/wv04QC5lLff2ZF3mwXZT6UoQGnLmoq
        obcyrLPsAwmXYWbVRh3QAsuz1kAGYig=
X-Google-Smtp-Source: ABdhPJyyWHsYFnW5R4sKuKpr17185Kr7wxmh6E2+cgmygV2ZSs66VEyasq48YZB80ZOp75CCd6+SXw==
X-Received: by 2002:a19:90:: with SMTP id 138mr51465907lfa.100.1594612304684;
        Sun, 12 Jul 2020 20:51:44 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id r25sm4339786lfi.70.2020.07.12.20.51.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2020 20:51:43 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id s16so7417392lfp.12
        for <stable@vger.kernel.org>; Sun, 12 Jul 2020 20:51:43 -0700 (PDT)
X-Received: by 2002:ac2:5a5e:: with SMTP id r30mr51926816lfn.30.1594612302784;
 Sun, 12 Jul 2020 20:51:42 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
 <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
 <CA+G9fYuL=xJPLbQJVzDfXB8uNiCWdXpL=joDsnATEFCzyFh_1g@mail.gmail.com>
 <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com>
 <20200712215041.GA3644504@google.com> <CAHk-=whxP0Gj70pJN5R7Qec4qjrGr+G9Ex7FJi7=_fPcdQ2ocQ@mail.gmail.com>
 <20200713025354.GB3644504@google.com>
In-Reply-To: <20200713025354.GB3644504@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 12 Jul 2020 20:51:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=whmbpZN6-Q=8cDM42UmHmqzgNDucLLP4BvR1jQ73+KSgw@mail.gmail.com>
Message-ID: <CAHk-=whmbpZN6-Q=8cDM42UmHmqzgNDucLLP4BvR1jQ73+KSgw@mail.gmail.com>
Subject: Re: WARNING: at mm/mremap.c:211 move_page_tables in i386
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>,
        lkft-triage@lists.linaro.org, Chris Down <chris@chrisdown.name>,
        Michel Lespinasse <walken@google.com>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Brian Geffon <bgeffon@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, pugaowei@gmail.com,
        Jerome Glisse <jglisse@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 12, 2020 at 7:53 PM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> > But I do feel like you figured out why the bug happened, now we're
> > just discussing whether the patch is the right thing to do.
>
> Yes.
>
> > Maybe saying "doing the pmd copies for the initial stack isn't
> > important, so let's just note this as a special case and get rid of
> > the WARN_ON()" might be an alternative solution.
>
> Personally, I feel it is better to keep the warning just so in the future we
> can detect any bugs.

I don't disagree, the warning didn't happen to find a bug now, but it
did fine a case we might be able to do better.

So now that I feel we understand the issue, and it's not a horrible
problem, just a (very hard to trigger) warning, I don't think there's
any huge hurry.

I think think I will - for now - change the WARN_ON() to
WARN_ON_ONCE() (so that it doesn't floow the logs if somebody triggers
this odd special case  this malisiously), and add a note about how
this happens to the code for posterito.

And if/when you figure out a better way to fix it, we can update the note.

Ok?

             Linus
