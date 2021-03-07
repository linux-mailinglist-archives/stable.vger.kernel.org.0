Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF54330272
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 16:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhCGPGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 10:06:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhCGPGC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 10:06:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23BEE650F7;
        Sun,  7 Mar 2021 15:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615129562;
        bh=N+mSojTnpTgrPQ3DMGo8wjzEXA31bXRzLtywdLaVoLw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WLnpSuFuHA4e9FWw9PEC+CUaB0cJuneG7OMP5+h7M76BfunpMaNbxeG9Zt9Kpox6z
         Y9H8hUdx4cZKDOjfjz6gH/qZjf0Uoufw98KVhWsCS8eT+sqwRRgzoJcTQP0B6YCkNU
         LV/5KlsSaiO0c350wKlEgriRhaRXqOoZ1kw+/0tw=
Date:   Sun, 7 Mar 2021 16:06:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org, snitzer@redhat.com
Subject: Re: [PATCH 5.4.y 3/4] dm table: fix DAX iterate_devices based device
 capability checks
Message-ID: <YETr2MwFMtHqymM3@kroah.com>
References: <161460625264244@kroah.com>
 <20210305065722.73504-1-jefflexu@linux.alibaba.com>
 <20210305065722.73504-4-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305065722.73504-4-jefflexu@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 02:57:21PM +0800, Jeffle Xu wrote:
> commit 57ba3e506c30a84b1ba1dd77ddd9f2be9d472e98 upstream.

There is no such git id "upstream" :(

Please fix up all of these series with the needed information on the
non-upstream patch, and make sure you have the correct git commit ids on
your patches.

thanks,

greg k-h
