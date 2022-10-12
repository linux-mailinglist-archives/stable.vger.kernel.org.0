Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0FCD5FC313
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 11:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiJLJaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 05:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiJLJaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 05:30:21 -0400
Received: from radex-web.radex.nl (smtp.radex.nl [178.250.146.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A77145E57E;
        Wed, 12 Oct 2022 02:30:18 -0700 (PDT)
Received: from [192.168.1.35] (cust-178-250-146-69.breedbanddelft.nl [178.250.146.69])
        by radex-web.radex.nl (Postfix) with ESMTPS id 701502406A;
        Wed, 12 Oct 2022 11:30:17 +0200 (CEST)
Message-ID: <113fe314-0f5c-f53f-db78-c93bd4515260@gmail.com>
Date:   Wed, 12 Oct 2022 11:30:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
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
 <20220927155332.10762-3-andriy.shevchenko@linux.intel.com>
 <20221003215734.7l3cnb2zy57nrxkk@synopsys.com>
 <YzvusOI89ju9e5+0@smile.fi.intel.com>
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
From:   Ferry Toth <fntoth@gmail.com>
In-Reply-To: <CAHQ1cqGSXoUTopwvrQtLww5M0Tf=6F505ziLn+wGHhW_8-JhFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NICE_REPLY_A,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

On 11-10-2022 22:50, Andrey Smirnov wrote:
> On Tue, Oct 11, 2022 at 11:54 AM Ferry Toth <fntoth@gmail.com> wrote:
>> Hi,
>>
>> Op 10-10-2022 om 23:35 schreef Andrey Smirnov:
>>> On Mon, Oct 10, 2022 at 1:52 PM Ferry Toth <fntoth@gmail.com> wrote:
>>>> Hi
>>>>
>>>> Op 10-10-2022 om 13:04 schreef Ferry Toth:
>>>>> Hi
>>>>>
>>>>> On 10-10-2022 07:02, Andrey Smirnov wrote:
>>>>>> On Fri, Oct 7, 2022 at 6:07 AM Ferry Toth <fntoth@gmail.com> wrote:
>>>>>>> On 07-10-2022 04:11, Thinh Nguyen wrote:
>>>>>>>> On Thu, Oct 06, 2022, Ferry Toth wrote:
>>>>>>>>> Hi
>>>>>>>>>
>>>>>>>>> On 06-10-2022 04:12, Thinh Nguyen wrote:
>>>>>>>>>> On Wed, Oct 05, 2022, Ferry Toth wrote:
>>>>>>>>>>> Hi,
>>>>>>>>>>>
>>>>>>>>>>>          Thanks!
>>>>>>>>>>>
>>>>>>>>>>>          Does the failure only happen the first time host is
>>>>>>>>>>> initialized? Or can
>>>>>>>>>>>          it recover after switching to device then back to host mode?
>>>>>>>>>>>
>>>>>>>>>>> I can switch back and forth and device mode works each time,
>>>>>>>>>>> host mode remains
>>>>>>>>>>> dead.
>>>>>>>>>> Ok.
>>>>>>>>>>
>>>>>>>>>>>          Probably the failure happens if some step(s) in
>>>>>>>>>>> dwc3_core_init() hasn't
>>>>>>>>>>>          completed.
>>>>>>>>>>>
>>>>>>>>>>>          tusb1210 is a phy driver right? The issue is probably
>>>>>>>>>>> because we didn't
>>>>>>>>>>>          initialize the phy yet. So, I suspect placing
>>>>>>>>>>> dwc3_get_extcon() after
>>>>>>>>>>>          initializing the phy will probably solve the dependency
>>>>>>>>>>> problem.
>>>>>>>>>>>
>>>>>>>>>>>          You can try something for yourself or I can provide
>>>>>>>>>>> something to test
>>>>>>>>>>>          later if you don't mind (maybe next week if it's ok).
>>>>>>>>>>>
>>>>>>>>>>> Yes, the code move I mentioned above "moves dwc3_get_extcon()
>>>>>>>>>>> until after
>>>>>>>>>>> dwc3_core_init() but just before dwc3_core_init_mode(). AFAIU
>>>>>>>>>>> initially
>>>>>>>>>>> dwc3_get_extcon() was called from within dwc3_core_init_mode()
>>>>>>>>>>> but only for
>>>>>>>>>>> case USB_DR_MODE_OTG. So with this change order of events is
>>>>>>>>>>> more or less
>>>>>>>>>>> unchanged" solves the issue.
>>>>>>>>>>>
>>>>>>>>>> I saw the experiment you did from the link you provided. We want
>>>>>>>>>> to also
>>>>>>>>>> confirm exactly which step in dwc3_core_init() was needed.
>>>>>>>>> Ok. I first tried the code move suggested by Andrey (didn't work).
>>>>>>>>> Then
>>>>>>>>> after reading the actual code I moved a bit further.
>>>>>>>>>
>>>>>>>>> This move was on top of -rc6 without any reverts. I did not make
>>>>>>>>> additional
>>>>>>>>> changes to dwc3_core_init()
>>>>>>>>>
>>>>>>>>> So current v6.0 has: dwc3_get_extcon - dwc3_get_dr_mode - ... -
>>>>>>>>> dwc3_core_init - .. - dwc3_core_init_mode (not working)
>>>>>>>>>
>>>>>>>>> I changed to: dwc3_get_dr_mode - dwc3_get_extcon - .. -
>>>>>>>>> dwc3_core_init - ..
>>>>>>>>> - dwc3_core_init_mode (no change)
>>>>>>>>>
>>>>>>>>> Then to: dwc3_get_dr_mode - .. - dwc3_core_init - .. -
>>>>>>>>> dwc3_get_extcon -
>>>>>>>>> dwc3_core_init_mode (works)
>>>>>>>>>
>>>>>>>>> .. are what I believe for this issue irrelevant calls to
>>>>>>>>> dwc3_alloc_scratch_buffers, dwc3_check_params and dwc3_debugfs_init.
>>>>>>>>>
>>>>>>>> Right. Thanks for narrowing it down. There are still many steps in
>>>>>>>> dwc3_core_init(). We have some suspicion, but we still haven't
>>>>>>>> confirmed
>>>>>>>> the exact cause of the failure. We can write a proper patch once we
>>>>>>>> know
>>>>>>>> the reason.
>>>>>>> If you would like me to test your suspicion, just tell me what to do
>>>>>>> :-)
>>>>>> OK, Ferry, I think I'm going to need clarification on specifics on
>>>>>> your test setup. Can you share your kernel config, maybe your
>>>>>> "/proc/config.gz", somewhere? When you say you are running vanilla
>>>>>> Linux, do you mean it or do you mean vanilla tree + some patch delta?
>>>>> For v6.0 I can get the exacts tonight. But earlier I had this for v5.17:
>>>>>
>>>>> https://github.com/htot/meta-intel-edison/blob/master/meta-intel-edison-bsp/recipes-kernel/linux/linux-yocto_5.17.bb
>>>>>
>>>>>
>>>>> There are 2 patches referred in #67 and #68. One is related to the
>>>>> infinite loop. The other is I believe also needed to get dwc3 to work.
>>>>>
>>>>> All the kernel config are applied as .cfg.
>>>>>
>>>>> Patches and cfs's here:
>>>>>
>>>>> https://github.com/htot/meta-intel-edison/tree/master/meta-intel-edison-bsp/recipes-kernel/linux/files
>>>>>
>>>> Updated Yocto recipe for v6.0 here:
>>>>
>>>> https://github.com/htot/meta-intel-edison/blob/honister/meta-intel-edison-bsp/recipes-kernel/linux/linux-yocto_6.0.bb
>>>>
>>>> #75-#77 are the 2 reverts from Andy, + one SOF revert (not related to
>>>> this thread).
>>> Please drop all of this
>>> https://github.com/htot/meta-intel-edison/blob/honister/meta-intel-edison-bsp/recipes-kernel/linux/linux-yocto_6.0.bb#L69-L77
>>> and re do the testing. Assuming things are still broken, that's how
>>> you want to do the bisecting.
>> I removed 4 patches:
>> 0043b-TODO-driver-core-Break-infinite-loop-when-deferred-p.patch
>> 0044-REVERTME-usb-dwc3-gadget-skip-endpoints-ep-18-in-out.patch
>> 0001-Revert-USB-fixup-for-merge-issue-with-usb-dwc3-Don-t.patch
>> 0001-Revert-usb-dwc3-Don-t-switch-OTG-peripheral-if-extco.patch
> Please remove all custom patches so we are on the same page. I don't
> suspect the 8250 related changes to affect anything, but I also would
> like to be testing the same thing. I'm testing vanilla v6.0
Alright, but don't expect any change. The 8250 patches are related to 
using DMA for the serial ports (except the console). It may affect 
bluetooth, the serial port on the arduino connector, but not the console.
>> and indeed as you expect kernel boots (no infinite loop). However dwc3
>> host mode is not working as in your case, device mode works fine (Yocto
>> configures a set of gadgets for me).
> What do you do to test host mode working? lsusb? Something else?
> Asking to make sure I'm doing something equivalent on my end.
>
I have a smsc95xx 4p usb hub with 1 eth port continuously plugged. It 
has leds on all ports so when it works it lights up like a Christmas tree.

But I also tried plugging a usb stick.

It maybe that lsusb is not enough. Iirc the root hub is there, but the 
tusb1210 not and then device plugs are not detected. So in my case none 
of the leds on the hub turn on.

>> Just to be sure if I could have bisected without 0043a I added back the
>> 2 0001-Revert* and indeed I run into the infinite loop with the console
>> spitting out continuous:
>> debugfs: Directory 'dwc3.0.auto' with parent 'ulpi' already present!
>> tusb1210 dwc3.0.auto.ulpi: error -110 writing val 0x41 to reg 0x80
>>
>> so yes it seems either 0043b or your patch "usb: dwc3: Don't switch OTG
>> -> peripheral if extcon is present" is needed to boot (break the
>> infinite loop). But your patch is in my case not sufficient to make host
>> mode work.
>>
> Next step would be to establish if USB is working before my patch. You
> should be able to avoid the boot loop if you disable the
> "phy-tusb1210" driver. The driver fails to probe anyway, so it's not
> very likely to be crucial for functioning, so it should allow you to
> try things with my patch reverted:

You lost me here. With "boot loop" you mean "probe loop" right? Why do 
you think the tusb1210 driver is not crucial?

See "phy: ti: tusb1210: Don't check for write errors when powering on"

It should not be failing to probe (and with Andy's "Break-infinite-loop" 
patch is doesn't) as without the tusb1210 usb host mode won't work as 
device plugs are not detected.

Earlier in this thread we had:

"The effect of the patch is that on Merrifield (I tested with Intel 
Edison Arduino board which has a HW switch to select between host and 
device mode) device mode works but in host mode USB is completely not 
working.

Currently on host mode - when working - superfluous error messages from 
tusb1210 appear. When host mode is not working there are no tusb1210 
messages in the logs / on the console at all. Seemingly tusb1210 is not 
probed, which points in the direction of a relation to extcon."

> git revert 8bd6b8c4b100 0f0101719138
>
> After that, if things start working, it'd make sense to re-do your
> function re-arranging experiment to re-validate it.
>
>> As I understand it depends a bit on the timing, I might have a different
>> initrd (built by Yocto vs. Buildroot). F.i. I see I have
>> extcon-intel-mrfld in initrd and dwc3 / phy-tusb1210 built-in.
>>
> You mentioned that your rootfs image does some gadget configuration
> for you. Can this be disabled? If yes, it'd make sense to check if
> this could be a variable explaining the difference.
This is done through configfs only when the switch is set to device mode.
> What U-Boot version are you running? AFACT U-Boot will touch that
> particular IP block, so this might be somewhat relevant.
IIRC if have v2022.04 but tested v2021.10 earlier (no difference).
