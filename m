Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343F91D4279
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 02:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgEOAzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 20:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgEOAzc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 20:55:32 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6657720748;
        Fri, 15 May 2020 00:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589504131;
        bh=dyv0R0ie8YtJy95FD9KX/0SzWGEPyzcOwMlclDh+UA4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uJSjrd+xSjB+lMuRVw90RcbqLGFHaXVtOIgqfx07hc1ld5s6DyfDgXH6HgOs4xQ1l
         J2xXwpDTUJl3aIpJp50BsBsCONoto8RXR7nnKtrJebxML90qwN3NLUj5Wh8ghW9VXj
         R30NpFNQJmBYlDidtvszjQo65EAGoXaguTwV2S6A=
Date:   Thu, 14 May 2020 20:55:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 39/39] crypto: xts - simplify error handling
 in ->create()
Message-ID: <20200515005530.GD29995@sasha-vm>
References: <20200514185456.21060-1-sashal@kernel.org>
 <20200514185456.21060-39-sashal@kernel.org>
 <20200514190843.GA187179@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200514190843.GA187179@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 14, 2020 at 12:08:43PM -0700, Eric Biggers wrote:
>On Thu, May 14, 2020 at 02:54:56PM -0400, Sasha Levin wrote:
>> From: Eric Biggers <ebiggers@google.com>
>>
>> [ Upstream commit 732e540953477083082e999ff553622c59cffd5f ]
>>
>> Simplify the error handling in the XTS template's ->create() function by
>> taking advantage of crypto_drop_skcipher() now accepting (as a no-op) a
>> spawn that hasn't been grabbed yet.
>>
>> Signed-off-by: Eric Biggers <ebiggers@google.com>
>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Please don't backport this patch.  It's a cleanup (not a fix) that depends on
>patches in 5.6, which you don't seem to be backporting.

For 5.6-4.19 I grabbed these to take:

	1a263ae60b04 ("gcc-10: avoid shadowing standard library 'free()' in crypto")

cleanly. I'll drop it as it's mostly to avoid silly gcc10 warnings, but
I just wanted to let you know the reason they ended up here.

>Note, this comment applies to all stable trees as well as all the other
>"simplify error handling in ->create()" patches.
>I hope that I don't have to reply to every individual email.

You don't :)

-- 
Thanks,
Sasha
