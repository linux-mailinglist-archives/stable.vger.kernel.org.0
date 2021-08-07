Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7120A3E3410
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 10:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbhHGIV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Aug 2021 04:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229636AbhHGIV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Aug 2021 04:21:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC61C60F14;
        Sat,  7 Aug 2021 08:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628324470;
        bh=ovbC15Az+Wo/7HGwNTt6ory4JqD2E5Iq6p1PUYzMeFc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qg+MsoRFdcgJR6B0xMQD/ADFxRMdz7XObH3MINhKHwnbJHhRfGTHBHLwneGSJfVF9
         0AuQXst3d48zocMo/a3YeO8Fn9+ISwTDkAieznC/Y8xf+XF5kAmLcV1EXVNZJX5qis
         fHY2MvPmFWuepbrk+vkmzwNdHzOAT4Cz/SVPRMd0=
Date:   Sat, 7 Aug 2021 10:20:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Hess <peter.hess@ph-home.de>,
        Frank Wunderlich <frank-w@public-files.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.13 32/35] Revert "spi: mediatek: fix fifo rx mode"
Message-ID: <YQ5Ca/SouyQy9sSB@kroah.com>
References: <20210806081113.718626745@linuxfoundation.org>
 <20210806081114.781183194@linuxfoundation.org>
 <1be93ec0-43cd-f86b-aeb8-64971b4fcedd@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1be93ec0-43cd-f86b-aeb8-64971b4fcedd@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 06, 2021 at 11:54:08AM -0700, Guenter Roeck wrote:
> On 8/6/21 1:17 AM, Greg Kroah-Hartman wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This reverts commit 09b8cc7810587257e5f82080884001301e1a1ba9 which is
> > commit 3a70dd2d050331ee4cf5ad9d5c0a32d83ead9a43 upstream.
> > 
> > It has been found to have problems.
> > 
> > Reported-by: Guenter Roeck <linux@roeck-us.net>
> > Cc: Peter Hess <peter.hess@ph-home.de>
> > Cc: Frank Wunderlich <frank-w@public-files.de>
> > Cc: Mark Brown <broonie@kernel.org>
> > Cc: Sasha Levin <sashal@kernel.org>
> > Link: https://lore.kernel.org/r/efee3a58-a4d2-af22-0931-e81b877ab539@roeck-us.net
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> The problem with the reverted patch has now been fixed in the mainline
> kernel with commit 0d5c3954b35e ("spi: mediatek: Fix fifo transfer").
> So an alternative to this revert might be to apply commit 0d5c3954b35e
> instead.

Good idea, I'll go drop this revert and add that change instead.

thanks,

greg k-h
