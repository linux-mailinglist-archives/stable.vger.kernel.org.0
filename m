Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34C8B65D0BD
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 11:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbjADKfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 05:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238869AbjADKfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 05:35:11 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A0D1EEC2;
        Wed,  4 Jan 2023 02:35:10 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pD16y-0006GG-7N; Wed, 04 Jan 2023 11:35:08 +0100
Message-ID: <60aa306c-2047-59ab-24ba-a6fba6667a3d@leemhuis.info>
Date:   Wed, 4 Jan 2023 11:35:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Request for cherry-picks for sound (Re: [regression, 5.10.y] Bug
 216861)
Content-Language: en-US, de-DE
To:     Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        =?UTF-8?B?UMOBTEZGWSBEw6FuaWVs?= <dpalffy@gmail.com>,
        Alsa-devel <alsa-devel@alsa-project.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Mark Brown <broonie@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Sergey <zagagyka@basealt.ru>,
        Salvatore Bonaccorso <carnil@debian.org>
References: <bebd692d-7d21-6648-6b7a-c91063bb51c2@leemhuis.info>
 <Y7K1WDmPYi3EMOn1@eldamar.lan> <87wn65umye.wl-tiwai@suse.de>
 <CALp6mkJhM1zDcNr9X_7WL09+uqcaAhNFFMhrjme0r7584O+Lgw@mail.gmail.com>
 <CALp6mk+rdqGXySUowxZv3kEEVWrh96m_x-h8xcFNQ9YZPkbc5w@mail.gmail.com>
 <87h6x7r7w6.wl-tiwai@suse.de> <87sfgrpos6.wl-tiwai@suse.de>
 <87wn62obhm.wl-tiwai@suse.de>
From:   "Linux kernel regression tracking (#info)" 
        <regressions@leemhuis.info>
Reply-To: Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <87wn62obhm.wl-tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1672828510;96571186;
X-HE-SMSGID: 1pD16y-0006GG-7N
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[TLDR: This mail in primarily relevant for Linux kernel regression
tracking. See link in footer if these mails annoy you.]

On 04.01.23 11:11, Takashi Iwai wrote:
> Greg, just in case you missed my previous post.

Side note: thx for handling this, Takashi!

> Could you cherry-pick the following two commits to 5.10.y and 5.15.y
> stable trees?
> 
> e8444560b4d9302a511f0996f4cfdf85b628f4ca
>     ASoC/SoundWire: dai: expand 'stream' concept beyond SoundWire
>  
> 636110411ca726f19ef8e87b0be51bb9a4cdef06
>     ASoC: Intel/SOF: use set_stream() instead of set_tdm_slots() for HDAudio

#regzbot fix: ASoC/SoundWire: dai: expand 'stream' concept beyond SoundWire

/me just picked one of them as the fix for the tracked regression, even
if both are needed, as that's likely close enough, unless something
really unexpected happens

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

> On Tue, 03 Jan 2023 17:26:49 +0100,
> Takashi Iwai wrote:
>>
>> On Tue, 03 Jan 2023 15:48:41 +0100,
>> Takashi Iwai wrote:
>>>
>>> On Tue, 03 Jan 2023 14:04:50 +0100,
>>> PÁLFFY Dániel wrote:
>>>>
>>>> And confirming, 5.10.161 with e8444560b4d9302a511f0996f4cfdf85b628f4ca
>>>> and 636110411ca726f19ef8e87b0be51bb9a4cdef06 cherry-picked works for
>>>> me.
>>>
>>> That's a good news.  Then we can ask stable people to pick up those
>>> commits for 5.10.y and 5.15.y.
>>
>> I confirmed that the latest 5.15.y requires those fixes, too.
>>
>> Greg, could you cherry-pick the following two commits to both 5.10.y
>> and 5.15.y stable trees?  This fixes the recent regression caused by
>> the backport of 39bd801d6908.
>>
>> e8444560b4d9302a511f0996f4cfdf85b628f4ca
>>     ASoC/SoundWire: dai: expand 'stream' concept beyond SoundWire
>>
>> 636110411ca726f19ef8e87b0be51bb9a4cdef06
>>     ASoC: Intel/SOF: use set_stream() instead of set_tdm_slots() for HDAudio
>>
>>
>> Thanks!
>>
>> Takashi
>>
>>>
>>>
>>> Takashi
>>>
>>>>
>>>> On Tue, Jan 3, 2023 at 1:05 PM PÁLFFY Dániel <dpalffy@gmail.com> wrote:
>>>>>
>>>>> Another report: https://bugs.archlinux.org/task/76795
>>>>> Apparently, folks at alsa-devel traced down the dependencies of that patch, see the mail thread at https://lore.kernel.org/all/dc65501c-c2fd-5608-c3d9-7cea184c3989%40opensource.cirrus.com/
>>>>>
>>>>> On Mon, Jan 2, 2023 at 1:42 PM Takashi Iwai <tiwai@suse.de> wrote:
>>>>>>
>>>>>> On Mon, 02 Jan 2023 11:43:36 +0100,
>>>>>> Salvatore Bonaccorso wrote:
>>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> [Adding as well Richard Fitzgerald and PÁLFFY Dániel to recipients]
>>>>>>>
>>>>>>> On Fri, Dec 30, 2022 at 09:08:57AM +0100, Thorsten Leemhuis wrote:
>>>>>>>> Hi, this is your Linux kernel regression tracker speaking.
>>>>>>>>
>>>>>>>> I noticed a regression report in bugzilla.kernel.org. As many (most?)
>>>>>>>> kernel developer don't keep an eye on it, I decided to forward it by
>>>>>>>> mail. Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=216861 :
>>>>>>>>
>>>>>>>>>  Sergey 2022-12-29 10:07:51 UTC
>>>>>>>>>
>>>>>>>>> Created attachment 303497 [details]
>>>>>>>>> pulseaudio.log
>>>>>>>>>
>>>>>>>>> Sudden sound disappearance was reported for some laptops, e.g.
>>>>>>>>>
>>>>>>>>> Acer Swift 3 SF314-59-78UR 11th Gen Intel(R) Core(TM) i7-1165G7 @ 2.80GHz
>>>>>>>>>
>>>>>>>>> # lspci
>>>>>>>>> 0000:00:1f.3 Multimedia audio controller: Intel Corporation Tiger Lake-LP Smart Sound Technology Audio Controller (rev 20)
>>>>>>>>>         Subsystem: Acer Incorporated [ALI] Device 148c
>>>>>>>>>         Flags: bus master, fast devsel, latency 32, IRQ 197, IOMMU group 12
>>>>>>>>>         Memory at 601f270000 (64-bit, non-prefetchable) [size=16K]
>>>>>>>>>         Memory at 601f000000 (64-bit, non-prefetchable) [size=1M]
>>>>>>>>>         Capabilities: [50] Power Management version 3
>>>>>>>>>         Capabilities: [80] Vendor Specific Information: Len=14 <?>
>>>>>>>>>         Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
>>>>>>>>>         Kernel driver in use: sof-audio-pci
>>>>>>>>>
>>>>>>>>> I am attaching the pulseaudio and dmesg logs
>>>>>>>>>
>>>>>>>>> This bug started reproducing after updating the kernel from 5.10.156 to 5.10.157
>>>>>>>>>
>>>>>>>>> Bisection revealed the commit being reverted:
>>>>>>>>>
>>>>>>>>> c34db0d6b88b1da95e7ab3353e674f4f574cccee is the first bad commit
>>>>>>>>> commit c34db0d6b88b1da95e7ab3353e674f4f574cccee
>>>>>>>>> Author: Richard Fitzgerald <rf@opensource.cirrus.com>
>>>>>>>>> Date:   Fri Nov 4 13:22:13 2022 +0000
>>>>>>>>>
>>>>>>>>>     ASoC: soc-pcm: Don't zero TDM masks in __soc_pcm_open()
>>>>>>>>>
>>>>>>>>>     [ Upstream commit 39bd801d6908900e9ab0cdc2655150f95ddd4f1a ]
>>>>>>>>>
>>>>>>>>>     The DAI tx_mask and rx_mask are set by snd_soc_dai_set_tdm_slot()
>>>>>>>>>     and used by later code that depends on the TDM settings. So
>>>>>>>>>     __soc_pcm_open() should not be obliterating those mask values.
>>>>>>>>>
>>>>>>>>> [...]
>>>>>>>>> Original bug report: https://bugzilla.altlinux.org/44690
>>>>>>>>
>>>>>>>> See the ticket for more details.
>>>>>>>>
>>>>>>>> BTW, let me use this mail to also add the report to the list of tracked
>>>>>>>> regressions to ensure it's doesn't fall through the cracks:
>>>>>>>>
>>>>>>>> #regzbot introduced: c34db0d6b88b1d
>>>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=216861
>>>>>>>> #regzbot title: sound: asoc: sudden sound disappearance
>>>>>>>> #regzbot ignore-activity
>>>>>>>
>>>>>>> FWIW, we had as well reports in Debian after having updated the kernel
>>>>>>> from 5.10.149 based one to 5.10.158 based one in the last point
>>>>>>> releases, they are at least:
>>>>>>>
>>>>>>> https://bugs.debian.org/1027483
>>>>>>> https://bugs.debian.org/1027430
>>>>>>
>>>>>> I got another report while the commit was backported to 5.14-based
>>>>>> openSUSE Leap kernel, and I ended up with dropping it.
>>>>>>
>>>>>> So, IMO, it's safer to drop this patch from the older stable trees.
>>>>>> As far as I see, 5.15.y and 5.10.y got this.
>>>>>>
>>>>>> Unless anyone gives a better fix, I'm going to submit a revert patch
>>>>>> for those trees.
>>>>>>
>>>>>>
>>>>>> thanks,
>>>>>>
>>>>>> Takashi
>>>>
>>>
> 
> 

-- 
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.
