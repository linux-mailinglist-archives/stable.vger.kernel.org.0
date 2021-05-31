Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4E93962F6
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 17:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbhEaPCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234105AbhEaPAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 11:00:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5435611CA;
        Mon, 31 May 2021 14:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622470353;
        bh=zR1cGoacMDr4c4wQGlzEADEdZgsbJayK7zDMvko60do=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F4Ad5rgiC+29iWRBlKk3EKI8RDfSMHIp9ibrfxObiNDDBk59hfuvVvgbRM8g+IiAV
         s4RKbnUY8YFMcDgF4qVhtmn6jodIMpq18WE7cR5T1JIImISYg9on3ZQmmUfDueV0Vh
         I36nxQ02oJ9lOBa5p67Rq7tjeY03/ZBsvzfr0YKo=
Date:   Mon, 31 May 2021 16:09:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hongbo Li <herbert.tencent@gmail.com>
Cc:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, ebiggers@kernel.org,
        dhowells@redhat.com, jarkko@kernel.org,
        tianjia.zhang@linux.alibaba.com, herberthbli@tencent.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: sm2 - fix a memory leak in sm2
Message-ID: <YLTuGkG7kFk9/f2u@kroah.com>
References: <1622467801-30957-1-git-send-email-herbert.tencent@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622467801-30957-1-git-send-email-herbert.tencent@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 09:30:01PM +0800, Hongbo Li wrote:
> From: Hongbo Li <herberthbli@tencent.com>
> 
> SM2 module alloc ec->Q in sm2_set_pub_key(), when doing alg test in
> test_akcipher_one(), it will set public key for every test vector,
> and don't free ec->Q. This will cause a memory leak.
> 
> This patch alloc ec->Q in sm2_ec_ctx_init().
> 
> Fixes: ea7ecb66440b ("crypto: sm2 - introduce OSCCA SM2 asymmetric cipher algorithm")
> Signed-off-by: Hongbo Li <herberthbli@tencent.com>
> Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  crypto/sm2.c | 24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
