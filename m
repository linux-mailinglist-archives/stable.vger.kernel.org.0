Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02234D3647
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbiCIRUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 12:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236444AbiCIRTZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 12:19:25 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0211A70CF6
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 09:18:03 -0800 (PST)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nRzwn-0004TJ-JR; Wed, 09 Mar 2022 18:18:01 +0100
Message-ID: <08548343-0bed-64e7-2aff-f403341c80dd@leemhuis.info>
Date:   Wed, 9 Mar 2022 18:18:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: laptop does not go to suspend anymore with kernel version >
 5.16.10
To:     reinhold.mannsberger@gmx.at, stable@vger.kernel.org
Cc:     regressions@lists.linux.dev
References: <4a83b8d3dc68a2bf6c7e988552a213f161b54c3a.camel@gmx.at>
 <776197b3-cc56-3948-d6e9-68bed82d9730@leemhuis.info>
 <4249d21e2638af07f43121982cf9dcb73b116ad9.camel@gmx.at>
Content-Language: en-US
In-Reply-To: <4249d21e2638af07f43121982cf9dcb73b116ad9.camel@gmx.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1646846285;128f9e7d;
X-HE-SMSGID: 1nRzwn-0004TJ-JR
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09.03.22 17:46, Reinhold Mannsberger wrote:
> Dear Thorsten!
> 
> Thank you for your quick response!
> 
> Now that you gave me the advice to check dmesg I found out that the
> messages are the same with kernel version 5.16.10 and 5.16.12. But - as
> I described - with kernel version 5.16.10 I had to press the power
> button to resume from suspend. So I my conclusion that my laptop does
> not go to suspend ist apparently wrong.

Good. :-D

> In any case you find excerpts
> from dmesg with both kernel versions attached.
> 
> Now there is one thing I really would like to understand. Concluding
> from the time stamps in dmesg it seems that my laptop goes to suspend
> only for a moment right before I re-open the lid. Of course I did not
> close my laptop lid only for 3 seconds - as it could be concluded from
> the time stamps for "PM: suspend entry (s2idle)" and "PM: suspend exit"
> - but for a longer period of time. Can you please enlighten me about that?

I have no idea, I'm just tracking regressions and sadly don't known much
about this. To me it looks a bit like s2idle is not working properly,
but I might be totally wrong with that. Maybe google might tell you; or
some measurements where you check how quickly the batter drains in
sleep. Oof you ask the PM developers -- but as this is not a regression
neither the regressions list nor the stable list care, so I guess you do
it in a separate mail.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I'm getting a lot of
reports on my table. I can only look briefly into most of them and lack
knowledge about most of the areas they concern. I thus unfortunately
will sometimes get things wrong or miss something important. I hope
that's not the case here; if you think it is, don't hesitate to tell me
in a public reply, it's in everyone's interest to set the public record
straight.



> Am Mittwoch, dem 09.03.2022 um 07:51 +0100 schrieb Thorsten Leemhuis:
>> Hi!
>>
>> On 08.03.22 19:21, Reinhold Mannsberger wrote:
>>>
>>> I am using Linux Mint Xfce 20.3 with kernel version 5.16. I had to use
>>> kernel 5.16 because with the standard kernel version of Linux mit 20.3
>>> (which is 5.13) my laptop did not correctly resume, when I closed the
>>> lid.
>>>
>>> With kernel 5.16 my laptop perfectly went to to suspend when I closed
>>> the lid and it perfectly resumed, when I opened the lid again. This
>>> means: I had to press the power button once
>>
>> That sounds odd to me, as most modern Laptops wake up automatically when
>> you open the lid. It's unlikely, but maybe that just that started to
>> work now?
>>
>>> when I reopened the lid -
>>> and then the laptop resumed (to the login screen). This was true until
>>> kernel version 5.16.10. With kernel version > 5.16.10 my laptop does
>>> not go into suspend anymore. This means: When I open the lid I am back
>>> at the login screen immediately (I don't have to press the power button
>>> anymore).
>>
>> You want to check dmesg if the system really didn't go to sleep; it will
>> likely also provide a hint of what went wrong. Just upload the output
>> (generated after a fresh start and where you suspend and resume once the
>> system booted) somewhere and send us a link or sent it as an attachment
>> in a reply. If that doesn't provide any hints of what might be wrong,
>> you might need to find the change that introduced the problem using a
>> bisection.
>>
>> HTH, Ciao, Thorsten
>>
>>> System information for my laptop:
>>> ----------------------------------------------------------------------
>>> System:    Kernel: 5.16.10-051610-generic x86_64 bits: 64 compiler: N/A
>>> Desktop: Xfce 4.16.0
>>>            tk: Gtk 3.24.20 wm: xfwm4 dm: LightDM Distro: Linux Mint
>>> 20.3 Una
>>>            base: Ubuntu 20.04 focal
>>> Machine:   Type: Laptop System: HP product: HP ProBook 455 G8 Notebook
>>> PC v: N/A serial: <filter>
>>>            Chassis: type: 10 serial: <filter>
>>>            Mobo: HP model: 8864 v: KBC Version 41.1E.00 serial:
>>> <filter> UEFI: HP
>>>            v: T78 Ver. 01.07.00 date: 10/08/2021
>>> Battery:   ID-1: BAT0 charge: 43.8 Wh condition: 44.5/45.0 Wh (99%)
>>> volts: 13.0/11.4
>>>            model: Hewlett-Packard Primary serial: <filter> status:
>>> Unknown
>>> CPU:       Topology: 8-Core model: AMD Ryzen 7 5800U with Radeon
>>> Graphics bits: 64 type: MT MCP
>>>            arch: Zen 3 L2 cache: 4096 KiB
>>>            flags: avx avx2 lm nx pae sse sse2 sse3 sse4_1 sse4_2 sse4a
>>> ssse3 svm bogomips: 60685
>>>            Speed: 3497 MHz min/max: 1600/1900 MHz Core speeds (MHz): 1:
>>> 3474 2: 3464 3: 3473
>>>            4: 3471 5: 4362 6: 4332 7: 3478 8: 3455 9: 3459 10: 3452 11:
>>> 3462 12: 3468 13: 3468
>>>            14: 3468 15: 3467 16: 3472
>>> Graphics:  Device-1: AMD vendor: Hewlett-Packard driver: amdgpu v:
>>> kernel bus ID: 05:00.0
>>>            chip ID: 1002:1638
>>>            Display: x11 server: X.Org 1.20.13 driver: amdgpu,ati
>>> unloaded: fbdev,modesetting,vesa
>>>            resolution: 1920x1080~60Hz
>>>            OpenGL: renderer: AMD RENOIR (DRM 3.44.0 5.16.10-051610-
>>> generic LLVM 12.0.0)
>>>            v: 4.6 Mesa 21.2.6 direct render: Yes
>>> ----------------------------------------------------------------------
>>>
>>>
>>> Best regards,
>>>
>>> Reinhold Mannsberger
>>>
>>>
>>>
