Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9C3A9F826
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 04:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbfH1CNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 22:13:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfH1CNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 22:13:14 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7C4920674;
        Wed, 28 Aug 2019 02:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566958392;
        bh=z9cH+4cl9MeA/f7ur8vlDOxGaS3KL68qd9WMtzQrkVI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b8M7wDINZwo+GHxG2o6rCweuZViOOsTq4ZlAvlK9YmNKdBUHaLSssEfEprvyLJAx3
         oPdemG/tVA0OFWwsEx8KaCOfm2oMJtYjibfKLed253i/fNiPfv6D7fi8u8BQq7/ILe
         8gNCLrBwoCjx+zYfi9LlYHZfLo1oh1dwtFp7ruQA=
Date:   Tue, 27 Aug 2019 22:13:11 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ricard Wanderlof <ricard.wanderlof@axis.com>,
        Ricard Wanderlof <ricardw@axis.com>
Subject: Re: [PATCH AUTOSEL 5.2 040/123] ASoC: Fail card instantiation if DAI
 format setup fails
Message-ID: <20190828021311.GV5281@sasha-vm>
References: <20190814021047.14828-1-sashal@kernel.org>
 <20190814021047.14828-40-sashal@kernel.org>
 <20190814092213.GC4640@sirena.co.uk>
 <20190826013515.GG5281@sasha-vm>
 <20190827110014.GD23391@sirena.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190827110014.GD23391@sirena.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 12:00:14PM +0100, Mark Brown wrote:
>On Sun, Aug 25, 2019 at 09:35:15PM -0400, Sasha Levin wrote:
>> On Wed, Aug 14, 2019 at 10:22:13AM +0100, Mark Brown wrote:
>
>> > > If the DAI format setup fails, there is no valid communication format
>> > > between CPU and CODEC, so fail card instantiation, rather than continue
>> > > with a card that will most likely not function properly.
>
>> > This is another one where if nobody noticed a problem already and things
>> > just happened to be working this might break things, it's vanishingly
>> > unlikely to fix anything that was broken.
>
>> Same as the other patch: this patch suggests it fixes a real bug, and if
>> this patch is broken let's fix it.
>
>If anyone ran into this on the older kernel and fixed or worked
>around it locally there's a reasonable chance this will then
>break what they're doing.  The patch itself is perfectly fine but

But there's not much we can do here. We can't hold off on fixing
breakage such as this because existing users have workarounds for this.
Are we breaking kernel ABI with this patch then?

And what about new users? We'll let them get hit by the issue and
develop their own workarounds?

>that doesn't mean the rest of the changes it's being backported
>into are also fine.

This is fair, and we can always hold off on patches if you want more
time for them to be tested/reviewed. Is it the case here?

--
Thanks,
Sasha
