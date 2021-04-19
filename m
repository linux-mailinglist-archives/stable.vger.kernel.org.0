Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D83364B09
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbhDSUQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhDSUQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 16:16:09 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F45C06174A;
        Mon, 19 Apr 2021 13:15:37 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id n2so54857748ejy.7;
        Mon, 19 Apr 2021 13:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=WqB829/0qV363BBqrKfPvSS3HBrKDo+ax3K9iEsahyc=;
        b=sa6YopQZZbGyGtJ+gD2UEHyRQoVUzdq1A8vbVPZtzdrpiazUqPiuZNDC/3tjOhE4gA
         jKwveMOG2erHOxaJ2lw6MU/2/jWQ5QP/VyA5ceJrssiTxR/3tSh+3OkmDsfRStOUFaIq
         Jf0Ym2Wc0102VC3FcNS74YNfpU289+yNoKxmvFJhXF0Ag/9Qbzdzg6PQHx5lSb+Qr2IO
         1PJnEZxYXDYSrdZald7N0ZbSQlxc+tA+6LY5GSrM540sCrSgIfrRgsx2RnMxD2XnupMW
         7NHKaF0KAAST2QKCGas0ooFBwKTXc4W3vyAMq5WeTuqIxjRTbTsEy1LfIPhlkMGV5/y5
         yIxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=WqB829/0qV363BBqrKfPvSS3HBrKDo+ax3K9iEsahyc=;
        b=Iv0B+7EfyaGckFrVTafxA0GuZxs5km6eToF9Ijc0pFz2rv8lt9C9Jz1EafoiU9/Fa/
         GrwJsRVea73CDL9as8MtbaZxXhz2c7PA3GcvsUXjEJgls/ZCRD6UW//i6HxHSVq0euS0
         sn9agACrLzvlYWY+38s0OFBS3EpMqcqWnSWPsbNewUP1CKfaSZGyu4Y9+AJsvl/b+who
         qyItwGlD4+ewiVEqeVUIWcqnG4P58l6STDdi77uCg+qdDR3BJf8B1COGx5iuDX1L+JUC
         YxFrPzD7QedebYXolZxFsMwWDghnS0kTXUwZ1Ow9Z10PyHNU5yiwOYG/BUeRiXvdrD0f
         Jpxg==
X-Gm-Message-State: AOAM531yENREWvfCrCqqh+Y4oE2yF49jOvpTnCafgtEFUiIvW/maVWIp
        DgsMDZeN90MDw9hDGYKwCSagj+OddBSwyw==
X-Google-Smtp-Source: ABdhPJzMTPW5TEHrRsXLpNH1wqfx7/KznBu3w9sFRsgtVpl9YoUTdvghkyQtC88aXPitz6aiT/EbQQ==
X-Received: by 2002:a17:906:7206:: with SMTP id m6mr24003266ejk.281.1618863336429;
        Mon, 19 Apr 2021 13:15:36 -0700 (PDT)
Received: from ?IPv6:2001:981:6fec:1:c5ff:9fd6:3e2f:f252? ([2001:981:6fec:1:c5ff:9fd6:3e2f:f252])
        by smtp.gmail.com with ESMTPSA id r19sm10800734ejr.55.2021.04.19.13.15.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 13:15:35 -0700 (PDT)
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
From:   Ferry Toth <fntoth@gmail.com>
Message-ID: <109affec-2e0c-0882-4514-8cab72eec85b@gmail.com>
Date:   Mon, 19 Apr 2021 22:15:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <4a1245e3-023c-ec69-2ead-dacf5560ff9f@synopsys.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

Op 19-04-2021 om 01:03 schreef Thinh Nguyen:
> Ferry Toth wrote:
>> Hi
>>
>> Op 17-04-2021 om 16:22 schreef Ferry Toth:
>>> Hi
>>>
>>> Op 17-04-2021 om 04:27 schreef Thinh Nguyen:
>>>> Ferry Toth wrote:
>>>>> Hi
>>>>>
>>>>> Op 16-04-2021 om 00:23 schreef Thinh Nguyen:
>>>>>> Thinh Nguyen wrote:
>>>>>>> From: Yu Chen <chenyu56@huawei.com>
>>>>>>> From: John Stultz <john.stultz@linaro.org>
>>>>>>>
>>>>>>> According to the programming guide, to switch mode for DRD
>>>>>>> controller,
>>>>>>> the driver needs to do the following.
>>>>>>>
>>>>>>> To switch from device to host:
>>>>>>> 1. Reset controller with GCTL.CoreSoftReset
>>>>>>> 2. Set GCTL.PrtCapDir(host mode)
>>>>>>> 3. Reset the host with USBCMD.HCRESET
>>>>>>> 4. Then follow up with the initializing host registers sequence
>>>>>>>
>>>>>>> To switch from host to device:
>>>>>>> 1. Reset controller with GCTL.CoreSoftReset
>>>>>>> 2. Set GCTL.PrtCapDir(device mode)
>>>>>>> 3. Reset the device with DCTL.CSftRst
>>>>>>> 4. Then follow up with the initializing registers sequence
>>>>>>>
>>>>>>> Currently we're missing step 1) to do GCTL.CoreSoftReset and step
>>>>>>> 3) of
>>>>>>> switching from host to device. John Stult reported a lockup issue
>>>>>>> seen
>>>>>>> with HiKey960 platform without these steps[1]. Similar issue is
>>>>>>> observed
>>>>>>> with Ferry's testing platform[2].
>>>>>>>
>>>>>>> So, apply the required steps along with some fixes to Yu Chen's
>>>>>>> and John
>>>>>>> Stultz's version. The main fixes to their versions are the missing
>>>>>>> wait
>>>>>>> for clocks synchronization before clearing GCTL.CoreSoftReset and
>>>>>>> only
>>>>>>> apply DCTL.CSftRst when switching from host to device.
>>>>>>>
>>>>>>> [1]
>>>>>>> https://urldefense.com/v3/__https://lore.kernel.org/linux-usb/20210108015115.27920-1-john.stultz@linaro.org/__;!!A4F2R9G_pg!PW9Jbs4wv4a_zKGgZHN0FYrIpfecPX0Ouq9V3d16Yz-9-GSHqZWsfBAF-WkeqLhzN4i3$
>>>>>>>
>>>>>>>
>>>>>>> [2]
>>>>>>> https://urldefense.com/v3/__https://lore.kernel.org/linux-usb/0ba7a6ba-e6a7-9cd4-0695-64fc927e01f1@gmail.com/__;!!A4F2R9G_pg!PW9Jbs4wv4a_zKGgZHN0FYrIpfecPX0Ouq9V3d16Yz-9-GSHqZWsfBAF-WkeqGeZStt4$
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
>>>>>>> Cc: Ferry Toth <fntoth@gmail.com>
>>>>>>> Cc: Wesley Cheng <wcheng@codeaurora.org>
>>>>>>> Cc: <stable@vger.kernel.org>
>>>>>>> Fixes: 41ce1456e1db ("usb: dwc3: core: make dwc3_set_mode() work
>>>>>>> properly")
>>>>>>> Signed-off-by: Yu Chen <chenyu56@huawei.com>
>>>>>>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>>>>>>> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>>>>>>> ---
>>>>>>> Changes in v3:
>>>>>>> - Check if the desired mode is OTG, then keep the old flow
>>>>>>> - Remove condition for OTG support only since the device can still be
>>>>>>>      configured DRD host/device mode only
>>>>>>> - Remove redundant hw_mode check since __dwc3_set_mode() only applies
>>>>>>> when
>>>>>>>      hw_mode is DRD
>>>>>>> Changes in v2:
>>>>>>> - Initialize mutex per device and not as global mutex.
>>>>>>> - Add additional checks for DRD only mode
>>>>>>>
>>>>>>>     drivers/usb/dwc3/core.c | 27 +++++++++++++++++++++++++++
>>>>>>>     drivers/usb/dwc3/core.h |  5 +++++
>>>>>>>     2 files changed, 32 insertions(+)
>>>>>>>
>>>>>> Hi John,
>>>>>>
>>>>>> If possible, can you run a test with this version on your platform?
>>>>>>
>>>>>> Thanks,
>>>>>> Thinh
>>>>>>
>>>>> I tested this on edison-arduino with this patch on top of usb-next
>>>>> (5.12-rc7 + "increase BESL baseline to 6" to prevent throttling").
>>>>>
>>>>> On this platform there is a physical switch to switch roles. With this
>>>>> patch I find:
>>>>>
>>>>> - switch to host mode always works fine
>>>>>
>>>>> - switch to gadget mode I need to flip the switch 3x
>>>>> (gadget-host-gadget).
>>>>>
>>>>> An error message appears on the gadget side "dwc3 dwc3.0.auto: timed
>>>>> out
>>>>> waiting for SETUP phase" appears, but then the device connects to my
>>>>> PC,
>>>>> no throttling.
>>>>>
>>>>> - alternatively I can switch to gadget 1x and then unplug/replug the
>>>>> cable.
>>>>>
>>>>> No error message and connects fine.
>>>>>
>>>>> - if I flip the switch only once, on the PC side I get:
>>>>>
>>>>>     kernel: usb 1-5: new high-speed USB device number 18 usingxhci_hcd
>>>>>     kernel: usb 1-5: New USB device found, idVendor=1d6b,
>>>>>     idProduct=0104, bcdDevice= 1.00 kernel: usb 1-5: New USB device
>>>>>     strings: Mfr=1, Product=2, SerialNumber=3 kernel: usb 1-5: Product:
>>>>>     USBArmory Gadget kernel: usb 1-5: Manufacturer: USBArmory kernel:
>>>>>     usb 1-5: SerialNumber: 0123456789abcdef kernel: usb 1-5: can't set
>>>>>     config #1, error -110
>>>> The device failed at set_configuration() request and timed out. It
>>>> probably timed out from the status stage looking at the device err
>>>> print.
>>>>
>>>>> Then if I wait long enough on the gadget side I get:
>>>>>
>>>>>     root@yuna:~# ifconfig
>>>>>
>>>>>     usb0: flags=-28605<UP,BROADCAST,RUNNING,MULTICAST,DYNAMIC> mtu 1500
>>>>>     inet 169.254.119.239 netmask 255.255.0.0 broadcast 169.254.255.255
>>>>>     inet6 fe80::a8bb:ccff:fedd:eef1 prefixlen 64 scopeid 0x20<link>
>>>>>     ether aa:bb:cc:dd:ee:f1 txqueuelen 1000 (Ethernet) RX packets 490424
>>>>>     bytes 735146578 (701.0 MiB) RX errors 0 dropped 191 overruns 0 frame
>>>>>     0 TX packets 35279 bytes 2532746 (2.4 MiB) TX errors 0 dropped 0
>>>>>     overruns 0 carrier 0 collisions 0
>>>>>
>>>>> (correct would be: inet 10.42.0.221 netmask 255.255.255.0 broadcast
>>>>> 10.42.0.255)
>>>>>
>>>>> So much improved now, but it seems I am still missing something on
>>>>> plug.
>>>>>
>>>> That's great! We can look at it further. Can you capture the tracepoints
>>>> of the issue. Also, can you try with mass_storage gadget to see if the
>>>> result is the same?
>>> I have already gser, eem, mass_storage and uac2 combo. When eem fails,
>>> the mass_storage and uac2 don't appear (on KDE you get all kind of
>>> popups when they appear).
>>>
>>> So either all works, or all fails.
>>>
>>> I'll trace this later today.
>> Trace capturing switch from host-> gadget  here
>> https://urldefense.com/v3/__https://github.com/andy-shev/linux/files/6329600/5.12-rc7*2Busb-next.zip__;JQ!!A4F2R9G_pg!Oa6XGH3IqY3wwG5KK4FwPuNA0m3q5bRj7N6vdP-y4sAY6mya-96J90NJ0tJnXLOiNwGT$
>>
>> (Issue history:
>> https://urldefense.com/v3/__https://github.com/andy-shev/linux/issues/31__;!!A4F2R9G_pg!Oa6XGH3IqY3wwG5KK4FwPuNA0m3q5bRj7N6vdP-y4sAY6mya-96J90NJ0tJnXNc7KgAw$
>> )
>>
>> On the PC side this resulted to:
>>
>> apr 17 18:17:44 delfion kernel: usb 1-5: new high-speed USB device
>> number 12 using xhci_hcd
>> apr 17 18:17:44 delfion kernel: usb 1-5: New USB device found,
>> idVendor=1d6b, idProduct=0104, bcdDevice= 1.00
>> apr 17 18:17:44 delfion kernel: usb 1-5: New USB device strings: Mfr=1,
>> Product=2, SerialNumber=3
>> apr 17 18:17:44 delfion kernel: usb 1-5: Product: USBArmory Gadget
>> apr 17 18:17:44 delfion kernel: usb 1-5: Manufacturer: USBArmory
>> apr 17 18:17:44 delfion kernel: usb 1-5: SerialNumber: 0123456789abcdef
>> apr 17 18:17:49 delfion kernel: usb 1-5: can't set config #1, error -110
>>
>>
>> Thanks for all your help!
>>
> Looks like it's LPM related again. To confirm, try this:
> Disable LPM with this property "snps,usb2-gadget-lpm-disable"
> (Note that it's not the same as "snps,dis_enblslpm_quirk")

Yes, I confirm this helps.

Note: on startup I was in host mode, with gadget cable plugged. The 
first switch to gadget didn't work, all subsequent switches did work, as 
well as unplug/plug the cable.

> Make sure that your testing kernel has this patch [1]
> 475e8be53d04 ("usb: dwc3: gadget: Check for disabled LPM quirk")
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/commit/?h=usb-next&id=475e8be53d0496f9bc6159f4abb3ff5f9b90e8de
>
>
> The failure you saw was probably due the gadget function attempting
> to start a delayed status stage of the SET_CONFIGURATION request.
> By this time, the host already put the device in low power.
>
> The START_TRANSFER command needs to be executed while the device
> is on "ON" state (or U0 if eSS). We shouldn't use dwc->link_state
> to check for link state because we only enable link state change
> interrupt for some controller versions.
>
> Once you confirms disabling LPM works, try this fix:
>
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 6227641f2d31..06cdec79244e 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -309,10 +309,14 @@ int dwc3_send_gadget_ep_cmd(struct dwc3_ep *dep, unsigned int cmd,
>   
>          if (DWC3_DEPCMD_CMD(cmd) == DWC3_DEPCMD_STARTTRANSFER) {
>                  int             needs_wakeup;
> +               u8              link_state;
>   
> -               needs_wakeup = (dwc->link_state == DWC3_LINK_STATE_U1 ||
> -                               dwc->link_state == DWC3_LINK_STATE_U2 ||
> -                               dwc->link_state == DWC3_LINK_STATE_U3);
> +               reg = dwc3_readl(dwc->regs, DWC3_DSTS);
> +               link_state = DWC3_DSTS_USBLNKST(reg);
> +
> +               needs_wakeup = (link_state == DWC3_LINK_STATE_U1 ||
> +                               link_state == DWC3_LINK_STATE_U2 ||
> +                               link_state == DWC3_LINK_STATE_U3);
>   
>                  if (unlikely(needs_wakeup)) {
>                          ret = __dwc3_gadget_wakeup(dwc);
> @@ -1989,6 +1993,8 @@ static int __dwc3_gadget_wakeup(struct dwc3 *dwc)
>          case DWC3_LINK_STATE_RESET:
>          case DWC3_LINK_STATE_RX_DET:    /* in HS, means Early Suspend */
>          case DWC3_LINK_STATE_U3:        /* in HS, means SUSPEND */
> +       case DWC3_LINK_STATE_U2:        /* in HS, means Sleep (L1) */
> +       case DWC3_LINK_STATE_U1:
>          case DWC3_LINK_STATE_RESUME:
>                  break;
>          default:
>
Same (good) result as with "snps,usb2-gadget-lpm-disable". Including 
first switch from host->gadget not working.

After a 2 - 4 minutes the connection is dropped and reconnected.

On the gadget end journal shows:

Apr 19 22:08:42 yuna systemd-networkd[507]: usb0: Lost carrier
Apr 19 22:08:42 yuna systemd-journald[417]: Forwarding to syslog missed 
1 messages.
Apr 19 22:08:42 yuna systemd-timesyncd[469]: No network connectivity, 
watching for changes.
Apr 19 22:08:42 yuna kernel: IPv6: ADDRCONF(NETDEV_CHANGE): usb0: link 
becomes ready
Apr 19 22:08:42 yuna kernel[480]: [  624.382929] IPv6: 
ADDRCONF(NETDEV_CHANGE): usb0: link becomes ready
Apr 19 22:08:42 yuna systemd-networkd[507]: usb0: Gained carrier
Apr 19 22:08:44 yuna systemd-networkd[507]: usb0: Gained IPv6LL
Apr 19 22:08:44 yuna systemd-timesyncd[469]: Network configuration 
changed, trying to establish connection.
Apr 19 22:08:57 yuna systemd-timesyncd[469]: Initial synchronization to 
time server 216.239.35.8:123 (time3.google.com).

So, drops and immediately reconnects.

>
>
> BR,
> Thinh
