Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32077154BBF
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 20:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgBFTPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 14:15:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:55718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgBFTPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 14:15:18 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F414221741;
        Thu,  6 Feb 2020 19:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581016518;
        bh=sUVpIaSQQv1sYxD093i3Qi8GgU7i0xULu1GEuvClAiM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yg+6gqpsUU1cUIhlvlTxyt5y/hQXnm8u2tx0Fot+b4gLse7f8mhHb2sq6g3D7/Tfp
         ZOQ8Bcnk5AZw2/yoPHsVT1VjVGxMQJ5HmoPmESTG7ommtclhP1L80hcMY0HG08iHj0
         TU3aLUTLpiHll4+khNScifRGyPW1i8kVreUFTi2w=
Date:   Thu, 6 Feb 2020 14:15:17 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Florian Bezdeka <florian@bezdeka.de>
Cc:     stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4.19] crypto: geode-aes - convert to skcipher API and
 make thread-safe
Message-ID: <20200206191517.GO31482@sasha-vm>
References: <20200206171534.4051-1-florian@bezdeka.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200206171534.4051-1-florian@bezdeka.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 06, 2020 at 06:15:34PM +0100, Florian Bezdeka wrote:
>commit 4549f7e5aa27ffc2cba63b5db8842a3b486f5688 upstream.
>
>The geode AES driver is heavily broken because it stores per-request
>state in the transform context.  So it will crash or produce the wrong
>result if used by any of the many places in the kernel that issue
>concurrent requests for the same transform object.
>
>This driver is also implemented using the deprecated blkcipher API,
>which makes it difficult to fix, and puts it among the drivers
>preventing that API from being removed.
>
>Convert this driver to use the skcipher API, and change it to not store
>per-request state in the transform context.
>
>Fixes: 9fe757b ("[PATCH] crypto: Add support for the Geode LX AES hardware")
>Signed-off-by: Eric Biggers <ebiggers@google.com>
>Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>Signed-off-by: Florian Bezdeka <florian@bezdeka.de>

Queued up, thanks!

-- 
Thanks,
Sasha
