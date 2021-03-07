Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03256330283
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 16:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhCGPRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 10:17:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:58376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229861AbhCGPQf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 10:16:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FC1D64F33;
        Sun,  7 Mar 2021 15:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615130195;
        bh=E0kcVGt+CtSElqjiHwp/AhkKaSpv9Ph6OObUmdsb/3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XK46dUvRIgPsvacI6YpgE2h2AKr9opaFAfS83svhYUkLqP4DU2AIttgR+W21C/xI0
         Z9b1Q040+unE/tvwGXsyuqMDWqCd9ro4wASnu6GBD0H1omIYYNVa8KbE327DrMgbWA
         Umnw9/Y+7hnAApdgodoyHNLyuEtpJIT/P2cHU20s=
Date:   Sun, 7 Mar 2021 16:16:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        joseph.qi@linux.alibaba.com, hare@suse.com
Subject: Re: [PATCH v2 4.19 0/6] close udev startup race condition for
 several devices
Message-ID: <YETuUSg8d5C+C8jD@kroah.com>
References: <20210223092859.17033-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223092859.17033-1-jefflexu@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 05:28:53PM +0800, Jeffle Xu wrote:
> Please refer to v1 ([1]) and background ([2]) for more details.
> 
> As Sasha suggested in [3], revert commit 9e07f4e24379 ("zram: close udev
> startup race condition as default groups") first, and then apply the
> original patch set.
> 
> - patch 5: fix the issue of zram that the original commit (9e07f4e24379)
> wants to fix
> - patch 6: fix the issue of virtio-blk ([2])
> - patch 3/4: I have not occured with these two issues in real world. Put
>   here just for completeness.
> 
> This patch set is for 4.19, though it shall be backported to
> 4.4/4.9/4.14/4.19. Send this patch set out first for more feedbacks.
> 
> I have only tested the issue of virtio-blk though.

Look sane enough for me, now queued up, thanks.

greg k-h
