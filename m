Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDBDB147306
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 22:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgAWVSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 16:18:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46704 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728911AbgAWVSb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 16:18:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579814303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=How2H6NEL6Dqougmvv1ZVsMJeirc4iagODypXt8mk0M=;
        b=KBozfCZgxikq0KVjRqr3Kys2V/kkqM0VX2gzfEw7v6VuxMuArlfsED58vQXUvqL49NpmiY
        DYHkm1pw68TlyYyyS4/318uHoOsyHleo0ViBnGP1ZHdfamRRPBozkXd0avdMmswyFF1crK
        M6FZacHfQnxGrutmd7hyqUVRcNBZJYM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-S-SthsjnMxmkEY8s9sDRJQ-1; Thu, 23 Jan 2020 16:18:21 -0500
X-MC-Unique: S-SthsjnMxmkEY8s9sDRJQ-1
Received: by mail-wr1-f72.google.com with SMTP id j4so28047wrs.13
        for <stable@vger.kernel.org>; Thu, 23 Jan 2020 13:18:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=How2H6NEL6Dqougmvv1ZVsMJeirc4iagODypXt8mk0M=;
        b=GVhey6QMb5A9S3bT9T4GU67WFhBPhy15RJ0atQdsH60DvFlyVUXZHalz7L3NU+WofL
         DrYw4lHz9LRIJP0uLnV3jL665MJKn2h2qMy8pjRm+Jx+/PCPuGvuy5vjswna957grzgZ
         8q5syjE2YrLpWwE14dZg1iNCBJlzsqsjdtjAH7HyAZXTOhBZuySyImBUInPNN+Vxh14+
         ixwrq0Dkzs2QwSDGcA/VdHXDyKJeeUkzbPC+H2l3ZcyFfgRh/xTRZOD83igX/cmx3kZN
         hh21M9KL4yC55ABHAK6/omMHu8pfpv0bGSI6Kr8WWzp97ZxeL9ph5y+Ik84uE5BsMNUz
         Usmg==
X-Gm-Message-State: APjAAAWJ9VLxZepBOxS13jHTLQNimZjkOYOXNP5cqitOoqAfYDmc+mOP
        /yQZFowEZj9Uc9nwwxCzhlTUMO5QcSdH6G8gmuna27jErWW+MWKMAb+KK6h3SBD98/AoEWTULle
        2DPHXrzKGWgsk6Dm9
X-Received: by 2002:a5d:5704:: with SMTP id a4mr44261wrv.198.1579814298496;
        Thu, 23 Jan 2020 13:18:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqwR9FV+i5D4lQ4QIoKETdPAhaHnVIimzy6j2Ul0afo5rFGKkg7pcKZVVi2d7OyIpAPLSXbZ3A==
X-Received: by 2002:a5d:5704:: with SMTP id a4mr44137wrv.198.1579814296856;
        Thu, 23 Jan 2020 13:18:16 -0800 (PST)
Received: from shalem.localdomain (2001-1c00-0c0c-fe00-7e79-4dac-39d0-9c14.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:7e79:4dac:39d0:9c14])
        by smtp.gmail.com with ESMTPSA id d16sm5165769wrg.27.2020.01.23.13.18.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 13:18:15 -0800 (PST)
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on
 Intel Bay Trail SoC
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        vipul kumar <vipulk0511@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        x86@kernel.org, Bin Gao <bin.gao@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
References: <1579617717-4098-1-git-send-email-vipulk0511@gmail.com>
 <87eevs7lfd.fsf@nanos.tec.linutronix.de>
 <CADdC98RJpsvu_zWehNGDDN=W11rD11NSPaodg-zuaXsHuOJYTQ@mail.gmail.com>
 <878slzeeim.fsf@nanos.tec.linutronix.de>
 <CADdC98TE4oNWZyEsqXzr+zJtfdTTOyeeuHqu1u04X_ktLHo-Hg@mail.gmail.com>
 <20200123144108.GU32742@smile.fi.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <df04f43d-8c6d-7602-cb50-535b85cf2aaa@redhat.com>
Date:   Thu, 23 Jan 2020 22:18:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200123144108.GU32742@smile.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Sorry for top posting, but this is a long and almost unreadable thread ...

So it seems to me that a better fix would be to change the freq_desc_byt struct from:

static const struct freq_desc freq_desc_byt = {
         1, { 83300, 100000, 133300, 116700, 80000, 0, 0, 0 }
};

to:

static const struct freq_desc freq_desc_byt = {
         1, { 83333, 100000, 133300, 116700, 80000, 0, 0, 0 }
};

That should give us the right TSC frequency without needing to mess with
the TSC_KNOWN_FREQ and TSC_RELIABLE flags.

Regards,

Hans


On 23-01-2020 15:41, Andy Shevchenko wrote:
> +Cc: Hans, since he possesses a lot of BYT devices and may be interested in this
> 
> On Thu, Jan 23, 2020 at 06:00:28PM +0530, vipul kumar wrote:
>> Hi Thomas,
>>
>> On Wed, Jan 22, 2020 at 8:15 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>>> Vipul,
>>>
>>> vipul kumar <vipulk0511@gmail.com> writes:
>>>> On Tue, Jan 21, 2020 at 11:15 PM Thomas Gleixner <tglx@linutronix.de>
>>> wrote:
>>>
>>>>     Measurement with the existing code:
>>>>     $ echo -n "SystemTime: " ; TZ=UTC date -Iseconds ; echo -n "RTC Time:
>>>> " ; TZ=UTC hwclock -r ; echo -n "Uptime: " ; uptime -p
>>>>     SystemTime: 2019-12-05T17:18:37+00:00
>>>>     RTC Time:   2019-12-05 17:18:07.255341+0000
>>>>     Uptime: up 1 day, 7 minutes
>>>>
>>>>     This sample shows a difference of 30 seconds after 1 day.
>>>>
>>>>     Measurement with this patch:
>>>>     SystemTime: 2019-12-11T12:06:19+00:00
>>>>     RTC Time:   2019-12-11 12:06:19.083127+0000
>>>>     Uptime: up 1 day, 3 minutes
>>>>
>>>>     With this patch, no time drift issue is observed. and tsc clocksource
>>>> get calibration (tsc: Refined TSC clocksource calibration: 1833.333 MHz)
>>>> which is missing
>>>>     with the existing implementation.
>>>
>>> What's the frequency which is determined from the MSR? Something like
>>> this in dmesg:
>>>
>>>         tsc: Detected NNN MHz processor
>>> or
>>>         tsc: Detected NNN MHz TSC
>>>
>>
>>     tsc: Detected 1832.600 MHz processor
>>
>>     # dmesg | grep tsc
>>     [    0.000000] tsc: Detected 1832.600 MHz processor
>>     [    4.895129] tsc: Refined TSC clocksource calibration: 1833.332 MHz
>>     [    4.895201] clocksource: tsc: mask: 0xffffffffffffffff max_cycles:
>> 0x34da5269766, max_idle_ns: 881590747508 ns
>>     [    5.903264] clocksource: Switched to clocksource tsc
>>
>>     Attached full logs with patch and without patch.
>>
>>>
>>> Also please apply the debug patch below and provide a _full_ dmesg after
>>> boot.
>>>
>>>>>> +config X86_FEATURE_TSC_UNKNOWN_FREQ
>>>>>> +     bool "Support to skip tsc known frequency flag"
>>>>>> +     help
>>>>>> +       Include support to skip X86_FEATURE_TSC_KNOWN_FREQ flag
>>>>>> +
>>>>>> +       X86_FEATURE_TSC_KNOWN_FREQ flag is causing time-drift on
>>>>> Valleyview/
>>>>>> +       Baytrail SoC.
>>>>>> +       By selecting this option, user can skip
>>>>> X86_FEATURE_TSC_KNOWN_FREQ
>>>>>> +       flag to use refine tsc freq calibration.
>>>>>
>>>>> This is exactly the same problem as before. How does anyone aside of you
>>>>> know whether to enable this or not?
>>>>>
>>>>      Go through the Documentation/kbuild/kconfig-language.rst but didn't
>>>> find related to make
>>>>      config known to everyone. Could you please point to documentation?
>>>
>>> Right. And there is no proper answer to this, which makes it clear that
>>> a config option is not the right tool to use.
>>>
>>>>> And if someone enables this option then _ALL_ platforms which utilize
>>>>> cpu_khz_from_msr() are affected. How is that any different from your
>>>>> previous approach? This works on local kernels where you build for a
>>>>> specific platform and you know exactly what you're doing, but not for
>>>>> general consumption. What should a distro do with this option?
>>>>>
>>>>>
>>>>      TSC frequency is already calculated in cpu_khz_from_msr() function
>>>> before setting these flags.
>>>
>>> Your mail client does some horrible formatting this zig-zag is
>>> unreadable. I'm reformatting the paragraphs below.
>>>
>>
>>    Sorry for that. Need to set formatting for reply.
>>
>>>
>>>> This patch return the same calculated TSC frequency but skipping
>>>> those two flags. On the basis of these flags, we decide whether we
>>>> skip the refined calibration and directly register it as a clocksource
>>>> or use refine tsc freq calibration in init_tsc_clocksource()
>>>> function. By default this config is disabled and if user wants to use
>>>> refine tsc freq calibration() then only user will enable it otherwise
>>>> it will go with existing implementations. So, I don't think so it will
>>>> break for other ATOM SoC.
>>>
>>> It does. I explained most of the following to you in an earlier mail
>>> already. Let me try again.
>>>
>>> If X86_FEATURE_TSC_RELIABLE is not set, then the TSC requires a watchdog
>>> clocksource. But some of those SoCs do not have anything else than TSC,
>>> so there is no watchdog available. As a consequence the TSC is not
>>> usable for high resolution timers and NOHZ. That breaks existing systems
>>> whether you like it or not.
>>>
>>> If X86_FEATURE_TSC_KNOWN_FREQUENCY is not set, then this delays the
>>> usability of the TSC for high res and NOHZ until the refined calibration
>>> figured out that it can't calibrate. And no, we can't know that it does
>>> not work upfront when the early TSC init happens. Clearing this flag
>>> will not break functionality, but it changes the behaviour on boot-time
>>> optimized systems which can obviously be considered breakage.
>>>
>>> So no, having a config knob which might be turned on and turning working
>>> systems into trainwrecks is simply not the way to go.
>>>
>>
>>     Thanks Thomas for clarifying about reliable and known frequency flags.
>>
>>>
>>> What can be done is to have a command line option which enforces refined
>>> calibration and that option can turn off X86_FEATURE_TSC_KNOWN_FREQUENCY,
>>> but nothing else.
>>>
>>
>>      Sure Thomas, will make implementation as per your suggestion.
>>
>>      Regards,
>>      Vipul
>>
>>>
>>>> Check the cpu_khz_from_msr() function.
>>>
>>> I know that code.
>>>
>>>> In cpu_khz_from_msr() function we are setting
>>>> X86_FEATURE_TSC_KNOWN_FREQ and X86_FEATURE_TSC_RELIABLE for all the
>>>> SoC's but in native_calibrate_tsc(), we check for vendor == INTEL and
>>>> CPUID > 0x15 and then at the end of function, will enable
>>>> X86_FEATURE_TSC_RELIABLE for INTEL_FAM6_ATOM_GOLDMONT SoC.
>>>>
>>>> Do we need to set the same flag in two different functions as it will be
>>>> set in cpu_khz_from_msr() for all SoCs ?
>>>
>>> cpu_khz_from_msr() does not handle INTEL_FAM6_ATOM_GOLDMONT or can you
>>> find that in tsc_msr_cpu_ids[]? Making half informed claims is not
>>> solving anything.
>>>
>>> Thanks,
>>>
>>>          tglx
>>>
>>> 8<------------------
>>>
>>> --- a/arch/x86/kernel/tsc_msr.c
>>> +++ b/arch/x86/kernel/tsc_msr.c
>>> @@ -94,16 +94,20 @@ unsigned long cpu_khz_from_msr(void)
>>>          if (freq_desc->msr_plat) {
>>>                  rdmsr(MSR_PLATFORM_INFO, lo, hi);
>>>                  ratio = (lo >> 8) & 0xff;
>>> +               pr_info("MSR_PINFO: %08x%08x -> %u\n", hi, lo, ratio);
>>>          } else {
>>>                  rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
>>>                  ratio = (hi >> 8) & 0x1f;
>>> +               pr_info("MSR_PSTAT: %08x%08x -> %u\n", hi, lo, ratio);
>>>          }
>>>
>>>          /* Get FSB FREQ ID */
>>>          rdmsr(MSR_FSB_FREQ, lo, hi);
>>> +       pr_info("MSR_FSBF: %08x%08x\n", hi, lo);
>>>
>>>          /* Map CPU reference clock freq ID(0-7) to CPU reference clock
>>> freq(KHz) */
>>>          freq = freq_desc->freqs[lo & 0x7];
>>> +       pr_info("REF_CLOCK: %08x\n", freq);
>>>
>>>          /* TSC frequency = maximum resolved freq * maximum resolved bus
>>> ratio */
>>>          res = freq * ratio;
>>>
> 
>> root@localhost:# dmesg
>> [    0.000000] microcode: microcode updated early to revision 0x838, date = 2019-04-22
>> [    0.000000] Linux version 4.14.139-rt66 (builder@vipul) (gcc version 6.3.0 20170516 (Debian 6.3.0-18+deb9u1)) #1 SMP PREEMPT RT Thu Jan 23 11:04:55 UTC 2020
>> [    0.000000] Command line: rootwait quiet     rootflags=i_version ima_tcb ima_appraise=enforce ima_appraise_tcb  nohz=off        splash plymouth.ignore-serial-consoles quiet        root=/dev/mapper/system-systema
>>
>> [    0.000000] x86/fpu: x87 FPU will use FXSAVE
>> [    0.000000] e820: BIOS-provided physical RAM map:
>> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000006efff] usable
>> [    0.000000] BIOS-e820: [mem 0x000000000006f000-0x000000000006ffff] ACPI NVS
>> [    0.000000] BIOS-e820: [mem 0x0000000000070000-0x000000000008ffff] usable
>> [    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009ffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000b7af2fff] usable
>> [    0.000000] BIOS-e820: [mem 0x00000000b7af3000-0x00000000b8402fff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000b8403000-0x00000000b8502fff] ACPI NVS
>> [    0.000000] BIOS-e820: [mem 0x00000000b8503000-0x00000000b8542fff] ACPI data
>> [    0.000000] BIOS-e820: [mem 0x00000000b8543000-0x00000000b93c2fff] usable
>> [    0.000000] BIOS-e820: [mem 0x00000000b93c3000-0x00000000b9cc2fff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000b9cc3000-0x00000000b9ffffff] usable
>> [    0.000000] BIOS-e820: [mem 0x00000000e00f8000-0x00000000e00f8fff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000fed01000-0x00000000fed01fff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000ffb00000-0x00000000ffffffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023fffffff] usable
>> [    0.000000] NX (Execute Disable) protection: active
>> [    0.000000] e820: update [mem 0xb43d3018-0xb43e3057] usable ==> usable
>> [    0.000000] e820: update [mem 0xb43d3018-0xb43e3057] usable ==> usable
>> [    0.000000] extended physical RAM map:
>> [    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000006efff] usable
>> [    0.000000] reserve setup_data: [mem 0x000000000006f000-0x000000000006ffff] ACPI NVS
>> [    0.000000] reserve setup_data: [mem 0x0000000000070000-0x000000000008ffff] usable
>> [    0.000000] reserve setup_data: [mem 0x0000000000090000-0x000000000009ffff] reserved
>> [    0.000000] reserve setup_data: [mem 0x0000000000100000-0x00000000b43d3017] usable
>> [    0.000000] reserve setup_data: [mem 0x00000000b43d3018-0x00000000b43e3057] usable
>> [    0.000000] reserve setup_data: [mem 0x00000000b43e3058-0x00000000b7af2fff] usable
>> [    0.000000] reserve setup_data: [mem 0x00000000b7af3000-0x00000000b8402fff] reserved
>> [    0.000000] reserve setup_data: [mem 0x00000000b8403000-0x00000000b8502fff] ACPI NVS
>> [    0.000000] reserve setup_data: [mem 0x00000000b8503000-0x00000000b8542fff] ACPI data
>> [    0.000000] reserve setup_data: [mem 0x00000000b8543000-0x00000000b93c2fff] usable
>> [    0.000000] reserve setup_data: [mem 0x00000000b93c3000-0x00000000b9cc2fff] reserved
>> [    0.000000] reserve setup_data: [mem 0x00000000b9cc3000-0x00000000b9ffffff] usable
>> [    0.000000] reserve setup_data: [mem 0x00000000e00f8000-0x00000000e00f8fff] reserved
>> [    0.000000] reserve setup_data: [mem 0x00000000fed01000-0x00000000fed01fff] reserved
>> [    0.000000] reserve setup_data: [mem 0x00000000ffb00000-0x00000000ffffffff] reserved
>> [    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000023fffffff] usable
>> [    0.000000] efi: EFI v2.40 by INSYDE Corp.
>> [    0.000000] efi:  ACPI 2.0=0xb8542014  ESRT=0xb7be2d18  SMBIOS=0xb7dfa000
>> [    0.000000] SMBIOS 2.7 present.
>> [    0.000000] DMI: SIEMENS AG SIMATIC IPC227E/A5E38155677, BIOS V20.01.12 04/05/2019
>> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
>> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
>> [    0.000000] e820: last_pfn = 0x240000 max_arch_pfn = 0x400000000
>> [    0.000000] MTRR default type: uncachable
>> [    0.000000] MTRR fixed ranges enabled:
>> [    0.000000]   00000-9FFFF write-back
>> [    0.000000]   A0000-BFFFF uncachable
>> [    0.000000]   C0000-FFFFF write-protect
>> [    0.000000] MTRR variable ranges enabled:
>> [    0.000000]   0 base 0FF800000 mask FFF800000 write-protect
>> [    0.000000]   1 base 000000000 mask F80000000 write-back
>> [    0.000000]   2 base 080000000 mask FC0000000 write-back
>> [    0.000000]   3 base 0BC000000 mask FFC000000 uncachable
>> [    0.000000]   4 base 0BB000000 mask FFF000000 uncachable
>> [    0.000000]   5 base 0BAE00000 mask FFFE00000 uncachable
>> [    0.000000]   6 base 100000000 mask F00000000 write-back
>> [    0.000000]   7 base 200000000 mask FC0000000 write-back
>> [    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT
>> [    0.000000] e820: last_pfn = 0xba000 max_arch_pfn = 0x400000000
>> [    0.000000] Base memory trampoline at [ffff9b900008a000] 8a000 size 24576
>> [    0.000000] BRK [0x1ced18000, 0x1ced18fff] PGTABLE
>> [    0.000000] BRK [0x1ced19000, 0x1ced19fff] PGTABLE
>> [    0.000000] BRK [0x1ced1a000, 0x1ced1afff] PGTABLE
>> [    0.000000] BRK [0x1ced1b000, 0x1ced1bfff] PGTABLE
>> [    0.000000] BRK [0x1ced1c000, 0x1ced1cfff] PGTABLE
>> [    0.000000] BRK [0x1ced1d000, 0x1ced1dfff] PGTABLE
>> [    0.000000] BRK [0x1ced1e000, 0x1ced1efff] PGTABLE
>> [    0.000000] BRK [0x1ced1f000, 0x1ced1ffff] PGTABLE
>> [    0.000000] BRK [0x1ced20000, 0x1ced20fff] PGTABLE
>> [    0.000000] BRK [0x1ced21000, 0x1ced21fff] PGTABLE
>> [    0.000000] BRK [0x1ced22000, 0x1ced22fff] PGTABLE
>> [    0.000000] Secure boot could not be determined
>> [    0.000000] RAMDISK: [mem 0xadc31000-0xafffffff]
>> [    0.000000] ACPI: Early table checksum verification disabled
>> [    0.000000] ACPI: RSDP 0x00000000B8542014 000024 (v02 SIEMEN)
>> [    0.000000] ACPI: XSDT 0x00000000B8542120 00009C (v01 SIEMEN SIMATIC  11112222      01000013)
>> [    0.000000] ACPI: FACP 0x00000000B853B000 00010C (v05 SIEMEN SIMATIC  11112222 WAS_ 00010001)
>> [    0.000000] ACPI: DSDT 0x00000000B8530000 006A5B (v02 SIEMEN SIMATIC  11112222 WAS_ 00010001)
>> [    0.000000] ACPI: FACS 0x00000000B84AA000 000040
>> [    0.000000] ACPI: UEFI 0x00000000B8541000 000236 (v01 SIEMEN SIMATIC  00000001 WAS_ 12345678)
>> [    0.000000] ACPI: TCPA 0x00000000B8540000 000032 (v02 SIEMEN SIMATIC  00000000 WAS_ 00000000)
>> [    0.000000] ACPI: UEFI 0x00000000B853E000 000042 (v01 SIEMEN SIMATIC  00000000 WAS_ 00000000)
>> [    0.000000] ACPI: SSDT 0x00000000B853D000 0004FD (v01 SIEMEN TPMACPI  00001000 WAS_ 20121114)
>> [    0.000000] ACPI: TPM2 0x00000000B853C000 000034 (v03 SIEMEN SIMATIC  00000000 WAS_ 00000000)
>> [    0.000000] ACPI: HPET 0x00000000B853A000 000038 (v01 SIEMEN SIMATIC  11112222 WAS_ 00010001)
>> [    0.000000] ACPI: LPIT 0x00000000B8539000 000104 (v01 SIEMEN SIMATIC  11112222 WAS_ 00010001)
>> [    0.000000] ACPI: APIC 0x00000000B8538000 000084 (v03 SIEMEN SIMATIC  11112222 WAS_ 00010001)
>> [    0.000000] ACPI: MCFG 0x00000000B8537000 00003C (v01 SIEMEN SIMATIC  11112222 WAS_ 00010001)
>> [    0.000000] ACPI: SSDT 0x00000000B852E000 000763 (v01 SIEMEN CpuPm    00003000 WAS_ 20121114)
>> [    0.000000] ACPI: SSDT 0x00000000B852D000 000290 (v01 SIEMEN Cpu0Tst  00003000 WAS_ 20121114)
>> [    0.000000] ACPI: SSDT 0x00000000B852C000 00017A (v01 SIEMEN ApTst    00003000 WAS_ 20121114)
>> [    0.000000] ACPI: FPDT 0x00000000B852B000 000044 (v01 SIEMEN SIMATIC  00000002 WAS_ 01000013)
>> [    0.000000] ACPI: BGRT 0x00000000B852F000 000038 (v01 SIEMEN SIMATIC  00000001 WAS_ 12345678)
>> [    0.000000] ACPI: Local APIC address 0xfee00000
>> [    0.000000] No NUMA configuration found
>> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000023fffffff]
>> [    0.000000] NODE_DATA(0) allocated [mem 0x23fff7000-0x23fffbfff]
>> [    0.000000] Zone ranges:
>> [    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
>> [    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
>> [    0.000000]   Normal   [mem 0x0000000100000000-0x000000023fffffff]
>> [    0.000000]   Device   empty
>> [    0.000000] Movable zone start for each node
>> [    0.000000] Early memory node ranges
>> [    0.000000]   node   0: [mem 0x0000000000001000-0x000000000006efff]
>> [    0.000000]   node   0: [mem 0x0000000000070000-0x000000000008ffff]
>> [    0.000000]   node   0: [mem 0x0000000000100000-0x00000000b7af2fff]
>> [    0.000000]   node   0: [mem 0x00000000b8543000-0x00000000b93c2fff]
>> [    0.000000]   node   0: [mem 0x00000000b9cc3000-0x00000000b9ffffff]
>> [    0.000000]   node   0: [mem 0x0000000100000000-0x000000023fffffff]
>> [    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000023fffffff]
>> [    0.000000] On node 0 totalpages: 2067518
>> [    0.000000]   DMA zone: 64 pages used for memmap
>> [    0.000000]   DMA zone: 21 pages reserved
>> [    0.000000]   DMA zone: 3982 pages, LIFO batch:0
>> [    0.000000]   DMA32 zone: 11763 pages used for memmap
>> [    0.000000]   DMA32 zone: 752816 pages, LIFO batch:31
>> [    0.000000]   Normal zone: 20480 pages used for memmap
>> [    0.000000]   Normal zone: 1310720 pages, LIFO batch:31
>> [    0.000000] x86/hpet: Will disable the HPET for this platform because it's not reliable
>> [    0.000000] Reserving Intel graphics memory at 0x00000000bb000000-0x00000000beffffff
>> [    0.000000] ACPI: PM-Timer IO Port: 0x408
>> [    0.000000] ACPI: Local APIC address 0xfee00000
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
>> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-86
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
>> [    0.000000] ACPI: IRQ0 used by override.
>> [    0.000000] ACPI: IRQ9 used by override.
>> [    0.000000] Using ACPI (MADT) for SMP configuration information
>> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
>> [    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
>> [    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0x0006f000-0x0006ffff]
>> [    0.000000] PM: Registered nosave memory: [mem 0x00090000-0x0009ffff]
>> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xb43d3000-0xb43d3fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xb43e3000-0xb43e3fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xb7af3000-0xb8402fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xb8403000-0xb8502fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xb8503000-0xb8542fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xb93c3000-0xb9cc2fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xba000000-0xbaffffff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xbb000000-0xbeffffff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xbf000000-0xe00f7fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xe00f8000-0xe00f8fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xe00f9000-0xfed00fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed01fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xfed02000-0xffafffff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xffb00000-0xffffffff]
>> [    0.000000] e820: [mem 0xbf000000-0xe00f7fff] available for PCI devices
>> [    0.000000] Booting paravirtualized kernel on bare hardware
>> [    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
>> [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
>> [    0.000000] percpu: Embedded 226 pages/cpu s886080 r8192 d31424 u1048576
>> [    0.000000] pcpu-alloc: s886080 r8192 d31424 u1048576 alloc=1*2097152
>> [    0.000000] pcpu-alloc: [0] 0 1 [0] 2 3
>> [    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 2035190
>> [    0.000000] Policy zone: Normal
>> [    0.000000] Kernel command line: rootwait quiet     rootflags=i_version ima_tcb ima_appraise=enforce ima_appraise_tcb  nohz=off        splash plymouth.ignore-serial-consoles quiet        root=/dev/mapper/system-systema
>>
>> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
>> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
>> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
>> [    0.000000] Memory: 8008768K/8270072K available (10252K kernel code, 1185K rwdata, 3080K rodata, 2228K init, 856K bss, 261304K reserved, 0K cma-reserved)
>> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
>> [    0.000000] Kernel/User page tables isolation: enabled
>> [    0.000000] ftrace: allocating 30370 entries in 119 pages
>> [    0.000000] Preemptible hierarchical RCU implementation.
>> [    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
>> [    0.000000] 	RCU priority boosting: priority 1 delay 500 ms.
>> [    0.000000] 	No expedited grace period (rcu_normal_after_boot).
>> [    0.000000] 	Tasks RCU enabled.
>> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
>> [    0.000000] NR_IRQS: 33024, nr_irqs: 1024, preallocated irqs: 16
>> [    0.000000] Console: colour dummy device 80x25
>> [    0.000000] console [tty0] enabled
>> [    0.001000] tsc: Detected 1832.600 MHz processor
>> [    0.001000] Calibrating delay loop (skipped), value calculated using timer frequency.. 3665.20 BogoMIPS (lpj=1832600)
>> [    0.001000] pid_max: default: 32768 minimum: 301
>> [    0.001000] ACPI: Core revision 20170728
>> [    0.012153] ACPI: 5 ACPI AML tables successfully acquired and loaded
>> [    0.012232] Security Framework initialized
>> [    0.012234] Yama: becoming mindful.
>> [    0.012268] AppArmor: AppArmor initialized
>> [    0.019782] Dentry cache hash table entries: 1048576 (order: 12, 16777216 bytes)
>> [    0.027419] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
>> [    0.027539] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
>> [    0.027601] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
>> [    0.028129] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
>> [    0.028131] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
>> [    0.028143] mce: CPU supports 6 MCE banks
>> [    0.028155] process: using mwait in idle threads
>> [    0.028161] Last level iTLB entries: 4KB 48, 2MB 0, 4MB 0
>> [    0.028163] Last level dTLB entries: 4KB 128, 2MB 16, 4MB 16, 1GB 0
>> [    0.028165] Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sanitization
>> [    0.028168] Spectre V2 : Mitigation: Full generic retpoline
>> [    0.028169] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
>> [    0.028170] Spectre V2 : Enabling Restricted Speculation for firmware calls
>> [    0.028172] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
>> [    0.028174] MDS: Mitigation: Clear CPU buffers
>> [    0.028454] Freeing SMP alternatives memory: 20K
>> [    0.029967] smpboot: Max logical packages: 1
>> [    0.031000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>> [    0.040079] TSC deadline timer enabled
>> [    0.040083] smpboot: CPU0: Intel(R) Celeron(R) CPU  N2930  @ 1.83GHz (family: 0x6, model: 0x37, stepping: 0x8)
>> [    0.044040] Performance Events: PEBS fmt2+, 8-deep LBR, Silvermont events, 8-deep LBR, full-width counters, Intel PMU driver.
>> [    0.044073] ... version:                3
>> [    0.044076] ... bit width:              40
>> [    0.044079] ... generic registers:      2
>> [    0.044082] ... value mask:             000000ffffffffff
>> [    0.044085] ... max period:             0000007fffffffff
>> [    0.044088] ... fixed-purpose events:   3
>> [    0.044090] ... event mask:             0000000700000003
>> [    0.048058] Hierarchical SRCU implementation.
>> [    0.057462] NMI watchdog: Enabled. Permanently consumes one hw-PMU counter.
>> [    0.059020] smp: Bringing up secondary CPUs ...
>> [    0.070078] x86: Booting SMP configuration:
>> [    0.070084] .... node  #0, CPUs:      #1 #2 #3
>> [    0.096219] smp: Brought up 1 node, 4 CPUs
>> [    0.096219] smpboot: Total of 4 processors activated (14660.80 BogoMIPS)
>> [    0.098400] devtmpfs: initialized
>> [    0.099089] x86/mm: Memory block size: 128MB
>> [    0.104222] random: get_random_bytes called from setup_net+0x4c/0x190 with crng_init=0
>> [    0.104222] PM: Registering ACPI NVS region [mem 0x0006f000-0x0006ffff] (4096 bytes)
>> [    0.104222] PM: Registering ACPI NVS region [mem 0xb8403000-0xb8502fff] (1048576 bytes)
>> [    0.104380] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
>> [    0.104436] futex hash table entries: 1024 (order: 4, 65536 bytes)
>> [    0.104640] pinctrl core: initialized pinctrl subsystem
>> [    0.105685] NET: Registered protocol family 16
>> [    0.106519] cpuidle: using governor ladder
>> [    0.106519] ACPI: bus type PCI registered
>> [    0.106519] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>> [    0.106519] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
>> [    0.107068] PCI: not using MMCONFIG
>> [    0.107068] PCI: Using configuration type 1 for base access
>> [    0.112224] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
>> [    0.113360] ACPI: Added _OSI(Module Device)
>> [    0.113365] ACPI: Added _OSI(Processor Device)
>> [    0.113369] ACPI: Added _OSI(3.0 _SCP Extensions)
>> [    0.113372] ACPI: Added _OSI(Processor Aggregator Device)
>> [    0.128124] ACPI: Dynamic OEM Table Load:
>> [    0.128144] ACPI: SSDT 0xFFFF9B9235135400 0003BC (v01 PmRef  Cpu0Ist  00003000 INTL 20121114)
>> [    0.129424] ACPI: Dynamic OEM Table Load:
>> [    0.129440] ACPI: SSDT 0xFFFF9B92351D1E00 00015F (v01 PmRef  ApIst    00003000 INTL 20121114)
>> [    0.132388] ACPI: Interpreter enabled
>> [    0.132448] ACPI: (supports S0 S4 S5)
>> [    0.132453] ACPI: Using IOAPIC for interrupt routing
>> [    0.132555] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
>> [    0.133369] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in ACPI motherboard resources
>> [    0.133399] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
>> [    0.133992] ACPI: Enabled 4 GPEs in block 00 to 3F
>> [    0.555626] ACPI: Power Resource [USBC] (on)
>> [    0.570268] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
>> [    0.570281] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
>> [    0.570710] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
>> [    0.570739] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
>> [    0.571767] PCI host bridge to bus 0000:00
>> [    0.571774] pci_bus 0000:00: root bus resource [io  0x0000-0x006f window]
>> [    0.571779] pci_bus 0000:00: root bus resource [io  0x0078-0x0cf7 window]
>> [    0.571784] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
>> [    0.571789] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
>> [    0.571794] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff window]
>> [    0.571798] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000fffff window]
>> [    0.571803] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xd09ffffe window]
>> [    0.571810] pci_bus 0000:00: root bus resource [bus 00-ff]
>> [    0.571827] pci 0000:00:00.0: [8086:0f00] type 00 class 0x060000
>> [    0.572176] pci 0000:00:02.0: [8086:0f31] type 00 class 0x030000
>> [    0.572197] pci 0000:00:02.0: reg 0x10: [mem 0xd0000000-0xd03fffff]
>> [    0.572212] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff pref]
>> [    0.572226] pci 0000:00:02.0: reg 0x20: [io  0x7050-0x7057]
>> [    0.572251] pci 0000:00:02.0: BAR 2: assigned to efifb
>> [    0.572568] pci 0000:00:13.0: [8086:0f23] type 00 class 0x010601
>> [    0.572595] pci 0000:00:13.0: reg 0x10: [io  0x7048-0x704f]
>> [    0.572608] pci 0000:00:13.0: reg 0x14: [io  0x705c-0x705f]
>> [    0.572620] pci 0000:00:13.0: reg 0x18: [io  0x7040-0x7047]
>> [    0.572632] pci 0000:00:13.0: reg 0x1c: [io  0x7058-0x705b]
>> [    0.572644] pci 0000:00:13.0: reg 0x20: [io  0x7020-0x703f]
>> [    0.572657] pci 0000:00:13.0: reg 0x24: [mem 0xd0904000-0xd09047ff]
>> [    0.572717] pci 0000:00:13.0: PME# supported from D3hot
>> [    0.573042] pci 0000:00:1a.0: [8086:0f18] type 00 class 0x108000
>> [    0.573077] pci 0000:00:1a.0: reg 0x10: [mem 0xd0800000-0xd08fffff]
>> [    0.573094] pci 0000:00:1a.0: reg 0x14: [mem 0xd0700000-0xd07fffff]
>> [    0.573212] pci 0000:00:1a.0: PME# supported from D0 D3hot
>> [    0.573512] pci 0000:00:1b.0: [8086:0f04] type 00 class 0x040300
>> [    0.573544] pci 0000:00:1b.0: reg 0x10: [mem 0xd0900000-0xd0903fff 64bit]
>> [    0.573631] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
>> [    0.573920] pci 0000:00:1c.0: [8086:0f48] type 01 class 0x060400
>> [    0.574000] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
>> [    0.574339] pci 0000:00:1c.1: [8086:0f4a] type 01 class 0x060400
>> [    0.574422] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
>> [    0.574735] pci 0000:00:1c.2: [8086:0f4c] type 01 class 0x060400
>> [    0.574818] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
>> [    0.575155] pci 0000:00:1c.3: [8086:0f4e] type 01 class 0x060400
>> [    0.575237] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
>> [    0.575557] pci 0000:00:1d.0: [8086:0f34] type 00 class 0x0c0320
>> [    0.575593] pci 0000:00:1d.0: reg 0x10: [mem 0xd0905000-0xd09053ff]
>> [    0.575722] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
>> [    0.576051] pci 0000:00:1f.0: [8086:0f1c] type 00 class 0x060100
>> [    0.576416] pci 0000:00:1f.3: [8086:0f12] type 00 class 0x0c0500
>> [    0.576464] pci 0000:00:1f.3: reg 0x10: [mem 0xd0906000-0xd090601f]
>> [    0.576539] pci 0000:00:1f.3: reg 0x20: [io  0x7000-0x701f]
>> [    0.577084] pci 0000:01:00.0: [110a:4078] type 00 class 0x050000
>> [    0.577125] pci 0000:01:00.0: reg 0x10: [mem 0xd0600000-0xd067ffff]
>> [    0.577146] pci 0000:01:00.0: reg 0x14: [mem 0xd0680000-0xd0687fff]
>> [    0.580025] pci 0000:00:1c.0: PCI bridge to [bus 01]
>> [    0.580036] pci 0000:00:1c.0:   bridge window [mem 0xd0600000-0xd06fffff]
>> [    0.580224] pci 0000:02:00.0: [8086:1533] type 00 class 0x020000
>> [    0.580266] pci 0000:02:00.0: reg 0x10: [mem 0xd0500000-0xd057ffff]
>> [    0.580298] pci 0000:02:00.0: reg 0x18: [io  0x6000-0x601f]
>> [    0.580316] pci 0000:02:00.0: reg 0x1c: [mem 0xd0580000-0xd0583fff]
>> [    0.580463] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
>> [    0.584024] pci 0000:00:1c.1: PCI bridge to [bus 02]
>> [    0.584032] pci 0000:00:1c.1:   bridge window [io  0x6000-0x6fff]
>> [    0.584039] pci 0000:00:1c.1:   bridge window [mem 0xd0500000-0xd05fffff]
>> [    0.584220] pci 0000:03:00.0: [8086:1533] type 00 class 0x020000
>> [    0.584260] pci 0000:03:00.0: reg 0x10: [mem 0xd0400000-0xd047ffff]
>> [    0.584292] pci 0000:03:00.0: reg 0x18: [io  0x5000-0x501f]
>> [    0.584310] pci 0000:03:00.0: reg 0x1c: [mem 0xd0480000-0xd0483fff]
>> [    0.584310] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
>> [    0.587028] pci 0000:00:1c.2: PCI bridge to [bus 03]
>> [    0.587032] pci 0000:00:1c.2:   bridge window [io  0x5000-0x5fff]
>> [    0.587038] pci 0000:00:1c.2:   bridge window [mem 0xd0400000-0xd04fffff]
>> [    0.587188] pci 0000:00:1c.3: PCI bridge to [bus 04]
>> [    0.792690] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *7
>> [    0.792941] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *7
>> [    0.793184] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15) *7
>> [    0.793406] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15) *7
>> [    0.793627] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *7
>> [    0.793849] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12 14 15)
>> [    0.794099] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *10 11 12 14 15)
>> [    0.794320] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
>> [    0.795333] pci 0000:00:02.0: vgaarb: setting as boot VGA device
>> [    0.795333] pci 0000:00:02.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
>> [    0.795333] pci 0000:00:02.0: vgaarb: bridge control possible
>> [    0.795333] vgaarb: loaded
>> [    0.795333] pps_core: LinuxPPS API ver. 1 registered
>> [    0.795333] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
>> [    0.795333] PTP clock support registered
>> [    0.795333] EDAC MC: Ver: 3.0.0
>> [    0.796089] Registered efivars operations
>> [    0.796204] PCI: Using ACPI for IRQ routing
>> [    0.797938] PCI: pci_cache_line_size set to 64 bytes
>> [    0.798064] e820: reserve RAM buffer [mem 0x0006f000-0x0006ffff]
>> [    0.798072] e820: reserve RAM buffer [mem 0xb43d3018-0xb7ffffff]
>> [    0.798077] e820: reserve RAM buffer [mem 0xb7af3000-0xb7ffffff]
>> [    0.798082] e820: reserve RAM buffer [mem 0xb93c3000-0xbbffffff]
>> [    0.798088] e820: reserve RAM buffer [mem 0xba000000-0xbbffffff]
>> [    0.800595] clocksource: Switched to clocksource refined-jiffies
>> [    0.858946] VFS: Disk quotas dquot_6.6.0
>> [    0.858991] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
>> [    0.859709] AppArmor: AppArmor Filesystem Enabled
>> [    0.859779] pnp: PnP ACPI init
>> [    0.859979] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
>> [    0.860373] system 00:01: [io  0x0680-0x069f] has been reserved
>> [    0.860382] system 00:01: [io  0x0400-0x047f] has been reserved
>> [    0.860389] system 00:01: [io  0x0500-0x05fe] has been reserved
>> [    0.860407] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
>> [    0.860881] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
>> [    0.861333] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
>> [    1.064797] system 00:04: [mem 0xe0000000-0xefffffff] could not be reserved
>> [    1.064806] system 00:04: [mem 0xfed01000-0xfed01fff] has been reserved
>> [    1.064814] system 00:04: [mem 0xfed03000-0xfed03fff] has been reserved
>> [    1.064821] system 00:04: [mem 0xfed04000-0xfed04fff] has been reserved
>> [    1.064828] system 00:04: [mem 0xfed0c000-0xfed0ffff] has been reserved
>> [    1.064835] system 00:04: [mem 0xfed08000-0xfed08fff] has been reserved
>> [    1.064835] system 00:04: [mem 0xfed1c000-0xfed1cfff] has been reserved
>> [    1.064835] system 00:04: [mem 0xfed40000-0xfed44fff] has been reserved
>> [    1.064835] system 00:04: [mem 0xfee00000-0xfeefffff] has been reserved
>> [    1.064835] system 00:04: [mem 0xfef00000-0xfeffffff] has been reserved
>> [    1.064835] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
>> [    1.064835] pnp: PnP ACPI: found 5 devices
>> [    1.076608] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
>> [    1.076986] clocksource: Switched to clocksource acpi_pm
>> [    1.076986] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 01] add_size 1000
>> [    1.076986] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000 add_align 100000
>> [    1.076986] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000 add_align 100000
>> [    1.076986] pci 0000:00:1c.2: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000 add_align 100000
>> [    1.076986] pci 0000:00:1c.3: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
>> [    1.076986] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000 add_align 100000
>> [    1.076986] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff] to [bus 04] add_size 200000 add_align 100000
>> [    1.076986] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
>> [    1.076986] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
>> [    1.076986] pci 0000:00:1c.1: BAR 15: no space for [mem size 0x00200000 64bit pref]
>> [    1.076986] pci 0000:00:1c.1: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
>> [    1.076986] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x00200000 64bit pref]
>> [    1.076986] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
>> [    1.076986] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x00200000]
>> [    1.076986] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x00200000]
>> [    1.076986] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x00200000 64bit pref]
>> [    1.076986] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
>> [    1.076986] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
>> [    1.076986] pci 0000:00:1c.3: BAR 13: assigned [io  0x2000-0x2fff]
>> [    1.076986] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x00200000]
>> [    1.076986] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x00200000]
>> [    1.076986] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x00200000 64bit pref]
>> [    1.076986] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
>> [    1.076986] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x00200000 64bit pref]
>> [    1.076986] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
>> [    1.076986] pci 0000:00:1c.1: BAR 15: no space for [mem size 0x00200000 64bit pref]
>> [    1.076986] pci 0000:00:1c.1: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
>> [    1.077409] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
>> [    1.077415] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
>> [    1.077423] pci 0000:00:1c.0: PCI bridge to [bus 01]
>> [    1.077429] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
>> [    1.077437] pci 0000:00:1c.0:   bridge window [mem 0xd0600000-0xd06fffff]
>> [    1.077447] pci 0000:00:1c.1: PCI bridge to [bus 02]
>> [    1.077452] pci 0000:00:1c.1:   bridge window [io  0x6000-0x6fff]
>> [    1.077459] pci 0000:00:1c.1:   bridge window [mem 0xd0500000-0xd05fffff]
>> [    1.077469] pci 0000:00:1c.2: PCI bridge to [bus 03]
>> [    1.077474] pci 0000:00:1c.2:   bridge window [io  0x5000-0x5fff]
>> [    1.077484] pci 0000:00:1c.2:   bridge window [mem 0xd0400000-0xd04fffff]
>> [    1.077505] pci 0000:00:1c.3: PCI bridge to [bus 04]
>> [    1.077514] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
>> [    1.077528] pci_bus 0000:00: resource 4 [io  0x0000-0x006f window]
>> [    1.077533] pci_bus 0000:00: resource 5 [io  0x0078-0x0cf7 window]
>> [    1.077537] pci_bus 0000:00: resource 6 [io  0x0d00-0xffff window]
>> [    1.077542] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff window]
>> [    1.077547] pci_bus 0000:00: resource 8 [mem 0x000c0000-0x000dffff window]
>> [    1.077551] pci_bus 0000:00: resource 9 [mem 0x000e0000-0x000fffff window]
>> [    1.077556] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xd09ffffe window]
>> [    1.077560] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
>> [    1.077565] pci_bus 0000:01: resource 1 [mem 0xd0600000-0xd06fffff]
>> [    1.077570] pci_bus 0000:02: resource 0 [io  0x6000-0x6fff]
>> [    1.077575] pci_bus 0000:02: resource 1 [mem 0xd0500000-0xd05fffff]
>> [    1.077579] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
>> [    1.077584] pci_bus 0000:03: resource 1 [mem 0xd0400000-0xd04fffff]
>> [    1.077588] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
>> [    1.077841] NET: Registered protocol family 2
>> [    1.078642] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
>> [    1.081159] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
>> [    1.082450] TCP: Hash tables configured (established 65536 bind 65536)
>> [    1.082942] UDP hash table entries: 4096 (order: 7, 524288 bytes)
>> [    1.083526] UDP-Lite hash table entries: 4096 (order: 7, 524288 bytes)
>> [    1.083907] NET: Registered protocol family 1
>> [    1.083953] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
>> [    2.307105] pci 0000:00:1d.0: EHCI: BIOS handoff failed (BIOS bug?) 01010001
>> [    2.307499] PCI: CLS 64 bytes, default 64
>> [    2.307698] Unpacking initramfs...
>> [    3.863476] Freeing initrd memory: 36668K
>> [    3.863485] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
>> [    3.863491] software IO TLB: mapped [mem 0xb03d3000-0xb43d3000] (64MB)
>> [    3.863609] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x34d4ebe4b98, max_idle_ns: 881590735674 ns
>> [    3.863665] clocksource: Switched to clocksource tsc
>> [    3.864915] audit: initializing netlink subsys (disabled)
>> [    3.865083] audit: type=2000 audit(1579782171.864:1): state=initialized audit_enabled=0 res=1
>> [    3.866736] workingset: timestamp_bits=40 max_order=21 bucket_order=0
>> [    3.874245] zbud: loaded
>> [    4.765970] Key type asymmetric registered
>> [    4.765976] Asymmetric key parser 'x509' registered
>> [    4.766187] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 247)
>> [    4.766311] io scheduler noop registered
>> [    4.766316] io scheduler deadline registered
>> [    4.766340] io scheduler cfq registered (default)
>> [    4.766345] io scheduler mq-deadline registered
>> [    4.768175] efifb: probing for efifb
>> [    4.768215] efifb: framebuffer at 0xc0000000, using 3072k, total 3072k
>> [    4.768219] efifb: mode is 1024x768x32, linelength=4096, pages=1
>> [    4.768222] efifb: scrolling: redraw
>> [    4.768226] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
>> [    4.773901] Console: switching to colour frame buffer device 128x48
>> [    4.779263] fb0: EFI VGA frame buffer device
>> [    4.779297] intel_idle: MWAIT substates: 0x33000020
>> [    4.779302] intel_idle: v0.4.1 model 0x37
>> [    4.779310] intel_idle: intel_idle_state_table_update BYT 0x37 reached
>> [    4.779313] intel_idle: byt_idle_state_table_update reached
>> [    4.779317] intel_idle: state C6N is disabled
>> [    4.779320] intel_idle: state C6S is disabled
>> [    4.779323] intel_idle: state C7 is disabled
>> [    4.779326] intel_idle: state C7S is disabled
>> [    4.779674] intel_idle: lapic_timer_reliable_states 0xffffffff
>> [    4.789625] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>> [    4.789809] 00:02: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a TI16750
>> [    4.790140] 00:03: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a TI16750
>> [    4.791434] Linux agpgart interface v0.103
>> [    4.807830] tpm_tis MSFT0101:00: 2.0 TPM (device-id 0x1A, rev-id 16)
>> [    5.225802] AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
>> [    5.225807] AMD IOMMUv2 functionality not available on this system
>> [    5.235438] loop: module loaded
>> [    5.235637] i8042: PNP: No PS/2 controller found.
>> [    5.235641] i8042: Probing ports directly.
>> [    5.236512] serio: i8042 KBD port at 0x60,0x64 irq 1
>> [    5.236656] serio: i8042 AUX port at 0x60,0x64 irq 12
>> [    5.237091] mousedev: PS/2 mouse device common for all mice
>> [    5.237433] rtc_cmos 00:00: RTC can wake from S4
>> [    5.237785] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
>> [    5.237911] rtc_cmos 00:00: alarms up to one month, y3k, 242 bytes nvram
>> [    5.237948] intel_pstate: Intel P-state driver initializing
>> [    5.240962] pmc_atom: SIMATIC IPC227E critclks quirk enabled
>> [    5.244166] NET: Registered protocol family 10
>> [    5.267172] Segment Routing with IPv6
>> [    5.267238] mip6: Mobile IPv6
>> [    5.267248] NET: Registered protocol family 17
>> [    5.267266] mpls_gso: MPLS GSO support
>> [    5.268247] microcode: sig=0x30678, pf=0x8, revision=0x838
>> [    5.268482] microcode: Microcode Update Driver: v2.2.
>> [    5.268526] sched_clock: Marking stable (5268463229, 0)->(5284772362, -16309133)
>> [    5.269207] registered taskstats version 1
>> [    5.269326] zswap: loaded using pool lzo/zbud
>> [    5.269465] AppArmor: AppArmor sha1 policy hashing enabled
>> [    5.290880] ima: Allocated hash algorithm: sha256
>> [    5.483333] rtc_cmos 00:00: setting system clock to 2020-01-23 12:22:54 UTC (1579782174)
>> [    5.497555] Freeing unused kernel memory: 2228K
>> [    5.497566] Write protecting the kernel read-only data: 16384k
>> [    5.501268] Freeing unused kernel memory: 2024K
>> [    5.506952] Freeing unused kernel memory: 1016K
>> [    5.517886] x86/mm: Checked W+X mappings: passed, no W+X pages found.
>> [    5.517890] x86/mm: Checking user space page tables
>> [    5.528533] x86/mm: Checked W+X mappings: passed, no W+X pages found.
>> [    7.264890] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
>> [    7.280245] ACPI: Sleep Button [SLPB]
>> [    7.313607] SCSI subsystem initialized
>> [    7.333157] ACPI: bus type USB registered
>> [    7.342823] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
>> [    7.347944] usbcore: registered new interface driver usbfs
>> [    7.352374] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
>> [    7.353696] usbcore: registered new interface driver hub
>> [    7.354498] usbcore: registered new device driver usb
>> [    7.356061] ACPI: Power Button [PWRF]
>> [    7.377690] libata version 3.00 loaded.
>> [    7.414682] dca service started, version 1.12.1
>> [    7.438308] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
>> [    7.571896] ehci-pci: EHCI PCI platform driver
>> [    7.572361] ehci-pci 0000:00:1d.0: EHCI Host Controller
>> [    7.572379] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 1
>> [    7.572400] ehci-pci 0000:00:1d.0: debug port 2
>> [    7.573535] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.4.0-k
>> [    7.573539] igb: Copyright (c) 2007-2014 Intel Corporation.
>> [    7.576346] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
>> [    7.576523] ehci-pci 0000:00:1d.0: irq 20, io mem 0xd0905000
>> [    7.584162] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
>> [    7.584413] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
>> [    7.584420] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    7.584426] usb usb1: Product: EHCI Host Controller
>> [    7.584432] usb usb1: Manufacturer: Linux 4.14.139-rt66 ehci_hcd
>> [    7.584437] usb usb1: SerialNumber: 0000:00:1d.0
>> [    7.585192] hub 1-0:1.0: USB hub found
>> [    7.585226] hub 1-0:1.0: 8 ports detected
>> [    7.590495] [drm] Memory usable by graphics device = 2048M
>> [    7.590511] checking generic (c0000000 300000) vs hw (c0000000 10000000)
>> [    7.590521] fb: switching to inteldrmfb from EFI VGA
>> [    7.590631] Console: switching to colour dummy device 80x25
>> [    7.591813] [drm] Replacing VGA console driver
>> [    7.592829] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
>> [    7.592838] [drm] Driver supports precise vblank timestamp query.
>> [    7.596552] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=io+mem
>> [    7.603431] [drm] Initialized i915 1.6.0 20170818 for 0000:00:02.0 on minor 0
>> [    7.606166] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
>> [    7.606919] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
>> [    7.607395] ahci 0000:00:13.0: version 3.0
>> [    7.607857] ahci 0000:00:13.0: controller can't do DEVSLP, turning off
>> [    7.618697] ahci 0000:00:13.0: AHCI 0001.0300 32 slots 2 ports 3 Gbps 0x1 impl SATA mode
>> [    7.618708] ahci 0000:00:13.0: flags: 64bit ncq led clo pio slum part deso
>> [    7.620442] scsi host0: ahci
>> [    7.621120] scsi host1: ahci
>> [    7.621433] ata1: SATA max UDMA/133 abar m2048@0xd0904000 port 0xd0904100 irq 88
>> [    7.621439] ata2: DUMMY
>> [    7.728937] fbcon: inteldrmfb (fb0) is primary device
>> [    7.784490] Console: switching to colour frame buffer device 240x67
>> [    7.809697] pps pps0: new PPS source ptp0
>> [    7.809705] igb 0000:02:00.0: added PHC on eth0
>> [    7.809709] igb 0000:02:00.0: Intel(R) Gigabit Ethernet Network Connection
>> [    7.809714] igb 0000:02:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 20:87:56:31:c5:0c
>> [    7.809758] igb 0000:02:00.0: eth0: PBA No: 000300-000
>> [    7.809762] igb 0000:02:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
>> [    7.826702] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
>> [    7.905112] usb 1-1: new high-speed USB device number 2 using ehci-pci
>> [    7.934247] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    7.935785] ata1.00: ATA-10: Micron_5100_MTFDDAK240TCB,  D0MU037, max UDMA/133
>> [    7.935791] ata1.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>> [    7.937914] ata1.00: configured for UDMA/133
>> [    7.938270] scsi 0:0:0:0: Direct-Access     ATA      Micron_5100_MTFD U037 PQ: 0 ANSI: 5
>> [    7.974092] ata1.00: Enabling discard_zeroes_data
>> [    7.974560] sd 0:0:0:0: [sda] 468862128 512-byte logical blocks: (240 GB/224 GiB)
>> [    7.974564] sd 0:0:0:0: [sda] 4096-byte physical blocks
>> [    7.974605] sd 0:0:0:0: [sda] Write Protect is off
>> [    7.974608] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>> [    7.974680] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    7.975140] ata1.00: Enabling discard_zeroes_data
>> [    7.977983]  sda: sda1 sda2 sda3 sda4
>> [    7.978984] ata1.00: Enabling discard_zeroes_data
>> [    7.979510] sd 0:0:0:0: [sda] Attached SCSI disk
>> [    8.033403] usb 1-1: New USB device found, idVendor=8087, idProduct=07e6
>> [    8.033411] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>> [    8.038203] hub 1-1:1.0: USB hub found
>> [    8.038280] hub 1-1:1.0: 4 ports detected
>> [    8.050401] pps pps1: new PPS source ptp1
>> [    8.050408] igb 0000:03:00.0: added PHC on eth1
>> [    8.050412] igb 0000:03:00.0: Intel(R) Gigabit Ethernet Network Connection
>> [    8.050416] igb 0000:03:00.0: eth1: (PCIe:2.5Gb/s:Width x1) 20:87:56:31:c5:06
>> [    8.050460] igb 0000:03:00.0: eth1: PBA No: 000300-000
>> [    8.050464] igb 0000:03:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
>> [    8.067473] igb 0000:02:00.0 enp2s0: renamed from eth0
>> [    8.074248] igb 0000:03:00.0 enp3s0: renamed from eth1
>> [    8.311138] usb 1-1.2: new high-speed USB device number 3 using ehci-pci
>> [    8.345283] random: lvm: uninitialized urandom read (4 bytes read)
>> [    8.390544] usb 1-1.2: New USB device found, idVendor=0424, idProduct=2514
>> [    8.390552] usb 1-1.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>> [    8.391047] hub 1-1.2:1.0: USB hub found
>> [    8.391166] hub 1-1.2:1.0: 4 ports detected
>> [    8.421224] device-mapper: uevent: version 1.0.3
>> [    8.421963] device-mapper: ioctl: 4.37.0-ioctl (2017-09-20) initialised: dm-devel@redhat.com
>> [    8.456089] usb 1-1.3: new low-speed USB device number 4 using ehci-pci
>> [    8.471697] random: lvm: uninitialized urandom read (2 bytes read)
>> [    8.539867] usb 1-1.3: New USB device found, idVendor=413c, idProduct=301a
>> [    8.539873] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>> [    8.539878] usb 1-1.3: Product: Dell MS116 USB Optical Mouse
>> [    8.539881] usb 1-1.3: Manufacturer: PixArt
>> [    8.567534] hidraw: raw HID events driver (C) Jiri Kosina
>> [    8.591691] usbcore: registered new interface driver usbhid
>> [    8.591698] usbhid: USB HID core driver
>> [    8.606085] usb 1-1.4: new low-speed USB device number 5 using ehci-pci
>> [    8.625980] input: PixArt Dell MS116 USB Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1.3/1-1.3:1.0/0003:413C:301A.0001/input/input6
>> [    8.626720] hid-generic 0003:413C:301A.0001: input,hidraw0: USB HID v1.11 Mouse [PixArt Dell MS116 USB Optical Mouse] on usb-0000:00:1d.0-1.3/input0
>> [    8.692570] usb 1-1.4: New USB device found, idVendor=413c, idProduct=2113
>> [    8.692585] usb 1-1.4: New USB device strings: Mfr=0, Product=2, SerialNumber=0
>> [    8.692594] usb 1-1.4: Product: Dell KB216 Wired Keyboard
>> [    8.699556] input: Dell KB216 Wired Keyboard as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1.4/1-1.4:1.0/0003:413C:2113.0002/input/input7
>> [    8.752456] hid-generic 0003:413C:2113.0002: input,hidraw1: USB HID v1.11 Keyboard [Dell KB216 Wired Keyboard] on usb-0000:00:1d.0-1.4/input0
>> [    8.760277] input: Dell KB216 Wired Keyboard as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1.4/1-1.4:1.1/0003:413C:2113.0003/input/input8
>> [    8.763063] usb 1-1.2.4: new high-speed USB device number 6 using ehci-pci
>> [    8.812510] hid-generic 0003:413C:2113.0003: input,hidraw2: USB HID v1.11 Device [Dell KB216 Wired Keyboard] on usb-0000:00:1d.0-1.4/input1
>> [    8.857158] usb 1-1.2.4: New USB device found, idVendor=0781, idProduct=5581
>> [    8.857177] usb 1-1.2.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>> [    8.857190] usb 1-1.2.4: Product: Ultra
>> [    8.857201] usb 1-1.2.4: Manufacturer: SanDisk
>> [    8.857213] usb 1-1.2.4: SerialNumber: 04018812802fe8c3affb6e4ff14c9072616e7bdcf156e4641ccc688d0ccd13340aa400000000000000000000c1ca173b001a0818815581079d275241
>> [    8.904607] usb-storage 1-1.2.4:1.0: USB Mass Storage device detected
>> [    8.905482] scsi host2: usb-storage 1-1.2.4:1.0
>> [    8.906380] usbcore: registered new interface driver usb-storage
>> [    8.937344] usbcore: registered new interface driver uas
>> [    9.953369] scsi 2:0:0:0: Direct-Access     SanDisk  Ultra            1.00 PQ: 0 ANSI: 6
>> [    9.957618] sd 2:0:0:0: [sdb] 120176640 512-byte logical blocks: (61.5 GB/57.3 GiB)
>> [    9.959602] sd 2:0:0:0: [sdb] Write Protect is off
>> [    9.959607] sd 2:0:0:0: [sdb] Mode Sense: 43 00 00 00
>> [    9.960718] sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
>> [    9.977778] GPT:Primary header thinks Alt. header is not at the end of the disk.
>> [    9.977789] GPT:14877681 != 120176639
>> [    9.977794] GPT:Alternate GPT header not at the end of the disk.
>> [    9.977800] GPT:14877681 != 120176639
>> [    9.977804] GPT: Use GNU Parted to correct GPT errors.
>> [    9.977852]  sdb: sdb1 sdb2
>> [    9.983397] sd 2:0:0:0: [sdb] Attached SCSI removable disk
>> [   14.708900] NET: Registered protocol family 38
>> [   17.482198] random: cryptsetup: uninitialized urandom read (2 bytes read)
>> [   25.648558] random: cryptsetup: uninitialized urandom read (2 bytes read)
>> [   33.739683] random: cryptsetup: uninitialized urandom read (2 bytes read)
>> [   41.853499] random: cryptsetup: uninitialized urandom read (2 bytes read)
>> [   44.892110] random: lvm: uninitialized urandom read (4 bytes read)
>> [   45.636922] EXT4-fs (dm-5): mounted filesystem with ordered data mode. Opts: i_version
>> [   46.119594] EXT4-fs: Warning: mounting with data=journal disables delayed allocation and O_DIRECT support!
>> [   46.122171] EXT4-fs (dm-7): mounted filesystem with journalled data mode. Opts: data=journal
>> [   47.457269] audit: type=1805 audit(1579782216.472:2): action="dont_appraise" fsmagic="0x9fa0" res=1
>> [   47.457285] audit: type=1805 audit(1579782216.472:3): action="dont_appraise" fsmagic="0x62656572" res=1
>> [   47.457296] audit: type=1805 audit(1579782216.472:4): action="dont_appraise" fsmagic="0x64626720" res=1
>> [   47.457305] audit: type=1805 audit(1579782216.472:5): action="dont_appraise" fsmagic="0x1021994" res=1
>> [   47.457317] audit: type=1805 audit(1579782216.472:6): action="dont_appraise" fsmagic="0x858458f6" res=1
>> [   47.457329] audit: type=1805 audit(1579782216.472:7): action="dont_appraise" fsmagic="0x1cd1" res=1
>> [   47.457367] audit: type=1805 audit(1579782216.472:8): action="dont_appraise" fsmagic="0x42494e4d" res=1
>> [   47.457378] audit: type=1805 audit(1579782216.472:9): action="dont_appraise" fsmagic="0x73636673" res=1
>> [   47.457388] audit: type=1805 audit(1579782216.472:10): action="dont_appraise" fsmagic="0xf97cff8c" res=1
>> [   47.457424] audit: type=1805 audit(1579782216.472:11): action="dont_appraise" fsmagic="0x43415d53" res=1
>> [   47.457580] systemd[1]: Successfully loaded the IMA custom policy /etc/ima/ima-policy.
>> [   47.457603] IMA: policy update completed
>> [   47.534320] ip_tables: (C) 2000-2006 Netfilter Core Team
>> [   47.595810] systemd[1]: systemd 241 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN -PCRE2 default-hierarchy=hybrid)
>> [   47.609184] systemd[1]: Detected architecture x86-64.
>> [   47.617495] systemd[1]: Set hostname to <localhost.localdomain>.
>> [   47.619885] systemd[1]: Failed to bump fs.file-max, ignoring: Invalid argument
>> [   47.954124] systemd[1]: /run/systemd/generator.late/squid.service:21: PIDFile= references path below legacy directory /var/run/, updating /var/run/squid.pid → /run/squid.pid; please update the unit file accordingly.
>> [   47.959208] systemd[1]: Listening on fsck to fsckd communication Socket.
>> [   47.960291] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
>> [   47.962620] systemd[1]: Created slice User and Session Slice.
>> [   47.962666] systemd[1]: Reached target Slices.
>> [   47.962735] systemd[1]: Reached target Swap.
>> [   48.105328] random: lvm: uninitialized urandom read (4 bytes read)
>> [   48.163805] Non-volatile memory driver v1.3
>> [   48.295496] random: systemd-random-: uninitialized urandom read (512 bytes read)
>> [   49.042161] systemd-journald[501]: Received request to flush runtime journal from PID 1
>> [   49.449539] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
>> [   49.750708] iTCO_vendor_support: vendor-support=0
>> [   49.792209] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
>> [   49.795400] iTCO_wdt: Found a Bay Trail SoC TCO device (Version=3, TCOBASE=0x0460)
>> [   49.800408] input: PC Speaker as /devices/platform/pcspkr/input/input9
>> [   49.831550] sd 0:0:0:0: Attached scsi generic sg0 type 0
>> [   49.838335] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
>> [   49.854453] sd 2:0:0:0: Attached scsi generic sg1 type 0
>> [   49.992642] snd_hda_intel 0000:00:1b.0: bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
>> [   50.000803] igb 0000:02:00.0 factorylan0: renamed from enp2s0
>> [   50.010276] igb 0000:03:00.0 machinelan0: renamed from enp3s0
>> [   50.362232] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
>> [   50.425199] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
>> [   50.538093] (NULL device *): hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
>> [   50.581117] (NULL device *): hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
>> [   50.646200] random: lvm: uninitialized urandom read (4 bytes read)
>> [   50.721210] intel_rapl: Found RAPL domain package
>> [   50.721217] intel_rapl: Found RAPL domain core
>> [   52.216273] EXT4-fs (dm-6): mounted filesystem with journalled data mode. Opts: data=journal
>> [   52.294842] EXT4-fs (dm-8): mounted filesystem with journalled data mode. Opts: data=journal
>> [   56.369802] IPv6: ADDRCONF(NETDEV_UP): factorylan0: link is not ready
>> [   56.425587] IPv6: ADDRCONF(NETDEV_UP): factorylan0: link is not ready
>> [   56.438514] IPv6: ADDRCONF(NETDEV_UP): machinelan0: link is not ready
>> [   56.491600] IPv6: ADDRCONF(NETDEV_UP): machinelan0: link is not ready
>> [   56.932663] [drm:intel_cpu_fifo_underrun_irq_handler [i915]] *ERROR* CPU pipe A FIFO underrun
>> [   59.569636] igb 0000:03:00.0 machinelan0: igb: machinelan0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
>> [   59.671360] IPv6: ADDRCONF(NETDEV_CHANGE): machinelan0: link becomes ready
>> [   67.803769] bridge: filtering via arp/ip/ip6tables is no longer available by default. Update your scripts to load br_netfilter if you need this.
>> [   67.808889] Bridge firewalling registered
>> [   67.836843] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
>> [   68.088408] Initializing XFRM netlink socket
>> [   68.103161] Netfilter messages via NETLINK v0.30.
>> [   68.109737] ctnetlink v0.93: registering with nfnetlink.
>> [   68.353599] IPv6: ADDRCONF(NETDEV_UP): docker0: link is not ready
>> root@localhost:#
>> root@localhost:# dmesg | grep tsc
>> [    0.001000] tsc: Detected 1832.600 MHz processor
>> [    3.863609] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x34d4ebe4b98, max_idle_ns: 881590735674 ns
>> [    3.863665] clocksource: Switched to clocksource tsc
>>
> 
>> root@localhost# dmesg
>> [    0.000000] microcode: microcode updated early to revision 0x838, date = 2019-04-22
>> [    0.000000] Linux version 4.14.139-rt66 (builder@vipul) (gcc version 6.3.0 20170516 (Debian 6.3.0-18+deb9u1)) #1 SMP PREEMPT RT Mon Jan 20 07:36:20 UTC 2020
>> [    0.000000] Command line: rootwait quiet     rootflags=i_version ima_tcb ima_appraise=enforce ima_appraise_tcb  nohz=off        splash plymouth.ignore-serial-consoles quiet        root=/dev/mapper/system-systema
>>
>> [    0.000000] x86/fpu: x87 FPU will use FXSAVE
>> [    0.000000] e820: BIOS-provided physical RAM map:
>> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000006efff] usable
>> [    0.000000] BIOS-e820: [mem 0x000000000006f000-0x000000000006ffff] ACPI NVS
>> [    0.000000] BIOS-e820: [mem 0x0000000000070000-0x000000000008ffff] usable
>> [    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009ffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000b7af2fff] usable
>> [    0.000000] BIOS-e820: [mem 0x00000000b7af3000-0x00000000b8402fff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000b8403000-0x00000000b8502fff] ACPI NVS
>> [    0.000000] BIOS-e820: [mem 0x00000000b8503000-0x00000000b8542fff] ACPI data
>> [    0.000000] BIOS-e820: [mem 0x00000000b8543000-0x00000000b93c2fff] usable
>> [    0.000000] BIOS-e820: [mem 0x00000000b93c3000-0x00000000b9cc2fff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000b9cc3000-0x00000000b9ffffff] usable
>> [    0.000000] BIOS-e820: [mem 0x00000000e00f8000-0x00000000e00f8fff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000fed01000-0x00000000fed01fff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000ffb00000-0x00000000ffffffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023fffffff] usable
>> [    0.000000] NX (Execute Disable) protection: active
>> [    0.000000] e820: update [mem 0xb43d3018-0xb43e3057] usable ==> usable
>> [    0.000000] e820: update [mem 0xb43d3018-0xb43e3057] usable ==> usable
>> [    0.000000] extended physical RAM map:
>> [    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000006efff] usable
>> [    0.000000] reserve setup_data: [mem 0x000000000006f000-0x000000000006ffff] ACPI NVS
>> [    0.000000] reserve setup_data: [mem 0x0000000000070000-0x000000000008ffff] usable
>> [    0.000000] reserve setup_data: [mem 0x0000000000090000-0x000000000009ffff] reserved
>> [    0.000000] reserve setup_data: [mem 0x0000000000100000-0x00000000b43d3017] usable
>> [    0.000000] reserve setup_data: [mem 0x00000000b43d3018-0x00000000b43e3057] usable
>> [    0.000000] reserve setup_data: [mem 0x00000000b43e3058-0x00000000b7af2fff] usable
>> [    0.000000] reserve setup_data: [mem 0x00000000b7af3000-0x00000000b8402fff] reserved
>> [    0.000000] reserve setup_data: [mem 0x00000000b8403000-0x00000000b8502fff] ACPI NVS
>> [    0.000000] reserve setup_data: [mem 0x00000000b8503000-0x00000000b8542fff] ACPI data
>> [    0.000000] reserve setup_data: [mem 0x00000000b8543000-0x00000000b93c2fff] usable
>> [    0.000000] reserve setup_data: [mem 0x00000000b93c3000-0x00000000b9cc2fff] reserved
>> [    0.000000] reserve setup_data: [mem 0x00000000b9cc3000-0x00000000b9ffffff] usable
>> [    0.000000] reserve setup_data: [mem 0x00000000e00f8000-0x00000000e00f8fff] reserved
>> [    0.000000] reserve setup_data: [mem 0x00000000fed01000-0x00000000fed01fff] reserved
>> [    0.000000] reserve setup_data: [mem 0x00000000ffb00000-0x00000000ffffffff] reserved
>> [    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000023fffffff] usable
>> [    0.000000] efi: EFI v2.40 by INSYDE Corp.
>> [    0.000000] efi:  ACPI 2.0=0xb8542014  ESRT=0xb7be2d18  SMBIOS=0xb7dfa000
>> [    0.000000] SMBIOS 2.7 present.
>> [    0.000000] DMI: SIEMENS AG SIMATIC IPC227E/A5E38155677, BIOS V20.01.12 04/05/2019
>> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
>> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
>> [    0.000000] e820: last_pfn = 0x240000 max_arch_pfn = 0x400000000
>> [    0.000000] MTRR default type: uncachable
>> [    0.000000] MTRR fixed ranges enabled:
>> [    0.000000]   00000-9FFFF write-back
>> [    0.000000]   A0000-BFFFF uncachable
>> [    0.000000]   C0000-FFFFF write-protect
>> [    0.000000] MTRR variable ranges enabled:
>> [    0.000000]   0 base 0FF800000 mask FFF800000 write-protect
>> [    0.000000]   1 base 000000000 mask F80000000 write-back
>> [    0.000000]   2 base 080000000 mask FC0000000 write-back
>> [    0.000000]   3 base 0BC000000 mask FFC000000 uncachable
>> [    0.000000]   4 base 0BB000000 mask FFF000000 uncachable
>> [    0.000000]   5 base 0BAE00000 mask FFFE00000 uncachable
>> [    0.000000]   6 base 100000000 mask F00000000 write-back
>> [    0.000000]   7 base 200000000 mask FC0000000 write-back
>> [    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT
>> [    0.000000] e820: last_pfn = 0xba000 max_arch_pfn = 0x400000000
>> [    0.000000] Base memory trampoline at [ffff9a110008a000] 8a000 size 24576
>> [    0.000000] BRK [0xa4118000, 0xa4118fff] PGTABLE
>> [    0.000000] BRK [0xa4119000, 0xa4119fff] PGTABLE
>> [    0.000000] BRK [0xa411a000, 0xa411afff] PGTABLE
>> [    0.000000] BRK [0xa411b000, 0xa411bfff] PGTABLE
>> [    0.000000] BRK [0xa411c000, 0xa411cfff] PGTABLE
>> [    0.000000] BRK [0xa411d000, 0xa411dfff] PGTABLE
>> [    0.000000] BRK [0xa411e000, 0xa411efff] PGTABLE
>> [    0.000000] BRK [0xa411f000, 0xa411ffff] PGTABLE
>> [    0.000000] BRK [0xa4120000, 0xa4120fff] PGTABLE
>> [    0.000000] BRK [0xa4121000, 0xa4121fff] PGTABLE
>> [    0.000000] BRK [0xa4122000, 0xa4122fff] PGTABLE
>> [    0.000000] BRK [0xa4123000, 0xa4123fff] PGTABLE
>> [    0.000000] Secure boot could not be determined
>> [    0.000000] RAMDISK: [mem 0xadc30000-0xafffffff]
>> [    0.000000] ACPI: Early table checksum verification disabled
>> [    0.000000] ACPI: RSDP 0x00000000B8542014 000024 (v02 SIEMEN)
>> [    0.000000] ACPI: XSDT 0x00000000B8542120 00009C (v01 SIEMEN SIMATIC  11112222      01000013)
>> [    0.000000] ACPI: FACP 0x00000000B853B000 00010C (v05 SIEMEN SIMATIC  11112222 WAS_ 00010001)
>> [    0.000000] ACPI: DSDT 0x00000000B8530000 006A5B (v02 SIEMEN SIMATIC  11112222 WAS_ 00010001)
>> [    0.000000] ACPI: FACS 0x00000000B84AA000 000040
>> [    0.000000] ACPI: UEFI 0x00000000B8541000 000236 (v01 SIEMEN SIMATIC  00000001 WAS_ 12345678)
>> [    0.000000] ACPI: TCPA 0x00000000B8540000 000032 (v02 SIEMEN SIMATIC  00000000 WAS_ 00000000)
>> [    0.000000] ACPI: UEFI 0x00000000B853E000 000042 (v01 SIEMEN SIMATIC  00000000 WAS_ 00000000)
>> [    0.000000] ACPI: SSDT 0x00000000B853D000 0004FD (v01 SIEMEN TPMACPI  00001000 WAS_ 20121114)
>> [    0.000000] ACPI: TPM2 0x00000000B853C000 000034 (v03 SIEMEN SIMATIC  00000000 WAS_ 00000000)
>> [    0.000000] ACPI: HPET 0x00000000B853A000 000038 (v01 SIEMEN SIMATIC  11112222 WAS_ 00010001)
>> [    0.000000] ACPI: LPIT 0x00000000B8539000 000104 (v01 SIEMEN SIMATIC  11112222 WAS_ 00010001)
>> [    0.000000] ACPI: APIC 0x00000000B8538000 000084 (v03 SIEMEN SIMATIC  11112222 WAS_ 00010001)
>> [    0.000000] ACPI: MCFG 0x00000000B8537000 00003C (v01 SIEMEN SIMATIC  11112222 WAS_ 00010001)
>> [    0.000000] ACPI: SSDT 0x00000000B852E000 000763 (v01 SIEMEN CpuPm    00003000 WAS_ 20121114)
>> [    0.000000] ACPI: SSDT 0x00000000B852D000 000290 (v01 SIEMEN Cpu0Tst  00003000 WAS_ 20121114)
>> [    0.000000] ACPI: SSDT 0x00000000B852C000 00017A (v01 SIEMEN ApTst    00003000 WAS_ 20121114)
>> [    0.000000] ACPI: FPDT 0x00000000B852B000 000044 (v01 SIEMEN SIMATIC  00000002 WAS_ 01000013)
>> [    0.000000] ACPI: BGRT 0x00000000B852F000 000038 (v01 SIEMEN SIMATIC  00000001 WAS_ 12345678)
>> [    0.000000] ACPI: Local APIC address 0xfee00000
>> [    0.000000] No NUMA configuration found
>> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000023fffffff]
>> [    0.000000] NODE_DATA(0) allocated [mem 0x23fff8000-0x23fffcfff]
>> [    0.000000] Zone ranges:
>> [    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
>> [    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
>> [    0.000000]   Normal   [mem 0x0000000100000000-0x000000023fffffff]
>> [    0.000000]   Device   empty
>> [    0.000000] Movable zone start for each node
>> [    0.000000] Early memory node ranges
>> [    0.000000]   node   0: [mem 0x0000000000001000-0x000000000006efff]
>> [    0.000000]   node   0: [mem 0x0000000000070000-0x000000000008ffff]
>> [    0.000000]   node   0: [mem 0x0000000000100000-0x00000000b7af2fff]
>> [    0.000000]   node   0: [mem 0x00000000b8543000-0x00000000b93c2fff]
>> [    0.000000]   node   0: [mem 0x00000000b9cc3000-0x00000000b9ffffff]
>> [    0.000000]   node   0: [mem 0x0000000100000000-0x000000023fffffff]
>> [    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000023fffffff]
>> [    0.000000] On node 0 totalpages: 2067518
>> [    0.000000]   DMA zone: 64 pages used for memmap
>> [    0.000000]   DMA zone: 21 pages reserved
>> [    0.000000]   DMA zone: 3982 pages, LIFO batch:0
>> [    0.000000]   DMA32 zone: 11763 pages used for memmap
>> [    0.000000]   DMA32 zone: 752816 pages, LIFO batch:31
>> [    0.000000]   Normal zone: 20480 pages used for memmap
>> [    0.000000]   Normal zone: 1310720 pages, LIFO batch:31
>> [    0.000000] x86/hpet: Will disable the HPET for this platform because it's not reliable
>> [    0.000000] Reserving Intel graphics memory at 0x00000000bb000000-0x00000000beffffff
>> [    0.000000] ACPI: PM-Timer IO Port: 0x408
>> [    0.000000] ACPI: Local APIC address 0xfee00000
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
>> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-86
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
>> [    0.000000] ACPI: IRQ0 used by override.
>> [    0.000000] ACPI: IRQ9 used by override.
>> [    0.000000] Using ACPI (MADT) for SMP configuration information
>> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
>> [    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
>> [    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0x0006f000-0x0006ffff]
>> [    0.000000] PM: Registered nosave memory: [mem 0x00090000-0x0009ffff]
>> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xb43d3000-0xb43d3fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xb43e3000-0xb43e3fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xb7af3000-0xb8402fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xb8403000-0xb8502fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xb8503000-0xb8542fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xb93c3000-0xb9cc2fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xba000000-0xbaffffff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xbb000000-0xbeffffff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xbf000000-0xe00f7fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xe00f8000-0xe00f8fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xe00f9000-0xfed00fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed01fff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xfed02000-0xffafffff]
>> [    0.000000] PM: Registered nosave memory: [mem 0xffb00000-0xffffffff]
>> [    0.000000] e820: [mem 0xbf000000-0xe00f7fff] available for PCI devices
>> [    0.000000] Booting paravirtualized kernel on bare hardware
>> [    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
>> [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
>> [    0.000000] percpu: Embedded 226 pages/cpu s886080 r8192 d31424 u1048576
>> [    0.000000] pcpu-alloc: s886080 r8192 d31424 u1048576 alloc=1*2097152
>> [    0.000000] pcpu-alloc: [0] 0 1 [0] 2 3
>> [    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 2035190
>> [    0.000000] Policy zone: Normal
>> [    0.000000] Kernel command line: rootwait quiet     rootflags=i_version ima_tcb ima_appraise=enforce ima_appraise_tcb  nohz=off        splash plymouth.ignore-serial-consoles quiet        root=/dev/mapper/system-systema
>>
>> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
>> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
>> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
>> [    0.000000] Memory: 8008768K/8270072K available (10252K kernel code, 1185K rwdata, 3080K rodata, 2228K init, 856K bss, 261304K reserved, 0K cma-reserved)
>> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
>> [    0.000000] Kernel/User page tables isolation: enabled
>> [    0.000000] ftrace: allocating 30370 entries in 119 pages
>> [    0.000000] Preemptible hierarchical RCU implementation.
>> [    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
>> [    0.000000] 	RCU priority boosting: priority 1 delay 500 ms.
>> [    0.000000] 	No expedited grace period (rcu_normal_after_boot).
>> [    0.000000] 	Tasks RCU enabled.
>> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
>> [    0.000000] NR_IRQS: 33024, nr_irqs: 1024, preallocated irqs: 16
>> [    0.000000] Console: colour dummy device 80x25
>> [    0.000000] console [tty0] enabled
>> [    0.001000] tsc: Detected 1832.600 MHz processor
>> [    0.001000] Calibrating delay loop (skipped), value calculated using timer frequency.. 3665.20 BogoMIPS (lpj=1832600)
>> [    0.001000] pid_max: default: 32768 minimum: 301
>> [    0.001000] ACPI: Core revision 20170728
>> [    0.012101] ACPI: 5 ACPI AML tables successfully acquired and loaded
>> [    0.012179] Security Framework initialized
>> [    0.012182] Yama: becoming mindful.
>> [    0.012215] AppArmor: AppArmor initialized
>> [    0.019713] Dentry cache hash table entries: 1048576 (order: 12, 16777216 bytes)
>> [    0.027394] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
>> [    0.027516] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
>> [    0.027579] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
>> [    0.028104] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
>> [    0.028105] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
>> [    0.028117] mce: CPU supports 6 MCE banks
>> [    0.028129] process: using mwait in idle threads
>> [    0.028135] Last level iTLB entries: 4KB 48, 2MB 0, 4MB 0
>> [    0.028136] Last level dTLB entries: 4KB 128, 2MB 16, 4MB 16, 1GB 0
>> [    0.028139] Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sanitization
>> [    0.028143] Spectre V2 : Mitigation: Full generic retpoline
>> [    0.028143] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
>> [    0.028145] Spectre V2 : Enabling Restricted Speculation for firmware calls
>> [    0.028147] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
>> [    0.028148] MDS: Mitigation: Clear CPU buffers
>> [    0.028427] Freeing SMP alternatives memory: 20K
>> [    0.029965] smpboot: Max logical packages: 1
>> [    0.031000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>> [    0.040077] TSC deadline timer enabled
>> [    0.040082] smpboot: CPU0: Intel(R) Celeron(R) CPU  N2930  @ 1.83GHz (family: 0x6, model: 0x37, stepping: 0x8)
>> [    0.044041] Performance Events: PEBS fmt2+, 8-deep LBR, Silvermont events, 8-deep LBR, full-width counters, Intel PMU driver.
>> [    0.044073] ... version:                3
>> [    0.044076] ... bit width:              40
>> [    0.044078] ... generic registers:      2
>> [    0.044081] ... value mask:             000000ffffffffff
>> [    0.044084] ... max period:             0000007fffffffff
>> [    0.044087] ... fixed-purpose events:   3
>> [    0.044090] ... event mask:             0000000700000003
>> [    0.048058] Hierarchical SRCU implementation.
>> [    0.057463] NMI watchdog: Enabled. Permanently consumes one hw-PMU counter.
>> [    0.059020] smp: Bringing up secondary CPUs ...
>> [    0.070076] x86: Booting SMP configuration:
>> [    0.070082] .... node  #0, CPUs:      #1 #2 #3
>> [    0.096219] smp: Brought up 1 node, 4 CPUs
>> [    0.096219] smpboot: Total of 4 processors activated (14660.80 BogoMIPS)
>> [    0.098407] devtmpfs: initialized
>> [    0.099095] x86/mm: Memory block size: 128MB
>> [    0.104223] random: get_random_bytes called from setup_net+0x4c/0x190 with crng_init=0
>> [    0.104223] PM: Registering ACPI NVS region [mem 0x0006f000-0x0006ffff] (4096 bytes)
>> [    0.104223] PM: Registering ACPI NVS region [mem 0xb8403000-0xb8502fff] (1048576 bytes)
>> [    0.104380] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
>> [    0.104437] futex hash table entries: 1024 (order: 4, 65536 bytes)
>> [    0.104641] pinctrl core: initialized pinctrl subsystem
>> [    0.105691] NET: Registered protocol family 16
>> [    0.106528] cpuidle: using governor ladder
>> [    0.106528] ACPI: bus type PCI registered
>> [    0.106528] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>> [    0.106528] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
>> [    0.107068] PCI: not using MMCONFIG
>> [    0.107068] PCI: Using configuration type 1 for base access
>> [    0.112226] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
>> [    0.114359] ACPI: Added _OSI(Module Device)
>> [    0.114364] ACPI: Added _OSI(Processor Device)
>> [    0.114368] ACPI: Added _OSI(3.0 _SCP Extensions)
>> [    0.114372] ACPI: Added _OSI(Processor Aggregator Device)
>> [    0.129992] ACPI: Dynamic OEM Table Load:
>> [    0.130029] ACPI: SSDT 0xFFFF9A13351A7800 0003BC (v01 PmRef  Cpu0Ist  00003000 INTL 20121114)
>> [    0.131292] ACPI: Dynamic OEM Table Load:
>> [    0.131308] ACPI: SSDT 0xFFFF9A1335158400 00015F (v01 PmRef  ApIst    00003000 INTL 20121114)
>> [    0.134265] ACPI: Interpreter enabled
>> [    0.134325] ACPI: (supports S0 S4 S5)
>> [    0.134331] ACPI: Using IOAPIC for interrupt routing
>> [    0.134432] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
>> [    0.135239] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in ACPI motherboard resources
>> [    0.135270] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
>> [    0.135864] ACPI: Enabled 4 GPEs in block 00 to 3F
>> [    0.556549] ACPI: Power Resource [USBC] (on)
>> [    0.571159] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
>> [    0.571172] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
>> [    0.571603] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
>> [    0.571632] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
>> [    0.572665] PCI host bridge to bus 0000:00
>> [    0.572672] pci_bus 0000:00: root bus resource [io  0x0000-0x006f window]
>> [    0.572677] pci_bus 0000:00: root bus resource [io  0x0078-0x0cf7 window]
>> [    0.572682] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
>> [    0.572687] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
>> [    0.572691] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff window]
>> [    0.572696] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000fffff window]
>> [    0.572700] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xd09ffffe window]
>> [    0.572707] pci_bus 0000:00: root bus resource [bus 00-ff]
>> [    0.572724] pci 0000:00:00.0: [8086:0f00] type 00 class 0x060000
>> [    0.573073] pci 0000:00:02.0: [8086:0f31] type 00 class 0x030000
>> [    0.573093] pci 0000:00:02.0: reg 0x10: [mem 0xd0000000-0xd03fffff]
>> [    0.573108] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff pref]
>> [    0.573122] pci 0000:00:02.0: reg 0x20: [io  0x7050-0x7057]
>> [    0.573147] pci 0000:00:02.0: BAR 2: assigned to efifb
>> [    0.573468] pci 0000:00:13.0: [8086:0f23] type 00 class 0x010601
>> [    0.573495] pci 0000:00:13.0: reg 0x10: [io  0x7048-0x704f]
>> [    0.573507] pci 0000:00:13.0: reg 0x14: [io  0x705c-0x705f]
>> [    0.573520] pci 0000:00:13.0: reg 0x18: [io  0x7040-0x7047]
>> [    0.573532] pci 0000:00:13.0: reg 0x1c: [io  0x7058-0x705b]
>> [    0.573544] pci 0000:00:13.0: reg 0x20: [io  0x7020-0x703f]
>> [    0.573556] pci 0000:00:13.0: reg 0x24: [mem 0xd0904000-0xd09047ff]
>> [    0.573616] pci 0000:00:13.0: PME# supported from D3hot
>> [    0.573918] pci 0000:00:1a.0: [8086:0f18] type 00 class 0x108000
>> [    0.573953] pci 0000:00:1a.0: reg 0x10: [mem 0xd0800000-0xd08fffff]
>> [    0.573969] pci 0000:00:1a.0: reg 0x14: [mem 0xd0700000-0xd07fffff]
>> [    0.574104] pci 0000:00:1a.0: PME# supported from D0 D3hot
>> [    0.574412] pci 0000:00:1b.0: [8086:0f04] type 00 class 0x040300
>> [    0.574444] pci 0000:00:1b.0: reg 0x10: [mem 0xd0900000-0xd0903fff 64bit]
>> [    0.574531] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
>> [    0.574821] pci 0000:00:1c.0: [8086:0f48] type 01 class 0x060400
>> [    0.574905] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
>> [    0.575237] pci 0000:00:1c.1: [8086:0f4a] type 01 class 0x060400
>> [    0.575320] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
>> [    0.575633] pci 0000:00:1c.2: [8086:0f4c] type 01 class 0x060400
>> [    0.575716] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
>> [    0.576044] pci 0000:00:1c.3: [8086:0f4e] type 01 class 0x060400
>> [    0.576127] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
>> [    0.576444] pci 0000:00:1d.0: [8086:0f34] type 00 class 0x0c0320
>> [    0.576480] pci 0000:00:1d.0: reg 0x10: [mem 0xd0905000-0xd09053ff]
>> [    0.576609] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
>> [    0.576917] pci 0000:00:1f.0: [8086:0f1c] type 00 class 0x060100
>> [    0.577295] pci 0000:00:1f.3: [8086:0f12] type 00 class 0x0c0500
>> [    0.577343] pci 0000:00:1f.3: reg 0x10: [mem 0xd0906000-0xd090601f]
>> [    0.577419] pci 0000:00:1f.3: reg 0x20: [io  0x7000-0x701f]
>> [    0.577949] pci 0000:01:00.0: [110a:4078] type 00 class 0x050000
>> [    0.577991] pci 0000:01:00.0: reg 0x10: [mem 0xd0600000-0xd067ffff]
>> [    0.578027] pci 0000:01:00.0: reg 0x14: [mem 0xd0680000-0xd0687fff]
>> [    0.581024] pci 0000:00:1c.0: PCI bridge to [bus 01]
>> [    0.581035] pci 0000:00:1c.0:   bridge window [mem 0xd0600000-0xd06fffff]
>> [    0.581217] pci 0000:02:00.0: [8086:1533] type 00 class 0x020000
>> [    0.581258] pci 0000:02:00.0: reg 0x10: [mem 0xd0500000-0xd057ffff]
>> [    0.581290] pci 0000:02:00.0: reg 0x18: [io  0x6000-0x601f]
>> [    0.581309] pci 0000:02:00.0: reg 0x1c: [mem 0xd0580000-0xd0583fff]
>> [    0.581309] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
>> [    0.584024] pci 0000:00:1c.1: PCI bridge to [bus 02]
>> [    0.584032] pci 0000:00:1c.1:   bridge window [io  0x6000-0x6fff]
>> [    0.584038] pci 0000:00:1c.1:   bridge window [mem 0xd0500000-0xd05fffff]
>> [    0.584211] pci 0000:03:00.0: [8086:1533] type 00 class 0x020000
>> [    0.584252] pci 0000:03:00.0: reg 0x10: [mem 0xd0400000-0xd047ffff]
>> [    0.584283] pci 0000:03:00.0: reg 0x18: [io  0x5000-0x501f]
>> [    0.584302] pci 0000:03:00.0: reg 0x1c: [mem 0xd0480000-0xd0483fff]
>> [    0.584447] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
>> [    0.588023] pci 0000:00:1c.2: PCI bridge to [bus 03]
>> [    0.588031] pci 0000:00:1c.2:   bridge window [io  0x5000-0x5fff]
>> [    0.588038] pci 0000:00:1c.2:   bridge window [mem 0xd0400000-0xd04fffff]
>> [    0.588187] pci 0000:00:1c.3: PCI bridge to [bus 04]
>> [    0.793195] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *7
>> [    0.793443] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *7
>> [    0.793665] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15) *7
>> [    0.793887] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15) *7
>> [    0.794134] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *7
>> [    0.794357] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12 14 15)
>> [    0.794577] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *10 11 12 14 15)
>> [    0.794797] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
>> [    0.795820] pci 0000:00:02.0: vgaarb: setting as boot VGA device
>> [    0.795820] pci 0000:00:02.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
>> [    0.795820] pci 0000:00:02.0: vgaarb: bridge control possible
>> [    0.795820] vgaarb: loaded
>> [    0.796141] pps_core: LinuxPPS API ver. 1 registered
>> [    0.796145] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
>> [    0.796156] PTP clock support registered
>> [    0.796202] EDAC MC: Ver: 3.0.0
>> [    0.796414] Registered efivars operations
>> [    0.796414] PCI: Using ACPI for IRQ routing
>> [    0.798406] PCI: pci_cache_line_size set to 64 bytes
>> [    0.798515] e820: reserve RAM buffer [mem 0x0006f000-0x0006ffff]
>> [    0.798522] e820: reserve RAM buffer [mem 0xb43d3018-0xb7ffffff]
>> [    0.798527] e820: reserve RAM buffer [mem 0xb7af3000-0xb7ffffff]
>> [    0.798532] e820: reserve RAM buffer [mem 0xb93c3000-0xbbffffff]
>> [    0.798538] e820: reserve RAM buffer [mem 0xba000000-0xbbffffff]
>> [    0.800732] clocksource: Switched to clocksource refined-jiffies
>> [    0.859223] VFS: Disk quotas dquot_6.6.0
>> [    0.859280] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
>> [    0.859949] AppArmor: AppArmor Filesystem Enabled
>> [    0.860037] pnp: PnP ACPI init
>> [    0.860239] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
>> [    0.860633] system 00:01: [io  0x0680-0x069f] has been reserved
>> [    0.860641] system 00:01: [io  0x0400-0x047f] has been reserved
>> [    0.860649] system 00:01: [io  0x0500-0x05fe] has been reserved
>> [    0.860667] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
>> [    0.861148] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
>> [    0.861570] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
>> [    1.063984] system 00:04: [mem 0xe0000000-0xefffffff] could not be reserved
>> [    1.063994] system 00:04: [mem 0xfed01000-0xfed01fff] has been reserved
>> [    1.064001] system 00:04: [mem 0xfed03000-0xfed03fff] has been reserved
>> [    1.064008] system 00:04: [mem 0xfed04000-0xfed04fff] has been reserved
>> [    1.064015] system 00:04: [mem 0xfed0c000-0xfed0ffff] has been reserved
>> [    1.064022] system 00:04: [mem 0xfed08000-0xfed08fff] has been reserved
>> [    1.064030] system 00:04: [mem 0xfed1c000-0xfed1cfff] has been reserved
>> [    1.064037] system 00:04: [mem 0xfed40000-0xfed44fff] has been reserved
>> [    1.064044] system 00:04: [mem 0xfee00000-0xfeefffff] has been reserved
>> [    1.064051] system 00:04: [mem 0xfef00000-0xfeffffff] has been reserved
>> [    1.064070] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
>> [    1.064612] pnp: PnP ACPI: found 5 devices
>> [    1.076790] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
>> [    1.076977] clocksource: Switched to clocksource acpi_pm
>> [    1.076977] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 01] add_size 1000
>> [    1.076977] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000 add_align 100000
>> [    1.076977] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000 add_align 100000
>> [    1.076977] pci 0000:00:1c.2: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000 add_align 100000
>> [    1.076977] pci 0000:00:1c.3: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
>> [    1.076977] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000 add_align 100000
>> [    1.076977] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff] to [bus 04] add_size 200000 add_align 100000
>> [    1.076977] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
>> [    1.076977] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
>> [    1.076977] pci 0000:00:1c.1: BAR 15: no space for [mem size 0x00200000 64bit pref]
>> [    1.076977] pci 0000:00:1c.1: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
>> [    1.077208] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x00200000 64bit pref]
>> [    1.077215] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
>> [    1.077229] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x00200000]
>> [    1.077234] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x00200000]
>> [    1.077256] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x00200000 64bit pref]
>> [    1.077262] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
>> [    1.077274] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
>> [    1.077285] pci 0000:00:1c.3: BAR 13: assigned [io  0x2000-0x2fff]
>> [    1.077302] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x00200000]
>> [    1.077308] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x00200000]
>> [    1.077330] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x00200000 64bit pref]
>> [    1.077335] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
>> [    1.077357] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x00200000 64bit pref]
>> [    1.077362] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
>> [    1.077384] pci 0000:00:1c.1: BAR 15: no space for [mem size 0x00200000 64bit pref]
>> [    1.077390] pci 0000:00:1c.1: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
>> [    1.077411] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
>> [    1.077417] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
>> [    1.077424] pci 0000:00:1c.0: PCI bridge to [bus 01]
>> [    1.077430] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
>> [    1.077437] pci 0000:00:1c.0:   bridge window [mem 0xd0600000-0xd06fffff]
>> [    1.077448] pci 0000:00:1c.1: PCI bridge to [bus 02]
>> [    1.077453] pci 0000:00:1c.1:   bridge window [io  0x6000-0x6fff]
>> [    1.077460] pci 0000:00:1c.1:   bridge window [mem 0xd0500000-0xd05fffff]
>> [    1.077470] pci 0000:00:1c.2: PCI bridge to [bus 03]
>> [    1.077475] pci 0000:00:1c.2:   bridge window [io  0x5000-0x5fff]
>> [    1.077482] pci 0000:00:1c.2:   bridge window [mem 0xd0400000-0xd04fffff]
>> [    1.077492] pci 0000:00:1c.3: PCI bridge to [bus 04]
>> [    1.077497] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
>> [    1.077511] pci_bus 0000:00: resource 4 [io  0x0000-0x006f window]
>> [    1.077516] pci_bus 0000:00: resource 5 [io  0x0078-0x0cf7 window]
>> [    1.077520] pci_bus 0000:00: resource 6 [io  0x0d00-0xffff window]
>> [    1.077525] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff window]
>> [    1.077530] pci_bus 0000:00: resource 8 [mem 0x000c0000-0x000dffff window]
>> [    1.077534] pci_bus 0000:00: resource 9 [mem 0x000e0000-0x000fffff window]
>> [    1.077539] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xd09ffffe window]
>> [    1.077544] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
>> [    1.077548] pci_bus 0000:01: resource 1 [mem 0xd0600000-0xd06fffff]
>> [    1.077553] pci_bus 0000:02: resource 0 [io  0x6000-0x6fff]
>> [    1.077558] pci_bus 0000:02: resource 1 [mem 0xd0500000-0xd05fffff]
>> [    1.077562] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
>> [    1.077567] pci_bus 0000:03: resource 1 [mem 0xd0400000-0xd04fffff]
>> [    1.077572] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
>> [    1.077819] NET: Registered protocol family 2
>> [    1.078615] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
>> [    1.081158] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
>> [    1.082455] TCP: Hash tables configured (established 65536 bind 65536)
>> [    1.082955] UDP hash table entries: 4096 (order: 7, 524288 bytes)
>> [    1.083530] UDP-Lite hash table entries: 4096 (order: 7, 524288 bytes)
>> [    1.083926] NET: Registered protocol family 1
>> [    1.083973] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
>> [    2.293104] pci 0000:00:1d.0: EHCI: BIOS handoff failed (BIOS bug?) 01010001
>> [    2.293507] PCI: CLS 64 bytes, default 64
>> [    2.293720] Unpacking initramfs...
>> [    3.849375] Freeing initrd memory: 36672K
>> [    3.849384] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
>> [    3.849389] software IO TLB: mapped [mem 0xb03d3000-0xb43d3000] (64MB)
>> [    3.850852] audit: initializing netlink subsys (disabled)
>> [    3.851124] audit: type=2000 audit(1579779453.850:1): state=initialized audit_enabled=0 res=1
>> [    3.852811] workingset: timestamp_bits=40 max_order=21 bucket_order=0
>> [    3.860637] zbud: loaded
>> [    4.781454] Key type asymmetric registered
>> [    4.781461] Asymmetric key parser 'x509' registered
>> [    4.781625] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 247)
>> [    4.781777] io scheduler noop registered
>> [    4.781782] io scheduler deadline registered
>> [    4.781807] io scheduler cfq registered (default)
>> [    4.781812] io scheduler mq-deadline registered
>> [    4.783771] efifb: probing for efifb
>> [    4.783810] efifb: framebuffer at 0xc0000000, using 3072k, total 3072k
>> [    4.783815] efifb: mode is 1024x768x32, linelength=4096, pages=1
>> [    4.783817] efifb: scrolling: redraw
>> [    4.783821] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
>> [    4.789833] Console: switching to colour frame buffer device 128x48
>> [    4.795515] fb0: EFI VGA frame buffer device
>> [    4.795551] intel_idle: MWAIT substates: 0x33000020
>> [    4.795555] intel_idle: v0.4.1 model 0x37
>> [    4.795563] intel_idle: intel_idle_state_table_update BYT 0x37 reached
>> [    4.795566] intel_idle: byt_idle_state_table_update reached
>> [    4.795570] intel_idle: state C6N is disabled
>> [    4.795573] intel_idle: state C6S is disabled
>> [    4.795577] intel_idle: state C7 is disabled
>> [    4.795579] intel_idle: state C7S is disabled
>> [    4.795975] intel_idle: lapic_timer_reliable_states 0xffffffff
>> [    4.806494] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>> [    4.806692] 00:02: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a TI16750
>> [    4.807130] 00:03: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a TI16750
>> [    4.808544] Linux agpgart interface v0.103
>> [    4.825212] tpm_tis MSFT0101:00: 2.0 TPM (device-id 0x1A, rev-id 16)
>> [    4.895129] tsc: Refined TSC clocksource calibration: 1833.333 MHz
>> [    4.895196] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x34da54753aa, max_idle_ns: 881590618787 ns
>> [    5.242969] AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
>> [    5.242974] AMD IOMMUv2 functionality not available on this system
>> [    5.253443] loop: module loaded
>> [    5.253643] i8042: PNP: No PS/2 controller found.
>> [    5.253647] i8042: Probing ports directly.
>> [    5.254696] serio: i8042 KBD port at 0x60,0x64 irq 1
>> [    5.254835] serio: i8042 AUX port at 0x60,0x64 irq 12
>> [    5.255359] mousedev: PS/2 mouse device common for all mice
>> [    5.255647] rtc_cmos 00:00: RTC can wake from S4
>> [    5.256165] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
>> [    5.256325] rtc_cmos 00:00: alarms up to one month, y3k, 242 bytes nvram
>> [    5.256361] intel_pstate: Intel P-state driver initializing
>> [    5.259552] pmc_atom: SIMATIC IPC227E critclks quirk enabled
>> [    5.262904] NET: Registered protocol family 10
>> [    5.288902] Segment Routing with IPv6
>> [    5.288959] mip6: Mobile IPv6
>> [    5.288968] NET: Registered protocol family 17
>> [    5.288983] mpls_gso: MPLS GSO support
>> [    5.290144] microcode: sig=0x30678, pf=0x8, revision=0x838
>> [    5.290400] microcode: Microcode Update Driver: v2.2.
>> [    5.290440] sched_clock: Marking stable (5290383624, 0)->(5307267426, -16883802)
>> [    5.291113] registered taskstats version 1
>> [    5.291208] zswap: loaded using pool lzo/zbud
>> [    5.291321] AppArmor: AppArmor sha1 policy hashing enabled
>> [    5.307572] ima: Allocated hash algorithm: sha256
>> [    5.496426] rtc_cmos 00:00: setting system clock to 2020-01-23 11:37:35 UTC (1579779455)
>> [    5.511262] Freeing unused kernel memory: 2228K
>> [    5.511270] Write protecting the kernel read-only data: 16384k
>> [    5.514988] Freeing unused kernel memory: 2024K
>> [    5.520939] Freeing unused kernel memory: 1016K
>> [    5.532218] x86/mm: Checked W+X mappings: passed, no W+X pages found.
>> [    5.532222] x86/mm: Checking user space page tables
>> [    5.543163] x86/mm: Checked W+X mappings: passed, no W+X pages found.
>> [    5.904409] clocksource: Switched to clocksource tsc
>> [    7.067537] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
>> [    7.067577] ACPI: Sleep Button [SLPB]
>> [    7.068184] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
>> [    7.072102] ACPI: Power Button [PWRF]
>> [    7.278653] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
>> [    7.278922] ACPI: bus type USB registered
>> [    7.284861] usbcore: registered new interface driver usbfs
>> [    7.292620] usbcore: registered new interface driver hub
>> [    7.295421] SCSI subsystem initialized
>> [    7.295876] usbcore: registered new device driver usb
>> [    7.298236] dca service started, version 1.12.1
>> [    7.362661] libata version 3.00 loaded.
>> [    7.385579] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.4.0-k
>> [    7.385584] igb: Copyright (c) 2007-2014 Intel Corporation.
>> [    7.401118] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
>> [    7.510462] ehci-pci: EHCI PCI platform driver
>> [    7.510946] ehci-pci 0000:00:1d.0: EHCI Host Controller
>> [    7.510961] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 1
>> [    7.510982] ehci-pci 0000:00:1d.0: debug port 2
>> [    7.514993] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
>> [    7.515453] ehci-pci 0000:00:1d.0: irq 20, io mem 0xd0905000
>> [    7.522131] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
>> [    7.522512] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
>> [    7.522522] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    7.522529] usb usb1: Product: EHCI Host Controller
>> [    7.522535] usb usb1: Manufacturer: Linux 4.14.139-rt66 ehci_hcd
>> [    7.522541] usb usb1: SerialNumber: 0000:00:1d.0
>> [    7.523380] hub 1-0:1.0: USB hub found
>> [    7.523422] hub 1-0:1.0: 8 ports detected
>> [    7.527906] [drm] Memory usable by graphics device = 2048M
>> [    7.527913] checking generic (c0000000 300000) vs hw (c0000000 10000000)
>> [    7.527917] fb: switching to inteldrmfb from EFI VGA
>> [    7.527970] Console: switching to colour dummy device 80x25
>> [    7.528620] [drm] Replacing VGA console driver
>> [    7.529224] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
>> [    7.529227] [drm] Driver supports precise vblank timestamp query.
>> [    7.530713] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=io+mem
>> [    7.539108] [drm] Initialized i915 1.6.0 20170818 for 0000:00:02.0 on minor 0
>> [    7.542442] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
>> [    7.543159] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
>> [    7.543504] ahci 0000:00:13.0: version 3.0
>> [    7.544866] ahci 0000:00:13.0: controller can't do DEVSLP, turning off
>> [    7.555182] ahci 0000:00:13.0: AHCI 0001.0300 32 slots 2 ports 3 Gbps 0x1 impl SATA mode
>> [    7.555193] ahci 0000:00:13.0: flags: 64bit ncq led clo pio slum part deso
>> [    7.556960] scsi host0: ahci
>> [    7.557620] scsi host1: ahci
>> [    7.557929] ata1: SATA max UDMA/133 abar m2048@0xd0904000 port 0xd0904100 irq 88
>> [    7.557935] ata2: DUMMY
>> [    7.624548] pps pps0: new PPS source ptp0
>> [    7.624563] igb 0000:02:00.0: added PHC on eth0
>> [    7.624572] igb 0000:02:00.0: Intel(R) Gigabit Ethernet Network Connection
>> [    7.624582] igb 0000:02:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 20:87:56:31:c5:0c
>> [    7.624634] igb 0000:02:00.0: eth0: PBA No: 000300-000
>> [    7.624643] igb 0000:02:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
>> [    7.663725] fbcon: inteldrmfb (fb0) is primary device
>> [    7.715912] Console: switching to colour frame buffer device 240x67
>> [    7.752821] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
>> [    7.849108] usb 1-1: new high-speed USB device number 2 using ehci-pci
>> [    7.862245] pps pps1: new PPS source ptp1
>> [    7.862252] igb 0000:03:00.0: added PHC on eth1
>> [    7.862256] igb 0000:03:00.0: Intel(R) Gigabit Ethernet Network Connection
>> [    7.862260] igb 0000:03:00.0: eth1: (PCIe:2.5Gb/s:Width x1) 20:87:56:31:c5:06
>> [    7.862303] igb 0000:03:00.0: eth1: PBA No: 000300-000
>> [    7.862308] igb 0000:03:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
>> [    7.869343] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    7.870113] igb 0000:02:00.0 enp2s0: renamed from eth0
>> [    7.870864] ata1.00: ATA-10: Micron_5100_MTFDDAK240TCB,  D0MU037, max UDMA/133
>> [    7.870869] ata1.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>> [    7.872982] ata1.00: configured for UDMA/133
>> [    7.873448] scsi 0:0:0:0: Direct-Access     ATA      Micron_5100_MTFD U037 PQ: 0 ANSI: 5
>> [    7.876337] igb 0000:03:00.0 enp3s0: renamed from eth1
>> [    7.927678] ata1.00: Enabling discard_zeroes_data
>> [    7.927918] sd 0:0:0:0: [sda] 468862128 512-byte logical blocks: (240 GB/224 GiB)
>> [    7.927921] sd 0:0:0:0: [sda] 4096-byte physical blocks
>> [    7.927962] sd 0:0:0:0: [sda] Write Protect is off
>> [    7.927965] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>> [    7.928086] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    7.928580] ata1.00: Enabling discard_zeroes_data
>> [    7.932119]  sda: sda1 sda2 sda3 sda4
>> [    7.933294] ata1.00: Enabling discard_zeroes_data
>> [    7.933745] sd 0:0:0:0: [sda] Attached SCSI disk
>> [    7.977410] usb 1-1: New USB device found, idVendor=8087, idProduct=07e6
>> [    7.977418] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>> [    7.977925] hub 1-1:1.0: USB hub found
>> [    7.978055] hub 1-1:1.0: 4 ports detected
>> [    8.255098] usb 1-1.2: new high-speed USB device number 3 using ehci-pci
>> [    8.287909] random: lvm: uninitialized urandom read (4 bytes read)
>> [    8.333412] usb 1-1.2: New USB device found, idVendor=0424, idProduct=2514
>> [    8.333421] usb 1-1.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>> [    8.334095] hub 1-1.2:1.0: USB hub found
>> [    8.334287] hub 1-1.2:1.0: 4 ports detected
>> [    8.360743] device-mapper: uevent: version 1.0.3
>> [    8.361140] device-mapper: ioctl: 4.37.0-ioctl (2017-09-20) initialised: dm-devel@redhat.com
>> [    8.400062] usb 1-1.3: new low-speed USB device number 4 using ehci-pci
>> [    8.414458] random: lvm: uninitialized urandom read (2 bytes read)
>> [    8.483918] usb 1-1.3: New USB device found, idVendor=413c, idProduct=301a
>> [    8.483926] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>> [    8.483931] usb 1-1.3: Product: Dell MS116 USB Optical Mouse
>> [    8.483936] usb 1-1.3: Manufacturer: PixArt
>> [    8.512842] hidraw: raw HID events driver (C) Jiri Kosina
>> [    8.536324] usbcore: registered new interface driver usbhid
>> [    8.536329] usbhid: USB HID core driver
>> [    8.549051] usb 1-1.4: new low-speed USB device number 5 using ehci-pci
>> [    8.564722] input: PixArt Dell MS116 USB Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1.3/1-1.3:1.0/0003:413C:301A.0001/input/input6
>> [    8.565486] hid-generic 0003:413C:301A.0001: input,hidraw0: USB HID v1.11 Mouse [PixArt Dell MS116 USB Optical Mouse] on usb-0000:00:1d.0-1.3/input0
>> [    8.635160] usb 1-1.4: New USB device found, idVendor=413c, idProduct=2113
>> [    8.635167] usb 1-1.4: New USB device strings: Mfr=0, Product=2, SerialNumber=0
>> [    8.635171] usb 1-1.4: Product: Dell KB216 Wired Keyboard
>> [    8.640453] input: Dell KB216 Wired Keyboard as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1.4/1-1.4:1.0/0003:413C:2113.0002/input/input7
>> [    8.693432] hid-generic 0003:413C:2113.0002: input,hidraw1: USB HID v1.11 Keyboard [Dell KB216 Wired Keyboard] on usb-0000:00:1d.0-1.4/input0
>> [    8.700294] input: Dell KB216 Wired Keyboard as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1.4/1-1.4:1.1/0003:413C:2113.0003/input/input8
>> [    8.705097] usb 1-1.2.4: new high-speed USB device number 6 using ehci-pci
>> [    8.752218] hid-generic 0003:413C:2113.0003: input,hidraw2: USB HID v1.11 Device [Dell KB216 Wired Keyboard] on usb-0000:00:1d.0-1.4/input1
>> [    8.797190] usb 1-1.2.4: New USB device found, idVendor=0781, idProduct=5581
>> [    8.797206] usb 1-1.2.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>> [    8.797216] usb 1-1.2.4: Product: Ultra
>> [    8.797225] usb 1-1.2.4: Manufacturer: SanDisk
>> [    8.797235] usb 1-1.2.4: SerialNumber: 04018812802fe8c3affb6e4ff14c9072616e7bdcf156e4641ccc688d0ccd13340aa400000000000000000000c1ca173b001a0818815581079d275241
>> [    8.839864] usb-storage 1-1.2.4:1.0: USB Mass Storage device detected
>> [    8.840644] scsi host2: usb-storage 1-1.2.4:1.0
>> [    8.841311] usbcore: registered new interface driver usb-storage
>> [    8.880219] usbcore: registered new interface driver uas
>> [    9.889263] scsi 2:0:0:0: Direct-Access     SanDisk  Ultra            1.00 PQ: 0 ANSI: 6
>> [    9.892272] sd 2:0:0:0: [sdb] 120176640 512-byte logical blocks: (61.5 GB/57.3 GiB)
>> [    9.893800] sd 2:0:0:0: [sdb] Write Protect is off
>> [    9.893813] sd 2:0:0:0: [sdb] Mode Sense: 43 00 00 00
>> [    9.895222] sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
>> [    9.916779] GPT:Primary header thinks Alt. header is not at the end of the disk.
>> [    9.916791] GPT:14877691 != 120176639
>> [    9.916798] GPT:Alternate GPT header not at the end of the disk.
>> [    9.916804] GPT:14877691 != 120176639
>> [    9.916809] GPT: Use GNU Parted to correct GPT errors.
>> [    9.916867]  sdb: sdb1 sdb2
>> [    9.922154] sd 2:0:0:0: [sdb] Attached SCSI removable disk
>> [   14.715297] NET: Registered protocol family 38
>> [   17.437791] random: cryptsetup: uninitialized urandom read (2 bytes read)
>> [   25.557261] random: cryptsetup: uninitialized urandom read (2 bytes read)
>> [   33.658071] random: cryptsetup: uninitialized urandom read (2 bytes read)
>> [   41.752577] random: cryptsetup: uninitialized urandom read (2 bytes read)
>> [   44.817298] random: lvm: uninitialized urandom read (4 bytes read)
>> [   45.573555] EXT4-fs (dm-5): mounted filesystem with ordered data mode. Opts: i_version
>> [   46.013797] EXT4-fs: Warning: mounting with data=journal disables delayed allocation and O_DIRECT support!
>> [   46.016488] EXT4-fs (dm-7): mounted filesystem with journalled data mode. Opts: data=journal
>> [   47.319423] audit: type=1805 audit(1579779497.322:2): action="dont_appraise" fsmagic="0x9fa0" res=1
>> [   47.319439] audit: type=1805 audit(1579779497.322:3): action="dont_appraise" fsmagic="0x62656572" res=1
>> [   47.319450] audit: type=1805 audit(1579779497.322:4): action="dont_appraise" fsmagic="0x64626720" res=1
>> [   47.319460] audit: type=1805 audit(1579779497.322:5): action="dont_appraise" fsmagic="0x1021994" res=1
>> [   47.319474] audit: type=1805 audit(1579779497.322:6): action="dont_appraise" fsmagic="0x858458f6" res=1
>> [   47.319490] audit: type=1805 audit(1579779497.322:7): action="dont_appraise" fsmagic="0x1cd1" res=1
>> [   47.319531] audit: type=1805 audit(1579779497.322:8): action="dont_appraise" fsmagic="0x42494e4d" res=1
>> [   47.319544] audit: type=1805 audit(1579779497.322:9): action="dont_appraise" fsmagic="0x73636673" res=1
>> [   47.319558] audit: type=1805 audit(1579779497.322:10): action="dont_appraise" fsmagic="0xf97cff8c" res=1
>> [   47.319586] audit: type=1805 audit(1579779497.322:11): action="dont_appraise" fsmagic="0x43415d53" res=1
>> [   47.319735] systemd[1]: Successfully loaded the IMA custom policy /etc/ima/ima-policy.
>> [   47.319758] IMA: policy update completed
>> [   47.366386] ip_tables: (C) 2000-2006 Netfilter Core Team
>> [   47.437980] systemd[1]: systemd 241 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN -PCRE2 default-hierarchy=hybrid)
>> [   47.451240] systemd[1]: Detected architecture x86-64.
>> [   47.457586] systemd[1]: Set hostname to <localhost.localdomain>.
>> [   47.459459] systemd[1]: Failed to bump fs.file-max, ignoring: Invalid argument
>> [   47.818194] systemd[1]: /run/systemd/generator.late/squid.service:21: PIDFile= references path below legacy directory /var/run/, updating /var/run/squid.pid → /run/squid.pid; please update the unit file accordingly.
>> [   47.827355] systemd[1]: Created slice system-getty.slice.
>> [   47.828000] systemd[1]: Listening on udev Kernel Socket.
>> [   47.828420] systemd[1]: Listening on fsck to fsckd communication Socket.
>> [   47.828862] systemd[1]: Listening on Journal Socket (/dev/log).
>> [   47.829710] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
>> [   47.996814] random: lvm: uninitialized urandom read (4 bytes read)
>> [   48.050142] Non-volatile memory driver v1.3
>> [   48.316925] random: systemd-random-: uninitialized urandom read (512 bytes read)
>> [   48.494669] random: mktemp: uninitialized urandom read (6 bytes read)
>> [   49.056503] systemd-journald[503]: Received request to flush runtime journal from PID 1
>> [   49.337143] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
>> [   49.847951] input: PC Speaker as /devices/platform/pcspkr/input/input9
>> [   49.946847] sd 0:0:0:0: Attached scsi generic sg0 type 0
>> [   50.014119] sd 2:0:0:0: Attached scsi generic sg1 type 0
>> [   50.168891] snd_hda_intel 0000:00:1b.0: bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
>> [   50.215517] igb 0000:02:00.0 factorylan0: renamed from enp2s0
>> [   50.254803] igb 0000:03:00.0 machinelan0: renamed from enp3s0
>> [   50.318608] iTCO_vendor_support: vendor-support=0
>> [   50.377676] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
>> [   50.380349] iTCO_wdt: Found a Bay Trail SoC TCO device (Version=3, TCOBASE=0x0460)
>> [   50.455705] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
>> [   50.705168] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
>> [   50.753973] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
>> [   50.833744] (NULL device *): hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
>> [   50.866327] (NULL device *): hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
>> [   50.955750] intel_rapl: Found RAPL domain package
>> [   50.955757] intel_rapl: Found RAPL domain core
>> [   52.482335] EXT4-fs (dm-6): mounted filesystem with journalled data mode. Opts: data=journal
>> [   52.557641] EXT4-fs (dm-8): mounted filesystem with journalled data mode. Opts: data=journal
>> [   55.920244] IPv6: ADDRCONF(NETDEV_UP): factorylan0: link is not ready
>> [   55.978874] IPv6: ADDRCONF(NETDEV_UP): factorylan0: link is not ready
>> [   55.995905] IPv6: ADDRCONF(NETDEV_UP): machinelan0: link is not ready
>> [   56.049581] IPv6: ADDRCONF(NETDEV_UP): machinelan0: link is not ready
>> [   58.981633] igb 0000:03:00.0 machinelan0: igb: machinelan0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
>> [   59.087351] IPv6: ADDRCONF(NETDEV_CHANGE): machinelan0: link becomes ready
>> [   66.389565] bridge: filtering via arp/ip/ip6tables is no longer available by default. Update your scripts to load br_netfilter if you need this.
>> [   66.395634] Bridge firewalling registered
>> [   66.431249] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
>> [   66.671647] Initializing XFRM netlink socket
>> [   66.684553] Netfilter messages via NETLINK v0.30.
>> [   66.689312] ctnetlink v0.93: registering with nfnetlink.
>> [   66.963230] IPv6: ADDRCONF(NETDEV_UP): docker0: link is not ready
>> root@localhost:/home/mentor#
>> root@localhost:# dmesg | grep tsc
>> [    0.001000] tsc: Detected 1832.600 MHz processor
>> [    4.895129] tsc: Refined TSC clocksource calibration: 1833.333 MHz
>> [    4.895196] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x34da54753aa, max_idle_ns: 881590618787 ns
>> [    5.904409] clocksource: Switched to clocksource tsc
>>
> 
> 

