Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4007E21BE46
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 22:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgGJUFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 16:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbgGJUFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 16:05:47 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DEEC08C5DC
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 13:05:46 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id y18so3861455lfh.11
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 13:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rOjG8jOG5e2cka7UROrnmdRc1ZeKdWqp04+UTzezgXE=;
        b=WmpCdav5rACJPM1yVreaa5jhIE1Rj0RGr/bF1Qjr1pwf2439Iz5WoGFXdSi5O12Dr5
         IXWc1w8QTxV3dD+bOVtIv3lKjedZWexuqrhZTiipy7sQHNTW5whUuBZMflnCtZWXFq8v
         f4lJqs3GKRsPnpqvfmvNw1KFo/5w8EYLFRpdo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rOjG8jOG5e2cka7UROrnmdRc1ZeKdWqp04+UTzezgXE=;
        b=WpEpPw+9gah7TDed+3lfYxZe6pt7YnphRZfIjK2vfO8PscY4xs8J7A3adX4uA9vQQa
         FDZYf+Glug886brbY7W+NC6ScXAFlxniZqu2A8OKWO3XOaEDaqQYPG83hQelip/driCX
         f0SeyxLcaV8NIfmHwN5s1iWYmkiaTA3BiATnWIX9B0wtw8i11P3vmBt0qE8YBJzPscBj
         lv2H0sDY3N9iX6eCQNAkA3WJhXQ1rIaFiBKoyNBBskbZt9D+25m/rSg6IKwFBIrianpg
         rjF/RAAmOFYmOcxFTU5rRz81euew0eZZprfL/LQAPA13BmnA9um2/jm3zQfatGWss8H9
         SOAA==
X-Gm-Message-State: AOAM533BHJoSn9uR7iFo80uat46KH7YoHNtScq4tkhcvhXaApVBD/mGZ
        4Qk1VFHNhhyRRBgSwb8stUxbX/iHYNc=
X-Google-Smtp-Source: ABdhPJwQdhZEE3m3iztF3GVFvEL340Ap0bXYpr/XjCG8d0XTk7hiajFP5Vbd7gVDDrJuIB+F1+2ayg==
X-Received: by 2002:a05:6512:3082:: with SMTP id z2mr31617849lfd.78.1594411544694;
        Fri, 10 Jul 2020 13:05:44 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id z23sm2228323ljz.3.2020.07.10.13.05.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 13:05:43 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id 9so7781195ljv.5
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 13:05:43 -0700 (PDT)
X-Received: by 2002:a2e:9b42:: with SMTP id o2mr40061229ljj.102.1594411542731;
 Fri, 10 Jul 2020 13:05:42 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
 <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
 <CA+G9fYuL=xJPLbQJVzDfXB8uNiCWdXpL=joDsnATEFCzyFh_1g@mail.gmail.com>
 <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com> <CA+G9fYudT63yZrkWG+mfKHTcn5mP+Ay6hraEQy3G_4jufztrrA@mail.gmail.com>
In-Reply-To: <CA+G9fYudT63yZrkWG+mfKHTcn5mP+Ay6hraEQy3G_4jufztrrA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Jul 2020 13:05:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=whPrCRZpXYKois-0t8MibxH9KVXn=+-O1YVvOA016fqhw@mail.gmail.com>
Message-ID: <CAHk-=whPrCRZpXYKois-0t8MibxH9KVXn=+-O1YVvOA016fqhw@mail.gmail.com>
Subject: Re: WARNING: at mm/mremap.c:211 move_page_tables in i386
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux- stable <stable@vger.kernel.org>,
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
        Joel Fernandes <joel@joelfernandes.org>,
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

On Fri, Jul 10, 2020 at 10:48 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> I have applied your patch and test started in a loop for a million times
> but the test ran for 35 times. Seems like the test got a timeout after 1 hour.

That just means that my test-case was wrong (in the sense that what it
was testing wasn't what was triggering things).

It might be wrong because I got the stack usage calculations wrong,
but it might be wrong simply because the bug you've triggered with LTP
needs something else to trigger.

> Re-running test with long timeouts 4 hours and will share findings.

That test was more intended to trigger the issue reliably, if it was
just a "stack is special, needs that exact 2MB aligned case to be
problematic".

So re-running my "t.c" the test for long times with that kernel patch
that removes the stack randomization isn't going to matter. Either it
triggers the case, or not.

I don't actually see any case where we play with vm_start the way we
used to (it was basically removed with commit 1be7107fbe18: "mm:
larger stack guard gap, between vmas"). So it was kind of a log shot
anyway.

              Linus
