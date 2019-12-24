Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57C5B129BFC
	for <lists+stable@lfdr.de>; Tue, 24 Dec 2019 01:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfLXAJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 19:09:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726865AbfLXAJK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Dec 2019 19:09:10 -0500
Received: from localhost (unknown [64.47.196.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DC53206D3;
        Tue, 24 Dec 2019 00:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577146149;
        bh=pFGhpW30ft4J5ozUybupiikEf5ZVs/5anCskI7M1mAU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OpE1TuRI+zDjZbPUcGEJHGw8BLPbyWo4BsTZxdRQJbEzt3JJP8kM9pXqRVOhAvuVj
         Iu7Puk3VQz+7m482Zd1Dm48xwbjVLjL33eFuYea4zd6tZykDva2Mh7xBGyGbmvLIfB
         4OR9ixMYIEBYa3OVrvexDyuIkQ325u+qzsAlhMSk=
Date:   Mon, 23 Dec 2019 19:09:06 -0500
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH for 4.4, 4.9, 4.14, 4.19] uio: make symbol
 'uio_class_registered' static
Message-ID: <20191224000906.GB282927@kroah.com>
References: <20191223235210.2312-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191223235210.2312-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 24, 2019 at 08:52:10AM +0900, Nobuhiro Iwamatsu wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> commit 6011002c1584d29c317e0895b9667d57f254537a upstream.
> 
> Fixes the following sparse warning:
> 
> drivers/uio/uio.c:277:6: warning:
>  symbol 'uio_class_registered' was not declared. Should it be static?
> 
> Fixes: ae61cf5b9913 ("uio: ensure class is registered before devices")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  drivers/uio/uio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Why is this a valid patch for the stable trees?

Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

for the rules.

greg k-h
