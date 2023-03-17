Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC536BE690
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 11:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjCQKXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 06:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjCQKXs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 06:23:48 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBAC442C2;
        Fri, 17 Mar 2023 03:23:46 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id j2so3941323wrh.9;
        Fri, 17 Mar 2023 03:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679048625;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kM6+hcwGaGzOq2F+ooLnrZP8ZyS2RYYKcNWTH3cusUw=;
        b=IvN/MZa9VQoOa3cj+m+n5p1M92eqHfV9t1jimvk+0W3mS+6kJ6SmmtHn5JBygSrm/S
         2APf2dcWOGkfFJ3RIALSqZIHEGrG51+xg1+9apkBW8td3SVqMUumrO4DVg9yVr0ZHzx6
         ORbWQISmLgx6GebfZd/CiKtzo/i9mD6Xf8AVPK+b43favfiTfBIp6MJJIXA0Z4o+HmFs
         n/eaPhQSnzmqZgVzYTTAq6b7aRYU7qgxYx4Np0sjdTfOaSnBgyBOzhSqmW5W05as83C6
         hXMGNh5hcObtyfL80CmQiGHjcJ0n5P8dVJsO+/PKQXxG8sGB0n1Uh55Sv6cZ8K732Mr4
         Ocjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679048625;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kM6+hcwGaGzOq2F+ooLnrZP8ZyS2RYYKcNWTH3cusUw=;
        b=hv/TkWED/Bs55Ic1EmKrALEvAMM9d3rc92f2SmXHHQiugzapJRRMoRojwRjppvlf2l
         3aRjZ4Nc01Bb+kjk3Sbk2ufpjHCuojA2L84z/JKW9EgFzDiaZq5Qqs7M7WTW775tPEXV
         2eGJ2umzffN6tyqr4BHjvK4mlnL+XLlJH0dZdQVEWNtI9RgwqoI6ojFmYLYrDv8b6NZ7
         XXAScRQ4xytnbwtYjNNltAbl3J5PD5orgjHl2xt0uLm710LX4WXPsTDwWqh20SdFRT2e
         lsXsMj/dTPLvGlPYG/cjG57B/Tr1j7H9Ta+uGZWMOKnwRQPRE+vCr1LoRIMybIOrMGgL
         5nSw==
X-Gm-Message-State: AO0yUKUiid0C1udHavfSWK83595nEfQMEuLMbNwqY20TUo7LrNSO7T61
        PT9YCpe/EfpDhU8z5HjQbdw=
X-Google-Smtp-Source: AK7set85V3Je0xwwXkbAvdGt+80UhL5HuBeHwV+ouoP/qGqdPeA+p32iWhX1HuKZXuJPrl8fJtROxw==
X-Received: by 2002:adf:ed51:0:b0:2ce:a093:6fd3 with SMTP id u17-20020adfed51000000b002cea0936fd3mr6699751wro.16.1679048624841;
        Fri, 17 Mar 2023 03:23:44 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id g9-20020a5d4889000000b002c559843748sm1625808wrq.10.2023.03.17.03.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 03:23:44 -0700 (PDT)
Date:   Fri, 17 Mar 2023 10:23:42 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/27] 4.19.278-rc3 review
Message-ID: <ZBQ/rhv9nP+i8Pyc@debian>
References: <20230316094129.846802350@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316094129.846802350@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Mar 16, 2023 at 10:42:14AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.278 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 09:41:20 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230311):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on qemu. No regression. [1]

Boot Regression on test laptop:
Only black screen but ssh worked, so from the dmesg it seems i915 failed.

[    3.538702] ------------[ cut here ]------------
[    3.538703] WARN_ON(!list_empty(&b->signals))
[    3.538765] WARNING: CPU: 3 PID: 137 at drivers/gpu/drm/i915/intel_breadcrumbs.c:888 intel_engine_fini_breadcrumbs+0xc5/0xd0 [i915]
[    3.538766] Modules linked in: crc32c_intel psmouse ahci i2c_i801 libahci i915(+) libata i2c_algo_bit scsi_mod lpc_ich drm_kms_helper ehci_pci sdhci_pci cqhci sdhci ehci_hcd mmc_core usbcore drm e1000e(+) usb_common video
[    3.538777] CPU: 3 PID: 137 Comm: systemd-udevd Not tainted 4.19.278-rc3-0233a363477c+ #1
[    3.538777] Hardware name: LENOVO 4287CTO/4287CTO, BIOS 8DET68WW (1.38 ) 04/11/2013
[    3.538815] RIP: 0010:intel_engine_fini_breadcrumbs+0xc5/0xd0 [i915]
[    3.538817] Code: 98 59 6e c0 48 c7 c7 11 51 6d c0 e8 98 21 73 d5 0f 0b e9 6f ff ff ff 48 c7 c6 d8 5a 6e c0 48 c7 c7 11 51 6d c0 e8 7e 21 73 d5 <0f> 0b e9 68 ff ff ff 0f 1f 40 00 66 66 66 66 90 41 57 41 56 41 55
[    3.538818] RSP: 0018:ffffb1930113bb48 EFLAGS: 00010286
[    3.538819] RAX: 0000000000000000 RBX: ffff8bc9c6828000 RCX: 0000000000000029
[    3.538820] RDX: 0000000000000000 RSI: ffffffff979e9320 RDI: 0000000000000246
[    3.538821] RBP: ffff8bca5e9b8000 R08: 284e4f5f4e524157 R09: 6d655f7473696c21
[    3.538821] R10: 3e2d622628797470 R11: 29736c616e676973 R12: 00000000fffffffa
[    3.538822] R13: ffff8bc9c681d780 R14: 0000000000000000 R15: ffff8bca5fabe000
[    3.538823] FS:  00007f097ff6a8c0(0000) GS:ffff8bcad60c0000(0000) knlGS:0000000000000000
[    3.538824] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.538825] CR2: 00007f09804fe8cc CR3: 000000019df3e001 CR4: 00000000000606e0
[    3.538826] Call Trace:
[    3.538866]  intel_engine_cleanup_common+0x4f/0x160 [i915]
[    3.538904]  intel_init_ring_buffer+0xcc/0xf0 [i915]
[    3.538940]  intel_engines_init+0x46/0xb0 [i915]
[    3.538976]  i915_gem_init+0x1d4/0x520 [i915]
[    3.539009]  i915_driver_load+0xb1d/0xdb0 [i915]
[    3.539013]  local_pci_probe+0x43/0x90
[    3.539015]  pci_device_probe+0x10a/0x1a0
[    3.539019]  really_probe+0x247/0x3d0
[    3.539021]  driver_probe_device+0xb6/0x100
[    3.539022]  __driver_attach+0x113/0x120
[    3.539023]  ? driver_probe_device+0x100/0x100
[    3.539026]  bus_for_each_dev+0x78/0xc0
[    3.539028]  bus_add_driver+0x16a/0x220
[    3.539030]  driver_register+0x8f/0xe0
[    3.539031]  ? 0xffffffffc07aa000
[    3.539033]  do_one_initcall+0x46/0x1d0
[    3.539037]  ? kernel_read_file+0x16a/0x1a0
[    3.539040]  ? _cond_resched+0x16/0x40
[    3.539042]  ? kmem_cache_alloc_trace+0x171/0x1d0
[    3.539044]  do_init_module+0x4e/0x270
[    3.539046]  __se_sys_finit_module+0xb1/0x110
[    3.539049]  do_syscall_64+0x55/0xf0
[    3.539050]  entry_SYSCALL_64_after_hwframe+0x5c/0xc1
[    3.539052] RIP: 0033:0x7f09804222e9
[    3.539053] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 77 8b 0d 00 f7 d8 64 89 01 48
[    3.539054] RSP: 002b:00007ffca2100948 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[    3.539055] RAX: ffffffffffffffda RBX: 0000564e2d018470 RCX: 00007f09804222e9
[    3.539056] RDX: 0000000000000000 RSI: 00007f09805bfe2d RDI: 000000000000000e
[    3.539057] RBP: 0000000000020000 R08: 0000000000000000 R09: 0000564e2cffe480
[    3.539057] R10: 000000000000000e R11: 0000000000000246 R12: 00007f09805bfe2d
[    3.539058] R13: 0000000000000000 R14: 0000564e2d017720 R15: 0000564e2d018470
[    3.539060] ---[ end trace 2dc2b0b9c81e2ead ]---
[    3.554929] e1000e 0000:00:19.0 0000:00:19.0 (uninitialized): registered PHC clock
[    3.563955] ------------[ cut here ]------------
[    3.563990] WARNING: CPU: 2 PID: 137 at drivers/gpu/drm/drm_mode_config.c:444 drm_mode_config_cleanup.cold+0x32/0x6b [drm]
[    3.563991] Modules linked in: crc32c_intel psmouse ahci i2c_i801 libahci i915(+) libata i2c_algo_bit scsi_mod lpc_ich drm_kms_helper ehci_pci sdhci_pci cqhci sdhci ehci_hcd mmc_core usbcore drm e1000e(+) usb_common video
[    3.563998] CPU: 2 PID: 137 Comm: systemd-udevd Tainted: G        W         4.19.278-rc3-0233a363477c+ #1
[    3.563999] Hardware name: LENOVO 4287CTO/4287CTO, BIOS 8DET68WW (1.38 ) 04/11/2013
[    3.564011] RIP: 0010:drm_mode_config_cleanup.cold+0x32/0x6b [drm]
[    3.564012] Code: 9f 4b a0 d5 0f 0b e9 bc 55 ff ff 48 c7 c7 c8 83 34 c0 e8 8c 4b a0 d5 0f 0b e9 f2 54 ff ff 48 c7 c7 c8 83 34 c0 e8 79 4b a0 d5 <0f> 0b 48 89 e6 48 89 ef e8 91 e4 fe ff 48 89 e7 e8 a9 e6 fe ff 48
[    3.564013] RSP: 0018:ffffb1930113bb78 EFLAGS: 00010246
[    3.564014] RAX: 0000000000000024 RBX: ffff8bca5e9b8368 RCX: 0000000000000299
[    3.564015] RDX: 0000000000000000 RSI: 0000000000000092 RDI: 0000000000000247
[    3.564016] RBP: ffff8bca5e9b8000 R08: 0000000000000299 R09: 0000000000000004
[    3.564017] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8bca5e9b8370
[    3.564017] R13: ffff8bca5e9bc9e8 R14: 00000000fffffffa R15: ffff8bca5fabe000
[    3.564019] FS:  00007f097ff6a8c0(0000) GS:ffff8bcad6080000(0000) knlGS:0000000000000000
[    3.564019] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.564020] CR2: 0000564e2d0060b0 CR3: 000000019df3e002 CR4: 00000000000606e0
[    3.564021] Call Trace:
[    3.564068]  intel_modeset_cleanup+0xbc/0x130 [i915]
[    3.564102]  i915_driver_load+0xb72/0xdb0 [i915]
[    3.564104]  local_pci_probe+0x43/0x90
[    3.564106]  pci_device_probe+0x10a/0x1a0
[    3.564109]  really_probe+0x247/0x3d0
[    3.564110]  driver_probe_device+0xb6/0x100
[    3.564112]  __driver_attach+0x113/0x120
[    3.564113]  ? driver_probe_device+0x100/0x100
[    3.564115]  bus_for_each_dev+0x78/0xc0
[    3.564117]  bus_add_driver+0x16a/0x220
[    3.564118]  driver_register+0x8f/0xe0
[    3.564119]  ? 0xffffffffc07aa000
[    3.564121]  do_one_initcall+0x46/0x1d0
[    3.564123]  ? kernel_read_file+0x16a/0x1a0
[    3.564125]  ? _cond_resched+0x16/0x40
[    3.564127]  ? kmem_cache_alloc_trace+0x171/0x1d0
[    3.564129]  do_init_module+0x4e/0x270
[    3.564130]  __se_sys_finit_module+0xb1/0x110
[    3.564133]  do_syscall_64+0x55/0xf0
[    3.564134]  entry_SYSCALL_64_after_hwframe+0x5c/0xc1
[    3.564135] RIP: 0033:0x7f09804222e9
[    3.564137] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 77 8b 0d 00 f7 d8 64 89 01 48
[    3.564137] RSP: 002b:00007ffca2100948 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[    3.564139] RAX: ffffffffffffffda RBX: 0000564e2d018470 RCX: 00007f09804222e9
[    3.564139] RDX: 0000000000000000 RSI: 00007f09805bfe2d RDI: 000000000000000e
[    3.564140] RBP: 0000000000020000 R08: 0000000000000000 R09: 0000564e2cffe480
[    3.564141] R10: 000000000000000e R11: 0000000000000246 R12: 00007f09805bfe2d
[    3.564141] R13: 0000000000000000 R14: 0000564e2d017720 R15: 0000564e2d018470
[    3.564143] ---[ end trace 2dc2b0b9c81e2eae ]---
[    3.564156] [drm:drm_mode_config_cleanup.cold [drm]] *ERROR* connector LVDS-1 leaked!
[    3.599840] i915 0000:00:02.0: Device initialization failed (-6)



[1]. https://openqa.qa.codethink.co.uk/tests/3130


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip

