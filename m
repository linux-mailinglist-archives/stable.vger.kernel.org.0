Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5569D24D534
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 14:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgHUMlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 08:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728657AbgHUMlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 08:41:23 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E1BC061386
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 05:41:23 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id c8so839527lfh.9
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 05:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vQ8YtZUq2JY+BH1jqqQCLSvh1WL0FVc7UY1mYQp2AQM=;
        b=Ehr1XCOBzdD5uog8ufwc8p/ZeibsGALJ/DPSRGA30L6oGq3HsS0KFwdyYUsug7ybHg
         uQac9t59HdWh/sctxLtx59MZmp9zKkXTcoNFgYd3aDVl9zN5KUBN1oZjufXKLn1TDuXt
         Wtw75wC4NFAvIaPTbdwVKS/HWohfj3La+pWL0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vQ8YtZUq2JY+BH1jqqQCLSvh1WL0FVc7UY1mYQp2AQM=;
        b=mkxWJKpg1wDUHb1gE9ztEu/crl8VloirGVAsL1z8KJic4pzwK32XvkKJBjfRi4Ef2U
         bGxeiwWzUNPKf7O3qpg1D9bsJhjrq435AojPwk+bjU+9jI8FgnRZaIFSxVL9oUcRLQAv
         UC5YCFFfpLvV+LhN6+tgRDovoEUekbRN20bhAVkzPW6oPfx39mLWU7efMe4jBzLB+gZ/
         G0kOfPTfQDoTLZAadrr4/95Xpqyy7q7qTnPCYOCnHi2oNIAPyOeUgXwHhky2BwsazF72
         AzAo3TdJKsFP1hqZEmYQ4g/PHGUzfhPQAzKkghPXITZgFPA05L/UR8T55Vn72THMsfl3
         fX4A==
X-Gm-Message-State: AOAM5333XFfKsmMSDbZz016/INHm+5bRvGG96Wth55AoVEYXkW2aGeH+
        zxCvoreIPrflSOHp5qqcTrenr+rZUYctEg==
X-Google-Smtp-Source: ABdhPJx5Y/ktjm81zwL+kI0aOUejo3MIiyNidGFkdaakewsqwftnRaRHhQOYnrJRTcXjwDp2rDTA3Q==
X-Received: by 2002:a19:2256:: with SMTP id i83mr1341695lfi.165.1598013680584;
        Fri, 21 Aug 2020 05:41:20 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id y131sm368790lff.28.2020.08.21.05.41.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 05:41:19 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id c8so839484lfh.9
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 05:41:19 -0700 (PDT)
X-Received: by 2002:a19:408d:: with SMTP id n135mr1384989lfa.192.1598013678967;
 Fri, 21 Aug 2020 05:41:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200821085011.28878-1-chris@chris-wilson.co.uk> <20200821085011.28878-2-chris@chris-wilson.co.uk>
In-Reply-To: <20200821085011.28878-2-chris@chris-wilson.co.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 21 Aug 2020 05:41:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiu1WHD0x0VXKoLQGy43S7KLCY=Yd-TPDh=7tDW08554w@mail.gmail.com>
Message-ID: <CAHk-=wiu1WHD0x0VXKoLQGy43S7KLCY=Yd-TPDh=7tDW08554w@mail.gmail.com>
Subject: Re: [PATCH 2/4] drm/i915/gem: Sync the vmap PTEs upon construction
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux-MM <linux-mm@kvack.org>, Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Dave Airlie <airlied@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 1:50 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> Since synchronising the PTE after assignment is a manual step, use the
> newly exported interface to flush the PTE after assigning via
> alloc_vm_area().

This commit message doesn't make much sense to me.

Are you talking about synchronizing the page directory structure
across processes after possibly creating new kernel page tables?

Because that has nothing to do with the PTE. It's all about making
sure the _upper_ layers of the page directories are populated
everywhere..

The name seems off to me too - what are you "flushing"? (And yes, I
know about the flush_cache_vmap(), but that looks just bogus, since
any non-mapped area shouldn't have any virtual caches to begin with,
so I suspect that is just the crazy architectures being confused -
flush_cache_vmap() is a no-op on any sane architecture - and powerpc
that mis-uses it for other things).

                   Linus
