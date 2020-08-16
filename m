Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15AD12457D2
	for <lists+stable@lfdr.de>; Sun, 16 Aug 2020 15:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgHPNuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Aug 2020 09:50:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbgHPNuo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 16 Aug 2020 09:50:44 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0F4620708;
        Sun, 16 Aug 2020 13:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597585843;
        bh=r5pCUfa+7GL4gvMpA6LRaUpmJ+k+6F3pLpgO3AsGBSc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IcIXJ1m/11WVz17PkicGhPZwiDKLAHg/eDa+E8BGdOl1IBp5Be/eQDep5QcmIesQK
         D1mNV2pP53kE2UTreAa3r9JB0NoUqwQ5Z94svNW9L6y3YpdfsQksmCkiIez4fNWBN3
         CdMRfV8AEpBpgSPbYWpmN5Pw9Aqb3wLVzATjvJEk=
Date:   Sun, 16 Aug 2020 09:50:42 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Martin Wilck <mwilck@suse.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.8 70/72] nvme-multipath: do not fall back to
 __nvme_find_path() for non-optimized paths
Message-ID: <20200816135042.GU2975990@sasha-vm>
References: <20200808233542.3617339-1-sashal@kernel.org>
 <20200808233542.3617339-70-sashal@kernel.org>
 <1899fe01e1eb5c23270541e1833b12365818c150.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1899fe01e1eb5c23270541e1833b12365818c150.camel@suse.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 05:37:54PM +0200, Martin Wilck wrote:
>On Sat, 2020-08-08 at 19:35 -0400, Sasha Levin wrote:
>> From: Hannes Reinecke <hare@suse.de>
>>
>> [ Upstream commit fbd6a42d8932e172921c7de10468a2e12c34846b ]
>>
>> When nvme_round_robin_path() finds a valid namespace we should be
>> using it;
>> falling back to __nvme_find_path() for non-optimized paths will cause
>> the
>> result from nvme_round_robin_path() to be ignored for non-optimized
>> paths.
>>
>> Fixes: 75c10e732724 ("nvme-multipath: round-robin I/O policy")
>> Signed-off-by: Martin Wilck <mwilck@suse.com>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/nvme/host/multipath.c | 11 +++++++----
>>  1 file changed, 7 insertions(+), 4 deletions(-)
>
>Hello Sasha,
>
>this patch needs a fix that I recently submitted to linux-nvme.
>The same holds for the respective 5.7 and 5.4 AUTOSEL patches.
>
>http://lists.infradead.org/pipermail/linux-nvme/2020-August/018570.html

I'll grab it too, thanks!

-- 
Thanks,
Sasha
