Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFF13DB99C
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 15:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhG3Nu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 09:50:59 -0400
Received: from mga17.intel.com ([192.55.52.151]:16708 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhG3Nu6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 09:50:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10060"; a="193378837"
X-IronPort-AV: E=Sophos;i="5.84,282,1620716400"; 
   d="scan'208";a="193378837"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 06:50:53 -0700
X-IronPort-AV: E=Sophos;i="5.84,282,1620716400"; 
   d="scan'208";a="508128490"
Received: from crojewsk-mobl1.ger.corp.intel.com (HELO [10.213.24.117]) ([10.213.24.117])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 06:50:51 -0700
Subject: Re: [PATCH v1] ASoC: Intel: kbl_da7219_max98357a: fix drv_name
To:     Lukasz Majczak <lma@semihalf.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     upstream@semihalf.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210730115906.144300-1-lma@semihalf.com>
From:   Cezary Rojewski <cezary.rojewski@intel.com>
Message-ID: <bd223956-93c8-1fb6-325d-0afb34ad2f23@intel.com>
Date:   Fri, 30 Jul 2021 15:50:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210730115906.144300-1-lma@semihalf.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-07-30 1:59 PM, Lukasz Majczak wrote:
> platform_id for kbl_da7219_max98357a was shrunk for kbl_da7219_mx98357a,
> but the drv_name was changed for kbl_da7219_max98373. Tested on a
> Pixelbook (Atlas).

Reasoning behind Pierre's initial commit is valid and I believe 
kbl_da7219_max98373 name change was simply unintended. To make the 
situation clearer, please be more elaborate in commit's message.

> Fixes: 94efd726b947 ("ASoC: Intel: kbl_da7219_max98357a: shrink platform_id below 20 characters")
> Cc: <stable@vger.kernel.org> # 5.4+
> Reported-by: Cezary Rojewski <cezary.rojewski@intel.com>

Please reword to: Suggested-by. I certainly wasn't the one who found the 
problem first, but I did provide the initial fix.

I don't see any problem is the code, so besides formalities:

Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>


Thanks,
Czarek
