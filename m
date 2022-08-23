Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7535559EE2C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 23:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiHWVZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 17:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiHWVZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 17:25:11 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A8681693;
        Tue, 23 Aug 2022 14:25:10 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ds12-20020a17090b08cc00b001fae6343d9fso2274384pjb.0;
        Tue, 23 Aug 2022 14:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=rqAIRkbPGrIsWv7eIgL9K7O7OCvji1Q8YP90RKFz8IY=;
        b=Eu4nBVX1bW1mvmukU+tlLFBg9iRJR/sN6yWCyXYGAtTbdOq8NCAFvpWmQgCTtPGRT+
         aRHxV5Ppwt0B4hb+emogvLb3AVhaGTPJ9mMCO8Su1OVRqlE12VDtWkNFLoa3tEqxPhgZ
         lwuh1qZPCTSF4kkI3Q0YiiGroLsw2IHq4MDjlg2HP00q/tIBj+IaXJtWuw3KtZ/nhq+N
         V+qO3EfzipET/fF8yxt9EL+Pu6a8fflYcCZJc53k8gf69tJMqPKy16H7kK8t11KN/VEo
         RO08GNtNtxsU3P8epQ5NX797s4CoEIqBEwooUM21EkzxHNOoBCQBsKth7SMJ8Jnv1Vog
         nsDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=rqAIRkbPGrIsWv7eIgL9K7O7OCvji1Q8YP90RKFz8IY=;
        b=ljOpQRTjYLm0FeTfevo5pYkwTG/jdJ5T+Y2Rgz7sizqShuIOsfpZNn6Wog/58tAodF
         fEpx8u2V0fJV1Qsh1gGnyVO/w8p7iyp1zqf02tPU/gBLZL0M74UxeOI3DoTxVRa3AW6k
         o9cVDcjpAo3/Jfa4hzgyDUezkyTONs8b4PxejppkV+oLsA7sgjP4FLd0eERbeafq2AHF
         pVzA2Ur+rvk7KjD3uC8eVh5J+qrUWvvodDQcs2rosAtOOIPGIHbcyUwEcVfSNE0UzSSu
         EOmyORLToIu4VW1SatcLrSyhnIyce/hh+wRjYKrpM96VCrgHvGk4nr6YXKwNIkgC9t19
         FGjw==
X-Gm-Message-State: ACgBeo2roXSy4BsB32w4YYLYWhMjiSSYD8HSdDHxuJGwC7/HnywRzhPH
        xiRSvNXsV+dhWihdYV022kw=
X-Google-Smtp-Source: AA6agR4YMXNQ6a3ov6N5+QW3piMbl+pOMnF20yCk2YE5uCUAWBfusTwI6IPphkOAp3JAo+2esxAH0A==
X-Received: by 2002:a17:902:bd49:b0:170:953d:c489 with SMTP id b9-20020a170902bd4900b00170953dc489mr26215274plx.96.1661289910203;
        Tue, 23 Aug 2022 14:25:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i9-20020a170902c94900b001641b2d61d4sm11095320pla.30.2022.08.23.14.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 14:25:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 23 Aug 2022 14:25:08 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 000/101] 4.9.326-rc1 review
Message-ID: <20220823212508.GA2588726@roeck-us.net>
References: <20220823080034.579196046@linuxfoundation.org>
 <20220823210018.GA2371231@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823210018.GA2371231@roeck-us.net>
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

On Tue, Aug 23, 2022 at 02:00:20PM -0700, Guenter Roeck wrote:
> On Tue, Aug 23, 2022 at 10:02:33AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.326 release.
> > There are 101 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 164 pass: 141 fail: 23
> Failed builds:
> 	arm:allmodconfig
> 	arm:imx_v6_v7_defconfig
> 	arm:ixp4xx_defconfig
> 	arm:u8500_defconfig
> 	arm:multi_v5_defconfig
> 	arm:omap1_defconfig
> 	arm:footbridge_defconfig
> 	arm:axm55xx_defconfig
> 	arm:keystone_defconfig
> 	arm:vexpress_defconfig
> 	arm:at91_dt_defconfig
> 	arm:shmobile_defconfig
> 	arm:nhk8815_defconfig
> 	arm:orion5x_defconfig
> 	arm:exynos_defconfig
> 	arm:cm_x2xx_defconfig
> 	arm:integrator_defconfig
> 	arm:pxa910_defconfig
> 	ia64:defconfig
> 	ia64:allnoconfig
> 	ia64:tinyconfig
> 	score:defconfig
> 	um:defconfig
> Qemu test results:
> 	total: 394 pass: 343 fail: 51
> Failed tests:
> 	arm:versatilepb:versatile_defconfig:aeabi:pci:scsi:mem128:net,default:versatile-pb:rootfs
> 	arm:versatilepb:versatile_defconfig:aeabi:pci:mem128:net,default:versatile-pb:initrd
> 	arm:versatileab:versatile_defconfig:mem128:net,default:versatile-ab:initrd
> 	arm:smdkc210:exynos_defconfig:cpuidle:nocrypto:mem128:exynos4210-smdkv310:initrd
> 	arm:smdkc210:exynos_defconfig:cpuidle:nocrypto:sd2:mem128:exynos4210-smdkv310:rootfs
> 	arm:realview-pb-a8:realview_defconfig:realview_pb:mem512:net,default:arm-realview-pba8:initrd
> 	arm:realview-pbx-a9:realview_defconfig:realview_pb:net,default:arm-realview-pbx-a9:initrd
> 	arm:realview-eb:realview_defconfig:realview_eb:mem512:net,default:arm-realview-eb:initrd
> 	arm:realview-eb-mpcore:realview_defconfig:realview_eb:mem512:net,default:arm-realview-eb-11mp-ctrevb:initrd
> 	arm:akita:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:initrd
> 	arm:borzoi:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:net,usb:initrd
> 	arm:borzoi:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:mmc:net,usb:rootfs
> 	arm:borzoi:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:ata:net,usb:rootfs
> 	arm:borzoi:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:usb:net,usb:rootfs
> 	arm:spitz:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:net,usb:initrd
> 	arm:spitz:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:mmc:net,usb:rootfs
> 	arm:spitz:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:ata:net,usb:rootfs
> 	arm:spitz:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:usb:net,usb:rootfs
> 	arm:terrier:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:net,usb:initrd
> 	arm:terrier:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:mmc:net,usb:rootfs
> 	arm:terrier:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:ata:net,usb:rootfs
> 	arm:terrier:pxa_defconfig:nodebug:nocd:nofs:nonvme:noscsi:notests:novirt:nofdt:usb:net,usb:rootfs
> 	arm:integratorcp:integrator_defconfig:mem128:net,default:integratorcp:initrd
> 	arm:integratorcp:integrator_defconfig:mem128:sd:net,default:integratorcp:rootfs
> 	mips:malta_defconfig:nocd:smp:net,e1000:initrd
> 	mips:malta_defconfig:nocd:smp:net,pcnet:flash,4,1,1:rootfs
> 	mips:malta_defconfig:nocd:smp:net,pcnet:ide:rootfs
> 	mips:malta_defconfig:nocd:smp:net,e1000:usb-xhci:rootfs
> 	mips:malta_defconfig:nocd:smp:net,e1000-82545em:usb-uas-xhci:rootfs
> 	mips:malta_defconfig:nocd:smp:net,i82801:usb-ehci:rootfs
> 	mips:malta_defconfig:nocd:smp:net,ne2k_pci:sdhci:mmc:rootfs
> 	mips:malta_defconfig:nocd:smp:net,pcnet:scsi[53C810]:rootfs
> 	mips:malta_defconfig:nocd:smp:net,rtl8139:scsi[53C895A]:rootfs
> 	mips:malta_defconfig:nocd:smp:net,tulip:scsi[DC395]:rootfs
> 	mips:malta_defconfig:nocd:smp:net,virtio-net:scsi[AM53C974]:rootfs
> 	mips:malta_defconfig:nocd:smp:net,i82550:scsi[MEGASAS]:rootfs
> 	mips:malta_defconfig:nocd:smp:net,i82558a:scsi[MEGASAS2]:rootfs
> 	mips:malta_defconfig:nocd:smp:net,i82562:scsi[FUSION]:rootfs
> 	mips:malta_defconfig:nocd:nosmp:net,e1000:initrd
> 	mips:malta_defconfig:nocd:nosmp:ide:net,pcnet:rootfs
> 	mipsel:mips32r6-generic:malta_32r6_defconfig:nocd:smp:net,pcnet:ide:rootfs
> 	sheb:rts7751r2dplus_defconfig:initrd
> 	sheb:rts7751r2dplus_defconfig:ata:rootfs
> 	xtensa:dc232b:lx60:generic_kc705_defconfig
> 	xtensa:dc232b:lx200:generic_kc705_defconfig
> 	xtensa:dc232b:kc705:generic_kc705_defconfig
> 	xtensa:dc232b:kc705:generic_kc705_defconfig
> 	xtensa:dc233c:ml605:generic_kc705_defconfig
> 	xtensa:dc233c:kc705:generic_kc705_defconfig
> 	xtensa:dc233c:kc705:generic_kc705_defconfig
> 	xtensa:de212:kc705-nommu:nommu_kc705_defconfig
> 
> Some change must have caused problems with the old binutils / linker
> version used when building v4.9.y kernels in my test bed.
> 

Bisected with ia64 to commit 26f954a9e4e2 ("Makefile: link with -z
noexecstack --no-warn-rwx-segments"). I did not test everything,
but every build I did test passes with this patch reverted.

Guenter
