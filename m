Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B1F1EBF27
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 17:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgFBPha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 11:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgFBPha (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 11:37:30 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D68EC08C5C0;
        Tue,  2 Jun 2020 08:37:30 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 185so5230573pgb.10;
        Tue, 02 Jun 2020 08:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fhvaP0uzgyzSW5Kw6qM3lqHFROjiPMzCtfrZYBCaGaM=;
        b=UdB6dK8ND/ClEI7kDxhgYCKESRwquiU0V34wrlQsuIsQ/l8gt9O6QAQos45MiDv5C7
         v1LBv3MpuAAVnQOTpxZRuiSDDzNGDtmuFuo77cl6dH+wNHuJ7LQKKYVTpFglUz6R3wBn
         jHu4REcf/4a/0gDHGbKEriuauoc4HKqoYrgGr5NZxi/xWlv1libEfO+OWc3swCtRlNXX
         jbfwgcDVTRrrtacu+T818CD9u8V42aGg9is5md+OwDNaO74eI6WTPHXKi8j/sMMRelkD
         lRPy6QDwdYGpBcxW2CjI4ILUjU+5UGLvZLVRlSuSATzosVMbKstYDdaYF49nH++YCT3n
         ZnnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=fhvaP0uzgyzSW5Kw6qM3lqHFROjiPMzCtfrZYBCaGaM=;
        b=iu/0GGElSOfSxFAkeXN6Z3+NbkK74cqRI+lAhkLkfFvGl4rVHIazH8hZIrWDDU0kjs
         i3hNFfOZ63dbKmm3t6c+eZL4XJl1rwGuDvU4640r6vNyzpzod4RA2+9EDb+Nfuca3ewn
         XD/rKBuA5eRVCCaE7arGTt0pz8QlzEEixZY3Bp02+EgoUc6b9WQF+/xl6bo8RJV+ozK3
         7wjLpRkkvPJ5/PqkqgmC/6GCE0lFyCZ1w2ZzKUzGJx9Z9VkiczJUFhWUj0mpvYp2rq1j
         qlwokTwzCZlcVZkLa1F/G11Ga4DBCHrVwcPHy+cmKIVcT2Q/fJGylWnyvu0Xv12JD0Yl
         HftQ==
X-Gm-Message-State: AOAM53117QScnWJCggO7/BB+GCVrsfl5dUdfyNuobgI/7w/ccS5lAf4n
        ui3/enDv8Jpq70gpSX6XVRPtNqwp
X-Google-Smtp-Source: ABdhPJysqy7E64C+cy/eVjmucUGNzLQa52+SrTw6Mpc4RtLE/hugiNB2eLOSzoc/RVlTFp5rXmvESA==
X-Received: by 2002:a62:8c12:: with SMTP id m18mr16491728pfd.111.1591112249589;
        Tue, 02 Jun 2020 08:37:29 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y22sm2870373pfc.132.2020.06.02.08.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 08:37:28 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/59] 4.9.226-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200602101841.662517961@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <3c900c0e-b15c-da05-d3d8-e68acf660076@roeck-us.net>
Date:   Tue, 2 Jun 2020 08:37:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200602101841.662517961@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/2/20 3:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.226 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jun 2020 10:16:52 +0000.
> Anything received after that time might be too late.
> 

Many arm builds still fail as attached. Is it really only me seeing this problem ?

FWIW, if we need/want to use unified assembler in v4.9.y, shouldn't all unified
assembler patches be applied ?

$ git log --oneline v4.9..c001899a5d6 arch/arm | grep unified
c001899a5d6c ARM: 8843/1: use unified assembler in headers
a216376add73 ARM: 8841/1: use unified assembler in macros
eb7ff9023e4f ARM: 8829/1: spinlock: use unified assembler language syntax
32fdb046ac43 ARM: 8828/1: uaccess: use unified assembler language syntax
1293c2b5d790 ARM: dts: berlin2q: add "cache-unified" to l2 node
75fea300d73a ARM: 8723/2: always assume the "unified" syntax for assembly code

I am quite concerned especially about missing commit 75fea300d73a,
which removes the ARM_ASM_UNIFIED configuration option. That means it is
still present in v4.9.y, but the failing builds don't enable it. Given that,
the build failures don't seem to be surprising.

Guenter

---
Build reference: v4.9.225-60-g6915714f12d0
gcc version: arm-linux-gnueabi-gcc (GCC) 9.3.0

Building arm:allmodconfig ... failed
--------------
Error log:
arch/arm/vfp/vfphw.S: Assembler messages:
arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldclne p11,cr0,[r10],#32*4'
arch/arm/vfp/vfphw.S:233: Error: bad instruction `stclne p11,cr0,[r0],#32*4'
make[2]: *** [arch/arm/vfp/vfphw.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [arch/arm/vfp] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [sub-make] Error 2
--------------

Building arm:s3c2410_defconfig ... failed
--------------
Error log:
arch/arm/lib/changebit.S: Assembler messages:
arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'
make[2]: *** [arch/arm/lib/changebit.o] Error 1
make[2]: *** Waiting for unfinished jobs....
arch/arm/lib/clear_user.S: Assembler messages:
arch/arm/lib/clear_user.S:33: Error: bad instruction `strbtal r2,[r0],#1'
arch/arm/lib/clear_user.S:34: Error: bad instruction `strbtle r2,[r0],#1'
arch/arm/lib/clear_user.S:35: Error: bad instruction `strbtlt r2,[r0],#1'
arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r0],#4'
arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r0],#4'
arch/arm/lib/clear_user.S:42: Error: bad instruction `strtpl r2,[r0],#4'
arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[r0],#1'
arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[r0],#1'
make[2]: *** [arch/arm/lib/clear_user.o] Error 1
make[1]: *** [arch/arm/lib] Error 2
make[1]: *** Waiting for unfinished jobs....

Failed builds:
arm:allmodconfig
arm:s3c2410_defconfig
arm:omap2plus_defconfig
arm:imx_v6_v7_defconfig
arm:ixp4xx_defconfig
arm:u8500_defconfig
arm:multi_v5_defconfig
arm:omap1_defconfig
arm:footbridge_defconfig
arm:davinci_all_defconfig
arm:mini2440_defconfig
arm:axm55xx_defconfig
arm:mxs_defconfig
arm:keystone_defconfig
arm:vexpress_defconfig
arm:imx_v4_v5_defconfig
arm:at91_dt_defconfig
arm:s3c6400_defconfig
arm:lpc32xx_defconfig
arm:shmobile_defconfig
arm:nhk8815_defconfig
arm:bcm2835_defconfig
arm:sama5_defconfig
arm:orion5x_defconfig
arm:exynos_defconfig
arm:cm_x2xx_defconfig
arm:s5pv210_defconfig
arm:integrator_defconfig
arm:pxa910_defconfig
arm:clps711x_defconfig
