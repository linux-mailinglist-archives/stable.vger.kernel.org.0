Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9881E677565
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 08:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjAWHJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 02:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjAWHJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 02:09:29 -0500
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C65511144
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 23:09:28 -0800 (PST)
Received: by mail-vk1-xa29.google.com with SMTP id w72so5512569vkw.7
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 23:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l+yTYlDwMs/8VLwuGIhXdyxg3bRiWziZ42OeRXEy0kQ=;
        b=Nza06cIStYfGFwNEm5+/EVYMiXXvKDJFM4Gc+sWZboo5WU5Nl3EK4JZ5V/GV7CNNqu
         q3AbnWHmn/9aw/aIuMWdDd2vf1zG5vutMxP1D8kSDeqBKhpUe3F1lDmakfEPGnuxh6zl
         YxonePUOEpUitp0KGAQvdeSADMHQSl7pEaJAiv1dTLbhsu1wCY6ZzM6aSyQxcHMPgxFG
         IiJPl54PkjlYIpcgNPlXm9icFG3H+4m1UVsMHN8qdL54bOcVWtvcglQXz3SmyYVkcOaH
         73oYElU+GTKRe0gEBU3Nay1RwDPytsaQPq8V9NfbChwpj6ajNwOEOo57XwkKSqWUnwu6
         e2qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l+yTYlDwMs/8VLwuGIhXdyxg3bRiWziZ42OeRXEy0kQ=;
        b=q3ROjrxOblLMIYcXYfEUNGKFr1P+meO+qzsPrWDVJSQTvTU07m3mhDMyRWvGg27T/5
         pKP330ZeDZdyOWQP106Dk7zTiAmk/TWuJBfhMTYjo2ND6B6T0kVVXJhT5qn1OfniMz/j
         JFKASDL1Tv0o4VmZDTFMHSXeBUoDolcG0sckRW5mveGyPNlQqaM/tXdDGIJBPLWN0f7N
         Bon016BVuF1VfBXHUWZn2K6yaSlvhPZdxqazzPk9yRurPeUzPWrgKlINCq+P9T9OrxfN
         ugLrSIxc40VMT5VPX+HPLksC7WotHAUOUH60jK2j9Y8Ak971vR+o+clQraHYH9JAVhWP
         EVLQ==
X-Gm-Message-State: AFqh2kr6AJ+QDexykqoZIX2MqHBEiQjO6tSmr0SQcAqTZhF4BBP61o0P
        nkmva+BjsNSf8Qz8g8V7dyB7mwsX81S8JotUQ/8NOQ==
X-Google-Smtp-Source: AMrXdXvjN8CIjK/t+dcB/fpWQDTmC82wWzDZDxzKHCXMXEVKyBh6qx9vdkPyz1pFU+MqdDSv9SmESuTcDn9lu5GQ9AI=
X-Received: by 2002:a1f:5dc1:0:b0:3e1:9fdf:7740 with SMTP id
 r184-20020a1f5dc1000000b003e19fdf7740mr2972059vkb.20.1674457767097; Sun, 22
 Jan 2023 23:09:27 -0800 (PST)
MIME-Version: 1.0
References: <20230122150222.210885219@linuxfoundation.org>
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 23 Jan 2023 12:39:16 +0530
Message-ID: <CA+G9fYuYi1Rvv19R_EVdht_7LV9qiR-6KVvZUGjct3kEk0uQTA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/55] 5.4.230-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>
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

On Sun, 22 Jan 2023 at 20:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.230 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.230-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


Regressions found on i386:
    - build/gcc-8-i386_defconfig

Regressions found on powerpc:
    - build/gcc-8-mpc83xx_defconfig
    - build/gcc-8-ppc64e_defconfig
    - build/gcc-8-maple_defconfig
    - build/gcc-8-ppc6xx_defconfig
    - build/gcc-8-defconfig
    - build/gcc-8-tqm8xx_defconfig
    - build/gcc-8-cell_defconfig

Regressions found on sh:
    - build/gcc-8-dreamcast_defconfig
    - build/gcc-8-microdev_defconfig

Regressions found on s390:
    - build/gcc-8-defconfig-fe40093d

Regressions found on x86_64:
    - build/gcc-8-x86_64_defconfig

Build error:
arch/x86/entry/entry_64.o: warning: objtool: .entry.text+0x1c1:
unsupported intra-function call
arch/x86/entry/entry_64.o: warning: objtool: If this is a retpoline,
please patch it in with alternatives and annotate it with
ANNOTATE_NOSPEC_ALTERNATIVE.
`.exit.text' referenced in section `.orc_unwind_ip' of
arch/x86/events/rapl.o: defined in discarded section `.exit.text' of
arch/x86/events/rapl.o
`.exit.text' referenced in section `.orc_unwind_ip' of
arch/x86/events/rapl.o: defined in discarded section `.exit.text' of
arch/x86/events/rapl.o
`.exit.text' referenced in section `.orc_unwind_ip' of
arch/x86/events/intel/uncore.o: defined in discarded section
`.exit.text' of arch/x86/events/intel/uncore.o
...

Bisection points to this commit,
    arch: fix broken BuildID for arm64 and riscv
    commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.

Upstream discussion thread,
  https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/

Steps to reproduce:
-------------------
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.
# Original tuxmake command with fragments listed below.
# tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-8
--kconfig x86_64_defconfig

Build url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2KgdmU2GQpPtTDTC696G=
7v6ytm8/
