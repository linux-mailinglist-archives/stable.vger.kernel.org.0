Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBCA25E762
	for <lists+stable@lfdr.de>; Sat,  5 Sep 2020 14:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgIEMDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Sep 2020 08:03:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728468AbgIEMDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Sep 2020 08:03:12 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E342520757;
        Sat,  5 Sep 2020 12:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599307392;
        bh=CL+8vNktyF9sqP+DrWIv2YGkaXiyazpKbZtcIXOTfSA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BWXOq0jUKp1yZ8Q/njk18/Tiixpxxrq6XTP8f7Ek0vMY+RW2LpXKUoD+qjtE5iDOg
         NPS/fcfzJBXfpJWuOWmSWX7sMWPUmGOm95FZJmj2EzYTWltZcF2mRlsp6GLvHeV3mx
         r05E4mXuaQ/j6t+KcEaib1+dYEAADV0rej/fx9IA=
Date:   Sat, 5 Sep 2020 08:03:10 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Keith Busch <kbusch@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.8 11/42] nvme: skip noiob for zoned devices
Message-ID: <20200905120310.GI8670@sasha-vm>
References: <20200831152934.1023912-1-sashal@kernel.org>
 <20200831152934.1023912-11-sashal@kernel.org>
 <20200831153818.GA83475@C02WT3WMHTD6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200831153818.GA83475@C02WT3WMHTD6>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 31, 2020 at 09:38:18AM -0600, Keith Busch wrote:
>On Mon, Aug 31, 2020 at 11:29:03AM -0400, Sasha Levin wrote:
>> From: Keith Busch <kbusch@kernel.org>
>>
>> [ Upstream commit c41ad98bebb8f4f0335b3c50dbb7583a6149dce4 ]
>>
>> Zoned block devices reuse the chunk_sectors queue limit to define zone
>> boundaries. If a such a device happens to also report an optimal
>> boundary, do not use that to define the chunk_sectors as that may
>> intermittently interfere with io splitting and zone size queries.
>>
>> Signed-off-by: Keith Busch <kbusch@kernel.org>
>> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>You can safely drop this from stable: nvme zoned devices were only introduced
>to linux in 5.9.

Dropped, thanks!

-- 
Thanks,
Sasha
