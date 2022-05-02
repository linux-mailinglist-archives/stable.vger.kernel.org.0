Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D47517125
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 16:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235196AbiEBOEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 10:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385479AbiEBOEi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 10:04:38 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25B5DFA5;
        Mon,  2 May 2022 07:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651500068; x=1683036068;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SB+mn4fRsEDPQCfTw8QCueHkfqpMzSgEmOFpanrd+SA=;
  b=HLjXlPk1fIrq24lnJRFLHJZTzAxyw81Bt6lDHioqNAJ9jSZp47Y4vlma
   fVCvxsmuTI7LDZe0JxO/d+2OXKZMy3RaLbyCVT9jr/VGVfy3q6+k/NyWa
   gZBRZuwy/4heV6HNs3lj0YuqtjSIYHHyYe8GPyK38jytHgPXIL7rtsB1a
   jaU3/jLFmXEW55nkMjf+Uzu+4iGxaTU2XlATiMtXQiehLZLFheclSmhSD
   XjWRdpFSS/q2OCZrjjFFS2/x7697nOf4LQLNMJhbKWQNRWAj1LI80IfWC
   181T859R/jpRxyVedFL8wjFspONIZWCR2bO9mTTo9pyxFn1Iz8W7YlKh8
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10334"; a="327758741"
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="327758741"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 07:01:06 -0700
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="561742281"
Received: from sushilsu-mobl1.amr.corp.intel.com (HELO [10.251.9.25]) ([10.251.9.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 07:01:05 -0700
Message-ID: <62f73d83-56b0-1ccb-c7f6-5bf975f7bf9b@linux.intel.com>
Date:   Mon, 2 May 2022 09:01:04 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH AUTOSEL 5.17 06/22] ASoC: Intel: sof_es8336: Add a quirk
 for Huawei Matebook D15
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, Mark Brown <broonie@kernel.org>
Cc:     cezary.rojewski@intel.com, alsa-devel@alsa-project.org,
        yung-chuan.liao@linux.intel.com, tiwai@suse.com,
        yang.jie@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, liam.r.girdwood@linux.intel.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        peter.ujfalusi@linux.intel.com
References: <20220426190145.2351135-1-sashal@kernel.org>
 <20220426190145.2351135-6-sashal@kernel.org> <Ymko4F24MvbGJUXp@sirena.org.uk>
 <Ym7gMZRI7ad6u0fL@sashalap>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <Ym7gMZRI7ad6u0fL@sashalap>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/1/22 14:32, Sasha Levin wrote:
> On Wed, Apr 27, 2022 at 12:28:32PM +0100, Mark Brown wrote:
>> On Tue, Apr 26, 2022 at 03:01:29PM -0400, Sasha Levin wrote:
>>> From: Mauro Carvalho Chehab <mchehab@kernel.org>
>>>
>>> [ Upstream commit c7cb4717f641db68e8117635bfcf62a9c27dc8d3 ]
>>>
>>> Based on experimental tests, Huawei Matebook D15 actually uses
>>> both gpio0 and gpio1: the first one controls the speaker, while
>>> the other one controls the headphone.
>>
>> Are you sure this doesn't need the rest of the series it came along
>> with?
> 
> I'm not :) Should we queue it too?

If you add this platform to -stable, you'd need the entire series https://lore.kernel.org/alsa-devel/20220308192610.392950-1-pierre-louis.bossart@linux.intel.com/, and the additions made by Mauro.

My take is that it's not really relevant for -stable, support for this hardware codec is still a works-in-progress and while we'd certainly want to have more distributions use the hardware support it's quite disruptive for -stable maintainers, with the risk of compilation problems and functional issues introduced. it'll make more sense for 5.18+.

