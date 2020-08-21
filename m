Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED7C24E12B
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 21:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgHUTxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 15:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725831AbgHUTxY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 15:53:24 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 573AF20724;
        Fri, 21 Aug 2020 19:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598039603;
        bh=2QiDitSdOfxDO/VB+exgpZpgxuRzBDeUzezQJr8QVrg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jl35uN05Ru3fv0hxS6qF5hY3560r8yv6moIt7DFzB1WDYYMzngZsF0C+LI+g+jrV/
         u35bhBpz3hWNyr6b3FZaixD870XZRc4DmbqQr6cBK98ovKM/BsFoD3dn+7YmI/PTVP
         Jys7Z7xSwBSJjJbbGx8g0HAd++wUsvtjBWRa1rYE=
Date:   Fri, 21 Aug 2020 15:53:22 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Gal Pressman <galpress@amazon.com>,
        Shadi Ammouri <sammouri@amazon.com>,
        Yossi Leybovich <sleybo@amazon.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.8 55/62] RDMA/efa: Add EFA 0xefa1 PCI ID
Message-ID: <20200821195322.GC8670@sasha-vm>
References: <20200821161423.347071-1-sashal@kernel.org>
 <20200821161423.347071-55-sashal@kernel.org>
 <20200821194036.GB2811093@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200821194036.GB2811093@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 04:40:36PM -0300, Jason Gunthorpe wrote:
>On Fri, Aug 21, 2020 at 12:14:16PM -0400, Sasha Levin wrote:
>> From: Gal Pressman <galpress@amazon.com>
>>
>> [ Upstream commit d4f9cb5c5b224dca3ff752c1bb854250bf114944 ]
>>
>> Add support for 0xefa1 devices.
>>
>> Link: https://lore.kernel.org/r/20200722140312.3651-5-galpress@amazon.com
>> Reviewed-by: Shadi Ammouri <sammouri@amazon.com>
>> Reviewed-by: Yossi Leybovich <sleybo@amazon.com>
>> Signed-off-by: Gal Pressman <galpress@amazon.com>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/infiniband/hw/efa/efa_main.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>
>Wait, what? Why is this being autosel'd?

Stable trees try to pick up device enablement patches (such as patches
that add PCI IDs). I suppose that AUTOSEL get pretty eager to grab
those.

>This needs to be the last patch in a series enabling support for this
>chip, it will badly break this driver to pick it out of sequence!!

I'll drop it, thanks for letting me know!

-- 
Thanks,
Sasha
