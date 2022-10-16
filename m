Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4369600360
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 22:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiJPU70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 16:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJPU7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 16:59:25 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA098C6B;
        Sun, 16 Oct 2022 13:59:22 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r14so13471986edc.7;
        Sun, 16 Oct 2022 13:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nqSB1WtFl1Pjz5B5A7BX4oTeoTyn1TGPFJ56y+T7YPk=;
        b=OQTwekD+8O/TQ5vFah/YdxcH+zb5TEU4d99IN2DFzxjsxUQLXLYqxwia9+i7skmtl0
         i+2MLOhclEabgp/Zm+Z95Qgi2LFlrHsiWO83TGJv9rI00SXDWDs4C01DDkAOMRj7oHVy
         0G1DTr93j8jSbnrre55gRhd1wc0C4Eu6V7O9xnvqHlvCxlctKyIre53lFcUaiRH/ZknU
         XPRzBe2CsuPPxIAKS0T7PBd+Ir8WvKRQQitrGAIUgLHYZEGyoaq2rklhyOUW2uqv7eTB
         SrSwpJC/Ee+xARhi8iYBe9olVWYzWebibo3JqzjYvZ/7rGW2F0KpP9+lSe/BKASvUxsO
         Oeng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nqSB1WtFl1Pjz5B5A7BX4oTeoTyn1TGPFJ56y+T7YPk=;
        b=uEbCudi/GXmn2uAWBu+cvNBsDHSQCywcLCVgBaJlJDnI/ej10FxG99Kgfl1e1sedAc
         5UTMwPmTOQ52usCxq7R7q5j9XaiCxGE6CHsC03EJ90a9siAVHGsplrQ1Q2dSqSRWg9Um
         +PGo57GEOK1icLrM7Junt1daNuJFIdYjwVfaOtRSbx/ZOiE6KSCuit38HW+34v7L2oXB
         xKI5V0arTOBlf190ZuynQ7AWUbk1H37X5oHfLjZHtFa0av8OOZ1rsDDMn5G9lTfHGbbP
         jP9slW9bkEadTX9kEnDRhBbfS7n2AOE9UpnRtRv5JGeLUdIpqNnTJvIPH8zw4s6Afi8o
         9+jw==
X-Gm-Message-State: ACrzQf2r45AF3nx3zCzrWZR+fUfZ9atbhzaF1t8NaO3MaZHhpdNZRYnE
        wb7Ng5P0YkXoSTcGWljdzZ99Yiw46ck=
X-Google-Smtp-Source: AMsMyM47orbGZS4L/ENAWqjhP0SXdwlCY7jMFAqHP01XdIKWGE+RbaVS3DbtZzJEc//D+Gl0tnng6w==
X-Received: by 2002:a05:6402:4282:b0:459:befa:c79c with SMTP id g2-20020a056402428200b00459befac79cmr7652304edc.23.1665953960968;
        Sun, 16 Oct 2022 13:59:20 -0700 (PDT)
Received: from ?IPV6:2a02:a466:68ed:1:174b:307e:18f1:ac0a? (2a02-a466-68ed-1-174b-307e-18f1-ac0a.fixed6.kpn.net. [2a02:a466:68ed:1:174b:307e:18f1:ac0a])
        by smtp.gmail.com with ESMTPSA id i1-20020a170906250100b0077a11b79b9bsm5035343ejb.133.2022.10.16.13.59.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Oct 2022 13:59:20 -0700 (PDT)
Message-ID: <887510d7-b732-2b0e-e177-615de59cfaf8@gmail.com>
Date:   Sun, 16 Oct 2022 22:59:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
Content-Language: en-US
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
 <a7724993-6c04-92c5-3a26-3aef6d29c9e3@gmail.com>
 <20221005021212.qwnbmq6p7t26c3a4@synopsys.com>
 <2886b82d-a1f6-d288-e8d1-edae54046b4f@gmail.com>
 <20221006021204.hz7iteao65dgsev6@synopsys.com>
 <d52cc102-6a4f-78e9-6176-b33e2813fd1d@gmail.com>
 <20221007021122.nnwmqc6sq43e5xbn@synopsys.com>
 <ade865f1-8ed5-a8e3-e441-cb7688c6d001@gmail.com>
 <CAHQ1cqGSmNSg73DzURrcP=a-cCd6KdVUtUmnonhP54vWVDmEhw@mail.gmail.com>
 <4e73bbb9-eae1-6a90-d716-c721a1eeced3@gmail.com>
 <7e9519c6-f65f-5f83-1d17-a3510103469f@gmail.com>
 <CAHQ1cqE5=j9i8uYvBwdNUK8TrX3Wxy7iUML6K+gBQx-KRtkS7w@mail.gmail.com>
 <644adb7b-0438-e37c-222c-71bf261369b0@gmail.com>
 <CAHQ1cqGSXoUTopwvrQtLww5M0Tf=6F505ziLn+wGHhW_8-JhFQ@mail.gmail.com>
 <113fe314-0f5c-f53f-db78-c93bd4515260@gmail.com>
 <CAHQ1cqF_FvG0G2CAQooOVR3E442ApNFf8EKK8PpxcOrUoL5jDA@mail.gmail.com>
 <bec17559-286c-b006-476f-3c26ae38e70d@gmail.com>
 <CAHQ1cqFqKv+J1=Qg5_sDUeKQ=64aSiGJq0pPH+OqEieZDM1Mfg@mail.gmail.com>
From:   Ferry Toth <fntoth@gmail.com>
In-Reply-To: <CAHQ1cqFqKv+J1=Qg5_sDUeKQ=64aSiGJq0pPH+OqEieZDM1Mfg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Op 15-10-2022 om 21:54 schreef Andrey Smirnov:
> On Thu, Oct 13, 2022 at 12:35 PM Ferry Toth <fntoth@gmail.com> wrote:
>> <SNIP>
>>> My end goal here is to find a way to test vanilla v6.0 with the two
>>> patches reverted on your end. I thought that during my testing I saw
>>> tusb1210 print those timeout messages during its probe and that
>>> disabling the driver worked to break the loop, but I went back to
>>> double check and it doesn't work so scratch that idea. Configuring
>>> extcon as a built-in breaks host functionality with or without patches
>>> on my end, so I'm not sure it could be a path.
>>>
>>> I won't have time to try things with
>>> 0043b-TODO-driver-core-Break-infinite-loop-when-deferred-p.patch until
>>> the weekend, meanwhile can you give this diff a try with vanilla (no
>>> reverts) v6.0:
>>>
> OK, got a chance to try things with that patch. Both v6.0 and v6.0
> with my patches reverted work the same, my Kingston DataTraveller USB
> stick enumerates and works as expected.
>
Iow you don't need the patch at all to get usb to work. There has got to 
be a difference in our configs.

Did you have a chance to look at mine (here: 
https://drive.google.com/file/d/1aKJWMqiAXnReeLCvxshzjKwGxIWQ7eJk/view?usp=sharing)

Else, send me yours.

>>> modified   drivers/phy/ti/phy-tusb1210.c
>>> @@ -127,6 +127,7 @@ static int tusb1210_set_mode(struct phy *phy, enum
>>> phy_mode mode, int submode)
>>>     u8 reg;
>>>
>>>     ret = tusb1210_ulpi_read(tusb, ULPI_OTG_CTRL, &reg);
>>> + WARN_ON(ret < 0);
>>>     if (ret < 0)
>>>     return ret;
>>>
>>> @@ -152,7 +153,10 @@ static int tusb1210_set_mode(struct phy *phy,
>>> enum phy_mode mode, int submode)
>>>     }
>>>
>>>     tusb->otg_ctrl = reg;
>>> - return tusb1210_ulpi_write(tusb, ULPI_OTG_CTRL, reg);
>>> + ret = tusb1210_ulpi_write(tusb, ULPI_OTG_CTRL, reg);
>>> + WARN_ON(ret < 0);
>>> + return ret;
>>> +
>>>    }
>>>
>>>    #ifdef CONFIG_POWER_SUPPLY
>>>
>>> ? I'm curious to see if there's masked errors on your end since dwc3
>>> driver doesn't check for those.
>> root@yuna:~# dmesg | grep -i -E 'warn|assert|error|tusb|dwc3'
>> 8250_mid: probe of 0000:00:04.0 failed with error -16
>> platform regulatory.0: Direct firmware load for regulatory.db failed
>> with error -2
>> brcmfmac mmc2:0001:1: Direct firmware load for
>> brcm/brcmfmac43340-sdio.Intel Corporation-Merrifield.bin failed with
>> error -2
>> sof-audio-pci-intel-tng 0000:00:0d.0: error: I/O region is too small.
>> sof-audio-pci-intel-tng 0000:00:0d.0: error: failed to probe DSP -19
>>
>>
>>>> This is done through configfs only when the switch is set to device mode.
>>> Sure, but can it be disabled? We are looking for unknown variables, so
>>> excluding this would be a reasonable thing to do.
>> It's not enabled until I flip the switch to device mode.
> OK to cut this back and forth short, I think it'd be easier to just
> ask you to run what I run. Here's vanilla v6.0 bzImage and initrd
> (built with your config + CONFIG_PHY_TUSB1210=y) I tested with

What do you mean by this? My config is with

CONFIG_GENERIC_PHY=y
CONFIG_PHY_TUSB1210=y

> https://drive.google.com/drive/folders/1H28AL1coPPZ2kLTYskDuDdWo-oE7DRPH?usp=sharing
> let's see how it behaves on your setup. There's also the U-Boot binary

Ok, it's getting weirder and weirder. The following is with my U-Boot 
and your kernel/initrd

1) I placed them in /boot which is on my btrfs partition on the emmc (my 
U-Boot has btrfs enabled)

Linux kernel version 6.0.0-edison-acpi-standard 
(andreysm@neptunefw-builder) #8 SMP PREEMPT_DYNAMIC Sat Oct 15 18:47:19 
UTC 2022
Building boot_params at 0x00090000
Loading bzImage at address 100000 (12064480 bytes)
Initial RAM disk at linear address 0x06000000, size 25165824 bytes
Kernel command line: "quiet root=/dev/mmcblk0p8 
rootflags=subvol=@,compress=lzo rootfstype=btrfs console=ttyS2,115200n8 
earlyprintk=ttyS2,115200n8,keep loglevel=4 systemd.unit=multi-user.target"
Kernel loaded at 00100000, setup_base=00090000

Usb drive is not detected regardless booting with stick plugged or 
plugging later on.

# lsusb
Bus 001 Device 001: ID 1d6b:0002
Bus 002 Device 001: ID 1d6b:0003

No TUSB1210 probed

# dmesg | grep dwc3
#

2) I placed them in my vfat rescue partition

Linux kernel version 6.0.0-edison-acpi-standard 
(andreysm@neptunefw-builder) #8 SMP PREEMPT_DYNAMIC Sat Oct 15 18:47:19 
UTC 2022
Building boot_params at 0x00090000
Loading bzImage at address 100000 (12064480 bytes)
Initial RAM disk at linear address 0x06000000, size 25165824 bytes
Kernel command line: "debugshell=0 tty1 console=ttyS2,115200n8 
root=/dev/mmcblk0p7 rootfstype=vfat systemd.unit=multi-user.target"
Kernel loaded at 00100000, setup_base=00090000

Usb drive is detected.

# lsusb
Bus 001 Device 001: ID 1d6b:0002
Bus 001 Device 002: ID 125f:312b
Bus 002 Device 001: ID 1d6b:0003

TUSB1210 probed

# dmesg | grep dwc3
[    8.605845] tusb1210 dwc3.0.auto.ulpi: GPIO lookup for consumer reset
[    8.605876] tusb1210 dwc3.0.auto.ulpi: using ACPI for GPIO lookup
[    8.605927] tusb1210 dwc3.0.auto.ulpi: using lookup tables for GPIO 
lookup
[    8.605941] tusb1210 dwc3.0.auto.ulpi: No GPIO consumer reset found
[    8.605956] tusb1210 dwc3.0.auto.ulpi: GPIO lookup for consumer cs
[    8.605970] tusb1210 dwc3.0.auto.ulpi: using ACPI for GPIO lookup
[    8.606011] tusb1210 dwc3.0.auto.ulpi: using lookup tables for GPIO 
lookup
[    8.606024] tusb1210 dwc3.0.auto.ulpi: No GPIO consumer cs found
[    8.669317] tusb1210 dwc3.0.auto.ulpi: error -110 writing val 0x41 to 
reg 0x80

## note: options debugshell, root and rootfstype are normally handled by 
a script in my initrd, so I guess here noop.

> I use in that folder in case you want to give it a try.
>
> Now on Merrifield dwc3_get_extcon() doesn't do anything but call
> extcon_get_extcon_dev() which doesn't touch any hardware or interact
> with other drivers, so assuming
>
>> So current v6.0 has: dwc3_get_extcon - dwc3_get_dr_mode - ... -
>> dwc3_core_init - .. - dwc3_core_init_mode (not working)
>>
>> I changed to: dwc3_get_dr_mode - dwc3_get_extcon - .. - dwc3_core_init -
>> .. - dwc3_core_init_mode (no change)
>>
>> Then to: dwc3_get_dr_mode - .. - dwc3_core_init - .. - dwc3_get_extcon -
>> dwc3_core_init_mode (works)
> still holds(did you double check that with vanilla v6.0?) the only
I didn't check
> difference that I can see is execution timings. It seems to me it's
> either an extra delay added by execution of  extcon_get_extcon_dev()
> (unlikely) or multiple partial probes that include dwc3_core_init()
> that change things. You can try to check the latter by adding an
> artificial probe deferral point after dwc3_core_init(). Something like
> (didn't test this):
>
> modified   drivers/usb/dwc3/core.c
> @@ -1860,6 +1860,10 @@ static int dwc3_probe(struct platform_device *pdev)
>    goto err3;
>
>    ret = dwc3_core_init(dwc);
> + static int deferral_counter = 0;
> + if (deferral_counter++ < 9) /* I counted 9 deferrals in my testing */
> + ret = -EPROBE_DEFER;
> +
>    if (ret) {
>    dev_err_probe(dev, ret, "failed to initialize core\n");
>    goto err4;

Not sure how you wanted this tested. So I assume on vanilla booting from 
btrfs on eemc. It crashes but maybe the trace is usefull. After crash it 
continues but no USB appears at all.

[    4.185151] kobject_add_internal failed for dwc3.0.auto.ulpi with 
-EEXIST, don't try to register things with the same name in the same 
directory.
[    4.198625] dwc3 dwc3.0.auto: failed to register ULPI interface
[    4.213112] BUG: kernel NULL pointer dereference, address: 
0000000000000001

[    4.220260] #PF: supervisor read access in kernel mode
[    4.225523] #PF: error_code(0x0000) - not-present page
[    4.230785] PGD 0 P4D 0
[    4.233402] Oops: 0000 [#1] PREEMPT SMP PTI
[    4.237696] CPU: 0 PID: 8 Comm: kworker/u4:0 Not tainted 
6.0.0-edison-acpi-standard #1
[    4.245802] Hardware name: Intel Corporation Merrifield/BODEGA BAY, 
BIOS 542 2015.01.21:18.19.48
[    4.254791] Workqueue: events_unbound deferred_probe_work_func
[    4.260793] RIP: 0010:strlen+0x0/0x20
[    4.264559] Code: b6 07 38 d0 74 14 48 83 c7 01 84 c0 74 05 48 39 f7 
75 ec 31 c0 c3 cc cc cc cc 48 89 f8 c3 cc cc cc cc 0f 1f 84 00 00 00 00 
00 <80> 3f 00 74 14 48 89 f8 48 83 c0 01 80 38 00 75 f7 48 29 f8 c3 cc
[    4.283751] RSP: 0018:ffffa9520004bb10 EFLAGS: 00010202
[    4.289113] RAX: 0000000000000018 RBX: ffff9c5807d77c18 RCX: 
0000000000000000
[    4.296417] RDX: ffffa9520004bb88 RSI: 0000000000000cc0 RDI: 
0000000000000001
[    4.303719] RBP: 0000000000000001 R08: 0000000000000000 R09: 
ffffa9520004baf0
[    4.311022] R10: ffffffffffffffff R11: 000000000000000b R12: 
0000000000000cc0
[    4.318323] R13: ffff9c5807d77c18 R14: ffff9c5807d77c18 R15: 
000000000000a710
[    4.325625] FS:  0000000000000000(0000) GS:ffff9c583e200000(0000) 
knlGS:0000000000000000
[    4.333907] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.339793] CR2: 0000000000000001 CR3: 000000001540c000 CR4: 
00000000001006f0
[    4.347098] Call Trace:
[    4.349611]  <TASK>
[    4.351771]  kstrdup_const+0x2d/0x70
[    4.355453]  kobject_set_name_vargs+0x1e/0x90
[    4.359939]  dev_set_name+0x4e/0x70
[    4.363534]  device_add+0x5b/0x960
[    4.367036]  ? complete_all+0x1b/0x80
[    4.370808]  ulpi_register_interface+0x213/0x290
[    4.375551]  dwc3_ulpi_init+0x17/0x40
[    4.379314]  dwc3_core_init+0xc29/0x1b70
[    4.383350]  dwc3_probe+0x115a/0x1900
[    4.387122]  platform_probe+0x3a/0xa0
[    4.390892]  really_probe+0xdc/0x390
[    4.394567]  ? pm_runtime_barrier+0x4b/0x80
[    4.398867]  __driver_probe_device+0x73/0x170
[    4.403340]  driver_probe_device+0x19/0x90
[    4.407545]  __device_attach_driver+0x80/0x110
[    4.412105]  ? driver_allows_async_probing+0x60/0x60
[    4.417195]  ? driver_allows_async_probing+0x60/0x60
[    4.422286]  bus_for_each_drv+0x79/0xc0
[    4.426230]  __device_attach+0xb7/0x210
[    4.430169]  bus_probe_device+0x89/0xa0
[    4.434111]  deferred_probe_work_func+0x85/0xe0
[    4.438762]  process_one_work+0x1d7/0x3a0
[    4.440890] EXT4-fs (mmcblk1): recovery complete
[    4.442785]  worker_thread+0x48/0x3c0
[    4.442809]  ? rescuer_thread+0x380/0x380
[    4.442828]  kthread+0xe2/0x110
[    4.447489] EXT4-fs (mmcblk1): mounted filesystem with ordered data 
mode. Quota mode: none.
[    4.451086]  ? kthread_complete_and_exit+0x20/0x20
[    4.451107]  ret_from_fork+0x22/0x30
[    4.475811]  </TASK>
[    4.478052] Modules linked in: mmc_block extcon_intel_mrfld sdhci_pci 
cqhci sdhci led_class mmc_core intel_soc_pmic_mrfld btrfs libcrc32c xor 
zlib_deflate raid6_pq zstd_compress
[    4.494312] CR2: 0000000000000001
[    4.497717] ---[ end trace 0000000000000000 ]---


