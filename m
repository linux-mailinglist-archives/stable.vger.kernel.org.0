Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6169D5956D3
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 11:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbiHPJn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 05:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233835AbiHPJmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 05:42:52 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD68E115A
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 01:41:58 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id i14so17605709ejg.6
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 01:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=m7Ylrhpsm6OVfghN5qH4zCT0WFeKmrFF6mCDrHN6og0=;
        b=z75K1phbqPlNfL1Bdg7U4n5nvKu7v9Jn1AXWrXin10tH6qqLH5SNIXPBfRkvhCmCqR
         gWzNMB4cKuoGCJf5M02GSGsLsO2Mo76s7R/DaStA4YfuqiC8kd4maI5J3UPk/N1R6csp
         WbnecpfSKfO1CSkDfPejCzlSIFsf4pQBsdf0Lw/eEHku2pk6QsntrFaPuqp8RokxErVp
         TwC6PFV85a/gW/JImsk9hAODQ+9CYlqMZapgRLmvMCTBU3EV0VYsfjakmlWpQCed/SJf
         KSHDt2kuFiUPnx6uT4WkiHx8OXmoitZt9UVgpWR8cCmRTCAk9Yz9TUuFWU+7fv1dnU5a
         3jrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=m7Ylrhpsm6OVfghN5qH4zCT0WFeKmrFF6mCDrHN6og0=;
        b=ZQ1zf/M8duYLOAvq1BWMzamhl1l7S+MaNl7bO66s9E+ko+b7ncD4xeLDs5dyZgVXJr
         sTcn7DxRMxKzIfJ8jQCPnO9CK7ddp4qz6lCnbiR++j+nd71BckaRgICxkZ0SUcUhei4+
         DMkwWfwYA1FsIBnXpQBoI3dQW/qpc9c8LF/2Fs5nxntkmUR/B4VriGDX4BeyyztTgmJV
         zVIicw0Wx3Eiki5pO3aj0TYvQX7urlLfifYVbJT8FftjilzlUy/Um8kJU6RxnbzXdeRk
         Kj4uP8LjvXzjc/9Wd3sDwTLfRpM98Ytnj07UB+DWX10xn7uLE+AbeiakICMC8VXhmSQn
         1PkQ==
X-Gm-Message-State: ACgBeo2uese7JGZHsT2gD+UuBixGTbdPhVpBd4xLJEhywzO3nsiehg8J
        AmsfyeVT5T3uo16HFhiqdA08ySS31sMYQJ8A/PBYog==
X-Google-Smtp-Source: AA6agR5WJcbhdI+a8fZ4r4PXRD9/RB3FMkf3bBU2V6bl986OSujcFf8WPx4pl8Erh1Ikff3d5PXSq+8N15Zu34T5E4o=
X-Received: by 2002:a17:907:2cd1:b0:730:a980:d593 with SMTP id
 hg17-20020a1709072cd100b00730a980d593mr12859182ejc.48.1660639316945; Tue, 16
 Aug 2022 01:41:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220815180337.130757997@linuxfoundation.org>
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Aug 2022 14:11:45 +0530
Message-ID: <CA+G9fYuXHvYQkWnDac6T8s9XnP_jctCbV=yEx3Z9EhWko2dPPg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/779] 5.15.61-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Aug 2022 at 23:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.61 release.
> There are 779 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 Aug 2022 18:01:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.61-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The powerpc defconfig failed on stable-rc 5.15.

* powerpc, build
  - gcc-10-ppc6xx_defconfig
  - gcc-11-ppc6xx_defconfig
  - gcc-8-ppc6xx_defconfig
  - gcc-9-ppc6xx_defconfig

arch/powerpc/sysdev/fsl_pci.c: In function 'fsl_add_bridge':
arch/powerpc/sysdev/fsl_pci.c:601:39: error:
'PCI_CLASS_BRIDGE_PCI_NORMAL' undeclared (first use in this function);
did you mean 'PCI_CLASS_BRIDGE_PCI'?
  601 |                         class_code |= PCI_CLASS_BRIDGE_PCI_NORMAL << 8;
      |                                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                                       PCI_CLASS_BRIDGE_PCI
arch/powerpc/sysdev/fsl_pci.c:601:39: note: each undeclared identifier
is reported only once for each function it appears in
make[3]: *** [scripts/Makefile.build:289: arch/powerpc/sysdev/fsl_pci.o] Error 1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Steps to reproduce:
--------------------
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.
# Original tuxmake command with fragments listed below.

tuxmake --runtime podman --target-arch powerpc --toolchain gcc-11
--kconfig ppc6xx_defconfig


--
Linaro LKFT
https://lkft.linaro.org
