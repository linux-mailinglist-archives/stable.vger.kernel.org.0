Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A55144F87A
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 15:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhKNO2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 09:28:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:60136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229563AbhKNO2n (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 09:28:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7C5461027;
        Sun, 14 Nov 2021 14:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636899949;
        bh=ZV2Hx3+pIL6mKU8se/mh5FSio88H9eOPjUCiqqBfNMY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WEXnx6VbLq/G2BMMPxLRQ7erP972PFzRoh0VTTIJKNZMRst2e9JgagN4H/KGNaG1F
         O9mxp+qs7h8l1cvr6dgs2wVo2R+uDexa4twqzLBQyg9lDdAIZZNmhyg2JOcy7NqIm2
         +/TAd42dHuaga7bCxwMnOVWjZBTRpDQIGtW4Wh6OI/wNUg3dYxKmDe7BwPbTJxjUzN
         PE84zJNVgFZpigvIy4Qvu7Gd7yUSaYfpWX5aPunG3QkGxYRp668Um3fDSycfg0YFFA
         CHDy81cKJLPRZeg4CrXOBH+IIEaTljLV3Y5vd7sZ5eUj8ysfIs0L3bekdoe1yQ4xkp
         TcoWd7YsZL+Dg==
Date:   Sun, 14 Nov 2021 09:25:48 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Charan Teja Reddy <charante@codeaurora.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Subject: Re: AUTOSEL series truncated was -- Re: [PATCH AUTOSEL 5.15 001/146]
 dma-buf: WARN on dmabuf release with pending attachments
Message-ID: <YZEcbEY4HkvZYdOh@sashalap>
References: <20211108174453.1187052-1-sashal@kernel.org>
 <20211109075423.GA16766@amd>
 <3957633e-9596-e329-c79b-b45e9993d139@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3957633e-9596-e329-c79b-b45e9993d139@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 09, 2021 at 08:05:23AM -0800, Randy Dunlap wrote:
>On 11/8/21 11:54 PM, Pavel Machek wrote:
>>Hi!
>>
>>This series is truncated .. I only got first patches. Similary, 5.10
>>series is truncated, [PATCH AUTOSEL 5.10 035/101] media: s5p-mfc: Add
>>checking to s5p_mfc_probe... is last one I got.
>>
>>I got all the patches before that, so I believe it is not problem on
>>my side, but I'd not mind someone confirming they are seeing the same
>>problem...
>
>Yes, several of the patch series were incomplete for me also...

Odd. I'll keep a closer look next time I send a series out to figure out
what's going on.

Thanks for the heads-up!

-- 
Thanks,
Sasha
