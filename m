Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0542FD5CC
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 17:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730699AbhATQgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 11:36:14 -0500
Received: from mga06.intel.com ([134.134.136.31]:8540 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391387AbhATQfM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 11:35:12 -0500
IronPort-SDR: NTfWwIvawqACqSzBYKe2EHFlQ2bIYQWwrbYtNgP7JKxDkqLtS6/71ItDncH1M6WmtvYSIzxSUF
 cFdFteEOv2hQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="240673440"
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="240673440"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 08:33:23 -0800
IronPort-SDR: NaTwmjflADhRHtNI8n0obvI0Q7vHMzOHK+6I23GOLIWvsfLcOL1dFqajClmMBmHE+qn0RzpzKd
 YIBVWTkaq5xw==
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="426954211"
Received: from yperets-mobl1.ger.corp.intel.com (HELO [10.209.89.231]) ([10.209.89.231])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 08:33:21 -0800
Subject: Re: [PATCH v2] ASoC: Intel: Skylake: Check the kcontrol against NULL
To:     =?UTF-8?Q?=c5=81ukasz_Majczak?= <lma@semihalf.com>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Mateusz Gorski <mateusz.gorski@linux.intel.com>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alex Levin <levinale@google.com>,
        Guenter Roeck <groeck@google.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Rojewski, Cezary" <cezary.rojewski@intel.com>,
        =?UTF-8?Q?Amadeusz_S=c5=82awi=c5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>
References: <20201210121438.7718-1-lma@semihalf.com>
 <20201217130439.141943-1-lma@semihalf.com>
 <CAFJ_xbprw7UKREWgRAq3dDAA9oC_3cWoozn5pCY8w9By4dASag@mail.gmail.com>
 <CAFJ_xbrvr7jcCB57MPwzXf=oC5OYT5KUBkcqHYyOYH=a5njfSA@mail.gmail.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <8c22c415-1807-b673-20e3-bc8d7f4c05b7@linux.intel.com>
Date:   Wed, 20 Jan 2021 10:33:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAFJ_xbrvr7jcCB57MPwzXf=oC5OYT5KUBkcqHYyOYH=a5njfSA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/20/21 9:49 AM, Łukasz Majczak wrote:
> Hi Pierre,
> 
> Is there anything more to do to get the ACK for this patch?

Adding Cezary and Amadeusz for feedback, I can't pretend having any sort 
of knowledge on the Skylake driver internals and topology usage.

> Best regards,
> Lukasz
> 
> wt., 12 sty 2021 o 12:34 Łukasz Majczak <lma@semihalf.com> napisał(a):
>>
>> Hi,
>>
>> This is just a kind reminder. Is there anything more required to
>> upstream this patch?
>>
>> Best regards,
>> Lukasz
>>
>>
>> czw., 17 gru 2020 o 14:06 Lukasz Majczak <lma@semihalf.com> napisał(a):
>>>
>>> There is no check for the kcontrol against NULL and in some cases
>>> it causes kernel to crash.
>>>
>>> Fixes: 2d744ecf2b984 ("ASoC: Intel: Skylake: Automatic DMIC format configuration according to information from NHLT")
>>> Cc: <stable@vger.kernel.org> # 5.4+
>>> Signed-off-by: Lukasz Majczak <lma@semihalf.com>
>>> Reviewed-by: Mateusz Gorski <mateusz.gorski@linux.intel.com>
>>> ---
>>>   sound/soc/intel/skylake/skl-topology.c | 14 ++++++++++----
>>>   1 file changed, 10 insertions(+), 4 deletions(-)
>>>   v1 -> v2: fixed coding style
>>>
>>> diff --git a/sound/soc/intel/skylake/skl-topology.c b/sound/soc/intel/skylake/skl-topology.c
>>> index ae466cd592922..8f0bfda7096a9 100644
>>> --- a/sound/soc/intel/skylake/skl-topology.c
>>> +++ b/sound/soc/intel/skylake/skl-topology.c
>>> @@ -3618,12 +3618,18 @@ static void skl_tplg_complete(struct snd_soc_component *component)
>>>          int i;
>>>
>>>          list_for_each_entry(dobj, &component->dobj_list, list) {
>>> -               struct snd_kcontrol *kcontrol = dobj->control.kcontrol;
>>> -               struct soc_enum *se =
>>> -                       (struct soc_enum *)kcontrol->private_value;
>>> -               char **texts = dobj->control.dtexts;
>>> +               struct snd_kcontrol *kcontrol;
>>> +               struct soc_enum *se;
>>> +               char **texts;
>>>                  char chan_text[4];
>>>
>>> +               kcontrol = dobj->control.kcontrol;
>>> +               if (!kcontrol)
>>> +                       continue;
>>> +
>>> +               se = (struct soc_enum *)kcontrol->private_value;
>>> +               texts = dobj->control.dtexts;
>>> +
>>>                  if (dobj->type != SND_SOC_DOBJ_ENUM ||
>>>                      dobj->control.kcontrol->put !=
>>>                      skl_tplg_multi_config_set_dmic)
>>> --
>>> 2.25.1
>>>
