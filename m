Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBA35EB39
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 20:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfGCSKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 14:10:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbfGCSKH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 14:10:07 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB77C21882;
        Wed,  3 Jul 2019 18:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562177407;
        bh=0yHrCqLUVM5hmhFa2U+32z6di/Py3HZt/DwDkp6e8k4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i3bEBz7RhkfhSgVniQwrOtHLlfu2anpHF7Eud3yb9BJeWAOaiXOLX/kikKXmWWrPf
         dg2ik1CcBv1Hiuo++gSNs3NPKFHyaCcWSorEMeQQQbqOen//fBy/QCqKZRcy5EFWII
         2ct1bCz75s7IeB94vyLC4cHuVhhoSwg1WYcUbmxo=
Date:   Wed, 3 Jul 2019 14:10:05 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Georgii Staroselskii <georgii.staroselskii@emlid.com>,
        Chen-Yu Tsai <wens@csie.org>
Subject: Re: [PATCH AUTOSEL 5.1 11/51] ASoC: sun4i-codec: fix first delay on
 Speaker
Message-ID: <20190703181005.GB2733@sasha-vm>
References: <20190626034117.23247-1-sashal@kernel.org>
 <20190626034117.23247-11-sashal@kernel.org>
 <20190626103741.GU5316@sirena.org.uk>
 <20190703142047.GX11506@sasha-vm>
 <20190703170744.GB3490@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190703170744.GB3490@sirena.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 03, 2019 at 06:07:44PM +0100, Mark Brown wrote:
>On Wed, Jul 03, 2019 at 10:20:47AM -0400, Sasha Levin wrote:
>> On Wed, Jun 26, 2019 at 11:37:41AM +0100, Mark Brown wrote:
>> > On Tue, Jun 25, 2019 at 11:40:27PM -0400, Sasha Levin wrote:
>
>> > > Allwinner DAC seems to have a delay in the Speaker audio routing. When
>> > > playing a sound for the first time, the sound gets chopped. On a second
>> > > play the sound is played correctly. After some time (~5s) the issue gets
>> > > back.
>
>> > This is inserting a big delay in the startup and might disrupt some
>> > production system.
>
>> But that would be a problem upstream as well, no?
>
>There's a difference between a problem that gets introduced in normal
>development tracking upstream and something that gets dropped into a
>stable release, we don't want people deciding that stable is something
>they can't just take en masse without really looking at what's in there.

Sure, but I don't see any work upstream on trying to correct this?

These sort of things are a reason why users stick with the same kernel
for years, which is what we'd like to avoid.

I'll drop this for now...

--
Thanks,
Sasha
