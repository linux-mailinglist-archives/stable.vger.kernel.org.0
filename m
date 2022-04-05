Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F9D4F5443
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 06:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392600AbiDFEqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 00:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1580779AbiDEXeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 19:34:50 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25293188A13;
        Tue,  5 Apr 2022 14:57:30 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id r11-20020a1c440b000000b0038ccb70e239so2475270wma.3;
        Tue, 05 Apr 2022 14:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6Zl2rTHV9dyeyEQ5EriFeY9oZvUpJZBlPVP09nxYZXI=;
        b=GCZuJEbxUwEvJ6LX1gdnbGz0b8o5gB1JFgMOGCyhlZb3gmywIGpLkA3J572T1Ytx/K
         5cHWqMzwxBWqJO+n5kIPGyrmgSzz4BP+URb9+ZchxOlLXxMKuDwMiB9CFpxid/ADeeys
         318NBh/R/BhdkgaFm1uv9LpgBzMzy3A4wjuZ9WTXGAO+JuAqiiYgoQT7Gh3jKG8WBRgW
         MqEdhZ+FUxAIdBsFl/ZCq/tT81EsOL7N7nfHRpGzM9mkwvP/u3Ts9QeOW+/Rz1zML8cF
         /Dei+iDfenDtx8hSqZ9SW3SvWZOpC2FjJN9m1jSqYR02XBeFkMs3GwM6h29PLpzN1SuH
         UcUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6Zl2rTHV9dyeyEQ5EriFeY9oZvUpJZBlPVP09nxYZXI=;
        b=wA0/yRAjOxmrTtCeJ/fkjB88TIGGROjgb99oJAGj/e4lU66VzIaQWomaNRB1BpZE/G
         dQs9C5MeTCPkwRRAcjV89Iw+4JFDyGP4TVs36PiCYcj7tyor/TPMjJ+ZxleHbVHZYCLj
         PeuVHPBrekgJek5n847RnD1UYHlz7mGOhV1lSCuEN8BqYQvCzi5Nr5zZBXnzeG36YMUY
         u0wfJla2TCqYKMSlUvDUy5XCurbBCjND4doJwSHHyxm2FoM+IIDSnP5cP//JenYsH+4f
         5zt+qYlYHE5+UNedjj8hgnUVu61xx0jj6/edN80wq9u7BlCm8q9C1jw2dAnUeNNvudsR
         AgUw==
X-Gm-Message-State: AOAM533POFB2FershV+VCxVzMBO5/HnO1MwjAsZh3O4XvbCEEjK94jmr
        yYddeD7Wj68knxjWUlblXb8=
X-Google-Smtp-Source: ABdhPJx9o9+sC7CxvjENOG4KHLFrhsOo3hLlekqA287eemHV1iDuo5WJKrCkGsIe2NiojP9286BNqQ==
X-Received: by 2002:a1c:7219:0:b0:38c:a4f8:484f with SMTP id n25-20020a1c7219000000b0038ca4f8484fmr4677028wmc.99.1649195848451;
        Tue, 05 Apr 2022 14:57:28 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id b1-20020adfd1c1000000b002058537af75sm13496470wrd.104.2022.04.05.14.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 14:57:28 -0700 (PDT)
Date:   Tue, 5 Apr 2022 22:57:26 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/599] 5.10.110-rc1 review
Message-ID: <Yky7RmYZnPp9HgzT@debian>
References: <20220405070258.802373272@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Apr 05, 2022 at 09:24:54AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 599 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.

My tests are still running, but it failed to boot on my test laptop.
The trace is:

[    2.194098] BUG: unable to handle page fault for address: ffffffffc0778fb5
[    2.194791] #PF: supervisor write access in kernel mode
[    2.195166] #PF: error_code(0x0003) - permissions violation
[    2.195558] PGD 1bac14067 P4D 1bac14067 PUD 1bac16067 PMD 10aab8067 PTE 8000000110976061
[    2.196124] Oops: 0003 [#1] SMP PTI
[    2.196374] CPU: 5 PID: 217 Comm: modprobe Not tainted 5.10.110-rc1+ #33
[    2.196846] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[    2.197712] RIP: 0010:number+0x1d6/0x340
[    2.198025] Code: 83 c3 01 89 c8 44 29 d8 39 c2 7e ea 45 85 c9 0f 88 72 01 00 00 4d 63 c9 4a 8d 54 0c 18 4b 8d 44 0b 01 4c 39 db 76 06 0f b6 0a <41> 88 0b 49 83 c3 01 48 83 ea 01 49 39 c3 75 e8 83 ed 01 0f 88 3c
[    2.199654] RSP: 0018:ffffb61a4030fb08 EFLAGS: 00010206
[    2.200126] RAX: ffffffffc0778fb7 RBX: ffffffffc0778fb8 RCX: 0000000000000031
[    2.200630] RDX: ffffb61a4030fb21 RSI: 000000000000000a RDI: 0000000000000000
[    2.201131] RBP: 00000000fffffffb R08: 0000000000ffff0a R09: 0000000000000001
[    2.201635] R10: 3e2d434552202c29 R11: ffffffffc0778fb5 R12: 0000000000000020
[    2.202140] R13: 0000000000000000 R14: 000000000000000a R15: 0000000000000000
[    2.202641] FS:  00007fad7aa99580(0000) GS:ffff8c9537d40000(0000) knlGS:0000000000000000
[    2.203212] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.203618] CR2: ffffffffc0778fb5 CR3: 000000011060c001 CR4: 0000000000370ee0
[    2.204149] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    2.204682] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    2.205182] Call Trace:
[    2.205371]  ? cpumask_next+0x17/0x20
[    2.205636]  ? kvm_smp_send_call_func_ipi+0x1e/0x60
[    2.205986]  vsnprintf+0x363/0x560
[    2.206233]  snprintf+0x49/0x60
[    2.206461]  eval_replace+0x46/0x80
[    2.206712]  trace_event_eval_update+0x263/0x360
[    2.207057]  trace_module_notify+0x44/0x50
[    2.207352]  blocking_notifier_call_chain_robust+0x64/0xd0
[    2.207774]  ? mutex_lock+0xe/0x30
[    2.208020]  load_module+0x209c/0x28e0
[    2.208291]  ? __do_sys_finit_module+0xb1/0x110
[    2.208613]  __do_sys_finit_module+0xb1/0x110
[    2.208926]  do_syscall_64+0x33/0x80
[    2.209184]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    2.209552] RIP: 0033:0x7fad7abb4f79
[    2.209810] Code: 48 8d 3d da db 0d 00 0f 05 eb a5 66 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c7 9e 0d 00 f7 d8 64 89 01 48
[    2.211162] RSP: 002b:00007ffd607603c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[    2.212293] RAX: ffffffffffffffda RBX: 0000557e2325bc20 RCX: 00007fad7abb4f79
[    2.213374] RDX: 0000000000000000 RSI: 0000557e2193c260 RDI: 0000000000000004
[    2.214495] RBP: 0000000000040000 R08: 0000000000000000 R09: 0000557e2325c620
[    2.215743] R10: 0000000000000004 R11: 0000000000000246 R12: 0000557e2193c260
[    2.216994] R13: 0000000000000000 R14: 0000557e2325bcb0 R15: 0000557e2325bc20
[    2.218219] Modules linked in: ext4(+) crc32c_generic crc16 mbcache jbd2 sd_mod bochs_drm t10_pi drm_vram_helper crc_t10dif drm_ttm_helper sr_mod crct10dif_generic cdrom ttm xhci_pci ata_generic drm_kms_helper xhci_hcd cec ata_piix libata rc_core usbcore crct10dif_pclmul crct10dif_common crc32_pclmul psmouse drm crc32c_intel usb_common i2c_piix4 e1000 scsi_mod floppy button
[    2.222206] CR2: ffffffffc0778fb5
[    2.223103] ---[ end trace 036356107aad6aa1 ]---

Did a bisect and the bisect log is:
# bad: [45fdcc9dc72a44448666a2bcff4030a659e29e46] Linux 5.10.110-rc1
# good: [d9c5818a0bc09e4cc9fe663edb69e4d6cdae4f70] Linux 5.10.109
git bisect start 'HEAD' 'v5.10.109'
# good: [93a35ab24592dfddafdb9f184e9399aad6d88a18] drm/amd/display: Add affected crtcs to atomic state for dsc mst unplug
git bisect good 93a35ab24592dfddafdb9f184e9399aad6d88a18
# good: [c8816508edf3558f597bd20a01403b060d690700] regulator: rpi-panel: Handle I2C errors/timing to the Atmel
git bisect good c8816508edf3558f597bd20a01403b060d690700
# bad: [5e7fb97064ee7794db7ac938583c3d095980e55f] scsi: qla2xxx: Fix disk failure to rediscover
git bisect bad 5e7fb97064ee7794db7ac938583c3d095980e55f
# good: [3d65639a786b4587e64fb813a79a8f27b83dcaab] ARM: dts: qcom: fix gic_irq_domain_translate warnings for msm8960
git bisect good 3d65639a786b4587e64fb813a79a8f27b83dcaab
# good: [8bb857ae514a06d96a6ca81ff306acf5783d6cc6] media: Revert "media: em28xx: add missing em28xx_close_extension"
git bisect good 8bb857ae514a06d96a6ca81ff306acf5783d6cc6
# bad: [0042f52f784f847927f1ff234b3f97dd97ad8e48] powerpc/lib/sstep: Fix build errors with newer binutils
git bisect bad 0042f52f784f847927f1ff234b3f97dd97ad8e48
# bad: [690ee20444960ce5592465bce043ac5cd4ef8028] media: atomisp: fix bad usage at error handling logic
git bisect bad 690ee20444960ce5592465bce043ac5cd4ef8028
# bad: [93fe2389e6fd4c545920f6bd013b36f9328b636e] tracing: Have TRACE_DEFINE_ENUM affect trace event types as well
git bisect bad 93fe2389e6fd4c545920f6bd013b36f9328b636e
# good: [1fe212d441b683685c2900bd4353f53f7f608db9] media: hdpvr: initialize dev->worker at hdpvr_register_videodev
git bisect good 1fe212d441b683685c2900bd4353f53f7f608db9
# first bad commit: [93fe2389e6fd4c545920f6bd013b36f9328b636e] tracing: Have TRACE_DEFINE_ENUM affect trace event types as well

And, reverting 93fe2389e6fd4c545920f6bd013b36f9328b636e on top of v5.10.110-rc1
fixed the problem.


--
Regards
Sudip
