Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1F03393B3
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 17:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhCLQj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 11:39:57 -0500
Received: from mga17.intel.com ([192.55.52.151]:29283 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232398AbhCLQjf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 11:39:35 -0500
IronPort-SDR: X7b2PPo+ZzlWmiD5JyAHGyisWUQxDFqoaKLjLhoUj+gWjllznpbu6ABg2EWJanJHc3VLi9CNXf
 yIdWyi3qKSzw==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="168770863"
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="168770863"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 08:39:35 -0800
IronPort-SDR: da3MCXd1zGFGz+LIGK+EQ4coy9OkP5kZP8mIIk2jDYCcT4TxrFa4tukb8shD7i4m6dUq51/o35
 eyMciPl8WWqg==
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="411059361"
Received: from akharche-mobl2.ccr.corp.intel.com (HELO [10.212.135.254]) ([10.212.135.254])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 08:39:34 -0800
Subject: Re: [PATCH v3 1/2] ASoC: samsung: tm2_wm5110: check of of_parse
 return value
To:     Mark Brown <broonie@kernel.org>
Cc:     tiwai@suse.de, alsa-devel@alsa-project.org,
        Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
References: <20210311003516.120003-1-pierre-louis.bossart@linux.intel.com>
 <20210311003516.120003-2-pierre-louis.bossart@linux.intel.com>
 <20210312142812.GA17802@sirena.org.uk>
 <a9caf1c6-d9d0-7e05-31f2-6a8d9026e509@linux.intel.com>
 <20210312163124.GK5348@sirena.org.uk>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <22662857-46ca-1f3a-2a55-445384a5de07@linux.intel.com>
Date:   Fri, 12 Mar 2021 10:39:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210312163124.GK5348@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/12/21 10:31 AM, Mark Brown wrote:
> On Fri, Mar 12, 2021 at 10:30:32AM -0600, Pierre-Louis Bossart wrote:
>> On 3/12/21 8:28 AM, Mark Brown wrote:
> 
>>> Commit: 11bc3bb24003 ("ASoC: samsung: tm2_wm5110: check of of_parse return value")
>>> 	Fixes tag: Fixes: 8d1513cef51a ("ASoC: samsung: Add support for HDMI audio on TM2board")
>>> 	Has these problem(s):
>>> 		- Subject does not match target commit subject
>>> 		  Just use
>>> 			git log -1 --format='Fixes: %h ("%s")'
> 
>> Sorry, I don't know what to make of this. I don't see this commit
>> 11bc3bb24003
> 
>> Something odd happened, there was an initial merge and it seems to have
>> disappeared, it's no longer in the for-next branch?
> 
> That commit is your patch being applied, which I've dropped because of
> the error reported.

ack, not sure why there's a missing space.

git log -1 --format='Fixes: %h ("%s")' 8d1513cef51a
Fixes: 8d1513cef51a ("ASoC: samsung: Add support for HDMI audio on TM2 
board")



