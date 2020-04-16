Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E468C1AB593
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 03:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731661AbgDPBhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 21:37:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbgDPBhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 21:37:45 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBDD920644;
        Thu, 16 Apr 2020 01:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587001065;
        bh=sqfi4F3U7dkwtQWOqRnkAy2qVbT2IFFzyjhhVI/E48Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CRUK/WQMdUk7zU0CBytuSOxBeZcoQJJXgEDKJ7c2sg/38jmW9uYH48aTOsHwjdlQ5
         Uz2hfHUsL6nClgPs2TMHi8j5tbOmaVlbTjYKVNO4c2LmXl8fd2Zn/g6nuXkSw+HHki
         JAQGH/Mh0ITuZRoYKbFN4mtgGFgpoFp5zSLNvlWs=
Date:   Wed, 15 Apr 2020 21:37:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     gilad@benyossef.com, geert+renesas@glider.be,
        herbert@gondor.apana.org.au, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] crypto: ccree - dec auth tag size from
 cryptlen map" failed to apply to 4.19-stable tree
Message-ID: <20200416013743.GS1068@sasha-vm>
References: <1586948847250254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1586948847250254@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 01:07:27PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
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
>From 8962c6d2c2b8ca51b0f188109015b15fc5f4da44 Mon Sep 17 00:00:00 2001
>From: Gilad Ben-Yossef <gilad@benyossef.com>
>Date: Sun, 2 Feb 2020 18:19:14 +0200
>Subject: [PATCH] crypto: ccree - dec auth tag size from cryptlen map
>
>Remove the auth tag size from cryptlen before mapping the destination
>in out-of-place AEAD decryption thus resolving a crash with
>extended testmgr tests.
>
>Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
>Cc: stable@vger.kernel.org # v4.19+
>Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
>Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Grabbing:

da3cf67f1bcf ("crypto: ccree - don't mangle the request assoclen")
9f31eb6e08cc ("crypto: ccree - zero out internal struct before use")
ccba2f1112d4 ("crypto: ccree - improve error handling")

resolved this conflict.

-- 
Thanks,
Sasha
