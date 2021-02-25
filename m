Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1823A3254F4
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 18:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbhBYR4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 12:56:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbhBYRzj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 12:55:39 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEBEC061574
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 09:54:52 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id v17so7460707ljj.9
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 09:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q6fnMFz33qplfRqMB+HqqUvPdR34RqJh36nDC5TsifM=;
        b=GFIFnYEHkDWCJeUWtVcHjzxrKHzPSC845ICu8hcYMqCsuUHUMYhmhM6A8qllmj2wvF
         TeD+nXiix4KfoCrm2ttxL6EfZmKtzW+4tjcpl0pa/DNpOjMdlXHpNVfbq1N7k4QYkskP
         rPYDh0IFTsvGod5noex2WbDs0vYWj0YFRCsRo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q6fnMFz33qplfRqMB+HqqUvPdR34RqJh36nDC5TsifM=;
        b=V/Om2yECWjUJVXN5wvcQtYbac/zCU2DcGQ+SeshFYsA3baK0XQrPR+dblRFCJqmRPD
         Ok91KHCdtWhY5yqysqEIDyS6BCW3SOQtMS9yn/zevA+6HJdmEaf3IDleimPxUg1yARCV
         JaYn6FcRZpnYzEG1CPwknPZPMT7YIKPhRgS9YiJx/ULyDVaj17NGBiIdld4s8B3ZSBcm
         BMIeiq/KRMbqEEUId5qE3se8a2xy6WxMceffYhfJNvuyk6L5YN/Anq67c8c6l4bd56nG
         Xkb0n6JwZ2/gy7A63nlErWAxMKlkgnuQYMSzCBq267bAwgXVztN2eUjMi1wp86q0oT5X
         bw/g==
X-Gm-Message-State: AOAM5307sTlCNXUlNimGKDjj0pFoH4LEbdguLX8Y1a2RgZPHjrq2jT7C
        Et8Y9b4Ngzlaa0vIEgjU5M8zwqUNmZTwiw==
X-Google-Smtp-Source: ABdhPJzqN9p7Rcq36ij1EQ3TRfRKAeGHX6BPag6lZHRU/jcUG7u7kVkSauOpSgwp0qhVcs6qYIJg4Q==
X-Received: by 2002:a2e:7403:: with SMTP id p3mr2213258ljc.35.1614275691152;
        Thu, 25 Feb 2021 09:54:51 -0800 (PST)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id l6sm168691lfp.13.2021.02.25.09.54.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 09:54:50 -0800 (PST)
Received: by mail-lf1-f41.google.com with SMTP id w36so9880382lfu.4
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 09:54:50 -0800 (PST)
X-Received: by 2002:a05:6512:398d:: with SMTP id j13mr2392819lfu.41.1614275689864;
 Thu, 25 Feb 2021 09:54:49 -0800 (PST)
MIME-Version: 1.0
References: <20210224153950.20789-1-rppt@kernel.org> <20210224153950.20789-2-rppt@kernel.org>
 <515b4abf-ff07-a43a-ac2e-132c33681886@redhat.com> <20210225170629.GE1854360@linux.ibm.com>
In-Reply-To: <20210225170629.GE1854360@linux.ibm.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 25 Feb 2021 09:54:34 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj-0TeNTNhn+r8c9n76uy8ZiYw03AnXz3hyDZ_rQu35Uw@mail.gmail.com>
Message-ID: <CAHk-=wj-0TeNTNhn+r8c9n76uy8ZiYw03AnXz3hyDZ_rQu35Uw@mail.gmail.com>
Subject: Re: [PATCH v7 1/1] mm/page_alloc.c: refactor initialization of struct
 page for holes in memory layout
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        =?UTF-8?Q?=C5=81ukasz_Majczak?= <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, stable <stable@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 9:07 AM Mike Rapoport <rppt@linux.ibm.com> wrote:
>
> >
> > We might still double-initialize PFNs when two zones overlap within a
> > section, correct?
>
> You mean that a section crosses zones boundary?
> I don't think it's that important.

What if there was a memory allocation in between that could allocate
the once-initialized page?

Maybe it can't happen, or is not an issue for some other reason, but
this code has been fragile and had a ton of subtle issues, so maybe
worth documenting (or explaining here why it's just not relevant)

          Linus
