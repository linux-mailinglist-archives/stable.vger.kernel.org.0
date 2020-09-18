Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFCA27008F
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 17:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgIRPK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 11:10:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:17603 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgIRPK2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 11:10:28 -0400
IronPort-SDR: BsL3e7rEjwEesC+3ALsBxGBPUbR90Y35PpsyRxJfhfP1ir8Yzlx44Quizs3cJm7ahwhPiOYkGG
 NnB4jONUx+XA==
X-IronPort-AV: E=McAfee;i="6000,8403,9748"; a="160014043"
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="160014043"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 08:10:26 -0700
IronPort-SDR: dOtXpYSi4LiuqNRT90e4YmtQJtKZBB/dCbvx3vIX7taPDv31qXkMlIKiQfKh92GU3e7slJrEQ/
 tJumBvT+c0cQ==
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="332666597"
Received: from tsecasiu-mobl.amr.corp.intel.com (HELO [10.213.179.236]) ([10.213.179.236])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 08:10:25 -0700
Subject: Re: [PATCH 3/7] ASoC: SOF: intel: hda: support also devices with 1
 and 3 dmics
To:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        alsa-devel@alsa-project.org
Cc:     tiwai@suse.de, broonie@kernel.org,
        Jaska Uimonen <jaska.uimonen@linux.intel.com>,
        Stable <stable@vger.kernel.org>
References: <20200825235040.1586478-1-ranjani.sridharan@linux.intel.com>
 <20200825235040.1586478-4-ranjani.sridharan@linux.intel.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <b799ec66-356d-865e-a30b-ca28d5046326@linux.intel.com>
Date:   Fri, 18 Sep 2020 10:10:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200825235040.1586478-4-ranjani.sridharan@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/25/20 6:50 PM, Ranjani Sridharan wrote:
> From: Jaska Uimonen <jaska.uimonen@linux.intel.com>
> 
> Currently the dmic check code supports only devices with 2 or 4 dmics.
> With other dmic counts the function will return 0. Lately we've seen
> devices with only 1 dmic thus enable also configurations with 1, and
> possibly 3, dmics. Add also topology postfix -1ch and -3ch for new dmic
> configuration.
> 
> Signed-off-by: Jaska Uimonen <jaska.uimonen@linux.intel.com>
> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

we now have multiple reports of devices with a single microphone where 
audio is broken without this patch, e.g. 
https://github.com/thesofproject/linux/issues/2451

This patch should be applied to -stable versions all the way to 5.6. It 
would be desirable for 5.5 and 5.4 as well but it will not apply 
cleanly. It's be trivial to provide a modified patch for these earlier 
kernel versions but I don't know what the process might be here?


