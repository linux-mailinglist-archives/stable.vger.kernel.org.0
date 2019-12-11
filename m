Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1244D11AD5C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 15:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbfLKOYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 09:24:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbfLKOYv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 09:24:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0842E20836;
        Wed, 11 Dec 2019 14:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576074290;
        bh=XHM1YLU18k2Ro9dHf3Nl8j96QWNwPbTEvr4jxMBnPJM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JpR3s/YG3yLJY6mr17EJiMcqXychSPnXbPBv+6tU5rXLz+MKNAk+KddQ7qdtqccgL
         nhoIJyBm/lGEzIGvDTYMcmMGvMLUYZ2Uz+2z2Qt04xahDcgh1wev361n2BfC8vW/40
         Fab7a6ozXRkJrcLuSvpk60AbCeZvvSlEhj/akjok=
Date:   Wed, 11 Dec 2019 15:24:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     kvalo@codeaurora.org, stable@vger.kernel.org,
        ulf.hansson@linaro.org
Subject: Re: WTF: patch "[PATCH] net: wireless: ti: wl1251 add device tree
 support" was seriously submitted to be applied to the 5.4-stable tree?
Message-ID: <20191211142448.GA605616@kroah.com>
References: <1576073193178125@kroah.com>
 <8B77E722-80C2-4607-8519-AC36CC42519C@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8B77E722-80C2-4607-8519-AC36CC42519C@goldelico.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 03:19:19PM +0100, H. Nikolaus Schaller wrote:
> Hi Greg,
> I have checked with Documentation/process/stable-kernel-rules.rst but not found out
> what is failing.
> 
> Basically this belongs to a series to fix a bug
> 
> 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")
> 
> that exists since v4.7 and has been hidden by patches which came into the kernel over
> the time.

I do not understand at all.

What does tagging all of these random wifi driver commits with cc:
stable have to do with an old mmc commit from 4.7-rc1?

confused,

greg k-h
