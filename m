Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D4C6439C4
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 01:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiLFAEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 19:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbiLFAEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 19:04:47 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9344520344
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 16:04:45 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id y4so12372265plb.2
        for <stable@vger.kernel.org>; Mon, 05 Dec 2022 16:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oIMcbh4Uza3ztFNGSDLU+/U5crvobqjVftiDBSiwTjk=;
        b=pSZbv8jBbICX53SlYjb8kfYWE3h9Xp3SKfUcz9N2Xlw4pqyBzRf4Yk8A4IMeEJ+878
         i1nF/+l414qa4Jb+nYx92bWOfo5PFuScpurW212olKgS1QqkNhB9HFOHAn3nT1Dw6YaN
         PYZl/j0wGMXUV96HKRjH9XjVErJr4ESYh/QtGAyfafw/teHs0DROzMzugRtToH77GZSc
         JP/1JzgLTqrdlD+XEgeSSl9RGZxgf19LW9ZtGZcsITWSfCyjNObwmseVYM7bb64XkKr1
         SYgd+HeBUBZeiN/tZam/6FgQpk0Lc4sE617p91QhKBlDenDwmySowdQrGB6xBpOgBtCn
         uZXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oIMcbh4Uza3ztFNGSDLU+/U5crvobqjVftiDBSiwTjk=;
        b=hifXITJZUZLDuZTLjB/2i9O8yQ/Y2Y30n5hix8NejudRFR6IaGHU2cXhE1kxPaF2Df
         vNyzVw/X0uwuil603VXUNF5flV7Fg7Eh6KDx6cVDva/llxotV1aIJxr4bVwc9qLzNM0o
         93StobylE3YAyUgGmlbO55Cx2B/zyoiqlQ6vnHeIGyoyl8navxV452+0LpbP3L2s5M0K
         QsU66OYT+k6od/OOy49NnioEf7U762bT/uZLpJZi8c2WuRWOvXM1YHenU0eko8ZgRE7P
         DujFNCP0i75VL+ky+10frb3+UiVMksyIHY/bprAHb+JoWMIFftfwYMKkqt7kpOVd0caz
         i8PA==
X-Gm-Message-State: ANoB5pn5kQgE1aiF027/8mk5+ScRCYwTH+FMoiqF43I4P0gh1654qSTF
        ufEXe59Ral7Ygo1/xHuvJjkR0t/DZ3chcZYAkg+RaA==
X-Google-Smtp-Source: AA0mqf7o+e/O4Si5bnux9v49E5VbINeJXvopUH90PUMpqIJ6jEiLmVFajyOtNlHjSUmScud+fQ5NBZOgC9+va6fzbYI=
X-Received: by 2002:a17:90a:6382:b0:219:fbc:a088 with SMTP id
 f2-20020a17090a638200b002190fbca088mr53133493pjj.162.1670285084989; Mon, 05
 Dec 2022 16:04:44 -0800 (PST)
MIME-Version: 1.0
References: <20221205190806.528972574@linuxfoundation.org>
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Mon, 5 Dec 2022 18:04:33 -0600
Message-ID: <CAEUSe7_2g6fde2JU7_yA9QCK+FfdLshCRnDd81FF3=SJwwDAzg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/120] 5.15.82-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        guoren@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On Mon, 5 Dec 2022 at 13:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.82-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.15.82-rc1
[...]
> Guo Ren <guoren@linux.alibaba.com>
>     riscv: kexec: Fixup crash_smp_send_stop without multi cores
[...]

We have found regression with RISC V with GCC 8 and 11:
-----8<----------8<----------8<-----
/builds/linux/arch/riscv/kernel/smp.c: In function 'handle_IPI':
/builds/linux/arch/riscv/kernel/smp.c:195:44: error: 'cpu' undeclared
(first use in this function)
  195 |                         ipi_cpu_crash_stop(cpu, get_irq_regs());
      |                                            ^~~
/builds/linux/arch/riscv/kernel/smp.c:195:44: note: each undeclared
identifier is reported only once for each function it appears in
/builds/linux/arch/riscv/kernel/smp.c:217:22: error: 'old_regs'
undeclared (first use in this function)
  217 |         set_irq_regs(old_regs);
      |                      ^~~~~~~~
make[3]: *** [/builds/linux/scripts/Makefile.build:289:
arch/riscv/kernel/smp.o] Error 1
make[3]: Target '__build' not remade because of errors.
make[2]: *** [/builds/linux/scripts/Makefile.build:552:
arch/riscv/kernel] Error 2
make[2]: Target '__build' not remade because of errors.
make[1]: *** [/builds/linux/Makefile:1900: arch/riscv] Error 2
make[1]: Target '__all' not remade because of errors.
make: *** [Makefile:219: __sub-make] Error 2
----->8---------->8---------->8-----

Bisection points to the above commit ("riscv: kexec: Fixup
crash_smp_send_stop without multi cores"). Reverting it makes the
build pass.

In order to reproduce:
# See https://docs.tuxmake.org/ for complete documentation.
# Original tuxmake command with fragments listed below.
tuxmake --runtime podman --target-arch riscv --toolchain gcc-11
--kconfig defconfig

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
