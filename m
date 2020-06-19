Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8452000FA
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 06:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbgFSEKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 00:10:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725290AbgFSEKt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 00:10:49 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 237632080D;
        Fri, 19 Jun 2020 04:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592539849;
        bh=0xCIv9ldYJmcqYbLnwQm+aTw1nwjw6QXRudKFQENLZM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jbta6Yd8auMbF+mVjPI/ZGZutS4VhNtzWq+N0bBw+5EmxKahszzM7tMwzMFLo/qY0
         WWUSYKcfWkQvLX1rCWEP+dPnzONEt+TGyQ7ODkDErDA7kT0uIxZpnPW9cZMd5hLglc
         Ov3bYxoT1F6hdrHTNbVtGT39mSs13jfClZf2yPxg=
Date:   Fri, 19 Jun 2020 00:10:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Giuliano Procida <gprocida@google.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] blk-mq: move blk_mq_update_nr_hw_queues synchronize_rcu
 call
Message-ID: <20200619041048.GW1931@sasha-vm>
References: <20200618183022.212135-1-gprocida@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200618183022.212135-1-gprocida@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 18, 2020 at 07:30:22PM +0100, Giuliano Procida wrote:
>This fixes the
>4.9 backport commit f530afb974c2e82047bd6220303a2dbe30eff304
>which was
>upstream commit f5bbbbe4d63577026f908a809f22f5fd5a90ea1f.
>
>The upstream commit added a call to synchronize_rcu to
>_blk_mq_update_nr_hw_queues, just after freezing queues.
>
>In the backport this landed (in blk_mq_update_nr_hw_queues instead),
>just after unfreezeing queues.
>
>This commit moves the call to its intended place.
>
>Fixes: f530afb974c2 ("blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter")
>Signed-off-by: Giuliano Procida <gprocida@google.com>

Good catch! I've queued this and the 4.14 version.

-- 
Thanks,
Sasha
