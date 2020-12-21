Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46D62E02F0
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 00:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgLUXea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 18:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLUXea (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 18:34:30 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA86C0613D3
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 15:33:49 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id b26so18202074lff.9
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 15:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QEI1Wo/KRErTAX0ERZgOzFeJks692fMFAi0JITm2e5Q=;
        b=GC5WA9gdSwcyncqpAe4Pgve/+6CIEcQ2X9/TyvwifrhZz13pA7erQ8ry7LaJHWRbYX
         ujbb52eNeZOdzzRXgtcSiXBN7bIpIlqUo5bA6wXKFSwNB+dI1C8olVMwudvXutMxjHPj
         qsGm07mg/0wlThOxI9rhIrdWA058+/rAApYwo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QEI1Wo/KRErTAX0ERZgOzFeJks692fMFAi0JITm2e5Q=;
        b=ThMJc64RSRVtP5szdDVOcHtah/UiuZgX6N7K7UfFWrpuhUkcsXQzpOk3NY7vq7Ut3T
         B9NyHx2PMsOPRCNnPiGlWkM1K3kjSIZtL0AEdJxrYg2+41yUEot5SNAduuLZo5pXvTqt
         Iu6G6bTuOX0PfXRcKUUP5Rw+s0h2KVsEwzBRQheWcOM+eQ9ZR2kWTr23nkEHNyU3WNOF
         zeqWvacGfldjVuR40kfd/wqMN1jYyBWH/ev4zJTe9NIhYPQzHcQm7qK9wT9YfuFumLOi
         6yz6903e/KtESEwpou/dac8ZDZNJ5nmyQs83siRpBrbUlHXNWEFyuQ4q7IMh0yIUBtus
         Kz1g==
X-Gm-Message-State: AOAM532+2mCp64fezoAvY+PjLTPRvoMNrmZy0ijp/iiunH5pO0KGJbxy
        GJGLjIjP/lQRVBNRf9CrnwWvMaYlybgQRA==
X-Google-Smtp-Source: ABdhPJx/5WNvK6S5xbvroM1274O7XgWsHhcBmxMmTlJP5Wk3DeYm9p7uRpcqF2jbS1k8S5FXIkdy9Q==
X-Received: by 2002:a2e:9296:: with SMTP id d22mr8668364ljh.197.1608593627905;
        Mon, 21 Dec 2020 15:33:47 -0800 (PST)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id j20sm2494137ljc.47.2020.12.21.15.33.46
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 15:33:47 -0800 (PST)
Received: by mail-lf1-f54.google.com with SMTP id m25so27636983lfc.11
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 15:33:46 -0800 (PST)
X-Received: by 2002:a05:6512:338f:: with SMTP id h15mr7192658lfg.40.1608593626453;
 Mon, 21 Dec 2020 15:33:46 -0800 (PST)
MIME-Version: 1.0
References: <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
 <20201221172711.GE6640@xz-x1> <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com> <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com> <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com> <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1> <X+Er1Rjv1W7rzcw7@google.com>
In-Reply-To: <X+Er1Rjv1W7rzcw7@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 21 Dec 2020 15:33:30 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiEp-D36h972CBHqJ-c8tR9fytg9tesZ1j_9B0ax9Ad_Q@mail.gmail.com>
Message-ID: <CAHk-=wiEp-D36h972CBHqJ-c8tR9fytg9tesZ1j_9B0ax9Ad_Q@mail.gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
To:     Yu Zhao <yuzhao@google.com>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 21, 2020 at 3:12 PM Yu Zhao <yuzhao@google.com> wrote:
>
> I can't say I disagree with you but the man has made the call and I
> think we should just move on.

"The man" can always be convinced by numbers.

So if somebody comes up with an alternate patch, and explains it, and
shows that it is better - go for it.

I just think that if mprotect() can take the mmap lock for writing,
then userfaultfd sure as hell can. What odd load does people have
where userfaultfd is more important than mprotect?

So as far as the man is concerned, I think "just fix userfaultfd" is
simply the default obvious operation.

Not necessarily a final endpoint.

                 Linus
