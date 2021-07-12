Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519683C5C0A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 14:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhGLMY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 08:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhGLMYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 08:24:55 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C470EC0613DD
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 05:22:06 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 7-20020a9d0d070000b0290439abcef697so18640921oti.2
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 05:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=I/gZ2fUbn7t9xYKR9dZLDy2ZzC/5pFr4YyA2ECocRro=;
        b=q/c4kmMeNUJ4UJVpgs277eyJ67KR/RXiTs5rhy5iuJbhZ26ho24MnzGQJIwZTuD+cp
         cCxMUPlJD6Ov4Q8hm+kc5kigiR4M1SEwP1fL3ScjwglyMVAB8B6NCLViQAGhOLku+kL2
         3VzxLJqoAmQyKux+5QotFS7I1u54mkxHaH7ctebIs0DjLo+V1vscv8K61BASkYyXkzjE
         SdGSxK7XWWqsCRXiYwQXQ5ayy9I6ne51BnMCj5BNXlTGH/LIFYcBRXZnob3SzifaSR9V
         LkD5NyIckOCmu+fs9PFy8ojHC2F4dktocKUQzL2Dv4pPAW4UeZUFZzPZeV/uOyegZTrD
         zF/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=I/gZ2fUbn7t9xYKR9dZLDy2ZzC/5pFr4YyA2ECocRro=;
        b=dBPBrZa0gQc8fLkWm3FeU/AesBOitE+4II6unaOTzJvBhXz/FP6Y0XcXCcCCVqQeeY
         1VIz8VPVem+JqHq/YnwveWqtPkOglnkpGgQl0tSxEiNSuQZbInfhLhV75MYoBWevfZoh
         04mxM77DbtWp/bSvr/bPYYYGoGSGEeFrauxg2i3uZM/1SzvDb0x8Khm3YvPaap0AcBis
         v0woPTCvMo8DEv2ZjN+tGJ0UoI28wJf7jFLRrDMHoS2/bTsaEz3TVpBIpXef6RYNxbgk
         Dp/StX+orDFeo9n+yIrWTNIFMat+PgK0AZ4jXT1VSPNevLMO2ZuFfXP/Zh7zbHUlM2b0
         J59w==
X-Gm-Message-State: AOAM530/Kyuid3fclVDfz+SAk5sfgFQoVAi8sa22MDZfM5On1kDsl90A
        KsZBtOxMAbcm0lgl9tyWhHKq+ua4IHjX1WDk7KIzEQ==
X-Google-Smtp-Source: ABdhPJy7wrbsGVIJqq5cMY18TfWKud3VMsSDkmPO8RnG788kNXP3X5+c5WbOZwOe7MypM6lKqOCHJP46ctNq8wc2HtQ=
X-Received: by 2002:a05:6830:242f:: with SMTP id k15mr47595ots.72.1626092525463;
 Mon, 12 Jul 2021 05:22:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210712060843.180606720@linuxfoundation.org>
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 12 Jul 2021 17:51:53 +0530
Message-ID: <CA+G9fYtdYvUse1Osfrux6DVU_DiLAKveQqnEZ36eoG-fThJBqw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/593] 5.10.50-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        Nathan Lynch <nathanl@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Jul 2021 at 11:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.50 release.
> There are 593 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.50-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Regression detected on powerpc,

Regressions found on powerpc:
 - build/gcc-10-cell_defconfig
 - build/gcc-10-maple_defconfig
 - build/gcc-10-defconfig
 - build/gcc-8-defconfig
 - build/gcc-9-defconfig
 - build/gcc-9-maple_defconfig
 - build/gcc-8-maple_defconfig
 - build/gcc-8-cell_defconfig
 - build/gcc-9-cell_defconfig

The following patch caused build warnings / errors on powerpc.

> Michael Ellerman <mpe@ellerman.id.au>
>     powerpc/stacktrace: Fix spurious "stale" traces in raise_backtrace_ip=
i()

Build error:
--------------
arch/powerpc/kernel/stacktrace.c: In function 'raise_backtrace_ipi':
arch/powerpc/kernel/stacktrace.c:248:5: error: implicit declaration of
function 'udelay' [-Werror=3Dimplicit-function-declaration]
  248 |     udelay(1);
      |     ^~~~~~
cc1: all warnings being treated as errors

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

link to build log:
https://builds.tuxbuild.com/1vCh34NozLpcdYwjDS72K2fkiM3/

--
Linaro LKFT
https://lkft.linaro.org
