Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70AD553309C
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 20:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240402AbiEXSmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 14:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiEXSmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 14:42:19 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6EA58385;
        Tue, 24 May 2022 11:42:17 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id s14so16582161plk.8;
        Tue, 24 May 2022 11:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=Srf/k1EMySBKUhCzKsY+R4gF2IaSdK+tZE4km9P9aRU=;
        b=p57816IQKTz3FFCAIb/HESMUK5uZdTdQLjuS4bQworqgRxKI4/l3ImRUjoOeOhEBgp
         tcUb5iopva/Zyz7QYWSsmPppit3331USvG30lZq1dUeQvSQt9eXCOKsuDJ8D2Dbx5NNo
         SSArX72fuv5o/2TgThPAOsl+i0UVqky6C9PaWg6qXHcxx41wpGaA9NAH9epUU2uxQJv7
         2yIgkjQJ5Z7ZKQCody5KJrnheUfzjmXM5T0kahrVWG4JC5xh553qCpSMMw8SmJ5+mErE
         3ZMkyT0Jh4LEQ3mTtYEjqk4JQqThtRFTiNS1/YfP9jAZwX+tgiS8TSTSw5IjFMislz00
         wIKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=Srf/k1EMySBKUhCzKsY+R4gF2IaSdK+tZE4km9P9aRU=;
        b=Q1o3geDEEtEIoTXQHMC5cM7FFDol22yBbKoGYBQlH4o48ZyLxpd5LIN5D5ym1xjW61
         Djr7JGSdQYnI84cW/6q9jLyyf3jVf1DIJohzUkNVwwC+v73LGs2Qt9okvCVCye+dcv0Q
         f6BFZUG11DAOHlfOyMux6M82FtN6szqPHC4gCDX9EWvVucf1tS3gIRL0mdzLdN1u7kd8
         +jMMGIPgt1CQl5gPKccFVUROu79cJkBPOh4Xuo+p/PlnKr5ueBXA4MkjeKlmgHZ0hKcB
         HqU6hkqpgBp/ULzZ/aFqN87zAvD+gXaS09pNTppkPrA/hqgz3xXt67bNDO/csvhg8nYa
         wx1A==
X-Gm-Message-State: AOAM533j6FiAjG9jSy/2xX7Lk6bNUIPYJrGraQcFGqClDKN44Pf5RtHT
        wkcGGoIHOuV85ELqT3WbtVw=
X-Google-Smtp-Source: ABdhPJyCFsebXQEnhFHYFk4nzRyLZ6g0qPb8mFMiZQYIALYRoRUwC24Rmcq/EDqzmYWfWLAKfqYIGA==
X-Received: by 2002:a17:902:7c0e:b0:162:1aa9:f550 with SMTP id x14-20020a1709027c0e00b001621aa9f550mr12674628pll.159.1653417737016;
        Tue, 24 May 2022 11:42:17 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j11-20020aa783cb000000b0050dc76281f2sm9551555pfn.204.2022.05.24.11.42.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 11:42:16 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------D00Jamxdfb3lG1FpuA2Dz5Zj"
Message-ID: <2dd9228b-8fb8-6877-5825-3923b15b9796@gmail.com>
Date:   Tue, 24 May 2022 11:42:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 4.9 00/25] 4.9.316-rc1 review
Content-Language: en-US
To:     Jon Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220523165743.398280407@linuxfoundation.org>
 <6f4034a5-f692-8a64-a09d-8bfe49767b78@nvidia.com>
 <YozK4DvamHBJ1qdX@kroah.com>
 <fbeb9833-4166-1919-e6ab-9ac7625a21d6@nvidia.com>
 <Yoz0Xv59MrUwFkMT@kroah.com> <883fc4cf-dce0-a433-5cf7-7de68be17ffb@gmail.com>
 <97cf35b5-1286-91a0-c0d4-df7fe8a983e6@nvidia.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <97cf35b5-1286-91a0-c0d4-df7fe8a983e6@nvidia.com>
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------D00Jamxdfb3lG1FpuA2Dz5Zj
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/24/22 10:50, Jon Hunter wrote:
> 
> On 24/05/2022 17:30, Florian Fainelli wrote:
> 
> ...
> 
>> Jonathan any chance this is Tegra specific? Our ARCH_BRCMSTB SoCs 
>> which use a Brahma-B15 which uses nearly the same ca15 processor 
>> functions defined in arch/arm/mm/proc-v7.S reports the following 
>> *before* changes:
>>
>> [    0.001641] CPU: Testing write buffer coherency: ok
>> [    0.001685] CPU0: Spectre v2: using ICIALLU workaround
>> [    0.001703] ftrace: allocating 30541 entries in 120 pages
>> [    0.044600] CPU0: update cpu_capacity 1024
>> [    0.044633] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
>> [    0.044662] Setting up static identity map for 0x200000 - 0x200060
>> [    0.047410] brcmstb: biuctrl: MCP: Write pairing already disabled
>> [    0.048974] CPU1: update cpu_capacity 1024
>> [    0.048978] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
>> [    0.048981] CPU1: Spectre v2: using ICIALLU workaround
>> [    0.050234] CPU2: update cpu_capacity 1024
>> [    0.050238] CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
>> [    0.050241] CPU2: Spectre v2: using ICIALLU workaround
>> [    0.051437] CPU3: update cpu_capacity 1024
>> [    0.051441] CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
>> [    0.051444] CPU3: Spectre v2: using ICIALLU workaround
>> [    0.051532] Brought up 4 CPUs
>>
>> and this *after* merging 4.9.316-rc1:
>>
>> [    0.001626] CPU: Testing write buffer coherency: ok
>> [    0.001670] CPU0: Spectre v2: using ICIALLU workaround
>> [    0.001689] CPU0: Spectre BHB: using loop workaround
>> [    0.001705] ftrace: allocating 30542 entries in 120 pages
>> [    0.043752] CPU0: update cpu_capacity 1024
>> [    0.043784] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
>> [    0.043813] Setting up static identity map for 0x200000 - 0x200060
>> [    0.046547] brcmstb: biuctrl: MCP: Write pairing already disabled
>> [    0.048121] CPU1: update cpu_capacity 1024
>> [    0.048124] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
>> [    0.048129] CPU1: Spectre v2: using ICIALLU workaround
>> [    0.048165] CPU1: Spectre BHB: using loop workaround
>> [    0.049398] CPU2: update cpu_capacity 1024
>> [    0.049402] CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
>> [    0.049405] CPU2: Spectre v2: using ICIALLU workaround
>> [    0.049440] CPU2: Spectre BHB: using loop workaround
>> [    0.050613] CPU3: update cpu_capacity 1024
>> [    0.050617] CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
>> [    0.050619] CPU3: Spectre v2: using ICIALLU workaround
>> [    0.050653] CPU3: Spectre BHB: using loop workaround
>> [    0.050722] Brought up 4 CPUs
>> [    0.050738] SMP: Total of 4 processors activated (216.00 BogoMIPS).
>> [    0.050753] CPU: All CPU(s) started in HYP mode.
> 
> 
> Does your platform support CPU idle? I see this being triggered
> during CPU idle transitions ...

It does, but not with an idle state resulting in powering down secondary 
cores. We do have CPU hotplug with power gating as well as system wide 
suspend states that result in power gating secondaries and they appear 
to be working fine.

I use the attached script to randomly cycle hot plug/unplug through each 
4 cores and it has been running over 10k cycles.

> 
> [    4.415167] CPU0: Spectre BHB: using loop workaround
> [    4.417621] [<c01109a0>] (unwind_backtrace) from [<c010b7ac>] 
> (show_stack+0x10/0x14)
> [    4.430291] [<c010b7ac>] (show_stack) from [<c09c2b38>] 
> (dump_stack+0xc0/0xd4)
> [    4.437512] [<c09c2b38>] (dump_stack) from [<c011a6c8>] 
> (cpu_v7_spectre_bhb_init+0xd8/0x190)
> [    4.445943] [<c011a6c8>] (cpu_v7_spectre_bhb_init) from [<c010dee8>] 
> (cpu_suspend+0xac/0xc8)
> [    4.454377] [<c010dee8>] (cpu_suspend) from [<c011e7e4>] 
> (tegra114_idle_power_down+0x74/0x78)
> [    4.462898] [<c011e7e4>] (tegra114_idle_power_down) from [<c06d3b44>] 
> (cpuidle_enter_state+0x130/0x524)
> [    4.472286] [<c06d3b44>] (cpuidle_enter_state) from [<c0164a30>] 
> (do_idle+0x1b0/0x200)
> [    4.480199] [<c0164a30>] (do_idle) from [<c0164d28>] 
> (cpu_startup_entry+0x18/0x1c)
> [    4.487762] [<c0164d28>] (cpu_startup_entry) from [<801018cc>] 
> (0x801018cc)
> 
> Jon
> 


-- 
Florian
--------------D00Jamxdfb3lG1FpuA2Dz5Zj
Content-Type: application/x-shellscript; name="hotplug.sh"
Content-Disposition: attachment; filename="hotplug.sh"
Content-Transfer-Encoding: base64

IyEvYmluL3NoCiMgSG90cGx1ZyB0ZXN0Cgp1c2FnZSgpIHsKCWVjaG8gIlVzYWdlOiAkMCBb
IyBjcHVzXSIKCWVjaG8gIiAgIElmIG51bWJlciBvZiBjcHVzIGlzIG5vdCBnaXZlbiwgZGVm
YXVsdHMgdG8gMiIKCWV4aXQKfQoKIyBEZWZhdWx0IHRvIDIgQ1BVcwpOUl9DUFVTPSR7MTot
Mn0KClsgJE5SX0NQVVMgLWx0IDIgXSAmJiB1c2FnZSAxPiYyCgpNQVhDUFU9JCgoTlJfQ1BV
Uy0xKSkKTUFYPWBjYXQgL3N5cy9kZXZpY2VzL3N5c3RlbS9jcHUva2VybmVsX21heGAKClsg
JE1BWENQVSAtZ3QgJE1BWCBdICYmIGVjaG8gIlRvbyBtYW55IENQVXMiIDE+JjIgJiYgdXNh
Z2UgMT4mMgoKY3B1X3BhdGgoKSB7CgllY2hvIC9zeXMvZGV2aWNlcy9zeXN0ZW0vY3B1L2Nw
dSQxCn0KCmNoZWNrcG9pbnRfdGVzdCgpIHsKCWlmIFsgJCgoJDEgJSA1MCkpIC1lcSAwIF07
IHRoZW4KCQllY2hvICIqKioqIEZpbmlzaGVkIHRlc3QgJDEgKioqKiIKCWZpCn0KCmVjaG8g
JyoqKionCmVjaG8gIlRlc3RpbmcgJE5SX0NQVVMgQ1BVcyIKZWNobyAnKioqKicKClRFU1Q9
MAp3aGlsZSA6CmRvCglOPSQoKFJBTkRPTSAlIE1BWENQVSArIDEpKQoJT049YGNhdCAkKGNw
dV9wYXRoICROKS9vbmxpbmVgCgllY2hvICQoKDEtT04pKSA+ICQoY3B1X3BhdGggJE4pL29u
bGluZQoJVEVTVD0kKChURVNUKzEpKQoJY2hlY2twb2ludF90ZXN0ICRURVNUCmRvbmUK

--------------D00Jamxdfb3lG1FpuA2Dz5Zj--
