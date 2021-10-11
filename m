Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26A742956C
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 19:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbhJKRTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 13:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbhJKRTU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 13:19:20 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688D8C061570
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 10:17:20 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g10so69782289edj.1
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 10:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U0otXV2y5XbiRFTl+VTUE1Rn2Q/EdVlXbDmxI0rU6v8=;
        b=tLOJJ6fxRtnL4KpCSY3QHaNgy6VnHEvrGi0oWG98M+Zzu62xsSNCv08SEH56U4RNhX
         slZ9WXSMyHgWoH7VwQZLM1G2x8nJEflaqk4DrgFgMsLRiq9TNZqwqAcSxjQ4oCoP3kUJ
         Z2o6q8HSodWgAQB5YihoiQ0+Bxqv7g7gTXvlgbtpiRoz3aCtT0OkienMrfXqKN5xfT86
         94PeyHTQc9+NU12CWnpUi0KJztS2ySA+r3aRnzuX5NFJbQ1qHsgWZdDQgNz1+UyxzHoY
         g06t0nQ/Ww2tcQbtFyfT4p+8BUsHtS8HosXZKFF344JqbGRBKvelnpL6P2pM6kO1Qz76
         NJpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U0otXV2y5XbiRFTl+VTUE1Rn2Q/EdVlXbDmxI0rU6v8=;
        b=h9IxYGrPBwU4dBpT2LQtFo4ONVMm4ZOlseyhT6Cf4uSQlgUuj41FHT5MAdzWbG2K/2
         /xxNoHFKnvmey6LIWsBx3vOfxnVTzzj+SCMAw7e1EMaQGM/AArg8SATCZxs1I0b7gjYJ
         zBT8rtYGEYNSe4L0uy5rnxCk04w0Zuxz+a/x08cwoQLFdh0FOEvuMvplE+LyQOxpamkF
         1z3lnVtowDheZBqigVrd56K8yZVdUgk8StSTTLo3vkyZ9Zq88OlUn3Z1sQiROmHXau7Z
         sgcR9bM3RTIVtTfgioc3YBiJvsMz0bzmsCefHs7rKYv7FezIJuY5Lbkr6CrhOfnDNofK
         d/sQ==
X-Gm-Message-State: AOAM531eWAKdX+SwExKOwoEza4VOnBpHPU+IDCsCfTAJQA8FnmJCN4Ve
        B49LcXLOomeAsRhV0SUhSf19b8DjJ34MlLCEkumDjw==
X-Google-Smtp-Source: ABdhPJxLGN99sa3B/D5yXgC1k67IFIYt7UU/C8flGFxcNKpEHo6MFV7Yj1SsNO3MdsHIlzOJzNTeGjzeGcRR7sAR/kk=
X-Received: by 2002:a17:906:7016:: with SMTP id n22mr26595622ejj.567.1633972638776;
 Mon, 11 Oct 2021 10:17:18 -0700 (PDT)
MIME-Version: 1.0
References: <20211011134503.715740503@linuxfoundation.org>
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 11 Oct 2021 22:47:06 +0530
Message-ID: <CA+G9fYsCPt53vxOoCQtM-2tndioDdzdXdgJT9FV2+c0UhwSs3Q@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/52] 5.4.153-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Song Liu <songliubraving@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Oct 2021 at 19:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.153 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Oct 2021 13:44:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.153-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Following patch caused build failures on stable rc 5.4.

> Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>     powerpc/bpf: Fix BPF_MOD when imm == 1

In file included from arch/powerpc/net/bpf_jit64.h:11,
                 from arch/powerpc/net/bpf_jit_comp64.c:19:
arch/powerpc/net/bpf_jit_comp64.c: In function 'bpf_jit_build_body':
arch/powerpc/net/bpf_jit_comp64.c:415:46: error: implicit declaration
of function 'PPC_RAW_LI'; did you mean 'PPC_RLWIMI'?
[-Werror=implicit-function-declaration]
  415 |                                         EMIT(PPC_RAW_LI(dst_reg, 0));
      |                                              ^~~~~~~~~~
arch/powerpc/net/bpf_jit.h:32:34: note: in definition of macro 'PLANT_INSTR'
   32 |         do { if (d) { (d)[idx] = instr; } idx++; } while (0)
      |                                  ^~~~~
arch/powerpc/net/bpf_jit_comp64.c:415:41: note: in expansion of macro 'EMIT'
  415 |                                         EMIT(PPC_RAW_LI(dst_reg, 0));
      |                                         ^~~~
cc1: all warnings being treated as errors


build url:
https://builds.tuxbuild.com/1zMdjlqarsON688BoMBlpCN2O3m/

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

-- 
Linaro LKFT
https://lkft.linaro.org
