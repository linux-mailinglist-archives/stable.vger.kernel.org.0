Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9884309F24
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 22:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbhAaVu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 16:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhAaVu1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 16:50:27 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185BCC061573
        for <stable@vger.kernel.org>; Sun, 31 Jan 2021 13:49:47 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id u25so20083670lfc.2
        for <stable@vger.kernel.org>; Sun, 31 Jan 2021 13:49:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zO34/3ZA+CkltKNl2PpcDzP0GsqnpE1ZCLqi6BG92QU=;
        b=fm0+aCk6BtxQfENltWf1/RlYYfNSq33QZP19XEtxgizJvi+9kwVDkOqVVWinTr8RKt
         SMgtjPJoGnPPICls/VnOBpyTeAZQ56+t8B0P7lBi1Sb5xkEFZ8v/DcfPkmDm+RSlyxn2
         zTKGghgExi53SRZc+2/rWDFy6trOmHD7O1mZw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zO34/3ZA+CkltKNl2PpcDzP0GsqnpE1ZCLqi6BG92QU=;
        b=KUcSnJgije4Yy6O19MB7xTX6Z0do24X122WeZoz9MDDIiOIo6Z4xZRaTd8bO+4FY2/
         +mFVVlrhgEyGWzQU+X8jFwIV/TCrOqIBQo9v7uNxk7+RAHtuoguVvegg8K42uETZLBZ4
         ntWeuPUG1uC+HV1KHIxRXSsDkA/Viebo45JDOfprjObR+eMVg9irh88cp7GTU3vP78/N
         tXB/bWIkNLzbnLOwV+V8bhcP/lk6sWjTN108ZrF8YjF4BDDrLeHqyvErQfm8bDDufDM+
         DpZDCpYXnoXkt2GBM1S5uHMnOhhaLR0stRgnY5f25i9+xml0z0dSXUDbRnaKL0sVabE7
         ncKQ==
X-Gm-Message-State: AOAM531G4n834zZkpXjc1Pss0lnrVetaiuZmZAtHnmeXmk7DPBSZvxYK
        SpxNtSt8ze2Fz+C4VL/s2yiNpE4od0qNpQ==
X-Google-Smtp-Source: ABdhPJxr+ja3szIHTKVGJKL7A9Zx0jwzMz6EZ/t+WdywWNzMf4157GpuzgYgapwNyW4IZkGl13AJiw==
X-Received: by 2002:ac2:5312:: with SMTP id c18mr7185757lfh.318.1612129785223;
        Sun, 31 Jan 2021 13:49:45 -0800 (PST)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id i2sm2796090lfl.152.2021.01.31.13.49.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 13:49:44 -0800 (PST)
Received: by mail-lf1-f53.google.com with SMTP id h12so20099372lfp.9
        for <stable@vger.kernel.org>; Sun, 31 Jan 2021 13:49:44 -0800 (PST)
X-Received: by 2002:a19:c14c:: with SMTP id r73mr6756270lff.201.1612129783707;
 Sun, 31 Jan 2021 13:49:43 -0800 (PST)
MIME-Version: 1.0
References: <20210130221035.4169-1-rppt@kernel.org> <20210130221035.4169-2-rppt@kernel.org>
 <CAHk-=wjJLdjqN2W_hwUmYCM8u=1tWnKsm46CYfdKPP__anGvJw@mail.gmail.com> <20210131080356.GE242749@kernel.org>
In-Reply-To: <20210131080356.GE242749@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 31 Jan 2021 13:49:27 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg-qT41Q1WgPUZPC9UmCi6xquk1KE3_yvxORbmDV3os0g@mail.gmail.com>
Message-ID: <CAHk-=wg-qT41Q1WgPUZPC9UmCi6xquk1KE3_yvxORbmDV3os0g@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] x86/setup: always add the beginning of RAM as memblock.memory
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Hildenbrand <david@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        =?UTF-8?Q?=C5=81ukasz_Majczak?= <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
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

On Sun, Jan 31, 2021 at 12:04 AM Mike Rapoport <rppt@kernel.org> wrote:
>
> >
> > That's *particularly* true when the very line above it did a
> > "memblock_reserve()" of the exact same range that the memblock_add()
> > "adds".
>
> The most correct thing to do would have been to
>
>         memblock_add(0, end_of_first_memory_bank);
>
> Somewhere at e820__memblock_setup().

You miss my complaint.

Why does the memblock code care about this magical "memblock_add()",
when we just told it that the SAME REGION is reserved by doing a
"memblock_reserve()"?

IOW, I'm not interested in "the correct thing to do would have been
[another memblock_add()]". I'm saying that the memblock code itself is
being confused, and no additional thing should have been required at
all, because we already *did* that memblock_reserve().

See?

Honestly, I'm not seeing it being a good thing to move further towards
memblock code as the primary model for memory initialization, when the
memblock code is so confused.

              Linus
