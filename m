Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9B21AB594
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 03:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732502AbgDPBiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 21:38:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731837AbgDPBh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 21:37:58 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 056F220644;
        Thu, 16 Apr 2020 01:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587001078;
        bh=AaO/+NvgBF4SPH/3WDudLvRSk+23VUPiQLzBDiLioTE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HExsXE35PZAb0WPByFCwBd+5gpdITbgo+ctEMkhRxuhoDXsD0dbt9Bc97efhvDktQ
         DSD9JmuOZs3G5fReSypK95G9GNKj6P0lJYhEUa/umIPGL1I031hbXaGwTWG/RHClKS
         MgS6q0UyeA3XePlRIyaKZsXyKnK6nCzoiPm59oMc=
Date:   Wed, 15 Apr 2020 21:37:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     gilad@benyossef.com, geert+renesas@glider.be,
        herbert@gondor.apana.org.au, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] crypto: ccree - only try to map auth tag
 if needed" failed to apply to 4.19-stable tree
Message-ID: <20200416013757.GT1068@sasha-vm>
References: <158694882829120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158694882829120@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 01:07:08PM +0200, gregkh@linuxfoundation.org wrote:
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
>From 504e84abec7a635b861afd8d7f92ecd13eaa2b09 Mon Sep 17 00:00:00 2001
>From: Gilad Ben-Yossef <gilad@benyossef.com>
>Date: Wed, 29 Jan 2020 16:37:55 +0200
>Subject: [PATCH] crypto: ccree - only try to map auth tag if needed
>
>Make sure to only add the size of the auth tag to the source mapping
>for encryption if it is an in-place operation. Failing to do this
>previously caused us to try and map auth size len bytes from a NULL
>mapping and crashing if both the cryptlen and assoclen are zero.
>
>Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
>Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
>Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>Cc: stable@vger.kernel.org # v4.19+
>Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Grabbing:

da3cf67f1bcf ("crypto: ccree - don't mangle the request assoclen")
9f31eb6e08cc ("crypto: ccree - zero out internal struct before use")
ccba2f1112d4 ("crypto: ccree - improve error handling")

resolved this conflict.

-- 
Thanks,
Sasha
