Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1135755D
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfF0AVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:21:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbfF0AVE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:21:04 -0400
Received: from localhost (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CA6A20663;
        Thu, 27 Jun 2019 00:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561594863;
        bh=IKe35oEhJZvYqgsiz7udgblC47kDC5uRQtBrjdadAbw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iD/DDI2CXJP3dJmOfa4DT3q516vkPrfaAch+8LK8Nvv9WrHx1vFcY1Xg4AGm4OIES
         VhA/cWHDBRb6/Aq+SCgOmBZvr0VYmRrtx8e8L3zBcfdNibPkU3Dnm+kAl3MhbfUMoH
         qMvDdR4O4/xqhUGZyNzDoN9PSP2CIvmYLrR3CHms=
Date:   Wed, 26 Jun 2019 20:20:59 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH AUTOSEL 5.1 07/51] ASoC: soc-dpm: fixup DAI active
 unbalance
Message-ID: <20190627002059.GN7898@sasha-vm>
References: <20190626034117.23247-1-sashal@kernel.org>
 <20190626034117.23247-7-sashal@kernel.org>
 <20190626100315.GS5316@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190626100315.GS5316@sirena.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 26, 2019 at 11:03:15AM +0100, Mark Brown wrote:
>On Tue, Jun 25, 2019 at 11:40:23PM -0400, Sasha Levin wrote:
>> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>>
>> [ Upstream commit f7c4842abfa1a219554a3ffd8c317e8fdd979bec ]
>>
>> snd_soc_dai_link_event() is updating snd_soc_dai :: active,
>> but it is unbalance.
>> It counts up if it has startup callback.
>
>Are you *sure* this doesn't have dependencies?

The actual code seems to correspond with the issue described in the
commit message, so I'd think not.

I can remove this patch if you're not confident about it.

--
Thanks,
Sasha
