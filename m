Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B662C1AB54C
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 03:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgDPBNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 21:13:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbgDPBNk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 21:13:40 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE7A02064A;
        Thu, 16 Apr 2020 01:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586999620;
        bh=52g+gVjZiMg4a5+0hzapE/Lu+oly61px2E1Jwk+GLEY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=duZTOBqqzUg8sdHvUSX/C5JYVNPpjU9SU8+QW/yNxyUyBOpODTbLlYL2l/ljymegh
         kU4B/zShNoQWfMVfKsiBvUpSG3lqcZ8E759xvtAjvkMTOvsU+Ar96h6KCbvSMYW8+B
         3nkybHxhgF7O77GuCRPxhDXwZHcmumfHImdXc9PE=
Date:   Wed, 15 Apr 2020 21:13:38 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     andrei.botila@nxp.com, herbert@gondor.apana.org.au,
        horia.geanta@nxp.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] crypto: caam - update xts sector size for
 large input length" failed to apply to 4.9-stable tree
Message-ID: <20200416011338.GR1068@sasha-vm>
References: <1586948775110154@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1586948775110154@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 01:06:15PM +0200, gregkh@linuxfoundation.org wrote:
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
>From 3f142b6a7b573bde6cff926f246da05652c61eb4 Mon Sep 17 00:00:00 2001
>From: Andrei Botila <andrei.botila@nxp.com>
>Date: Fri, 28 Feb 2020 12:46:48 +0200
>Subject: [PATCH] crypto: caam - update xts sector size for large input length
>MIME-Version: 1.0
>Content-Type: text/plain; charset=UTF-8
>Content-Transfer-Encoding: 8bit
>
>Since in the software implementation of XTS-AES there is
>no notion of sector every input length is processed the same way.
>CAAM implementation has the notion of sector which causes different
>results between the software implementation and the one in CAAM
>for input lengths bigger than 512 bytes.
>Increase sector size to maximum value on 16 bits.
>
>Fixes: c6415a6016bf ("crypto: caam - add support for acipher xts(aes)")
>Cc: <stable@vger.kernel.org> # v4.12+
>Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
>Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
>Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Function names were different due to 9dbe3072c6b1 ("crypto: caam/qi -
ablkcipher -> skcipher conversion") - queued up for 4.19 and 4.14.

I don't think that it's needed on anything older.

-- 
Thanks,
Sasha
