Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386182E0187
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 21:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgLUU10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 15:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725949AbgLUU1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 15:27:23 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F43C0613D6
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 12:26:42 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id 23so26676784lfg.10
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 12:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jpofkkkZ7q2cLabxVdnoR1KpfpHXn/gunfXeSPC5btE=;
        b=efJi2L/jwYZG7lsZ3QUyQ+qJRPOSZJVBiQPV+KYdbYTDhEtiTiZJDpg0XZofJH/vr5
         mvNIAsdX5eAcIdvkl8jdEU5jTFWJ/AX+Txhwsgdbaf4PRt5Mq82tnOXK8TWv+g9m7y52
         H+k0THZ5Fa1365neNcweicdbjh0OKXdZEByM4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jpofkkkZ7q2cLabxVdnoR1KpfpHXn/gunfXeSPC5btE=;
        b=bmIyR0vioMDEJ5tUacdQQFH06BAgu+bwof8Fp901TkJmKpl8096xKhDz8UEgWmVMew
         fgt+xhkbw3Sybu594asQBVHBV1NIfEFamqINZLkZdh1NvuU4RXnekhe5OTYG5+5Z5Cf/
         3q3+L/ew6dFgfciawSgy4xs0kQAysdX0Or8zAtnUa7itqEBZ/5a0J8S50oMNZ+UrVr0x
         2EIFqCUrCjBH20eaRv+39fgMCr0l+0KS8CrIgHaBv6NWTfi+rMS2NQBqMATVgSNEkF5u
         /nF4JpW6hJ1+Ad55SFIAbJCXW/MeH21nc+rafE8qAFUSWvPxhvUea0p9osefZMXhzux8
         BPfA==
X-Gm-Message-State: AOAM5307lXup8wo257jMeHKHFrhoGcM1bKz4NFx/Qo+Dzp/ThqN5rgm4
        emyIFeONvBa+J1pBspz78XE6UYIXmiItbQ==
X-Google-Smtp-Source: ABdhPJzmRRYpOo/V28L5i6L7OzJnL7wBXBJ3MCJ3qrTRtRc0lVxaMtKHSKBGG1jIIpY0xFaDHwQS9w==
X-Received: by 2002:a2e:9847:: with SMTP id e7mr8565260ljj.388.1608582400641;
        Mon, 21 Dec 2020 12:26:40 -0800 (PST)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id o15sm2218916lff.297.2020.12.21.12.26.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 12:26:40 -0800 (PST)
Received: by mail-lf1-f51.google.com with SMTP id h205so26736580lfd.5
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 12:26:39 -0800 (PST)
X-Received: by 2002:a05:6512:789:: with SMTP id x9mr6960312lfr.487.1608582398544;
 Mon, 21 Dec 2020 12:26:38 -0800 (PST)
MIME-Version: 1.0
References: <20201219043006.2206347-1-namit@vmware.com> <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com> <X97pprdcRXusLGnq@google.com>
 <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com> <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com> <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com> <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
In-Reply-To: <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 21 Dec 2020 12:26:22 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
Message-ID: <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Yu Zhao <yuzhao@google.com>, Peter Xu <peterx@redhat.com>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 21, 2020 at 12:23 PM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> Using mmap_write_lock() was my initial fix and there was a strong pushback
> on this approach due to its potential impact on performance.

From whom?

Somebody who doesn't understand that correctness is more important
than performance? And that userfaultfd is not the most important part
of the system?

The fact is, userfaultfd is CLEARLY BUGGY.

          Linus
