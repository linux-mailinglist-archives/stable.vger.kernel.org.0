Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9943962EF
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 17:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbhEaPCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234137AbhEaPAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 11:00:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C42F6135C;
        Mon, 31 May 2021 14:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622470356;
        bh=1Z4N68USn6iPKdDMjFITCt216+Ua2Rfye0Lg+zWhbVc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NLgjMQcVMAQPs742r0SR/Bsv+AzgTgaIIIE4ipSVzQ3HKX6QNMEvAjhR2qHjvwHGJ
         hOHciiMs2Rzs/w9ahE652fS2IMvAeBhSt/6pURtev4T9NAY7GRbtHntObxCPdNoreb
         xDioKm7qjlB1KSwupIA8Iqowi2pqdJ62GgbR/N34=
Date:   Mon, 31 May 2021 16:09:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hongbo Li <herbert.tencent@gmail.com>
Cc:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, ebiggers@kernel.org,
        dhowells@redhat.com, jarkko@kernel.org,
        tianjia.zhang@linux.alibaba.com, herberthbli@tencent.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: fix a memory leak in sm2
Message-ID: <YLTuML8P8fXCl7iw@kroah.com>
References: <1622467611-30383-1-git-send-email-herbert.tencent@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622467611-30383-1-git-send-email-herbert.tencent@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 09:26:51PM +0800, Hongbo Li wrote:
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

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
