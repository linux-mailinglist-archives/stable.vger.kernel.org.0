Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5220E1D3C9D
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbgENTIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:08:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728954AbgENTIp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 15:08:45 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE0FF20643;
        Thu, 14 May 2020 19:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589483324;
        bh=KHYmyiI66zTuoK4UuBzCZfdb93JuBPFDvZtlObrdUyk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l2qFbdhcHcDykTDkYu7ahNKLCXt68LmvuAeVkogZoD4oS02SFal6OVFk5SD5mWr6H
         kSTMbSdpFRiK66FHOizh/4D5mj5tdyHexudw0j9PwxqKepQReehRUwREYRkAyZdQPp
         i5nCEWAaYY+Rw57WY3k1HVcN9LuM7Z4uzuZQmo6M=
Date:   Thu, 14 May 2020 12:08:43 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 39/39] crypto: xts - simplify error handling
 in ->create()
Message-ID: <20200514190843.GA187179@gmail.com>
References: <20200514185456.21060-1-sashal@kernel.org>
 <20200514185456.21060-39-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514185456.21060-39-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 14, 2020 at 02:54:56PM -0400, Sasha Levin wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> [ Upstream commit 732e540953477083082e999ff553622c59cffd5f ]
> 
> Simplify the error handling in the XTS template's ->create() function by
> taking advantage of crypto_drop_skcipher() now accepting (as a no-op) a
> spawn that hasn't been grabbed yet.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please don't backport this patch.  It's a cleanup (not a fix) that depends on
patches in 5.6, which you don't seem to be backporting.

Note, this comment applies to all stable trees as well as all the other
"simplify error handling in ->create()" patches.
I hope that I don't have to reply to every individual email.

- Eric
