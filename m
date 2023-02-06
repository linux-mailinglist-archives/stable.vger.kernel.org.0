Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139F768B7EE
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 10:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjBFJD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 04:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBFJD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 04:03:57 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327F2EC76
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 01:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675674236; x=1707210236;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0id6BaRRlaN0BFZsKs2pgqazihDfzWWNp34nMDXl9AU=;
  b=IseQFr74MA1pSSd38pjlPDV+nJh8X/mmo/hgiXzlII4+fc6OqIagOpN5
   b7gwR52DTeuIzrmu+d+JECClEGuFcoQjdjmbOBOA2yS+ZRnguj3emIorL
   dzSBNb/icOme8P2lJbwq3+AU9Bx9iM4MEB56OT8KnnLHK2OUcqGTRawr3
   n2FWXpWm7sQECTokidHQn8fCC4HqOGBg2spnSbVQRgdkP9nz1vgEunlJS
   8dAVZBv26f3QgEUZDCBq8St3ZTf3EMQu/7gKHaALxqzYHtLwAjfSzwLOa
   0UpfMNdZEuJ50cQ9lgcCT7+Hi8zJgchQAsSMLWHyPxc/h9G1qkEE7fd+y
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="393760160"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="393760160"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 01:03:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="809054411"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="809054411"
Received: from aslawinx-mobl.ger.corp.intel.com (HELO [10.99.16.144]) ([10.99.16.144])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 01:03:53 -0800
Message-ID: <a423c627-d303-3b50-5f11-78c06ed3b985@linux.intel.com>
Date:   Mon, 6 Feb 2023 10:03:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
Content-Language: en-US
To:     Jason Montleon <jmontleo@redhat.com>
Cc:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Sasa Ostrouska <casaxa@gmail.com>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Greg KH <gregkh@linuxfoundation.org>, lma@semihalf.com,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
References: <CAJD_bPJ1VYTSQvogui4S9xWn9jQzQq8JRXOzXmus+qoRyrybOA@mail.gmail.com>
 <Y9Vg26wjGfkCicYv@kroah.com>
 <CAJD_bPLkkgbk+GO66Ec9RmiW6MfYrG32WP75oLzXsz2+rpREWg@mail.gmail.com>
 <CAJD_bPK=m0mX8_Qq=6iwD8sL8AkR99PEzBbE3RcSaJmxuJmW6g@mail.gmail.com>
 <02834fa9-4fb0-08fb-4b5f-e9646c1501d6@leemhuis.info>
 <288d7ff4-75aa-7ad1-c49c-579373cab3ed@intel.com>
 <CALFERdw=GwNYafR3q=5=k=H_jrzTZMyDBQLouFGV0JGu8i9sCg@mail.gmail.com>
 <04a9f939-8a98-9a46-e165-8e9fb8801a83@intel.com>
 <CAJD_bP+Te5a=OfjN9YrjGOG2PzudQ87=5FEKj6YLFxfKyFe5bw@mail.gmail.com>
 <6262bd72-cc2b-9d2a-e8f0-55c2b2bb7861@linux.intel.com>
 <CAJD_bPKxbsDi10FGX2mrMeuxcphDOvO8Q87j+AvnnQpe5cvmSA@mail.gmail.com>
 <CAJD_bP+RUemsss_YiAZ5v08ak8aTzXCB0gk7q623zyF455bh7g@mail.gmail.com>
From:   =?UTF-8?Q?Amadeusz_S=c5=82awi=c5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>
In-Reply-To: <CAJD_bP+RUemsss_YiAZ5v08ak8aTzXCB0gk7q623zyF455bh7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/4/2023 4:16 PM, Jason Montleon wrote:
> I have built kernels for 6.0.19 (I don't think anyone confirmed
> whether or not it worked), plus every 6.1 tag from 6.1-rc1 up to
> 6.1.7. 6.0.19 worked. No 6.1 kernels worked. For rc1 to rc5 I built
> with and without the legacy dai renaming patch added in rc6 that I
> believe would be necessary, but it made no difference either way.

Hi,

thank you for trying to narrow it down, if I understand correctly -rc1 
doesn't work, which means that problem was introduced somewhere between 
6.0 and 6.1-rc1 (just for the sake of being sure, can you test 6.0 
instead of 6.0.19?) There is one commit which I'm bit suspicious about: 
ef6f5494faf6a37c74990689a3bb3cee76d2544c it changes how HDMI are 
assigned and as a machine board present on EVE makes use of HDMI, it may 
potentially cause some problems. Can you try reverting it?
(If reverting on top of v6.1.8 you need to revert both 
f9aafff5448b1d8d457052271cd9a11b24e4d0bd and 
ef6f5494faf6a37c74990689a3bb3cee76d2544c which has minor conflict, 
easily resolved with just adding both lines.

I also still wonder, why problem reproduces only on some 
distributions... any chance you can try and boot with 
pipewire/pulseaudio disabled and see if it still happens, iirc those 
tools try to check all FEs and this may be breaking something during 
enumeration.

Thanks,
Amadeusz

> 
> On Wed, Feb 1, 2023 at 9:33 AM Jason Montleon <jmontleo@redhat.com> wrote:
>>
>> On Wed, Feb 1, 2023 at 6:05 AM Amadeusz Sławiński
>> <amadeuszx.slawinski@linux.intel.com> wrote:
>>>
>>> On 1/31/2023 4:16 PM, Jason Montleon wrote:
>>>> On Tue, Jan 31, 2023 at 7:37 AM Cezary Rojewski
>>>> <cezary.rojewski@intel.com> wrote:
>>>>>
>>>>> On 2023-01-30 1:22 PM, Sasa Ostrouska wrote:
>>>>>
>>>>>> Dear Czarek, many thanks for the answer and taking care of it. If
>>>>>> needed something from my side please jest let me know
>>>>>> and I will try to do it.
>>>>>
>>>>>
>>>>> Hello Sasa,
>>>>>
>>>>> Could you provide us with the topology and firmware binary present on
>>>>> your machine?
>>>>>
>>>>> Audio topology is located at /lib/firmware and named:
>>>>>
>>>>> 9d71-GOOGLE-EVEMAX-0-tplg.bin
>>>>> -or-
>>>>> dfw_sst.bin
>>>>>
>>>>> Firmware on the other hand is found in /lib/firmware/intel/.
>>>>> 'dsp_fw_kbl.bin' will lie there, it shall be a symlink pointing to an
>>>>> actual AudioDSP firmware binary.
>>>>>
>>>> Maybe this is the problem.
>>>>
>>>> I think most of us are pulling the topology and firmware from the
>>>> chromeos recovery images for lack of any other known source, and it
>>>> looks a little different than this. Those can be downloaded like so:
>>>> https://gist.github.com/jmontleon/8899cb83138f2653f520fbbcc5b830a0
>>>>
>>>> After placing the topology file you'll see these errors and audio will
>>>> not work until they're also copied in place.
>>>> snd_soc_skl 0000:00:1f.3: Direct firmware load for
>>>> dsp_lib_dsm_core_spt_release.bin failed with error -2
>>>> snd_soc_skl 0000:00:1f.3: Direct firmware load for
>>>> intel/dsp_fw_C75061F3-F2B2-4DCC-8F9F-82ABB4131E66.bin failed with
>>>> error -2
>>>>
>>>> Once those were in place, up to 6.0.18 audio worked.
>>>>
>>>> Is there a better source for the topology file?
>>>>
>>>>> The reasoning for these asks is fact that problem stopped reproducing on
>>>>> our end once we started playing with kernel versions (moved away from
>>>>> status quo with Fedora). Neither on Lukasz EVE nor on my SKL RVP.
>>>>> However, we might be using newer configuration files when compared to
>>>>> equivalent of yours.
>>>>>
>>>>> Recent v6.2-rc5 broonie/sound/for-next - no repro
>>>>> Our internal tree based on Mark's for-next - no repro
>>>>> 6.1.7 stable [1] - no repro
>>>>>
>>>>> Of course we will continue with our attempts. Will notify about the
>>>>> progress.
>>>>>
>>>>>
>>>>> [1]:
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v6.1.7&id=21e996306a6afaae88295858de0ffb8955173a15
>>>>>
>>>>>
>>>>> Kind regards,
>>>>> Czarek
>>>>>
>>>>
>>>>
>>>
>>> Hi Jason,
>>>
>>> as I understand you've tried to do bisect, can you instead try building
>>> kernels checking out following tags:
>>> v6.1      v6.1.1    v6.1.2    v6.1.3    v6.1.4    v6.1.5    v6.1.6
>>> v6.1.7    v6.1.8
>>> and report when it stops working, so it narrows scope of what we look
>>> at? I assume that kernel builds are done using upstream stable kernel
>>> (from https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/).
>>>
>>> Thanks,
>>> Amadeusz
>>>
>> Hi Amadeusz,
>> Yes, I did the bisects using
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/
>>
>> The only thing I did to these was add
>> 392cc13c5ec72ccd6bbfb1bc2339502cc59dd285, otherwise audio breaks with
>> the dai not registered error message in dmesg from the rt5514 bug from
>> 6.0 and up. It wasn't added to 6.1 until rc6, I believe. If there's a
>> better way to work around the multiple bugs I can try again, otherwise
>> I will start working on builds from tags and see if I learn anything.
>>
>> FWIW, I've seen two people complain that Arch isn't working either
>> since it moved to 6.1. For the one who was trying, patching out the
>> commit I came to with the first bisect did not regain them sound like
>> it did for me. And yet Sasa reports Slackware is mostly working for
>> him with 6.1.8 on Slackware. I don't know what to make of it, but
>> thought I'd share in case it helps point someone else to something.
>> https://github.com/jmontleon/pixelbook-fedora/issues/51#issuecomment-1410222840
>> https://github.com/jmontleon/pixelbook-fedora/issues/51#issuecomment-1410673371
>> https://github.com/jmontleon/pixelbook-fedora/issues/53#issuecomment-1408699252
>>
>> Probably less relevant since they aren't from upstream and I know they
>> don't mean as much, but I have tried 6.1.5-6.1.8 Fedora packages for
>> certain, and went back trying several others from koji back into rc
>> builds, although using prebuilt kernels, anything before 6.1-rc6 won't
>> work, as mentioned above. Nothing worked. But as I said I'll build
>> from tags and see if I can learn anything.
>>
>> Thank you,
>> Jason Montleon
>>
>> --
>> Jason Montleon        | email: jmontleo@redhat.com
>> Red Hat, Inc.         | gpg key: 0x069E3022
>> Cell: 508-496-0663    | irc: jmontleo / jmontleon
> 
> 
> 

