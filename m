Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49E228E007
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 13:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgJNLwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 07:52:08 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:51818 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJNLwI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 07:52:08 -0400
Received: from [192.168.0.20] (cpc89244-aztw30-2-0-cust3082.18-1.cable.virginm.net [86.31.172.11])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 22121A42;
        Wed, 14 Oct 2020 13:52:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1602676325;
        bh=T9Uc6h53rw9NAitsG8SsOkkuxSUeWPLQQ6nmZi7wfWI=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=KQr4h90Ofbb/Hg3tjDPYwk0bMEMAaIMJCP8JKqvfQPi9BMR2NeMzDJ85nhr/vjdEj
         o6+I1wvRA9PnBnKoPulVsZif+qEyzjz3cltIZPAuYEWKzt2QYk/vVoy7jiggRKMvdQ
         5kX+Tflwb236ab9TH3D4DcJW967dsXc0dzlt9GwE=
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH AUTOSEL 5.8 17/20] i2c: core: Call
 i2c_acpi_install_space_handler() before i2c_acpi_register_devices()
To:     Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org
References: <20200921144027.2135390-1-sashal@kernel.org>
 <20200921144027.2135390-17-sashal@kernel.org>
 <1977b57b-fae6-d9d4-e6bf-3d4013619537@ideasonboard.com>
 <bbeb7cae-d856-bb25-4602-8dd3bae62773@redhat.com>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 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
 WZw01QYHU/GUV/zHJSFk
Organization: Ideas on Board
Message-ID: <da7fa0ff-8264-47a4-6d40-1641d315be1c@ideasonboard.com>
Date:   Wed, 14 Oct 2020 12:52:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bbeb7cae-d856-bb25-4602-8dd3bae62773@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Hans,

On 14/10/2020 12:23, Hans de Goede wrote:
> Hi,
> 
> On 10/14/20 1:09 PM, Kieran Bingham wrote:
>> Hi Hans, Sasha,
>>
>> As mentioned on https://github.com/linux-surface/kernel/issues/63, I'm
>> afraid I've bisected a boot time issue on the Microsoft Surface Go 2 to
>> this commit on the stable 5.8 tree.
>>
>> The effect as reported there is that the boot process stalls just after
>> loading the usbhid module.
>>
>> Typing, or interacting with the Keyboard (Type Cover) at that point
>> appears to cause usb bus resets, but I don't know if that's a related
>> symptom or just an effect of some underlying root cause.
>>
>> I have been running a linux-media kernel on this device without issue.
>>
>> Is this commit in 5.9? I'll build a vanilla v5.9 kernel and see if it
>> occurs there too.
> 
> Yes the commit is in 5.9 too. Still would be interesting to see if 5.9 hits
> this issue too. I guess it will, but as I mentioned in:

Indeed, I've just tested vanilla 5.9 on a Surface Go 2 and that's broken
I'm afraid.

Back traces on 5.9 [0] show hung tasks on both the i915_driver_probe,
and the tps68470_gpio_probe. I suspect the i915 failure of course is the
reason a desktop environment can't be reached, however I was able to ssh
in at least ;-)

[0] https://paste.debian.net/1167081/


Given that this is now a mainline bug, I'll reply to the mainline patch
and suggest a revert there, rather than here on the stable patches.

As for fixing it ... I don't have enough visibility of the problem for
both this, and the issues that were fixed by this patch.

Let me know if there's anything you'd like me to investigate further, or
dig into specifically.

--
Kieran


> https://github.com/linux-surface/kernel/issues/63
> 
> I do not understand why this commit is causing this issue.
> 
> So I just checked and the whole acpidump is not using I2C
> opregion stuff at all:
> 
> [hans@x1 microsoft-surface-go2]$ ack GenericSerialBus *.dsl
> [hans@x1 microsoft-surface-go2]$
> 
> And there is only 1 _REG handler which is for the
> embedded-controller.
> 
> So this patch should not make a difference at all on the GO2,
> other then maybe a subtle timing difference somewhere ... ?
> 
> Regards,
> 
> Hans
> 
> 
>> On 21/09/2020 15:40, Sasha Levin wrote:
>>> From: Hans de Goede <hdegoede@redhat.com>
>>>
>>> [ Upstream commit 21653a4181ff292480599dad996a2b759ccf050f ]
>>>
>>> Some ACPI i2c-devices _STA method (which is used to detect if the device
>>> is present) use autodetection code which probes which device is present
>>> over i2c. This requires the I2C ACPI OpRegion handler to be registered
>>> before we enumerate i2c-clients under the i2c-adapter.
>>>
>>> This fixes the i2c touchpad on the Lenovo ThinkBook 14-IIL and
>>> ThinkBook 15 IIL not getting an i2c-client instantiated and thus not
>>> working.
>>>
>>> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1842039
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>>> Signed-off-by: Wolfram Sang <wsa@kernel.org>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>   drivers/i2c/i2c-core-base.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
>>> index 4f09d4c318287..7031393c74806 100644
>>> --- a/drivers/i2c/i2c-core-base.c
>>> +++ b/drivers/i2c/i2c-core-base.c
>>> @@ -1336,8 +1336,8 @@ static int i2c_register_adapter(struct
>>> i2c_adapter *adap)
>>>         /* create pre-declared device nodes */
>>>       of_i2c_register_devices(adap);
>>> -    i2c_acpi_register_devices(adap);
>>>       i2c_acpi_install_space_handler(adap);
>>> +    i2c_acpi_register_devices(adap);
>>>         if (adap->nr < __i2c_first_dynamic_bus_num)
>>>           i2c_scan_static_board_info(adap);
>>>
>>
>>
> 

-- 
Regards
--
Kieran
