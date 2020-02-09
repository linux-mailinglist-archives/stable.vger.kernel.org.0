Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 870E3156AF3
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 16:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgBIPLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 10:11:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727682AbgBIPLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 10:11:53 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FD1420733;
        Sun,  9 Feb 2020 15:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581261112;
        bh=FIlmFup55SO8y+55BY+G1BAjC194TWSe0Ksc8TzAEJI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yl8T0TIZfzL/FffeylMkf3j/XcfW3i5Tr8xaF26b2ESYZruS/DbJ/poA0Ak5dFq/1
         qv2lW4xgXKxrJnoPs1aboCsIo6+1i7YSXgDzuScx55jxRfbVo5+w4FnBOxkURp5Q1O
         8cnHH+BDmraBwwnO5m0uXPesbIc5okDQruZd7uwQ=
Date:   Sun, 9 Feb 2020 10:11:51 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     trondmy@gmail.com, Anna.Schumaker@Netapp.com, bcodding@redhat.com,
        trond.myklebust@hammerspace.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] NFS: Fix memory leaks and corruption in
 readdir" failed to apply to 4.9-stable tree
Message-ID: <20200209151151.GA3584@sasha-vm>
References: <158124745033180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158124745033180@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 12:24:10PM +0100, gregkh@linuxfoundation.org wrote:
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
>From 4b310319c6a8ce708f1033d57145e2aa027a883c Mon Sep 17 00:00:00 2001
>From: Trond Myklebust <trondmy@gmail.com>
>Date: Sun, 2 Feb 2020 17:53:53 -0500
>Subject: [PATCH] NFS: Fix memory leaks and corruption in readdir
>
>nfs_readdir_xdr_to_array() must not exit without having initialised
>the array, so that the page cache deletion routines can safely
>call nfs_readdir_clear_array().
>Furthermore, we should ensure that if we exit nfs_readdir_filler()
>with an error, we free up any page contents to prevent a leak
>if we try to fill the page again.
>
>Fixes: 11de3b11e08c ("NFS: Fix a memory leak in nfs_readdir")
>Cc: stable@vger.kernel.org # v2.6.37+
>Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
>Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
>Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>

I also took b044f6451384 ("NFS: switch back to to ->iterate()") and
queued both for 4.9 and 4.4.

-- 
Thanks,
Sasha
