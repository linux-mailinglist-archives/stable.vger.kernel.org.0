Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62832573F7D
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 00:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbiGMWRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 18:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiGMWRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 18:17:43 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C252A26C;
        Wed, 13 Jul 2022 15:17:42 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 70so227431pfx.1;
        Wed, 13 Jul 2022 15:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k/Sfn7fFPDZzuiNhEGRbLFmyWjKnhhjZclNeEieBmH4=;
        b=q2yg+dlnILzrgGTyFb7L0tTPiuYNvagtJfH/NBf5y2Fl6BGX+qYbwVpHIz155W8gsP
         FcZCAVZo6kCGRCO3YmOvAefaqI241+wjzuwzj8tAkPY9MalCxnrX+e0aKNtGqcPdSWr/
         RT+Fp4PkQFZxyY8UnJb5v4E/hQK04ux9JCP4zUCSt1lMa4aHEhGPTclZ2k6liqtQGJRP
         mJHUDiO6dt0XDVx/96JdRwjm1IrxUktY5N9Hwq83JELJw8ZdNIfops2EfKuirCGK6oIs
         oPdTNOqhPCnZhS5y6vwyCzdyvTlWhLxb+lquyZBcymHoKSfgHQ+PMB4l4kc8p9ISSbLV
         ZkSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=k/Sfn7fFPDZzuiNhEGRbLFmyWjKnhhjZclNeEieBmH4=;
        b=JzTyaO8zZMgI37PKIHjERw5H6Jar+fjsozvTorURpwYqIL0/GSI2fyZKu+L7MxSTa3
         i2IlTSObtKS2ajdKuyFjELOBee13qTwii0yG0n98GXG0pmuHjchOVXHFYCpz4wIqKj6H
         Waj7rBp+Ud/ma5LkjgNYl3whzkiKzsI9OtI4BhZ+3wzDSTrFSO8ggXCKfsyZqx7k5oar
         2Bctz6KlL+GJhMPFXglNVzi/8KCGeelSJN0WiTMlkcdzu0wBIsmjoyg4qMPQbExuomjz
         QwZhfm/uzBLUIdC+RBdXSDLmA1cfTChSRMRoDI6MohCBfrE/rV08jkvasfKRWgoetg3U
         YeDA==
X-Gm-Message-State: AJIora/BJSEbKTJz4faeRqjCD7q2qw+ueUv0vmCOtRfXU1+RrNnE63YH
        vrB+IhOnBqT4XK5hgPNrD+4=
X-Google-Smtp-Source: AGRyM1ubo0nEnvfDaOn4n8ikNSp5c0NjOo0hj/eKRipmkN/T7udN3OgbG/aRBXms3gjMmRteWCI7ag==
X-Received: by 2002:aa7:8318:0:b0:528:c331:e576 with SMTP id bk24-20020aa78318000000b00528c331e576mr5328795pfb.58.1657750661709;
        Wed, 13 Jul 2022 15:17:41 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n1-20020a622701000000b00525496442ccsm15174pfn.216.2022.07.13.15.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 15:17:41 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 13 Jul 2022 15:17:40 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/131] 5.10.131-rc2 review
Message-ID: <20220713221740.GA69517@roeck-us.net>
References: <20220713094820.698453505@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713094820.698453505@linuxfoundation.org>
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

On Wed, Jul 13, 2022 at 03:10:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.131 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 15 Jul 2022 09:47:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 162 fail: 1
Failed builds:
	um:defconfig
Qemu test results:
	total: 477 pass: 469 fail: 8
Failed tests:
	x86_64:q35:SandyBridge:defconfig:smp4:net,ne2k_pci:efi32:mem1G:usb:hd
	x86_64:q35:Conroe:defconfig:smp4:net,tulip:efi32:mem256:scsi[DC395]:hd
	x86_64:q35:Skylake-Server:defconfig:smp4:net,e1000-82544gc:efi32:mem2G:scsi[53C895A]:hd
	x86_64:q35:Opteron_G5:defconfig:smp4:net,i82559c:efi32:mem256:scsi[MEGASAS2]:hd
	x86_64:pc:Opteron_G2:defconfig:smp:net,usb:efi32:mem2G:scsi[virtio-pci]:hd
	x86_64:q35:Nehalem:defconfig:smp2:net,i82558a:efi32:mem1G:virtio:hd
	x86_64:q35:Skylake-Client-IBRS:defconfig:preempt:smp2:net,i82558b:efi32:mem1G:sdhci:mmc:hd
	x86_64:q35:Haswell-noTSX-IBRS:defconfig:nosmp:net,pcnet:efi32:mem2G:ata:hd

Build error:

/opt/kernel/gcc-11.3.0-2.38-nolibc/x86_64-linux/bin/../lib/gcc/x86_64-linux/11.3.0/../../../../x86_64-linux/bin/ld: arch/x86/um/../kernel/module.o: in function `module_finalize':
arch/x86/um/../kernel/module.c:283: undefined reference to `apply_returns'

Crash:

[    0.709966] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[    0.709966] BUG: unable to handle page fault for address: 0000000021803b80
[    0.709966] #PF: supervisor instruction fetch in kernel mode
[    0.709966] #PF: error_code(0x0011) - permissions violation
[    0.709966] PGD 175a063 P4D 175a063 PUD 175b063 PMD 1766063 PTE 8000000021803063
[    0.709966] Oops: 0011 [#1] SMP PTI
[    0.709966] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.131-rc2+ #1
[    0.709966] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[    0.709966] RIP: 0010:0x21803b80
[    0.709966] Code: Unable to access opcode bytes at RIP 0x21803b56.
[    0.709966] RSP: 0018:ffffffffb9403e80 EFLAGS: 00000046
[    0.709966] RAX: 0000000000000000 RBX: 0000000001798000 RCX: 00000000df24be60
[    0.709966] RDX: 000000003feab058 RSI: 0000000000000600 RDI: 000000003fe7e038
[    0.709966] RBP: 0000000000000600 R08: 0000000001798000 R09: 00000000229ed067
[    0.709966] R10: 0000000000000000 R11: 00000000229ed067 R12: 0000000000000030
[    0.709966] R13: 0000000000000001 R14: ffff9aca41790000 R15: 0000000000000282
[    0.709966] FS:  0000000000000000(0000) GS:ffff9aca7f800000(0000) knlGS:0000000000000000
[    0.709966] CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050033
[    0.709966] CR2: 0000000021803b80 CR3: 0000000001758000 CR4: 00000000000406b0
[    0.709966] Call Trace:
[    0.709966]  ? efi_set_virtual_address_map+0x87/0x160
[    0.709966]  ? efi_enter_virtual_mode+0x39a/0x3f5
[    0.709966]  ? start_kernel+0x4aa/0x544
[    0.709966]  ? secondary_startup_64_no_verify+0xc2/0xcb
[    0.709966] Modules linked in:
[    0.709966] CR2: 0000000021803b80
[    0.709966] ---[ end trace 1b5f45b6ffd42130 ]---
[    0.709966] RIP: 0010:0x21803b80
[    0.709966] Code: Unable to access opcode bytes at RIP 0x21803b56.
[    0.709966] RSP: 0018:ffffffffb9403e80 EFLAGS: 00000046
[    0.709966] RAX: 0000000000000000 RBX: 0000000001798000 RCX: 00000000df24be60
[    0.709966] RDX: 000000003feab058 RSI: 0000000000000600 RDI: 000000003fe7e038
[    0.709966] RBP: 0000000000000600 R08: 0000000001798000 R09: 00000000229ed067
[    0.709966] R10: 0000000000000000 R11: 00000000229ed067 R12: 0000000000000030
[    0.709966] R13: 0000000000000001 R14: ffff9aca41790000 R15: 0000000000000282
[    0.709966] FS:  0000000000000000(0000) GS:ffff9aca7f800000(0000) knlGS:0000000000000000
[    0.709966] CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050033
[    0.709966] CR2: 0000000021803b80 CR3: 0000000001758000 CR4: 00000000000406b0
[    0.709966] Kernel panic - not syncing: Attempted to kill the idle task!

This is the same for all stable release candidates, and is also seen
in the mainline kernel.

Guenter
