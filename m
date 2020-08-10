Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EF1240D69
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgHJTEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728177AbgHJTEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 15:04:07 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C8AC061756
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 12:04:06 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id h19so10776987ljg.13
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 12:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=znZF7mN4GZa7I95wRQzCZYfOmWM4zcoHpG47PvAps1U=;
        b=XUJQHnTApaapFJwiD/BK36p+cwXWA+5VUkYEfyWWZ/6mgtkmnboJDj6aIUoioBVyPJ
         OLqiFTmnWZbmAEv8s98Nvcp1U+JKND7W3WrzVdKMnAE18WAMXRo1u68m44Lt/tRYstoq
         oMkbTLobdgkHSjFkZxhHiaKKxen95T6oCkO7s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=znZF7mN4GZa7I95wRQzCZYfOmWM4zcoHpG47PvAps1U=;
        b=gJbBlnxT7kp/L4M25vz9tsfubNwx/0Jqe60NPaO4gL+mTDDQtFVODKaQ/0X0ZSWUYB
         yWIdf+dS3N6TNbodoczLqyBieXB2VnxWLLQ0I0AmrHnPl2PPu7vDHQg1lALWnrIKTIGM
         WdcSoisl4ZUaMtMNe1YechwRDchS/0S7Kc/4c2E4L+mwFeyynEnWyLgqfBhex/kgWER3
         KXEm0BjtwroGeIpA7T1M+dIb+qbFlwrVQfSzh98BqPWjLNakYYsuHYMOkySvFRRMui1E
         LToOGHwmyVtKtIdiKsXlbJrOUIYxYih5GDWkOP/ULpAYMZ5jslfMyE4xva0nJhagmMIU
         wToA==
X-Gm-Message-State: AOAM532tdsztDnyXQ0hJDeVe+r/I0iyARzMYH3yucDVGr8F8AwuON0h1
        zQfNDDnTCwreQ8YOSLYY3DIp9kexSD0=
X-Google-Smtp-Source: ABdhPJzLmP1TBc2eSqPscARpw4O/nbLWks4i8ksCgqkqS/ps31zMYLKgmJf9I2R2lwrKlmpd2ZDvSA==
X-Received: by 2002:a2e:2a04:: with SMTP id q4mr1174816ljq.192.1597086244667;
        Mon, 10 Aug 2020 12:04:04 -0700 (PDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id t22sm11033410lfr.12.2020.08.10.12.04.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 12:04:04 -0700 (PDT)
Received: by mail-lj1-f175.google.com with SMTP id t6so10807108ljk.9
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 12:04:04 -0700 (PDT)
X-Received: by 2002:a05:6512:3b7:: with SMTP id v23mr1282665lfp.10.1597085867750;
 Mon, 10 Aug 2020 11:57:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
 <20200807061706.unk5_0KtC%akpm@linux-foundation.org> <CAHk-=wiK1oh8T_GNdnQk4UERuWmLQMnXuia8CpJ5QVzSAKuffQ@mail.gmail.com>
 <CAHbLzkrSQ8CT5jaT-8LFtnEg-63qdZNoHe6XBc3F4orxuHt-7A@mail.gmail.com>
 <CAHk-=wjoOtcAvkYQThDQ5u+jFqbtwOsSJH1DtLDfokMOd4K93w@mail.gmail.com> <CAHbLzkrRyFrDKpCBH6X7kSOKJxrPg34ccX2ik6u4zO94=94BtQ@mail.gmail.com>
In-Reply-To: <CAHbLzkrRyFrDKpCBH6X7kSOKJxrPg34ccX2ik6u4zO94=94BtQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 10 Aug 2020 11:57:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wihhz_Z4vJF-jwQP=qyboN3gTRuP9ZDxLgFYOZFBWK8vw@mail.gmail.com>
Message-ID: <CAHk-=wihhz_Z4vJF-jwQP=qyboN3gTRuP9ZDxLgFYOZFBWK8vw@mail.gmail.com>
Subject: Re: [patch 001/163] mm/memory.c: avoid access flag update TLB flush
 for retried page fault
To:     Yang Shi <shy828301@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
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

On Mon, Aug 10, 2020 at 10:48 AM Yang Shi <shy828301@gmail.com> wrote:
>
> It looks the retried fault still flush TLB with this change.
>
> Shouldn't we do something like this to skip spurious TLB flush:

I have no idea what code-base you're basing your patches against, and
what you're comparing my patch.

Your patch does *exactly* the same thing mine did. Except it does a
"goto unlock" to jump over the flush_tlb_fix_spurious_fault(), while
my pseudo-patch just changed the

                if (vmf->flags & FAULT_FLAG_WRITE)

to be a

                if (vmf->flags & (FAULT_FLAG_WRITE | FAULT_FLAG_TRIED))

but it has the same effect: it skips the flush_tlb_fix_spurious_fault().

So if you think your patch does something else, then your source code
doesn't match mine. The *only* thing you jumped over was that same
thing that I disabled.

Somebody is confused.

                    Linus
