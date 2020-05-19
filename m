Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596C41D94C0
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 12:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgESKxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 06:53:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgESKxd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 06:53:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AC7D206D4;
        Tue, 19 May 2020 10:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589885612;
        bh=caz831zh9zz+Zj57ygMBoHpx7mNwspS/hNdKjQXpDa4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WOGfVmFShUJdf+d1Il5Vw0rbaUx4nHBSCeZktzM4Q+lBY3u9hYvfq5JRtAHRNf3Y7
         McWpUIiuHwwbCif2U32WG+Yetlv2xZ7rdayR1LSCah1gvlsUa4nApF1p5PX1Je93ko
         xZlUEbaWb2XaUFNYmnW1cmoT/PoohF6PNmD6vnKE=
Date:   Tue, 19 May 2020 12:53:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Henri Rosten <henri.rosten@unikie.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, lukas.bulwahn@gmail.com
Subject: Re: [PATCH 4.4 17/86] phy: micrel: Disable auto negotiation on
 startup
Message-ID: <20200519105329.GA120343@kroah.com>
References: <20200518173450.254571947@linuxfoundation.org>
 <20200518173453.976038108@linuxfoundation.org>
 <20200519054510.GA28178@buimax>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519054510.GA28178@buimax>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 19, 2020 at 08:45:12AM +0300, Henri Rosten wrote:
> On Mon, May 18, 2020 at 07:35:48PM +0200, Greg Kroah-Hartman wrote:
> > From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > 
> > [ Upstream commit 99f81afc139c6edd14d77a91ee91685a414a1c66 ]
> 
> I notice 99f81afc139c has been reverted in mainline with commit b43bd72835a5.  
> The revert commit points out that:
> 
> "It was papering over the real problem, which is fixed by commit
> f555f34fdc58 ("net: phy: fix auto-negotiation stall due to unavailable
> interrupt")"
>  
> Therefore, consider backporting f555f34fdc58 instead of 99f81afc139c.
> 
> Notice if f555f34fdc58 is taken, then I believe 215d08a85b9a should also 
> be backported.

I'm just going to drop this single patch for now instead, thanks.

greg k-h
