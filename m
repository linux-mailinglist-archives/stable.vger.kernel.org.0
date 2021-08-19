Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5713F1C32
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 17:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239281AbhHSPHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 11:07:34 -0400
Received: from mga05.intel.com ([192.55.52.43]:32319 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239184AbhHSPH3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Aug 2021 11:07:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10081"; a="302160647"
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="302160647"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 08:06:52 -0700
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="522471382"
Received: from crojewsk-mobl1.ger.corp.intel.com (HELO [10.213.19.151]) ([10.213.19.151])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 08:06:50 -0700
Subject: Re: [PATCH v2] ASoC: Intel: Fix platform ID matching for
 kbl_da7219_max98373
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Lukasz Majczak <lma@semihalf.com>
Cc:     upstream@semihalf.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Curtis Malainey <cujomalainey@chromium.org>,
        stable@vger.kernel.org
References: <20210819082414.39497-1-lma@semihalf.com>
 <87736cce-a96f-064e-6d60-71645ba46f13@linux.intel.com>
From:   Cezary Rojewski <cezary.rojewski@intel.com>
Message-ID: <aeb40985-140f-b013-f368-778ad33fc7d0@intel.com>
Date:   Thu, 19 Aug 2021 17:06:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <87736cce-a96f-064e-6d60-71645ba46f13@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-08-19 4:30 PM, Pierre-Louis Bossart wrote:
> On 8/19/21 3:24 AM, Lukasz Majczak wrote:
>> Sparse warnings triggered truncating the IDs of some platform device
>> tables. Unfortunately kbl_da7219_max98373 was also truncated.
>> This patch is reverting the original ID.
>> Tested on Atlas chromebook.
> 
> Instead of reverting, how about changing the remaining occurrences of
> the old name in the machine driver?
> 
> sound/soc/intel/boards/kbl_da7219_max98927.c:   if (!strcmp(pdev->name,
> "kbl_da7219_max98373") ||
> sound/soc/intel/boards/kbl_da7219_max98927.c:           .name =
> "kbl_da7219_max98373",

Mentioned by 'Fixes' tag patch clearly introduced regression. If we are 
to update any name-fields, it's better to have a fresh start and update 
all the boards in one-go than doing so separately.

Apart from that, Maxim codecs go by the name of 'max' in 
sound/soc/codecs/. It's more intuitive to have equivalent shortcut used 
in board's name.


Regards,
Czarek
