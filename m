Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62EB1B2E75
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbgDURj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:39:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729276AbgDURj4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 13:39:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51036206D9;
        Tue, 21 Apr 2020 17:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587490795;
        bh=DeujCKaPmT9s1qf6BsHVmtgKDM79TE6c+FN9jrTESh8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=soY6fXk15JiN3nPLLPBjWErRD8kBhzIGjOv7YogW3LRXV7/HpsrEHzJIOe/s1ba3V
         w7bHVNprOWjchp2idrBsYnMSzoRcuqr0z5Mu3HQ66QjNmZWxCybKPL9Ot4T8mr5M/H
         +qmzOmC0VgYzqFBnqw3IEPtiZCzmbg5OAuHrhJdw=
Date:   Tue, 21 Apr 2020 19:39:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>
Subject: Re: [PATCH 4.14 06/24] android: binder: Use true and false for
 boolean values
Message-ID: <20200421173953.GA1307291@kroah.com>
References: <20200421124017.272694-1-lee.jones@linaro.org>
 <20200421124017.272694-7-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421124017.272694-7-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 01:39:59PM +0100, Lee Jones wrote:
> From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
> 
> [ Upstream commit 197410ad884eb18b31d48e9d8e64cb5a9e326f2f ]
> 
> Assign true or false to boolean variables instead of an integer value.
> 
> This issue was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Cc: Todd Kjos <tkjos@android.com>
> Cc: Martijn Coenen <maco@android.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/android/binder.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> index 05e75d18b4d93..afb690ed31ed9 100644
> --- a/drivers/android/binder.c
> +++ b/drivers/android/binder.c
> @@ -249,7 +249,7 @@ static struct binder_transaction_log_entry *binder_transaction_log_add(
>  	unsigned int cur = atomic_inc_return(&log->cur);
>  
>  	if (cur >= ARRAY_SIZE(log->entry))
> -		log->full = 1;
> +		log->full = true;

While nice and pretty, this does not actually fix a bug, so it's not
needed for stable trees.

thanks,

greg k-h
