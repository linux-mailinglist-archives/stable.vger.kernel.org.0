Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855203CD4EC
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 14:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236811AbhGSL7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 07:59:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237041AbhGSL7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 07:59:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B0146113B;
        Mon, 19 Jul 2021 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626698411;
        bh=ec9aSpU01rDk3L8/1MWG2xSeLpf8itpXYZ3hxC+ULgY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XMAYxAts9Xl2J4OPBUKPBvtcBknkVvrEXexP+6Xp4Ju3YIe0sEZVG/ie1iXby6XW8
         CjJE12YKdYhcjfSKKUTHmbqLH5D57pbnePca6a8gRTrFk2xTcQQT5HXPrNShRxsOJY
         Lp+noSbzn3n0jnBo8kQ4Ob2y1Sk+7orMqjH+gG7s=
Date:   Mon, 19 Jul 2021 14:40:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     sudipm.mukherjee@gmail.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, davem@davemloft.net, sashal@kernel.org
Subject: Re: [PATCH 5.4] net: moxa: Use
 devm_platform_get_and_ioremap_resource()
Message-ID: <YPVyophPac6yjBws@kroah.com>
References: <20210716093245.315536-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716093245.315536-1-yangyingliang@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 05:32:45PM +0800, Yang Yingliang wrote:
> [ Upstream commit 35cba15a504bf4f585bb9d78f47b22b28a1a06b2 ]
> 
> Use devm_platform_get_and_ioremap_resource() to simplify
> code and avoid a null-ptr-deref by checking 'res' in it.
> 
> [yyl: since devm_platform_get_and_ioremap_resource() is introduced
>       in linux-5.7, so just check the return value after calling
>       platform_get_resource()]
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/ethernet/moxa/moxart_ether.c | 4 ++++
>  1 file changed, 4 insertions(+)

Now queued up, thanks.

greg k-h
