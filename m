Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1DF5757D
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfF0AZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:25:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbfF0AZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:25:02 -0400
Received: from localhost (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66F0C20815;
        Thu, 27 Jun 2019 00:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595101;
        bh=l5x2VvRl++sXWxBNrMQE3zytnOqiTo0fKg1zqbtx46w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cs/+gfhPiTphyqbKkCAedgK/080En6ogMkzs8OuId21lUsX7nctTpa8kFCUoxIZVW
         ym9SrZvKu89pXJ0nTObaJNjMzdBqLEMBRLBSbzG1fdJrmphqya/7mG04+JEBlGuutb
         X5tzXZWlppGoemjAL7H7T3mrSYhH41aoyyYlXurY=
Date:   Wed, 26 Jun 2019 20:24:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Subject: Re: [PATCH AUTOSEL 5.1 08/51] ASoC: core: lock client_mutex while
 removing link components
Message-ID: <20190627002457.GP7898@sasha-vm>
References: <20190626034117.23247-1-sashal@kernel.org>
 <20190626034117.23247-8-sashal@kernel.org>
 <20190626103701.GT5316@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190626103701.GT5316@sirena.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 26, 2019 at 11:37:01AM +0100, Mark Brown wrote:
>On Tue, Jun 25, 2019 at 11:40:24PM -0400, Sasha Levin wrote:
>> From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
>>
>> [ Upstream commit 34ac3c3eb8f0c07252ceddf0a22dd240e5c91ccb ]
>>
>> Removing link components results in topology unloading. So,
>> acquire the client_mutex before removing components in
>> soc_remove_link_components. This will prevent the lockdep warning
>> seen when dai links are removed during topology removal.
>
>There's additional fixes for this IIRC.

The fix is part of this branch, you commented on it as well.

--
Thanks,
Sasha
