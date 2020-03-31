Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDEC199AA0
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 18:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731026AbgCaQAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 12:00:52 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34014 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730286AbgCaQAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 12:00:52 -0400
Received: by mail-pj1-f66.google.com with SMTP id q16so1101339pje.1
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 09:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pJ6pmncFE1wHp8szfX3I/S/ng2tE75707WsTwjWTPD0=;
        b=pu6BS+qkLCO0EpFuflXMrDZBAmVF5ZmFVMmGV3P1LiW9v1OtBhocFvzp5SXU8tID7t
         W7F5HoFa2nZg+DJSBKbIIUz368/5kLFZvBEoDrusFX3Cac/5eKgoCMDevpDY+4T+xljl
         nq7JuwMM+Aro7f54cpj817trJNaT7gXXr4hjxTfrYtuTC2av+JSqq5X7LD4BX8zR+97h
         W1ANcmDhYM42vbWDhTV+agzjUVObc7ko/mI7S11TdKOP0M2mH4BuyeZNbryM/cT99L7g
         KccA/y5Lks5DPiCtt83eB4RKYxUgD191ROie6diD1sXB381q5yPeiXRz9Z8Pox5aT3Xv
         Ly3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pJ6pmncFE1wHp8szfX3I/S/ng2tE75707WsTwjWTPD0=;
        b=hSCnxSRVWWX08db/BZ7t33RsGwtka4b4mIgGpjnuXL2w/vF932C91ov9OnulreCGZH
         Hcmj5RzeqINVX5Sn7Yvq4sjskQcflMFuKlpYjNho774NxPZoQSOWloTU3WDymr3teMjt
         4KQ+aeiej7Yo4tRwDKK476XwBj1+Q3GZ2cBrsDK4VKmp1WqI+UunP/FZQ6gkEKkHvAiy
         UM8I9DMo1mSGLPHgF8kTmI1GKxw6Mqxev/Xa0cquP+FAuOdI35LVLrxg8a9MkB7H21DJ
         +pqdVic4RGtGASiKdkJZn5t9G4vEU6rxWcxvLb3nGsJ5KXaCzLjJP4OdbysKmwteHreR
         xSBw==
X-Gm-Message-State: AGi0Puah+aGnk2G4xrOCm4JP/oYl+VebRt7SU8XXxbrpL/QEIrJDVWRc
        i7gTQK1+joAAoqdf//O0KaKO0kL9LO7fWVeYtqnelw==
X-Google-Smtp-Source: APiQypLNfJ85avC1TKQZ1RE9n/ZZ5uBWfNSU9FxTXqNcm/J4V5IYmoXKrVK29rfYCy1Gb9tpj6DI2ccqJ08BMgBjZHk=
X-Received: by 2002:a17:902:bb91:: with SMTP id m17mr1868925pls.223.1585670449779;
 Tue, 31 Mar 2020 09:00:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200330080400.124803-1-courbet@google.com> <20200331131120.C4A2120784@mail.kernel.org>
In-Reply-To: <20200331131120.C4A2120784@mail.kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 31 Mar 2020 09:00:37 -0700
Message-ID: <CAKwvOdm4A+RyMHzziS51EJuj5t_wxG4Sdg0wSh0=wgYZ4AV+Ww@mail.gmail.com>
Subject: Re: [PATCH v3] powerpc: Make setjmp/longjmp signature standard
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Clement Courbet <courbet@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Michael, is this worth us sending manual backports to stable?

On Tue, Mar 31, 2020 at 6:11 AM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: c9029ef9c957 ("powerpc: Avoid clang warnings around setjmp and longjmp").
>
> The bot has tested the following trees: v5.5.13, v5.4.28, v4.19.113, v4.14.174.
>
> v5.5.13: Build OK!
> v5.4.28: Failed to apply! Possible dependencies:
>     74277f00b232 ("powerpc/fsl_booke/kaslr: export offset in VMCOREINFO ELF notes")
>     793b08e2efff ("powerpc/kexec: Move kexec files into a dedicated subdir.")
>     9f7bd9201521 ("powerpc/32: Split kexec low level code out of misc_32.S")
>
> v4.19.113: Failed to apply! Possible dependencies:
>     2874c5fd2842 ("treewide: Replace GPLv2 boilerplate/reference with SPDX - rule 152")
>     40b0b3f8fb2d ("treewide: Replace GPLv2 boilerplate/reference with SPDX - rule 230")
>     793b08e2efff ("powerpc/kexec: Move kexec files into a dedicated subdir.")
>     9f7bd9201521 ("powerpc/32: Split kexec low level code out of misc_32.S")
>     aa497d435241 ("powerpc: Add attributes for setjmp/longjmp")
>     c47ca98d32a2 ("powerpc: Move core kernel logic into arch/powerpc/Kbuild")
>     fb0b0a73b223 ("powerpc: Enable kcov")
>
> v4.14.174: Failed to apply! Possible dependencies:
>     06bb53b33804 ("powerpc: store and restore the pkey state across context switches")
>     1421dc6d4829 ("powerpc/kbuild: Use flags variables rather than overriding LD/CC/AS")
>     1b4037deadb6 ("powerpc: helper function to read, write AMR, IAMR, UAMOR registers")
>     2ddc53f3a751 ("powerpc: implementation for arch_set_user_pkey_access()")
>     471d7ff8b51b ("powerpc/64s: Remove POWER4 support")
>     4d70b698f957 ("powerpc: helper functions to initialize AMR, IAMR and UAMOR registers")
>     4fb158f65ac5 ("powerpc: track allocation status of all pkeys")
>     793b08e2efff ("powerpc/kexec: Move kexec files into a dedicated subdir.")
>     92e3da3cf193 ("powerpc: initial pkey plumbing")
>     a73657ea19ae ("powerpc/64: Add GENERIC_CPU support for little endian")
>     aa497d435241 ("powerpc: Add attributes for setjmp/longjmp")
>     badf436f6fa5 ("powerpc/Makefiles: Convert ifeq to ifdef where possible")
>     c0d64cf9fefd ("powerpc: Use feature bit for RTC presence rather than timebase presence")
>     c1807e3f8466 ("powerpc/64: Free up CPU_FTR_ICSWX")
>     c47ca98d32a2 ("powerpc: Move core kernel logic into arch/powerpc/Kbuild")
>     cf43d3b26452 ("powerpc: Enable pkey subsystem")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
>
> --
> Thanks
> Sasha



-- 
Thanks,
~Nick Desaulniers
