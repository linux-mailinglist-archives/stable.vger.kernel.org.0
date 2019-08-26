Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E88C49C701
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 03:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfHZBdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Aug 2019 21:33:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbfHZBdo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Aug 2019 21:33:44 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 925FF20673;
        Mon, 26 Aug 2019 01:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566783223;
        bh=soGnK/XzwmIt6U8KqKjDw3zFvx3AArGytKLbfjxOTk8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=coyATRWN2NkvEkHBvwzhaHowmyOrjxa/CeqeD0fYfoywkc6uCy2X+nTOZDSj6fc2c
         YZJi4RIAqlL1ZYUHKdlirvbyjBUHoHK0BG7/WDoxz2IEBC12w28e0+T2oS6x71e9Kx
         PIQj1P/P4h1Xu8d+OWupLOmLU+463V4ZM11CUkc4=
Date:   Sun, 25 Aug 2019 21:33:42 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>
Subject: Re: [PATCH AUTOSEL 5.2 022/123] ASoC: dapm: Fix handling of
 custom_stop_condition on DAPM graph walks
Message-ID: <20190826013342.GF5281@sasha-vm>
References: <20190814021047.14828-1-sashal@kernel.org>
 <20190814021047.14828-22-sashal@kernel.org>
 <20190814092052.GB4640@sirena.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190814092052.GB4640@sirena.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 14, 2019 at 10:20:52AM +0100, Mark Brown wrote:
>On Tue, Aug 13, 2019 at 10:09:06PM -0400, Sasha Levin wrote:
>> From: Charles Keepax <ckeepax@opensource.cirrus.com>
>>
>> [ Upstream commit 8dd26dff00c0636b1d8621acaeef3f6f3a39dd77 ]
>>
>> DPCM uses snd_soc_dapm_dai_get_connected_widgets to build a
>> list of the widgets connected to a specific front end DAI so it
>> can search through this list for available back end DAIs. The
>
>The DPCM code and its users are rather fragile, if nobody noticed a
>problem I'd worry about causing some other problem to manifest by
>disturbing things.

Doesn't this patch imply that someone noticed it?

And if not, it'll just break when folks update their kernel...

If it creates other problems we should address them now rather than
later.

--
Thanks,
Sasha
