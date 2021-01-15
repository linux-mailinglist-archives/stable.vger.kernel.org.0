Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDC52F75DA
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 10:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbhAOJu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 04:50:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729491AbhAOJu1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 04:50:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C22623403;
        Fri, 15 Jan 2021 09:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610704196;
        bh=8kVUUfGUV1PGQsJH6sdWn1GPGd4SkP3RyPjyR/I/86U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TwiDu0D99giki0LI96SEXAimlJBgMdOAXowc6dHAwJIATZTPf9q3MX52F+EVjSKJd
         ufhGYCsNY+uvSeiGNBrqj1Cq50Pr5yz3aZHCD04Cm2Bfr+nBRjg7SF3BW+Unp5YkQP
         3leDJKoGr2HWuYl2djx5QGQ15HVTyXHixm0J8sbs=
Date:   Fri, 15 Jan 2021 10:49:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     lukas@wunner.de, broonie@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: pxa2xx: Fix use-after-free on
 unbind" failed to apply to 4.14-stable tree
Message-ID: <YAFlQhMWzfbXKQGG@kroah.com>
References: <160915257822973@kroah.com>
 <20210111204505.yzydbkffdn2k44u3@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111204505.yzydbkffdn2k44u3@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 08:45:05PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Dec 28, 2020 at 11:49:38AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport, will also apply to 4.9-stable and 4.4-stable.

Thanks applied!

greg k-h
