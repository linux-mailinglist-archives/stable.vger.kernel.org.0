Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5361E4982B3
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 15:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiAXOu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 09:50:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34544 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiAXOu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 09:50:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8033761374
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 14:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB56C340E1;
        Mon, 24 Jan 2022 14:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643035857;
        bh=P9/wIfIv98yubVDOre03EOxJp6lWYastXmJnZCPkLXo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mrs4Cex7DTzkyXOmHs83d06leDkM2lzpiKjg7mVsbyDjW0+k3UKIcKOMwmzs6sxr8
         P60p9SIP+0qARWUku1rz0aR75ea8Jw/rRaYsH/+rqrUIIyr2CeYBYFqbyYZeTiabxr
         l8tc49pWHxCgDBDYi2STGYrwRog0dK/CR8MoggDI=
Date:   Mon, 24 Jan 2022 15:50:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     ranjani.sridharan@linux.intel.com, bard.liao@intel.com,
        broonie@kernel.org, kai.vehmanen@linux.intel.com,
        paul.olaru@oss.nxp.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ASoC: SOF: handle paused streams during
 system suspend" failed to apply to 5.16-stable tree
Message-ID: <Ye68zj5vYsmbALKz@kroah.com>
References: <1643032809235135@kroah.com>
 <45de02b3-031a-35f2-eedd-b87f3a8f19af@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45de02b3-031a-35f2-eedd-b87f3a8f19af@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 08:37:33AM -0600, Pierre-Louis Bossart wrote:
> 
> 
> On 1/24/22 08:00, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.16-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> This is a bit of a corner case, most users don't use pause and
> suspending while paused is not well handled in general.
> 
> This problem was detected by our CI test suite and fixed for
> consistency, but it's not clear to me that this should land in -stable.
> 
> If there was any consensus that this is needed, the following sequence
> works for me:
> 
> git cherry-pick 7cc7b9ba21d4978d19f0e3edc2b00d44c9d66ff6
> git cherry-pick b2ebcf42a48f4560862bb811f3268767d17ebdcd
> git cherry-pick 01429183f479c54c1b5d15453a8ce574ea43e525
> 
> and then this commit
> 
> git cherry-pick 96da174024b9c63bd5d3358668d0bc12677be877

That works, thanks!

greg k-h
