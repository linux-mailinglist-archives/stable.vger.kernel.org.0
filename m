Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA742156B0E
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 16:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgBIPjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 10:39:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:50646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727514AbgBIPjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 10:39:19 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F05B020733;
        Sun,  9 Feb 2020 15:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581262759;
        bh=GVTdndqy4C6MsKj8E8XKDFysYJL9nHuOLOHelVG/B9c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ABS7j49m4aOHV9uaVnRlSi1lsYHeJXuv31r+ZMoPlybqK7QrTaQTDvvI8MQ15/5K2
         xLZs2tshmZa1rRbI3j2PPqn8oyiI6t7HwPPN/tIITEDiVOF0uOXN3PQmw/aIAktW6q
         nvGwRcPYcRA1F9sX+PASEphcQ3Bw5Na3tDN/Rq7E=
Date:   Sun, 9 Feb 2020 10:39:17 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     trondmy@gmail.com, Anna.Schumaker@Netapp.com, bcodding@redhat.com,
        trond.myklebust@hammerspace.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] NFS: Directory page cache pages need to
 be locked when read" failed to apply to 4.9-stable tree
Message-ID: <20200209153917.GB3584@sasha-vm>
References: <1581247474219231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1581247474219231@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 12:24:34PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.9-stable tree.
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
>From 114de38225d9b300f027e2aec9afbb6e0def154b Mon Sep 17 00:00:00 2001
>From: Trond Myklebust <trondmy@gmail.com>
>Date: Sun, 2 Feb 2020 17:53:54 -0500
>Subject: [PATCH] NFS: Directory page cache pages need to be locked when read
>
>When a NFS directory page cache page is removed from the page cache,
>its contents are freed through a call to nfs_readdir_clear_array().
>To prevent the removal of the page cache entry until after we've
>finished reading it, we must take the page lock.
>
>Fixes: 11de3b11e08c ("NFS: Fix a memory leak in nfs_readdir")
>Cc: stable@vger.kernel.org # v2.6.37+
>Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
>Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
>Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>

I've also grabbed 6089dd0d7310 ("NFS: Fix bool
initialization/comparison") and queued both for 4.9 and 4.4.

-- 
Thanks,
Sasha
