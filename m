Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0A1606929
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 21:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiJTTzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 15:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiJTTzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 15:55:16 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DAE5B512;
        Thu, 20 Oct 2022 12:55:10 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id sc25so2035318ejc.12;
        Thu, 20 Oct 2022 12:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+ixwwTZgzpzVwL/3AeeWYXcDf7Fp0uL9s1epKgezwLQ=;
        b=q4mAHslAQJKi9OFTWDKeQ+0nw2Q016bwlcoK101zHciWFjBEe2MqSeddWFlZQ5kgDD
         Bie34p5jybgo6Kf79Jb4kbw4yMTNDXFbpGDSjHg58WnQot7UYAhc/Wsm5kzgAfipCAwl
         HuA2y7imnexYKmebbJB47AlnH/46uO8OL6BDSUh/hn1m0A+32j3sc4RsOjZgGLVnACGw
         szHbsP8pjI7LBC51+WACmIGVP48uCzPWsGcP29nC3O0Bmlht/FeL0X141yqryhQRpH6A
         TlzKk9wFIH3iq/b9J54aYXJqY3tBZQCjpkbGTCInY57zdBmL8weTkOu9s/hQiL2aJJHt
         f9uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+ixwwTZgzpzVwL/3AeeWYXcDf7Fp0uL9s1epKgezwLQ=;
        b=bdZjzaAFUAtDHVq7Si8Klx+V8UD5vvrWvp5AZ44ViDmdmq3S6BM7FzULBPhA3WsDZM
         RV0JX5Xu/CJVkJTvQOnPerFIoGk+hLPLSSDTnaQFg8OiYAMs4WwAlwb3tFXOVScXYeUr
         TRs5IdMz4CiKWw2Lw7jMShBv8ELPPM89AQNuOJiN7wgIamKUuSplF8o9GLYM9YxPIgB/
         VlSPMhyqjenw+3hzfaff+5xVIUTrTpGJDSAo2smw5ZkWwvIkYVqGivAAiRbkljqczJaZ
         ELPNlDh/626gzyF2LzeFGric/hZr6pBHC74J+u3nINg/lR28EE182wmE5Njknc4Fc+K2
         9hmQ==
X-Gm-Message-State: ACrzQf3TpugW5W/5XdPPDL5diFCTJ+h9uQa3Wbup+Sb5Qla63/XpQ2kp
        nCOTWi57GNDLNspHHDJs66Q=
X-Google-Smtp-Source: AMsMyM4Bap1mWgkWbNh6tn9DEjaqFkdAGZI6wejAdrTPj1vgSlrPoCpH9dUQX6wC1UKTc2w4MbBeEg==
X-Received: by 2002:a17:907:6087:b0:78d:ee99:a06a with SMTP id ht7-20020a170907608700b0078dee99a06amr12467792ejc.52.1666295709007;
        Thu, 20 Oct 2022 12:55:09 -0700 (PDT)
Received: from ?IPV6:2a02:a466:68ed:1:bdf5:477:fa2f:12f8? (2a02-a466-68ed-1-bdf5-477-fa2f-12f8.fixed6.kpn.net. [2a02:a466:68ed:1:bdf5:477:fa2f:12f8])
        by smtp.gmail.com with ESMTPSA id i24-20020a056402055800b004588ef795easm12552796edx.34.2022.10.20.12.55.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 12:55:08 -0700 (PDT)
Message-ID: <37860dc6-c646-56c8-a98b-ed0e0a945f40@gmail.com>
Date:   Thu, 20 Oct 2022 21:55:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
Content-Language: en-US
From:   Ferry Toth <fntoth@gmail.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
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
 <887510d7-b732-2b0e-e177-615de59cfaf8@gmail.com>
 <CAHQ1cqFNjy7ddSot5zDekLvnqHpz5xJP+Fi6vnh+6JwVeozjcA@mail.gmail.com>
 <50218bf7-ee13-87d2-6498-e613220f9931@gmail.com>
In-Reply-To: <50218bf7-ee13-87d2-6498-e613220f9931@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Op 18-10-2022 om 22:47 schreef Ferry Toth:
> Hi,
> 
> Op 17-10-2022 om 23:20 schreef Andrey Smirnov:
>> On Sun, Oct 16, 2022 at 1:59 PM Ferry Toth <fntoth@gmail.com> wrote:
>>>
>>> Op 15-10-2022 om 21:54 schreef Andrey Smirnov:
>>>> On Thu, Oct 13, 2022 at 12:35 PM Ferry Toth <fntoth@gmail.com> wrote:
>>>>> <SNIP>
>>>>>> My end goal here is to find a way to test vanilla v6.0 with the two
>>>>>> patches reverted on your end. I thought that during my testing I saw
>>>>>> tusb1210 print those timeout messages during its probe and that
>>>>>> disabling the driver worked to break the loop, but I went back to
>>>>>> double check and it doesn't work so scratch that idea. Configuring
>>>>>> extcon as a built-in breaks host functionality with or without 
>>>>>> patches
>>>>>> on my end, so I'm not sure it could be a path.
>>>>>>
>>>>>> I won't have time to try things with
>>>>>> 0043b-TODO-driver-core-Break-infinite-loop-when-deferred-p.patch 
>>>>>> until
>>>>>> the weekend, meanwhile can you give this diff a try with vanilla (no
>>>>>> reverts) v6.0:
>>>>>>
>>>> OK, got a chance to try things with that patch. Both v6.0 and v6.0
>>>> with my patches reverted work the same, my Kingston DataTraveller USB
>>>> stick enumerates and works as expected.
>>>>
>>> Iow you don't need the patch at all to get usb to work. There has got to
>>> be a difference in our configs.
>>>
>> My patch? Yeah, it should have zero effect on anything.
>> !DWC3_VER_IS_PRIOR(DWC3, 330A) is false for Merrifield, so the logical
>> change from my patch is a no-op. It's a pure coincidence that it
>> resolved the probe loop that
>> 0043b-TODO-driver-core-Break-infinite-loop-when-deferred-p.patch is
>> for.
>>
>>> Did you have a chance to look at mine (here:
>>> https://drive.google.com/file/d/1aKJWMqiAXnReeLCvxshzjKwGxIWQ7eJk/view?usp=sharing)
>>>
>>> Else, send me yours.
>>>
>> I've been using your config in all of the testing.
>>
>>>>>> modified   drivers/phy/ti/phy-tusb1210.c
>>>>>> @@ -127,6 +127,7 @@ static int tusb1210_set_mode(struct phy *phy, 
>>>>>> enum
>>>>>> phy_mode mode, int submode)
>>>>>>      u8 reg;
>>>>>>
>>>>>>      ret = tusb1210_ulpi_read(tusb, ULPI_OTG_CTRL, &reg);
>>>>>> + WARN_ON(ret < 0);
>>>>>>      if (ret < 0)
>>>>>>      return ret;
>>>>>>
>>>>>> @@ -152,7 +153,10 @@ static int tusb1210_set_mode(struct phy *phy,
>>>>>> enum phy_mode mode, int submode)
>>>>>>      }
>>>>>>
>>>>>>      tusb->otg_ctrl = reg;
>>>>>> - return tusb1210_ulpi_write(tusb, ULPI_OTG_CTRL, reg);
>>>>>> + ret = tusb1210_ulpi_write(tusb, ULPI_OTG_CTRL, reg);
>>>>>> + WARN_ON(ret < 0);
>>>>>> + return ret;
>>>>>> +
>>>>>>     }
>>>>>>
>>>>>>     #ifdef CONFIG_POWER_SUPPLY
>>>>>>
>>>>>> ? I'm curious to see if there's masked errors on your end since dwc3
>>>>>> driver doesn't check for those.
>>>>> root@yuna:~# dmesg | grep -i -E 'warn|assert|error|tusb|dwc3'
>>>>> 8250_mid: probe of 0000:00:04.0 failed with error -16
>>>>> platform regulatory.0: Direct firmware load for regulatory.db failed
>>>>> with error -2
>>>>> brcmfmac mmc2:0001:1: Direct firmware load for
>>>>> brcm/brcmfmac43340-sdio.Intel Corporation-Merrifield.bin failed with
>>>>> error -2
>>>>> sof-audio-pci-intel-tng 0000:00:0d.0: error: I/O region is too small.
>>>>> sof-audio-pci-intel-tng 0000:00:0d.0: error: failed to probe DSP -19
>>>>>
>>>>>
>>>>>>> This is done through configfs only when the switch is set to 
>>>>>>> device mode.
>>>>>> Sure, but can it be disabled? We are looking for unknown 
>>>>>> variables, so
>>>>>> excluding this would be a reasonable thing to do.
>>>>> It's not enabled until I flip the switch to device mode.
>>>> OK to cut this back and forth short, I think it'd be easier to just
>>>> ask you to run what I run. Here's vanilla v6.0 bzImage and initrd
>>>> (built with your config + CONFIG_PHY_TUSB1210=y) I tested with
>>> What do you mean by this? My config is with
>>>
>>> CONFIG_GENERIC_PHY=y
>>> CONFIG_PHY_TUSB1210=y
>>>
>> $ cat config-6.0.0-edison-acpi-standard | grep 1210
>> # CONFIG_PHY_TUSB1210 is not set
>> $ md5sum config-6.0.0-edison-acpi-standard
>> 3c989c708302c1f9e73c6113e71aed9d  config-6.0.0-edison-acpi-standard
>>
>> I had to manually enable it, that's what I meant by my comment.
> 
> Unbelievable, seems I uploaded the wrong config. I just double checked 
> to see if any other differences:
> 
> scripts/diffconfig config-6.0.0-edison-acpi-standard-bad 
> config-6.0.0-edison-acpi-standard-good
>   GENERIC_PHY n -> y
>   PHY_TUSB1210 n -> y
> 
>>
>>>> https://drive.google.com/drive/folders/1H28AL1coPPZ2kLTYskDuDdWo-oE7DRPH?usp=sharing
>>>> let's see how it behaves on your setup. There's also the U-Boot binary
>>> Ok, it's getting weirder and weirder. The following is with my U-Boot
>>> and your kernel/initrd
>>>
>>> 1) I placed them in /boot which is on my btrfs partition on the emmc (my
>>> U-Boot has btrfs enabled)
>>>
>>> Linux kernel version 6.0.0-edison-acpi-standard
>>> (andreysm@neptunefw-builder) #8 SMP PREEMPT_DYNAMIC Sat Oct 15 18:47:19
>>> UTC 2022
>>> Building boot_params at 0x00090000
>>> Loading bzImage at address 100000 (12064480 bytes)
>>> Initial RAM disk at linear address 0x06000000, size 25165824 bytes
>>> Kernel command line: "quiet root=/dev/mmcblk0p8
>>> rootflags=subvol=@,compress=lzo rootfstype=btrfs console=ttyS2,115200n8
>>> earlyprintk=ttyS2,115200n8,keep loglevel=4 
>>> systemd.unit=multi-user.target"
>>> Kernel loaded at 00100000, setup_base=00090000
>>>
>> You shouldn't be using root from you storage since:
>>    a) the initrd I uploaded is self-containing, it doesn't need 
>> anything else
> 
> Yes I know. With the Yocto image we build our own that does switchroot.
> 
> Here I am inside your buildroot initrd, no fs from the emmc are mounted. 
> According to dmesg btrfs module is loaded later then dwc3, and scans 
> (finds) the btrfs partition in all cases without mounting.
> 
>>    b) your local data is another variable we don't want to introduce
>>
>> just "rootfstype=ramfs" should be enough for this and
>>
>>   root=/dev/mmcblk0p8 rootflags=subvol=@,compress=lzo rootfstype=btrfs
>>
>> should be dropped.
> 
> After some experimenting it appears "rootfstype=btrfs" causes the 
> buildroot rootfs to fail probing tsub1210.
> 
> I think you should be able to reproduce this.
> 
> However, changing "rootfstype=ramfs" for my (yocto) image (which 
> probably should be the right thing to do now I think about it) does not 
> resolve the failing to probe tsub1210. Comparing the dmesg with the 
> buildroot one shows that in my case a lot of stuff happens prior to dwc3:
> 
> raid6 does speed testing (this is used by btrfs)
> 
> btrfs is loaded
> 
> sdhci probed
> 
> acpi tables (for edison-arduino) loaded into configfs
> 
> external gpio muxes setup
> 
> finally xhci (tusb1210 is before this on the buildroot image)
> 
> 
>>
>>> Usb drive is not detected regardless booting with stick plugged or
>>> plugging later on.
>>>
>>> # lsusb
>>> Bus 001 Device 001: ID 1d6b:0002
>>> Bus 002 Device 001: ID 1d6b:0003
>>>
>>> No TUSB1210 probed
>>>
>>> # dmesg | grep dwc3
>>> #
>>>
>>> 2) I placed them in my vfat rescue partition
>>>
>>> Linux kernel version 6.0.0-edison-acpi-standard
>>> (andreysm@neptunefw-builder) #8 SMP PREEMPT_DYNAMIC Sat Oct 15 18:47:19
>>> UTC 2022
>>> Building boot_params at 0x00090000
>>> Loading bzImage at address 100000 (12064480 bytes)
>>> Initial RAM disk at linear address 0x06000000, size 25165824 bytes
>>> Kernel command line: "debugshell=0 tty1 console=ttyS2,115200n8
>>> root=/dev/mmcblk0p7 rootfstype=vfat systemd.unit=multi-user.target"
>>> Kernel loaded at 00100000, setup_base=00090000
>>>
>>> Usb drive is detected.
>> Yep, that's exactly my point about extra variables. So it looks like
>> something in your root btrfs partition is triggering this issue. I
>> don't really know the contents of your root file system, so don't
>> really have any suggestions there. Maybe old kernel modules are
>> getting picked up? Or something else is interfering ¯\_(ツ)_/¯
>>
>>> # lsusb
>>> Bus 001 Device 001: ID 1d6b:0002
>>> Bus 001 Device 002: ID 125f:312b
>>> Bus 002 Device 001: ID 1d6b:0003
>>>
>>> TUSB1210 probed
>>>
>>> # dmesg | grep dwc3
>>> [    8.605845] tusb1210 dwc3.0.auto.ulpi: GPIO lookup for consumer reset
>>> [    8.605876] tusb1210 dwc3.0.auto.ulpi: using ACPI for GPIO lookup
>>> [    8.605927] tusb1210 dwc3.0.auto.ulpi: using lookup tables for GPIO
>>> lookup
>>> [    8.605941] tusb1210 dwc3.0.auto.ulpi: No GPIO consumer reset found
>>> [    8.605956] tusb1210 dwc3.0.auto.ulpi: GPIO lookup for consumer cs
>>> [    8.605970] tusb1210 dwc3.0.auto.ulpi: using ACPI for GPIO lookup
>>> [    8.606011] tusb1210 dwc3.0.auto.ulpi: using lookup tables for GPIO
>>> lookup
>>> [    8.606024] tusb1210 dwc3.0.auto.ulpi: No GPIO consumer cs found
>>> [    8.669317] tusb1210 dwc3.0.auto.ulpi: error -110 writing val 0x41 to
>>> reg 0x80
>>>
>>> ## note: options debugshell, root and rootfstype are normally handled by
>>> a script in my initrd, so I guess here noop.
>>>
>>>> I use in that folder in case you want to give it a try.
>>>>
>>>> Now on Merrifield dwc3_get_extcon() doesn't do anything but call
>>>> extcon_get_extcon_dev() which doesn't touch any hardware or interact
>>>> with other drivers, so assuming
>>>>
>>>>> So current v6.0 has: dwc3_get_extcon - dwc3_get_dr_mode - ... -
>>>>> dwc3_core_init - .. - dwc3_core_init_mode (not working)
>>>>>
>>>>> I changed to: dwc3_get_dr_mode - dwc3_get_extcon - .. - 
>>>>> dwc3_core_init -
>>>>> .. - dwc3_core_init_mode (no change)
>>>>>
>>>>> Then to: dwc3_get_dr_mode - .. - dwc3_core_init - .. - 
>>>>> dwc3_get_extcon -
>>>>> dwc3_core_init_mode (works)
>>>> still holds(did you double check that with vanilla v6.0?) the only
>>> I didn't check
>>>> difference that I can see is execution timings. It seems to me it's
>>>> either an extra delay added by execution of  extcon_get_extcon_dev()
>>>> (unlikely) or multiple partial probes that include dwc3_core_init()
>>>> that change things. You can try to check the latter by adding an
>>>> artificial probe deferral point after dwc3_core_init(). Something like
>>>> (didn't test this):
>>>>
>>>> modified   drivers/usb/dwc3/core.c
>>>> @@ -1860,6 +1860,10 @@ static int dwc3_probe(struct platform_device 
>>>> *pdev)
>>>>     goto err3;
>>>>
>>>>     ret = dwc3_core_init(dwc);
>>>> + static int deferral_counter = 0;
>>>> + if (deferral_counter++ < 9) /* I counted 9 deferrals in my testing */
>>>> + ret = -EPROBE_DEFER;
>>>> +
>>>>     if (ret) {
>>>>     dev_err_probe(dev, ret, "failed to initialize core\n");
>>>>     goto err4;
>>> Not sure how you wanted this tested. So I assume on vanilla booting from
>>> btrfs on eemc. It crashes but maybe the trace is usefull. After crash it
>>> continues but no USB appears at all.
>>>
>> I think you'll have to experiment with that code placement to emulate
>> a deferred probe for the old location of "get extcon".  I'd focus on
>> figuring out the root filesystem variable first before trying to get
>> this to work.
> 
> Yes, did that as described above. I think that "rootfstype=btrfs" causes 
> some ordering issue, like as if xhci goes to soon. It goes before:
> 
> spi_master spi5: GPIO lookup for consumer cs
> 
> while tusb1210 when it does probe starts with:
> 
> tusb1210 dwc3.0.auto.ulpi: GPIO lookup for consumer reset
> 
> and xhci follow later.
> 
>> To be explicit, at this point I don't think the revert is really
>> warranted. I'm also happy to reply/help you with suggestions, but you
>> are going to have to start driving this.
> 
> I agree that reverting based on a "regression" can not be concluded here 
> as dwc3 on merrifield never worked without an out-of-tree patch. And 
> your patch makes that out-of-tree patch obsolete - that's a good thing.
> 
> But I do think your patch is exposing an older issue that makes dwc3 
> sensitive to ordering. I would very much appreciate if you could try 
> "rootfstype=btrfs" to reproduce. It think it would be a good thing to 
> resolve it so that the effort here has not been for nothing.
> 
> My next step will be to move around the code placement as you suggest. 
> (I can spend a few hours in the evenings only as this is not my day job, 
> so explains if I'm a bit slow to respond here).
> 
Here the results of moving the code around the same as before:
---
  drivers/usb/dwc3/core.c | 14 +++++++-------
  1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index d0237b30c9be..990de5bf1983 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1844,13 +1844,6 @@ static int dwc3_probe(struct platform_device *pdev)
  		goto err2;
  	}

-	dwc->edev = dwc3_get_extcon(dwc);
-	if (IS_ERR(dwc->edev)) {
-		ret = PTR_ERR(dwc->edev);
-		dev_err_probe(dwc->dev, ret, "failed to get extcon\n");
-		goto err3;
-	}
-
  	ret = dwc3_get_dr_mode(dwc);
  	if (ret)
  		goto err3;
@@ -1868,6 +1861,13 @@ static int dwc3_probe(struct platform_device *pdev)
  	dwc3_check_params(dwc);
  	dwc3_debugfs_init(dwc);

+	dwc->edev = dwc3_get_extcon(dwc);
+	if (IS_ERR(dwc->edev)) {
+		ret = PTR_ERR(dwc->edev);
+		dev_err_probe(dwc->dev, ret, "failed to get extcon\n");
+		goto err5;
+	}
+
  	ret = dwc3_core_init_mode(dwc);
  	if (ret)
  		goto err5;
-- 
2.34.1

When I apply this on vanilla v6.0 I go into the probe loop again. 
Applying this in combination with Andy's "driver core: Break infinite 
loop when deferred probe can't be satisfied" all works nicely as before.
