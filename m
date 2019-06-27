Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE865757B
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfF0AY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:24:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbfF0AY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:24:26 -0400
Received: from localhost (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89F2820815;
        Thu, 27 Jun 2019 00:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595066;
        bh=alD1se/H8oSgNNFyrIfLo/Nfix2/7MSIr7dtHdEMxz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nUE3ssRAsi7TSkJaT84htx3XrfeVIZO8w2Ah4D0LMJGbTSnCKtsVdGMDNqzj04zoQ
         yWPiIQMdlZWcsPvXMQnUJDgwHLgl4zv+tC+Pdo87oXr7HimLZf24Izawzep8WHCLWq
         CVxNTKOwX5JTuZm/dTlmAxGMYvdBRRNXjBFXknww=
Date:   Wed, 26 Jun 2019 20:24:22 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        "kernelci . org bot" <bot@kernelci.org>
Subject: Re: [PATCH AUTOSEL 5.1 38/51] ASoC: core: Fix deadlock in
 snd_soc_instantiate_card()
Message-ID: <20190627002422.GO7898@sasha-vm>
References: <20190626034117.23247-1-sashal@kernel.org>
 <20190626034117.23247-38-sashal@kernel.org>
 <20190626103912.GW5316@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190626103912.GW5316@sirena.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 26, 2019 at 11:39:12AM +0100, Mark Brown wrote:
>On Tue, Jun 25, 2019 at 11:40:54PM -0400, Sasha Levin wrote:
>> From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
>>
>> [ Upstream commit 495f926c68ddb905a7a0192963096138c6a934e1 ]
>>
>> Move the client_mutex lock to snd_soc_unbind_card() before
>> removing link components. This prevents the deadlock
>> in the error path in snd_soc_instantiate_card().
>
>Again, are you sure there's no dependencies?

I'm taking the patch it depends on (also a fix) as part of this AUTOSEL
branch.

--
Thanks,
Sasha
