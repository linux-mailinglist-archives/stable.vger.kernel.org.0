Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78B514FFD2
	for <lists+stable@lfdr.de>; Sun,  2 Feb 2020 23:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgBBWef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Feb 2020 17:34:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbgBBWee (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 Feb 2020 17:34:34 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 014C020658;
        Sun,  2 Feb 2020 22:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580682874;
        bh=YcmlOdgal5MoIYxONM2lE/IKtcX1X3AgC3zydaI0hUU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gHc3C6LSoDWdbG0zlEKzZkSbx8sIfPA8bRb94TvkYQFwKlCUXNFm71J9GuJggrr5q
         q0mHHmS2rZScUuYl1HFLghGR1tzQ75A4Zxi9V9uEFRRwHEOnAGfTCCNg2pxeEOZnQa
         iPkJJxhb9CpTvaQ35JRUa1y2UKHZQ/5SnWdZoRrI=
Date:   Sun, 2 Feb 2020 17:34:32 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     herbert@gondor.apana.org.au, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] crypto: pcrypt - Fix user-after-free on
 module unload" failed to apply to 4.19-stable tree
Message-ID: <20200202223432.GE1732@sasha-vm>
References: <1580395207158126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1580395207158126@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 30, 2020 at 03:40:07PM +0100, gregkh@linuxfoundation.org wrote:
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
>From 07bfd9bdf568a38d9440c607b72342036011f727 Mon Sep 17 00:00:00 2001
>From: Herbert Xu <herbert@gondor.apana.org.au>
>Date: Tue, 19 Nov 2019 17:41:31 +0800
>Subject: [PATCH] crypto: pcrypt - Fix user-after-free on module unload
>
>On module unload of pcrypt we must unregister the crypto algorithms
>first and then tear down the padata structure.  As otherwise the
>crypto algorithms are still alive and can be used while the padata
>structure is being freed.
>
>Fixes: 5068c7a883d1 ("crypto: pcrypt - Add pcrypt crypto...")
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Conflicts due to 63d3578892dc ("crypto: pcrypt - remove padata cpumask
notifier"), cleaned up and queued for all trees.

-- 
Thanks,
Sasha
