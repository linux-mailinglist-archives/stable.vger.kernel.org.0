Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF3C6864FF
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 12:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbjBALFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 06:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjBALFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 06:05:49 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FEEEC4F
        for <stable@vger.kernel.org>; Wed,  1 Feb 2023 03:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675249547; x=1706785547;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wUI9fwdxyITvbXcc3bSr/O1oZNGcCUvap6bRqf8k2dQ=;
  b=aNMBhHCAYtY8ynITrxnhbURqIexBpETNPD9jQ7rsaELghqE0yV84Hhfc
   LWNKWk8mnBfTFJ+O1/U+EeeGsPAQkaw5DMnCy4RcYTnS5aTQ97V6iAPx1
   5Hn1vaLporo3fHtfLv90rQDVDMGgnP20MyJTkILR9S82trK91ei8BAJay
   7X7P/ng8TDNHVIoMR9RAPatXYtNwy9ZxUjnreuqVJwiuzC8KZZXxB0kTW
   5NWkRDKUAWpM4w8Ozx1EBZ7FhMyO80qESj830cA2ZTO10RNoridvE1Fz+
   Grf85Aj37w4SroSnfuUGeOATdQDeOUTItAXxwFnnqfrNUcEnLASDwGIVO
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="390501507"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="390501507"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 03:05:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="773395829"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="773395829"
Received: from aslawinx-mobl.ger.corp.intel.com (HELO [10.99.16.144]) ([10.99.16.144])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 03:05:44 -0800
Message-ID: <6262bd72-cc2b-9d2a-e8f0-55c2b2bb7861@linux.intel.com>
Date:   Wed, 1 Feb 2023 12:05:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
Content-Language: en-US
To:     Jason Montleon <jmontleo@redhat.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>
Cc:     Sasa Ostrouska <casaxa@gmail.com>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Greg KH <gregkh@linuxfoundation.org>, lma@semihalf.com,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
References: <CAJD_bPJ1VYTSQvogui4S9xWn9jQzQq8JRXOzXmus+qoRyrybOA@mail.gmail.com>
 <Y9Vg26wjGfkCicYv@kroah.com>
 <CAJD_bPLkkgbk+GO66Ec9RmiW6MfYrG32WP75oLzXsz2+rpREWg@mail.gmail.com>
 <CAJD_bPK=m0mX8_Qq=6iwD8sL8AkR99PEzBbE3RcSaJmxuJmW6g@mail.gmail.com>
 <02834fa9-4fb0-08fb-4b5f-e9646c1501d6@leemhuis.info>
 <288d7ff4-75aa-7ad1-c49c-579373cab3ed@intel.com>
 <CALFERdw=GwNYafR3q=5=k=H_jrzTZMyDBQLouFGV0JGu8i9sCg@mail.gmail.com>
 <04a9f939-8a98-9a46-e165-8e9fb8801a83@intel.com>
 <CAJD_bP+Te5a=OfjN9YrjGOG2PzudQ87=5FEKj6YLFxfKyFe5bw@mail.gmail.com>
From:   =?UTF-8?Q?Amadeusz_S=c5=82awi=c5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>
In-Reply-To: <CAJD_bP+Te5a=OfjN9YrjGOG2PzudQ87=5FEKj6YLFxfKyFe5bw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/31/2023 4:16 PM, Jason Montleon wrote:
> On Tue, Jan 31, 2023 at 7:37 AM Cezary Rojewski
> <cezary.rojewski@intel.com> wrote:
>>
>> On 2023-01-30 1:22 PM, Sasa Ostrouska wrote:
>>
>>> Dear Czarek, many thanks for the answer and taking care of it. If
>>> needed something from my side please jest let me know
>>> and I will try to do it.
>>
>>
>> Hello Sasa,
>>
>> Could you provide us with the topology and firmware binary present on
>> your machine?
>>
>> Audio topology is located at /lib/firmware and named:
>>
>> 9d71-GOOGLE-EVEMAX-0-tplg.bin
>> -or-
>> dfw_sst.bin
>>
>> Firmware on the other hand is found in /lib/firmware/intel/.
>> 'dsp_fw_kbl.bin' will lie there, it shall be a symlink pointing to an
>> actual AudioDSP firmware binary.
>>
> Maybe this is the problem.
> 
> I think most of us are pulling the topology and firmware from the
> chromeos recovery images for lack of any other known source, and it
> looks a little different than this. Those can be downloaded like so:
> https://gist.github.com/jmontleon/8899cb83138f2653f520fbbcc5b830a0
> 
> After placing the topology file you'll see these errors and audio will
> not work until they're also copied in place.
> snd_soc_skl 0000:00:1f.3: Direct firmware load for
> dsp_lib_dsm_core_spt_release.bin failed with error -2
> snd_soc_skl 0000:00:1f.3: Direct firmware load for
> intel/dsp_fw_C75061F3-F2B2-4DCC-8F9F-82ABB4131E66.bin failed with
> error -2
> 
> Once those were in place, up to 6.0.18 audio worked.
> 
> Is there a better source for the topology file?
> 
>> The reasoning for these asks is fact that problem stopped reproducing on
>> our end once we started playing with kernel versions (moved away from
>> status quo with Fedora). Neither on Lukasz EVE nor on my SKL RVP.
>> However, we might be using newer configuration files when compared to
>> equivalent of yours.
>>
>> Recent v6.2-rc5 broonie/sound/for-next - no repro
>> Our internal tree based on Mark's for-next - no repro
>> 6.1.7 stable [1] - no repro
>>
>> Of course we will continue with our attempts. Will notify about the
>> progress.
>>
>>
>> [1]:
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v6.1.7&id=21e996306a6afaae88295858de0ffb8955173a15
>>
>>
>> Kind regards,
>> Czarek
>>
> 
> 

Hi Jason,

as I understand you've tried to do bisect, can you instead try building 
kernels checking out following tags:
v6.1      v6.1.1    v6.1.2    v6.1.3    v6.1.4    v6.1.5    v6.1.6 
v6.1.7    v6.1.8
and report when it stops working, so it narrows scope of what we look 
at? I assume that kernel builds are done using upstream stable kernel 
(from https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/).

Thanks,
Amadeusz
