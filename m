Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033981C5C0E
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 17:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbgEEPn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 11:43:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730542AbgEEPn4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 11:43:56 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D30E7206B9;
        Tue,  5 May 2020 15:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588693435;
        bh=TxnOYoONYUB46J1H+7fQDHT62rFdwOCUNjdJs3RRW/M=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=cxnJWq7yXPZpmKMuJcZ/0dguQcZPjQmN4tT8R+lEMFn00JQwVe3veXHFxk1easiUR
         wtOHdz+YfQ8bASxL2HtLtTYhGSnYHYkfbvvp09cw7xF+dcVno8lOdvbtesrUOJI3D/
         czuRozy3ZPw0IUkhrMceT3nbnLdAsuBsutNf4mv4=
Subject: Re: [PATCH 5.6 00/73] 5.6.11-rc1 review
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        shuah <shuah@kernel.org>
References: <20200504165501.781878940@linuxfoundation.org>
 <3366716c-3a30-033d-4df6-4183eb262208@kernel.org>
 <82eb8f25-4e15-001a-1c4f-5f59400d352b@kernel.org>
 <s5h4ksubdh8.wl-tiwai@suse.de>
From:   shuah <shuah@kernel.org>
Message-ID: <e7326300-faad-df0e-1918-a36b5be4b078@kernel.org>
Date:   Tue, 5 May 2020 09:43:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <s5h4ksubdh8.wl-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/5/20 9:36 AM, Takashi Iwai wrote:
> On Tue, 05 May 2020 17:30:07 +0200,
> shuah wrote:
>>
>> On 5/5/20 9:25 AM, shuah wrote:
>>> On 5/4/20 11:57 AM, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 5.6.11 release.
>>>> There are 73 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Wed, 06 May 2020 16:52:55 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>>      https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.11-rc1.gz
>>>>
>>>> or in the git tree and branch at:
>>>>      git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>>>> linux-5.6.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>>
>>>> -------------
>>>> Pseudo-Shortlog of commits:
>>>>
>>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>       Linux 5.6.11-rc1
>>>>
>>>
>>>> Takashi Iwai <tiwai@suse.de>
>>>>       ALSA: pcm: oss: Place the plugin buffer overflow checks correctly
>>>>
>>>> Vasily Khoruzhick <anarsoul@gmail.com>
>>>>       ALSA: line6: Fix POD HD500 audio playback
>>>>
>>>> Wu Bo <wubo40@huawei.com>
>>>>       ALSA: hda/hdmi: fix without unlocked before return
>>>>
>>>> Takashi Iwai <tiwai@suse.de>
>>>>       ALSA: usb-audio: Correct a typo of NuPrime DAC-10 USB ID
>>>>
>>>> Hui Wang <hui.wang@canonical.com>
>>>>       ALSA: hda/realtek - Two front mics on a Lenovo ThinkCenter
>>>>
>>>
>>>>    sound/core/oss/pcm_plugin.c                       | 20 ++++---
>>>>    sound/isa/opti9xx/miro.c                          |  9 ++-
>>>>    sound/isa/opti9xx/opti92x-ad1848.c                |  9 ++-
>>>>    sound/pci/hda/patch_hdmi.c                        |  4 +-
>>>>    sound/pci/hda/patch_realtek.c                     |  1 +
>>>>    sound/usb/line6/podhd.c                           | 22 ++-----
>>>>    sound/usb/quirks.c                                |  2 +-
>>>>    78 files changed, 554 insertions(+), 297 deletions(-)
>>>>
>>>>
>>>>
>>>
>>> Compiled and booted on my test system. Tons of the of following
>>> errors in dmesg
>>>
>>> Adding Takashi Iwai
>>>
>>> [   33.980302] usb 2-2.4: 1:1: cannot set freq 48000 to ep 0x1
>>> [   49.340581] usb 2-2.4: 2:1: cannot set freq 48000 to ep 0x82
>>> [   59.580511] usb 2-2.4: 13:0: cannot get min/max values for
>>> control 2 (id 13)
>>> [   64.700532] usb 2-2.4: 9:0: cannot get min/max values for control
>>> 2 (id 9)
>>> [   69.792257] usb 2-2.4: 10:0: cannot get min/max values for
>>> control 2 (id 10)
>>> [   69.792736] usbcore: registered new interface driver snd-usb-audio
>>> [   74.871038] usb 2-2.4: 9:0: cannot get min/max values for control
>>> 2 (id 9)
>>> [   79.967099] usb 2-2.4: 9:0: cannot get min/max values for control
>>> 2 (id 9)
>>> [   85.076961] usb 2-2.4: 9:0: cannot get min/max values for control
>>> 2 (id 9)
>>> [   90.191415] usb 2-2.4: 9:0: cannot get min/max values for control
>>> 2 (id 9)
>>> [   95.308843] usb 2-2.4: 9:0: cannot get min/max values for control
>>> 2 (id 9)
>>>
>>> followed by
>>>
>>> [  131.172280] usb 2-2.4: 1:1: usb_set_interface failed (-110)
>>> [  136.259909] usb 2-2.4: 1:1: usb_set_interface failed (-110)
>>> [  141.380345] usb 2-2.4: 1:1: usb_set_interface failed (-110)
>>> [  146.500227] usb 2-2.4: 1:1: usb_set_interface failed (-110)
>>> [  151.620227] usb 2-2.4: 1:1: usb_set_interface failed (-110)
>>> [  156.739899] usb 2-2.4: 1:1: usb_set_interface failed (-110)
>>> [  161.859999] usb 2-2.4: 1:1: usb_set_interface failed (-110)
>>>
>>>
>>> I have audio on that port. I haven't tried yet reverting these
>>> sound patches yet. demsg is filling up with these messages for
>>> sure.
>>>
>>
>> I just tried Linux 5.7-rc4 and it also has this problem. New in rc4 as
>> far as I can tell.
> 
> Then it's unlikely from the changes in sound/*, but I'd suspect rather
> USB core side.  There is only one change for USB-audio driver and it's
> a correction of USB device ID.
> 
> 

For what its worth not seeing this on 5.4.39-rc1 with the same set of
sound changes. I will start bisect on 5.6.11-rc1

thanks,
-- Shuah

