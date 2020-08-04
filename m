Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36E523BE60
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 18:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgHDQuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 12:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726580AbgHDQtq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 12:49:46 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980FDC06174A;
        Tue,  4 Aug 2020 09:49:44 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 74so12467310pfx.13;
        Tue, 04 Aug 2020 09:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rZ0FyaPVlqFeZ3J+C2W6xWgrwt2CLBOwiPXeYmHvwhM=;
        b=hkhbxHfoHmY3PT00diNc3JPeKY4sHh9B5j/AB21KaWRx5bpSm2CIlcbF9WKsg5q3Ee
         +Dnu6yCyqeQe1W33ZnpTUsuwKjOkaujTMMYwwakZjqg1uDTEjwLMbyUVGvxlJNNxrCf/
         bOKq4O9vpSpz4eaQRFD8dbSubgrCNcSzxABwFZG6Wx6GvooIF8Cvb7cHEwD7ZVa3BCts
         MhvBmiRPvnOFz8EOXu8gJMQq1Lm1gVFOqAuj9G8NvZuhcgUelNnBCFaF+B01WlRONQrR
         hN6E7M7282f9G5tbPcmUMPp5laWCnztWxEbAt7ICgMo64IFDjuY5U49EQ1C5e8Uc/QU/
         ZwIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=rZ0FyaPVlqFeZ3J+C2W6xWgrwt2CLBOwiPXeYmHvwhM=;
        b=VLyPNvtA2ui2XKW361ZF/56AjCLnsO9EhuXrb7GhyErqHIn7PyTBvuSGxxiZJRuwth
         Q7tLfyNMJzhBs8ZLSt8vASUOcEp0XzLJ+ZRgY1ozkFMEQ0fNun95l3y8Lw31kWdPIUbV
         j/V8PiEtk7RT6wyxTqDrqDJyCY8TUR/p0hbKvPlu8G62AhlfYX/1f/CE2eUJJ5dpSMHI
         js0Ua7gkK46/W1I9BiLn8HcBYCzfq5M2Sa72iX68p/NcMc0+nZFHy3w3zeu888rAwhLT
         nWnspmwyXgLCNCyvgM+BgpRz7nDNXBvb7fMXPFxaWrY83X2n60av1QboWjDxH0tmfIxo
         TN1A==
X-Gm-Message-State: AOAM533SUweBUbwuPKSdvvxR7tfD68hTvibgnGakz35FUyCEBDejJOHl
        BlbDpq96WjJg6Zzc3NWDiB/FuTw4
X-Google-Smtp-Source: ABdhPJzKsuN0vtlLQ6nqXgHCm+ZQqcIdlAGg+HTT9Dza3WynK+eIFIZyzq6y0R/xH80odUFGI8OJaQ==
X-Received: by 2002:a63:5906:: with SMTP id n6mr19091524pgb.278.1596559784070;
        Tue, 04 Aug 2020 09:49:44 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y17sm23898276pfe.30.2020.08.04.09.49.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 09:49:43 -0700 (PDT)
Subject: Re: [PATCH 5.7 000/121] 5.7.13-rc2 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20200804072435.385370289@linuxfoundation.org>
 <CA+G9fYs35Eiq1QFM0MOj6Y7gC=YKaiknCPgcJpJ5NMW4Y7qnYQ@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <666b3ff1-76a5-c6f3-d70c-57cb01f26b77@roeck-us.net>
Date:   Tue, 4 Aug 2020 09:49:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+G9fYs35Eiq1QFM0MOj6Y7gC=YKaiknCPgcJpJ5NMW4Y7qnYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/4/20 1:16 AM, Naresh Kamboju wrote:
> On Tue, 4 Aug 2020 at 13:03, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 5.7.13 release.
>> There are 121 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 06 Aug 2020 07:23:45 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.13-rc2.gz
>> or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> arm64 build broken.
> 
> make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm64
> CROSS_COMPILE=aarch64-linux-gnu- HOSTCC=gcc CC="sccache
> aarch64-linux-gnu-gcc" O=build Image
> #
> In file included from ../include/linux/smp.h:67,
>                  from ../include/linux/percpu.h:7,
>                  from ../include/linux/prandom.h:12,
>                  from ../include/linux/random.h:118,
>                  from ../arch/arm64/include/asm/pointer_auth.h:6,
>                  from ../arch/arm64/include/asm/processor.h:39,
>                  from ../include/linux/mutex.h:19,
>                  from ../include/linux/kernfs.h:12,
>                  from ../include/linux/sysfs.h:16,
>                  from ../include/linux/kobject.h:20,
>                  from ../include/linux/of.h:17,
>                  from ../include/linux/irqdomain.h:35,
>                  from ../include/linux/acpi.h:13,
>                  from ../include/acpi/apei.h:9,
>                  from ../include/acpi/ghes.h:5,
>                  from ../include/linux/arm_sdei.h:8,
>                  from ../arch/arm64/kernel/asm-offsets.c:10:
> ../arch/arm64/include/asm/smp.h:100:29: error: field ‘ptrauth_key’ has
> incomplete type
>   100 |  struct ptrauth_keys_kernel ptrauth_key;
>       |                             ^~~~~~~~~~~
> make[2]: *** [../scripts/Makefile.build:100:
> arch/arm64/kernel/asm-offsets.s] Error 1
> 

I didn't see that error after I applied Linus' patch on top of v5.8.
On current mainline, I get the following error when trying to build
sparc64:allmodconfig:

include/linux/seqlock.h: In function 'write_seqcount_begin_nested':
arch/sparc/include/asm/percpu_64.h:19:25: error: '__local_per_cpu_offset' undeclared

This is caused by by commit 859247d39fb00 ("seqlock: lockdep assert non-preemptibility
on seqcount_t write").

When trying to build arm64:defconfig, I get this error:

Building arm64:defconfig ... failed
--------------
Error log:
Error: arch/arm64/boot/dts/intel/socfpga_agilex.dtsi:313.15-16 syntax error

This is caused by commit d4ae4dd346cd493 ("arm64: dts: agilex: add nand clocks").

Sigh. Anyway, after reverting those two commits on mainline (v5.8-2483-gc0842fbc1b18),
both arm64:defconfig and arm64:allmodconfig build for me (with gcc-9.3.0). Given that,
I don't think this compile problem is seen in the upstream kernel.

Guenter
