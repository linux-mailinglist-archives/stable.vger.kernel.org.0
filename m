Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54AC1CF76D
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 16:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbgELOi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 10:38:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728101AbgELOi5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 10:38:57 -0400
Received: from localhost (unknown [73.114.22.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CD33206A3;
        Tue, 12 May 2020 14:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589294337;
        bh=TJ5cQZ2Xno+I4G+cOEG7/S+lEJchHpPM1EYX/2qrA5E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WwIFO6PCiSo70pK0Pr8GRXg6abANXk1K1170+Czoe8N4GGspMlojQLjHALiIsSdAY
         KbQlvdSowPwWwDD1qqmTzFyUUc4k8MP6gL5rcX1k3Vb3W26FZ5U5ZCJZwY2eb5FcVN
         25U7v+Hmsd/JKzqAP5VtVuuBhf07UgG/M7onBTbc=
Date:   Tue, 12 May 2020 10:38:51 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     hch@lst.de, axboe@kernel.dk, bvanassche@acm.org, jack@suse.cz,
        yuyufen@huawei.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] bdi: add a ->dev_name field to struct
 backing_dev_info" failed to apply to 5.6-stable tree
Message-ID: <20200512143851.GQ13035@sasha-vm>
References: <158928427224231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158928427224231@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 12, 2020 at 01:51:12PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.6-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 6bd87eec23cbc9ed222bed0f5b5b02bf300e9a8d Mon Sep 17 00:00:00 2001
>From: Christoph Hellwig <hch@lst.de>
>Date: Mon, 4 May 2020 14:47:56 +0200
>Subject: [PATCH] bdi: add a ->dev_name field to struct backing_dev_info
>
>Cache a copy of the name for the life time of the backing_dev_info
>structure so that we can reference it even after unregistering.
>
>Fixes: 68f23b89067f ("memcg: fix a crash in wb_workfn when a device disappears")
>Reported-by: Yufen Yu <yuyufen@huawei.com>
>Signed-off-by: Christoph Hellwig <hch@lst.de>
>Reviewed-by: Jan Kara <jack@suse.cz>
>Reviewed-by: Bart Van Assche <bvanassche@acm.org>
>Signed-off-by: Jens Axboe <axboe@kernel.dk>

I've also grabbed eb7ae5e06bb6 ("bdi: move bdi_dev_name out of line") as
a dependency and queued both for 5.6 and 5.4.

-- 
Thanks,
Sasha
