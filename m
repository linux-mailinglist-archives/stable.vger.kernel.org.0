Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94D93C9E19
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 13:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhGOMCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 08:02:21 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47413 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231338AbhGOMCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 08:02:21 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id BBF625C025D;
        Thu, 15 Jul 2021 07:59:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 15 Jul 2021 07:59:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=APLneAKskgIRuWTFaSNVvav62Ld
        iHrfIatCHo4V5EYY=; b=df4V4buKqqwTExvtHt9J4pjuh7Bdh/3TDSKnmwFgCSW
        mdfsqPRCvlREI3ZtgOcwRG/EUOcic5cxoQn9UHjU2u+6dTHFd2EKzB8atW0yGQ9X
        /RlsWpQ/y/Mk2wAFcvvu4+1YbvrRaJmvzjXd/PlchVTSWpQjGdXTndTXJjn14QJk
        FeIyIehKvAn1ilDnpUY2KphdH3sQb7R55UphkfJVM+ww6hBavrPxylLOLMpu7k7Z
        vUeXuqy6XVxAzsbXJ1s16oQETooP4k5mY3pU0bkM/lQ4pEFSPuqtUh/UNZO65JmX
        dfyqvvlt4zHCg/kFNlEWY+G+zfSWGw+t09TKxZhoIPQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=APLneA
        KskgIRuWTFaSNVvav62LdiHrfIatCHo4V5EYY=; b=j6nJCppgzgzZP7/EyzIDLW
        xsUYd50rDQvqO/hPm6MidNsePx8ST2rohA3J028zAf793KpGFU835XxCgjjNEtb6
        w83Tc00fLjDhGrvi7q87GO2hTroPTFI2LqgUYKzvNCWZMdfFtO2pqZeY9GeBNWZh
        3LoItnZfDcv7ukiid0OvHTmmAmEpxnmGfr/7/23gkOigVsJ2S1iuKo5V52FqMkWx
        w0V+8Xu4NDupMAZpzYMoJxYT2jHNBO6yhnOzJa5PowdyDf+ouVPT/G9t+bbOVCwl
        5ZVcO/ySnlbS0cx/7Ii+Lgj6h+ipAxoH3bRxXFvpTipGMpiJZCyy0jc1dUV7hrkA
        ==
X-ME-Sender: <xms:HyPwYL_7EgVsLJmse6mp19KEAkXJ01PltZb9mHEnITaXBvkUOh-6EA>
    <xme:HyPwYHvmTDUF3ZU3WpYbqB7wFBEAKVHXWK5yHLSiDyVanP4InwSeTXD9BzrO5udZ4
    MRaHM7vKbqHBw>
X-ME-Received: <xmr:HyPwYJD8lOMyDsm22mw2CAC_NkT4ZLqHH82bcREXumuGekzzVtsUN8YaSW4Q1CqtRcLs3uAFm7AvByzsHZnZn8RgqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtgddvlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:HyPwYHdV_LoH39GvKpvQKJMrHBNilxFz7h-A4QQWlPj6WEN8hjLK3g>
    <xmx:HyPwYAMSMYpePQprfIJnywP7zr_oU03MccuuaQeQzZQF9yufqJUvfg>
    <xmx:HyPwYJn5vaI5q2qT2Fxg2VasD8ChGcI6NEfHd5oB-koAJV1557i2vQ>
    <xmx:HyPwYMDOws27VDx-hv1-zUoNIQF6b_NRjVV-w35MMirsgAxEsjJ5TA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jul 2021 07:59:27 -0400 (EDT)
Date:   Thu, 15 Jul 2021 13:55:32 +0200
From:   Greg KH <greg@kroah.com>
To:     Davis Mosenkovs <davis@mosenkovs.lv>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14] mac80211: fix memory corruption in EAPOL handling
Message-ID: <YPAiNH03VHTgDwho@kroah.com>
References: <20210710183807.5792-1-davis@mosenkovs.lv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710183807.5792-1-davis@mosenkovs.lv>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 10, 2021 at 09:38:07PM +0300, Davis Mosenkovs wrote:
> Commit 557bb37533a3 ("mac80211: do not accept/forward invalid EAPOL
> frames") uses skb_mac_header() before eth_type_trans() is called
> leading to incorrect pointer, the pointer gets written to. This issue
> has appeared during backporting to 4.4, 4.9 and 4.14.
> 
> Fixes: 557bb37533a3 ("mac80211: do not accept/forward invalid EAPOL frames")
> Link: https://lore.kernel.org/r/CAHQn7pKcyC_jYmGyTcPCdk9xxATwW5QPNph=bsZV8d-HPwNsyA@mail.gmail.com
> Cc: <stable@vger.kernel.org> # 4.14.x
> Signed-off-by: Davis Mosenkovs <davis@mosenkovs.lv>
> ---
>  net/mac80211/rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Ah, see your other backports now, nice, all now is good.

greg k-h
