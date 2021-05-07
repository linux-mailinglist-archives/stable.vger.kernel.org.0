Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34C43767D9
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 17:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235020AbhEGPXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 11:23:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231540AbhEGPXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 May 2021 11:23:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F9186101D;
        Fri,  7 May 2021 15:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620400971;
        bh=GNYZlX93nR3daRU3fjDF1R/Wh3E7aFbR5wq9RLjTi2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ssu6t1wD23dmb6HzbxS0jXCRdEAOinBpiM86kRTsd8lQVe710LwNLIUyO04SKuThv
         Gez7iqD1g0OXMxkc2OtIJmRgp/we7YGvJsTHM5EE366BcR1MNBPKjRLzNGd9zMp8Mo
         c6SK6aiNhNRSGYuP3pKaheIL30JX3EUnBkeXQSgQ=
Date:   Fri, 7 May 2021 17:22:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH 4.19.y] erofs: add unsupported inode i_format check
Message-ID: <YJVbSVst+EPg2oDL@kroah.com>
References: <162039576612327@kroah.com>
 <20210507151545.235017-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210507151545.235017-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 07, 2021 at 11:15:45PM +0800, Gao Xiang wrote:
> From: Gao Xiang <xiang@kernel.org>
> 
> commit 24a806d849c0b0c1d0cd6a6b93ba4ae4c0ec9f08 upstream.
> 
> If any unknown i_format fields are set (may be of some new incompat
> inode features), mark such inode as unsupported.
> 
> Just in case of any new incompat i_format fields added in the future.
> 
> Fixes: 431339ba9042 ("staging: erofs: add inode operations")
> Cc: <stable@vger.kernel.org> # 4.19+
> [ Gao Xiang: Manually backport to 4.19.y due to trivial conflicts. ]
> Signed-off-by: Gao Xiang <xiang@kernel.org>
> ---
> Hi Greg,
> 
> Please consider this backport patch for 4.19 staging erofs.
> (btw, I use xiang@kernel.org instead of @redhat.com here since
>  I'll shift to Alibaba in weeks...)


Thanks for this, now queued up!

greg k-h
