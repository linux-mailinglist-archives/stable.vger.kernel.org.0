Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEB1677613
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 09:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbjAWIJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 03:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjAWIJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 03:09:25 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8490B59F8
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 00:09:23 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id i188so12009096vsi.8
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 00:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7c/pdOExCcpLLZUD6UA3m2abu2a1/Ie4TH52nAygB5A=;
        b=U33m8q0XyJQsgPxNmhR8Dj4rfbqxHdDFumhoFfPeYGnu3vV1RYXFseHMwdEKUqImxL
         y3drzFDspZvSXPdG2IalmZs792vA9OP4TABizj6X4wY6lQTG0cO7VSw/HDS80+6R4Klp
         FU6q55BEIMSjagGZTknunhScijwjxCYsP3RupTzKmfbrIhAaVrUFNsm8U28U0jeacgQL
         iocDYOeJEkXMqR6KECJ2pFFNh82qv2cfRdo6xbtIEv7qVNj1ytkrP/BcajaLp8HLGwv1
         Hcdo6ccu3AB1scChpieAUCJSOjkKNyR5ERKe2fGpqX4lzy1BMMo84aiF+2Cymf/V9n/I
         iUcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7c/pdOExCcpLLZUD6UA3m2abu2a1/Ie4TH52nAygB5A=;
        b=B0ZbbTcIisyWWDrUWgcUVsLCJ845zH//NIoB0UBFtW8U8FLGhvZjH6IqVYvQU/OYKa
         0ADCWTO9IHdUDtnvae/Ydw9FBB3SthFohi8ZtiuauJy3Rd+672D8wXpNsvn8dAQ6wI9h
         eS/8CiGflpWY2BJrjE5HC+jZV8b9wOqsVgLPth28UMYfpDshcRgkMWpJIx5EVSd+f/e/
         2bn1ceftNw1CK4J0FLaSuhZ0kMALhHwF61lCOeVO/IBVWDvBY9xtyJ29HNDVPhooCatQ
         0qILyiym/kan//p45rnC0ljGbi+qqjioYfVqBDJGIKGhZ1EQvHzV9pQwNbPEU/zp4krS
         mUhQ==
X-Gm-Message-State: AFqh2kqHPnAEjQx4fJdQ+AwelFon2lJkiMZA4VzLYMYvs6YUpYXmDdNa
        Fh4tVzq4trxaSiTsNdSaFh0gqBPGxv0RXbT2B6a5lGRFjMv/8DVZ
X-Google-Smtp-Source: AMrXdXvpdjWNCIvZ712IPqqtV40RJsW2ntvWQWa078Hd7TKDuvhollsWd5E60URXbG01RNQeUmXiZ9lf9HUm3Q4FQ8k=
X-Received: by 2002:a05:6102:4425:b0:3c8:c513:197 with SMTP id
 df37-20020a056102442500b003c8c5130197mr3009317vsb.9.1674461362523; Mon, 23
 Jan 2023 00:09:22 -0800 (PST)
MIME-Version: 1.0
References: <20230122150246.321043584@linuxfoundation.org>
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 23 Jan 2023 13:39:11 +0530
Message-ID: <CA+G9fYsS1GLzMoeh-jz8eOMbomJ=XBg_3FjQ+4w_=Dw1Mwr3rQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
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
        Arnd Bergmann <arnd@arndb.de>, tom.saeger@oracle.com
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

On Sun, 22 Jan 2023 at 20:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

* sh, build
  - gcc-8-dreamcast_defconfig
  - gcc-8-microdev_defconfig


Build error logs:
`.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
defined in discarded section `.exit.text' of crypto/algboss.o
`.exit.text' referenced in section `__bug_table' of
drivers/char/hw_random/core.o: defined in discarded section
`.exit.text' of drivers/char/hw_random/core.o
make[2]: *** [/builds/linux/scripts/Makefile.vmlinux:34: vmlinux] Error 1

Bisection points to this commit,
    arch: fix broken BuildID for arm64 and riscv
    commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.

Ref:
upstream discussion thread,
https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/

Steps to reproduce:
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.
# Original tuxmake command with fragments listed below.

tuxmake --runtime podman --target-arch sh --toolchain gcc-8 --kconfig
microdev_defconfig

Build log links,
https://storage.tuxsuite.com/public/linaro/lkft/builds/2KgeCQc3ZdltaEFoi0Cw=
yJlUcuk/

--
Linaro LKFT
https://lkft.linaro.org
