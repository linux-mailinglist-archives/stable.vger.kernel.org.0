Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B72B1A3F0
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 22:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbfEJUS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 16:18:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727911AbfEJUS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 May 2019 16:18:57 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2F2D217F5;
        Fri, 10 May 2019 20:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557519537;
        bh=Q/hdExccvJjNzjv6Qv8a4/VCle6IDL5htrBTYUcGjr4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bVft6V5xugEbJpoW4Q5HmHOuZ+5Bl20NunFrAETP+6/Gj1j2JnlCiJJ7vq2LrEZ1z
         52yK21jmbI8xcqT322Bd7bhDPrdTkPcmcS9YHUWelrbXW2IKH+n7xJOwsS7pOgD9KD
         KQ+dDTlBXkBPrgEOuUY0ytOTJ28RmK7yiowTK/aw=
Date:   Fri, 10 May 2019 16:18:55 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Wheeler <stable@lists.ewheeler.net>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        "open list:BFQ I/O SCHEDULER" <linux-block@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Eric Wheeler <bfq@linux.ewheeler.net>, stable@vger.kernel.org
Subject: Re: [PATCH] bfq: backport: update internal depth state when queue
 depth changes
Message-ID: <20190510201855.GB14410@sasha-vm>
References: <1557510992-18506-1-git-send-email-stable@lists.ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1557510992-18506-1-git-send-email-stable@lists.ewheeler.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 10, 2019 at 10:56:32AM -0700, Eric Wheeler wrote:
>From: Jens Axboe <axboe@kernel.dk>
>
>commit 77f1e0a52d26242b6c2dba019f6ebebfb9ff701e upstream
>
>A previous commit moved the shallow depth and BFQ depth map calculations
>to be done at init time, moving it outside of the hotter IO path. This
>potentially causes hangs if the users changes the depth of the scheduler
>map, by writing to the 'nr_requests' sysfs file for that device.
>
>Add a blk-mq-sched hook that allows blk-mq to inform the scheduler if
>the depth changes, so that the scheduler can update its internal state.
>
>Signed-off-by: Eric Wheeler <bfq@linux.ewheeler.net>
>Tested-by: Kai Krakow <kai@kaishome.de>
>Reported-by: Paolo Valente <paolo.valente@linaro.org>
>Fixes: f0635b8a416e ("bfq: calculate shallow depths at init time")
>Signed-off-by: Jens Axboe <axboe@kernel.dk>
>Cc: stable@vger.kernel.org

I wasn't clear on what was backported here, so I've queued the upstream
version on 4.19 and 4.14, it doesn't seem to be relevant to older
branches.

--
Thanks,
Sasha
