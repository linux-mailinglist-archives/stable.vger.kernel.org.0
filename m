Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F81B1C25EB
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 15:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgEBNrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 09:47:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727948AbgEBNrX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 2 May 2020 09:47:23 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A95112071E;
        Sat,  2 May 2020 13:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588427242;
        bh=73TIjw9O6dK2fAlfdODYkB/VFm8uvKuFeW5svJp5uFA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MC4T9yrNMAJ94kM2+SXcWdp6i2eKFYOzXDawiBEHaYHb2biJ9zHC2GbFujl40NAYf
         5pVS6ClrEJRxbfN+WfsKaVEAKrj99uQ/bXcD/zBYaQ+LgxWhVQXqpH/5w2f9MxyKOB
         EhdNt8MV9yshaw+3oRvYnAyj42Wi+lS4OFNVH0EU=
Date:   Sat, 2 May 2020 09:47:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Guillaume Tucker <guillaume.tucker@collabora.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernelci@groups.io, Kevin Hilman <khilman@baylibre.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: Re: stable-rc/linux-5.4.y bisection: baseline.dmesg.alert on
 meson-g12a-x96-max
Message-ID: <20200502134721.GH13035@sasha-vm>
References: <5eabecbf.1c69fb81.2c617.628f@mx.google.com>
 <cc10812b-19bd-6bd1-75da-32082241640a@collabora.com>
 <20200501122536.GA38314@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200501122536.GA38314@sirena.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 01, 2020 at 01:25:36PM +0100, Mark Brown wrote:
>On Fri, May 01, 2020 at 12:57:27PM +0100, Guillaume Tucker wrote:
>
>> The call stack is not the same as in the commit message found by
>> the bisection, so maybe it only fixed part of the problem:
>
>No, it is a backport which was fixing an issue that wasn't present in
>v5.4.
>
>> >   Result:     09f4294793bd3 ASoC: meson: axg-card: fix codec-to-codec link setup
>
>As I said in reply to the AUTOSEL mail:
>
>| > Since the addition of commit 9b5db059366a ("ASoC: soc-pcm: dpcm: Only allow
>| > playback/capture if supported"), meson-axg cards which have codec-to-codec
>| > links fail to init and Oops:
>
>| This clearly describes the issue as only being present after the above
>| commit which is not in v5.6.
>
>Probably best that this not be backported.

Hrm... But I never queued that commit... I wonder what's up.

-- 
Thanks,
Sasha
