Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEE4179419
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 16:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbgCDPxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 10:53:36 -0500
Received: from mail1.perex.cz ([77.48.224.245]:39134 "EHLO mail1.perex.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbgCDPxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 10:53:36 -0500
Received: from mail1.perex.cz (localhost [127.0.0.1])
        by smtp1.perex.cz (Perex's E-mail Delivery System) with ESMTP id 37EF8A0042;
        Wed,  4 Mar 2020 16:53:34 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp1.perex.cz 37EF8A0042
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=perex.cz; s=default;
        t=1583337214; bh=8SBxtxpHwSLRC2CbYe+Q730Ys/1ADQK9is9B9mt3J5M=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=XTLpF1o6y/U7MbxAjYukq2Y8c+BdeO7aC2HMS5rgFZBJ8G5dufbd/Ykr5uggGJxW7
         +6ziAslGoqjpEVIDMaLxtHM0wMre1x1snlHogYgdtNMx8wNAhoFTBsHcG8FsOb9SaH
         2vJg1LqXJdH+qOKjNU4sn99WZ97YugR0wb2CMBG8=
Received: from p50.perex-int.cz (unknown [192.168.100.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: perex)
        by mail1.perex.cz (Perex's E-mail Delivery System) with ESMTPSA;
        Wed,  4 Mar 2020 16:53:28 +0100 (CET)
Subject: Re: 5.5.y - apply "ASoC: intel/skl/hda - export number of digital
 microphones via control components"
To:     Mark Brown <broonie@kernel.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Pierre-louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        ALSA development <alsa-devel@alsa-project.org>
References: <147efa37-eb57-7f17-b9eb-84a9fe5ad475@perex.cz>
 <20200304154450.GB5646@sirena.org.uk>
From:   Jaroslav Kysela <perex@perex.cz>
Message-ID: <a6d57c14-0794-77d0-5c6f-c0c897d254b5@perex.cz>
Date:   Wed, 4 Mar 2020 16:53:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200304154450.GB5646@sirena.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dne 04. 03. 20 v 16:44 Mark Brown napsal(a):
> On Wed, Mar 04, 2020 at 04:25:54PM +0100, Jaroslav Kysela wrote:
>> Hi,
>>
>>    could we cherry-pick patch 8cd9956f61c65022209ce6d1e55ed12aea12357d to the
>> 5.5 stable tree?
>>
>> 8cd9956f61c65022209ce6d1e55ed12aea12357d :
>>   "ASoC: intel/skl/hda - export number of digital microphones via control
>> components"
> 
> This looks more like a new feature than a bug fix and I've been trying
> to get the stable people to calm down with the backports, there's been
> *far* too many regressions introduced recently in just the x86 stuff
> found after the fact.  Does this fix systems that used to work?

The released ALSA UCM does not work correctly for some platforms without this 
information (the number of digital microphones is not identified correctly).

The regression probability is really low for this one and we're using it in 
Fedora kernels for months without issues (in this code).

				Thanks,
					Jaroslav

-- 
Jaroslav Kysela <perex@perex.cz>
Linux Sound Maintainer; ALSA Project; Red Hat, Inc.
