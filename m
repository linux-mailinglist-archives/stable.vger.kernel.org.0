Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4BD94F6610
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 18:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238190AbiDFQy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 12:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238177AbiDFQyH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 12:54:07 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E646425E26;
        Wed,  6 Apr 2022 07:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649254700; x=1680790700;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YmIXCsMYCeWATU+in/DRP/A6BQR/Ctfd6i0hCV0gooc=;
  b=CVBXtslYTFZCA78N6EHW3ul0Xe+Ar+6XGgrOapCFNo7L0S0nIPGnpJng
   culcypL0+uADdR6lDw5shmyRxv/kEjPg/HdoTqTZYnRq8JEsstACxklb1
   /6xxpHR8/ObXyEXsrLeujodLpmcgKJ55YK8nGmbLfiqsbEaPDNbmQ/sfj
   zscj5c+7xL5H79JPBBwKjcQqKY2YM8Ik3O2rIw2er/DdmKcqLLuO3K8go
   wyQwhrgTQ8oYZWIj7bw2VAgNGb/wjASeG8wUbaYbVnc7PWBRhTROfoC7d
   Yxxw1TLfogXhS7AeOlb6qPiTO0yWR1s3c5fsy5xr9Pe4tsAnSiJo/vvt+
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="258646143"
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="258646143"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 07:06:24 -0700
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="642065188"
Received: from mrice-x13.amr.corp.intel.com (HELO [10.209.59.160]) ([10.209.59.160])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 07:06:22 -0700
Message-ID: <b92a20b9-f645-8637-d665-747b27eb65f6@linux.intel.com>
Date:   Wed, 6 Apr 2022 09:06:21 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: sof_es8336 build failure [was: [PATCH 5.17 0000/1126] 5.17.2-rc1
 review]
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Mark Brown <broonie@kernel.org>,
        yung-chuan.liao@linux.intel.com, peter.ujfalusi@linux.intel.com,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
References: <20220405070407.513532867@linuxfoundation.org>
 <8ea245ed-eac9-1cd5-31bd-150a06378872@kernel.org>
 <06b5cc53-8de6-b238-70eb-9c1d5f245f78@kernel.org>
 <Yk2HbuCEaSSh8sKc@kroah.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <Yk2HbuCEaSSh8sKc@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/6/22 07:28, Greg Kroah-Hartman wrote:
> On Wed, Apr 06, 2022 at 09:37:59AM +0200, Jiri Slaby wrote:
>> Cc some folks and change subject
>>
>> On 06. 04. 22, 9:29, Jiri Slaby wrote:
>>> On 05. 04. 22, 9:12, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 5.17.2 release.
>>>> There are 1126 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>> ...
>>>> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>>>>       ASoC: Intel: sof_es8336: use NHLT information to set dmic and SSP
>>>
>>> Fails to build w/ suse x86_64 default config [1] (and x86_32 too):
>>>   > sound/soc/intel/boards/sof_es8336.c: In function ‘sof_es8336_probe’:
>>>   > sound/soc/intel/boards/sof_es8336.c:482:32: error: ‘struct
>>> snd_soc_acpi_mach_params’ has no member named ‘i2s_link_mask’; did you
>>> mean ‘link_mask’?
>>>   >   482 |         if (!mach->mach_params.i2s_link_mask) {
>>>   >       |                                ^~~~~~~~~~~~~
>>>   >       |                                link_mask
>>>   > sound/soc/intel/boards/sof_es8336.c:494:39: error: ‘struct
>>> snd_soc_acpi_mach_params’ has no member named ‘i2s_link_mask’; did you
>>> mean ‘link_mask’?
>>>   >   494 |                 if (mach->mach_params.i2s_link_mask & BIT(2))
>>>   >       |                                       ^~~~~~~~~~~~~
>>>   >       |                                       link_mask
>>>   > sound/soc/intel/boards/sof_es8336.c:496:44: error: ‘struct
>>> snd_soc_acpi_mach_params’ has no member named ‘i2s_link_mask’; did you
>>> mean ‘link_mask’?
>>>   >   496 |                 else if (mach->mach_params.i2s_link_mask &
>>> BIT(1))
>>>   >       |                                            ^~~~~~~~~~~~~
>>>   >       |                                            link_mask
>>>   > sound/soc/intel/boards/sof_es8336.c:498:45: error: ‘struct
>>> snd_soc_acpi_mach_params’ has no member named ‘i2s_link_mask’; did you
>>> mean ‘link_mask’?
>>>   >   498 |                 else  if (mach->mach_params.i2s_link_mask &
>>> BIT(0))
>>>   >       |                                             ^~~~~~~~~~~~~
>>>   >       |                                             link_mask
>>>
>>> So 679aa83a0fb70dcbf9e97c is missing -- but likely more is needed.
>>>
>>> [1] https://raw.githubusercontent.com/SUSE/kernel-source/stable/config/x86_64/default
>>>
>>>
> 
> Offending commit now dropped, thanks!

It's fine, this was part of a large series for a set of platforms based 
on the ES8336 and ES8326 codec, but it's still WIP with patches from 
Mauro for specific devices, UCM changes needed and the ES8326 still in 
review. This can hardly qualify for inclusion in a stable branch.
