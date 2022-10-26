Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1EC460EA6B
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 22:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbiJZUm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 16:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbiJZUmG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 16:42:06 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25FAA23C3;
        Wed, 26 Oct 2022 13:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666816925; x=1698352925;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1gaLxx2/iHz7YZIBgFqkbZxBg68PkAwpn99ti8lfuqs=;
  b=Z7+ovRIlwsZGcLhQ+9mTLcKsIfryYqFNHZoVuI9/KcXdxpd7vMs7G9Ls
   k/CzB63y6z3ihVIPw2LL+Zfp3wxdOrYZFC+4WdBlOkNvSzKPmNoWzt0dA
   KzAEMlOU3EBYk2MsNQ7mIOBThlzIgtdJixB6KgxSDsJd4m25btUsEFfDL
   pI/vvgZ6s/FroF2gYT1UEtB1a67hJmKmhAVJuPMXYZyWxcaXer5Yiih/R
   1zLUR1bTLSel/Ikr1WiSR8m3O7j+rRYcocxv6ryC6rvg567RusuIMJbqx
   1G1K5HH0QSk/rpCio45rHLdhT6T5uNRO0tWCOr8E+i3bx9pQOGQ5qg4iy
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="288450861"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="288450861"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 13:42:05 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="610103338"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="610103338"
Received: from bcoan-mobl2.amr.corp.intel.com (HELO [10.209.189.197]) ([10.209.189.197])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 13:42:05 -0700
Message-ID: <3f207f82-e177-c833-b2b0-ca9e64a6e9a7@linux.intel.com>
Date:   Wed, 26 Oct 2022 15:41:09 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [Regression] Bug 216613 - Sound stopped working with v6.0.3 on
 Lenovo T14 Gen2i: ASoC: error at snd_soc_component_probe #forregzbot
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Cc:     alsa-devel@alsa-project.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <2c028797-b313-be93-7b1e-8d838e694948@leemhuis.info>
 <f34cafd4-f224-ad10-6962-e8f6c709cb39@leemhuis.info>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <f34cafd4-f224-ad10-6962-e8f6c709cb39@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/26/22 07:08, Thorsten Leemhuis wrote:
> [Note: this mail is primarily send for documentation purposes and/or for
> regzbot, my Linux kernel regression tracking bot. That's why I removed
> most or all folks from the list of recipients, but left any that looked
> like a mailing lists. These mails usually contain '#forregzbot' in the
> subject, to make them easy to spot and filter out.]
> 
> On 22.10.22 08:35, Thorsten Leemhuis wrote:
>> Hi, this is your Linux kernel regression tracker speaking.
>>
>> I noticed a regression report in bugzilla.kernel.org. As many (most?)
>> kernel developer don't keep an eye on it, I decided to forward it by
>> mail. Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=216613 :
>>
>>>  Grzegorz Alibożek 2022-10-21 19:26:43 UTC
>>>
>>> After upgrade kernel from 6.0.2 to 6.0.3 on Lenovo T14 Gen2i, sound stopped working.
>>> dmesg:
>>>
>>> paź 21 21:11:45 kernel: snd_hda_codec_hdmi ehdaudio0D2: failed to create hda codec -12
>>> paź 21 21:11:45 kernel: snd_hda_codec_hdmi ehdaudio0D2: ASoC: error at snd_soc_component_probe on ehdaudio0D2: -12
>>> paź 21 21:11:45 kernel: skl_hda_dsp_generic skl_hda_dsp_generic: ASoC: failed to instantiate card -12
>>>
>>> [reply] [−] Comment 1 Grzegorz Alibożek 2022-10-21 19:56:43 UTC
>>>
>>> Created attachment 303070 [details]
>>> trace
> 
> #regzbot introduced: 7494e2e6c55ed19
> #regzbot fixed-by: 02356311982b

Revert on its way:

https://lore.kernel.org/r/20221024143931.15722-1-tiwai@suse.de
