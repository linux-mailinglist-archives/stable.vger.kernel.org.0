Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D6D4570B3
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 15:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbhKSOfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 09:35:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235496AbhKSOfO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 09:35:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3724D60E9B;
        Fri, 19 Nov 2021 14:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637332332;
        bh=yUg6uusctDcpqio8WO8+Ta1t51wRhsvr0JUIvCOEwoo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IUrOH1h6NwgrmJTwCvIokUWzSORI6tg7ShvXJcbfMVcfOZrrtVEoccFgeiwvXt8Wt
         gx+i2CgATLQbvr7YqeyF889gRTkSzHbp5sPUt9Hoz/ZDuoF3J4GZ9rBA8kLti0u6uz
         UtiBZYtr3n6qRcy2r4FKCS2VMkLnXns/aqVBFAbk=
Date:   Fri, 19 Nov 2021 15:32:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
Cc:     Stable <stable@vger.kernel.org>
Subject: Re: [PATCH]: thermal: Fix NULL pointer,dereferences in of_thermal_
 functions
Message-ID: <YZe1avDl1jp5G1Tf@kroah.com>
References: <9ccc6a1e-d4f5-5762-b9cc-74699e92913d@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ccc6a1e-d4f5-5762-b9cc-74699e92913d@quicinc.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 03:20:34PM -0800, Subbaraman Narayanamurthy wrote:
> Hi,
> This patch was sent originally in [1]. I can see it being picked up in 5.16-rc1 [2] now. Can this be applied to 5.10.x and 5.15.x trees please?
> 
> Commit id: 96cfe05051fd8543cdedd6807ec59a0e6c409195 <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/thermal/thermal_of.c?h=v5.16-rc1&id=96cfe05051fd8543cdedd6807ec59a0e6c409195>
> Reason: To avoid a null pointer de-reference when a thermal sensor device supplying a thermal zone device doesn't probe or probe later when an userspace entity can attempt to set trip thresholds.
> Kernel versions to be applied: 5.10.x, 5.15.x
> 
> Thanks,
> Subbaraman
> 
> [1] https://lore.kernel.org/linux-pm/1636070227-15909-1-git-send-email-quic_subbaram@quicinc.com/.
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/thermal/thermal_of.c?h=v5.16-rc1&id=96cfe05051fd8543cdedd6807ec59a0e6c409195

Now queued up, thanks.

greg k-h
