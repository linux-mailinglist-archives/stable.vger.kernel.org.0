Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD26B205338
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 15:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732676AbgFWNPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 09:15:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732662AbgFWNPG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 09:15:06 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E6EC20723;
        Tue, 23 Jun 2020 13:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592918105;
        bh=yKC4wE+UkQqquOq6csNQa6WPBTgaqACxKvVRBsKTvzQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mxYE4poWODzEMtrWzZtfp55+t3oX4JilM36Bsc9qB0D4F7TLHi6cs8wHTw6ttNDzZ
         8z++vvqKrBNqUf/FjI1TWvM6uTQwVJL5Ld2WcEK3py6aGcCPH8AUfaJdoGotbVAv5M
         oI3UZvJAKM2Dg+6J+e/Ivl/5yol+Q0OqKygGUx7k=
Date:   Tue, 23 Jun 2020 09:15:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     herbert@gondor.apana.org.au, smueller@chronox.de,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] crypto: algif_skcipher - Cap recv SG list
 at ctx->used" failed to apply to 4.9-stable tree
Message-ID: <20200623131504.GW1931@sasha-vm>
References: <1592913287117111@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1592913287117111@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 01:54:47PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.9-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 7cf81954705b7e5b057f7dc39a7ded54422ab6e1 Mon Sep 17 00:00:00 2001
>From: Herbert Xu <herbert@gondor.apana.org.au>
>Date: Fri, 29 May 2020 14:54:43 +1000
>Subject: [PATCH] crypto: algif_skcipher - Cap recv SG list at ctx->used
>
>Somewhere along the line the cap on the SG list length for receive
>was lost.  This patch restores it and removes the subsequent test
>which is now redundant.
>
>Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of...")
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>Reviewed-by: Stephan Mueller <smueller@chronox.de>
>Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

We don't have 2d97591ef43d ("crypto: af_alg - consolidation of duplicate
code") in our 4.9 and 4.4 trees.

We do carry an "out of tree" backport that fixes an issue silently fixed
by 2d97591ef43d, but it does not introduce the issue that this patch
fixes.

-- 
Thanks,
Sasha
