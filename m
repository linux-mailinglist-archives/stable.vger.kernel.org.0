Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4941623F29D
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 20:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgHGSRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 14:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgHGSRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 14:17:38 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BA7C061756
        for <stable@vger.kernel.org>; Fri,  7 Aug 2020 11:17:38 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z14so3196947ljm.1
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 11:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CKMvl01L4wF4iqNu2rhFEk7yvhvWgxW9jY+i4dSP0Kw=;
        b=QNy++CHeaaM6WpTb5fAZTyuu42THHqM5jUd2cVss/n1PrKPIikisPKPZhqd7LZTKxg
         XRl8ax9NJP1HEwuU+5uYXH/UJjANG6FSmTpAGh/ApTvFbuHohZLD8NJT7jz3jNAfXMGD
         qaLgx9c5VgDvjeeVZmx3gDEbig9nwZY1MWC7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CKMvl01L4wF4iqNu2rhFEk7yvhvWgxW9jY+i4dSP0Kw=;
        b=CKhqRlfjy6o5NSMXqZcb1uGOLJhgel4CAubZaNxDoUak1B89SQdyYqwA1/H1XOT329
         LABoz/uZJV59LaUpJ7en33/Nd9RlikOJIki+kgqJW8KuVfZrrIBwswa4jYEfvnqf9lOV
         GMNl0QY/lIsdDE1yfmqiF9x6C4YYcmFiwNgBQQfG4GdiDXPjnLT2xYmLobvehDXRTJkD
         m7548GIick87v8T3Pkc5otGBcoiP9mmFUwwamdb93E+p8lLAsFObn8ctUTXkmtoKg8H+
         e8IxxrQAWvJAVqZrFjX0eEtUVHTWyhzv2nKC/UiyszRoPY29Zd2XWIKX43ySCOx4ehG7
         su+w==
X-Gm-Message-State: AOAM530J+Qb999KR26SF1gr+/jR8PSgH5TlDe5CWY4MEEhpEcaPDuhPX
        UbdsDILIvk/aALc5WHv8Gny6fgHeFHx0ew==
X-Google-Smtp-Source: ABdhPJz/KzsI1C1jtRgwFo+Qyyzb6Ds6m8oeLWqqVyrITpsdrQBzxX2BbBedRaTFFosI1wEE8TBIVg==
X-Received: by 2002:a2e:9696:: with SMTP id q22mr6792648lji.11.1596824255571;
        Fri, 07 Aug 2020 11:17:35 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id a24sm2132817lji.36.2020.08.07.11.17.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 11:17:34 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id g6so3139680ljn.11
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 11:17:33 -0700 (PDT)
X-Received: by 2002:a2e:545:: with SMTP id 66mr7142832ljf.285.1596824253318;
 Fri, 07 Aug 2020 11:17:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org> <20200807061706.unk5_0KtC%akpm@linux-foundation.org>
In-Reply-To: <20200807061706.unk5_0KtC%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 7 Aug 2020 11:17:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiK1oh8T_GNdnQk4UERuWmLQMnXuia8CpJ5QVzSAKuffQ@mail.gmail.com>
Message-ID: <CAHk-=wiK1oh8T_GNdnQk4UERuWmLQMnXuia8CpJ5QVzSAKuffQ@mail.gmail.com>
Subject: Re: [patch 001/163] mm/memory.c: avoid access flag update TLB flush
 for retried page fault
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Hillf Danton <hdanton@sina.com>,
        Hugh Dickins <hughd@google.com>,
        Josef Bacik <josef@toxicpanda.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        stable <stable@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Xu <xuyu@linux.alibaba.com>,
        Yang Shi <yang.shi@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 6, 2020 at 11:17 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Yang Shi <yang.shi@linux.alibaba.com>
> Subject: mm/memory.c: avoid access flag update TLB flush for retried page fault

This is not the safe version that just avoids the extra TLB flush.

This is - once again - the thing that skips the whole mkdirty and page
table update too.

I'm not taking it this time _either_.

Andrew, please flush this garbage from your system.

                 Linus
