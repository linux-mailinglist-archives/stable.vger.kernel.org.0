Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315456BE676
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 11:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjCQKUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 06:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjCQKUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 06:20:14 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75025B0BAF;
        Fri, 17 Mar 2023 03:20:13 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id o7so3940101wrg.5;
        Fri, 17 Mar 2023 03:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679048412;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fcgizilFINCxrFl9PEuFkW7yKtyneOXZtW9e2hb5He8=;
        b=e6saHuMp3aikwOvmKqjh8Yfbz8bc535pVk0svM7aOpKIJXRkOWpDMFS0tD5TT2ATQK
         p9E3yZ5EQWPXo34FF0UcPGsV2OlCSE4P9owaVLgES9hqUN2++FUheYrlYAljsqJv56H4
         OE4NNUIn7rTw2p6lQ0jbRhx6QtS5iIeL3Z9tJteN21282mpImwML0+6coEWjgnSYnu3Y
         BQHwiSt9MtpZjx3UVgttAI8uueQAlfonYFHrUqNE5BC8u/WxN9ARSz1N2QxPcyt8P/9y
         KRVpJ13jEevV6MZfcSoUyRK2IFtFR3Bm30Vfggv1IoX5AQtED4Tc9JjD/FQqtDjXvJzd
         EOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679048412;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fcgizilFINCxrFl9PEuFkW7yKtyneOXZtW9e2hb5He8=;
        b=ftZcZYKt4lbBWRPCjTW4rOnnq02uDDBf1iu3CuPRnBFtSujoNK//wM9F0eqgbZHJhr
         WfUejM8vJVLKd6O3Z6uZgrjCalxu3Yd5xwa4Bhw86XkWTQhICmCuA1hDn/P1LA/YMsG4
         F4uEn71V8wuCs3D2SCmhmetSb0x6YVLUc3mmTO2/n1Rc+LN22rnjXvYvI/8ig4iScSzZ
         kOdRigaJQE5WxBjHPL+W5bwrvJwBWwOUZH7J9U88XJ4CWHNOFufdNdsymyCyDSXsxv5R
         kIsgEEIJwF8xJejlGrJC/vfzlsk2TfY6QEDF3sL7Cdm+z2xqEf3HMI79GyNThRducPKb
         QdeA==
X-Gm-Message-State: AO0yUKUcEvNM7ik9WW6NZ0Vc4aPIrniML5rsqX//Z0nKXu0pGPRkdI4T
        Of6fPFP5MkRn3pIvJ3l+Piw=
X-Google-Smtp-Source: AK7set+hHSxbzHEVhO/6H8MzI6mV6MDwc59G9dEY81eho+qIihC9XbfLCZttKDN8PFGpUdO35GJPpA==
X-Received: by 2002:a5d:4002:0:b0:2ce:a0c2:d9ed with SMTP id n2-20020a5d4002000000b002cea0c2d9edmr6385501wrp.32.1679048411775;
        Fri, 17 Mar 2023 03:20:11 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id u13-20020adfdb8d000000b002d2b117a6a6sm1603266wri.41.2023.03.17.03.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 03:20:11 -0700 (PDT)
Date:   Fri, 17 Mar 2023 10:20:09 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/55] 5.4.237-rc2 review
Message-ID: <ZBQ+2XUJC5CjaI6V@debian>
References: <20230316083403.224993044@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083403.224993044@linuxfoundation.org>
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

On Thu, Mar 16, 2023 at 09:49:55AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.237 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230311):
mips: 65 configs -> 1 failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

mips build failure:
lasat_defconfig -> failed

arch/mips/lasat/picvue_proc.c:42:44: error: expected ')' before '&' token
   42 | static DECLARE_TASKLET(pvc_display_tasklet, &pvc_display, 0);
      |                                            ^~
      |                                            )
arch/mips/lasat/picvue_proc.c: In function 'pvc_line_proc_write':
arch/mips/lasat/picvue_proc.c:87:27: error: 'pvc_display_tasklet' undeclared (first use in this function)
   87 |         tasklet_schedule(&pvc_display_tasklet);
      |                           ^~~~~~~~~~~~~~~~~~~
arch/mips/lasat/picvue_proc.c:87:27: note: each undeclared identifier is reported only once for each function it appears in
At top level:
arch/mips/lasat/picvue_proc.c:33:13: error: 'pvc_display' defined but not used [-Werror=unused-function]
   33 | static void pvc_display(unsigned long data)
      |             ^~~~~~~~~~~


Boot test:
x86_64: Booted on qemu. No regression. [1]

Boot Regression on test laptop.

[    3.473713] BUG: kernel NULL pointer dereference, address: 000000000000007c
[    3.473720] #PF: supervisor read access in kernel mode
[    3.473722] #PF: error_code(0x0000) - not-present page
[    3.473723] PGD 0 P4D 0 
[    3.473727] Oops: 0000 [#1] SMP NOPTI
[    3.473730] CPU: 0 PID: 114 Comm: systemd-udevd Not tainted 5.4.237-rc2-1baba0e91ac5+ #1
[    3.473732] Hardware name: LENOVO 4287CTO/4287CTO, BIOS 8DET68WW (1.38 ) 04/11/2013
[    3.473798] RIP: 0010:intel_context_unpin+0xe/0x120 [i915]
[    3.473804] Code: 60 00 e9 44 ff ff ff be 02 00 00 00 e8 8b 8d d3 fa eb ae 41 bd fc ff ff ff eb b2 90 66 66 66 66 90 41 55 48 8d 57 7c 41 54 55 <8b> 47 7c 48 89 fd 83 f8 01 74 0f 8d 48 ff f0 0f b1 0a 75 f2 5d 41
[    3.473808] RSP: 0018:ffff9d6900167a58 EFLAGS: 00010246
[    3.473811] RAX: ffff8898905c9400 RBX: ffff889787fea000 RCX: ffff8898905c94c0
[    3.473814] RDX: 000000000000007c RSI: ffff8898905caac0 RDI: 0000000000000000
[    3.473817] RBP: ffff889787fea000 R08: ffff889891f86160 R09: ffff8898960af4b8
[    3.473820] R10: ffff88978757a0c0 R11: 00000000030c44f5 R12: 00000000fffffffa
[    3.473823] R13: ffff8898913feb80 R14: ffffffffc04e4bf0 R15: ffff889891f877c8
[    3.473827] FS:  00007f5b0f8648c0(0000) GS:ffff889896000000(0000) knlGS:0000000000000000
[    3.473830] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.473833] CR2: 000000000000007c CR3: 000000021100c005 CR4: 00000000000606f0
[    3.473836] Call Trace:
[    3.473893]  intel_engine_cleanup_common+0xb7/0x1f0 [i915]
[    3.473947]  intel_ring_submission_init+0x60/0x110 [i915]
[    3.473999]  intel_engines_init+0x44/0xa0 [i915]
[    3.474056]  i915_gem_init+0x1f7/0x7e0 [i915]
[    3.474118]  ? intel_modeset_init+0x101e/0x1c70 [i915]
[    3.474167]  i915_driver_probe+0xc43/0x14f0 [i915]
[    3.474175]  ? __kernfs_new_node+0x156/0x1b0
[    3.474180]  ? kfree+0xb3/0x230
[    3.474229]  ? i915_pci_probe+0x3f/0x150 [i915]
[    3.474234]  local_pci_probe+0x42/0x80
[    3.474240]  ? _cond_resched+0x16/0x40
[    3.474245]  pci_device_probe+0xfd/0x1b0
[    3.474251]  really_probe+0x160/0x400
[    3.474255]  driver_probe_device+0xb6/0x100
[    3.474259]  device_driver_attach+0xa1/0xb0
[    3.474263]  __driver_attach+0x9b/0x140
[    3.474267]  ? device_driver_attach+0xb0/0xb0
[    3.474271]  bus_for_each_dev+0x78/0xc0
[    3.474275]  bus_add_driver+0x136/0x200
[    3.474279]  driver_register+0x8f/0xe0
[    3.474283]  ? 0xffffffffc06ec000
[    3.474288]  do_one_initcall+0x46/0x200
[    3.474292]  ? _cond_resched+0x16/0x40
[    3.474297]  ? kmem_cache_alloc_trace+0x19d/0x220
[    3.474302]  ? do_init_module+0x23/0x250
[    3.474305]  do_init_module+0x4c/0x250
[    3.474310]  __do_sys_finit_module+0xac/0x110
[    3.474315]  do_syscall_64+0x52/0x160
[    3.474320]  entry_SYSCALL_64_after_hwframe+0x5c/0xc1
[    3.474324] Modules linked in: i915(+) ahci crc32c_intel libahci libata psmouse i2c_i801 scsi_mod i2c_algo_bit lpc_ich ehci_pci ehci_hcd sdhci_pci drm_kms_helper cqhci sdhci usbcore usb_common mmc_core e1000e(+) drm ptp pps_core video
[    3.474342] CR2: 000000000000007c
[    3.474346] ---[ end trace c956347dbb581033 ]---



[1]. https://openqa.qa.codethink.co.uk/tests/3131


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
