Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2522DBDD6
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 10:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgLPJoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 04:44:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgLPJoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Dec 2020 04:44:20 -0500
Date:   Wed, 16 Dec 2020 10:44:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608111820;
        bh=660qYIfVRVWxXtwPu2TkAHoXad8Rf9XKFmlXmuCsho8=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=0tnZWtFCpBAZLTEQ9XwwxzAXFAreJS5H6KHnaGfzmhomc8gHAfsQ41HtoFWNDKcnr
         taR3qJMEhF64ppdPOM9kWon8p0FTMUVUD5LGyT/ZuHZ1pyqYyRRmXZbB1H8BvpnnYz
         w/TQd5m0fj+7wDROirot6+xXkNCVYukozOvNqvws=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chao Yu <yuchao0@huawei.com>
Cc:     jaegeuk@kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, chao@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] f2fs: fix out-of-repair __setattr_copy()
Message-ID: <X9nXCdp1ssMHKdNI@kroah.com>
References: <20201216091523.21411-1-yuchao0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216091523.21411-1-yuchao0@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 16, 2020 at 05:15:23PM +0800, Chao Yu wrote:
> __setattr_copy() was copied from setattr_copy() in fs/attr.c, there is
> two missing patches doesn't cover this inner function, fix it.
> 
> Commit 7fa294c8991c ("userns: Allow chown and setgid preservation")
> Commit 23adbe12ef7d ("fs,userns: Change inode_capable to capable_wrt_inode_uidgid")

Are these lines supposed to be "Fixes:" instead of "Commit "?

thanks,

greg k-h
