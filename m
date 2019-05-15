Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7781F91D
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 19:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfEORGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 13:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbfEORGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 13:06:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FEBD20862;
        Wed, 15 May 2019 17:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557940013;
        bh=3s5MNfbYRU4f9wPUfwL54/Imb2QZD3B5Kfsa0bUBVSM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yy3dVj+46/pmIfOhI3PHO1hsnf2ffIIbOLOfM8IbF0GmZiSS6FgcpjMUjfCTjhN57
         DF5cDQgrxjVVLXOS9HGqGATkL3zEbI4fxe00WhGiNXaSesVzMXc9WN7XE3s8jMMSBj
         mTSnsZGpHm8Hburqd1sKswjDvE4EjpFCgeu9VmFg=
Date:   Wed, 15 May 2019 19:06:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vignesh Raghavendra <vigneshr@ti.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: Re: [PATCH 4.14 053/115] i2c: omap: Enable for ARCH_K3
Message-ID: <20190515170650.GA9493@kroah.com>
References: <20190515090659.123121100@linuxfoundation.org>
 <20190515090703.440094029@linuxfoundation.org>
 <b97de7c6-fb95-33a9-3ac6-4df45eec82c5@ti.com>
 <a6eecb36-a0ae-753a-6582-0afdac04c4b5@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6eecb36-a0ae-753a-6582-0afdac04c4b5@ti.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 15, 2019 at 11:53:08AM -0500, Vignesh Raghavendra wrote:
> 
> 
> On 15/05/19 6:28 AM, Grygorii Strashko wrote:
> > Hi Greg,
> > 
> > On 15.05.19 13:55, Greg Kroah-Hartman wrote:
> >> [ Upstream commit 5b277402deac0691226a947df71c581686bd4020 ]
> >>
> >> Allow I2C_OMAP to be built for K3 platforms.
> >>
> >> Signed-off-by: Vignesh R <vigneshr@ti.com>
> >> Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
> >> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> >> Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
> > 
> > This is not v4.14 material as there no support for ARCH_K3.
> > Could you drop it pls.
> > 
> 
> Yes, I had informed not to backport this patch before during other
> stable reviews as well:
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1811579.html
> 
> Please drop the patch.

Now dropped, thanks.

greg k-h
