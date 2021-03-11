Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4956533715D
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 12:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbhCKL3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 06:29:39 -0500
Received: from air.basealt.ru ([194.107.17.39]:52402 "EHLO air.basealt.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232643AbhCKL3U (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 06:29:20 -0500
Received: by air.basealt.ru (Postfix, from userid 490)
        id 575B0589432; Thu, 11 Mar 2021 11:29:17 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on
        sa.local.altlinux.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        RP_MATCHES_RCVD autolearn=ham autolearn_force=no version=3.4.1
Received: from nickel-ws.localdomain (obninsk.basealt.ru [217.15.195.17])
        by air.basealt.ru (Postfix) with ESMTPSA id 22CCF589428;
        Thu, 11 Mar 2021 11:29:09 +0000 (UTC)
Reply-To: nickel@basealt.ru
Subject: Re: elan_i2c: failed to read report data: -71
To:     jingle <jingle.wu@emc.com.tw>
Cc:     stable@vger.kernel.org,
        'Dmitry Torokhov' <dmitry.torokhov@gmail.com>,
        kernel@pengutronix.de, linux-input@vger.kernel.org,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
References: <20210302210934.iro3a6chigx72r4n@pengutronix.de>
 <016d01d70fdb$2aa48b00$7feda100$@emc.com.tw>
 <20210303183223.rtqi63hdl3a7hahv@pengutronix.de>
 <20210303200330.udsge64hxlrdkbwt@pengutronix.de>
 <YEA9oajb7qj6LGPD@google.com>
 <20210304065958.n3u5ewoby6rjsdvj@pengutronix.de>
 <15cb57ba-9188-51a1-b931-da45932e199f@basealt.ru>
 <20210305191806.twbfrkgdgf4as7c2@pengutronix.de>
From:   Nikolai Kostrigin <nickel@basealt.ru>
Organization: BaseALT
Message-ID: <22d4c0e2-18db-4a04-8584-755407d33a5a@basealt.ru>
Date:   Thu, 11 Mar 2021 14:29:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210305191806.twbfrkgdgf4as7c2@pengutronix.de>
Content-Type: multipart/mixed;
 boundary="------------047573928A96EA97B9B27720"
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------047573928A96EA97B9B27720
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi!

05.03.2021 22:18, Uwe Kleine-König пишет:
> On Thu, Mar 04, 2021 at 11:49:59AM +0300, Nikolai Kostrigin wrote:
>> Hi,
>>
>> 04.03.2021 09:59, Uwe Kleine-König пишет:
>>> Hello,
>>>
>>> On Wed, Mar 03, 2021 at 05:53:37PM -0800, 'Dmitry Torokhov' wrote:
>>>> On Wed, Mar 03, 2021 at 09:03:30PM +0100, Uwe Kleine-König wrote:
>>>>> On Wed, Mar 03, 2021 at 07:32:23PM +0100, Uwe Kleine-König wrote:
>>>>>> On Wed, Mar 03, 2021 at 11:13:21AM +0800, jingle wrote:
>>>>>>> Please updates this patchs.
>>>>>>>
>>>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git/commit/?h=next&id=056115daede8d01f71732bc7d778fb85acee8eb6
>>>>>>>
>>>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git/commit/?h=next&id=e4c9062717feda88900b566463228d1c4910af6d
>>>>>>
>>>>>> The first was one of the two patches I already tried, but the latter
>>>>>> indeed fixes my problem \o/.
>>>>>>
>>>>>> @Dmitry: If you don't consider your tree stable, feel free to add a
>>>>>>
>>>>>> 	Tested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>>>>>>
>>>>>> to e4c9062717feda88900b566463228d1c4910af6d.
>>>>>
>>>>> Do you consider this patch for stable? I'd like to see it in Debian's
>>>>> 5.10 kernel and I guess I'm not the only one who would benefit from such
>>>>> a backport.
>>>>
>>>> When I was applying the patches I did not realize that there was already
>>>> hardware in the wild that needed it. The patches are now in mainline, so
>>>> I can no longer adjust the tags, but I will not object if you propose
>>>> them for stable.
>>>
>>> I want to propose to backport commit
>>>
>>> e4c9062717fe ("Input: elantech - fix protocol errors for some trackpoints in SMBus mode")
>>>
>>> to the active stable kernels. This commit repairs the track point and
>>> the touch pad buttons on a Lenovo Thinkpad E15 here. Without this change
>>> I don't get any events apart from an error message for each button press
>>> or move of the track point in the kernel log. (Also the error message is
>>> the same for all buttons and the track point, so I cannot create a new
>>> input event driver in userspace that emulates the right event depending
>>> on the error message :-)
>>>
>>> At least to 5.10.x it applies cleanly, I didn't try the older stable
>>> branches.
>>>
>>> Best regards and thanks
>>> Uwe
>>>
>>
>> I'd like to propose to backport [1] also as it was checked along with
>> previously proposed patch and fixes Elan Trackpoint operation on
>> Thinkpad L13.
>>
>> Both patches apply cleanly to 5.10.17 in my case.
>>
>> I also tried to apply to 5.4.x, but failed.
>>
>> [1] 056115daede8 Input: elan_i2c - add new trackpoint report type 0x5F
>>
>> Additional info is available here:
>>
>> https://lore.kernel.org/linux-input/fe31f6f8-6e38-2ed6-8548-6fa271bf36e9@basealt.ru/T/#m514047f2c5e7e2ec4ed9658782f14221ed7598fc
> 
> FTR: I tested 5.10 + e4c9062717fe ("Input: elantech - fix protocol
> errors for some trackpoints in SMBus mode") now and in this setup the
> touchpad is still broken. I assume that in combination with 056115daede8
> it will work. The working setup I tested was 5.10 + c7f0169e3bd2 +
> 056115daede8 + e4c9062717fe and I assume c7f0169e3bd2 isn't relevant.
> 
> Best regards
> Uwe
> 
> 

Now when both patches (056115daede8 + e4c9062717fe) are in stable since
5.10.22 trackpoint works just fine on TP L13 after computer boot.

But there is one more thing to add:

when resuming from hibernation mode trackpoint loses the workaround and
continue to send long packets (please refer to attached log).
This happens because the device was powered off and during wake-up the
code from 'psmouse' containing packet type switch was not run.

drivers/input/mouse/elantech.c:
if (elantech_change_report_id(psmouse)) {
                        psmouse_info(psmouse,
                                     "Trackpoint report is broken,
forcing standard PS/2 protocol\n");
                        return -ENODEV;
                }

Power management is handled by elan_i2c driver.

drivers/input/mouse/elan_i2c_core.c:

[...]
static SIMPLE_DEV_PM_OPS(elan_pm_ops, elan_suspend, elan_resume);
[...]

Resume from suspend is not affected since, I guess, the initial setup is
preserved in powered state.

The quick workaround is to reload either psmouse or i2c_i801 driver.
This restores operation.

So I'd like to kindly ask Jingle Wu to introduce execution of
elantech_change_report_id() during hibernation resume if this possible
paying attention to psmouse and elan_i2c drivers architecture.

Thank you.

-- 
Best regards,
Nikolai Kostrigin

--------------047573928A96EA97B9B27720
Content-Type: text/x-log; charset=UTF-8;
 name="dmesg_elan_i2c_EPROTO_after_pm-hibernate.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="dmesg_elan_i2c_EPROTO_after_pm-hibernate.log"

[    0.000000] Linux version 5.10.22-un-def-alt1 (builder@localhost.localdomain) (gcc-10 (GCC) 10.2.1 20201125 (ALT Sisyphus 10.2.1-alt2), GNU ld (GNU Binutils) 2.35.1.20210104) #1 SMP PREEMPT Tue Mar 9 18:59:44 UTC 2021
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz root=/dev/mapper/alt-root ro quiet resume=/dev/disk/by-uuid/c47ef67b-a71e-4223-993f-2f2b4f6b7f48 panic=30 splash
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Hygon HygonGenuine
[    0.000000]   Centaur CentaurHauls
[    0.000000] x86/split lock detection: warning about user-space split_locks
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x020: 'AVX-512 opmask'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x040: 'AVX-512 Hi256'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x080: 'AVX-512 ZMM_Hi256'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x200: 'Protection Keys User registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: xstate_offset[5]:  832, xstate_sizes[5]:   64
[    0.000000] x86/fpu: xstate_offset[6]:  896, xstate_sizes[6]:  512
[    0.000000] x86/fpu: xstate_offset[7]: 1408, xstate_sizes[7]: 1024
[    0.000000] x86/fpu: xstate_offset[9]: 2432, xstate_sizes[9]:    8
[    0.000000] x86/fpu: Enabled xstate features 0x2e7, context size is 2440 bytes, using 'compacted' format.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000008b8c9fff] usable
[    0.000000] BIOS-e820: [mem 0x000000008b8ca000-0x0000000092f2efff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000092f2f000-0x0000000093b2efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000093b2f000-0x0000000093bfefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000093bff000-0x0000000093bfffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000093c00000-0x0000000097ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000098c00000-0x0000000098dfffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000099600000-0x00000000a07fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed20000-0x00000000fed7ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000025f7fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.70 by Lenovo
[    0.000000] efi: ACPI=0x93bfe000 ACPI 2.0=0x93bfe014 SMBIOS=0x8f1b2000 SMBIOS 3.0=0x8f1a5000 TPMFinalLog=0x93990000 MEMATTR=0x8822d018 ESRT=0x87e23298 RNG=0x8f2da818 TPMEventLog=0x6a4c4018 
[    0.000000] efi: seeding entropy pool
[    0.000000] SMBIOS 3.2.0 present.
[    0.000000] DMI: LENOVO 20VH001WRT/20VH001WRT, BIOS R1FET29W (1.03 ) 10/08/2020
[    0.000000] tsc: Detected 2400.000 MHz processor
[    0.000000] tsc: Detected 2419.200 MHz TSC
[    0.000006] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000009] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000015] last_pfn = 0x25f800 max_arch_pfn = 0x400000000
[    0.000017] MTRR default type: write-back
[    0.000018] MTRR fixed ranges enabled:
[    0.000019]   00000-9FFFF write-back
[    0.000020]   A0000-BFFFF uncachable
[    0.000021]   C0000-FFFFF write-protect
[    0.000022] MTRR variable ranges enabled:
[    0.000023]   0 base 00C0000000 mask 7FC0000000 uncachable
[    0.000024]   1 base 00A0000000 mask 7FE0000000 uncachable
[    0.000025]   2 base 009C000000 mask 7FFC000000 uncachable
[    0.000026]   3 base 2000000000 mask 6000000000 uncachable
[    0.000026]   4 base 1000000000 mask 7000000000 uncachable
[    0.000027]   5 base 0800000000 mask 7800000000 uncachable
[    0.000028]   6 base 0400000000 mask 7C00000000 uncachable
[    0.000029]   7 base 4000000000 mask 4000000000 uncachable
[    0.000029]   8 disabled
[    0.000030]   9 disabled
[    0.000704] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[    0.001238] last_pfn = 0x93c00 max_arch_pfn = 0x400000000
[    0.014167] esrt: Reserving ESRT space from 0x0000000087e23298 to 0x0000000087e23438.
[    0.014173] e820: update [mem 0x87e23000-0x87e23fff] usable ==> reserved
[    0.014196] check: Scanning 1 areas for low memory corruption
[    0.014201] Using GB pages for direct mapping
[    0.014617] Secure boot disabled
[    0.014618] RAMDISK: [mem 0x32f21000-0x3407bfff]
[    0.014632] ACPI: Early table checksum verification disabled
[    0.014635] ACPI: RSDP 0x0000000093BFE014 000024 (v02 LENOVO)
[    0.014639] ACPI: XSDT 0x0000000093BFC188 000124 (v01 LENOVO TP-R1F   00001030 PTEC 00000002)
[    0.014645] ACPI: FACP 0x000000008F194000 000114 (v06 LENOVO TP-R1F   00001030 PTEC 00000002)
[    0.014651] ACPI: DSDT 0x000000008F15C000 031B56 (v02 LENOVO ICL      00000002      01000013)
[    0.014655] ACPI: FACS 0x000000009396F000 000040
[    0.014658] ACPI: SSDT 0x000000008F23F000 00255D (v02 LENOVO CpuSsdt  00003000 INTL 20191018)
[    0.014662] ACPI: SSDT 0x000000008F23E000 00059B (v02 LENOVO CtdpB    00001000 INTL 20191018)
[    0.014665] ACPI: SSDT 0x000000008F1C4000 0035E3 (v02 LENOVO DptfTabl 00001000 INTL 20191018)
[    0.014669] ACPI: SSDT 0x000000008F198000 00060E (v02 LENOVO Tpm2Tabl 00001000 INTL 20191018)
[    0.014673] ACPI: TPM2 0x000000008F197000 00004C (v04 LENOVO TP-R1F   00001030 PTEC 00000002)
[    0.014676] ACPI: SSDT 0x000000008F196000 00054B (v02 LENOVO PerfTune 00001000 INTL 20191018)
[    0.014680] ACPI: ECDT 0x000000008F195000 000053 (v01 LENOVO TP-R1F   00001030 PTEC 00000002)
[    0.014683] ACPI: HPET 0x000000008F193000 000038 (v01 LENOVO TP-R1F   00001030 PTEC 00000002)
[    0.014687] ACPI: APIC 0x000000008F192000 00012C (v04 LENOVO TP-R1F   00001030 PTEC 00000002)
[    0.014690] ACPI: MCFG 0x000000008F191000 00003C (v01 LENOVO TP-R1F   00001030 PTEC 00000002)
[    0.014694] ACPI: SSDT 0x000000008F190000 000083 (v02 LENOVO PID1Ssdt 00000010 INTL 20191018)
[    0.014697] ACPI: SSDT 0x000000008F18E000 001469 (v02 LENOVO ProjSsdt 00000010 INTL 20191018)
[    0.014701] ACPI: SSDT 0x000000008F159000 0023E7 (v02 LENOVO TglU_Rvp 00001000 INTL 20191018)
[    0.014704] ACPI: NHLT 0x000000008F158000 0002E1 (v00 LENOVO TP-R1F   00001030 PTEC 00000002)
[    0.014708] ACPI: SSDT 0x000000008F154000 002BB5 (v02 LENOVO SaSsdt   00003000 INTL 20191018)
[    0.014711] ACPI: SSDT 0x000000008F150000 00354B (v02 LENOVO IgfxSsdt 00003000 INTL 20191018)
[    0.014715] ACPI: SSDT 0x000000008F144000 00B252 (v02 LENOVO TcssSsdt 00001000 INTL 20191018)
[    0.014718] ACPI: LPIT 0x000000008F141000 0000CC (v01 LENOVO TP-R1F   00001030 PTEC 00000002)
[    0.014722] ACPI: WSMT 0x000000008F140000 000028 (v01 LENOVO TP-R1F   00001030 PTEC 00000002)
[    0.014725] ACPI: SSDT 0x000000008F13F000 00012A (v02 LENOVO TbtTypeC 00000000 INTL 20191018)
[    0.014728] ACPI: DBGP 0x000000008F13E000 000034 (v01 LENOVO TP-R1F   00001030 PTEC 00000002)
[    0.014732] ACPI: DBG2 0x000000008F13D000 000054 (v00 LENOVO TP-R1F   00001030 PTEC 00000002)
[    0.014735] ACPI: POAT 0x000000008F13C000 000055 (v03 LENOVO TP-R1F   00001030 PTEC 00000002)
[    0.014739] ACPI: SSDT 0x000000008F126000 00090D (v02 LENOVO UsbCTabl 00001000 INTL 20191018)
[    0.014742] ACPI: BATB 0x000000008F125000 00004A (v02 LENOVO TP-R1F   00001030 PTEC 00000002)
[    0.014746] ACPI: DMAR 0x000000008C11E000 0000C0 (v02 LENOVO TP-R1F   00001030 PTEC 00000002)
[    0.014749] ACPI: SSDT 0x000000008C11D000 000144 (v02 LENOVO ADebTabl 00001000 INTL 20191018)
[    0.014752] ACPI: BGRT 0x000000008F127000 000038 (v01 LENOVO TP-R1F   00001030 PTEC 00000002)
[    0.014756] ACPI: PTDT 0x000000008C11C000 000986 (v00 LENOVO TP-R1F   00001030 PTEC 00000002)
[    0.014759] ACPI: UEFI 0x00000000930C3000 00008A (v01 LENOVO TP-R1F   00001030 PTEC 00000002)
[    0.014763] ACPI: FPDT 0x000000008C11B000 000044 (v01 LENOVO TP-R1F   00001030 PTEC 00001030)
[    0.014771] ACPI: Local APIC address 0xfee00000
[    0.014890] No NUMA configuration found
[    0.014891] Faking a node at [mem 0x0000000000000000-0x000000025f7fffff]
[    0.014895] NODE_DATA(0) allocated [mem 0x25f7fa000-0x25f7fdfff]
[    0.014920] Zone ranges:
[    0.014921]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.014923]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.014924]   Normal   [mem 0x0000000100000000-0x000000025f7fffff]
[    0.014926] Movable zone start for each node
[    0.014927] Early memory node ranges
[    0.014928]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.014929]   node   0: [mem 0x0000000000100000-0x000000008b8c9fff]
[    0.014930]   node   0: [mem 0x0000000093bff000-0x0000000093bfffff]
[    0.014931]   node   0: [mem 0x0000000100000000-0x000000025f7fffff]
[    0.015324] Zeroed struct page in unavailable ranges: 53143 pages
[    0.015326] Initmem setup node 0 [mem 0x0000000000001000-0x000000025f7fffff]
[    0.015328] On node 0 totalpages: 2011241
[    0.015332]   DMA zone: 64 pages used for memmap
[    0.015332]   DMA zone: 24 pages reserved
[    0.015333]   DMA zone: 3998 pages, LIFO batch:0
[    0.015363]   DMA32 zone: 8868 pages used for memmap
[    0.015364]   DMA32 zone: 567499 pages, LIFO batch:63
[    0.018775]   Normal zone: 22496 pages used for memmap
[    0.018776]   Normal zone: 1439744 pages, LIFO batch:63
[    0.027346] Reserving Intel graphics memory at [mem 0x9c800000-0xa07fffff]
[    0.027939] ACPI: PM-Timer IO Port: 0x1808
[    0.027941] ACPI: Local APIC address 0xfee00000
[    0.027948] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.027949] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.027950] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.027950] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.027951] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.027952] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.027952] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.027953] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.027954] ACPI: LAPIC_NMI (acpi_id[0x09] high edge lint[0x1])
[    0.027954] ACPI: LAPIC_NMI (acpi_id[0x0a] high edge lint[0x1])
[    0.027955] ACPI: LAPIC_NMI (acpi_id[0x0b] high edge lint[0x1])
[    0.027956] ACPI: LAPIC_NMI (acpi_id[0x0c] high edge lint[0x1])
[    0.027956] ACPI: LAPIC_NMI (acpi_id[0x0d] high edge lint[0x1])
[    0.027957] ACPI: LAPIC_NMI (acpi_id[0x0e] high edge lint[0x1])
[    0.027958] ACPI: LAPIC_NMI (acpi_id[0x0f] high edge lint[0x1])
[    0.027958] ACPI: LAPIC_NMI (acpi_id[0x10] high edge lint[0x1])
[    0.027998] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-119
[    0.028001] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.028002] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.028004] ACPI: IRQ0 used by override.
[    0.028005] ACPI: IRQ9 used by override.
[    0.028007] Using ACPI (MADT) for SMP configuration information
[    0.028008] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.028017] e820: update [mem 0x8764a000-0x876dafff] usable ==> reserved
[    0.028025] TSC deadline timer available
[    0.028027] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.028041] PM: hibernation: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.028043] PM: hibernation: Registered nosave memory: [mem 0x0009f000-0x000fffff]
[    0.028044] PM: hibernation: Registered nosave memory: [mem 0x8764a000-0x876dafff]
[    0.028046] PM: hibernation: Registered nosave memory: [mem 0x87e23000-0x87e23fff]
[    0.028047] PM: hibernation: Registered nosave memory: [mem 0x8b8ca000-0x92f2efff]
[    0.028048] PM: hibernation: Registered nosave memory: [mem 0x92f2f000-0x93b2efff]
[    0.028048] PM: hibernation: Registered nosave memory: [mem 0x93b2f000-0x93bfefff]
[    0.028050] PM: hibernation: Registered nosave memory: [mem 0x93c00000-0x97ffffff]
[    0.028050] PM: hibernation: Registered nosave memory: [mem 0x98000000-0x98bfffff]
[    0.028051] PM: hibernation: Registered nosave memory: [mem 0x98c00000-0x98dfffff]
[    0.028052] PM: hibernation: Registered nosave memory: [mem 0x98e00000-0x995fffff]
[    0.028052] PM: hibernation: Registered nosave memory: [mem 0x99600000-0xa07fffff]
[    0.028053] PM: hibernation: Registered nosave memory: [mem 0xa0800000-0xfed1ffff]
[    0.028054] PM: hibernation: Registered nosave memory: [mem 0xfed20000-0xfed7ffff]
[    0.028054] PM: hibernation: Registered nosave memory: [mem 0xfed80000-0xffffffff]
[    0.028056] [mem 0xa0800000-0xfed1ffff] available for PCI devices
[    0.028057] Booting paravirtualized kernel on bare hardware
[    0.028060] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.033663] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
[    0.033875] percpu: Embedded 56 pages/cpu s192512 r8192 d28672 u262144
[    0.033882] pcpu-alloc: s192512 r8192 d28672 u262144 alloc=1*2097152
[    0.033883] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.033905] Built 1 zonelists, mobility grouping on.  Total pages: 1979789
[    0.033906] Policy zone: Normal
[    0.033907] Kernel command line: BOOT_IMAGE=/boot/vmlinuz root=/dev/mapper/alt-root ro quiet resume=/dev/disk/by-uuid/c47ef67b-a71e-4223-993f-2f2b4f6b7f48 panic=30 splash
[    0.034366] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes, linear)
[    0.034584] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes, linear)
[    0.034675] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.053125] Memory: 7681712K/8044964K available (12296K kernel code, 1984K rwdata, 7808K rodata, 1688K init, 4600K bss, 362996K reserved, 0K cma-reserved)
[    0.053193] ftrace: allocating 39630 entries in 155 pages
[    0.068827] ftrace: allocated 155 pages with 5 groups
[    0.068918] rcu: Preemptible hierarchical RCU implementation.
[    0.068919] rcu: 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=8.
[    0.068921] 	Trampoline variant of Tasks RCU enabled.
[    0.068921] 	Rude variant of Tasks RCU enabled.
[    0.068922] 	Tracing variant of Tasks RCU enabled.
[    0.068923] rcu: RCU calculated value of scheduler-enlistment delay is 100 jiffies.
[    0.068924] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.072668] NR_IRQS: 33024, nr_irqs: 2048, preallocated irqs: 16
[    0.073205] random: get_random_bytes called from start_kernel+0x65b/0x83e with crng_init=0
[    0.073332] Console: colour dummy device 80x25
[    0.073345] printk: console [tty0] enabled
[    0.073363] ACPI: Core revision 20200925
[    0.073765] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 99544814920 ns
[    0.073877] APIC: Switch to symmetric I/O mode setup
[    0.073879] DMAR: Host address width 39
[    0.073880] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.073885] DMAR: dmar0: reg_base_addr fed90000 ver 4:0 cap 1c0000c40660462 ecap 69e2ff0505e
[    0.073887] DMAR: DRHD base: 0x000000fed86000 flags: 0x0
[    0.073891] DMAR: dmar1: reg_base_addr fed86000 ver 1:0 cap d2008c40660462 ecap f050da
[    0.073892] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.073898] DMAR: dmar2: reg_base_addr fed91000 ver 1:0 cap d2008c40660462 ecap f050da
[    0.073899] DMAR: RMRR base: 0x0000009c000000 end: 0x000000a07fffff
[    0.073901] DMAR: RMRR base: 0x00000092b19000 end: 0x00000092f18fff
[    0.073903] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 2
[    0.073904] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
[    0.073905] DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.076071] DMAR-IR: Enabled IRQ remapping in x2apic mode
[    0.076072] x2apic enabled
[    0.076104] Switched APIC routing to cluster x2apic.
[    0.081520] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.085831] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x22df1149949, max_idle_ns: 440795312789 ns
[    0.085837] Calibrating delay loop (skipped), value calculated using timer frequency.. 4838.40 BogoMIPS (lpj=2419200)
[    0.085840] pid_max: default: 32768 minimum: 301
[    0.089469] LSM: Security Framework initializing
[    0.089475] Yama: becoming mindful.
[    0.089484] AltHa disabled.
[    0.089487] Kiosk: Netlink family registered.
[    0.089513] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes, linear)
[    0.089530] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes, linear)
[    0.089782] x86/cpu: User Mode Instruction Prevention (UMIP) activated
[    0.089817] mce: CPU0: Thermal monitoring enabled (TM1)
[    0.089896] process: using mwait in idle threads
[    0.089898] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.089899] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.089903] Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sanitization
[    0.089905] Spectre V2 : Mitigation: Enhanced IBRS
[    0.089905] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
[    0.089907] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
[    0.089908] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl and seccomp
[    0.090089] Freeing SMP alternatives memory: 36K
[    0.091926] smpboot: CPU0: 11th Gen Intel(R) Core(TM) i5-1135G7 @ 2.40GHz (family: 0x6, model: 0x8c, stepping: 0x1)
[    0.092041] Performance Events: PEBS fmt4+-baseline,  AnyThread deprecated, Icelake events, 32-deep LBR, full-width counters, Intel PMU driver.
[    0.092054] ... version:                5
[    0.092054] ... bit width:              48
[    0.092055] ... generic registers:      8
[    0.092056] ... value mask:             0000ffffffffffff
[    0.092056] ... max period:             00007fffffffffff
[    0.092057] ... fixed-purpose events:   4
[    0.092057] ... event mask:             0001000f000000ff
[    0.092159] rcu: Hierarchical SRCU implementation.
[    0.092834] NMI watchdog: Enabled. Permanently consumes one hw-PMU counter.
[    0.092890] smp: Bringing up secondary CPUs ...
[    0.092971] x86: Booting SMP configuration:
[    0.092973] .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
[    0.102957] smp: Brought up 1 node, 8 CPUs
[    0.102957] smpboot: Max logical packages: 1
[    0.102957] ----------------
[    0.102957] | NMI testsuite:
[    0.102957] --------------------
[    0.102957]   remote IPI:  ok  |
[    0.102957]    local IPI:  ok  |
[    0.102957] --------------------
[    0.102957] Good, all   2 testcases passed! |
[    0.102957] ---------------------------------
[    0.102957] smpboot: Total of 8 processors activated (38707.20 BogoMIPS)
[    0.104161] devtmpfs: initialized
[    0.104161] x86/mm: Memory block size: 128MB
[    0.104894] PM: Registering ACPI NVS region [mem 0x92f2f000-0x93b2efff] (12582912 bytes)
[    0.105091] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.105095] futex hash table entries: 2048 (order: 5, 131072 bytes, linear)
[    0.105161] pinctrl core: initialized pinctrl subsystem
[    0.105383] NET: Registered protocol family 16
[    0.105472] DMA: preallocated 1024 KiB GFP_KERNEL pool for atomic allocations
[    0.105476] DMA: preallocated 1024 KiB GFP_KERNEL|GFP_DMA pool for atomic allocations
[    0.105480] DMA: preallocated 1024 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations
[    0.105485] audit: initializing netlink subsys (disabled)
[    0.105492] audit: type=2000 audit(1615373153.027:1): state=initialized audit_enabled=0 res=1
[    0.105492] thermal_sys: Registered thermal governor 'fair_share'
[    0.105492] thermal_sys: Registered thermal governor 'bang_bang'
[    0.105492] thermal_sys: Registered thermal governor 'step_wise'
[    0.105492] thermal_sys: Registered thermal governor 'user_space'
[    0.105492] cpuidle: using governor ladder
[    0.105492] cpuidle: using governor menu
[    0.105844] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.105846] ACPI: bus type PCI registered
[    0.105847] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.106078] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    0.106081] PCI: not using MMCONFIG
[    0.106085] PCI: Using configuration type 1 for base access
[    0.106365] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.107310] Kprobes globally optimized
[    0.107314] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.107314] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.108902] ACPI: Added _OSI(Module Device)
[    0.108903] ACPI: Added _OSI(Processor Device)
[    0.108904] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.108905] ACPI: Added _OSI(Processor Aggregator Device)
[    0.108906] ACPI: Added _OSI(Linux-Dell-Video)
[    0.108907] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
[    0.108908] ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
[    0.173661] ACPI: 15 ACPI AML tables successfully acquired and loaded
[    0.175222] ACPI: EC: EC started
[    0.175223] ACPI: EC: interrupt blocked
[    0.188569] ACPI: EC: EC_CMD/EC_SC=0x66, EC_DATA=0x62
[    0.188570] ACPI: EC: Boot ECDT EC used to handle transactions
[    0.190836] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.204836] ACPI: Dynamic OEM Table Load:
[    0.204836] ACPI: SSDT 0xFFFF888100DD7E00 0001CB (v02 PmRef  Cpu0Psd  00003000 INTL 20191018)
[    0.205838] ACPI: \_SB_.PR00: _OSC native thermal LVT Acked
[    0.206835] ACPI: Dynamic OEM Table Load:
[    0.206835] ACPI: SSDT 0xFFFF888100DE4C00 000394 (v02 PmRef  Cpu0Cst  00003001 INTL 20191018)
[    0.207056] ACPI: Dynamic OEM Table Load:
[    0.207061] ACPI: SSDT 0xFFFF8881015C6800 0005C3 (v02 PmRef  Cpu0Ist  00003000 INTL 20191018)
[    0.208023] ACPI: Dynamic OEM Table Load:
[    0.208028] ACPI: SSDT 0xFFFF888101578400 000266 (v02 PmRef  Cpu0Hwp  00003000 INTL 20191018)
[    0.209031] ACPI: Dynamic OEM Table Load:
[    0.209036] ACPI: SSDT 0xFFFF8881015D6000 0008E7 (v02 PmRef  ApIst    00003000 INTL 20191018)
[    0.210040] ACPI: Dynamic OEM Table Load:
[    0.210045] ACPI: SSDT 0xFFFF8881001D2800 00048A (v02 PmRef  ApHwp    00003000 INTL 20191018)
[    0.210983] ACPI: Dynamic OEM Table Load:
[    0.210987] ACPI: SSDT 0xFFFF8881015D7000 0004D2 (v02 PmRef  ApPsd    00003000 INTL 20191018)
[    0.211922] ACPI: Dynamic OEM Table Load:
[    0.211926] ACPI: SSDT 0xFFFF8881015DA800 00048A (v02 PmRef  ApCst    00003000 INTL 20191018)
[    0.214421] ACPI: Interpreter enabled
[    0.214452] ACPI: (supports S0 S4 S5)
[    0.214453] ACPI: Using IOAPIC for interrupt routing
[    0.214478] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    0.214904] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in ACPI motherboard resources
[    0.214914] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.215214] ACPI: Enabled 7 GPEs in block 00 to 7F
[    0.215832] ACPI: Power Resource [PXP] (off)
[    0.219078] ACPI: Power Resource [PUBS] (on)
[    0.225317] ACPI: Power Resource [BTPR] (on)
[    0.226202] ACPI: Power Resource [PXP] (off)
[    0.227516] ACPI: Power Resource [PXP] (off)
[    0.230612] ACPI: Power Resource [V0PR] (on)
[    0.230695] ACPI: Power Resource [V1PR] (on)
[    0.230774] ACPI: Power Resource [V2PR] (on)
[    0.232104] ACPI: Power Resource [WRST] (on)
[    0.232251] ACPI: Power Resource [TBT0] (on)
[    0.232274] ACPI: Power Resource [TBT1] (on)
[    0.232295] ACPI: Power Resource [D3C] (on)
[    0.348945] ACPI: Power Resource [FN00] (off)
[    0.349796] ACPI: Power Resource [PIN] (off)
[    0.349816] ACPI: Power Resource [PINP] (off)
[    0.350299] ACPI: PCI Root Bridge [PC00] (domain 0000 [bus 00-fe])
[    0.350304] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI EDR HPX-Type3]
[    0.352426] acpi PNP0A08:00: _OSC: platform does not support [AER]
[    0.356147] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME PCIeCapability LTR DPC]
[    0.356148] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    0.358021] PCI host bridge to bus 0000:00
[    0.358022] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.358023] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.358023] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.358024] pci_bus 0000:00: root bus resource [mem 0xa0800000-0xbfffffff window]
[    0.358024] pci_bus 0000:00: root bus resource [mem 0x4000000000-0x7fffffffff window]
[    0.358025] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.358048] pci 0000:00:00.0: [8086:9a14] type 00 class 0x060000
[    0.358694] pci 0000:00:02.0: [8086:9a49] type 00 class 0x030000
[    0.358702] pci 0000:00:02.0: reg 0x10: [mem 0x601c000000-0x601cffffff 64bit]
[    0.358706] pci 0000:00:02.0: reg 0x18: [mem 0x4000000000-0x400fffffff 64bit pref]
[    0.358710] pci 0000:00:02.0: reg 0x20: [io  0x3000-0x303f]
[    0.358723] pci 0000:00:02.0: BAR 2: assigned to efifb
[    0.358723] pci 0000:00:02.0: DMAR: Skip IOMMU disabling for graphics
[    0.358748] pci 0000:00:02.0: reg 0x344: [mem 0x00000000-0x00ffffff 64bit]
[    0.358749] pci 0000:00:02.0: VF(n) BAR0 space: [mem 0x00000000-0x06ffffff 64bit] (contains BAR0 for 7 VFs)
[    0.358752] pci 0000:00:02.0: reg 0x34c: [mem 0x00000000-0x1fffffff 64bit pref]
[    0.358753] pci 0000:00:02.0: VF(n) BAR2 space: [mem 0x00000000-0xdfffffff 64bit pref] (contains BAR2 for 7 VFs)
[    0.359373] pci 0000:00:04.0: [8086:9a03] type 00 class 0x118000
[    0.359389] pci 0000:00:04.0: reg 0x10: [mem 0x601d140000-0x601d15ffff 64bit]
[    0.360117] pci 0000:00:06.0: [8086:9a09] type 01 class 0x060400
[    0.360204] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.360238] pci 0000:00:06.0: PTM enabled (root), 4ns granularity
[    0.360945] pci 0000:00:07.0: [8086:9a27] type 01 class 0x060400
[    0.361563] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.361585] pci 0000:00:07.0: DPC: RP PIO log size 0 is invalid
[    0.361591] fbcon: Taking over console
[    0.361767] pci 0000:00:08.0: [8086:9a11] type 00 class 0x088000
[    0.361774] pci 0000:00:08.0: reg 0x10: [mem 0x601d190000-0x601d190fff 64bit]
[    0.362403] pci 0000:00:0d.0: [8086:9a13] type 00 class 0x0c0330
[    0.362415] pci 0000:00:0d.0: reg 0x10: [mem 0x601d170000-0x601d17ffff 64bit]
[    0.362468] pci 0000:00:0d.0: PME# supported from D3hot D3cold
[    0.363132] pci 0000:00:0d.3: [8086:9a1d] type 00 class 0x0c0340
[    0.363142] pci 0000:00:0d.3: reg 0x10: [mem 0x601d100000-0x601d13ffff 64bit]
[    0.363149] pci 0000:00:0d.3: reg 0x18: [mem 0x601d18f000-0x601d18ffff 64bit]
[    0.363184] pci 0000:00:0d.3: supports D1 D2
[    0.363185] pci 0000:00:0d.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.363822] pci 0000:00:14.0: [8086:a0ed] type 00 class 0x0c0330
[    0.363843] pci 0000:00:14.0: reg 0x10: [mem 0x601d160000-0x601d16ffff 64bit]
[    0.363929] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.364601] pci 0000:00:14.2: [8086:a0ef] type 00 class 0x050000
[    0.364620] pci 0000:00:14.2: reg 0x10: [mem 0x601d188000-0x601d18bfff 64bit]
[    0.364633] pci 0000:00:14.2: reg 0x18: [mem 0x601d18e000-0x601d18efff 64bit]
[    0.365298] pci 0000:00:14.3: [8086:a0f0] type 00 class 0x028000
[    0.365318] pci 0000:00:14.3: reg 0x10: [mem 0x601d184000-0x601d187fff 64bit]
[    0.365446] pci 0000:00:14.3: PME# supported from D0 D3hot D3cold
[    0.366089] pci 0000:00:16.0: [8086:a0e0] type 00 class 0x078000
[    0.366111] pci 0000:00:16.0: reg 0x10: [mem 0x601d18d000-0x601d18dfff 64bit]
[    0.366198] pci 0000:00:16.0: PME# supported from D3hot
[    0.366890] pci 0000:00:1c.0: [8086:a0bc] type 01 class 0x060400
[    0.366991] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.367024] pci 0000:00:1c.0: PTM enabled (root), 4ns granularity
[    0.367745] pci 0000:00:1f.0: [8086:a082] type 00 class 0x060100
[    0.368506] pci 0000:00:1f.3: [8086:a0c8] type 00 class 0x040380
[    0.368555] pci 0000:00:1f.3: reg 0x10: [mem 0x601d180000-0x601d183fff 64bit]
[    0.368625] pci 0000:00:1f.3: reg 0x20: [mem 0x601d000000-0x601d0fffff 64bit]
[    0.368741] pci 0000:00:1f.3: PME# supported from D3hot D3cold
[    0.369413] pci 0000:00:1f.4: [8086:a0a3] type 00 class 0x0c0500
[    0.369437] pci 0000:00:1f.4: reg 0x10: [mem 0x601d18c000-0x601d18c0ff 64bit]
[    0.369466] pci 0000:00:1f.4: reg 0x20: [io  0xefa0-0xefbf]
[    0.370135] pci 0000:00:1f.5: [8086:a0a4] type 00 class 0x0c8000
[    0.370153] pci 0000:00:1f.5: reg 0x10: [mem 0xfe010000-0xfe010fff]
[    0.370827] pci 0000:00:1f.6: [8086:15fc] type 00 class 0x020000
[    0.370866] pci 0000:00:1f.6: reg 0x10: [mem 0xae400000-0xae41ffff]
[    0.371089] pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
[    0.371851] pci 0000:04:00.0: [144d:a808] type 00 class 0x010802
[    0.371866] pci 0000:04:00.0: reg 0x10: [mem 0xae300000-0xae303fff 64bit]
[    0.372037] pci 0000:00:06.0: PCI bridge to [bus 04]
[    0.372039] pci 0000:00:06.0:   bridge window [mem 0xae300000-0xae3fffff]
[    0.372072] pci 0000:00:07.0: PCI bridge to [bus 20-49]
[    0.372075] pci 0000:00:07.0:   bridge window [mem 0xa2000000-0xae1fffff]
[    0.372079] pci 0000:00:07.0:   bridge window [mem 0x6000000000-0x601bffffff 64bit pref]
[    0.372151] pci 0000:0c:00.0: [10ec:522a] type 00 class 0xff0000
[    0.372174] pci 0000:0c:00.0: reg 0x10: [mem 0xae200000-0xae200fff]
[    0.372329] pci 0000:0c:00.0: supports D1 D2
[    0.372330] pci 0000:0c:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.372535] pci 0000:00:1c.0: PCI bridge to [bus 0c]
[    0.372539] pci 0000:00:1c.0:   bridge window [mem 0xae200000-0xae2fffff]
[    0.386852] ACPI: EC: interrupt unblocked
[    0.386852] ACPI: EC: event unblocked
[    0.386872] ACPI: EC: EC_CMD/EC_SC=0x66, EC_DATA=0x62
[    0.386872] ACPI: EC: GPE=0x6e
[    0.386873] ACPI: \_SB_.PC00.LPCB.EC__: Boot ECDT EC initialization complete
[    0.386874] ACPI: \_SB_.PC00.LPCB.EC__: EC: Used to handle transactions and events
[    0.386924] iommu: Default domain type: Translated 
[    0.386924] pci 0000:00:02.0: vgaarb: VGA device added: decodes=io+mem,owns=mem,locks=none
[    0.386924] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.386924] pci 0000:00:02.0: vgaarb: setting as boot device
[    0.386924] vgaarb: loaded
[    0.386924] pps_core: LinuxPPS API ver. 1 registered
[    0.386924] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.386924] PTP clock support registered
[    0.386924] EDAC MC: Ver: 3.0.0
[    0.387247] Registered efivars operations
[    0.387247] NetLabel: Initializing
[    0.387247] NetLabel:  domain hash size = 128
[    0.387247] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    0.387247] NetLabel:  unlabeled traffic allowed by default
[    0.387247] PCI: Using ACPI for IRQ routing
[    0.407681] PCI: pci_cache_line_size set to 64 bytes
[    0.407902] pci 0000:00:1f.5: can't claim BAR 0 [mem 0xfe010000-0xfe010fff]: no compatible bridge window
[    0.408262] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    0.408263] e820: reserve RAM buffer [mem 0x8764a000-0x87ffffff]
[    0.408263] e820: reserve RAM buffer [mem 0x87e23000-0x87ffffff]
[    0.408264] e820: reserve RAM buffer [mem 0x8b8ca000-0x8bffffff]
[    0.408264] e820: reserve RAM buffer [mem 0x93c00000-0x93ffffff]
[    0.408265] e820: reserve RAM buffer [mem 0x25f800000-0x25fffffff]
[    0.408269] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.408269] hpet0: 8 comparators, 64-bit 19.200000 MHz counter
[    0.409857] clocksource: Switched to clocksource tsc-early
[    0.416089] VFS: Disk quotas dquot_6.6.0
[    0.416099] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.416150] pnp: PnP ACPI init
[    0.416684] system 00:00: [io  0x0680-0x069f] has been reserved
[    0.416685] system 00:00: [io  0x164e-0x164f] has been reserved
[    0.416687] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.416756] system 00:01: [io  0x1854-0x1857] has been reserved
[    0.416757] system 00:01: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.416768] pnp 00:02: Plug and Play ACPI device, IDs LEN0071 PNP0303 (active)
[    0.416776] pnp 00:03: Plug and Play ACPI device, IDs LEN2146 PNP0f13 (active)
[    0.416791] pnp 00:04: disabling [mem 0xc0000000-0xcfffffff] because it overlaps 0000:00:02.0 BAR 9 [mem 0x00000000-0xdfffffff 64bit pref]
[    0.416812] system 00:04: [io  0x1800-0x189f] could not be reserved
[    0.416813] system 00:04: [io  0x0800-0x087f] has been reserved
[    0.416814] system 00:04: [io  0x0880-0x08ff] has been reserved
[    0.416815] system 00:04: [io  0x0900-0x097f] has been reserved
[    0.416815] system 00:04: [io  0x0980-0x09ff] has been reserved
[    0.416816] system 00:04: [io  0x0a00-0x0a7f] has been reserved
[    0.416817] system 00:04: [io  0x0a80-0x0aff] has been reserved
[    0.416818] system 00:04: [io  0x0b00-0x0b7f] has been reserved
[    0.416818] system 00:04: [io  0x0b80-0x0bff] has been reserved
[    0.416819] system 00:04: [mem 0xfe802000-0xfe8021ff] has been reserved
[    0.416820] system 00:04: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.416821] system 00:04: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.416821] system 00:04: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.416822] system 00:04: [mem 0xfeb00000-0xfebfffff] has been reserved
[    0.416823] system 00:04: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.416824] system 00:04: [mem 0xfed90000-0xfed93fff] could not be reserved
[    0.416825] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.417091] pnp 00:05: disabling [mem 0xc0000000-0xcfffffff] because it overlaps 0000:00:02.0 BAR 9 [mem 0x00000000-0xdfffffff 64bit pref]
[    0.417105] system 00:05: [mem 0xfedc0000-0xfedc7fff] has been reserved
[    0.417106] system 00:05: [mem 0xfeda0000-0xfeda0fff] has been reserved
[    0.417106] system 00:05: [mem 0xfeda1000-0xfeda1fff] has been reserved
[    0.417107] system 00:05: [mem 0xfed20000-0xfed7ffff] could not be reserved
[    0.417108] system 00:05: [mem 0xfed90000-0xfed93fff] could not be reserved
[    0.417109] system 00:05: [mem 0xfed45000-0xfed8ffff] could not be reserved
[    0.417109] system 00:05: [mem 0xfee00000-0xfeefffff] has been reserved
[    0.417111] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.417410] system 00:06: [io  0x1800-0x18fe] could not be reserved
[    0.417411] system 00:06: [mem 0xfe000000-0xfe01ffff] has been reserved
[    0.417411] system 00:06: [mem 0xfe04c000-0xfe04ffff] has been reserved
[    0.417412] system 00:06: [mem 0xfe050000-0xfe0affff] has been reserved
[    0.417413] system 00:06: [mem 0xfe0d0000-0xfe0fffff] has been reserved
[    0.417413] system 00:06: [mem 0xfe200000-0xfe7fffff] has been reserved
[    0.417414] system 00:06: [mem 0xff000000-0xffffffff] has been reserved
[    0.417415] system 00:06: [mem 0xfd000000-0xfd68ffff] has been reserved
[    0.417415] system 00:06: [mem 0xfd6b0000-0xfd6cffff] has been reserved
[    0.417416] system 00:06: [mem 0xfd6f0000-0xfdffffff] has been reserved
[    0.417418] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.417580] system 00:07: [io  0x2000-0x20fe] has been reserved
[    0.417581] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.417697] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.417851] pnp 00:09: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:02.0 BAR 7 [mem 0x00000000-0x06ffffff 64bit]
[    0.417852] pnp 00:09: disabling [mem 0x000c0000-0x000c3fff] because it overlaps 0000:00:02.0 BAR 7 [mem 0x00000000-0x06ffffff 64bit]
[    0.417852] pnp 00:09: disabling [mem 0x000c8000-0x000cbfff] because it overlaps 0000:00:02.0 BAR 7 [mem 0x00000000-0x06ffffff 64bit]
[    0.417853] pnp 00:09: disabling [mem 0x000d0000-0x000d3fff] because it overlaps 0000:00:02.0 BAR 7 [mem 0x00000000-0x06ffffff 64bit]
[    0.417854] pnp 00:09: disabling [mem 0x000d8000-0x000dbfff] because it overlaps 0000:00:02.0 BAR 7 [mem 0x00000000-0x06ffffff 64bit]
[    0.417854] pnp 00:09: disabling [mem 0x000e0000-0x000e3fff] because it overlaps 0000:00:02.0 BAR 7 [mem 0x00000000-0x06ffffff 64bit]
[    0.417855] pnp 00:09: disabling [mem 0x000e8000-0x000ebfff] because it overlaps 0000:00:02.0 BAR 7 [mem 0x00000000-0x06ffffff 64bit]
[    0.417856] pnp 00:09: disabling [mem 0x000f0000-0x000fffff] because it overlaps 0000:00:02.0 BAR 7 [mem 0x00000000-0x06ffffff 64bit]
[    0.417856] pnp 00:09: disabling [mem 0x00100000-0xa07fffff] because it overlaps 0000:00:02.0 BAR 7 [mem 0x00000000-0x06ffffff 64bit]
[    0.417857] pnp 00:09: disabling [mem 0x00000000-0x0009ffff disabled] because it overlaps 0000:00:02.0 BAR 9 [mem 0x00000000-0xdfffffff 64bit pref]
[    0.417858] pnp 00:09: disabling [mem 0x000c0000-0x000c3fff disabled] because it overlaps 0000:00:02.0 BAR 9 [mem 0x00000000-0xdfffffff 64bit pref]
[    0.417859] pnp 00:09: disabling [mem 0x000c8000-0x000cbfff disabled] because it overlaps 0000:00:02.0 BAR 9 [mem 0x00000000-0xdfffffff 64bit pref]
[    0.417860] pnp 00:09: disabling [mem 0x000d0000-0x000d3fff disabled] because it overlaps 0000:00:02.0 BAR 9 [mem 0x00000000-0xdfffffff 64bit pref]
[    0.417860] pnp 00:09: disabling [mem 0x000d8000-0x000dbfff disabled] because it overlaps 0000:00:02.0 BAR 9 [mem 0x00000000-0xdfffffff 64bit pref]
[    0.417861] pnp 00:09: disabling [mem 0x000e0000-0x000e3fff disabled] because it overlaps 0000:00:02.0 BAR 9 [mem 0x00000000-0xdfffffff 64bit pref]
[    0.417862] pnp 00:09: disabling [mem 0x000e8000-0x000ebfff disabled] because it overlaps 0000:00:02.0 BAR 9 [mem 0x00000000-0xdfffffff 64bit pref]
[    0.417862] pnp 00:09: disabling [mem 0x000f0000-0x000fffff disabled] because it overlaps 0000:00:02.0 BAR 9 [mem 0x00000000-0xdfffffff 64bit pref]
[    0.417863] pnp 00:09: disabling [mem 0x00100000-0xa07fffff disabled] because it overlaps 0000:00:02.0 BAR 9 [mem 0x00000000-0xdfffffff 64bit pref]
[    0.417874] system 00:09: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.417875] system 00:09: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.417876] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.417954] pnp: PnP ACPI: found 10 devices
[    0.423166] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.423196] NET: Registered protocol family 2
[    0.423290] tcp_listen_portaddr_hash hash table entries: 4096 (order: 4, 65536 bytes, linear)
[    0.423300] TCP established hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    0.423350] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes, linear)
[    0.423444] TCP: Hash tables configured (established 65536 bind 65536)
[    0.423487] MPTCP token hash table entries: 8192 (order: 5, 196608 bytes, linear)
[    0.423504] UDP hash table entries: 4096 (order: 5, 131072 bytes, linear)
[    0.423517] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes, linear)
[    0.423555] NET: Registered protocol family 1
[    0.423559] NET: Registered protocol family 44
[    0.423562] pci_bus 0000:00: max bus depth: 1 pci_try_num: 2
[    0.423568] pci 0000:00:02.0: BAR 9: assigned [mem 0x4020000000-0x40ffffffff 64bit pref]
[    0.423570] pci 0000:00:02.0: BAR 7: assigned [mem 0x4010000000-0x4016ffffff 64bit]
[    0.423572] pci 0000:00:07.0: BAR 13: assigned [io  0x4000-0x4fff]
[    0.423573] pci 0000:00:1f.5: BAR 0: assigned [mem 0xa0800000-0xa0800fff]
[    0.423586] pci 0000:00:06.0: PCI bridge to [bus 04]
[    0.423595] pci 0000:00:06.0:   bridge window [mem 0xae300000-0xae3fffff]
[    0.423600] pci 0000:00:07.0: PCI bridge to [bus 20-49]
[    0.423601] pci 0000:00:07.0:   bridge window [io  0x4000-0x4fff]
[    0.423604] pci 0000:00:07.0:   bridge window [mem 0xa2000000-0xae1fffff]
[    0.423606] pci 0000:00:07.0:   bridge window [mem 0x6000000000-0x601bffffff 64bit pref]
[    0.423610] pci 0000:00:1c.0: PCI bridge to [bus 0c]
[    0.423614] pci 0000:00:1c.0:   bridge window [mem 0xae200000-0xae2fffff]
[    0.423621] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.423622] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.423622] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.423623] pci_bus 0000:00: resource 7 [mem 0xa0800000-0xbfffffff window]
[    0.423623] pci_bus 0000:00: resource 8 [mem 0x4000000000-0x7fffffffff window]
[    0.423624] pci_bus 0000:04: resource 1 [mem 0xae300000-0xae3fffff]
[    0.423625] pci_bus 0000:20: resource 0 [io  0x4000-0x4fff]
[    0.423625] pci_bus 0000:20: resource 1 [mem 0xa2000000-0xae1fffff]
[    0.423626] pci_bus 0000:20: resource 2 [mem 0x6000000000-0x601bffffff 64bit pref]
[    0.423627] pci_bus 0000:0c: resource 1 [mem 0xae200000-0xae2fffff]
[    0.423711] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.424339] PCI: CLS 0 bytes, default 64
[    0.424360] Trying to unpack rootfs image as initramfs...
[    0.592483] Freeing initrd memory: 17772K
[    0.592490] DMAR: Intel-IOMMU force enabled due to platform opt in
[    0.592504] DMAR: No ATSR found
[    0.592542] DMAR: dmar1: Using Queued invalidation
[    0.592545] DMAR: dmar0: Using Queued invalidation
[    0.592547] DMAR: dmar2: Using Queued invalidation
[    0.592672] pci 0000:00:00.0: Adding to iommu group 0
[    0.592678] pci 0000:00:02.0: Adding to iommu group 1
[    0.592683] pci 0000:00:04.0: Adding to iommu group 2
[    0.592696] pci 0000:00:06.0: Adding to iommu group 3
[    0.592704] pci 0000:00:07.0: Adding to iommu group 4
[    0.592709] pci 0000:00:08.0: Adding to iommu group 5
[    0.592717] pci 0000:00:0d.0: Adding to iommu group 6
[    0.592722] pci 0000:00:0d.3: Adding to iommu group 6
[    0.592730] pci 0000:00:14.0: Adding to iommu group 7
[    0.592735] pci 0000:00:14.2: Adding to iommu group 7
[    0.592739] pci 0000:00:14.3: Adding to iommu group 8
[    0.592746] pci 0000:00:16.0: Adding to iommu group 9
[    0.592755] pci 0000:00:1c.0: Adding to iommu group 10
[    0.592768] pci 0000:00:1f.0: Adding to iommu group 11
[    0.592773] pci 0000:00:1f.3: Adding to iommu group 11
[    0.592778] pci 0000:00:1f.4: Adding to iommu group 11
[    0.592783] pci 0000:00:1f.5: Adding to iommu group 11
[    0.592787] pci 0000:00:1f.6: Adding to iommu group 11
[    0.592799] pci 0000:04:00.0: Adding to iommu group 12
[    0.592808] pci 0000:0c:00.0: Adding to iommu group 13
[    0.592914] DMAR: Intel(R) Virtualization Technology for Directed I/O
[    0.592915] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.592916] software IO TLB: mapped [mem 0x00000000828a4000-0x00000000868a4000] (64MB)
[    0.592970] resource sanity check: requesting [mem 0xfedc0000-0xfedcdfff], which spans more than pnp 00:05 [mem 0xfedc0000-0xfedc7fff]
[    0.592974] caller tgl_uncore_imc_freerunning_init_box+0xbb/0x100 mapping multiple BARs
[    0.593108] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x22df1149949, max_idle_ns: 440795312789 ns
[    0.593124] clocksource: Switched to clocksource tsc
[    0.593137] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.593238] check: Scanning for low memory corruption every 60 seconds
[    0.593268] simple-framebuffer simple-framebuffer.0: framebuffer at 0x4000000000, 0x1d5000 bytes, mapped to 0x00000000d8f01ce3
[    0.593269] simple-framebuffer simple-framebuffer.0: format=a8r8g8b8, mode=800x600x32, linelength=3200
[    0.593315] Console: switching to colour frame buffer device 100x37
[    0.594315] simple-framebuffer simple-framebuffer.0: fb0: simplefb registered!
[    0.594530] Initialise system trusted keyrings
[    0.594553] workingset: timestamp_bits=40 max_order=21 bucket_order=0
[    0.594592] zbud: loaded
[    0.601993] Key type asymmetric registered
[    0.601994] Asymmetric key parser 'x509' registered
[    0.601997] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 247)
[    0.602034] io scheduler mq-deadline registered
[    0.602039] io scheduler bfq registered
[    0.602302] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
[    0.602302] crc32: self tests passed, processed 225944 bytes in 120335 nsec
[    0.602424] crc32c: CRC_LE_BITS = 64
[    0.602424] crc32c: self tests passed, processed 225944 bytes in 60133 nsec
[    0.612264] crc32_combine: 8373 self tests passed
[    0.622106] crc32c_combine: 8373 self tests passed
[    0.622426] pcieport 0000:00:06.0: PME: Signaling with IRQ 123
[    0.622487] pcieport 0000:00:06.0: bw_notification: enabled with IRQ 123
[    0.622650] pcieport 0000:00:07.0: PME: Signaling with IRQ 124
[    0.622664] pcieport 0000:00:07.0: pciehp: Slot #0 AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+ Interlock- NoCompl+ IbPresDis- LLActRep+
[    0.622738] pcieport 0000:00:07.0: bw_notification: enabled with IRQ 124
[    0.622900] pcieport 0000:00:1c.0: PME: Signaling with IRQ 125
[    0.622950] pcieport 0000:00:1c.0: bw_notification: enabled with IRQ 125
[    0.623049] intel_idle: MWAIT substates: 0x11121020
[    0.623188] Monitor-Mwait will be used to enter C-1 state
[    0.623208] Monitor-Mwait will be used to enter C-2 state
[    0.623228] Monitor-Mwait will be used to enter C-3 state
[    0.623239] ACPI: \_SB_.PR00: Found 3 idle states
[    0.623240] intel_idle: v0.5.1 model 0x8C
[    0.623430] intel_idle: Local APIC timer is reliable in all C-states
[    0.624860] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.625445] Linux agpgart interface v0.103
[    0.627071] tpm_tis STM0125:00: 2.0 TPM (device-id 0x0, rev-id 78)
[    0.638131] brd: module loaded
[    0.638704] loop: module loaded
[    0.638993] nvme 0000:04:00.0: platform quirk: setting simple suspend
[    0.639040] nvme nvme0: pci function 0000:04:00.0
[    0.639134] libphy: Fixed MDIO Bus: probed
[    0.639153] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.646689] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.646706] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.646769] mousedev: PS/2 mouse device common for all mice
[    0.646828] rtc_cmos rtc_cmos: RTC can wake from S4
[    0.647413] rtc_cmos rtc_cmos: registered as rtc0
[    0.647614] rtc_cmos rtc_cmos: setting system clock to 2021-03-10T10:45:53 UTC (1615373153)
[    0.647622] rtc_cmos rtc_cmos: alarms up to one month, y3k, 114 bytes nvram
[    0.647630] intel_pstate: Intel P-state driver initializing
[    0.648037] intel_pstate: HWP enabled
[    0.648091] ledtrig-cpu: registered to indicate activity on CPUs
[    0.648169] NET: Registered protocol family 10
[    0.648285] Segment Routing with IPv6
[    0.648286] RPL Segment Routing with IPv6
[    0.648819] microcode: sig=0x806c1, pf=0x80, revision=0x60
[    0.648886] microcode: Microcode Update Driver: v2.2.
[    0.648889] IPI shorthand broadcast: enabled
[    0.648895] sched_clock: Marking stable (644150729, 4730577)->(659549347, -10668041)
[    0.648958] registered taskstats version 1
[    0.648960] Loading compiled-in X.509 certificates
[    0.649319] nvme nvme0: missing or invalid SUBNQN field.
[    0.649330] nvme nvme0: Shutdown timeout set to 8 seconds
[    0.649470] Loaded X.509 cert 'Build time autogenerated kernel key: 1ddde602435fcc3b204c34e417bb3ebcfe708f0a'
[    0.650410] zswap: loaded using pool zstd/zbud
[    0.650528] Key type ._fscrypt registered
[    0.650529] Key type .fscrypt registered
[    0.650529] Key type fscrypt-provisioning registered
[    0.651990] Key type encrypted registered
[    0.651996] ima: Allocated hash algorithm: sha1
[    0.659661] nvme nvme0: 8/0/0 default/read/poll queues
[    0.662062]  nvme0n1: p1 p2
[    0.668679] ima: No architecture policies found
[    0.668686] evm: Initialising EVM extended attributes:
[    0.668687] evm: security.selinux
[    0.668687] evm: security.SMACK64
[    0.668687] evm: security.SMACK64EXEC
[    0.668688] evm: security.SMACK64TRANSMUTE
[    0.668688] evm: security.SMACK64MMAP
[    0.668688] evm: security.apparmor
[    0.668689] evm: security.ima
[    0.668689] evm: security.capability
[    0.668689] evm: HMAC attrs: 0x1
[    0.674523] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.686847] Freeing unused decrypted memory: 2036K
[    0.687134] Freeing unused kernel image (initmem) memory: 1688K
[    0.688889] Write protecting the kernel read-only data: 22528k
[    0.689483] Freeing unused kernel image (text/rodata gap) memory: 2036K
[    0.689650] Freeing unused kernel image (rodata/data gap) memory: 384K
[    0.689655] rodata_test: all tests were successful
[    0.689659] Run /init as init process
[    0.689660]   with arguments:
[    0.689660]     /init
[    0.689661]     splash
[    0.689661]   with environment:
[    0.689662]     HOME=/
[    0.689662]     TERM=linux
[    0.689663]     BOOT_IMAGE=/boot/vmlinuz
[    1.119089] device-mapper: uevent: version 1.0.3
[    1.119143] device-mapper: ioctl: 4.43.0-ioctl (2020-10-01) initialised: dm-devel@redhat.com
[    1.170928] udevd[465]: Starting version v243.9-alt1
[    1.172080] udevd[467]: /etc/udev/rules.d/50-udev-default.rules:24 The line takes no effect, ignoring.
[    1.172088] udevd[467]: /etc/udev/rules.d/50-udev-default.rules:25 The line takes no effect, ignoring.
[    1.172098] udevd[467]: /etc/udev/rules.d/50-udev-default.rules:29 The line takes no effect, ignoring.
[    1.172106] udevd[467]: /etc/udev/rules.d/50-udev-default.rules:32 The line takes no effect, ignoring.
[    1.172110] udevd[467]: /etc/udev/rules.d/50-udev-default.rules:33 The line takes no effect, ignoring.
[    1.172115] udevd[467]: /etc/udev/rules.d/50-udev-default.rules:34 The line takes no effect, ignoring.
[    1.172119] udevd[467]: /etc/udev/rules.d/50-udev-default.rules:35 The line takes no effect, ignoring.
[    1.172123] udevd[467]: /etc/udev/rules.d/50-udev-default.rules:36 The line takes no effect, ignoring.
[    1.172127] udevd[467]: /etc/udev/rules.d/50-udev-default.rules:37 The line takes no effect, ignoring.
[    1.316752] i915 0000:00:02.0: enabling device (0006 -> 0007)
[    1.317603] i915 0000:00:02.0: [drm] VT-d active for gfx access
[    1.317606] checking generic (4000000000 1d5000) vs hw (601c000000 1000000)
[    1.317607] checking generic (4000000000 1d5000) vs hw (4000000000 10000000)
[    1.317607] fb0: switching to inteldrmfb from simple
[    1.317812] Console: switching to colour dummy device 80x25
[    1.317824] i915 0000:00:02.0: vgaarb: deactivate vga console
[    1.319297] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=mem
[    1.319353] i915 0000:00:02.0: Direct firmware load for i915/tgl_dmc_ver2_08.bin failed with error -2
[    1.319355] i915 0000:00:02.0: [drm] Failed to load DMC firmware i915/tgl_dmc_ver2_08.bin. Disabling runtime power management.
[    1.319355] i915 0000:00:02.0: [drm] DMC firmware homepage: https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/i915
[    2.583459] [drm] Initialized i915 1.6.0 20200917 for 0000:00:02.0 on minor 0
[    2.586378] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.587138] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input2
[    2.590346] fbcon: i915drmfb (fb0) is primary device
[    2.598374] Console: switching to colour frame buffer device 240x67
[    2.621445] i915 0000:00:02.0: [drm] fb0: i915drmfb frame buffer device
[    3.006674] random: lvm: uninitialized urandom read (4 bytes read)
[    3.040697] random: lvm: uninitialized urandom read (4 bytes read)
[    3.052899] random: plymouthd: uninitialized urandom read (8 bytes read)
[    3.096298] PM: Image not found (code -22)
[    3.122124] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[    6.159349] printk: udevd: 81 output lines suppressed due to ratelimiting
[    7.845335] random: fast init done
[    7.863987] systemd[1]: Inserted module 'autofs4'
[    7.912287] systemd[1]: systemd v243.9-alt1 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=hybrid)
[    7.924865] systemd[1]: Detected architecture x86-64.
[    7.931439] systemd[1]: Set hostname to <comp-gen-intel-a2414c>.
[    7.960315] random: lvmconfig: uninitialized urandom read (4 bytes read)
[    7.978627] systemd[1]: /lib/systemd/system/smb.service:10: PIDFile= references a path below legacy directory /var/run/, updating /var/run/smbd.pid → /run/smbd.pid; please update the unit file accordingly.
[    7.978780] systemd[1]: /lib/systemd/system/winbind.service:9: PIDFile= references a path below legacy directory /var/run/, updating /var/run/winbindd.pid → /run/winbindd.pid; please update the unit file accordingly.
[    7.980557] systemd[1]: /lib/systemd/system/nmb.service:10: PIDFile= references a path below legacy directory /var/run/, updating /var/run/nmbd.pid → /run/nmbd.pid; please update the unit file accordingly.
[    7.991567] systemd[1]: /lib/systemd/system/org.cups.cupsd.socket:6: ListenStream= references a path below legacy directory /var/run/, updating /var/run/cups/cups.sock → /run/cups/cups.sock; please update the unit file accordingly.
[    7.991741] systemd[1]: /lib/systemd/system/alteratord.socket:6: ListenStream= references a path below legacy directory /var/run/, updating /var/run/alteratord/.socket → /run/alteratord/.socket; please update the unit file accordingly.
[    7.993261] systemd[1]: Created slice User and Session Slice.
[    7.993376] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    8.002364] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input3
[    8.006865] ACPI: Sleep Button [SLPB]
[    8.006913] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input4
[    8.006979] ACPI: Lid Switch [LID]
[    8.007004] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[    8.007039] ACPI: Power Button [PWRF]
[    8.015441] EXT4-fs (dm-1): re-mounted. Opts: (null)
[    8.019327] vboxguest: loading out-of-tree module taints kernel.
[    8.019440] vboxguest: module verification failed: signature and/or required key missing - tainting kernel
[    8.021633] vboxguest: PCI device not found, probably running on physical hardware.
[    8.052475] vboxdrv: Found 8 processor cores
[    8.068193] vboxdrv: TSC mode is Invariant, tentative frequency 2419200705 Hz
[    8.068193] vboxdrv: Successfully loaded version 6.1.18 (interface 0x00300000)
[    8.068707] VBoxNetFlt: Successfully started.
[    8.069074] VBoxNetAdp: Successfully started.
[    8.175552] systemd-journald[2545]: Received client request to flush runtime journal.
[    8.240381] proc_thermal 0000:00:04.0: enabling device (0000 -> 0002)
[    8.242835] ACPI: bus type USB registered
[    8.242858] usbcore: registered new interface driver usbfs
[    8.242864] usbcore: registered new interface driver hub
[    8.242874] usbcore: registered new device driver usb
[    8.243695] intel_rapl_common: Found RAPL domain package
[    8.246524] proc_thermal 0000:00:04.0: Creating sysfs group for PROC_THERMAL_PCI
[    8.247842] ACPI: AC Adapter [ADP1] (on-line)
[    8.248451] mei_me 0000:00:16.0: enabling device (0000 -> 0002)
[    8.248560] rtsx_pci 0000:0c:00.0: enabling device (0000 -> 0002)
[    8.251589] xhci_hcd 0000:00:0d.0: xHCI Host Controller
[    8.251594] xhci_hcd 0000:00:0d.0: new USB bus registered, assigned bus number 1
[    8.252330] intel_pmc_core INT33A1:00:  initialized
[    8.252660] xhci_hcd 0000:00:0d.0: hcc params 0x20007fc1 hci version 0x120 quirks 0x0000000200009810
[    8.252664] xhci_hcd 0000:00:0d.0: cache line size of 64 is not supported
[    8.252897] hub 1-0:1.0: USB hub found
[    8.252904] hub 1-0:1.0: 1 port detected
[    8.252993] ACPI Warning: \_SB.PC00.TXHC.RHUB.HS01._UPC: Found unexpected NULL package element (20200925/nsrepair-186)
[    8.252996] ACPI Warning: \_SB.PC00.TXHC.RHUB.HS01._UPC: Found unexpected NULL package element (20200925/nsrepair-186)
[    8.253147] xhci_hcd 0000:00:0d.0: xHCI Host Controller
[    8.253151] xhci_hcd 0000:00:0d.0: new USB bus registered, assigned bus number 2
[    8.253155] xhci_hcd 0000:00:0d.0: Host supports USB 3.1 Enhanced SuperSpeed
[    8.253271] random: lvm: uninitialized urandom read (4 bytes read)
[    8.253279] hub 2-0:1.0: USB hub found
[    8.253289] hub 2-0:1.0: 4 ports detected
[    8.253357] ACPI Warning: \_SB.PC00.TXHC.RHUB.SS01._UPC: Found unexpected NULL package element (20200925/nsrepair-186)
[    8.253359] ACPI Warning: \_SB.PC00.TXHC.RHUB.SS01._UPC: Found unexpected NULL package element (20200925/nsrepair-186)
[    8.253417] ACPI Warning: \_SB.PC00.TXHC.RHUB.SS02._UPC: Found unexpected NULL package element (20200925/nsrepair-186)
[    8.253419] ACPI Warning: \_SB.PC00.TXHC.RHUB.SS02._UPC: Found unexpected NULL package element (20200925/nsrepair-186)
[    8.253475] ACPI Warning: \_SB.PC00.TXHC.RHUB.SS03._UPC: Found unexpected NULL package element (20200925/nsrepair-186)
[    8.253476] ACPI Warning: \_SB.PC00.TXHC.RHUB.SS03._UPC: Found unexpected NULL package element (20200925/nsrepair-186)
[    8.253527] ACPI Warning: \_SB.PC00.TXHC.RHUB.SS04._UPC: Found unexpected NULL package element (20200925/nsrepair-186)
[    8.253529] ACPI Warning: \_SB.PC00.TXHC.RHUB.SS04._UPC: Found unexpected NULL package element (20200925/nsrepair-186)
[    8.253537] usb: port power management may be unreliable
[    8.253779] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    8.253782] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    8.257208] xhci_hcd 0000:00:14.0: hcc params 0x20007fc1 hci version 0x120 quirks 0x0000000000009810
[    8.257215] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    8.257541] hub 3-0:1.0: USB hub found
[    8.257564] hub 3-0:1.0: 12 ports detected
[    8.257650] ACPI Warning: \_SB.PC00.XHCI.RHUB.HS01._UPC: Found unexpected NULL package element (20200925/nsrepair-186)
[    8.257653] ACPI Warning: \_SB.PC00.XHCI.RHUB.HS01._UPC: Found unexpected NULL package element (20200925/nsrepair-186)
[    8.257719] ACPI Warning: \_SB.PC00.XHCI.RHUB.HS02._UPC: Found unexpected NULL package element (20200925/nsrepair-186)
[    8.257721] ACPI Warning: \_SB.PC00.XHCI.RHUB.HS02._UPC: Found unexpected NULL package element (20200925/nsrepair-186)
[    8.262320] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    8.262324] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    8.262328] xhci_hcd 0000:00:14.0: Host supports USB 3.1 Enhanced SuperSpeed
[    8.262481] hub 4-0:1.0: USB hub found
[    8.262492] hub 4-0:1.0: 4 ports detected
[    8.280183] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    8.280433] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    8.281217] cfg80211: loaded regulatory.db is malformed or signature is missing/invalid
[    8.281358] FAT-fs (nvme0n1p1): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[    8.284183] Intel(R) Wireless WiFi driver for Linux
[    8.284235] iwlwifi 0000:00:14.3: enabling device (0000 -> 0002)
[    8.284988] FAT-fs (nvme0n1p1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[    8.285770] iwlwifi 0000:00:14.3: Direct firmware load for iwlwifi-QuZ-a0-hr-b0-59.ucode failed with error -2
[    8.286255] iwlwifi 0000:00:14.3: Direct firmware load for iwlwifi-QuZ-a0-hr-b0-58.ucode failed with error -2
[    8.286268] iwlwifi 0000:00:14.3: Direct firmware load for iwlwifi-QuZ-a0-hr-b0-57.ucode failed with error -2
[    8.286277] iwlwifi 0000:00:14.3: Direct firmware load for iwlwifi-QuZ-a0-hr-b0-56.ucode failed with error -2
[    8.286288] iwlwifi 0000:00:14.3: Direct firmware load for iwlwifi-QuZ-a0-hr-b0-55.ucode failed with error -2
[    8.286298] iwlwifi 0000:00:14.3: Direct firmware load for iwlwifi-QuZ-a0-hr-b0-54.ucode failed with error -2
[    8.286308] iwlwifi 0000:00:14.3: Direct firmware load for iwlwifi-QuZ-a0-hr-b0-53.ucode failed with error -2
[    8.286317] iwlwifi 0000:00:14.3: Direct firmware load for iwlwifi-QuZ-a0-hr-b0-52.ucode failed with error -2
[    8.286328] iwlwifi 0000:00:14.3: Direct firmware load for iwlwifi-QuZ-a0-hr-b0-51.ucode failed with error -2
[    8.286338] iwlwifi 0000:00:14.3: Direct firmware load for iwlwifi-QuZ-a0-hr-b0-50.ucode failed with error -2
[    8.286347] iwlwifi 0000:00:14.3: Direct firmware load for iwlwifi-QuZ-a0-hr-b0-49.ucode failed with error -2
[    8.287153] iwlwifi 0000:00:14.3: TLV_FW_FSEQ_VERSION: FSEQ Version: 43.2.23.17
[    8.287157] iwlwifi 0000:00:14.3: Found debug destination: EXTERNAL_DRAM
[    8.287160] iwlwifi 0000:00:14.3: Found debug configuration: 0
[    8.287303] iwlwifi 0000:00:14.3: loaded firmware version 48.4fa0041f.0 QuZ-a0-hr-b0-48.ucode op_mode iwlmvm
[    8.289742] wl: module license 'Propriretary' taints kernel.
[    8.289743] Disabling lock debugging due to kernel taint
[    8.314674] battery: ACPI: Battery Slot [BAT0] (battery present)
[    8.315889] Non-volatile memory driver v1.3
[    8.318401] thinkpad_acpi: ThinkPad ACPI Extras v0.26
[    8.318401] thinkpad_acpi: http://ibm-acpi.sf.net/
[    8.318402] thinkpad_acpi: ThinkPad BIOS R1FET29W (1.03 ), EC R1FHT25W
[    8.318402] thinkpad_acpi: Lenovo ThinkPad L13 Gen 2, model 20VH001WRT
[    8.318747] thinkpad_acpi: radio switch found; radios are enabled
[    8.318763] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    8.318764] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    8.339828] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    8.344844] thinkpad_acpi: battery 1 registered (start 0, stop 100)
[    8.344849] battery: new extension: ThinkPad Battery Extension
[    8.345544] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
[    8.346498] iwlwifi 0000:00:14.3: Detected Intel(R) Wi-Fi 6 AX201 160MHz, REV=0x354
[    8.347300] acpi PNP0C14:01: duplicate WMI GUID 05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:00)
[    8.347340] acpi PNP0C14:02: duplicate WMI GUID 05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:00)
[    8.347409] acpi PNP0C14:03: duplicate WMI GUID 05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:00)
[    8.347449] acpi PNP0C14:04: duplicate WMI GUID 05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:00)
[    8.347479] acpi PNP0C14:05: duplicate WMI GUID 05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:00)
[    8.347508] acpi PNP0C14:06: duplicate WMI GUID 05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:00)
[    8.347561] acpi PNP0C14:07: duplicate WMI GUID 05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:00)
[    8.358470] iwlwifi 0000:00:14.3: Applying debug destination EXTERNAL_DRAM
[    8.358608] iwlwifi 0000:00:14.3: Allocated 0x00400000 bytes for firmware monitor.
[    8.382827] thermal LNXTHERM:00: registered as thermal_zone8
[    8.382829] ACPI: Thermal Zone [THM0] (47 C)
[    8.390596] i801_smbus 0000:00:1f.4: enabling device (0001 -> 0003)
[    8.390772] i801_smbus 0000:00:1f.4: SPD Write Disable is set
[    8.390823] i801_smbus 0000:00:1f.4: SMBus using PCI interrupt
[    8.391350] i2c i2c-14: 2/8 memory slots populated (from DMI)
[    8.391351] i2c i2c-14: Systems with more than 4 memory slots not supported yet, not instantiating SPD
[    8.392589] e1000e: Intel(R) PRO/1000 Network Driver - 3.8.7-NAPI
[    8.392590] e1000e: Copyright(c) 1999 - 2020 Intel Corporation.
[    8.392810] e1000e-ext 0000:00:1f.6: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    8.393524] intel-spi 0000:00:1f.5: mx25l25635e (32768 Kbytes)
[    8.395979] Creating 1 MTD partitions on "0000:00:1f.5":
[    8.395981] 0x000000000000-0x000002000000 : "BIOS"
[    8.432415] snd_hda_intel 0000:00:1f.3: DSP detected with PCI class/subclass/prog-if info 0x040380
[    8.433535] snd_hda_intel 0000:00:1f.3: bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
[    8.435116] pstore: Using crash dump compression: zstd
[    8.435132] pstore: Registered efi as persistent store backend
[    8.464095] input: PC Speaker as /devices/platform/pcspkr/input/input8
[    8.466442] cryptd: max_cpu_qlen set to 1000
[    8.469647] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC257: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
[    8.469649] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    8.469650] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=1 (0x21/0x0/0x0/0x0/0x0)
[    8.469650] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
[    8.469651] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[    8.469652] snd_hda_codec_realtek hdaudioC0D0:      Mic=0x19
[    8.469653] snd_hda_codec_realtek hdaudioC0D0:      Internal Mic=0x12
[    8.470086] AVX2 version of gcm_enc/dec engaged.
[    8.470087] AES CTR mode by8 optimization enabled
[    8.508399] iwlwifi 0000:00:14.3: base HW address: 94:e7:0b:10:30:1f
[    8.521179] thermal thermal_zone9: failed to read out thermal zone (-61)
[    8.525725] ioremap error for 0x930c7000-0x930c8000, requested 0x2, got 0x0
[    8.526485] ucsi_acpi: probe of USBC000:00 failed with error -12
[    8.549411] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1f.3/sound/card0/input9
[    8.549463] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1f.3/sound/card0/input10
[    8.549498] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1f.3/sound/card0/input11
[    8.549527] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input12
[    8.549553] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input13
[    8.549580] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input14
[    8.549611] input: HDA Intel PCH HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input15
[    8.549642] input: HDA Intel PCH HDMI/DP,pcm=10 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input16
[    8.549668] input: HDA Intel PCH HDMI/DP,pcm=11 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input17
[    8.549696] input: HDA Intel PCH HDMI/DP,pcm=12 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input18
[    8.549720] input: HDA Intel PCH HDMI/DP,pcm=13 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input19
[    8.549746] input: HDA Intel PCH HDMI/DP,pcm=14 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input20
[    8.549776] input: HDA Intel PCH HDMI/DP,pcm=15 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input21
[    8.549806] input: HDA Intel PCH HDMI/DP,pcm=16 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input22
[    8.584848] usb 3-5: new high-speed USB device number 2 using xhci_hcd
[    8.593980] intel_rapl_msr: PL4 support detected.
[    8.594010] intel_rapl_common: Found RAPL domain package
[    8.594011] intel_rapl_common: Found RAPL domain core
[    8.594013] intel_rapl_common: Found RAPL domain uncore
[    8.594014] intel_rapl_common: Found RAPL domain psys
[    8.603738] mei_hdcp 0000:00:16.0-b638ab7e-94e2-4ea2-a552-d1c54b627f04: bound 0000:00:02.0 (ops i915_hdcp_component_ops [i915])
[    8.607851] Adding 8191996k swap on /dev/mapper/alt-swap.  Priority:-2 extents:1 across:8191996k SSFS
[    8.626604] iTCO_vendor_support: vendor-support=0
[    8.629041] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    8.629112] iTCO_wdt: Found a Intel PCH TCO device (Version=6, TCOBASE=0x0400)
[    8.629184] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    8.632758] random: alsactl: uninitialized urandom read (4 bytes read)
[    8.849651] e1000e-ext 0000:00:1f.6 0000:00:1f.6 (uninitialized): registered PHC clock
[    8.883848] usb 3-6: new full-speed USB device number 3 using xhci_hcd
[    8.936197] e1000e-ext 0000:00:1f.6 eth0: (PCI Express:2.5GT/s:Width x1) 48:2a:e3:a2:41:4c
[    8.936202] e1000e-ext 0000:00:1f.6 eth0: Intel(R) PRO/1000 Network Connection
[    8.936395] e1000e-ext 0000:00:1f.6 eth0: MAC: 13, PHY: 12, PBA No: FFFFFF-0FF
[    9.009618] psmouse serio1: elantech: assuming hardware version 4 (with firmware version 0x5f3001)
[    9.021563] psmouse serio1: elantech: Synaptics capabilities query result 0x90, 0x18, 0x0d.
[    9.034476] psmouse serio1: elantech: Elan sample query result 00, 0d, a7
[    9.044704] iwlwifi 0000:00:14.3: Applying debug destination EXTERNAL_DRAM
[    9.046789] psmouse serio1: elantech: Elan ic body: 0x11, current fw version: 0x2
[    9.110867] random: crng init done
[    9.110869] random: 4 urandom warning(s) missed due to ratelimiting
[    9.118932] psmouse serio1: elantech: Trying to set up SMBus access
[    9.121649] elan_i2c 14-0015: supply vcc not found, using dummy regulator
[    9.127846] usb 3-7: new full-speed USB device number 4 using xhci_hcd
[    9.130930] elan_i2c 14-0015: Elan Touchpad: Module ID: 0x000d, Firmware: 0x0001, Sample: 0x0000, IAP: 0x0000
[    9.131007] input: Elan Touchpad as /devices/pci0000:00/0000:00:1f.4/i2c-14/14-0015/input/input23
[    9.131078] input: Elan TrackPoint as /devices/pci0000:00/0000:00:1f.4/i2c-14/14-0015/input/input24
[    9.191229] iwlwifi 0000:00:14.3: FW already configured (0) - re-configuring
[    9.226858] iwlwifi 0000:00:14.3: Applying debug destination EXTERNAL_DRAM
[    9.373761] iwlwifi 0000:00:14.3: FW already configured (0) - re-configuring
[    9.377845] usb 3-10: new full-speed USB device number 5 using xhci_hcd
[    9.544830] mc: Linux media interface: v0.10
[    9.552789] videodev: Linux video capture interface: v2.00
[    9.564530] uvcvideo: Found UVC 1.50 device Integrated Camera (04f2:b681)
[    9.566189] Bluetooth: Core ver 2.22
[    9.566202] NET: Registered protocol family 31
[    9.566203] Bluetooth: HCI device and connection manager initialized
[    9.566206] Bluetooth: HCI socket layer initialized
[    9.566208] Bluetooth: L2CAP socket layer initialized
[    9.566210] Bluetooth: SCO socket layer initialized
[    9.571492] usbcore: registered new interface driver btusb
[    9.572809] Bluetooth: hci0: Bootloader revision 0.4 build 0 week 30 2018
[    9.573813] Bluetooth: hci0: Device revision is 2
[    9.573813] Bluetooth: hci0: Secure boot is enabled
[    9.573814] Bluetooth: hci0: OTP lock is enabled
[    9.573815] Bluetooth: hci0: API lock is enabled
[    9.573815] Bluetooth: hci0: Debug lock is disabled
[    9.573816] Bluetooth: hci0: Minimum firmware build 1 week 10 2014
[    9.573895] input: Integrated Camera: Integrated C as /devices/pci0000:00/0000:00:14.0/usb3/3-5/3-5:1.0/input/input25
[    9.575099] Bluetooth: hci0: Found device firmware: intel/ibt-19-0-4.sfi
[    9.575862] uvcvideo: Found UVC 1.50 device Integrated Camera (04f2:b681)
[    9.577495] input: Integrated Camera: Integrated I as /devices/pci0000:00/0000:00:14.0/usb3/3-5/3-5:1.2/input/input26
[    9.577537] usbcore: registered new interface driver uvcvideo
[    9.577538] USB Video Class driver (1.1.1)
[    9.593075] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    9.593077] Bluetooth: BNEP filters: protocol multicast
[    9.593081] Bluetooth: BNEP socket layer initialized
[    9.607589] NET: Registered protocol family 17
[   11.094305] Bluetooth: hci0: Waiting for firmware download to complete
[   11.094833] Bluetooth: hci0: Firmware loaded in 1487658 usecs
[   11.094846] Bluetooth: hci0: Waiting for device to boot
[   11.108796] Bluetooth: hci0: Device booted in 13630 usecs
[   11.111936] Bluetooth: hci0: Found Intel DDC parameters: intel/ibt-19-0-4.ddc
[   11.113803] Bluetooth: hci0: Applying Intel DDC parameters completed
[   11.116801] Bluetooth: hci0: Firmware revision 0.0 build 212 week 13 2020
[   11.176914] NET: Registered protocol family 38
[   14.997300] Bluetooth: RFCOMM TTY layer initialized
[   14.997307] Bluetooth: RFCOMM socket layer initialized
[   14.997311] Bluetooth: RFCOMM ver 1.11
[   16.991754] wlan0: authenticate with cc:2d:e0:10:6a:d2
[   16.994126] wlan0: send auth to cc:2d:e0:10:6a:d2 (try 1/3)
[   17.017123] wlan0: authenticated
[   17.017843] wlan0: associate with cc:2d:e0:10:6a:d2 (try 1/3)
[   17.022534] wlan0: RX AssocResp from cc:2d:e0:10:6a:d2 (capab=0x401 status=0 aid=4)
[   17.024974] wlan0: associated
[   17.037240] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  106.219478] EXT4-fs (dm-1): re-mounted. Opts: commit=0
[  106.332001] PM: hibernation: hibernation entry
[  106.332876] Filesystems sync: 0.000 seconds
[  106.332878] Freezing user space processes ... (elapsed 0.001 seconds) done.
[  106.334114] OOM killer disabled.
[  106.334201] PM: hibernation: Marking nosave pages: [mem 0x00000000-0x00000fff]
[  106.334202] PM: hibernation: Marking nosave pages: [mem 0x0009f000-0x000fffff]
[  106.334204] PM: hibernation: Marking nosave pages: [mem 0x8764a000-0x876dafff]
[  106.334207] PM: hibernation: Marking nosave pages: [mem 0x87e23000-0x87e23fff]
[  106.334208] PM: hibernation: Marking nosave pages: [mem 0x8b8ca000-0x93bfefff]
[  106.334737] PM: hibernation: Marking nosave pages: [mem 0x93c00000-0xffffffff]
[  106.336448] PM: hibernation: Basic memory bitmaps created
[  106.336843] PM: hibernation: Preallocating image memory
[  106.449904] PM: hibernation: Allocated 462844 pages for snapshot
[  106.449906] PM: hibernation: Allocated 1851376 kbytes in 0.11 seconds (16830.69 MB/s)
[  106.449907] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  106.451231] printk: Suspending console(s) (use no_console_suspend to debug)
[  106.451802] wlan0: deauthenticating from cc:2d:e0:10:6a:d2 by local choice (Reason: 3=DEAUTH_LEAVING)
[  106.919633] ACPI: EC: interrupt blocked
[  106.926223] ACPI: Preparing to enter system sleep state S4
[  106.952574] ACPI: EC: event blocked
[  106.952575] ACPI: EC: EC stopped
[  106.952576] PM: Saving platform NVS memory
[  106.956695] Disabling non-boot CPUs ...
[  106.957002] IRQ 158: no longer affine to CPU1
[  106.958905] smpboot: CPU 1 is now offline
[  106.959521] IRQ 159: no longer affine to CPU2
[  106.960534] smpboot: CPU 2 is now offline
[  106.961110] IRQ 160: no longer affine to CPU3
[  106.962135] smpboot: CPU 3 is now offline
[  106.962937] IRQ 161: no longer affine to CPU4
[  106.964463] smpboot: CPU 4 is now offline
[  106.965013] IRQ 162: no longer affine to CPU5
[  106.966028] smpboot: CPU 5 is now offline
[  106.966407] IRQ 163: no longer affine to CPU6
[  106.967437] smpboot: CPU 6 is now offline
[  106.967962] IRQ 164: no longer affine to CPU7
[  106.969008] smpboot: CPU 7 is now offline
[  106.974629] PM: hibernation: Creating image:
[  107.033979] PM: hibernation: Need to copy 454854 pages
[  107.033980] PM: hibernation: Normal pages needed: 454854 + 1024, available pages: 1556064
[  106.974914] PM: Restoring platform NVS memory
[  106.976130] ACPI: EC: EC started
[  106.977052] Enabling non-boot CPUs ...
[  106.977278] x86: Booting SMP configuration:
[  106.977279] smpboot: Booting Node 0 Processor 1 APIC 0x2
[  106.977337] smpboot: Scheduler frequency invariance went wobbly, disabling!
[  106.978267] CPU1 is up
[  106.978440] smpboot: Booting Node 0 Processor 2 APIC 0x4
[  106.979458] CPU2 is up
[  106.979601] smpboot: Booting Node 0 Processor 3 APIC 0x6
[  106.980681] CPU3 is up
[  106.980818] smpboot: Booting Node 0 Processor 4 APIC 0x1
[  106.981960] CPU4 is up
[  106.982092] smpboot: Booting Node 0 Processor 5 APIC 0x3
[  106.983053] CPU5 is up
[  106.983190] smpboot: Booting Node 0 Processor 6 APIC 0x5
[  106.984281] CPU6 is up
[  106.984448] smpboot: Booting Node 0 Processor 7 APIC 0x7
[  106.985576] CPU7 is up
[  106.990973] ACPI: Waking up from system sleep state S4
[  107.017410] ACPI: EC: interrupt unblocked
[  107.174115] ACPI: EC: event unblocked
[  107.174209] usb usb1: root hub lost power or was reset
[  107.174210] usb usb3: root hub lost power or was reset
[  107.174211] usb usb2: root hub lost power or was reset
[  107.174211] usb usb4: root hub lost power or was reset
[  107.184880] nvme nvme0: Shutdown timeout set to 8 seconds
[  107.187118] iwlwifi 0000:00:14.3: Applying debug destination EXTERNAL_DRAM
[  107.194773] nvme nvme0: 8/0/0 default/read/poll queues
[  107.337691] iwlwifi 0000:00:14.3: FW already configured (0) - re-configuring
[  107.508399] usb 3-6: reset full-speed USB device number 3 using xhci_hcd
[  107.748417] usb 3-5: reset high-speed USB device number 2 using xhci_hcd
[  107.988595] usb 3-10: reset full-speed USB device number 5 using xhci_hcd
[  108.229613] usb 3-7: reset full-speed USB device number 4 using xhci_hcd
[  108.369744] acpi LNXPOWER:09: Turning OFF
[  108.370234] acpi LNXPOWER:08: Turning OFF
[  108.371533] mei_hdcp 0000:00:16.0-b638ab7e-94e2-4ea2-a552-d1c54b627f04: bound 0000:00:02.0 (ops i915_hdcp_component_ops [i915])
[  108.372657] PM: hibernation: Basic memory bitmaps freed
[  108.372663] OOM killer enabled.
[  108.372664] Restarting tasks ... 
[  108.373132] Bluetooth: hci0: Bootloader revision 0.4 build 0 week 30 2018
[  108.374108] Bluetooth: hci0: Device revision is 2
[  108.374111] Bluetooth: hci0: Secure boot is enabled
[  108.374114] Bluetooth: hci0: OTP lock is enabled
[  108.374118] Bluetooth: hci0: API lock is enabled
[  108.374121] Bluetooth: hci0: Debug lock is disabled
[  108.374124] Bluetooth: hci0: Minimum firmware build 1 week 10 2014
[  108.374590] Bluetooth: hci0: Found device firmware: intel/ibt-19-0-4.sfi
[  108.376970] done.
[  108.380868] PM: hibernation: hibernation exit
[  108.678600] e1000e-ext 0000:00:1f.6 eth0: NIC Link is Down
[  108.692720] iwlwifi 0000:00:14.3: Applying debug destination EXTERNAL_DRAM
[  108.840258] iwlwifi 0000:00:14.3: FW already configured (0) - re-configuring
[  108.873794] iwlwifi 0000:00:14.3: Applying debug destination EXTERNAL_DRAM
[  109.021055] iwlwifi 0000:00:14.3: FW already configured (0) - re-configuring
[  109.269548] EXT4-fs (dm-1): re-mounted. Opts: commit=0
[  110.076592] Bluetooth: hci0: Waiting for firmware download to complete
[  110.077137] Bluetooth: hci0: Firmware loaded in 1665213 usecs
[  110.077161] Bluetooth: hci0: Waiting for device to boot
[  110.091224] Bluetooth: hci0: Device booted in 13753 usecs
[  110.091275] Bluetooth: hci0: Found Intel DDC parameters: intel/ibt-19-0-4.ddc
[  110.093150] Bluetooth: hci0: Applying Intel DDC parameters completed
[  110.096195] Bluetooth: hci0: Firmware revision 0.0 build 212 week 13 2020
[  111.149960] elan_i2c 14-0015: failed to read report data: -71
[  111.162563] elan_i2c 14-0015: failed to read report data: -71
[  111.169496] elan_i2c 14-0015: failed to read report data: -71
[  111.183868] elan_i2c 14-0015: failed to read report data: -71
[  111.190243] elan_i2c 14-0015: failed to read report data: -71
[  111.204381] elan_i2c 14-0015: failed to read report data: -71
[  111.210850] elan_i2c 14-0015: failed to read report data: -71
[  111.224858] elan_i2c 14-0015: failed to read report data: -71
[  111.231600] elan_i2c 14-0015: failed to read report data: -71
[  111.238603] elan_i2c 14-0015: failed to read report data: -71
[  111.252286] elan_i2c 14-0015: failed to read report data: -71
[  111.259389] elan_i2c 14-0015: failed to read report data: -71
[  111.273237] elan_i2c 14-0015: failed to read report data: -71
[  111.279804] elan_i2c 14-0015: failed to read report data: -71
[  111.293913] elan_i2c 14-0015: failed to read report data: -71
[  111.300548] elan_i2c 14-0015: failed to read report data: -71
[  111.307923] elan_i2c 14-0015: failed to read report data: -71
[  111.321403] elan_i2c 14-0015: failed to read report data: -71
[  111.328062] elan_i2c 14-0015: failed to read report data: -71
[  111.341991] elan_i2c 14-0015: failed to read report data: -71
[  111.348772] elan_i2c 14-0015: failed to read report data: -71
[  111.362948] elan_i2c 14-0015: failed to read report data: -71
[  111.369488] elan_i2c 14-0015: failed to read report data: -71
[  111.377085] elan_i2c 14-0015: failed to read report data: -71
[  111.390362] elan_i2c 14-0015: failed to read report data: -71
[  111.397111] elan_i2c 14-0015: failed to read report data: -71
[  111.438531] elan_i2c 14-0015: failed to read report data: -71
[  111.452226] elan_i2c 14-0015: failed to read report data: -71
[  111.480001] elan_i2c 14-0015: failed to read report data: -71
[  111.486715] elan_i2c 14-0015: failed to read report data: -71
[  111.500632] elan_i2c 14-0015: failed to read report data: -71
[  111.507300] elan_i2c 14-0015: failed to read report data: -71
[  111.516212] elan_i2c 14-0015: failed to read report data: -71
[  111.528005] elan_i2c 14-0015: failed to read report data: -71
[  111.535637] elan_i2c 14-0015: failed to read report data: -71
[  111.548882] elan_i2c 14-0015: failed to read report data: -71
[  111.555675] elan_i2c 14-0015: failed to read report data: -71
[  111.570208] elan_i2c 14-0015: failed to read report data: -71
[  111.576253] elan_i2c 14-0015: failed to read report data: -71
[  111.590282] elan_i2c 14-0015: failed to read report data: -71
[  111.596996] elan_i2c 14-0015: failed to read report data: -71
[  111.604816] elan_i2c 14-0015: failed to read report data: -71
[  111.617703] elan_i2c 14-0015: failed to read report data: -71
[  111.624703] elan_i2c 14-0015: failed to read report data: -71
[  111.638495] elan_i2c 14-0015: failed to read report data: -71
[  111.645245] elan_i2c 14-0015: failed to read report data: -71
[  111.659239] elan_i2c 14-0015: failed to read report data: -71
[  111.666083] elan_i2c 14-0015: failed to read report data: -71
[  111.680047] elan_i2c 14-0015: failed to read report data: -71
[  111.686657] elan_i2c 14-0015: failed to read report data: -71
[  111.693906] elan_i2c 14-0015: failed to read report data: -71
[  111.707709] elan_i2c 14-0015: failed to read report data: -71
[  111.714208] elan_i2c 14-0015: failed to read report data: -71
[  111.728169] elan_i2c 14-0015: failed to read report data: -71
[  111.734857] elan_i2c 14-0015: failed to read report data: -71
[  111.748903] elan_i2c 14-0015: failed to read report data: -71
[  111.755563] elan_i2c 14-0015: failed to read report data: -71
[  111.763381] elan_i2c 14-0015: failed to read report data: -71
[  111.776221] elan_i2c 14-0015: failed to read report data: -71
[  111.783102] elan_i2c 14-0015: failed to read report data: -71
[  111.797109] elan_i2c 14-0015: failed to read report data: -71
[  111.804005] elan_i2c 14-0015: failed to read report data: -71
[  111.817966] elan_i2c 14-0015: failed to read report data: -71
[  111.824528] elan_i2c 14-0015: failed to read report data: -71
[  111.838801] elan_i2c 14-0015: failed to read report data: -71
[  111.845158] elan_i2c 14-0015: failed to read report data: -71
[  111.852454] elan_i2c 14-0015: failed to read report data: -71
[  111.865994] elan_i2c 14-0015: failed to read report data: -71
[  111.872913] elan_i2c 14-0015: failed to read report data: -71
[  111.886941] elan_i2c 14-0015: failed to read report data: -71
[  111.893441] elan_i2c 14-0015: failed to read report data: -71
[  111.907219] elan_i2c 14-0015: failed to read report data: -71
[  111.962457] elan_i2c 14-0015: failed to read report data: -71
[  111.976307] elan_i2c 14-0015: failed to read report data: -71
[  111.982959] elan_i2c 14-0015: failed to read report data: -71
[  111.997231] elan_i2c 14-0015: failed to read report data: -71
[  112.003761] elan_i2c 14-0015: failed to read report data: -71
[  112.010746] elan_i2c 14-0015: failed to read report data: -71
[  112.024874] elan_i2c 14-0015: failed to read report data: -71
[  112.031211] elan_i2c 14-0015: failed to read report data: -71
[  112.045382] elan_i2c 14-0015: failed to read report data: -71
[  112.051954] elan_i2c 14-0015: failed to read report data: -71
[  112.066412] elan_i2c 14-0015: failed to read report data: -71
[  112.072607] elan_i2c 14-0015: failed to read report data: -71
[  112.079993] elan_i2c 14-0015: failed to read report data: -71
[  112.093526] elan_i2c 14-0015: failed to read report data: -71
[  112.100224] elan_i2c 14-0015: failed to read report data: -71
[  112.114261] elan_i2c 14-0015: failed to read report data: -71
[  112.120868] elan_i2c 14-0015: failed to read report data: -71
[  112.135152] elan_i2c 14-0015: failed to read report data: -71
[  112.141577] elan_i2c 14-0015: failed to read report data: -71
[  112.149116] elan_i2c 14-0015: failed to read report data: -71
[  112.162409] elan_i2c 14-0015: failed to read report data: -71
[  112.169142] elan_i2c 14-0015: failed to read report data: -71
[  112.183447] elan_i2c 14-0015: failed to read report data: -71
[  112.189875] elan_i2c 14-0015: failed to read report data: -71
[  112.204013] elan_i2c 14-0015: failed to read report data: -71
[  112.210608] elan_i2c 14-0015: failed to read report data: -71
[  112.258862] elan_i2c 14-0015: failed to read report data: -71
[  112.272849] elan_i2c 14-0015: failed to read report data: -71
[  112.279452] elan_i2c 14-0015: failed to read report data: -71
[  112.293621] elan_i2c 14-0015: failed to read report data: -71
[  112.300065] elan_i2c 14-0015: failed to read report data: -71
[  112.307598] elan_i2c 14-0015: failed to read report data: -71
[  112.320857] elan_i2c 14-0015: failed to read report data: -71
[  112.327684] elan_i2c 14-0015: failed to read report data: -71
[  112.341552] elan_i2c 14-0015: failed to read report data: -71
[  112.348368] elan_i2c 14-0015: failed to read report data: -71
[  112.362527] elan_i2c 14-0015: failed to read report data: -71
[  112.369115] elan_i2c 14-0015: failed to read report data: -71
[  112.383254] elan_i2c 14-0015: failed to read report data: -71
[  112.389945] elan_i2c 14-0015: failed to read report data: -71
[  112.396802] elan_i2c 14-0015: failed to read report data: -71
[  112.410674] elan_i2c 14-0015: failed to read report data: -71
[  112.417501] elan_i2c 14-0015: failed to read report data: -71
[  112.431458] elan_i2c 14-0015: failed to read report data: -71
[  112.438189] elan_i2c 14-0015: failed to read report data: -71
[  112.452400] elan_i2c 14-0015: failed to read report data: -71
[  112.458827] elan_i2c 14-0015: failed to read report data: -71
[  112.466171] elan_i2c 14-0015: failed to read report data: -71
[  112.479610] elan_i2c 14-0015: failed to read report data: -71
[  112.486367] elan_i2c 14-0015: failed to read report data: -71
[  112.500673] elan_i2c 14-0015: failed to read report data: -71
[  112.507025] elan_i2c 14-0015: failed to read report data: -71
[  112.521346] elan_i2c 14-0015: failed to read report data: -71
[  112.527693] elan_i2c 14-0015: failed to read report data: -71
[  112.535449] elan_i2c 14-0015: failed to read report data: -71
[  112.548950] elan_i2c 14-0015: failed to read report data: -71
[  112.555245] elan_i2c 14-0015: failed to read report data: -71
[  112.569275] elan_i2c 14-0015: failed to read report data: -71
[  112.575994] elan_i2c 14-0015: failed to read report data: -71
[  112.590324] elan_i2c 14-0015: failed to read report data: -71
[  112.596615] elan_i2c 14-0015: failed to read report data: -71
[  112.604344] elan_i2c 14-0015: failed to read report data: -71
[  112.617412] elan_i2c 14-0015: failed to read report data: -71
[  112.624416] elan_i2c 14-0015: failed to read report data: -71
[  112.638246] elan_i2c 14-0015: failed to read report data: -71
[  112.644897] elan_i2c 14-0015: failed to read report data: -71
[  112.659080] elan_i2c 14-0015: failed to read report data: -71
[  112.665801] elan_i2c 14-0015: failed to read report data: -71
[  112.679485] elan_i2c 14-0015: failed to read report data: -71
[  112.693680] elan_i2c 14-0015: failed to read report data: -71
[  112.707174] elan_i2c 14-0015: failed to read report data: -71
[  112.713860] elan_i2c 14-0015: failed to read report data: -71
[  112.727819] elan_i2c 14-0015: failed to read report data: -71
[  112.734616] elan_i2c 14-0015: failed to read report data: -71
[  112.748730] elan_i2c 14-0015: failed to read report data: -71
[  112.755369] elan_i2c 14-0015: failed to read report data: -71
[  112.763003] elan_i2c 14-0015: failed to read report data: -71
[  112.775938] elan_i2c 14-0015: failed to read report data: -71
[  112.782755] elan_i2c 14-0015: failed to read report data: -71
[  112.796759] elan_i2c 14-0015: failed to read report data: -71
[  112.803454] elan_i2c 14-0015: failed to read report data: -71
[  112.817600] elan_i2c 14-0015: failed to read report data: -71
[  112.824249] elan_i2c 14-0015: failed to read report data: -71
[  112.838418] elan_i2c 14-0015: failed to read report data: -71
[  112.844938] elan_i2c 14-0015: failed to read report data: -71
[  112.852065] elan_i2c 14-0015: failed to read report data: -71
[  112.865850] elan_i2c 14-0015: failed to read report data: -71
[  112.872539] elan_i2c 14-0015: failed to read report data: -71
[  112.886494] elan_i2c 14-0015: failed to read report data: -71
[  112.893117] elan_i2c 14-0015: failed to read report data: -71
[  112.907254] elan_i2c 14-0015: failed to read report data: -71
[  112.913888] elan_i2c 14-0015: failed to read report data: -71
[  112.921131] elan_i2c 14-0015: failed to read report data: -71
[  112.934545] elan_i2c 14-0015: failed to read report data: -71
[  112.941384] elan_i2c 14-0015: failed to read report data: -71
[  112.955618] elan_i2c 14-0015: failed to read report data: -71
[  112.962086] elan_i2c 14-0015: failed to read report data: -71
[  112.976381] elan_i2c 14-0015: failed to read report data: -71
[  112.982924] elan_i2c 14-0015: failed to read report data: -71
[  112.990384] elan_i2c 14-0015: failed to read report data: -71
[  113.003556] elan_i2c 14-0015: failed to read report data: -71
[  113.010376] elan_i2c 14-0015: failed to read report data: -71
[  113.024327] elan_i2c 14-0015: failed to read report data: -71
[  113.031007] elan_i2c 14-0015: failed to read report data: -71
[  113.045246] elan_i2c 14-0015: failed to read report data: -71
[  113.051822] elan_i2c 14-0015: failed to read report data: -71
[  113.066085] elan_i2c 14-0015: failed to read report data: -71
[  113.072458] elan_i2c 14-0015: failed to read report data: -71
[  113.079572] elan_i2c 14-0015: failed to read report data: -71
[  113.093369] elan_i2c 14-0015: failed to read report data: -71
[  113.100136] elan_i2c 14-0015: failed to read report data: -71
[  113.114332] elan_i2c 14-0015: failed to read report data: -71
[  113.120830] elan_i2c 14-0015: failed to read report data: -71
[  113.135132] elan_i2c 14-0015: failed to read report data: -71
[  113.141432] elan_i2c 14-0015: failed to read report data: -71
[  113.148698] elan_i2c 14-0015: failed to read report data: -71
[  113.162203] elan_i2c 14-0015: failed to read report data: -71
[  113.169053] elan_i2c 14-0015: failed to read report data: -71
[  113.182923] elan_i2c 14-0015: failed to read report data: -71
[  113.189680] elan_i2c 14-0015: failed to read report data: -71
[  113.203963] elan_i2c 14-0015: failed to read report data: -71
[  113.210361] elan_i2c 14-0015: failed to read report data: -71
[  113.218049] elan_i2c 14-0015: failed to read report data: -71
[  113.231161] elan_i2c 14-0015: failed to read report data: -71
[  113.237974] elan_i2c 14-0015: failed to read report data: -71
[  113.251886] elan_i2c 14-0015: failed to read report data: -71
[  113.258663] elan_i2c 14-0015: failed to read report data: -71
[  113.265930] wlan0: authenticate with cc:2d:e0:10:6a:d2
[  113.267979] wlan0: send auth to cc:2d:e0:10:6a:d2 (try 1/3)
[  113.272602] elan_i2c 14-0015: failed to read report data: -71
[  113.279170] elan_i2c 14-0015: failed to read report data: -71
[  113.286976] elan_i2c 14-0015: failed to read report data: -71
[  113.290855] wlan0: authenticated
[  113.291326] wlan0: associate with cc:2d:e0:10:6a:d2 (try 1/3)
[  113.297103] wlan0: RX AssocResp from cc:2d:e0:10:6a:d2 (capab=0x401 status=0 aid=4)
[  113.299882] elan_i2c 14-0015: failed to read report data: -71
[  113.300173] wlan0: associated
[  113.306962] elan_i2c 14-0015: failed to read report data: -71
[  113.313828] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  113.320678] elan_i2c 14-0015: failed to read report data: -71
[  113.327496] elan_i2c 14-0015: failed to read report data: -71
[  113.341620] elan_i2c 14-0015: failed to read report data: -71
[  113.348332] elan_i2c 14-0015: failed to read report data: -71
[  113.362511] elan_i2c 14-0015: failed to read report data: -71
[  113.368978] elan_i2c 14-0015: failed to read report data: -71
[  113.376325] elan_i2c 14-0015: failed to read report data: -71
[  113.389674] elan_i2c 14-0015: failed to read report data: -71
[  113.396591] elan_i2c 14-0015: failed to read report data: -71
[  113.410410] elan_i2c 14-0015: failed to read report data: -71
[  113.417122] elan_i2c 14-0015: failed to read report data: -71
[  113.431275] elan_i2c 14-0015: failed to read report data: -71
[  113.437863] elan_i2c 14-0015: failed to read report data: -71
[  113.445492] elan_i2c 14-0015: failed to read report data: -71
[  113.458542] elan_i2c 14-0015: failed to read report data: -71
[  113.465452] elan_i2c 14-0015: failed to read report data: -71
[  113.479508] elan_i2c 14-0015: failed to read report data: -71
[  113.486099] elan_i2c 14-0015: failed to read report data: -71
[  113.500306] elan_i2c 14-0015: failed to read report data: -71
[  113.506875] elan_i2c 14-0015: failed to read report data: -71
[  113.521030] elan_i2c 14-0015: failed to read report data: -71
[  113.527493] elan_i2c 14-0015: failed to read report data: -71
[  113.534641] elan_i2c 14-0015: failed to read report data: -71
[  113.548499] elan_i2c 14-0015: failed to read report data: -71
[  113.555125] elan_i2c 14-0015: failed to read report data: -71
[  113.569381] elan_i2c 14-0015: failed to read report data: -71
[  113.575839] elan_i2c 14-0015: failed to read report data: -71
[  113.584535] elan_i2c 14-0015: failed to read report data: -71
[  113.596716] elan_i2c 14-0015: failed to read report data: -71
[  113.603959] elan_i2c 14-0015: failed to read report data: -71
[  113.617531] elan_i2c 14-0015: failed to read report data: -71
[  113.624089] elan_i2c 14-0015: failed to read report data: -71
[  113.638050] elan_i2c 14-0015: failed to read report data: -71
[  113.644824] elan_i2c 14-0015: failed to read report data: -71
[  113.658879] elan_i2c 14-0015: failed to read report data: -71
[  113.665532] elan_i2c 14-0015: failed to read report data: -71
[  113.673092] elan_i2c 14-0015: failed to read report data: -71
[  113.686373] elan_i2c 14-0015: failed to read report data: -71
[  113.693011] elan_i2c 14-0015: failed to read report data: -71
[  113.707053] elan_i2c 14-0015: failed to read report data: -71
[  113.713890] elan_i2c 14-0015: failed to read report data: -71
[  113.727724] elan_i2c 14-0015: failed to read report data: -71
[  113.734362] elan_i2c 14-0015: failed to read report data: -71
[  113.748552] elan_i2c 14-0015: failed to read report data: -71
[  113.755036] elan_i2c 14-0015: failed to read report data: -71
[  113.762153] elan_i2c 14-0015: failed to read report data: -71
[  113.775876] elan_i2c 14-0015: failed to read report data: -71
[  113.782694] elan_i2c 14-0015: failed to read report data: -71
[  113.796677] elan_i2c 14-0015: failed to read report data: -71
[  113.803319] elan_i2c 14-0015: failed to read report data: -71
[  113.817435] elan_i2c 14-0015: failed to read report data: -71
[  113.824084] elan_i2c 14-0015: failed to read report data: -71
[  113.831560] elan_i2c 14-0015: failed to read report data: -71
[  113.844950] elan_i2c 14-0015: failed to read report data: -71
[  113.851646] elan_i2c 14-0015: failed to read report data: -71
[  113.865646] elan_i2c 14-0015: failed to read report data: -71
[  113.872383] elan_i2c 14-0015: failed to read report data: -71
[  113.886543] elan_i2c 14-0015: failed to read report data: -71
[  113.892948] elan_i2c 14-0015: failed to read report data: -71
[  113.900760] elan_i2c 14-0015: failed to read report data: -71
[  113.913694] elan_i2c 14-0015: failed to read report data: -71
[  113.920581] elan_i2c 14-0015: failed to read report data: -71
[  113.941411] elan_i2c 14-0015: failed to read report data: -71
[  113.955401] elan_i2c 14-0015: failed to read report data: -71
[  113.961970] elan_i2c 14-0015: failed to read report data: -71
[  113.976155] elan_i2c 14-0015: failed to read report data: -71
[  113.982690] elan_i2c 14-0015: failed to read report data: -71
[  113.989820] elan_i2c 14-0015: failed to read report data: -71
[  114.003500] elan_i2c 14-0015: failed to read report data: -71
[  114.010256] elan_i2c 14-0015: failed to read report data: -71
[  114.024376] elan_i2c 14-0015: failed to read report data: -71
[  114.031040] elan_i2c 14-0015: failed to read report data: -71
[  114.045090] elan_i2c 14-0015: failed to read report data: -71
[  114.051633] elan_i2c 14-0015: failed to read report data: -71
[  114.059041] elan_i2c 14-0015: failed to read report data: -71
[  114.072285] elan_i2c 14-0015: failed to read report data: -71
[  114.079148] elan_i2c 14-0015: failed to read report data: -71
[  114.092998] elan_i2c 14-0015: failed to read report data: -71
[  114.099954] elan_i2c 14-0015: failed to read report data: -71
[  114.114187] elan_i2c 14-0015: failed to read report data: -71
[  114.120583] elan_i2c 14-0015: failed to read report data: -71
[  114.128426] elan_i2c 14-0015: failed to read report data: -71
[  114.141532] elan_i2c 14-0015: failed to read report data: -71
[  114.148241] elan_i2c 14-0015: failed to read report data: -71
[  114.162085] elan_i2c 14-0015: failed to read report data: -71
[  114.168986] elan_i2c 14-0015: failed to read report data: -71
[  114.182889] elan_i2c 14-0015: failed to read report data: -71
[  114.189495] elan_i2c 14-0015: failed to read report data: -71
[  114.197594] elan_i2c 14-0015: failed to read report data: -71
[  114.210249] elan_i2c 14-0015: failed to read report data: -71
[  114.217571] elan_i2c 14-0015: failed to read report data: -71
[  114.231206] elan_i2c 14-0015: failed to read report data: -71
[  114.237874] elan_i2c 14-0015: failed to read report data: -71
[  114.251918] elan_i2c 14-0015: failed to read report data: -71
[  114.258507] elan_i2c 14-0015: failed to read report data: -71
[  114.272921] elan_i2c 14-0015: failed to read report data: -71
[  114.279256] elan_i2c 14-0015: failed to read report data: -71
[  114.286819] elan_i2c 14-0015: failed to read report data: -71
[  114.300103] elan_i2c 14-0015: failed to read report data: -71
[  114.306827] elan_i2c 14-0015: failed to read report data: -71
[  114.321162] elan_i2c 14-0015: failed to read report data: -71
[  114.327480] elan_i2c 14-0015: failed to read report data: -71
[  114.341551] elan_i2c 14-0015: failed to read report data: -71
[  114.348069] elan_i2c 14-0015: failed to read report data: -71
[  114.362401] elan_i2c 14-0015: failed to read report data: -71
[  114.368942] elan_i2c 14-0015: failed to read report data: -71
[  114.375849] elan_i2c 14-0015: failed to read report data: -71
[  114.389936] elan_i2c 14-0015: failed to read report data: -71
[  114.396458] elan_i2c 14-0015: failed to read report data: -71
[  114.410497] elan_i2c 14-0015: failed to read report data: -71
[  114.417128] elan_i2c 14-0015: failed to read report data: -71
[  114.431523] elan_i2c 14-0015: failed to read report data: -71
[  114.437895] elan_i2c 14-0015: failed to read report data: -71
[  114.445191] elan_i2c 14-0015: failed to read report data: -71
[  114.458742] elan_i2c 14-0015: failed to read report data: -71
[  114.465449] elan_i2c 14-0015: failed to read report data: -71
[  114.479420] elan_i2c 14-0015: failed to read report data: -71
[  114.486139] elan_i2c 14-0015: failed to read report data: -71
[  114.500456] elan_i2c 14-0015: failed to read report data: -71
[  114.506826] elan_i2c 14-0015: failed to read report data: -71
[  114.514548] elan_i2c 14-0015: failed to read report data: -71
[  114.527588] elan_i2c 14-0015: failed to read report data: -71
[  114.534392] elan_i2c 14-0015: failed to read report data: -71
[  114.548412] elan_i2c 14-0015: failed to read report data: -71
[  114.555044] elan_i2c 14-0015: failed to read report data: -71
[  114.569309] elan_i2c 14-0015: failed to read report data: -71
[  114.575662] elan_i2c 14-0015: failed to read report data: -71
[  114.590150] elan_i2c 14-0015: failed to read report data: -71
[  114.596461] elan_i2c 14-0015: failed to read report data: -71
[  114.603548] elan_i2c 14-0015: failed to read report data: -71
[  114.617471] elan_i2c 14-0015: failed to read report data: -71
[  114.624012] elan_i2c 14-0015: failed to read report data: -71
[  114.638072] elan_i2c 14-0015: failed to read report data: -71
[  114.644672] elan_i2c 14-0015: failed to read report data: -71
[  114.658862] elan_i2c 14-0015: failed to read report data: -71
[  114.665440] elan_i2c 14-0015: failed to read report data: -71
[  114.672708] elan_i2c 14-0015: failed to read report data: -71
[  114.686370] elan_i2c 14-0015: failed to read report data: -71
[  114.692913] elan_i2c 14-0015: failed to read report data: -71
[  114.706983] elan_i2c 14-0015: failed to read report data: -71
[  114.713640] elan_i2c 14-0015: failed to read report data: -71
[  114.727638] elan_i2c 14-0015: failed to read report data: -71
[  114.734189] elan_i2c 14-0015: failed to read report data: -71
[  114.741899] elan_i2c 14-0015: failed to read report data: -71
[  114.754898] elan_i2c 14-0015: failed to read report data: -71
[  114.761803] elan_i2c 14-0015: failed to read report data: -71
[  114.775768] elan_i2c 14-0015: failed to read report data: -71
[  114.782545] elan_i2c 14-0015: failed to read report data: -71
[  114.796621] elan_i2c 14-0015: failed to read report data: -71
[  114.803358] elan_i2c 14-0015: failed to read report data: -71
[  114.817465] elan_i2c 14-0015: failed to read report data: -71
[  114.824067] elan_i2c 14-0015: failed to read report data: -71
[  114.830964] elan_i2c 14-0015: failed to read report data: -71
[  114.844879] elan_i2c 14-0015: failed to read report data: -71
[  114.851594] elan_i2c 14-0015: failed to read report data: -71
[  114.865583] elan_i2c 14-0015: failed to read report data: -71
[  114.872172] elan_i2c 14-0015: failed to read report data: -71
[  114.886409] elan_i2c 14-0015: failed to read report data: -71
[  114.892958] elan_i2c 14-0015: failed to read report data: -71
[  114.900253] elan_i2c 14-0015: failed to read report data: -71
[  114.913611] elan_i2c 14-0015: failed to read report data: -71
[  114.934566] elan_i2c 14-0015: failed to read report data: -71
[  114.941245] elan_i2c 14-0015: failed to read report data: -71
[  114.955460] elan_i2c 14-0015: failed to read report data: -71
[  114.961936] elan_i2c 14-0015: failed to read report data: -71
[  114.969541] elan_i2c 14-0015: failed to read report data: -71
[  114.982552] elan_i2c 14-0015: failed to read report data: -71
[  114.989467] elan_i2c 14-0015: failed to read report data: -71
[  115.003450] elan_i2c 14-0015: failed to read report data: -71
[  115.010182] elan_i2c 14-0015: failed to read report data: -71
[  115.024467] elan_i2c 14-0015: failed to read report data: -71
[  115.030877] elan_i2c 14-0015: failed to read report data: -71
[  115.045107] elan_i2c 14-0015: failed to read report data: -71
[  115.051472] elan_i2c 14-0015: failed to read report data: -71
[  115.058739] elan_i2c 14-0015: failed to read report data: -71
[  115.072506] elan_i2c 14-0015: failed to read report data: -71
[  115.079166] elan_i2c 14-0015: failed to read report data: -71
[  115.093261] elan_i2c 14-0015: failed to read report data: -71
[  115.099827] elan_i2c 14-0015: failed to read report data: -71
[  115.113942] elan_i2c 14-0015: failed to read report data: -71
[  115.120515] elan_i2c 14-0015: failed to read report data: -71
[  115.128023] elan_i2c 14-0015: failed to read report data: -71
[  115.141263] elan_i2c 14-0015: failed to read report data: -71
[  115.148153] elan_i2c 14-0015: failed to read report data: -71
[  115.162194] elan_i2c 14-0015: failed to read report data: -71
[  115.168952] elan_i2c 14-0015: failed to read report data: -71
[  115.183028] elan_i2c 14-0015: failed to read report data: -71
[  115.189408] elan_i2c 14-0015: failed to read report data: -71
[  115.197354] elan_i2c 14-0015: failed to read report data: -71
[  115.210411] elan_i2c 14-0015: failed to read report data: -71
[  115.217168] elan_i2c 14-0015: failed to read report data: -71
[  115.231080] elan_i2c 14-0015: failed to read report data: -71
[  115.237707] elan_i2c 14-0015: failed to read report data: -71
[  115.251835] elan_i2c 14-0015: failed to read report data: -71
[  115.258410] elan_i2c 14-0015: failed to read report data: -71
[  115.272215] elan_i2c 14-0015: failed to read report data: -71
[  115.286381] elan_i2c 14-0015: failed to read report data: -71
[  115.300090] elan_i2c 14-0015: failed to read report data: -71
[  115.306711] elan_i2c 14-0015: failed to read report data: -71
[  115.320757] elan_i2c 14-0015: failed to read report data: -71
[  115.327428] elan_i2c 14-0015: failed to read report data: -71
[  115.341661] elan_i2c 14-0015: failed to read report data: -71
[  115.348252] elan_i2c 14-0015: failed to read report data: -71
[  115.355646] elan_i2c 14-0015: failed to read report data: -71
[  115.368894] elan_i2c 14-0015: failed to read report data: -71
[  115.375627] elan_i2c 14-0015: failed to read report data: -71
[  115.389816] elan_i2c 14-0015: failed to read report data: -71
[  115.396362] elan_i2c 14-0015: failed to read report data: -71
[  115.410378] elan_i2c 14-0015: failed to read report data: -71
[  115.417016] elan_i2c 14-0015: failed to read report data: -71
[  115.424979] elan_i2c 14-0015: failed to read report data: -71
[  115.437715] elan_i2c 14-0015: failed to read report data: -71
[  115.444891] elan_i2c 14-0015: failed to read report data: -71
[  115.458589] elan_i2c 14-0015: failed to read report data: -71
[  115.465305] elan_i2c 14-0015: failed to read report data: -71
[  115.479382] elan_i2c 14-0015: failed to read report data: -71
[  115.486095] elan_i2c 14-0015: failed to read report data: -71
[  115.507003] elan_i2c 14-0015: failed to read report data: -71

--------------047573928A96EA97B9B27720--
