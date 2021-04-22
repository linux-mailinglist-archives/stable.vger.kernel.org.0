Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB75F368847
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 22:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239497AbhDVU4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 16:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239495AbhDVU4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 16:56:12 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E24C06174A;
        Thu, 22 Apr 2021 13:55:35 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id mh2so49255506ejb.8;
        Thu, 22 Apr 2021 13:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=dEQlBQ+cKNmvrna+slH7W/hMGqqCGXx5n3UWJyZ8sYQ=;
        b=aQPxJr4TxH5FQe6Tr21BLzR9VMqBUL40Krw4ITVx/BARvappmztuiXl95pYypsK97g
         ZEqj7NA5ic/IhLv9TWSjs9y6FhQI5A0Gj+al5w2pVM/uBsseA94XL39aoxR/O9PnEFBg
         0L3atuGzvBPvYzXjMYu1KBoP0+HbNesraRvpr5+ktKBieDD2gBuH/5A3Lyeg9PcMfKy6
         VhrIGoT7tpki7yvNvzpezLVBcy8zgxace9IAzlOxKVpjpTG1YcpTg09XHEffHe9P+a8F
         dUNcrCOS78wHEUaFsQM9foJCDzPNj0Mn2KuvUtMfCDKaSWj15v5yeOBbwe80aOjzOJZQ
         SqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dEQlBQ+cKNmvrna+slH7W/hMGqqCGXx5n3UWJyZ8sYQ=;
        b=Rkc3MVQciNUtNcfK7BbdYnM17a/Y11KCPRYE4nluJIVYNT5GjAfkAdil3xZEbuBv50
         btLaN//ZZVFIv68qgauy4D0RXBoWPyYGNXJxEas23qTr5BgT89j/yft9bKDH6DVcR6al
         tTiGK0g5BI5LbAiIf5taOIGZ0ODVWXl4eOp9wMIwiNYRGSvnk1VNUZ4Ry0S0ysibnkON
         UShBM5o2iQg+Wlz6s49gmR6/Q7HogfgYj9JDkbf593sEyNIT7B+VQsFxk7hpE7AMnX2h
         3d5kjHZQ/7Q0ELv8e7+E37eu2D6bFDtJvvgSLqMltAzfUA54B6iyPehuvs0Ka85L7KDK
         pbvQ==
X-Gm-Message-State: AOAM532o9Q9HEHY1I+EXhklMSpnx4Kq27J+I4KHrV7qMQHHH3ZQW8n1f
        81ZHANGW8CK26F4KRRFZs8OcyM62LDeOBQ==
X-Google-Smtp-Source: ABdhPJywLNvFriI5I8KqH4xnzheaDmAX8/OfwFjPocj1tGLFXjUnaWLI/u88nXnTerJNaoXFL5q1GA==
X-Received: by 2002:a17:907:9894:: with SMTP id ja20mr596936ejc.428.1619124933816;
        Thu, 22 Apr 2021 13:55:33 -0700 (PDT)
Received: from ?IPv6:2001:981:6fec:1:8cd0:2dad:989e:1456? ([2001:981:6fec:1:8cd0:2dad:989e:1456])
        by smtp.gmail.com with ESMTPSA id cm21sm2925238edb.29.2021.04.22.13.55.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 13:55:33 -0700 (PDT)
Subject: Re: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        John Stultz <john.stultz@linaro.org>
Cc:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Yu Chen <chenyu56@huawei.com>, Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
References: <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
 <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
 <d053b843-2308-6b42-e7ff-3dc6e33e5c7d@synopsys.com>
 <0882cfae-4708-a67a-f112-c1eb0c7e6f51@gmail.com>
 <1c1d8e4a-c495-4d51-b125-c3909a3bdb44@synopsys.com>
 <db5849f7-ba31-8b18-ebb5-f27c4e36de28@gmail.com>
 <09755742-c73b-f737-01c1-8ecd309de551@gmail.com>
 <4a1245e3-023c-ec69-2ead-dacf5560ff9f@synopsys.com>
 <109affec-2e0c-0882-4514-8cab72eec85b@gmail.com>
 <fdaebefd-36c2-84e0-164f-c376483a0db3@synopsys.com>
 <a485bdc8-35e9-d58b-1411-84463274bb6d@gmail.com>
 <d9bca287-92fe-b2c8-511c-0ae89d2745c9@synopsys.com>
From:   Ferry Toth <fntoth@gmail.com>
Message-ID: <c9ef4bca-9fad-bb66-5ea3-2bd07b5b4e3e@gmail.com>
Date:   Thu, 22 Apr 2021 22:55:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <d9bca287-92fe-b2c8-511c-0ae89d2745c9@synopsys.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

Op 21-04-2021 om 21:01 schreef Thinh Nguyen:
> Ferry Toth wrote:
>> Hi
>>
>> Op 19-04-2021 om 23:23 schreef Thinh Nguyen:
>>> Ferry Toth wrote:
>>>> Hi
>>>>
>>>> Op 19-04-2021 om 01:03 schreef Thinh Nguyen:
>>>>> Ferry Toth wrote:
>>>>>> Hi
>>>>>>
>>>>>> Op 17-04-2021 om 16:22 schreef Ferry Toth:
>>>>>>> Hi
>>>>>>>
>>>>>>> Op 17-04-2021 om 04:27 schreef Thinh Nguyen:
>>>>>>>> Ferry Toth wrote:
>>>>>>>>> Hi
>>>>>>>>>
>>>>>>>>> Op 16-04-2021 om 00:23 schreef Thinh Nguyen:
>>>>>>>>>> Thinh Nguyen wrote:
>>>>>>>>>>> From: Yu Chen <chenyu56@huawei.com>
>>>>>>>>>>> From: John Stultz <john.stultz@linaro.org>
>>>>>>>>>>>
>>>>>>>>>>> According to the programming guide, to switch mode for DRD
>>>>>>>>>>> controller,
>>>>>>>>>>> the driver needs to do the following.
>>>>>>>>>>>
>>>>>>>>>>> To switch from device to host:
>>>>>>>>>>> 1. Reset controller with GCTL.CoreSoftReset
>>>>>>>>>>> 2. Set GCTL.PrtCapDir(host mode)
>>>>>>>>>>> 3. Reset the host with USBCMD.HCRESET
>>>>>>>>>>> 4. Then follow up with the initializing host registers sequence
>>>>>>>>>>>
>>>>>>>>>>> To switch from host to device:
>>>>>>>>>>> 1. Reset controller with GCTL.CoreSoftReset
>>>>>>>>>>> 2. Set GCTL.PrtCapDir(device mode)
>>>>>>>>>>> 3. Reset the device with DCTL.CSftRst
>>>>>>>>>>> 4. Then follow up with the initializing registers sequence
>>>>>>>>>>>
>>>>>>>>>>> Currently we're missing step 1) to do GCTL.CoreSoftReset and step
>>>>>>>>>>> 3) of
>>>>>>>>>>> switching from host to device. John Stult reported a lockup issue
>>>>>>>>>>> seen
>>>>>>>>>>> with HiKey960 platform without these steps[1]. Similar issue is
>>>>>>>>>>> observed
>>>>>>>>>>> with Ferry's testing platform[2].
>>>>>>>>>>>
>>>>>>>>>>> So, apply the required steps along with some fixes to Yu Chen's
>>>>>>>>>>> and John
>>>>>>>>>>> Stultz's version. The main fixes to their versions are the
>>>>>>>>>>> missing
>>>>>>>>>>> wait
>>>>>>>>>>> for clocks synchronization before clearing GCTL.CoreSoftReset and
>>>>>>>>>>> only
>>>>>>>>>>> apply DCTL.CSftRst when switching from host to device.
>>>>>>>>>>>
>>>>>>>>>>> [1]
>>>>>>>>>>> https://urldefense.com/v3/__https://lore.kernel.org/linux-usb/20210108015115.27920-1-john.stultz@linaro.org/__;!!A4F2R9G_pg!PW9Jbs4wv4a_zKGgZHN0FYrIpfecPX0Ouq9V3d16Yz-9-GSHqZWsfBAF-WkeqLhzN4i3$
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> [2]
>>>>>>>>>>> https://urldefense.com/v3/__https://lore.kernel.org/linux-usb/0ba7a6ba-e6a7-9cd4-0695-64fc927e01f1@gmail.com/__;!!A4F2R9G_pg!PW9Jbs4wv4a_zKGgZHN0FYrIpfecPX0Ouq9V3d16Yz-9-GSHqZWsfBAF-WkeqGeZStt4$
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
>>>>>>>>>>> Cc: Ferry Toth <fntoth@gmail.com>
>>>>>>>>>>> Cc: Wesley Cheng <wcheng@codeaurora.org>
>>>>>>>>>>> Cc: <stable@vger.kernel.org>
>>>>>>>>>>> Fixes: 41ce1456e1db ("usb: dwc3: core: make dwc3_set_mode() work
>>>>>>>>>>> properly")
>>>>>>>>>>> Signed-off-by: Yu Chen <chenyu56@huawei.com>
>>>>>>>>>>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>>>>>>>>>>> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>>>>>>>>>>> ---
>>>>>>>>>>> Changes in v3:
>>>>>>>>>>> - Check if the desired mode is OTG, then keep the old flow
>>>>>>>>>>> - Remove condition for OTG support only since the device can
>>>>>>>>>>> still be
>>>>>>>>>>>        configured DRD host/device mode only
>>>>>>>>>>> - Remove redundant hw_mode check since __dwc3_set_mode() only
>>>>>>>>>>> applies
>>>>>>>>>>> when
>>>>>>>>>>>        hw_mode is DRD
>>>>>>>>>>> Changes in v2:
>>>>>>>>>>> - Initialize mutex per device and not as global mutex.
>>>>>>>>>>> - Add additional checks for DRD only mode
>>>>>>>>>>>
>>>>>>>>>>>       drivers/usb/dwc3/core.c | 27 +++++++++++++++++++++++++++
>>>>>>>>>>>       drivers/usb/dwc3/core.h |  5 +++++
>>>>>>>>>>>       2 files changed, 32 insertions(+)
>>>>>>>>>>>
>>>>>>>>>> Hi John,
>>>>>>>>>>
>>>>>>>>>> If possible, can you run a test with this version on your
>>>>>>>>>> platform?
>>>>>>>>>>
>>>>>>>>>> Thanks,
>>>>>>>>>> Thinh
>>>>>>>>>>
>>>>>>>>> I tested this on edison-arduino with this patch on top of usb-next
>>>>>>>>> (5.12-rc7 + "increase BESL baseline to 6" to prevent throttling").
>>>>>>>>>
>>>>>>>>> On this platform there is a physical switch to switch roles. With
>>>>>>>>> this
>>>>>>>>> patch I find:
>>>>>>>>>
>>>>>>>>> - switch to host mode always works fine
>>>>>>>>>
>>>>>>>>> - switch to gadget mode I need to flip the switch 3x
>>>>>>>>> (gadget-host-gadget).
>>>>>>>>>
>>>>>>>>> An error message appears on the gadget side "dwc3 dwc3.0.auto:
>>>>>>>>> timed
>>>>>>>>> out
>>>>>>>>> waiting for SETUP phase" appears, but then the device connects
>>>>>>>>> to my
>>>>>>>>> PC,
>>>>>>>>> no throttling.
>>>>>>>>>
>>>>>>>>> - alternatively I can switch to gadget 1x and then unplug/replug
>>>>>>>>> the
>>>>>>>>> cable.
>>>>>>>>>
>>>>>>>>> No error message and connects fine.
>>>>>>>>>
>>>>>>>>> - if I flip the switch only once, on the PC side I get:
>>>>>>>>>
>>>>>>>>>       kernel: usb 1-5: new high-speed USB device number 18
>>>>>>>>> usingxhci_hcd
>>>>>>>>>       kernel: usb 1-5: New USB device found, idVendor=1d6b,
>>>>>>>>>       idProduct=0104, bcdDevice= 1.00 kernel: usb1-5: New USB device
>>>>>>>>>       strings: Mfr=1, Product=2, SerialNumber=3kernel:usb 1-5:
>>>>>>>>> Product:
>>>>>>>>>       USBArmory Gadget kernel: usb 1-5: Manufacturer:USBArmory
>>>>>>>>> kernel:
>>>>>>>>>       usb 1-5: SerialNumber: 0123456789abcdef kernel:usb 1-5: can't
>>>>>>>>> set
>>>>>>>>>       config #1, error -110
>>>>>>>> The device failed at set_configuration() request and timed out. It
>>>>>>>> probably timed out from the status stage looking at the device err
>>>>>>>> print.
>>>>>>>>
>>>>>>>>> Then if I wait long enough on the gadget side I get:
>>>>>>>>>
>>>>>>>>>       root@yuna:~# ifconfig
>>>>>>>>>
>>>>>>>>>       usb0: flags=-28605<UP,BROADCAST,RUNNING,MULTICAST,DYNAMIC> mtu
>>>>>>>>> 1500
>>>>>>>>>       inet 169.254.119.239 netmask 255.255.0.0 broadcast
>>>>>>>>> 169.254.255.255
>>>>>>>>>       inet6 fe80::a8bb:ccff:fedd:eef1 prefixlen 64 scopeid
>>>>>>>>> 0x20<link>
>>>>>>>>>       ether aa:bb:cc:dd:ee:f1 txqueuelen 1000 (Ethernet) RX packets
>>>>>>>>> 490424
>>>>>>>>>       bytes 735146578 (701.0 MiB) RX errors 0 dropped191 overruns 0
>>>>>>>>> frame
>>>>>>>>>       0 TX packets 35279 bytes 2532746 (2.4 MiB) TX errors 0
>>>>>>>>> dropped 0
>>>>>>>>>       overruns 0 carrier 0 collisions 0
>>>>>>>>>
>>>>>>>>> (correct would be: inet 10.42.0.221 netmask 255.255.255.0 broadcast
>>>>>>>>> 10.42.0.255)
>>>>>>>>>
>>>>>>>>> So much improved now, but it seems I am still missing something on
>>>>>>>>> plug.
>>>>>>>>>
>>>>>>>> That's great! We can look at it further. Can you capture the
>>>>>>>> tracepoints
>>>>>>>> of the issue. Also, can you try with mass_storage gadget to see
>>>>>>>> if the
>>>>>>>> result is the same?
>>>>>>> I have already gser, eem, mass_storage and uac2 combo. When eem
>>>>>>> fails,
>>>>>>> the mass_storage and uac2 don't appear (on KDE you get all kind of
>>>>>>> popups when they appear).
>>>>>>>
>>>>>>> So either all works, or all fails.
>>>>>>>
>>>>>>> I'll trace this later today.
>>>>>> Trace capturing switch from host-> gadget  here
>>>>>> https://urldefense.com/v3/__https://github.com/andy-shev/linux/files/6329600/5.12-rc7*2Busb-next.zip__;JQ!!A4F2R9G_pg!Oa6XGH3IqY3wwG5KK4FwPuNA0m3q5bRj7N6vdP-y4sAY6mya-96J90NJ0tJnXLOiNwGT$
>>>>>>
>>>>>>
>>>>>>
>>>>>> (Issue history:
>>>>>> https://urldefense.com/v3/__https://github.com/andy-shev/linux/issues/31__;!!A4F2R9G_pg!Oa6XGH3IqY3wwG5KK4FwPuNA0m3q5bRj7N6vdP-y4sAY6mya-96J90NJ0tJnXNc7KgAw$
>>>>>>
>>>>>>
>>>>>> )
>>>>>>
>>>>>> On the PC side this resulted to:
>>>>>>
>>>>>> apr 17 18:17:44 delfion kernel: usb 1-5: new high-speed USB device
>>>>>> number 12 using xhci_hcd
>>>>>> apr 17 18:17:44 delfion kernel: usb 1-5: New USB device found,
>>>>>> idVendor=1d6b, idProduct=0104, bcdDevice= 1.00
>>>>>> apr 17 18:17:44 delfion kernel: usb 1-5: New USB device strings:
>>>>>> Mfr=1,
>>>>>> Product=2, SerialNumber=3
>>>>>> apr 17 18:17:44 delfion kernel: usb 1-5: Product: USBArmory Gadget
>>>>>> apr 17 18:17:44 delfion kernel: usb 1-5: Manufacturer: USBArmory
>>>>>> apr 17 18:17:44 delfion kernel: usb 1-5: SerialNumber:
>>>>>> 0123456789abcdef
>>>>>> apr 17 18:17:49 delfion kernel: usb 1-5: can't set config #1, error
>>>>>> -110
>>>>>>
>>>>>>
>>>>>> Thanks for all your help!
>>>>>>
>>>>> Looks like it's LPM related again. To confirm, try this:
>>>>> Disable LPM with this property "snps,usb2-gadget-lpm-disable"
>>>>> (Note that it's not the same as "snps,dis_enblslpm_quirk")
>>>> Yes, I confirm this helps.
>>>>
>>>> Note: on startup I was in host mode, with gadget cable plugged. The
>>>> first switch to gadget didn't work, all subsequent switches did work, as
>>>> well as unplug/plug the cable.
>>>>
>>>>> Make sure that your testing kernel has this patch [1]
>>>>> 475e8be53d04 ("usb: dwc3: gadget: Check for disabled LPM quirk")
>>>>>
>>>>> [1]
>>>>> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/commit/?h=usb-next&id=475e8be53d0496f9bc6159f4abb3ff5f9b90e8de__;!!A4F2R9G_pg!Mvz1Am6Ka_pOBfD0TmsA3821I05Ti8stMgh5r4XzMwZ9dy1Wan-il-DB4h50DmbaU4Zw$
>>>>>
>>>>>
>>>>>
>>>>> The failure you saw was probably due the gadget function attempting
>>>>> to start a delayed status stage of the SET_CONFIGURATION request.
>>>>> By this time, the host already put the device in low power.
>>>>>
>>>>> The START_TRANSFER command needs to be executed while the device
>>>>> is on "ON" state (or U0 if eSS). We shouldn't use dwc->link_state
>>>>> to check for link state because we only enable link state change
>>>>> interrupt for some controller versions.
>>>>>
>>>>> Once you confirms disabling LPM works, try this fix:
>>>>>
>>>>> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
>>>>> index 6227641f2d31..06cdec79244e 100644
>>>>> --- a/drivers/usb/dwc3/gadget.c
>>>>> +++ b/drivers/usb/dwc3/gadget.c
>>>>> @@ -309,10 +309,14 @@ int dwc3_send_gadget_ep_cmd(struct dwc3_ep *dep,
>>>>> unsigned int cmd,
>>>>>              if (DWC3_DEPCMD_CMD(cmd) == DWC3_DEPCMD_STARTTRANSFER) {
>>>>>                    int             needs_wakeup;
>>>>> +               u8              link_state;
>>>>>     -               needs_wakeup = (dwc->link_state ==
>>>>> DWC3_LINK_STATE_U1 ||
>>>>> -                               dwc->link_state == DWC3_LINK_STATE_U2||
>>>>> -                               dwc->link_state == DWC3_LINK_STATE_U3);
>>>>> +               reg = dwc3_readl(dwc->regs, DWC3_DSTS);
>>>>> +               link_state = DWC3_DSTS_USBLNKST(reg);
>>>>> +
>>>>> +               needs_wakeup = (link_state == DWC3_LINK_STATE_U1 ||
>>>>> +                               link_state == DWC3_LINK_STATE_U2 ||
>>>>> +                               link_state == DWC3_LINK_STATE_U3);
>>>>>                      if (unlikely(needs_wakeup)) {
>>>>>                           ret = __dwc3_gadget_wakeup(dwc);
>>>>> @@ -1989,6 +1993,8 @@ static int __dwc3_gadget_wakeup(struct dwc3 *dwc)
>>>>>            case DWC3_LINK_STATE_RESET:
>>>>>            case DWC3_LINK_STATE_RX_DET:    /* in HS, means Early
>>>>> Suspend */
>>>>>            case DWC3_LINK_STATE_U3:        /* in HS, means SUSPEND */
>>>>> +       case DWC3_LINK_STATE_U2:        /* in HS, means Sleep (L1) */
>>>>> +       case DWC3_LINK_STATE_U1:
>>>>>            case DWC3_LINK_STATE_RESUME:
>>>>>                    break;
>>>>>            default:
>>>>>
>>>> Same (good) result as with "snps,usb2-gadget-lpm-disable". Including
>>>> first switch from host->gadget not working.
>>>>
>>> Great! Not sure why the first switch is not working, but it seems like
>>> we were able to eliminate quite a few issues. If you have more dwc3
>>> tracepoints, we can take a look further.
>> I traced but the file is empty. I captured the registers as well. The
>> zip file is here:
>>
>> https://urldefense.com/v3/__https://github.com/andy-shev/linux/files/6346271/first-switch.zip__;!!A4F2R9G_pg!KAmPA0Vw1WUiSxdc5-BKNPyD0klvdr5ucZI3E_C2ojho2rNT9wzMs8HG4qCYSDx89HFE$
>>
>> I found the gadget configuration script was not called, which normally
>> gets called due to a udev rule:
>>
>> ACTION=="add", KERNEL=="dwc3.0.auto", SUBSYSTEMS=="udc",
>> ATTRS{state}=="not attached", RUN+="/usr/bin/conf-gadget.sh"
>>
>> So I retried and see  with ~# udevadm monitor:
>>
>> # flipping the switch from host->gadget
>>
>> KERNEL[51.824914] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/1-1.1:1.0/net/enp0s17u1u1/queues/rx-0
>> (queues)
>> KERNEL[51.825682] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/1-1.1:1.0/net/enp0s17u1u1/queues/tx-0
>> (queues)
>> KERNEL[51.826226] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/1-1.1:1.0/net/enp0s17u1u1
>> (net)
>> KERNEL[51.836041] unbind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/mdio_bus/usb-001:003/usb-001:003:01
>> (mdio_bus)
>> KERNEL[51.836709] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/mdio_bus/usb-001:003/usb-001:003:01
>> (mdio_bus)
>> KERNEL[51.837342] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/mdio_bus/usb-001:003
>> (mdio_bus)
>> KERNEL[51.837763] unbind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/1-1.1:1.0
>> (usb)
>> KERNEL[51.838116] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/1-1.1:1.0
>> (usb)
>> KERNEL[51.873712] unbind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1
>> (usb)
>> KERNEL[51.874000] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1
>> (usb)
>> KERNEL[51.874207] unbind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1:1.0
>> (usb)
>> KERNEL[51.874431] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1:1.0
>> (usb)
>> KERNEL[51.897175] unbind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1 (usb)
>> KERNEL[51.897486] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1 (usb)
>>
>> # stopped capture tracepoints here, then switch back to host
>>
>> KERNEL[253.214406] add
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1 (usb)
>> KERNEL[253.263305] change
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1 (usb)
>> KERNEL[253.263687] add
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1:1.0
>> (usb)
>> KERNEL[253.328354] bind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1:1.0
>> (usb)
>> KERNEL[253.328734] bind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1 (usb)
>> KERNEL[253.699341] add
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1
>> (usb)
>> KERNEL[253.744911] change
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1
>> (usb)
>> KERNEL[253.745804] add
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/1-1.1:1.0
>> (usb)
>> KERNEL[253.805307] add
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/mdio_bus/usb-001:005
>> (mdio_bus)
>> KERNEL[253.812978] add
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/mdio_bus/usb-001:005/usb-001:005:01
>> (mdio_bus)
>> KERNEL[253.814318] bind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/mdio_bus/usb-001:005/usb-001:005:01
>> (mdio_bus)
>> KERNEL[253.815386] add
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/1-1.1:1.0/net/eth0
>> (net)
>> KERNEL[253.815552] add
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/1-1.1:1.0/net/eth0/queues/rx-0
>> (queues)
>> KERNEL[253.815778] add
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/1-1.1:1.0/net/eth0/queues/tx-0
>> (queues)
>> KERNEL[253.825279] bind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/1-1.1:1.0
>> (usb)
>> KERNEL[253.825667] bind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1
>> (usb)
>>
>> # switch to gadget again
>>
>> KERNEL[314.212144] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/1-1.1:1.0/net/eth0/queues/rx-0
>> (queues)
>> KERNEL[314.212473] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/1-1.1:1.0/net/eth0/queues/tx-0
>> (queues)
>> KERNEL[314.214691] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/1-1.1:1.0/net/eth0
>> (net)
>>
>> # extcon event didn't show the first time
>>
>> KERNEL[314.238385] change
>> /devices/pci0000:00/0000:00:13.0/INTC100E:00/mrfld_bcove_pwrsrc/extcon/extcon0
>> (extcon)
>> KERNEL[314.238677] unbind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/mdio_bus/usb-001:005/usb-001:005:01
>> (mdio_bus)
>> KERNEL[314.238863] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/mdio_bus/usb-001:005/usb-001:005:01
>> (mdio_bus)
>> KERNEL[314.239015] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/mdio_bus/usb-001:005
>> (mdio_bus)
>> KERNEL[314.239205] unbind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/1-1.1:1.0
>> (usb)
>> KERNEL[314.239429] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1/1-1.1:1.0
>> (usb)
>> KERNEL[314.239666] unbind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb2/2-0:1.0 (usb)
>>
>> KERNEL[314.239933] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb2/2-0:1.0 (usb)
>>
>> KERNEL[314.262713] unbind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb2 (usb)
>> KERNEL[314.263030] unbind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1
>> (usb)
>> KERNEL[314.263298] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb2 (usb)
>> KERNEL[314.263569] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1.1
>> (usb)
>> KERNEL[314.263815] unbind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1:1.0
>> (usb)
>> KERNEL[314.264042] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1/1-1:1.0
>> (usb)
>> KERNEL[314.264753] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usbmon/usbmon2
>> (usbmon)
>> KERNEL[314.265019] unbind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1 (usb)
>> KERNEL[314.265289] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-1 (usb)
>> KERNEL[314.288792] unbind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-0:1.0 (usb)
>>
>> KERNEL[314.289057] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1/1-0:1.0 (usb)
>>
>> KERNEL[314.289327] unbind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1 (usb)
>> KERNEL[314.289661] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usb1 (usb)
>> KERNEL[314.647375] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto/usbmon/usbmon1
>> (usbmon)
>> KERNEL[314.647816] unbind
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto (platform)
>> KERNEL[314.648143] remove   /kernel/software_nodes/node1 (software_nodes)
>> KERNEL[314.648672] remove
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/xhci-hcd.2.auto (platform)
>>
>> # here is the event we were waiting for
>>
>> KERNEL[314.649158] add
>> /devices/pci0000:00/0000:00:11.0/dwc3.0.auto/udc/dwc3.0.auto (udc)
>>
>> # after this gadget devices appear normally
>>
>> Maybe this issue is due to extcon missing the event?
>  From the info here, it doesn't look like the host platform device was
> removed on the first switch. Also, as you pointed it out, the extcon
> event was not shown on the first switch either. Without a notification
> to switch mode, the dwc3 driver won't do anything. You need to check why
> that's the case as I can't help much here.
>
>>>> After a 2 - 4 minutes the connection is dropped and reconnected.
>>> Does this occur with LPM disabled also? We can review this issue further
>>> with more dwc3 tracepoints.
>> I captured connection dropping and reconnecting in this fairly long
>> trace near the end of the file:
>>
>> https://urldefense.com/v3/__https://github.com/andy-shev/linux/files/6346323/lost-connection.zip__;!!A4F2R9G_pg!KAmPA0Vw1WUiSxdc5-BKNPyD0klvdr5ucZI3E_C2ojho2rNT9wzMs8HG4qCYSIuUHRz4$
>>
> Nothing obvious stands out as a problem from the dwc3 driver or the
> controller. I see a (port) reset after 30 seconds of inactivity, which
> is a typical timeout and recovery mechanism in the upperlayer from host.
>
> * Is this a new issue or was it always there?
> * Does turning off LPM help?

I reverted my "usb: gadget: increase BESL baseline to 6" and picked 
"usb: dwc3: pci: Enable dis_enblslpm_quirk for Intel Merrifield".

So this is again the big hammer you suggested earlier to turn off LPM.


After 15 min (at least 4x longer then normal to get a port reset) I have 
still not seen a port reset.


So for now I conclude, yes turning off LPM helps.


> * Are the other gadget functions still work during the 30 seconds
> inactivity?
>
>
>>>> On the gadget end journal shows:
>>>>
>>>> Apr 19 22:08:42 yuna systemd-networkd[507]: usb0: Lost carrier
>>>> Apr 19 22:08:42 yuna systemd-journald[417]: Forwarding to syslog missed
>>>> 1 messages.
>>>> Apr 19 22:08:42 yuna systemd-timesyncd[469]: No network connectivity,
>>>> watching for changes.
>>>> Apr 19 22:08:42 yuna kernel: IPv6: ADDRCONF(NETDEV_CHANGE): usb0: link
>>>> becomes ready
>>>> Apr 19 22:08:42 yuna kernel[480]: [  624.382929] IPv6:
>>>> ADDRCONF(NETDEV_CHANGE): usb0: link becomes ready
>>>> Apr 19 22:08:42 yuna systemd-networkd[507]: usb0: Gained carrier
>>>> Apr 19 22:08:44 yuna systemd-networkd[507]: usb0: Gained IPv6LL
>>>> Apr 19 22:08:44 yuna systemd-timesyncd[469]: Network configuration
>>>> changed, trying to establish connection.
>>>> Apr 19 22:08:57 yuna systemd-timesyncd[469]: Initial synchronization to
>>>> time server 216.239.35.8:123 (time3.google.com).
>>>>
>>>> So, drops and immediately reconnects.
>>>>
>>>   From the look at the log here, it seems to be a reset from host (and an
>>> issue at the protocol level) unrelated to dwc3 driver or the controller.
>>> Hopefully and maybe we can get more clues from dwc3 tracepoints.
>>>
> BR,
> Thinh
