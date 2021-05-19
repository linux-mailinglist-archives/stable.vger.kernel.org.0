Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71543388367
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 02:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhESAGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 20:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232153AbhESAGE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 May 2021 20:06:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B5096135D;
        Wed, 19 May 2021 00:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621382686;
        bh=fDRMp6la+ZcO5o042pAO9F4TsB3TBtyXZEm5oCc5P38=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bvqEZnImrNrt7AR9pV3HbJHdRQsLGs6+rH6LJTWkf5DaLd0DaX1l5uEZJPHve1jc1
         1h8wF5O5OgHG4WZpNi+41Tg5skdzyFIBm6xoYHfbYtRc1RZih+WCgWlc6AiGQI9oQT
         KqR4ihgH/nGqbSM0IFGIvrEJGBfZrnckNX6I5BVKx3371+I4iK7pozq8Sd3OLTi8Gk
         gzye1FR3mDmlQcV2UTRPMHWaGhT07WNwNv9MbN9b/FG5YxmHS2hwWBOg/7+Z628p3e
         GtIORMGaG9WQRiGHDq8PQFHM65YTNf3gau6fAJtO86/3leP/YEq9baAH9ibdj+fbm+
         dD5GIv4WQqt2g==
Date:   Tue, 18 May 2021 20:04:45 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.4 042/111] virtio_net: Do not pull payload in skb->head
Message-ID: <YKRWHYiN1zXWHrfj@sashalap>
References: <20210412084004.200986670@linuxfoundation.org>
 <20210412084005.653952525@linuxfoundation.org>
 <20210412051230-mutt-send-email-mst@kernel.org>
 <CANn89iJ+5qFw+sPmxBqzxd6rp=3fnc8xkbup7SWWa_LxyhUUrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CANn89iJ+5qFw+sPmxBqzxd6rp=3fnc8xkbup7SWWa_LxyhUUrg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 18, 2021 at 09:35:26PM +0200, Eric Dumazet wrote:
>On Mon, Apr 12, 2021 at 11:12 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>> Note that an issue related to this patch was recently reported.
>> It's quite possible that the root cause is a bug elsewhere
>> in the kernel, but it probably makes sense to defer the backport
>> until we know more ...
>
>I think the patch should be backported now, all issues have been sorted out ?

This is just 38ec4944b593 ("gro: ensure frag0 meets IP header
alignment"), right? I can queue both for the next round of releases.

-- 
Thanks,
Sasha
