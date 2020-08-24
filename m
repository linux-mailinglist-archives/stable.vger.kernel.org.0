Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C142501EA
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 18:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgHXQXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 12:23:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbgHXQXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:23:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E1EA2074D;
        Mon, 24 Aug 2020 16:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598286196;
        bh=2E0N7CzzxkyvEYG6ZItoofnSmB0PprRB21tJ4G1jMyY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nFT82NphYzTVcEOtKQ98G+SSTfBVrsQQFYkHka1Pk4t/25FH2NAXwTeu8oftaEh6M
         yjCDHQ9Ag1RPcGKd2eqkSq2RXzZbKckKv+xD8c2BQamaiIHI6EYDKo/blvCjEVaRyv
         1ax3+IlfVN6d5PoyU7gFt+ApaWpL7+CFAdL2ZMr0=
Date:   Mon, 24 Aug 2020 18:23:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH] Revert "drm/amd/display: Improve DisplayPort monitor
 interop"
Message-ID: <20200824162334.GA542203@kroah.com>
References: <20200824161029.2001401-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824161029.2001401-1-alexander.deucher@amd.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 12:10:29PM -0400, Alex Deucher wrote:
> This reverts commit 1adb2ff1f6b170cdbc3925a359c8f39d2215dc20.
> 
> This breaks display wake up in stable kernels (5.7.x and 5.8.x).
> 
> Note that there is no upstream equivalent to this
> revert. This patch was targeted for stable by Sasha's stable
> patch process. Presumably there are some other changes necessary
> for this patch to work properly on stable kernels.
> 
> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1266
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org # 5.7.x, 5.8.x
> Cc: Sasha Levin <sashal@kernel.org>

Now reverted, thanks!

greg k-h
