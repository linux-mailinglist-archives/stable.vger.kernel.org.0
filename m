Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D04E18F9AA
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 17:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbgCWQ0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 12:26:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727277AbgCWQ0w (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 23 Mar 2020 12:26:52 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66E682051A;
        Mon, 23 Mar 2020 16:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584980811;
        bh=Zt+GP+fB4DxIasM1J/YBiGj3qmXCaJrony+aB1nGWw4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0gEpxXi8Wh5JtpxoY6ByouSX0sASWc5xU2jf0qe5uPvePZo53rbRfI8q26gWYL1mT
         rgCuLDxD2N0zEHWw7eEFnda3XVYGPnjFE6OZyCqlXk1HxSSq+bQAeAtCX7p6Wk+TCq
         aie4Sv9G+T4deJ+LPNdM0FV3MPMtPKk1/XYMpbwM=
Date:   Mon, 23 Mar 2020 12:26:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     tomas@novotny.cz, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, agx@sigxcpu.org
Subject: Re: FAILED: patch "[PATCH] iio: light: vcnl4000: update sampling
 periods for vcnl4200" failed to apply to 4.19-stable tree
Message-ID: <20200323162650.GV4189@sasha-vm>
References: <1584973105253103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1584973105253103@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 23, 2020 at 03:18:25PM +0100, gregkh@linuxfoundation.org wrote:
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
>From b42aa97ed5f1169cfd37175ef388ea62ff2dcf43 Mon Sep 17 00:00:00 2001
>From: Tomas Novotny <tomas@novotny.cz>
>Date: Tue, 18 Feb 2020 16:44:50 +0100
>Subject: [PATCH] iio: light: vcnl4000: update sampling periods for vcnl4200
>MIME-Version: 1.0
>Content-Type: text/plain; charset=UTF-8
>Content-Transfer-Encoding: 8bit
>
>Vishay has published a new version of "Designing the VCNL4200 Into an
>Application" application note in October 2019. The new version specifies
>that there is +-20% of part to part tolerance. This explains the drift
>seen during experiments. The proximity pulse width is also changed from
>32us to 30us. According to the support, the tolerance also applies to
>ambient light.
>
>So update the sampling periods. As the reading is blocking, current
>users may notice slightly longer response time.
>
>Fixes: be38866fbb97 ("iio: vcnl4000: add support for VCNL4200")
>Reviewed-by: Guido Günther <agx@sigxcpu.org>
>Signed-off-by: Tomas Novotny <tomas@novotny.cz>
>Cc: <Stable@vger.kernel.org>
>Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

The conflict is because we don't have 5a441aade5b3 ("iio: light:
vcnl4000 add support for the VCNL4040 proximity and light sensor") on
4.19. I've adjusted context and queued it up.

-- 
Thanks,
Sasha
