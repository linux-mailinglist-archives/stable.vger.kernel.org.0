Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC3A49AE27
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 09:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237457AbiAYIge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 03:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379047AbiAYIbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 03:31:41 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE672C0680AD
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 22:54:25 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id h14so58727846ybe.12
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 22:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f1lt8YRK2UQEZww1aCXWt/M8bZ3Hv2L1sSVuMpXe9ZE=;
        b=QPouWdi/gzbF4+mQxh5q1TeKToySu2NjOitRnPUXax5Cgxg1turxzuarhOurWA+BgV
         GM4HAKi/SaY+OMAL2eCMMwbtrQuzCLjGuwsdeyfdaLo60DCjPeONA9VOyuWC48fEtmNB
         +OrQP2LzVzC98B0mD1rjUkSR/vZlDNScYRGwKWiRcDs8UVL7Iglu2GTZySisXxkpGTga
         rJ9YuTdnPmItK35VgXHcMNopyPebdxSc8yqnv8jdqJw3TL0LpTEGjUe3jE0YjS/eshT6
         bXRRCCcQrQaHeG7OmC/Q6NNKdxHqboLOtyasA8Sbh5XMLOBqW9+u3NL3y4xDbfJYgSLT
         GfCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f1lt8YRK2UQEZww1aCXWt/M8bZ3Hv2L1sSVuMpXe9ZE=;
        b=3UUy4pmngdnz2t4qfziQbzUIyRGIq7bc6BBEL4xOAZsSiPpa+nLu1dTybT305cbmtA
         2zxJrPCJ2/xWoHDoEGc7F3bE6UhcD3+1R8QdSZ6mN3O8y3gPlA28w3RRkoK3lw7MovJb
         maQXNYa8KAr3nRdpJbvRlXPBWLXrNyX/TMFmFJuPwXu4MR1phegc9RfOgEvrsQIVdwaJ
         a7I/uJDzCuYxRcLbSPEUgs+l8mtVhdVM8t+EMaSwuArpncGouWaxPpXy47ThWi2O0rXd
         hJ6Td0dh6HJ7sfs6W4zAGyuxTFlb1rmUzezHvEyan7eKlTdMcWDTCT77dAyWQvkFq+pM
         3SHQ==
X-Gm-Message-State: AOAM531xcjClxZk/2YlBhX0hTEEza2dplARGFF+VINW3Fo6N4VW1CMLQ
        3fMzv/lFOqg6c3wqCttCZn/Lyxpy4Kl/Pt4sOAjetw==
X-Google-Smtp-Source: ABdhPJzm36AyBsD/RrOvPYuWDEJgoIL4reeflPXvnGUumoJshfqgnpV0ijP7fzf3oaMG2VqWeOAcaHeguJI8MJK+IKc=
X-Received: by 2002:a25:ada2:: with SMTP id z34mr20878578ybi.684.1643093664863;
 Mon, 24 Jan 2022 22:54:24 -0800 (PST)
MIME-Version: 1.0
References: <20220124184024.407936072@linuxfoundation.org> <12c8fd1e-431e-9a59-9e7a-e8d856c088b9@linaro.org>
In-Reply-To: <12c8fd1e-431e-9a59-9e7a-e8d856c088b9@linaro.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Jan 2022 12:24:13 +0530
Message-ID: <CA+G9fYvokaTwyBTJvD73sO8+d56uEY6BDhXFS8O5iWhM-fxQFw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/563] 5.10.94-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>,
        Russell King <russell.king@oracle.com>,
        Alan Maguire <alan.maguire@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 at 04:30, Daniel D=C3=ADaz <daniel.diaz@linaro.org> wro=
te:
>
> Hello!
>
> On 1/24/22 12:36, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.94 release.
> > There are 563 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.94-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>

Regressions detected on arm, arm64, i386, x86 on 5.10 and 5.15.


> This is from arm64:
>    /builds/linux/arch/arm64/mm/extable.c: In function 'fixup_exception':
>    /builds/linux/arch/arm64/mm/extable.c:17:13: error: implicit declarati=
on of function 'in_bpf_jit' [-Werror=3Dimplicit-function-declaration]
>       17 |         if (in_bpf_jit(regs))
>          |             ^~~~~~~~~~
>    cc1: some warnings being treated as errors
>    make[3]: *** [/builds/linux/scripts/Makefile.build:280: arch/arm64/mm/=
extable.o] Error 1
>
> And from Perf on arm, arm64, i386, x86:
>    libbpf.c: In function 'bpf_object__elf_collect':
>    libbpf.c:2873:31: error: invalid type argument of '->' (have 'GElf_Shd=
r' {aka 'Elf64_Shdr'})
>     2873 |                         if (sh->sh_type !=3D SHT_PROGBITS)
>          |                               ^~
>    libbpf.c:2877:31: error: invalid type argument of '->' (have 'GElf_Shd=
r' {aka 'Elf64_Shdr'})
>     2877 |                         if (sh->sh_type !=3D SHT_PROGBITS)
>          |                               ^~
>    make[4]: *** [/builds/linux/tools/build/Makefile.build:97: /home/tuxbu=
ild/.cache/tuxmake/builds/current/staticobjs/libbpf.o] Error 1

Due to this patch,
arm64/bpf: Remove 128MB limit for BPF JIT programs
commit b89ddf4cca43f1269093942cf5c4e457fd45c335 upstream.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
