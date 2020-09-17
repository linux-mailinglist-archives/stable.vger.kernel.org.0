Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F039226D0C1
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 03:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgIQBpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 21:45:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbgIQBpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 21:45:30 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F2BB20684;
        Thu, 17 Sep 2020 01:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600306538;
        bh=oGKEU0SwK4LnjTiWr5ukfXNFIYbnnmMpvPAu1mpxRnI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p1DhXw+NqESUsJxjIz2x75aGifEBZU7s0BO36qof9ETHhi5tAFSaYcQe9KRFSOmSs
         15AIYqCIa9JgKSte4it817SsKKQWttAzpXEODBpQGeSNH0LPXDSexTRyfYeDJ8b+9u
         ruvx3JaD3dt4YMmlPcA7XMkxwnCKtzL1abw6mzWU=
Date:   Wed, 16 Sep 2020 21:35:37 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH 4.19 28/78] nvme: have nvme_wait_freeze_timeout return if
 it timed out
Message-ID: <20200917013537.GG2431@sasha-vm>
References: <20200915140633.552502750@linuxfoundation.org>
 <20200915140634.986905823@linuxfoundation.org>
 <20200916073427.GB32537@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200916073427.GB32537@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 09:34:27AM +0200, Pavel Machek wrote:
>Hi!
>
>> [ Upstream commit 7cf0d7c0f3c3b0203aaf81c1bc884924d8fdb9bd ]
>>
>> Users can detect if the wait has completed or not and take appropriate
>> actions based on this information (e.g. weather to continue
>> initialization or rather fail and schedule another initialization
>> attempt).
>
>This does not fix any bug and is not needed in 4.19-stable. In the
>5.8-stable there are other patches that depend on that (which is
>probably why it was merged), but those are not present in 4.19.
>
>Please drop.

Right, now dropped. Thanks!

-- 
Thanks,
Sasha
