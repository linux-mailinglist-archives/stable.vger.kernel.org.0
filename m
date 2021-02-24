Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D79324319
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 18:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbhBXRVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 12:21:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234704AbhBXRVy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 12:21:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5374964F0B;
        Wed, 24 Feb 2021 17:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614187273;
        bh=NXWjf57sYNaJSH0gZdTTslFvP5uVci8Rc5jXJAkjRs4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zlwI5GC2fLOTHSSRoe1bJsYgI8Q9JzQkdp8/5xcXYGhpoS3b9pz5TGeTixj2eDkJD
         V897p0S4FZir+EX0eh3FzZmWFVTFh1dV840l96hCsItJd7rmBr6GaFlPnF5zLq+qWe
         +UnR1+rMXNsObsDavJAnb6Oc3+FFXxE42sh0pMzU=
Date:   Wed, 24 Feb 2021 18:21:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SeongJae Park <sjpark@amazon.com>
Cc:     sashal@kernel.org, aams@amazon.com, markubo@amazon.com,
        linux-kernel@vger.kernel.org,
        "# 4 . 4 . y" <stable@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: Please apply "xen-netback: delete NAPI instance when queue fails
 to initialize" to v4.4.y
Message-ID: <YDaLBcj5DJrSWXqU@kroah.com>
References: <20210224170356.20697-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224170356.20697-1-sjpark@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 06:03:56PM +0100, SeongJae Park wrote:
> This is a request for merge of upstream commit 4a658527271b ("xen-netback:
> delete NAPI instance when queue fails to initialize") on v4.4.y tree.
> 
> If 'xenvif_connect()' fails after successful 'netif_napi_add()', the napi is
> not cleaned up.  Because 'create_queues()' frees the queues in its error
> handling code, if the 'xenvif_free()' is called for the vif, use-after-free
> occurs. The upstream commit fixes the problem by cleaning up the napi in the
> 'xenvif_connect()'.
> 
> Attaching the original patch below for your convenience.

The original patch does not apply cleanly.

> Tested-by: Markus Boehme <markubo@amazon.de>

What was tested?

I backported the patch, but next time, please provide the patch that
will work properly.

greg k-h
