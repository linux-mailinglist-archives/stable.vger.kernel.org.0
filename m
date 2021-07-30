Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B1C3DB9FE
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 16:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239081AbhG3OFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 10:05:32 -0400
Received: from mga04.intel.com ([192.55.52.120]:32875 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239013AbhG3OFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 10:05:32 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10060"; a="211222526"
X-IronPort-AV: E=Sophos;i="5.84,282,1620716400"; 
   d="scan'208";a="211222526"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 07:05:25 -0700
X-IronPort-AV: E=Sophos;i="5.84,282,1620716400"; 
   d="scan'208";a="508132580"
Received: from crojewsk-mobl1.ger.corp.intel.com (HELO [10.213.24.117]) ([10.213.24.117])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 07:05:23 -0700
Subject: Re: [PATCH v1] ASoC: Intel: kbl_da7219_max98357a: fix drv_name
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Lukasz Majczak <lma@semihalf.com>
Cc:     upstream@semihalf.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210730115906.144300-1-lma@semihalf.com>
 <58b46549-9b42-1832-b1e1-680d56c3f393@linux.intel.com>
From:   Cezary Rojewski <cezary.rojewski@intel.com>
Message-ID: <c1fb1cd1-6d27-648a-ac9c-81e150505750@intel.com>
Date:   Fri, 30 Jul 2021 16:05:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <58b46549-9b42-1832-b1e1-680d56c3f393@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-07-30 3:55 PM, Pierre-Louis Bossart wrote:
> On 7/30/21 6:59 AM, Lukasz Majczak wrote:

...

>> @@ -113,7 +113,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_kbl_machines[] = {
>>   	},
>>   	{
>>   		.id = "DLGS7219",
>> -		.drv_name = "kbl_da7219_mx98373",
>> +		.drv_name = "kbl_da7219_max98373",
> 
> this one is wrong though? The correct name was already present, you're
> reverting back to the wrong name.
> 
> there's another one that I missed, do you mind changing this as well?
> 
> soc-acpi-intel-cml-match.c:             .drv_name = "cml_da7219_max98357a",
> 
> Should be "cml_da7219_mx98357a"
> 
> 

Not saying 'nay' or 'yay' but why is configuration first available on 
KBL platforms being renamed to 'cml_XXX'?

Czarek
