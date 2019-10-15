Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA8D2D6D7A
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 05:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfJODOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 23:14:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726946AbfJODOc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 23:14:32 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C22ED2086A;
        Tue, 15 Oct 2019 03:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571109272;
        bh=T7i2sJUZQvp4pkRp1Fm+oeg1rP1aV+0ePdU+cOMNUFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fhrNjklw4PXJ4yXGxh/urFaguCynubHdm5m18o1TDq+Sl7CkcgctGoSH2Mpr4nbf8
         TedGm5tRS6HwBVvahyx7RIx0FlEtSeWnfjPmoiG0uvt254w0Bpjyi1Cs48+6OzfL/A
         04+KsspOBL2O31kay6CDW0BZR3+AQPifcpxKpF1M=
Date:   Mon, 14 Oct 2019 23:14:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     piastryyy@gmail.com, pshilov@microsoft.com, stable@vger.kernel.org,
        stfrench@microsoft.com
Subject: Re: FAILED: patch "[PATCH] CIFS: Force revalidate inode when dentry
 is stale" failed to apply to 4.4-stable tree
Message-ID: <20191015031430.GK31224@sasha-vm>
References: <1571069849229168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1571069849229168@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 06:17:29PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.4-stable tree.
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
>From c82e5ac7fe3570a269c0929bf7899f62048e7dbc Mon Sep 17 00:00:00 2001
>From: Pavel Shilovsky <piastryyy@gmail.com>
>Date: Mon, 30 Sep 2019 10:06:19 -0700
>Subject: [PATCH] CIFS: Force revalidate inode when dentry is stale
>
>Currently the client indicates that a dentry is stale when inode
>numbers or type types between a local inode and a remote file
>don't match. If this is the case attributes is not being copied
>from remote to local, so, it is already known that the local copy
>has stale metadata. That's why the inode needs to be marked for
>revalidation in order to tell the VFS to lookup the dentry again
>before openning a file. This prevents unexpected stale errors
>to be returned to the user space when openning a file.
>
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
>Signed-off-by: Steve French <stfrench@microsoft.com>

I also took a108471b5730b ("cifs: Check uniqueid for SMB2+ and return
-ESTALE if necessary") and queued both for 4.4.

-- 
Thanks,
Sasha
