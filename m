Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CF321C57F
	for <lists+stable@lfdr.de>; Sat, 11 Jul 2020 19:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgGKR1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jul 2020 13:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728507AbgGKR1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jul 2020 13:27:52 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1130BC08C5DD
        for <stable@vger.kernel.org>; Sat, 11 Jul 2020 10:27:52 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id y18so5001443lfh.11
        for <stable@vger.kernel.org>; Sat, 11 Jul 2020 10:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WT5If22sLaMPwYvd2aUV89SMReFctlqwpoNyy327+N8=;
        b=aOL1heFQeqiKinpPUMjMjc9jJYIKtXbUtHLKxfkNHEMtr57W5VoqmqeG4iVDWaOm6m
         viRFkgNqyVE/8Uxjzpz6FWkO7DvUs9dguymc3cng8XxqvIsndwZtoNtvPIZ7X2NflYP9
         u+VLfQ4fIU84dJLfEvHh9pb3mWBR3aPdi+zwQLXciITSYcnd1vwbGqhMMxGp2yjFgQDG
         TkC/neU3A4butD9FHcisZH/z4n0Oae08Q/E2fQb0qJrI13xaPg1PZeQBITxe+6I31ROR
         K0i3UBnKymFop6u8GnnD799cEhW0EKEwaxE/Fz7Pc93devszFWG4RcJMDemwf59mgWQL
         LugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WT5If22sLaMPwYvd2aUV89SMReFctlqwpoNyy327+N8=;
        b=XvRdYh9Uw8jRv210OS5mDfY3/irsjjERM1ZdfWwh17P4JLxSvuNKtngTk+J/ICbj6b
         62COpNx6ndi88Bzzibn0tWBXH8ePy6qud+Unn1TEr6Rp7acloUGrQzXnCjWJkpvZbdIf
         aseWbN9035ogMTvUF3NUo3wQVHEAHwXF84hWOLkBxBJQpmNQawMKqk75evYH915RwTKV
         U4pzoiKGIl6651dXvf0iOXbzFF5/VZ8prQWZRxiwlZPETXnEWqE9RlbcQtnvQAbBxxJT
         zvL2xRvhCow5wHdcbxBID0s0tq+uER50vOFqRdbdQlJqChgRu2f+lR4dDtfg4Qb1XBxk
         AbFQ==
X-Gm-Message-State: AOAM531zUXYCIjeLCFZF/2LqWbQcJR+0j1wNAWzQ88xPuId3KCVFVudF
        oc9KmIFJPbz2Sbp4q8yiwCi6mqsjK5thKuqg/XpUeA==
X-Google-Smtp-Source: ABdhPJzyuQC9nNuJW74kQTfO9OTzPQaq3SEObRbW8jRoAavJBh0wA61Wit3kCDkbVEL4KIJMrlobAElUlQJjcmk/RcI=
X-Received: by 2002:ac2:5325:: with SMTP id f5mr47009377lfh.6.1594488470333;
 Sat, 11 Jul 2020 10:27:50 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
 <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
 <CA+G9fYuL=xJPLbQJVzDfXB8uNiCWdXpL=joDsnATEFCzyFh_1g@mail.gmail.com>
 <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com>
 <CA+G9fYudT63yZrkWG+mfKHTcn5mP+Ay6hraEQy3G_4jufztrrA@mail.gmail.com> <CAHk-=whPrCRZpXYKois-0t8MibxH9KVXn=+-O1YVvOA016fqhw@mail.gmail.com>
In-Reply-To: <CAHk-=whPrCRZpXYKois-0t8MibxH9KVXn=+-O1YVvOA016fqhw@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 11 Jul 2020 22:57:38 +0530
Message-ID: <CA+G9fYusSSrc5G_pZV6Lc-LjjkzQcc3EsLMo+ejSzvyRcMgbqw@mail.gmail.com>
Subject: Re: WARNING: at mm/mremap.c:211 move_page_tables in i386
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
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
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 11 Jul 2020 at 01:35, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Jul 10, 2020 at 10:48 AM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:

I have started bisecting this problem and found the first bad commit

commit 9f132f7e145506efc0744426cb338b18a54afc3b
Author: Joel Fernandes (Google) <joel@joelfernandes.org>
Date:   Thu Jan 3 15:28:41 2019 -0800

    mm: select HAVE_MOVE_PMD on x86 for faster mremap

    Moving page-tables at the PMD-level on x86 is known to be safe.  Enable
    this option so that we can do fast mremap when possible.

    Link: http://lkml.kernel.org/r/20181108181201.88826-4-joelaf@google.com
    Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
    Suggested-by: Kirill A. Shutemov <kirill@shutemov.name>
    Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
    Cc: Julia Lawall <Julia.Lawall@lip6.fr>
    Cc: Michal Hocko <mhocko@kernel.org>
    Cc: William Kucharski <william.kucharski@oracle.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e260460210e1..6185d4f33296 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -172,6 +172,7 @@ config X86
  select HAVE_MEMBLOCK_NODE_MAP
  select HAVE_MIXED_BREAKPOINTS_REGS
  select HAVE_MOD_ARCH_SPECIFIC
+ select HAVE_MOVE_PMD
  select HAVE_NMI
  select HAVE_OPROFILE
  select HAVE_OPTPROBES


After reverting the above patch the reported kernel warning got fixed on
Linus mainline tree 5.8.0-rc4.

-- 
Linaro LKFT
https://lkft.linaro.org
