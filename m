Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10DD8595751
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 11:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbiHPJ6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 05:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbiHPJ5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 05:57:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256565A14E;
        Tue, 16 Aug 2022 01:47:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 06468CE170B;
        Tue, 16 Aug 2022 08:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0F9C433D6;
        Tue, 16 Aug 2022 08:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660639627;
        bh=aM++4I5AYzhlbjwHGRFWJiYJnmfNdT6VW1yBEjk0zaY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XXAawc+aF/hivH2xEhW5NKh6h35FTRKtvRHgZYhHEEmF6gLkQQcG/JekUkbUrMc6Q
         jVw3PGKpNwoAn6Rr78WmV8a1n6ribQ9Wal7Jt/XbZzESdn1Tc2fIPvoLPmv5DPZKzH
         fSQ3cZp0c2eW7Jv3sNmDkS8QyZT6ZQNCqKlirLP6nk3JR/CcOaNdHJa3uAK+uXPq3f
         qG6AW8s/mfcuiSPeM3jSGV6WzLWWlsHjsroSF2bQilNuMYm5dNXUHthYF9BQCJ/YLs
         mlfUPn10JwK7yRXM1UoqBNVFnDC5dvLbE64/uEiPTSWVUX97gXAdzCmjhstF63BwQT
         MnZFiES+QguGQ==
Received: by pali.im (Postfix)
        id 117C768B; Tue, 16 Aug 2022 10:47:04 +0200 (CEST)
Date:   Tue, 16 Aug 2022 10:47:03 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 5.15 000/779] 5.15.61-rc1 review
Message-ID: <20220816084703.nbciiu63x4dgulwc@pali>
References: <20220815180337.130757997@linuxfoundation.org>
 <CA+G9fYuXHvYQkWnDac6T8s9XnP_jctCbV=yEx3Z9EhWko2dPPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuXHvYQkWnDac6T8s9XnP_jctCbV=yEx3Z9EhWko2dPPg@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday 16 August 2022 14:11:45 Naresh Kamboju wrote:
> On Mon, 15 Aug 2022 at 23:44, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.61 release.
> > There are 779 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 17 Aug 2022 18:01:29 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.61-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The powerpc defconfig failed on stable-rc 5.15.
> 
> * powerpc, build
>   - gcc-10-ppc6xx_defconfig
>   - gcc-11-ppc6xx_defconfig
>   - gcc-8-ppc6xx_defconfig
>   - gcc-9-ppc6xx_defconfig
> 
> arch/powerpc/sysdev/fsl_pci.c: In function 'fsl_add_bridge':
> arch/powerpc/sysdev/fsl_pci.c:601:39: error:
> 'PCI_CLASS_BRIDGE_PCI_NORMAL' undeclared (first use in this function);
> did you mean 'PCI_CLASS_BRIDGE_PCI'?
>   601 |                         class_code |= PCI_CLASS_BRIDGE_PCI_NORMAL << 8;
>       |                                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                                       PCI_CLASS_BRIDGE_PCI
> arch/powerpc/sysdev/fsl_pci.c:601:39: note: each undeclared identifier
> is reported only once for each function it appears in
> make[3]: *** [scripts/Makefile.build:289: arch/powerpc/sysdev/fsl_pci.o] Error 1

Hello, this is probably because of missing PCI_CLASS_BRIDGE_PCI_NORMAL
define which was added in this change:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/diff/include/linux/pci_ids.h?id=904b10fb189cc15376e9bfce1ef0282e68b0b004

> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Steps to reproduce:
> --------------------
> # To install tuxmake on your system globally:
> # sudo pip3 install -U tuxmake
> #
> # See https://docs.tuxmake.org/ for complete documentation.
> # Original tuxmake command with fragments listed below.
> 
> tuxmake --runtime podman --target-arch powerpc --toolchain gcc-11
> --kconfig ppc6xx_defconfig
> 
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
