Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE78D145ECC
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 23:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgAVWuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 17:50:25 -0500
Received: from mga12.intel.com ([192.55.52.136]:7331 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbgAVWuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 17:50:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2020 14:50:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,351,1574150400"; 
   d="scan'208";a="229541509"
Received: from jovercas-mobl1.amr.corp.intel.com (HELO [10.254.105.26]) ([10.254.105.26])
  by orsmga006.jf.intel.com with ESMTP; 22 Jan 2020 14:50:22 -0800
Subject: Re: [alsa-devel] [PATCH] ASoC: topology: fix
 soc_tplg_fe_link_create() - link->dobj initialization order
To:     Jaroslav Kysela <perex@perex.cz>, Mark Brown <broonie@kernel.org>
Cc:     Dragos Tarcatu <dragos_tarcatu@mentor.com>,
        Sasha Levin <sashal@kernel.org>,
        ALSA development <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        stable@vger.kernel.org
References: <20200122190752.3081016-1-perex@perex.cz>
 <26ae4dbd-b1b8-c640-0dc0-d8c2bbe666e2@linux.intel.com>
 <20200122202530.GG3833@sirena.org.uk>
 <045401f5-8d4c-cdc3-12fb-cf35148411e5@perex.cz>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <67f2a1cf-fe62-76fa-ccdb-869e2b0daee2@linux.intel.com>
Date:   Wed, 22 Jan 2020 15:47:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <045401f5-8d4c-cdc3-12fb-cf35148411e5@perex.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>>> I am not following. Is this a fix for linux-5.4-y only, or is it 
>>> needed on
>>> Mark's tree? In the latter case, what is broken? We've been using Mark's
>>> tree without issues, wondering what we missed?
>>
>> He's saying it's a fix for stable but it's just a cleanup and robustness
>> improvement in current kernels - when the patch 76d270364932 (ASoC:
>> topology: Check return value for snd_soc_add_dai_link()) was backported
>> by the bot the bot missed some other context which triggered bugs.
> 
> Exactly. It's because the commit 
> 237d19080cd37e1ccf5462e63d8577d713f6da46 ("ASoC: soc-core: remove 
> topology specific operation") removed the link->dobj checks, but this 
> commit was not picked to the stable kernels.
> 
> The initialization reordering is fine for all kernels (and makes sense), 
> so I would like to apply it everywhere.

ok, thanks for the precisions.
