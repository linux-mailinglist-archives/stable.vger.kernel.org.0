Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35DB810A8B7
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 03:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfK0CYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 21:24:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfK0CYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Nov 2019 21:24:01 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B8282071A;
        Wed, 27 Nov 2019 02:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574821440;
        bh=0KtpCZwN9/N90i4n0TvIBMqMpfLx7HWKsSDtBSt3bMw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FwqrP+LFVD+GNvqkE3y3Yg3buvuQ3UBbnlWCQnbpquTPfyQAsSR/ILEuWTE1j0PqF
         Mc2JrudBIQqrtaT2pMg9f0BrW/y0nzM0dyX5D1wXFlHNgelwNs5OdjU32Mp1vk8mNr
         Q4GwCzv79gnB/VFp3JM++rLVwyGHPMxRKfhV/7Fo=
Date:   Tue, 26 Nov 2019 21:23:59 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     wei.w.wang@intel.com, david@redhat.com, mst@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] virtio_balloon: fix shrinker count"
 failed to apply to 4.19-stable tree
Message-ID: <20191127022359.GN5861@sasha-vm>
References: <1574703882140153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1574703882140153@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 25, 2019 at 06:44:42PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
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
>From c9a6820fc0da2603be3054ee7590eb9f350508a7 Mon Sep 17 00:00:00 2001
>From: Wei Wang <wei.w.wang@intel.com>
>Date: Tue, 19 Nov 2019 05:02:33 -0500
>Subject: [PATCH] virtio_balloon: fix shrinker count
>
>Instead of multiplying by page order, virtio balloon divided by page
>order. The result is that it can return 0 if there are a bit less
>than MAX_ORDER - 1 pages in use, and then shrinker scan won't be called.
>
>Cc: stable@vger.kernel.org
>Fixes: 71994620bb25 ("virtio_balloon: replace oom notifier with shrinker")
>Signed-off-by: Wei Wang <wei.w.wang@intel.com>
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>Reviewed-by: David Hildenbrand <david@redhat.com>

I think that the fixes tag should be pointing to 86a559787e6f
("virtio-balloon: VIRTIO_BALLOON_F_FREE_PAGE_HINT"), and this commit
isn't needed on 4.19.

-- 
Thanks,
Sasha
