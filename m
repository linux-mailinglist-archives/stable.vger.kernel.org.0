Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9915FA694
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 22:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiJJUwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 16:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiJJUwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 16:52:40 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB0C6C74D;
        Mon, 10 Oct 2022 13:52:38 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id m15so17431011edb.13;
        Mon, 10 Oct 2022 13:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VkKW7QNRO+vFDZbYVYUX8l57zW0wwZBdLL4qsXCoSqY=;
        b=a22vdRFdHgHRuFkE9xGv1vZyWAnksE+S0sWn81t/MtlRSrHoYD7M85ifk1/rc2hgFU
         5BcN9NNI4Gh5oCU9QNmbwllfgva+s6duIq8xDk2MY2gFvdDZz2KE+uuS5v/NAtxQn8Yn
         ReQrS7I1ARczlwX0hx1NQC+QNP8hqdGuNq3YF7Brehs9sVkuMYYWfLFu6kaVLWLPLtQE
         LfcZ53nlWDq9Uvr7hMBKil9/r/9VyLOxv8/zYsHPXOlUQVNLXfNXXcF3yD00LRF5h5X6
         2c6Mkd++xmM3y+3Db70zl3YzCJKRZ9twy47zhgavUIu+l5MYz4jmwmMfyV0myZJDX1bY
         Jmxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VkKW7QNRO+vFDZbYVYUX8l57zW0wwZBdLL4qsXCoSqY=;
        b=WBjMu7n8EZfjfIABAwbADLalqvXuFOVjv0DQofhc0hrTLW8vkOdWEgYdd3vGy1+rjM
         +OGLk/+UIlgxaKPPne5E2gyRkkGA1RqCllzaELc0I0saBEQFfdmmLRd/m8UJA1Ag5qOO
         vCjRxVQUpuwCAl9EuR2Z4Lf4Su8IIPdseSs8874KoDQUfgDD64fOczya7E5bBGYfeAG2
         OR1m83YOAWqYr56iZqFitkZ5EAPr9QqO3qZHdix3W/ShDpmcXi04tcJ6gO96gIPpFiTE
         Y6HdMro4ZcuSiqAM1Dnb1mHD6/3CXhQL1RVqtgm3Ew2Z1ko5dUESMR5g1P4Q6rm7ZyiO
         ov8Q==
X-Gm-Message-State: ACrzQf1nwC0g5pY5tBfN9+Pn2zpGYTKfjFq0gRuZTZeI8gdGzhHQncxw
        hmPgQBWHNcp6imXiDfYMMuStiHtu6ag=
X-Google-Smtp-Source: AMsMyM5mM0nSFY/Pqr/OOyMtrL7VcMWDBfdtFW0aRFhhKmGqUA4XDX6u6B+w+pOofQR1RPIOCUq/nw==
X-Received: by 2002:a05:6402:2804:b0:439:83c2:8be2 with SMTP id h4-20020a056402280400b0043983c28be2mr20081184ede.292.1665435157144;
        Mon, 10 Oct 2022 13:52:37 -0700 (PDT)
Received: from ?IPV6:2a02:a466:68ed:1:e350:d49a:19c5:6601? (2a02-a466-68ed-1-e350-d49a-19c5-6601.fixed6.kpn.net. [2a02:a466:68ed:1:e350:d49a:19c5:6601])
        by smtp.gmail.com with ESMTPSA id hg20-20020a1709072cd400b0073dd8e5a39fsm5717124ejc.156.2022.10.10.13.52.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 13:52:36 -0700 (PDT)
Message-ID: <7e9519c6-f65f-5f83-1d17-a3510103469f@gmail.com>
Date:   Mon, 10 Oct 2022 22:52:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
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
Content-Language: en-US
In-Reply-To: <4e73bbb9-eae1-6a90-d716-c721a1eeced3@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

Op 10-10-2022 om 13:04 schreef Ferry Toth:
> Hi
>
> On 10-10-2022 07:02, Andrey Smirnov wrote:
>> On Fri, Oct 7, 2022 at 6:07 AM Ferry Toth <fntoth@gmail.com> wrote:
>>>
>>> On 07-10-2022 04:11, Thinh Nguyen wrote:
>>>> On Thu, Oct 06, 2022, Ferry Toth wrote:
>>>>> Hi
>>>>>
>>>>> On 06-10-2022 04:12, Thinh Nguyen wrote:
>>>>>> On Wed, Oct 05, 2022, Ferry Toth wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>>        Thanks!
>>>>>>>
>>>>>>>        Does the failure only happen the first time host is 
>>>>>>> initialized? Or can
>>>>>>>        it recover after switching to device then back to host mode?
>>>>>>>
>>>>>>> I can switch back and forth and device mode works each time, 
>>>>>>> host mode remains
>>>>>>> dead.
>>>>>> Ok.
>>>>>>
>>>>>>>        Probably the failure happens if some step(s) in 
>>>>>>> dwc3_core_init() hasn't
>>>>>>>        completed.
>>>>>>>
>>>>>>>        tusb1210 is a phy driver right? The issue is probably 
>>>>>>> because we didn't
>>>>>>>        initialize the phy yet. So, I suspect placing 
>>>>>>> dwc3_get_extcon() after
>>>>>>>        initializing the phy will probably solve the dependency 
>>>>>>> problem.
>>>>>>>
>>>>>>>        You can try something for yourself or I can provide 
>>>>>>> something to test
>>>>>>>        later if you don't mind (maybe next week if it's ok).
>>>>>>>
>>>>>>> Yes, the code move I mentioned above "moves dwc3_get_extcon() 
>>>>>>> until after
>>>>>>> dwc3_core_init() but just before dwc3_core_init_mode(). AFAIU 
>>>>>>> initially
>>>>>>> dwc3_get_extcon() was called from within dwc3_core_init_mode() 
>>>>>>> but only for
>>>>>>> case USB_DR_MODE_OTG. So with this change order of events is 
>>>>>>> more or less
>>>>>>> unchanged" solves the issue.
>>>>>>>
>>>>>> I saw the experiment you did from the link you provided. We want 
>>>>>> to also
>>>>>> confirm exactly which step in dwc3_core_init() was needed.
>>>>> Ok. I first tried the code move suggested by Andrey (didn't work). 
>>>>> Then
>>>>> after reading the actual code I moved a bit further.
>>>>>
>>>>> This move was on top of -rc6 without any reverts. I did not make 
>>>>> additional
>>>>> changes to dwc3_core_init()
>>>>>
>>>>> So current v6.0 has: dwc3_get_extcon - dwc3_get_dr_mode - ... -
>>>>> dwc3_core_init - .. - dwc3_core_init_mode (not working)
>>>>>
>>>>> I changed to: dwc3_get_dr_mode - dwc3_get_extcon - .. - 
>>>>> dwc3_core_init - ..
>>>>> - dwc3_core_init_mode (no change)
>>>>>
>>>>> Then to: dwc3_get_dr_mode - .. - dwc3_core_init - .. - 
>>>>> dwc3_get_extcon -
>>>>> dwc3_core_init_mode (works)
>>>>>
>>>>> .. are what I believe for this issue irrelevant calls to
>>>>> dwc3_alloc_scratch_buffers, dwc3_check_params and dwc3_debugfs_init.
>>>>>
>>>> Right. Thanks for narrowing it down. There are still many steps in
>>>> dwc3_core_init(). We have some suspicion, but we still haven't 
>>>> confirmed
>>>> the exact cause of the failure. We can write a proper patch once we 
>>>> know
>>>> the reason.
>>> If you would like me to test your suspicion, just tell me what to do 
>>> :-)
>>
>> OK, Ferry, I think I'm going to need clarification on specifics on
>> your test setup. Can you share your kernel config, maybe your
>> "/proc/config.gz", somewhere? When you say you are running vanilla
>> Linux, do you mean it or do you mean vanilla tree + some patch delta?
>
> For v6.0 I can get the exacts tonight. But earlier I had this for v5.17:
>
> https://github.com/htot/meta-intel-edison/blob/master/meta-intel-edison-bsp/recipes-kernel/linux/linux-yocto_5.17.bb 
>
>
> There are 2 patches referred in #67 and #68. One is related to the 
> infinite loop. The other is I believe also needed to get dwc3 to work.
>
> All the kernel config are applied as .cfg.
>
> Patches and cfs's here:
>
> https://github.com/htot/meta-intel-edison/tree/master/meta-intel-edison-bsp/recipes-kernel/linux/files 
>

Updated Yocto recipe for v6.0 here:

https://github.com/htot/meta-intel-edison/blob/honister/meta-intel-edison-bsp/recipes-kernel/linux/linux-yocto_6.0.bb

#75-#77 are the 2 reverts from Andy, + one SOF revert (not related to 
this thread).

Otherwise via the git route, https://github.com/andy-shev/linux should 
lead to the same, although you might want to drop "WIP: serial: 
8250_dma: use sgl on transmit "

>
>> The reason I'm asking is because I'm having a hard time reproducing
>> the problem on my end. In fact, when I build v6.0
>> (4fe89d07dcc2804c8b562f6c7896a45643d34b2f) and then do a
>>
>> git revert 8bd6b8c4b100 0f0101719138 (original revert proposed by Andy)
>>
>> I get an infinite loop of reprobing that looks something like (some
>> debug tracing, function name + line number, included):
>>
>> [    6.160732] tusb1210 dwc3.0.auto.ulpi: error -110 writing val 0x41
>> to reg 0x80
>> [    6.172299] XXXXXXXXXXX: dwc3_probe 1834
>> [    6.172426] XXXXXXXXXXX: dwc3_core_init_mode 1386
>> [    6.176391] XXXXXXXXXXX: dwc3_drd_init 593
>> [    6.181573] dwc3 dwc3.0.auto: Driver dwc3 requests probe deferral
>> [    6.191886] platform dwc3.0.auto: Added to deferred list
>> [    6.197249] platform dwc3.0.auto: Retrying from deferred list
>> [    6.203057] bus: 'platform': __driver_probe_device: matched device
>> dwc3.0.auto with driver dwc3
>> [    6.211783] bus: 'platform': really_probe: probing driver dwc3 with
>> device dwc3.0.auto
>> [    6.219935] XXXXXXXXXXX: dwc3_probe 1822
>> [    6.219952] XXXXXXXXXXX: dwc3_core_init 1092
>> [    6.223903] XXXXXXXXXXX: dwc3_core_init 1095
>> [    6.234839] bus: 'ulpi': __driver_probe_device: matched device
>> dwc3.0.auto.ulpi with driver tusb1210
>> [    6.248335] bus: 'ulpi': really_probe: probing driver tusb1210 with
>> device dwc3.0.auto.ulpi
>> [    6.257039] driver: 'tusb1210': driver_bound: bound to device
>> 'dwc3.0.auto.ulpi'
>> [    6.264501] bus: 'ulpi': really_probe: bound device
>> dwc3.0.auto.ulpi to driver tusb1210
>> [    6.272553] debugfs: Directory 'dwc3.0.auto' with parent 'ulpi'
>> already present!
>> [    6.279978] XXXXXXXXXXX: dwc3_core_init 1099
>> [    6.279991] XXXXXXXXXXX: dwc3_core_init 1103
>> [    6.345769] tusb1210 dwc3.0.auto.ulpi: error -110 writing val 0x41
>> to reg 0x80
>> [    6.357316] XXXXXXXXXXX: dwc3_probe 1834
>> [    6.357447] XXXXXXXXXXX: dwc3_core_init_mode 1386
>> [    6.361402] XXXXXXXXXXX: dwc3_drd_init 593
>> [    6.366589] dwc3 dwc3.0.auto: Driver dwc3 requests probe deferral
>> [    6.376901] platform dwc3.0.auto: Added to deferred list
>>
>> which renders the system completely unusable, but USB host is
>> definitely going to be broken too. Now, ironically, with my patch
>> in-place, an attempt to probe extcon that ends up deferring the probe
>> happens before the ULPI driver failure (which wasn't failing driver
>> probe prior to 
>> https://lore.kernel.org/all/20220213130524.18748-7-hdegoede@redhat.com/),
>> there no "driver binding" event that re-triggers deferred probe
>> causing the loop, so the system progresses to a point where extcon is
>> available and dwc3 driver eventually loads.
>>
>> After that, and I don't know if I'm doing the same test, USB host
>> seems to work as expected. lsusb works, my USB stick enumerates as
>> expected. Switching the USB mux to micro-USB and back shuts the host
>> functionality down and brings it up as expected. Now I didn't try to
>> load any gadgets to make sure USB gadget works 100%, but since you
>> were saying it was USB host that was broken, I wasn't concerned with
>> that. Am I doing the right test?
>>
>> For the reference what I test with is:
>>   - vanilla kernel, no patch delta (sans minor debug tracing) + initrd
>> built with Buildroot 2022.08.1
>>   - Initrd is using systemd (don't think that really matters, but who 
>> knows)
>>   - U-Boot 2022.04 (built with Buildroot as well)
>>   - kernel config is x86_64_defconfig + whatever I gathered from *.cfg
>> files in 
>> https://github.com/edison-fw/meta-intel-edison/tree/master/meta-intel-edison-bsp/recipes-kernel/linux/files
