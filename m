Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F76E4F5697
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 08:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiDFGkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 02:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1840870AbiDFFgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 01:36:42 -0400
Received: from gateway33.websitewelcome.com (gateway33.websitewelcome.com [192.185.145.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FF62325D3
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 18:07:51 -0700 (PDT)
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 3934635691
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 20:07:51 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id bu9HnSSjHXvvJbu9HnTEep; Tue, 05 Apr 2022 20:07:51 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ir5zKJS6Hpz521fr7STfT6k5Mt4+Sno9XyjBALW2r/Y=; b=r0kMJMCXJxpiicNLzvduiIeKFo
        CTjV5wiO+ae8bbVR/yAYKNwsFb5hFd5GJIWxacv4XOCOQncKRqq8N9e9h7x/unvoQkAHnobkBhp0A
        8IxCvSvwaD9vizPUxp4uhZ76utR2ogIwo6NH5OXVcFRIYubJvKWowrXyqS8avbqen0x69tPt4VEb6
        Ao8uD1qbFkwKEjEiYZHAewc0xpFoUJxY0560cwrBxml7YoHd8Kc5TIJrTPkS4fGvs2lgYM1R3jaw9
        vpCgZvz8z7jHEMXp5Z2YD5amk89nYUqzecYILvaABM0tfgM68QI2NLLBoGCRXMU/yT3K4TGZ4xpT0
        5y2XX56w==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57874 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nbu9G-001KNx-Gc; Wed, 06 Apr 2022 01:07:50 +0000
Date:   Tue, 5 Apr 2022 18:07:49 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/599] 5.10.110-rc1 review
Message-ID: <20220406010749.GA1133386@roeck-us.net>
References: <20220405070258.802373272@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nbu9G-001KNx-Gc
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57874
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 11
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 09:24:54AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 599 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 150 fail: 11
Failed builds:
	alpha:defconfig
	alpha:allmodconfig
	csky:defconfig
	m68k:defconfig
	m68k:allmodconfig
	m68k:sun3_defconfig
	m68k_nommu:m5475evb_defconfig
	microblaze:mmu_defconfig
	nds32:defconfig
	nds32:allmodconfig
	um:defconfig
Qemu test results:
	total: 477 pass: 448 fail: 29
Failed tests:
	<all alpha>
	q800:m68040:mac_defconfig:initrd
	q800:m68040:mac_defconfig:rootfs
	<all microblaze>
	<all s390>

Compile error:

fs/binfmt_elf.c: In function 'fill_note_info':
fs/binfmt_elf.c:2050:45: error: 'siginfo' undeclared (first use in this function)
fs/binfmt_elf.c:2056:53: error: 'regs' undeclared (first use in this function)

s390 tests crashed. Other failed qemu tests did not compile.

[    7.385841] Unable to handle kernel pointer dereference in virtual kernel address space
[    7.385946] Failing address: 0000000001002000 TEID: 0000000001002407
[    7.386007] Fault in home space mode while using kernel ASCE.
[    7.386610] AS:0000000001874007 R3:000000001ffec007 S:000000001ffe8800 P:000000000100231d
[    7.387430] Oops: 0004 ilc:3 [#1] SMP
[    7.387557] Modules linked in:
[    7.387902] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.10.110-rc1-00600-g45fdcc9dc72a #1
[    7.387944] Hardware name: QEMU 3906 QEMU (KVM/Linux)
[    7.388043] Krnl PSW : 0704e00180000000 00000000008f0726 (number+0x25e/0x3c0)
[    7.388159]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
[    7.388227] Krnl GPRS: 0000000000000058 0000000001002dc9 0000000000000002 00000000fffffffb
[    7.388268]            000003e00000bb11 000003e001002dc8 0000000000000000 0000000000000000
[    7.388309]            0000000000000020 000003e000000001 0000000001002dca 0000000001002dc7
[    7.388350]            000000000309c100 000003e00000bb10 00000000008f087a 000003e00000ba48
[    7.388832] Krnl Code: 00000000008f0716: f0c84112b001	srp	274(13,%r4),1(%r11),8
[    7.388832]            00000000008f071c: 41202001		la	%r2,1(%r2)
[    7.388832]           #00000000008f0720: ecab0006c065	clgrj	%r10,%r11,12,00000000008f072c
[    7.388832]           >00000000008f0726: d200b0004000	mvc	0(1,%r11),0(%r4)
[    7.388832]            00000000008f072c: 41b0b001		la	%r11,1(%r11)
[    7.388832]            00000000008f0730: a74bffff		aghi	%r4,-1
[    7.388832]            00000000008f0734: a727fff6		brctg	%r2,00000000008f0720
[    7.388832]            00000000008f0738: a73affff		ahi	%r3,-1
[    7.389230] Call Trace:
[    7.389303]  [<00000000008f0726>] number+0x25e/0x3c0
[    7.389351] ([<00000000008f087a>] number+0x3b2/0x3c0)
[    7.389389]  [<00000000008f5bd8>] vsnprintf+0x4b0/0x7c8
[    7.389425]  [<00000000008f5f98>] snprintf+0x40/0x50
[    7.389464]  [<000000000028b0aa>] eval_replace+0x62/0xc0
[    7.389507]  [<000000000028f6f4>] trace_event_eval_update+0x204/0x240
[    7.389547]  [<0000000001413a40>] tracer_init_tracefs+0x168/0x2d0
[    7.389585]  [<0000000000100982>] do_one_initcall+0x72/0x2b0
[    7.389623]  [<0000000001400434>] do_initcalls+0x124/0x148
[    7.389660]  [<00000000014006fe>] kernel_init_freeable+0x226/0x268
[    7.389699]  [<0000000000d6d202>] kernel_init+0x22/0x150
[    7.389737]  [<0000000000d7b858>] ret_from_fork+0x28/0x2c
[    7.389782] INFO: lockdep is turned off.
[    7.389822] Last Breaking-Event-Address:
[    7.389862]  [<00000000008f06ec>] number+0x224/0x3c0
[    7.390089] Kernel panic - not syncing: Fatal exception: panic_on_oops

Guenter
