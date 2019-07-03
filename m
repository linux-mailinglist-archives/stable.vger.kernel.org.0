Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDB625E641
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 16:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbfGCOQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 10:16:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726957AbfGCOQC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 10:16:02 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63B36218A4;
        Wed,  3 Jul 2019 14:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562163361;
        bh=Z5Q9c6N5pcNRJTsrqbCAmSGmLaXFi1adb61wVEtQN1M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WR4VGjKJMoXPGU+HXAaroKxcXZk+8X9kyhEnXMIjsa1AlxR9lo++0S+4558KzRZPe
         sOQ7kFCXg3FOZJcVt3K/ytzOSn0DdevYUasPxalrv8HMWVWmVkNMdg9Fb2IC4FA6Or
         LDv9BN1DcHEZUmtAmtoRHsT0gvV/R8BAV/GALRLE=
Date:   Wed, 3 Jul 2019 10:16:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH AUTOSEL 5.1 07/51] ASoC: soc-dpm: fixup DAI active
 unbalance
Message-ID: <20190703141600.GW11506@sasha-vm>
References: <20190626034117.23247-1-sashal@kernel.org>
 <20190626034117.23247-7-sashal@kernel.org>
 <20190626100315.GS5316@sirena.org.uk>
 <20190627002059.GN7898@sasha-vm>
 <20190701161801.GD2793@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190701161801.GD2793@sirena.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 01, 2019 at 05:18:01PM +0100, Mark Brown wrote:
>On Wed, Jun 26, 2019 at 08:20:59PM -0400, Sasha Levin wrote:
>> On Wed, Jun 26, 2019 at 11:03:15AM +0100, Mark Brown wrote:
>> > On Tue, Jun 25, 2019 at 11:40:23PM -0400, Sasha Levin wrote:
>
>> > > [ Upstream commit f7c4842abfa1a219554a3ffd8c317e8fdd979bec ]
>
>> > > snd_soc_dai_link_event() is updating snd_soc_dai :: active,
>> > > but it is unbalance.
>> > > It counts up if it has startup callback.
>
>> > Are you *sure* this doesn't have dependencies?
>
>> The actual code seems to correspond with the issue described in the
>> commit message, so I'd think not.
>
>> I can remove this patch if you're not confident about it.
>
>I'm not entirely, no.

Dropped it, thanks.

--
Thanks,
Sasha
