Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D060E1B4E69
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 22:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgDVUed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 16:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgDVUed (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 16:34:33 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F37AC03C1A9;
        Wed, 22 Apr 2020 13:34:33 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a7so1486786pju.2;
        Wed, 22 Apr 2020 13:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oj6RBd4NInqortzIybzJMGkQaa/DYFjVQ1PNIAkB4u8=;
        b=kjiAzu/oTsPU/KfGaHOc0rksr/OV/UhTXByqBQrEOYO9RJErfLmYFhA63EM9KIUqPs
         kZZgPRVzN3wVmU3lAz9o8vENF/gbE0cgVcF3VIrVta7pcAUTdYeioQ9adyImsIiajKKL
         oX92eeCZ+20MEn2aG1S+zLECrEg7Z8g16fLkmtCaAqMFAyi1+PXih42XJmaqMJnob6Sf
         3uIdnI27cTJjtvMKaePK7+xy8qek8hTsG+jxxzndhkK2Im4ZBmbhro+1mjCS5i+o4tFb
         lDbpVcR29KYbWA6iPzA41sCq3BvXZVRZtwjmyfL8lySGK47obtEyV8JPSgYWkVtc88Hc
         /qIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=oj6RBd4NInqortzIybzJMGkQaa/DYFjVQ1PNIAkB4u8=;
        b=ZcjEIf7+gT57XN6Ar7VFtjFw+LV1F+ER2mVOvVZWD4kZzk/LVHZ03z3OZKMAXCGapT
         zdqMkeqPrx0HMobb7N85X0d/BwY/X79pdaV5iS4l/rU9P73Bg9QaxXZ0rNN1xh/a1zad
         mV43ltxQJEffwAwuUlhjyHr2K/UgsCKShowxTKPg0er9HW0YlT2YzO1+tEZEsqL1zHWz
         Sixufm29gOcMD3b7d34gOCfvpnlkPJDkpI5USsULY2oqWw16tRfvtLvwDjt2QYB4u96t
         +ltPLGe5zn4CTADq3O6F7FnNThVh42mqISNFkAtZVj604SGd3TCZYzuPv4slz2tOpbZ1
         N9/g==
X-Gm-Message-State: AGi0PuYD3nolimrXdS5caZ6GNtNVM2UV43CPKC1/RemvPSMYM6QVcp77
        S1ir0nt8kEMtxmQVbSRbq7w=
X-Google-Smtp-Source: APiQypJwnLzlCDzFCiSpt0SJPeFfr5t2e53tNHcOrWfLUkLXWgnbl1fyyreADG0zBV2GNzvsKEZrYQ==
X-Received: by 2002:a17:902:9b90:: with SMTP id y16mr436362plp.227.1587587672677;
        Wed, 22 Apr 2020 13:34:32 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x12sm347222pfq.209.2020.04.22.13.34.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Apr 2020 13:34:32 -0700 (PDT)
Date:   Wed, 22 Apr 2020 13:34:30 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/125] 4.9.220-rc1 review
Message-ID: <20200422203430.GA52250@roeck-us.net>
References: <20200422095032.909124119@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 11:55:17AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.220 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
> Anything received after that time might be too late.
> 

I see a number of unit test crashes in ppc images. Looks like UAF.
This affects 4.4.y, 4.9.y, and 4.14.y. I'll bisect.

Guenter

---
BUG: Unable to handle kernel data access at 0x6b6b6b6b6b6b6b6b
Faulting instruction address: 0xc0000000006651dc
Oops: Kernel access of bad area, sig: 11 [#1]
PREEMPT SMP NR_CPUS=32 
PowerMac
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.9.220-rc1-00126-gf6cef26 #1
task: c00000003c1c8010 task.stack: c00000003c1c4000
NIP: c0000000006651dc LR: c00000000066824c CTR: c000000000668230
REGS: c00000003c1c7320 TRAP: 0380   Not tainted  (4.9.220-rc1-00126-gf6cef26)
MSR: 800000000000b032 <SF,EE,FP,ME,IR,DR,RI>  CR: 28004448  XER: 00000000
SOFTE: 0 
GPR00: 00000000743a2027 c00000003c1c75a0 c0000000011e1000 c000000001e926cc 
GPR04: c000000001e92aa0 c000000001e92aa0 04ffffff000affff 0000000000000000 
GPR08: c0000000006646b0 ffffffffffffffff 6b6b6b6b6b6b6b6b 0000000000000001 
GPR12: 0000000044004448 c00000000fff9000 c00000000000ffc0 0000000000000000 
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
GPR20: c00000003c1c7878 0000000000000000 0000000000000002 c00000003c1c7880 
GPR24: c000000000e506ae 0000000000000025 c000000001e926c0 0000000000000020 
GPR28: 00000000000003e0 c000000001e92aa0 c000000000e506ae c000000001e926cc 
NIP [c0000000006651dc] .string+0x1c/0xe0
LR [c00000000066824c] .vsnprintf+0x1ac/0x490
Call Trace:
[c00000003c1c75a0] [c00000003a512af8] 0xc00000003a512af8 (unreliable)
[c00000003c1c7670] [c000000000668548] .vscnprintf+0x18/0x60
[c00000003c1c76f0] [c0000000001386cc] .vprintk_emit+0x12c/0x6d0
[c00000003c1c77c0] [c000000000bc3d84] .printk+0xa0/0xbc
[c00000003c1c7840] [c00000000065a9b0] .kobject_put+0x150/0x170
[c00000003c1c78d0] [c0000000009819bc] .of_node_put+0x2c/0x50
[c00000003c1c7950] [c000000000f7998c] .of_unittest_changeset+0x710/0x75c
[c00000003c1c7b00] [c000000000f7c280] .of_unittest+0x22b8/0x2978
[c00000003c1c7c20] [c00000000000f554] .do_one_initcall+0x64/0x1e0
[c00000003c1c7d00] [c000000000f236a8] .kernel_init_freeable+0x298/0x38c
[c00000003c1c7db0] [c00000000000ffe4] .kernel_init+0x24/0x160
[c00000003c1c7e30] [c00000000000c330] .ret_from_kernel_thread+0x58/0x68
Instruction dump:
4b9f3c45 60000000 e80100a0 7c0803a6 4bffffd4 2ba50fff 7caa2b78 7cc90734 
7c852378 409d0030 2fa90000 419e00b8 <890a0000> 394a0001 2fa80000 419e00a8 
---[ end trace f5bca90605285cbd ]---

