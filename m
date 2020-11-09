Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670552AB287
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 09:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgKIIiL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 9 Nov 2020 03:38:11 -0500
Received: from mga04.intel.com ([192.55.52.120]:11408 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726127AbgKIIiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 03:38:11 -0500
IronPort-SDR: pKcpPCuPpBfpS1Prs8QwPve+K6qQau2kxFylwRZZnt/w4dFkGPpTFmBehHtXsNFFQ6gR+VJ7C9
 VslNo016qpUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="167182604"
X-IronPort-AV: E=Sophos;i="5.77,463,1596524400"; 
   d="scan'208";a="167182604"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 00:38:09 -0800
IronPort-SDR: URgk027lW0k7A9koHZd1eL/Df8fB5ntkbax7hPAPsj+NMg+AVjPmsYUXP56l5fgkmdRM/H4fUs
 rG+EniBjF9eA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,463,1596524400"; 
   d="scan'208";a="322363521"
Received: from irsmsx605.ger.corp.intel.com ([163.33.146.138])
  by orsmga003.jf.intel.com with ESMTP; 09 Nov 2020 00:38:02 -0800
Received: from irsmsx601.ger.corp.intel.com (163.33.146.7) by
 IRSMSX605.ger.corp.intel.com (163.33.146.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Nov 2020 08:38:02 +0000
Received: from irsmsx601.ger.corp.intel.com ([163.33.146.7]) by
 irsmsx601.ger.corp.intel.com ([163.33.146.7]) with mapi id 15.01.1713.004;
 Mon, 9 Nov 2020 08:38:02 +0000
From:   "Rojewski, Cezary" <cezary.rojewski@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "Gorski, Mateusz" <mateusz.gorski@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Mark Brown <broonie@kernel.org>
Subject: RE: [PATCH] ASoC: Intel: Skylake: Add alternative topology binary
 name
Thread-Topic: [PATCH] ASoC: Intel: Skylake: Add alternative topology binary
 name
Thread-Index: AQHWsesetrmyqB6A606/K4JDH1AqQKm2iiKAgAFSVACAAAM7AIAGkXhQgAAMdoCAAQUlgA==
Date:   Mon, 9 Nov 2020 08:38:02 +0000
Message-ID: <cb48723796ac40018d5b804da42d0863@intel.com>
References: <20201103141047.15053-1-mateusz.gorski@linux.intel.com>
 <20201103153541.GC3267686@kroah.com>
 <d6006431-420f-55c7-0f78-977507e11fcf@linux.intel.com>
 <20201104115810.GA1694250@kroah.com>
 <0f6a673556974a289c2b81f3a8cc7536@intel.com>
 <20201108170059.GA18354@kroah.com>
In-Reply-To: <20201108170059.GA18354@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [163.33.253.164]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-11-08 6:00 PM, Greg KH wrote:
> On Sun, Nov 08, 2020 at 04:17:16PM +0000, Rojewski, Cezary wrote:
>> On 2020-11-04 12:58 PM, Greg KH wrote:
>>> On Wed, Nov 04, 2020 at 12:46:36PM +0100, Gorski, Mateusz wrote:
>>>>
>>>>>> [ Upstream commit 1b290ef023b3eeb4f4688b582fecb773915ef937 ]
>>>>>>
>>>>>> Add alternative topology binary file name based on used machine driver
>>>>>> and fallback to use this name after failed attempt to load topology file
>>>>>> with name based on NHLT.
>>>>>> This change addresses multiple issues with current mechanism, for
>>>>>> example - there are devices without NHLT table, and that currently
>>>>>> results in tplg_name being empty.
...

>>>>> What problems are people facing, and what kernel(s) are you asking for
>>>>> this to be ported to, and why can't people just use 5.8 or newer if they
>>>>> have this new hardware?
>>>>>
>>>>
>>>> I forgot to add - I wanted this change to be merged to stable 5.4 kernel.
>>>> Please let me know if I should resend this patch with this information
>>>> included.
>>>>
>>>> As for the user issues - topology binary file name is currently created
>>>> according to information from NHLT. The problem is, that some laptops (for
>>>> example Dell XPS 13) do not have NHLT at all. This results in topology
>>>> binary name being empty (" ").
>>>> This patch adds alternative name based on loaded machine driver.
>>>>
>>>> It applies not only to new hardware, please note that the mentioned Dell XPS
>>>> 13 is based on Kabylake. This issue existed on upstream from the beginning
>>>> of Skylake driver and was only recently addressed.
>>>
>>> When was that laptop released and is this the only change that is needed
>>> in order for the 5.4.y kernel to work properly on it?
>>>
>>
>> Sorry for the late answer, Greg. To address your concerns and questions
>> let me elaborate:
>>
>> Indeed, this change is not the only one required to enable DMIC + HDA
>> configuration for customers. The following series is essential:
>>
>> [PATCH 0/7] ASoC: Intel: Skylake: Fix HDaudio and Dmic
>> https://lore.kernel.org/alsa-devel/20200305145314.32579-1-cezary.rojewski@intel.com/
> 
> Great, then they should just use a newer kernel version.  It's crazy to
> think that you can go back in time and get older kernels working for
> newer hardware :)

Skylake and Kabylake-based platforms are few years old already, that's
not exactly a "newer hardware". Icelake and such are and these are not
part of /skylake driver. Fact is, this should all be part of 4.19 or
earlier since DMIC + HDA configuration are available even there. And
receiving laptop with such kernel and no patches fails miserably ; (

Unfortunately, kernels 4.19 and below need many more changes than "just"
6 fixes as HDA-generic soundcard isn't available there. That, however,
can easily be called "a new feature" so stopping at 5.4 is a fair call.

Thanks,
Czarek

