Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78607300681
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 16:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbhAVPEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 10:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728637AbhAVPDi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 10:03:38 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29648C06174A
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 07:02:58 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id y72so946001ooa.5
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 07:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OJKWIQqx6v0dlsfViKU5cuhP8gvpdjnjTIz5bInhKHM=;
        b=LvEDFwUsof0pvcqFGZ30dIzNYq2AdaVGiAveifHLZW4vFhJQvDfSXGfdS98npk4EyC
         I5goxMf0EudveMFQNNJtFlK5rcFAmq7c9gvuUkonlie1iL5bP1h9GTyq4y0qgE9mk3dP
         lZyPFbF1r0gIVbBxqODF6crcteeGaRY4mZ7gVw5ESfipezhAYnrabUJFXR+3hq7dYmWs
         ZZoseJHZLYl2+yjM1ev/yvss6bNsYCgZJ7plDt5braIhnkSuURgT5vfjn/rVEpA75zA/
         D79jP2ouzmK1qQHVywkUZIcxPiUOxflp8kfaBk2u2tLJCsMgfOyhehT7wf04QRTTtQL0
         UkrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OJKWIQqx6v0dlsfViKU5cuhP8gvpdjnjTIz5bInhKHM=;
        b=RKSGItDt06CaUxVqxuLWPHsKNMkoH+ZJyYjsnE029qak9XQf8NWUR/5mqhoAFUPIOe
         D2m5SozBWyhUBhDqlZs5ueZFpiNZmYBRNz4MTl0g6PHbcS16hmwd//xc6tHiIlN7P52X
         q3/NxgfBCmAU194E8fShu7247DsdFIO6jviKeXRhHtsbG7qag4SfKZArHaZWQjuALleV
         l9nL9nHScPVQa2dCE016I67w4o0hWKl/fYFaAN9Z6/BngXD8GhAjYyAyP33oanoGoAwY
         nTO+nSdc4WZw2TDTI77R9O+5qa5+2uQEYtb8mXOrL0DDiU8bau9qLwenWczVSxwgWnOh
         awKg==
X-Gm-Message-State: AOAM533BM9LLMD9d2DfoD5p3WSI8uNc6bam+x+/c7J03mBbf1nRGRxMh
        neuWZ81SICGrKMdnWL3F4Yys2hvC1pDweLKuoofDsA==
X-Google-Smtp-Source: ABdhPJzfk+yYEIz6clorKAD/bw4ULNqRxd97O1JrjLIq7Mfn1a5SAR3XzT8LB6wzxbfBRdOaqzs/6XJKLhtImM4x/L8=
X-Received: by 2002:a4a:a9c9:: with SMTP id h9mr3957459oon.93.1611327777348;
 Fri, 22 Jan 2021 07:02:57 -0800 (PST)
MIME-Version: 1.0
References: <20210122135735.176469491@linuxfoundation.org>
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 22 Jan 2021 20:32:46 +0530
Message-ID: <CA+G9fYso4QNbRWdrQiiOiMb5RUr8VtM3AkKEGLasgN+KsPSvDw@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/50] 4.14.217-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Will Deacon <will@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 22 Jan 2021 at 19:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.217 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.217-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

arm64 clang-10 builds breaks due to this patch on
   - stable-rc 4.14
   - stable-rc 4.9
   - stable-rc 4.4

> Will Deacon <will@kernel.org>
>     compiler.h: Raise minimum version of GCC to 5.1 for arm64

arm64 (defconfig) with clang-10 - FAILED

-- 
Linaro LKFT
https://lkft.linaro.org
