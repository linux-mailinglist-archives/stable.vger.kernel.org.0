Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1493379CA
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 17:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhCKQpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 11:45:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52507 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229702AbhCKQoo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 11:44:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615481083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z/iM70UPGw0q9UWS7Bab1CEgThmuc/GO6xycqGWpyPQ=;
        b=Pa0tsY7X1KgDpvYVXD1lif7m23XS8LgSerW0fODMOf4u+vXXHkuRhAH/wbQytSTTBhjWma
        Gris0rC/2nWbGOlQU+zWsiwSdCsQQSsW1Wl6wDKr903j+2w/wbw6uZO9q8faqIVsd6+lud
        m6cVqC7M/LfkEicOyFPyp6ebPs+gHhE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-DxBunqfDPpmY8EhV_NDpCg-1; Thu, 11 Mar 2021 11:44:41 -0500
X-MC-Unique: DxBunqfDPpmY8EhV_NDpCg-1
Received: by mail-ej1-f71.google.com with SMTP id li22so4418602ejb.18
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 08:44:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z/iM70UPGw0q9UWS7Bab1CEgThmuc/GO6xycqGWpyPQ=;
        b=cAyE3jXrAf6CL8WPEpzUiudlMDa6ObSw8BBFGWgbXOGZKeJ3ORVIGdg5BxuE/11+Q5
         yB6x3SreNWeSCETNTjaMp8v4oIp+SklLb8n1UsxKLmBO7y8S1R6JvSja89cnVTuaqdYd
         wZ+/jp4QB/Rqd3hwkxL5U7VGQivZwWqajcaUdNHBFq0OWHHJJGnaQQvax9DLj8vJmfGE
         H8v7nB34v96AQaZpeuUM0HjVf5WFidzZHo9VJdodIBp9DbM+dHIYJNAJoxynnmUNWigH
         OWEgfau7HHj3GFxg95j8UaO1xdBR3Kxw9FfYOoBwDfqFteQ7P79RbXu1KiLCIaEtvNII
         9RPg==
X-Gm-Message-State: AOAM53297MsAbMUrl7K7aco+ONOCJhSuY6oqTsT//YNpt1rReZD7zpwo
        nzmjJVL3conXqBdq5ZC9pZM7i3TQLFUD+pJ5N+eRMBmIDlmXqqGPfffDAqHO/OCvp5mVAcgkNXQ
        MVMlxXmUpz+7OR3zuFvNpS7b6G2MiqxEeUnpZ6OVxvC1GdOHyTozQZOh6bGgXlHmaxRxs
X-Received: by 2002:a50:ed83:: with SMTP id h3mr9800254edr.140.1615481078626;
        Thu, 11 Mar 2021 08:44:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxL7jFXDPeGf/e3SfN+B7SLEqL3rrJi/VXQkdEil/cRez1PHAT5oigV36mjVHkV6YPHS8zc6w==
X-Received: by 2002:a50:ed83:: with SMTP id h3mr9800226edr.140.1615481078297;
        Thu, 11 Mar 2021 08:44:38 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id lu26sm1545776ejb.33.2021.03.11.08.44.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 08:44:37 -0800 (PST)
Subject: Re: [PATCH 1/2] ASoC: intel: atom: Stop advertising non working S24LE
 support
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jie Yang <yang.jie@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
References: <20210309105520.9185-1-hdegoede@redhat.com>
 <e1af1b57-d384-0dce-6362-c39197cf2063@linux.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <1c6f6608-5da3-1d57-1673-97ea22930ff9@redhat.com>
Date:   Thu, 11 Mar 2021 17:44:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <e1af1b57-d384-0dce-6362-c39197cf2063@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 3/9/21 4:42 PM, Pierre-Louis Bossart wrote:
> 
> 
> On 3/9/21 4:55 AM, Hans de Goede wrote:
>> The SST firmware's media and deep-buffer inputs are hardcoded to
>> S16LE, the corresponding DAIs don't have a hw_params callback and
>> their prepare callback also does not take the format into account.
>>
>> So far the advertising of non working S24LE support has not caused
>> issues because pulseaudio defaults to S16LE, but changing pulse-audio's
>> config to use S24LE will result in broken sound.
>>
>> Pipewire is replacing pulse now and pipewire prefers S24LE over S16LE
>> when available, causing the problem of the broken S24LE support to
>> come to the surface now.
>>
>> Cc: stable@vger.kernel.org
>> BugLink: https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/866
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> 
> Humm, that is strange.
> I can't recall such limitations in the firmware, and the SSP support does make use of 24 bits.
> Please give me a couple of days to double-check what's missing.

Note this is not about the format between the DSP (the DSP's SSP) and the codec,
this is the format between userspace and the DSP.

As is mentioned by the reporter of this issue:
https://github.com/thesofproject/sof/issues/3868#issuecomment-796809535
Both in that issue but also here:
https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/530#note_791736

And independently reproduced by my here:
https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/866#note_830336

The S24LE format ATM does not work when passed from userspace, this is
supposed to take 24 bits sampled packed into 32 bits ints (so padded
with 1 0 byte to make 32 bits per sample), but to actually get working
playback with the SST driver, the following commands are necessary:

ffmpeg -i /usr/share/sounds/alsa/Side_Left.wav -ar 96000 -f s32le -ac 2 test.raw
aplay --dump-hw-params -D"hw:1,0" -r48000 -c2 -fS24_LE test.raw

Note how the ffmpeg command to generate a working set of raw samples
is set to convert to full 32 bit samples, rather then 0 padded 24 bit
samples. Generating a .raw file with the same -f s32le argument to
ffmpeg and then playing it with aplay -fS24_LE while using the SOF
driver results in static. Where as with the SST driver it results
in working sound. This shows that the 2 clearly interpret the format
differently and it looks like the SST driver is interpreting it wrong.

Maybe the SST driver should advertise S32_LE support instead, SOF
advertised both S24_LE and S32_LE and the S32_LE format is the
one which works with .raw files generated with ffmpeg's -f s32le
option when using the SOF drv.

Note the format is not the only issue though, to get normal speed / pitch
playback, the file needs to be converted to a sample rate of 96KHz 
and then played back at 48 KHz, hence the "-ar 96000" argument to
ffmpeg to get normal playback when using aplay -fS24_LE with the SST driver.

Because of both these fmt and playback speed issues I decided to just
drop the SNDRV_PCM_FMTBIT_S24_LE support in my patch. I guess we could
try to fix it, but since the plan is the phase out the SST support for
these devices this year I believe that we should not spend too much
time on trying to fix the SST driver here.  Dropping the SNDRV_PCM_FMTBIT_S24_LE
is a simple workaround to bridge the time until we complete drop the
SST support.

Regards,

Hans



> 
>> ---
>>   sound/soc/intel/atom/sst-mfld-platform-pcm.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/sound/soc/intel/atom/sst-mfld-platform-pcm.c b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
>> index 9e9b05883557..aa5dd590ddd5 100644
>> --- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
>> +++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
>> @@ -488,14 +488,14 @@ static struct snd_soc_dai_driver sst_platform_dai[] = {
>>           .channels_min = SST_STEREO,
>>           .channels_max = SST_STEREO,
>>           .rates = SNDRV_PCM_RATE_44100|SNDRV_PCM_RATE_48000,
>> -        .formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
>> +        .formats = SNDRV_PCM_FMTBIT_S16_LE,
>>       },
>>       .capture = {
>>           .stream_name = "Headset Capture",
>>           .channels_min = 1,
>>           .channels_max = 2,
>>           .rates = SNDRV_PCM_RATE_44100|SNDRV_PCM_RATE_48000,
>> -        .formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
>> +        .formats = SNDRV_PCM_FMTBIT_S16_LE,
>>       },
>>   },
>>   {
>> @@ -506,7 +506,7 @@ static struct snd_soc_dai_driver sst_platform_dai[] = {
>>           .channels_min = SST_STEREO,
>>           .channels_max = SST_STEREO,
>>           .rates = SNDRV_PCM_RATE_44100|SNDRV_PCM_RATE_48000,
>> -        .formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
>> +        .formats = SNDRV_PCM_FMTBIT_S16_LE,
>>       },
>>   },
>>   {
>>
> 

