Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0794A5710F3
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 05:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiGLDog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 23:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGLDof (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 23:44:35 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD86E7D797
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 20:44:33 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id r76so6740722iod.10
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 20:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=we/1DkNmncaGQ9XqV3lFJKT4IMXvi4J7Aa7q16uT1D0=;
        b=xtrqwTYdVNs0RGR1A7WHrAkCKZoaZgfjd6ZU4d6y5NCRFwiLrQF/Qo53CkSwA8o90o
         SF224rVDFa7TzxC3SxDlTKzUvvQjjJ4QdyTvn/FupQYSp4TwcKsMH+vcfXdFCFT+igWS
         BJht7APz3gchVxg4pY9y2bxZj+DqVYyqUw6wbiIOgnZ+yun6lsApwY1RJUiL7WPiH5BV
         yI0X9SZI+wgnc3RMVKj24ai9zrIH3iI2emRKnqiETCDr9kYUKVNFMn5CoorUyFbLiaTb
         kHrrDPsD2YXGmh0JwLHyrV4FgdWfhXtuvu93ZDriPPOnrmGrExPJXbnCKgU3yPVTiuj7
         iiSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=we/1DkNmncaGQ9XqV3lFJKT4IMXvi4J7Aa7q16uT1D0=;
        b=48W58fYocQvxTIEdf1PUv3sabUWtvzs2DC5u2mNw0iyw3djJ4/PT/uK3dq+LDqOhAF
         DdJ36b6g5iLo/Il4jFEULqURz+bdgEgdIWRhO974gQ/6Um9h8YBb5NpBCNNpFROFj0mM
         PlYRkfgZvX84OZfVy/jI55OSszGz/GEL5NbNHtxA17uWfvwDpy0ZZPa9vm1m6v8PJUoR
         wcIWo25dIpvgVkdhhgub5wpgkEIW7+vxbXg9plTVK0kjwvw31uoKOs+ypD6DY5lPwt3R
         BrthKo8OfairyI9hnGs+AwWPVFhN6rK/57Xtty15i3xnuyT63Sn2vheDfn7r6Ecim7bt
         KPTA==
X-Gm-Message-State: AJIora/YbQA9Env/EzF9erIE7EmlAT/Fc2bLi9ydvWuEB9OVwpnviRtx
        JZ4iyGKGcBGVpoLtetYoRIP6keO6VemH7qCLdVAO7Q==
X-Google-Smtp-Source: AGRyM1vnfBG8J2KqOfi+KIulVunCE66aScLJ8YMAkErTojUSGg4Sk/jo35jhsILNe1o0voEcDDaRcuJOk8D8pNzlW94=
X-Received: by 2002:a05:6638:272c:b0:33f:6fe4:b76f with SMTP id
 m44-20020a056638272c00b0033f6fe4b76fmr802132jav.284.1657597473066; Mon, 11
 Jul 2022 20:44:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220711145306.494277196@linuxfoundation.org>
In-Reply-To: <20220711145306.494277196@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Jul 2022 09:14:21 +0530
Message-ID: <CA+G9fYsvtJu832j-1NmJ00ZOvGLAxAHUkNWo8PDztT--oO0_Ng@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/229] 5.15.54-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jul 2022 at 20:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.54 release.
> There are 229 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Jul 2022 14:51:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.54-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Regressions found while building for powerpc.

Following powerpc builds failed.

* powerpc, build
  - clang-13-defconfig
  - clang-13-ppc64e_defconfig
  - clang-14-defconfig
  - clang-14-ppc64e_defconfig
  - gcc-10-cell_defconfig
  - gcc-10-defconfig
  - gcc-10-maple_defconfig
  - gcc-10-ppc64e_defconfig
  - gcc-11-cell_defconfig
  - gcc-11-defconfig
  - gcc-11-maple_defconfig
  - gcc-11-ppc64e_defconfig
  - gcc-8-cell_defconfig
  - gcc-8-defconfig
  - gcc-8-maple_defconfig
  - gcc-8-ppc64e_defconfig
  - gcc-9-cell_defconfig
  - gcc-9-defconfig
  - gcc-9-maple_defconfig
  - gcc-9-ppc64e_defconfig
  - gcc-11-allmodconfig
  - gcc-10-allmodconfig
  - clang-13-allmodconfig
  - clang-14-allmodconfig

make --silent --keep-going --jobs=3D8
O=3D/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=3D1 LLVM_IAS=3D0
LD=3Dpowerpc64le-linux-gnu-ld ARCH=3Dpowerpc
CROSS_COMPILE=3Dpowerpc64le-linux-gnu- 'HOSTCC=3Dsccache clang'
'CC=3Dsccache clang'
arch/powerpc/kernel/vdso64/gettimeofday.S: Assembler messages:
arch/powerpc/kernel/vdso64/gettimeofday.S:25: Error: unrecognized
opcode: `cvdso_call'
arch/powerpc/kernel/vdso64/gettimeofday.S:36: Error: unrecognized
opcode: `cvdso_call'
arch/powerpc/kernel/vdso64/gettimeofday.S:47: Error: unrecognized
opcode: `cvdso_call'
arch/powerpc/kernel/vdso64/gettimeofday.S:57: Error: unrecognized
opcode: `cvdso_call_time'
clang: error: assembler command failed with exit code 1 (use -v to see
invocation)
make[2]: *** [scripts/Makefile.build:390:
arch/powerpc/kernel/vdso64/gettimeofday.o] Error 1
make[2]: Target 'include/generated/vdso64-offsets.h' not remade
because of errors.
make[1]: *** [arch/powerpc/Makefile:427: vdso_prepare] Error 2

Build : https://builds.tuxbuild.com/2BnsQzulG0EbhdbiIORptHZwacG/

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
