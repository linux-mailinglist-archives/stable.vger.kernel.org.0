Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6EAC59EDF5
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 23:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiHWVFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 17:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbiHWVAW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 17:00:22 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4BA792F5;
        Tue, 23 Aug 2022 14:00:21 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id z187so14570671pfb.12;
        Tue, 23 Aug 2022 14:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=llF/Z9RKGbAToint2Q3pYV/WcHsJ2EzQ2K+586Fwtzg=;
        b=Z2b0XFlRKLzo0KPhUmL7G6a3nzRNVfIlMez11msmUgyTi4CY8yPLlpKq45M5aRZpmS
         UVzAvEIOxw3EL9NJroTKO4rzuxNvreNxZ1GyAlGcDVh7+xrf+/ezeko5ghx7tucntbwF
         hjL0ZVLwH5laEBW+YUThbBNfmJ7w+Fj6Cp94tJ/OYd4j7BJc9vmqBWANWMWGRi3ogDpK
         OiUjWz8EwbSGUVM3fPEQ1N+9tfWbKu6ulSOiHytMc4PcW6ZlXkVkciPQj08YIPzBxdz0
         HVAuSNN/CrlucWlB99lmu2W+S5vQs1MBny5xTSIRF9uk23HAFAxoDeie2nN04Px49y9s
         QT4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=llF/Z9RKGbAToint2Q3pYV/WcHsJ2EzQ2K+586Fwtzg=;
        b=STiiVsbQIBw0gUOlzGJVm4V0Xdlf5k32Kjp+buI0D4TzrnNCTO1gbYwxdL35PPPPbK
         oehR0maj+T8Oyx2BTsTAVzbfd3dytCalLZcbRS2KEgj4UyM4dY8pwto/vB5AGH92feak
         4J5Hx7Im5QHZZeVjKEaDe3APM7NsPnxISHkEun9su0QdEVsMUkfSELqMRVb9upUNrVqv
         bYuFYFR9imqLr+cqLPGST4O6Z6oJs2oTmAeO34j2ZYgg1fUi5y0v4k2/jNbJF6qeXN20
         T2gjcbzXEWWvq5P+cAedFn3hBPsMasWsxfCWL4nHS4eOmR1/K7mBfBKgOiHN+RQmjyEx
         Y9DQ==
X-Gm-Message-State: ACgBeo2n0e1FVUTXV41huWC+oRjkBrCLLE/eAesx3QBMgp6SETv+F9h7
        re+Tt3Yr7u5ulE40ER30ox8=
X-Google-Smtp-Source: AA6agR5znyIZN3Po17o+XN3W8ysSiZ3nrMIj9VUiPxfMtsbcTWAg1twpukar8m3YeaJVxQIGVG+p5Q==
X-Received: by 2002:a63:8749:0:b0:41d:89d4:ce3d with SMTP id i70-20020a638749000000b0041d89d4ce3dmr20976837pge.344.1661288420750;
        Tue, 23 Aug 2022 14:00:20 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k1-20020aa79721000000b0053675c0b773sm5826262pfg.88.2022.08.23.14.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 14:00:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 23 Aug 2022 14:00:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 000/101] 4.9.326-rc1 review
Message-ID: <20220823210018.GA2371231@roeck-us.net>
References: <20220823080034.579196046@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 10:02:33AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.326 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 164 pass: 141 fail: 23
Failed builds:
	arm:allmodconfig
	arm:imx_v6_v7_defconfig
	arm:ixp4xx_defconfig
	arm:u8500_defconfig
	arm:multi_v5_defconfig
	arm:omap1_defconfig
	arm:footbridge_defconfig
	arm:axm55xx_defconfig
	arm:keystone_defconfig
	arm:vexpress_defconfig
	arm:at91_dt_defconfig
	arm:shmobile_defconfig
	arm:nhk8815_defconfig
	arm:orion5x_defconfig
	arm:exynos_defconfig
	arm:cm_x2xx_defconfig
	arm:integrator_defconfig
	arm:pxa910_defconfig
	ia64:defconfig
	ia64:allnoconfig
	ia64:tinyconfig
	score:defconfig
	um:defconfig
Qemu test results:
	total: 394 pass: 343 fail: 51
Failed tests:
	arm:versatilepb:versatile_defconfig:aeabi:pci:scsi:mem128:net,default:versatile-pb:rootfs
	arm:versatilepb:versatile_defconfig:aeabi:pci:mem128:net,default:versatile-pb:initrd
	arm:versatileab:versatile_defconfig:mem128:net,default:versatile-ab:initrd
	arm:smdkc210:exynos_defconfig:cpuidle:nocrypto:mem128:exynos4210-smdkv310:initrd
	arm:smdkc210:exynos_defconfig:cpuidle:nocrypto:sd2:mem128:exynos4210-smdkv310:rootfs
	arm:realview-pb-a8:realview_defconfig:realview_pb:mem512:net,default:arm-realview-pba8:initrd
	arm:realview-pbx-a9:realview_defconfig:realview_pb:net,default:arm-realview-pbx-a9:initrd
	arm:realview-eb:realview_defconfig:realview_eb:mem512:net,default:arm-realview-eb:initrd
	arm:realview-eb-mpcore:realview_defconfig:realview_eb:mem512:net,default:arm-realview-eb-11mp-ctrevb:initrd
	arm:akita:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:initrd
	arm:borzoi:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:net,usb:initrd
	arm:borzoi:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:mmc:net,usb:rootfs
	arm:borzoi:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:ata:net,usb:rootfs
	arm:borzoi:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:usb:net,usb:rootfs
	arm:spitz:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:net,usb:initrd
	arm:spitz:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:mmc:net,usb:rootfs
	arm:spitz:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:ata:net,usb:rootfs
	arm:spitz:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:usb:net,usb:rootfs
	arm:terrier:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:net,usb:initrd
	arm:terrier:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:mmc:net,usb:rootfs
	arm:terrier:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:ata:net,usb:rootfs
	arm:terrier:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:usb:net,usb:rootfs
	arm:integratorcp:integrator_defconfig:mem128:net,default:integratorcp:initrd
	arm:integratorcp:integrator_defconfig:mem128:sd:net,default:integratorcp:rootfs
	mips:malta_defconfig:nocd:smp:net,e1000:initrd
	mips:malta_defconfig:nocd:smp:net,pcnet:flash,4,1,1:rootfs
	mips:malta_defconfig:nocd:smp:net,pcnet:ide:rootfs
	mips:malta_defconfig:nocd:smp:net,e1000:usb-xhci:rootfs
	mips:malta_defconfig:nocd:smp:net,e1000-82545em:usb-uas-xhci:rootfs
	mips:malta_defconfig:nocd:smp:net,i82801:usb-ehci:rootfs
	mips:malta_defconfig:nocd:smp:net,ne2k_pci:sdhci:mmc:rootfs
	mips:malta_defconfig:nocd:smp:net,pcnet:scsi[53C810]:rootfs
	mips:malta_defconfig:nocd:smp:net,rtl8139:scsi[53C895A]:rootfs
	mips:malta_defconfig:nocd:smp:net,tulip:scsi[DC395]:rootfs
	mips:malta_defconfig:nocd:smp:net,virtio-net:scsi[AM53C974]:rootfs
	mips:malta_defconfig:nocd:smp:net,i82550:scsi[MEGASAS]:rootfs
	mips:malta_defconfig:nocd:smp:net,i82558a:scsi[MEGASAS2]:rootfs
	mips:malta_defconfig:nocd:smp:net,i82562:scsi[FUSION]:rootfs
	mips:malta_defconfig:nocd:nosmp:net,e1000:initrd
	mips:malta_defconfig:nocd:nosmp:ide:net,pcnet:rootfs
	mipsel:mips32r6-generic:malta_32r6_defconfig:nocd:smp:net,pcnet:ide:rootfs
	sheb:rts7751r2dplus_defconfig:initrd
	sheb:rts7751r2dplus_defconfig:ata:rootfs
	xtensa:dc232b:lx60:generic_kc705_defconfig
	xtensa:dc232b:lx200:generic_kc705_defconfig
	xtensa:dc232b:kc705:generic_kc705_defconfig
	xtensa:dc232b:kc705:generic_kc705_defconfig
	xtensa:dc233c:ml605:generic_kc705_defconfig
	xtensa:dc233c:kc705:generic_kc705_defconfig
	xtensa:dc233c:kc705:generic_kc705_defconfig
	xtensa:de212:kc705-nommu:nommu_kc705_defconfig

Some change must have caused problems with the old binutils / linker
version used when building v4.9.y kernels in my test bed.

Guenter

---

Build errors:

arm:

arm-linux-gnueabi-ld: error: source object drivers/net/ethernet/cirrus/built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o has EABI version 0
arm-linux-gnueabi-ld: failed to merge target specific data of file drivers/net/ethernet/cirrus/built-in.o
arm-linux-gnueabi-ld: error: source object drivers/net/ethernet/freescale/built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o has EABI version 0
arm-linux-gnueabi-ld: failed to merge target specific data of file drivers/net/ethernet/freescale/built-in.o
arm-linux-gnueabi-ld: error: source object drivers/net/ethernet/smsc/built-in.o has EABI version 5, but target drivers/net/ethernet/built-in.o has EABI version 0
arm-linux-gnueabi-ld: failed to merge target specific data of file drivers/net/ethernet/smsc/built-in.o
make[4]: *** [scripts/Makefile.build:460: drivers/net/ethernet/built-in.o] Error 1
make[3]: *** [scripts/Makefile.build:558: drivers/net/ethernet] Error 2

This affects a variety of files depending on the configuration.

ia64:

ia64-linux-ld: drivers/video/fbdev/omap2/built-in.o: linking constant-gp files with non-constant-gp files
ia64-linux-ld: failed to merge target specific data of file drivers/video/fbdev/omap2/built-in.o

ia64-linux-ld: drivers/gpu/vga/built-in.o: linking constant-gp files with non-constant-gp files
ia64-linux-ld: failed to merge target specific data of file drivers/gpu/vga/built-in.o

score:

Persistent compiler (or linker) error, resulting in core dump (gcc 4.9.1)

um:

Linker error, resulting in core dumps (gcc 6.3.0)

mips (qemu tests):

Yet another linker crash.

mips32r6-generic:

Error log:
mips-linux-ld: drivers/gpu/vga/built-in.o: linking mips:isa32r6 module with previous mips:3000 modules
mips-linux-ld: drivers/gpu/vga/built-in.o: linking -mnan=2008 module with previous -mnan=legacy modules
mips-linux-ld: failed to merge target specific data of file drivers/gpu/vga/built-in.o

sheb:

Another linker crash.

xtensa:

Again, linker crash
