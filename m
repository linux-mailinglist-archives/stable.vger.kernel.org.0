Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63DD64AFEB
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 07:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234578AbiLMGbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 01:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234258AbiLMGbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 01:31:39 -0500
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3081B1F610
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 22:31:38 -0800 (PST)
Received: by mail-vk1-xa32.google.com with SMTP id o136so1112235vka.2
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 22:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VKyiy6rqr1s8RJTj8dqYYvulLQtys2Tc8voFn45GrzU=;
        b=NnBfkXq/VChaqULajdA2qKhgoUKMVhfTWXDRqpnMJhcaCulwkj2CeMqrn3/Ay8AhRW
         QUzdNE2kHqWMU33rDF5ccUEetiaPQr1oorsvAOAs8aiV377T546SzLQ70fDXdqzqQGVe
         Fo4GryWPAmQHtqg/K/SWpXqvd0llTX1VG1YxarbtBjH17GbaOQXe+nnQqvYzPJ2JGCU9
         tm3s2YqwOXRAC0IbnyuUO2ulXHs1eZCSX2T+EulxW0Y57VjaSTVlBAGxSsYgsDQS63Iu
         enNs86Tt9+2YTs/8XLRHGtZ1CRjsQGENbDiQgZlfonUyN9kOV1X9eeV5JJFhBzexD2iD
         dvoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VKyiy6rqr1s8RJTj8dqYYvulLQtys2Tc8voFn45GrzU=;
        b=yaX8gS8T/wYBART1h9ZYHedjBAJ8aH/z29fhYmKAtGpqm5ppUA3qtesUR8aCMJBv3Y
         lItRlk49t5vdlY9VCfbQkOJgEfDGv6G+Tzek9eeCM+4DLlx1/5qor/YDtrNy5wHnysMs
         ANj5SzioQ5zm5w9dhyEA+p9CYspCSugP6w8m891GJi7mX3Sy/tph/x2HxvEQn2m8yqB6
         tzQg80HdaHJIRf/vA255dDlWwznPYfyCKNLG3zOZJyMxhtApfVCGD0RgZdbA2EuxtVlB
         3tuz1a4fjHjipGiLdNH8D4f3h+VeBzzvQhYOu/4PiHITaKCYlVnZX/d1c8QKyfLniFb7
         dVaw==
X-Gm-Message-State: ANoB5plmfAby0EBrwty4sSEfTVKP38oU40dslzh6FzkTe0JePRoXUOwx
        lVaCq+WfOwssCzFJOzHKU2W3zUYL8fWQR2iLtMlFJjDuzGyrHTKJ
X-Google-Smtp-Source: AA0mqf6jhubMdHwDvWT6AMebwaCz1mRJs22GLf8fj9JPa0C0R/H+CjLzed+EqoKIH7jkDZGht5kh9bXEwwhYOruAooI=
X-Received: by 2002:a05:6122:1437:b0:3bd:dc4d:fb7d with SMTP id
 o23-20020a056122143700b003bddc4dfb7dmr6550693vkp.7.1670913097036; Mon, 12 Dec
 2022 22:31:37 -0800 (PST)
MIME-Version: 1.0
References: <20221212130934.337225088@linuxfoundation.org>
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Dec 2022 12:01:25 +0530
Message-ID: <CA+G9fYt7QTkGWPhj0NX8bcDOvEvf9jOW5Oaj8T2zmzasHjo1yA@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/157] 6.0.13-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        llvm@lists.linux.dev
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Dec 2022 at 19:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.13 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

This is an additional report.
Following issue is specific to clang nightly,

x86 clang-nightly builds failed with defconfig and tinyconfig due to
below errors / warnings.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Regressions found on x86_64:

    - build/clang-nightly-tinyconfig
    - build/clang-nightly-x86_64_defconfig
    - build/clang-nightly-allnoconfig
    - build/clang-nightly-lkftconfig

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=1 LLVM_IAS=1
ARCH=x86_64 SRCARCH=x86 CROSS_COMPILE=x86_64-linux-gnu- HOSTCC=clang
CC=clang

ld.lld: error: version script assignment of 'LINUX_2.6' to symbol
'__vdso_sgx_enter_enclave' failed: symbol not defined
llvm-objdump: error: 'arch/x86/entry/vdso/vdso64.so.dbg': No such file
or directory
llvm-objcopy: error: 'arch/x86/entry/vdso/vdso64.so.dbg': No such file
or directory
make[4]: *** [/builds/linux/arch/x86/entry/vdso/Makefile:136:
arch/x86/entry/vdso/vdso64.so] Error 1

Steps to reproduce:
--------------------
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.
# Original tuxmake command with fragments listed below.
# tuxmake --runtime podman --target-arch x86_64 --toolchain
clang-nightly --kconfig x86_64_defconfig LLVM=1 LLVM_IAS=1

tuxmake --runtime podman --target-arch x86_64 --toolchain
clang-nightly --kconfig
https://builds.tuxbuild.com/2IocvUIXEK9MUve4Uut67U0xskC/config LLVM=1
LLVM_IAS=1

Details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.12-158-g57dda3cf2efc/testrun/13588489/suite/build/test/clang-nightly-x86_64_defconfig/details/


--
Linaro LKFT
https://lkft.linaro.org
