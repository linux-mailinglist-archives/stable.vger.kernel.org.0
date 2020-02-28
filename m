Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59032174075
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 20:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgB1To5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 14:44:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:58614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgB1To5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 14:44:57 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C147246B7;
        Fri, 28 Feb 2020 19:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582919096;
        bh=QGVjRtSvQfqJWUvi3mpt+fAVQFXPjfcS6Z8kvcvqNnY=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:
         References:From;
        b=FZST07ci0AfaSyoJ4bvOQT69mGMSjeuKI48DzIZB2Ho7Y0MWs5o50ZdAJjMvGUHeK
         YO5FSpnSwGk3zeE/mce77nm5/awWwG9ro49Fqtd2xZyGJCxG8qSJYgCpa2DB769tW4
         3U3eYRvebQCS9NWrCpuuVzApF29f/1JnNYQ+6qDg=
Date:   Fri, 28 Feb 2020 19:44:55 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] loop: avoid EAGAIN, if offset or block_size are changed
In-Reply-To: <20200228043820.169288-1-jaegeuk@kernel.org>
References: <20200228043820.169288-1-jaegeuk@kernel.org>
Message-Id: <20200228194456.8C147246B7@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 5db470e229e2 ("loop: drop caches if offset or block_size are changed").

The bot has tested the following trees: v5.5.6, v5.4.22, v4.19.106, v4.14.171.

v5.5.6: Build OK!
v5.4.22: Build OK!
v4.19.106: Build OK!
v4.14.171: Failed to apply! Possible dependencies:
    3148ffbdb916 ("loop: use killable lock in ioctls")
    550df5fdacff ("loop: Push loop_ctl_mutex down to loop_set_status()")
    757ecf40b7e0 ("loop: Push loop_ctl_mutex down to loop_set_fd()")
    85b0a54a82e4 ("loop: Move loop_reread_partitions() out of loop_ctl_mutex")
    a13165441d58 ("loop: Push lo_ctl_mutex down into individual ioctls")
    c371077000f4 ("loop: Push loop_ctl_mutex down to loop_change_fd()")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
