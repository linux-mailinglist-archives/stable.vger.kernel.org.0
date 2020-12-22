Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070C72E0361
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 01:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgLVAZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 19:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgLVAZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 19:25:24 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFB4C0613D3
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 16:24:44 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id n9so10540443ili.0
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 16:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4RuWWi7Zl0r6VeRFf6xBa4XAn38HB/limrAzhvwBg9E=;
        b=QxNJ3YhgavKUMBo9RFOSja6zyVmlQSaT9lxfBxy2MZqCO+Lmri5ACNMvgW/1nEBH9u
         RfRWRqk4hPOPoCizuEb4pvXMgwxOT3Yp0Ue0HSEN8FP5649e+o8It9Pp1hTl/gncEv5v
         Z5XKcfOnokS7rz2lbhVKUIcP2ImTJdgDicSI+Z0xj3sYdg/tR7EHorMT2UyccQToc2tL
         dZtFjPlW8euhQGfmx+x3tDQOdffJLed1RX3ZpyaPAhpRQKIWopoqX2NIU02F98qrQMxd
         xlOKdL4kia4rVg4CK34oJd0QGnOYYHaaNyiItjcwMmIrOmZiqy+eN8lQ16fg7OCSigBx
         XeIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4RuWWi7Zl0r6VeRFf6xBa4XAn38HB/limrAzhvwBg9E=;
        b=uJZcg6YxDMh7RtlFkD3hdnRruVGiU1MxuMpKhbpQs7z6n+jVzCqaZ2XrwL1yd+fbN8
         dILTQvlhthY1mWlRGam4y7R/IM+x36hMSxqzuI5D8EFz9Tk2JhfXpo2VvLwk3+ip3Ffn
         AEiV3DeBJlLJ+Z5Vp8NGmcDC4pczMZIE2glM3UVwlEDnTIbex8dsOKh/ELyatVcqF2DZ
         ZGw5eOuFgi+PMlDWgBszNvIJma6ZTMg1aNPaAsmXISOuXh22vedvuoB39Zp0IIEOcb6Y
         zye/7SN+vT0vxNQsuj/FVukOBiimz7CuPLe21KDmzASVkfaIj4BOwMQ+tGHoXNAsF3mZ
         uIqw==
X-Gm-Message-State: AOAM532apFbrZLurIYcadbGKkcrQIjgQ4ufiCxqWADKyaDW/LkPWME0V
        GvLheShMInjGf+zBxMT+Ch/WAA==
X-Google-Smtp-Source: ABdhPJyBEsQhZx/Eo+G0MR8uYZv1+RPEAPRNQ3dCCuOdkBFw/mpJJCIkxzG9Yzm/uczjOmTQpWBxzA==
X-Received: by 2002:a92:9ada:: with SMTP id c87mr18944102ill.5.1608596683475;
        Mon, 21 Dec 2020 16:24:43 -0800 (PST)
Received: from google.com ([2620:15c:183:200:7220:84ff:fe09:2d90])
        by smtp.gmail.com with ESMTPSA id w9sm14146363ilq.43.2020.12.21.16.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 16:24:42 -0800 (PST)
Date:   Mon, 21 Dec 2020 17:24:38 -0700
From:   Yu Zhao <yuzhao@google.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Peter Xu <peterx@redhat.com>, Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+E8xpSskyEj+eAe@google.com>
References: <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <X+Er1Rjv1W7rzcw7@google.com>
 <CAHk-=wiEp-D36h972CBHqJ-c8tR9fytg9tesZ1j_9B0ax9Ad_Q@mail.gmail.com>
 <X+E3FmxrEVfc0B/X@google.com>
 <CAHk-=wiWkZGSsPXAbonBoNLYj3vETkoB+9eKOxoFZutPgqkYzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiWkZGSsPXAbonBoNLYj3vETkoB+9eKOxoFZutPgqkYzA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 21, 2020 at 04:11:01PM -0800, Linus Torvalds wrote:
> On Mon, Dec 21, 2020 at 4:00 PM Yu Zhao <yuzhao@google.com> wrote:
> >
> > My first instinct is to be conservative and revert 09854ba94c6a ("mm:
> > do_wp_page() simplification") so people are less likely to come back
> > and complain about performance issues from holding mmap lock for
> > write when clearing pte_write.
> 
> Well, the thing is, that simplificaiton was actually part of fixing a
> real regression wrt GUP.
> 
> Reverting that would break a308c71bf1e6 ("mm/gup: Remove enfornced COW
> mechanism").
> 
> And that one was the (better) fix for commit 17839856fd58 that fixed a
> real security issue, but did it with a big hammer that then caused
> problems for uffd-wp (and some other loads). There's a bit more
> context in the merge message in commit b25d1dc9474e Merge branch
> 'simplify-do_wp_page'.
> 
> So while that commit 09854ba94c6a on its own is "just" a
> simplification, it's actually part of a bigger series that fixes
> serious problems.
> 
>                 Linus

Well, that settles it then. I don't any better idea that is as safe
as what Nadav has.
