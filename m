Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68ABB1744A8
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 04:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgB2DIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 22:08:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgB2DIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 22:08:40 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF6C92467B;
        Sat, 29 Feb 2020 03:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582945720;
        bh=hOyEpxPRQGrilqK673TIYfny8ywUcM8JlVlW3ODrXDY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wHfvRTUkcmnmEdSeEYFMkUvL5GfRYvFCdgi5Lh1HBXY6YzspfFScWxMmhJ+G8yqfb
         AjC5U41ZNOXq+ctIYim6cvFTRrAOGBWire96+9p84G8tRtl5jx+ZOCCaiE4jGS+wfq
         jyF4AADlIW1N5dMCFLT4wInT7c4tsV8D1a8X1KMY=
Date:   Fri, 28 Feb 2020 22:08:38 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        joe@perches.com, tglx@linutronix.de, Marc Zyngier <maz@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Request to backport "irqchip/gic-v3-its: Fix misuse of GENMASK
 macro"
Message-ID: <20200229030838.GE21491@sasha-vm>
References: <47617046-53ba-ed7f-ccbb-5c7c09426552@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <47617046-53ba-ed7f-ccbb-5c7c09426552@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 28, 2020 at 02:50:51PM +0800, Zenghui Yu wrote:
>Hi Greg, Sasha,
>
>Could you please help to backport the upstream commit
>20faba848752901de23a4d45a1174d64d2069dde ("irqchip/gic-v3-its: Fix
>misuse of GENMASK macro") to the stable linux-4.19 tree since it's
>definitely a fix for 4.19. Note that it's not needed for other stable
>trees.
>
>I've tried and it can be applied to 4.19.106 cleanly.

Queued up, thanks!

-- 
Thanks,
Sasha
