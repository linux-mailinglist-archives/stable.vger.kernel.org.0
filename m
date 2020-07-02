Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31132128D8
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 18:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgGBQBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 12:01:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:38956 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgGBQBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 12:01:00 -0400
IronPort-SDR: ymFLz1hv0Ok17xOhw2sa88x5qq6dnt0nchufVV+bFJ6hUbCdVP1QS7dAD/SSNiswKGe7w6jdtQ
 3mhQaMbZYybQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="148484204"
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="148484204"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 09:00:59 -0700
IronPort-SDR: uhwaa7uGNaoqs+PK3xjQnx7NweL6s2+zvtP9lCnnjnKJs+Ggylown6aJ0ORyzmj9w3md68k77K
 CwvEPA5TFikA==
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="304292241"
Received: from nchava-mobl1.amr.corp.intel.com (HELO [10.252.135.144]) ([10.252.135.144])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 09:00:58 -0700
Subject: Re: [PATCH AUTOSEL 5.7 15/53] ASoC: SOF: Intel: add PCI IDs for ICL-H
 and TGL-H
To:     Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>
Cc:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        alsa-devel@alsa-project.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        sound-open-firmware@alsa-project.org
References: <20200702012202.2700645-1-sashal@kernel.org>
 <20200702012202.2700645-15-sashal@kernel.org>
 <20200702111835.GB4483@sirena.org.uk>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <0baf17f3-1af8-a4a1-644c-ab27490f9b44@linux.intel.com>
Date:   Thu, 2 Jul 2020 10:42:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200702111835.GB4483@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/2/20 6:18 AM, Mark Brown wrote:
> On Wed, Jul 01, 2020 at 09:21:24PM -0400, Sasha Levin wrote:
>> From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>>
>> [ Upstream commit c8d2e2bfaeffa0f914330e8b4e45b986c8d30b58 ]
>>
>> Usually the DSP is not traditionally enabled on H skews but this might
>> be used moving forward.
> 
> "This might be used moving forward"?

There are two conditions for the SOF driver to be used in a distro:
a) the DSP needs to be enabled (as reported by the pci class info)
b) sound/hda/intel-dsp-config.c needs to contain a quirk to select SOF 
over the legacy HDaudio, such as presence of DMIC/SoundWire or a known 
vendor DMI.

Traditionally for desktops neither a) nor b) are true, but this is 
changing: we will start adding quirks for specific product lines as 
requested by OEMs.

Does this answer to your question?
