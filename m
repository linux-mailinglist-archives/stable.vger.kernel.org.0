Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4483259F41D
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 09:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbiHXHYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 03:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiHXHY3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 03:24:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2933ECC5;
        Wed, 24 Aug 2022 00:24:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35009616D4;
        Wed, 24 Aug 2022 07:24:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB26C433D6;
        Wed, 24 Aug 2022 07:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661325867;
        bh=PvoFh1O3RFCDEFFhBTKUZfLH5PbVeF4JPYs/N/mME/w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nR5ZBAIz0u/Nu0xX5US7JG4TVjWSYuSHjRq29sE6Vp5JQJ9+zMfUuiPVdohZO22fM
         iN1i5SOafaVjrCsXn4WG0x/x/WLP3VldjknNte6MLDak8wm7Mnn+4j5mxBP+CCyfFR
         FVrc9Y+onJkxw36A7olHtH59WgIGxxZxpdXxLy4A=
Date:   Wed, 24 Aug 2022 09:24:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 000/101] 4.9.326-rc1 review
Message-ID: <YwXSKJ9iuB8/TXGz@kroah.com>
References: <20220823080034.579196046@linuxfoundation.org>
 <20220823210018.GA2371231@roeck-us.net>
 <20220823212508.GA2588726@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823212508.GA2588726@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 02:25:08PM -0700, Guenter Roeck wrote:
> On Tue, Aug 23, 2022 at 02:00:20PM -0700, Guenter Roeck wrote:
> > On Tue, Aug 23, 2022 at 10:02:33AM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.9.326 release.
> > > There are 101 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
> > > Anything received after that time might be too late.
> > > 
> > Build results:
> > 	total: 164 pass: 141 fail: 23
> > Failed builds:
> > 	arm:allmodconfig
> > 	arm:imx_v6_v7_defconfig
> > 	arm:ixp4xx_defconfig
> > 	arm:u8500_defconfig
> > 	arm:multi_v5_defconfig
> > 	arm:omap1_defconfig
> > 	arm:footbridge_defconfig
> > 	arm:axm55xx_defconfig
> > 	arm:keystone_defconfig
> > 	arm:vexpress_defconfig
> > 	arm:at91_dt_defconfig
> > 	arm:shmobile_defconfig
> > 	arm:nhk8815_defconfig
> > 	arm:orion5x_defconfig
> > 	arm:exynos_defconfig
> > 	arm:cm_x2xx_defconfig
> > 	arm:integrator_defconfig
> > 	arm:pxa910_defconfig
> > 	ia64:defconfig
> > 	ia64:allnoconfig
> > 	ia64:tinyconfig
> > 	score:defconfig
> > 	um:defconfig
> > Qemu test results:
> > 	total: 394 pass: 343 fail: 51
> > Failed tests:
> > 	arm:versatilepb:versatile_defconfig:aeabi:pci:scsi:mem128:net,default:versatile-pb:rootfs
> > 	arm:versatilepb:versatile_defconfig:aeabi:pci:mem128:net,default:versatile-pb:initrd
> > 	arm:versatileab:versatile_defconfig:mem128:net,default:versatile-ab:initrd
> > 	arm:smdkc210:exynos_defconfig:cpuidle:nocrypto:mem128:exynos4210-smdkv310:initrd
> > 	arm:smdkc210:exynos_defconfig:cpuidle:nocrypto:sd2:mem128:exynos4210-smdkv310:rootfs
> > 	arm:realview-pb-a8:realview_defconfig:realview_pb:mem512:net,default:arm-realview-pba8:initrd
> > 	arm:realview-pbx-a9:realview_defconfig:realview_pb:net,default:arm-realview-pbx-a9:initrd
> > 	arm:realview-eb:realview_defconfig:realview_eb:mem512:net,default:arm-realview-eb:initrd
> > 	arm:realview-eb-mpcore:realview_defconfig:realview_eb:mem512:net,default:arm-realview-eb-11mp-ctrevb:initrd
> > 	arm:akita:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:initrd
> > 	arm:borzoi:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:net,usb:initrd
> > 	arm:borzoi:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:mmc:net,usb:rootfs
> > 	arm:borzoi:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:ata:net,usb:rootfs
> > 	arm:borzoi:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:usb:net,usb:rootfs
> > 	arm:spitz:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:net,usb:initrd
> > 	arm:spitz:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:mmc:net,usb:rootfs
> > 	arm:spitz:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:ata:net,usb:rootfs
> > 	arm:spitz:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:usb:net,usb:rootfs
> > 	arm:terrier:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:net,usb:initrd
> > 	arm:terrier:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:mmc:net,usb:rootfs
> > 	arm:terrier:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:ata:net,usb:rootfs
> > 	arm:terrier:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:usb:net,usb:rootfs
> > 	arm:integratorcp:integrator_defconfig:mem128:net,default:integratorcp:initrd
> > 	arm:integratorcp:integrator_defconfig:mem128:sd:net,default:integratorcp:rootfs
> > 	mips:malta_defconfig:nocd:smp:net,e1000:initrd
> > 	mips:malta_defconfig:nocd:smp:net,pcnet:flash,4,1,1:rootfs
> > 	mips:malta_defconfig:nocd:smp:net,pcnet:ide:rootfs
> > 	mips:malta_defconfig:nocd:smp:net,e1000:usb-xhci:rootfs
> > 	mips:malta_defconfig:nocd:smp:net,e1000-82545em:usb-uas-xhci:rootfs
> > 	mips:malta_defconfig:nocd:smp:net,i82801:usb-ehci:rootfs
> > 	mips:malta_defconfig:nocd:smp:net,ne2k_pci:sdhci:mmc:rootfs
> > 	mips:malta_defconfig:nocd:smp:net,pcnet:scsi[53C810]:rootfs
> > 	mips:malta_defconfig:nocd:smp:net,rtl8139:scsi[53C895A]:rootfs
> > 	mips:malta_defconfig:nocd:smp:net,tulip:scsi[DC395]:rootfs
> > 	mips:malta_defconfig:nocd:smp:net,virtio-net:scsi[AM53C974]:rootfs
> > 	mips:malta_defconfig:nocd:smp:net,i82550:scsi[MEGASAS]:rootfs
> > 	mips:malta_defconfig:nocd:smp:net,i82558a:scsi[MEGASAS2]:rootfs
> > 	mips:malta_defconfig:nocd:smp:net,i82562:scsi[FUSION]:rootfs
> > 	mips:malta_defconfig:nocd:nosmp:net,e1000:initrd
> > 	mips:malta_defconfig:nocd:nosmp:ide:net,pcnet:rootfs
> > 	mipsel:mips32r6-generic:malta_32r6_defconfig:nocd:smp:net,pcnet:ide:rootfs
> > 	sheb:rts7751r2dplus_defconfig:initrd
> > 	sheb:rts7751r2dplus_defconfig:ata:rootfs
> > 	xtensa:dc232b:lx60:generic_kc705_defconfig
> > 	xtensa:dc232b:lx200:generic_kc705_defconfig
> > 	xtensa:dc232b:kc705:generic_kc705_defconfig
> > 	xtensa:dc232b:kc705:generic_kc705_defconfig
> > 	xtensa:dc233c:ml605:generic_kc705_defconfig
> > 	xtensa:dc233c:kc705:generic_kc705_defconfig
> > 	xtensa:dc233c:kc705:generic_kc705_defconfig
> > 	xtensa:de212:kc705-nommu:nommu_kc705_defconfig
> > 
> > Some change must have caused problems with the old binutils / linker
> > version used when building v4.9.y kernels in my test bed.
> > 
> 
> Bisected with ia64 to commit 26f954a9e4e2 ("Makefile: link with -z
> noexecstack --no-warn-rwx-segments"). I did not test everything,
> but every build I did test passes with this patch reverted.

Ick, I was trying to fix up builds with newer binutils.  Seems to have
worked for 4.14.y, but not 4.9.y.  I'll go revert the above commit, and
2 others, and push out a -rc2.

thanks for testing and letting me know.

greg k-h
