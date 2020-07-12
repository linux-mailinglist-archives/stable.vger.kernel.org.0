Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDF221CB5F
	for <lists+stable@lfdr.de>; Sun, 12 Jul 2020 22:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbgGLUii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 16:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729338AbgGLUii (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jul 2020 16:38:38 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43A4C061794
        for <stable@vger.kernel.org>; Sun, 12 Jul 2020 13:38:37 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id j11so13180714ljo.7
        for <stable@vger.kernel.org>; Sun, 12 Jul 2020 13:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gl2ce7HaAsxftBSvHTYfVjHKxjss9sGSbVqe5rk7avY=;
        b=XdGOzuYCMQf2MS3+YU13NwZGxK6zk35LUeoeXKnD4wgMvpsZR4f1qJiIA3edqzxUOI
         APpAc1SkrdtdB1sVpR+nfZN5esJJgThGv9EAPSKom0yU+I4kNIz9avLhSfpeIbrUgO8N
         jtms4zy/hQnftZTRS7OTXFDNvfm8EZQlT9LGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gl2ce7HaAsxftBSvHTYfVjHKxjss9sGSbVqe5rk7avY=;
        b=dXtFM7CfZDQfJi2c3EUjQSh0Kett+taBxEs87EZfojzFLrSeSRgu7yd3V5LngVe6qt
         fmn/IiFofOADJv5a3/8UbClShfU8SGGtxboMgosNOJDeGc3W+zQkTuwYGz8RffqshbTc
         EpV/pZ7xIdAF3KgAepTdW4PB3cnCXd6w7vkjRt0jiVKR/BdfDQTCaTQe7+Y1umUPam0o
         q/QpMeE7O/Y5rpSQ0muxYG6bhFcUlyCq71H85aN7oy/FH2nS2Z6GuUEpwwX2ITInmTjY
         tR/hjdVSGHnNGdlXyYaM7lJbtnvkezgyr08t7No5I+mpMJmNBO2eLRqIJhMak8pdrpIy
         BPIg==
X-Gm-Message-State: AOAM531WzI0w9gm/tG81M5UdFh6GMMBZRrmX0s4MI7CRVKxv87zWQ++4
        f50y7u6XEgLsoLU465iImmS1RZvjdzY=
X-Google-Smtp-Source: ABdhPJzrQmgN+RYYDTkw4pHUDj8c8FfKYBnO16CY/c7x4/JSEPSYWLTXYR+YW9esVD8Op39tYaGflw==
X-Received: by 2002:a2e:810e:: with SMTP id d14mr24506758ljg.31.1594586316186;
        Sun, 12 Jul 2020 13:38:36 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id j4sm4178274lfb.94.2020.07.12.13.38.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2020 13:38:34 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id d21so6772274lfb.6
        for <stable@vger.kernel.org>; Sun, 12 Jul 2020 13:38:34 -0700 (PDT)
X-Received: by 2002:ac2:5a5e:: with SMTP id r30mr51001288lfn.30.1594586313808;
 Sun, 12 Jul 2020 13:38:33 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
 <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
 <CA+G9fYuL=xJPLbQJVzDfXB8uNiCWdXpL=joDsnATEFCzyFh_1g@mail.gmail.com>
 <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com>
 <CA+G9fYudT63yZrkWG+mfKHTcn5mP+Ay6hraEQy3G_4jufztrrA@mail.gmail.com>
 <CAHk-=whPrCRZpXYKois-0t8MibxH9KVXn=+-O1YVvOA016fqhw@mail.gmail.com>
 <CA+G9fYusSSrc5G_pZV6Lc-LjjkzQcc3EsLMo+ejSzvyRcMgbqw@mail.gmail.com>
 <CAHk-=wj_Bqu5n3OJCnKiO_gs97fYEpdx6eSacEw2kv9YnnSv_w@mail.gmail.com> <20200712173052.GU12769@casper.infradead.org>
In-Reply-To: <20200712173052.GU12769@casper.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 12 Jul 2020 13:38:18 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiU1LR_H4zV6McCKHKJ0unX1zXLTRXfjSEW2HTDjTce0A@mail.gmail.com>
Message-ID: <CAHk-=wiU1LR_H4zV6McCKHKJ0unX1zXLTRXfjSEW2HTDjTce0A@mail.gmail.com>
Subject: Re: WARNING: at mm/mremap.c:211 move_page_tables in i386
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        William Kucharski <william.kucharski@oracle.com>,
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
        Sasha Levin <sashal@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 12, 2020 at 10:31 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> But I don't see any other way to do it.  It's not like I can put THPs
> in the page cache before fixing the things that won't work.

I agree that sometimes there are bootstrapping issues. Incremental and
explanatory commits are still better than one big commit that
introduces a whole new feature and enables it.

But if at all possible, at least limit the scope of the new feature
first, enabling the simplest possible cases as they become possible so
that there's some incremental testing, and so that bisection can say
"ok, that baseline worked, but then when XYZ happened, things went
sideways".

And even when it's a new feature - if it needs cleanup patches to
other things first, please do that. In fact, please do that as a
completely independent series that goes into a previous kernel release
entirely, so that the cleanup and preparatory patches can be
independently verified by a lot of people who run that _previous_
kernel, so that the baseline of that cleanup phase is something as
stable as possible.

             Linus
