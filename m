Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADDF11046FA
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 00:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbfKTXcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 18:32:02 -0500
Received: from mga09.intel.com ([134.134.136.24]:6334 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbfKTXcC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Nov 2019 18:32:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 15:32:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,223,1571727600"; 
   d="scan'208";a="197041002"
Received: from akiruban-mobl.amr.corp.intel.com (HELO [10.255.228.77]) ([10.255.228.77])
  by orsmga007.jf.intel.com with ESMTP; 20 Nov 2019 15:32:00 -0800
Subject: Re: [PATCH 4.19 038/422] soundwire: Initialize completion for defer
 messages
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        Shreyas NC <shreyas.nc@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051402.440815842@linuxfoundation.org>
 <20191120215417.GA23361@duo.ucw.cz>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <96ef8f59-e0f1-ed87-d712-13d5419f9068@linux.intel.com>
Date:   Wed, 20 Nov 2019 16:52:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191120215417.GA23361@duo.ucw.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>> [ Upstream commit a306a0e4a5326269b6c78d136407f08433ab5ece ]
>>
>> Deferred messages are async messages used to synchronize
>> transitions mostly while doing a bank switch on multi links.
>> On successful transitions these messages are marked complete
>> and thereby confirming that all the buses performed bank switch
>> successfully.
>>
>> So, initialize the completion structure for the same.
>>
>> Signed-off-by: Sanyog Kale <sanyog.r.kale@intel.com>
> 
> This is only called from sdw_transfer_defer() and that function is
> called in mainline, but is unused in 4.19.X.
> 
> So I don't think this is suitable for -stable.

Agree.

Multi-link solutions with synchronized streaming are not supported just 
yet. It's an important feature but it'll only be enabled after the 
existing backlog of 60+ patches are merged, and when the ASoC multi-cpu 
support allows for this feature, hopefully for 5.7.

my 2 cents
-Pierre

