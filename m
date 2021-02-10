Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16594317028
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 20:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbhBJTa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 14:30:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbhBJTa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 14:30:57 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E78C061574
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 11:30:17 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id y5so2954522ilg.4
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 11:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XR3GJYIrFqVh/P4AaYfLRSkAEDtaWqwqBD1TKpNkqZA=;
        b=bxN2BwNs3tdQqP3WHeziz9Kyj02bvgwpyBZJJqV9quH5IrMHzseF6fX5i/QqhEOIDU
         N/cnJlpbCMzDI9KItYP08h/4UB7dz/x0mvQeZNBGkXhQdJ+l0aREjeuzOBS8e/IfljwD
         yl1fV6QBd4hslnuvA6/4n/isUDgsTwPmE47k4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XR3GJYIrFqVh/P4AaYfLRSkAEDtaWqwqBD1TKpNkqZA=;
        b=KoTMGAoiWUn/D3i8hp0fDaROrAvEn+uB8iBAoBPNQhzNub9ExTggABnBC0xIif6JjF
         JzHMa4YSFGB81DTuXVm+wqUKwi9sGlQ//wfwjg7GMKgJDdSVCjOlCLRFT9nBwPTLho+c
         0DiTZqdHTG0ztXdQwCSnJOJiN8BCUYcgtWVA8bfqqNef5WELpx2qu7NvD4Mb7VtVZWXB
         1Ic11O5l0aklOZaN+dnRF9uaxVFV5l29reCpSitOBgryvjqnjy+5QxWdA9tUa1Kd0cwL
         SnZdQaO4+q+nWL6y3r1yPpacWoWRVYnn7f4PD25xaBYPcrlFhwJ/ax3ITsH1Ow4+23BP
         wPfw==
X-Gm-Message-State: AOAM5307e+ll05qCNrWO+HUxYoyspzHzqzhPGoma4uVG4gFPskyw94jo
        yzbcxg/pmMhwIzZRqpM0Kjv5/eQOt/dypA==
X-Google-Smtp-Source: ABdhPJymfPILdbwLyN0DTMhJuzxKYhPU4KqGl0Zs00HpprZmaO6r4xlK+ZEfU3anemuro2Syxd8rQA==
X-Received: by 2002:a92:de01:: with SMTP id x1mr2496484ilm.307.1612985417025;
        Wed, 10 Feb 2021 11:30:17 -0800 (PST)
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com. [209.85.166.174])
        by smtp.gmail.com with ESMTPSA id a14sm889630ilm.68.2021.02.10.11.30.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 11:30:16 -0800 (PST)
Received: by mail-il1-f174.google.com with SMTP id e1so2976398ilu.0
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 11:30:16 -0800 (PST)
X-Received: by 2002:a92:c26a:: with SMTP id h10mr2537425ild.234.1612984986592;
 Wed, 10 Feb 2021 11:23:06 -0800 (PST)
MIME-Version: 1.0
References: <20210209214232.hlVJaEmRu%akpm@linux-foundation.org> <4d33f14e-93ba-76ec-a82e-168ee2f25fe6@suse.cz>
In-Reply-To: <4d33f14e-93ba-76ec-a82e-168ee2f25fe6@suse.cz>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 10 Feb 2021 11:22:50 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgMASx-nw8L_pYGktuVQH6msBnm718e9=JW+MCA8PSweg@mail.gmail.com>
Message-ID: <CAHk-=wgMASx-nw8L_pYGktuVQH6msBnm718e9=JW+MCA8PSweg@mail.gmail.com>
Subject: Re: [patch 13/14] mm, slub: better heuristic for number of cpus when
 calculating slab order
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        bharata@linux.ibm.com, Catalin Marinas <catalin.marinas@arm.com>,
        Christoph Lameter <cl@linux.com>, Roman Gushchin <guro@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Jann Horn <jannh@google.com>, Linux-MM <linux-mm@kvack.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@kernel.org>, mm-commits@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        stable <stable@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 10, 2021 at 6:34 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>
> As Andrew's incoming series might have been not merged yet, I will point to
> Mel's Tested-by:

Thanks, added.


           Linus
