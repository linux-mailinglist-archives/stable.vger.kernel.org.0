Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D886BC81B
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 09:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjCPICu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 04:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCPICt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 04:02:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C0A509B6;
        Thu, 16 Mar 2023 01:02:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 446116199C;
        Thu, 16 Mar 2023 08:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD2FC433D2;
        Thu, 16 Mar 2023 08:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678953752;
        bh=sCg7LY++8tSg2hrlbPjQpl0Er0nwVxgieBMOEu+U/As=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aLxmWmCa/LngmD3xlP3zeb0KUYTZ7rMzgDDADHHf1Q4JvNtgmI0sN/C4645s4xt7U
         NFB1jLWtT56V6qRduvwM7zbi4EclGy8H5PAhKxavcQKY4kRNuqYSG2N1XBEd0Oey3k
         h7hYu15oXiqIm3rIxNcpK9mGYXjZrAICNkJ6QcQU=
Date:   Thu, 16 Mar 2023 09:02:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/143] 6.1.20-rc1 review
Message-ID: <ZBLNFrZmpOLvGJCb@kroah.com>
References: <20230315115740.429574234@linuxfoundation.org>
 <b97c4328-54fd-0461-5fa9-323a0d2ba1f4@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b97c4328-54fd-0461-5fa9-323a0d2ba1f4@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 09:21:53AM -0600, Daniel Díaz wrote:
> Hello!
> 
> On 15/03/23 06:11, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.20 release.
> > There are 143 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.20-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> 
> Build failures on PowerPC (GCC-8, GCC-12, Clang-16, Clang-nightly) on:
> * cell_defconfig
> * mpc83xx_defconfig
> 
> -----8<-----
> In file included from /builds/linux/drivers/usb/host/ohci-hcd.c:1253:
> /builds/linux/drivers/usb/host/ohci-ppc-of.c: In function 'ohci_hcd_ppc_of_probe':
> /builds/linux/drivers/usb/host/ohci-ppc-of.c:123:13: error: 'NO_IRQ' undeclared (first use in this function); did you mean 'NR_IRQS'?
>   if (irq == NO_IRQ) {
>              ^~~~~~
>              NR_IRQS
> ----->8-----
> 
> 
> PowerPC with GCC-8 and GCC-12, for ppc6xx_defconfig:
> 
> -----8<-----
> /builds/linux/drivers/ata/pata_mpc52xx.c: In function 'mpc52xx_ata_probe':
> /builds/linux/drivers/ata/pata_mpc52xx.c:734:17: error: 'NO_IRQ' undeclared (first use in this function); did you mean 'NR_IRQS'?
>   if (ata_irq == NO_IRQ) {
>                  ^~~~~~
>                  NR_IRQS
> /builds/linux/drivers/ata/pata_mpc52xx.c:734:17: note: each undeclared identifier is reported only once for each function it appears in
> make[4]: *** [/builds/linux/scripts/Makefile.build:250: drivers/ata/pata_mpc52xx.o] Error 1
> make[4]: Target 'drivers/ata/' not remade because of errors.
> make[3]: *** [/builds/linux/scripts/Makefile.build:500: drivers/ata] Error 2
> In file included from /builds/linux/drivers/usb/host/ehci-hcd.c:1321:
> /builds/linux/drivers/usb/host/ehci-ppc-of.c: In function 'ehci_hcd_ppc_of_probe':
> /builds/linux/drivers/usb/host/ehci-ppc-of.c:122:13: error: 'NO_IRQ' undeclared (first use in this function); did you mean 'NR_IRQS'?
>   if (irq == NO_IRQ) {
>              ^~~~~~
>              NR_IRQS
> /builds/linux/drivers/usb/host/ehci-ppc-of.c:122:13: note: each undeclared identifier is reported only once for each function it appears in
> make[5]: *** [/builds/linux/scripts/Makefile.build:250: drivers/usb/host/ehci-hcd.o] Error 1
> In file included from /builds/linux/drivers/usb/host/ohci-hcd.c:1253:
> /builds/linux/drivers/usb/host/ohci-ppc-of.c: In function 'ohci_hcd_ppc_of_probe':
> /builds/linux/drivers/usb/host/ohci-ppc-of.c:123:13: error: 'NO_IRQ' undeclared (first use in this function); did you mean 'NR_IRQS'?
>   if (irq == NO_IRQ) {
>              ^~~~~~
>              NR_IRQS
> /builds/linux/drivers/usb/host/ohci-ppc-of.c:123:13: note: each undeclared identifier is reported only once for each function it appears in
> ----->8-----

Those all should be fixed in -rc2.

> 
> 
> PowerPC with GCC-8 and GCC-12, for ppc64e_defconfig:
> 
> -----8<-----
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:237: arch/powerpc/boot/crt0.o] Error 1
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:237: arch/powerpc/boot/crtsavres.o] Error 1
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:235: arch/powerpc/boot/cuboot.o] Error 1
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:238: arch/powerpc/boot/div64.o] Error 1
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:234: arch/powerpc/boot/devtree.o] Error 1
> [...]
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:235: arch/powerpc/boot/fdt_sw.o] Error 1
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:235: arch/powerpc/boot/fdt_wip.o] Error 1
> make[2]: Target 'arch/powerpc/boot/zImage' not remade because of errors.
> make[1]: *** [/builds/linux/arch/powerpc/Makefile:247: zImage] Error 2
> make[1]: Target '__all' not remade because of errors.
> make: *** [Makefile:238: __sub-make] Error 2
> make: Target '__all' not remade because of errors.
> ----->8-----

Odd, ok, I think I've fixed this one up as well now.

thanks

greg k-h
