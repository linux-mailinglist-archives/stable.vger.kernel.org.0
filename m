Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6654E23339
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732454AbfETMJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:09:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730921AbfETMJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:09:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A04A20656;
        Mon, 20 May 2019 12:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354145;
        bh=wZbHqJjzSCtRrw1EnIKg8CMFLMhBazKLa0vRuT7Cyv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JU7536XVe6T/VGeJ+j7c7M0xeRuruJCV7FOA+wbNKM/UUluggkO5lRNP8o00D/5mJ
         S7GIPNbAacX0h6TA67hr3NFAJshjXNqlRYiOJzcH2OBMIwWWKhdV6CMYVqfKhuEqCX
         vMOGx72sZZKwXC+X5RwqFfLjutGNpeecqZ6XGhfE=
Date:   Mon, 20 May 2019 14:09:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [STABLE PATCH 1/2] crypto: ccree: zap entire sg on aead request
 unmap
Message-ID: <20190520120903.GB13524@kroah.com>
References: <20190520115025.16457-1-gilad@benyossef.com>
 <20190520115025.16457-2-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520115025.16457-2-gilad@benyossef.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 20, 2019 at 02:50:23PM +0300, Gilad Ben-Yossef wrote:
> We were trying to be clever zapping out of the cache only the required
> length out of scatter list on AEAD request completion and getting it
> wrong.
> 
> As Knuth said: "when in douby, use brute force". Zap the whole length of
> the scatter list.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  drivers/crypto/ccree/cc_buffer_mgr.c | 18 ++----------------
>  1 file changed, 2 insertions(+), 16 deletions(-)

This does not apply on top of my latest 4.19 tree with the current
pending queue applied, nor does it apply to 5.1 or 5.0.

How about waiting a few days and resending after I do the next round of
stable updates, so you can rebase on top of them easier?

thanks,

greg k-h
