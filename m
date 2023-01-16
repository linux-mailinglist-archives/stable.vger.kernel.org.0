Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C2B66D00C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 21:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbjAPUUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 15:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbjAPUU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 15:20:29 -0500
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F6983C5;
        Mon, 16 Jan 2023 12:20:28 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1433ef3b61fso29923014fac.10;
        Mon, 16 Jan 2023 12:20:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TBcBFSvQ61KEQ9osa73Zd/UiEV+spUyz2jdoUMqe1u8=;
        b=Df+S4tG/5cGMPqVzzgKkulDAGVRlKwyrKHWBW99UffceEu0DThZBJfmBPhkMP36bIt
         ladj895+3rfVRCUVNOBu4QJwRUnlwftLWPCTo9tkfE+RAQ1bXeLlVa6D1rMLTVkaZozp
         McX+OCHgITdwym2ebFQAP3SqxulH5b8USSDhb0/sCkblPJkq6mHfCb2jCP3loXv1ZMhp
         BrY9w9r5KEeXjE6UEKYA7+0aF1xL0qgjmNeSSuEkBm4ct1knjzDGgwLf3RdzCT8wwK4Z
         sHUPFVty5cIHE9gGmdr6tElmgcvDlnic1Gw2clSCw7j/QxAFviEKxNnmX2MOVLjZtqNI
         lanw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TBcBFSvQ61KEQ9osa73Zd/UiEV+spUyz2jdoUMqe1u8=;
        b=rKKti+Si+88eyxX27H2YWlLdsEMxqktAMt2fsUoJrXXtclo/ADzLJfq+Q2LTTOZFQw
         0g7v9W8a26oU2r/fo5CeAlEkrqdnWaq4UnpDYorSduvRmD3BBHTcCS+XKHy+QvCBSw9J
         4uZdX13dpM78Vp/qey/B0kLw6V0DfvgtLPlkU3kHhOfmlFdsJeEcG9LAkA6+G78R/m/j
         KXa9Bc3sWTsQjcOW2X6ZP8ku7tYTsoc41vCvuRL+4EZoG+O9yRb7MCff80Nrgc6hLAOv
         79zqw9fnSM1b/pWy3+E/7Uv3LQ80qxZvFE5xddQKClRRKMXPw2A3YU/JPm5XybAmwZeu
         tSsQ==
X-Gm-Message-State: AFqh2koVklZNeDYgfQB3E6FU9dt3uBVb4xXCnxDx8N5qq8q7KAWeohPM
        PgbK1cMX0SP5lGWdRopnP/g=
X-Google-Smtp-Source: AMrXdXvr+VZT7oEqXphPaCHajtlq7hKyQuVMckunl+TTGkLZSXdSj14PKUaKL5YyBAinkSVkS+WiwQ==
X-Received: by 2002:a05:6871:480b:b0:15e:cd80:8dfa with SMTP id qc11-20020a056871480b00b0015ecd808dfamr604193oab.17.1673900427581;
        Mon, 16 Jan 2023 12:20:27 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ep41-20020a056870a9a900b001446a45bb49sm15049548oab.23.2023.01.16.12.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 12:20:26 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 16 Jan 2023 12:20:25 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/658] 5.4.229-rc1 review
Message-ID: <20230116202025.GA3397667@roeck-us.net>
References: <20230116154909.645460653@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 16, 2023 at 04:41:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.229 release.
> There are 658 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
> 

Note: Exactly the same failures are seen in v4.19.269-522-gc75d2b5524ab,
so I won't bother sending test results for that branch.

---

Build results:
	total: 159 pass: 153 fail: 6
Failed builds:
	i386:tools/perf
	riscv:defconfig
	s390:allnoconfig
	s390:tinyconfig
	um:defconfig
	x86_64:tools/perf
Qemu test results:
	total: 449 pass: 413 fail: 36
Failed tests:
	<all ppc64:pseries>
	<all riscv>

Details follow.

Guenter

========

Building i386:tools/perf ... failed
Building x86_64:tools/perf ... failed
--------------
Error log:
util/debug.c: In function ‘perf_quiet_option’:
util/debug.c:237:2: error: ‘debug_peo_args’ undeclared

Building riscv:defconfig ... failed
--------------
Error log:
arch/riscv/kernel/stacktrace.c: In function 'walk_stackframe':
arch/riscv/kernel/stacktrace.c:58:36: error: 'struct pt_regs' has no member named 'epc'

Building s390:allnoconfig ... failed
Building s390:tinyconfig ... failed
--------------
Error log:
s390-linux-ld: drivers/base/platform.o: in function `devm_platform_get_and_ioremap_resource':
platform.c:(.text+0x594): undefined reference to `devm_ioremap_resource'
s390-linux-ld: platform.c:(.text+0x5c2): undefined reference to `devm_ioremap_resource'

Building um:defconfig ... failed
--------------
Error log:
ld: drivers/base/platform.o: in function `devm_platform_get_and_ioremap_resource':
drivers/base/platform.c:82: undefined reference to `devm_ioremap_resource'

Runtime:

Building ppc64:pseries:pseries_defconfig:smp2:net,pcnet:initrd ... running ......R... failed (crashed)

BUG: Kernel NULL pointer dereference at 0x00000000
Faulting instruction address: 0xc000000000046cc8
Oops: Kernel access of bad area, sig: 11 [#1]
BE SMP NR_CPUS=2048 NUMA pSeries
Modules linked in:
CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.19.270-rc1-00522-gc75d2b5524ab #1
NIP:  c000000000046cc8 LR: c000000000046ca4 CTR: 0000000000000000
REGS: c00000003e6878f0 TRAP: 0380   Not tainted  (4.19.270-rc1-00522-gc75d2b5524ab)
MSR:  8000000002009032 <SF,VEC,EE,ME,IR,DR,RI>  CR: 84000882  XER: 00000000
CFAR: c000000000162cf8 IRQMASK: 0
GPR00: c000000000046ca4 c00000003e687b70 c000000001772000 0000000000000000
GPR04: 0000000000000001 0000000000000001 c00000003e687990 00000000bc24d52c
GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000003
GPR12: 0000000024000882 c00000003ffff300 c000000000010e34 0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000000 0000000000000000 c00000000125eea8 0000000000000001
GPR24: c000000001379cd8 c000000001419f20 c0000000017b7d68 c0000000017b7d68
GPR28: 0000000000000000 0000000000000002 c00000000160efe8 c00000000168ac60
NIP [c000000000046cc8] .eeh_init+0x48/0x220
LR [c000000000046ca4] .eeh_init+0x24/0x220
Call Trace:
[c00000003e687b70] [c000000000046ca4] .eeh_init+0x24/0x220 (unreliable)
[c00000003e687c00] [c00000000001065c] .do_one_initcall+0x7c/0x430
[c00000003e687ce0] [c000000001394db4] .kernel_init_freeable+0x538/0x62c
[c00000003e687dc0] [c000000000010e4c] .kernel_init+0x18/0x14c
[c00000003e687e30] [c00000000000c0d0] .ret_from_kernel_thread+0x58/0x68
Instruction dump:
3c62ffd7 38631c10 4811c021 60000000 2c030000 408201c8 3d22000b e92904e0
2c290000 41820198 f8410028 e9290008 <e9490000> 7d4903a6 e8490008 4e800421
---[ end trace 8912d02d3e80c4ae ]---

riscv64 images fail to compile (see above)
