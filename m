Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D86429EB4
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 09:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhJLHhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 03:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbhJLHhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 03:37:08 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC5FC061745
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 00:35:07 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id w14so25686368edv.11
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 00:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0LdgTQXaIMFK90MNm2LnmaoXjv7Xz1qZCtdN0PVVc54=;
        b=Qiq8iA5ULEqujdzoJDRiufJoirupCSn8sZCgDe767gWHWs0sgPrEVPSs6Qg2ThZQzw
         ditUsjX+68E/QYrCxf1k6wkDf4vIBlcWKBbTkz0Mefc9MVMXlQ/euRUbR7ashmrrxrvr
         tggvc0sIY9OUkq1N1QoaWRKBFs5m+XerdEjwnlqgrTnYaA3ImTDG6vnrKY7AbaNgeDCo
         nnP424+10CuNHb7Rp7Q8q8bPFBbjBCUHEWkhIh5sCUj+FYEYoeWXtIqg6i2VX++knvCg
         YC0h09cOVwdX1QBAcjRHmW2dLsGI+e+6JhlJdu8hoIwKjd3CLzpO5fSp9kWh5bDHankt
         MAMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0LdgTQXaIMFK90MNm2LnmaoXjv7Xz1qZCtdN0PVVc54=;
        b=EUM1xxJ9AY6RaobX1fa5a4yTQZcdcwrp8B5XO0+j5g4zqVPO1fmHMbKEQhgqRFfF/2
         HFnZKfT1RdxaXjGh8UUBFKr0n7BWuWJb8grvLg/ut6Se+ruVt9Limzxf4q1U5TNai4NC
         rhI2iTIStc1nlXUB/LWW0qnFVTY9zCMmslh40m09U2sOxXc8I4gvEsbDJS70jO7rodRa
         9zoYNf8WtxpiaRR9h+OJx2HZTxtUMe0EHGowUUGC0oti321H6UDv/FX5hZrDdg5P6itW
         iZpz6TIxLUZIXWY/w0Z+6oMjGkIs4JZ3+mvONM4FTZ/CdB7RhWqJThhMlKrcxSwK0NdJ
         d1pw==
X-Gm-Message-State: AOAM532Y2u1ARmV2er/aPf97qnBX6gbojFhXGgSL5xund2o8CL9h2wZ3
        1hmJZyH6DAcESBxqhU3H2z0GJdr97jN44AU+sDvXnw==
X-Google-Smtp-Source: ABdhPJwCt53XHpRv0O60+/zV2VTB2O0ZJQiUr07Ip2Ze2mcCpt8//Lsk0vB2lrIScioA4EveNy3rJQRIEtb4pBNUe50=
X-Received: by 2002:a17:906:c302:: with SMTP id s2mr30057500ejz.499.1634024105733;
 Tue, 12 Oct 2021 00:35:05 -0700 (PDT)
MIME-Version: 1.0
References: <20211012064436.577746139@linuxfoundation.org>
In-Reply-To: <20211012064436.577746139@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Oct 2021 13:04:54 +0530
Message-ID: <CA+G9fYt3vmhvuoFJ6p49DHiFE60oBeWUwuSLrh7vXwr=8_rpfg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/52] 5.4.153-rc2 review
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
        Michael Ellerman <mpe@ellerman.id.au>,
        bpf <bpf@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 Oct 2021 at 12:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.153 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Oct 2021 06:44:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.153-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

stable rc 5.4.153-rc2 Powerpc build failed.

In file included from arch/powerpc/net/bpf_jit64.h:11,
                 from arch/powerpc/net/bpf_jit_comp64.c:19:
arch/powerpc/net/bpf_jit_comp64.c: In function 'bpf_jit_build_body':
arch/powerpc/net/bpf_jit.h:32:9: error: expected expression before 'do'
   32 |         do { if (d) { (d)[idx] = instr; } idx++; } while (0)
      |         ^~
arch/powerpc/net/bpf_jit.h:33:33: note: in expansion of macro 'PLANT_INSTR'
   33 | #define EMIT(instr)             PLANT_INSTR(image, ctx->idx, instr)
      |                                 ^~~~~~~~~~~
arch/powerpc/net/bpf_jit_comp64.c:415:41: note: in expansion of macro 'EMIT'
  415 |                                         EMIT(PPC_LI(dst_reg, 0));
      |                                         ^~~~
arch/powerpc/net/bpf_jit.h:33:33: note: in expansion of macro 'PLANT_INSTR'
   33 | #define EMIT(instr)             PLANT_INSTR(image, ctx->idx, instr)
      |                                 ^~~~~~~~~~~
arch/powerpc/net/bpf_jit.h:41:33: note: in expansion of macro 'EMIT'
   41 | #define PPC_ADDI(d, a, i)       EMIT(PPC_INST_ADDI |
___PPC_RT(d) |           \
      |                                 ^~~~
arch/powerpc/net/bpf_jit.h:44:33: note: in expansion of macro 'PPC_ADDI'
   44 | #define PPC_LI(r, i)            PPC_ADDI(r, 0, i)
      |                                 ^~~~~~~~
arch/powerpc/net/bpf_jit_comp64.c:415:46: note: in expansion of macro 'PPC_LI'
  415 |                                         EMIT(PPC_LI(dst_reg, 0));
      |                                              ^~~~~~
make[3]: *** [scripts/Makefile.build:262:
arch/powerpc/net/bpf_jit_comp64.o] Error 1
make[3]: Target '__build' not remade because of errors.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

-- 
Linaro LKFT
https://lkft.linaro.org
