Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7E701169F2
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 10:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfLIJrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 04:47:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbfLIJrI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 04:47:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24C1520726;
        Mon,  9 Dec 2019 09:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575884827;
        bh=cFW2Px5ltAq0uvXZUr3YCm89N0WrwOLR4cp0l+4zZQc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cPnosmSY5wY2zdio5j/eMnegevHOLz/e2yRCsU5Yizr3WB1ER6vm3D4rxHsVR9Oa5
         RK79NcoMNtijWDY2M6R+mS2Aa31KIPIDl5mt9W+Ihznp6NFjY06aEiveS695WmFu9y
         FEgfpV4hFPCpugeyU248bqUhHUrhm2buZ5x7DJkI=
Date:   Mon, 9 Dec 2019 10:47:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     stable@vger.kernel.org, Trond Myklebust <trondmy@hammerspace.com>,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: stable request: 5.4.y: SUNRPC: Avoid RPC delays when exiting
 suspend
Message-ID: <20191209094705.GC932866@kroah.com>
References: <370ef599-8164-170c-8ba0-f8a9082578c4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <370ef599-8164-170c-8ba0-f8a9082578c4@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 09, 2019 at 08:46:24AM +0000, Jon Hunter wrote:
> Hi Greg,
> 
> Please can you include the following for 5.4.y. This fixes long delays
> exiting suspend when using NFS and was causing one of our suspend tests
> to fail.
> 
> commit 66eb3add452aa1be65ad536da99fac4b8f620b74
> Author: Trond Myklebust <trond.myklebust@hammerspace.com>
> Date:   Tue Nov 5 09:10:54 2019 -0500
> 
>     SUNRPC: Avoid RPC delays when exiting suspend

Now queued up, thanks!

greg k-h
