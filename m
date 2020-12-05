Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC492CF8FC
	for <lists+stable@lfdr.de>; Sat,  5 Dec 2020 03:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725550AbgLECiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 21:38:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57547 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgLECiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 21:38:22 -0500
Received: from [111.196.65.193] (helo=[192.168.0.105])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1klNS8-0005UN-8U; Sat, 05 Dec 2020 02:37:40 +0000
Subject: Re: [PATCH] ALSA: hda/realtek: make bass spk volume adjustable on a
 yoga laptop
To:     Takashi Iwai <tiwai@suse.de>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
References: <20201204123459.71474-1-hui.wang@canonical.com>
 <s5hblf94lki.wl-tiwai@suse.de>
From:   Hui Wang <hui.wang@canonical.com>
Message-ID: <37d313c3-3e1c-66a5-6c7a-ab5f71cf0d75@canonical.com>
Date:   Sat, 5 Dec 2020 10:37:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <s5hblf94lki.wl-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/4/20 11:50 PM, Takashi Iwai wrote:
> On Fri, 04 Dec 2020 13:34:59 +0100,
> Hui Wang wrote:
>> This also make the headset button work on this machine.
> Hm, the description isn't clearly related with the code changes.
> Could you elaborate a bit more?  The functions you changed are used
> commonly, so it needs clarification.
>
>
> thanks,
>
> Takashi

OK, will change the description in the v2.

Thanks,

Hui.

>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Hui Wang <hui.wang@canonical.com>
>> ---
>>   sound/pci/hda/patch_realtek.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
>> index 8616c5624870..5a905fa1b33a 100644
>> --- a/sound/pci/hda/patch_realtek.c
>> +++ b/sound/pci/hda/patch_realtek.c
>> @@ -3104,6 +3104,7 @@ static void alc_disable_headset_jack_key(struct hda_codec *codec)
>>   	case 0x10ec0215:
>>   	case 0x10ec0225:
>>   	case 0x10ec0285:
>> +	case 0x10ec0287:
>>   	case 0x10ec0295:
>>   	case 0x10ec0289:
>>   	case 0x10ec0299:
>> @@ -3130,6 +3131,7 @@ static void alc_enable_headset_jack_key(struct hda_codec *codec)
>>   	case 0x10ec0215:
>>   	case 0x10ec0225:
>>   	case 0x10ec0285:
>> +	case 0x10ec0287:
>>   	case 0x10ec0295:
>>   	case 0x10ec0289:
>>   	case 0x10ec0299:
>> @@ -8578,6 +8580,11 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
>>   		{0x14, 0x90170110},
>>   		{0x19, 0x04a11040},
>>   		{0x21, 0x04211020}),
>> +	SND_HDA_PIN_QUIRK(0x10ec0287, 0x17aa, "Lenovo", ALC285_FIXUP_THINKPAD_HEADSET_JACK,
>> +		{0x14, 0x90170110},
>> +		{0x17, 0x90170111},
>> +		{0x19, 0x03a11030},
>> +		{0x21, 0x03211020}),
>>   	SND_HDA_PIN_QUIRK(0x10ec0286, 0x1025, "Acer", ALC286_FIXUP_ACER_AIO_MIC_NO_PRESENCE,
>>   		{0x12, 0x90a60130},
>>   		{0x17, 0x90170110},
>> -- 
>> 2.25.1
>>
