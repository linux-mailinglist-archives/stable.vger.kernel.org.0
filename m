Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 919621A4F96
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 13:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgDKLr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 07:47:56 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38133 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbgDKLr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Apr 2020 07:47:56 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id F23B65C020D;
        Sat, 11 Apr 2020 07:47:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 11 Apr 2020 07:47:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=zkvkS0Plmt8goPrtB0bmlPecPrL
        k9+ouUf+SKjJsWAg=; b=j8MMS1pL14nvYHVUdWbKQxCXjF1gV4FFLgICZhbdrQ3
        6fsY8Oiw/y6RuurBf9rwZ8lxNk5zAP1ATWCwluW0YmKoGIt50L+LSIs1Uj999d/o
        gC5jrs57N0VbAOJx6WTVsgiwm2wUpGgM8oAn3wHC+49A+UoBPwMcxx03CgX227cC
        3WC+8nZ+rtd1gp7ZrIjuFLa7l1ysdDjcqs3Fok0dQJqPeL4elaQau4Sag+1+Q57n
        VYZzXPJ6UpVY576sItSXltONsaN09NWNyCp4lgG6lc83v3R1heh/8EAdpRd8/mxs
        a2telQegKLe1GO4SN5OIJzpxfylcDp2g0C3CtcXFvaw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=zkvkS0
        Plmt8goPrtB0bmlPecPrLk9+ouUf+SKjJsWAg=; b=Cqb4xm4Mxs4OwMbXrI/ieV
        mQ/HergeqQcOVcHRFCTLfwKvYUT8JFl/cDDhrsMZwLNVwSk4r3D7nO9HpYnRnhZI
        a5mDk+hl5bRBY/8QmljzyydN9ZKogHlJjQTmEYapN5wbMjmLIKbhZdfYhzYdyuhb
        /nvOPYMAS1IzfUaN+tZ/tnx3QRg3f/5eTngN8BLuHb9z0SYeFzDfi/Qvj2NGR+sN
        SFeEpHby9WwKIsHRHiLF7T/OPVXBH02VRvv+EhnyxBNxSwTjv/ETjbGAjJG1S14E
        vQrAioL5SFs8wWXi948os6TNAtwH2ktQYe64SzY7R9amTCRPlpiMjqgVnkeAVChg
        ==
X-ME-Sender: <xms:a66RXs90enmvNxOR4REbzc2y5eKGoYuGVwSUJ2JISGV9v7BKt0kmYA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrvdeggdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:a66RXvubAEjCga5buNi_KUrL2mQ0aGQCltHysalUxWLVFJAgARJzWg>
    <xmx:a66RXhCgerw4AQiVEA5u7CkdNKOsGaZ0d7oK7dQFkU7xaLplP4qyFQ>
    <xmx:a66RXuKZ1kXDOmYdt1KNS5Y0lH7MgsTJv6UxERlQvCLl8PZzM1S8_g>
    <xmx:a66RXri1wPZo_OIjkOsspx_Iv1vgjeaLgMHqHxn00xrZo1TOP7hY2w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 69147328005A;
        Sat, 11 Apr 2020 07:47:55 -0400 (EDT)
Date:   Sat, 11 Apr 2020 13:47:53 +0200
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org,
        Karthick Gopalasubramanian <kargop@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 4.19 10/13] wil6210: remove reset file from debugfs
Message-ID: <20200411114753.GF2606747@kroah.com>
References: <20200403121859.901838-1-lee.jones@linaro.org>
 <20200403121859.901838-11-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403121859.901838-11-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 03, 2020 at 01:18:56PM +0100, Lee Jones wrote:
> From: Karthick Gopalasubramanian <kargop@codeaurora.org>
> 
> [ Upstream commit 32dcfe8316cdbd885542967c0c85f5b9de78874b ]
> 
> Reset file is not used and may cause race conditions
> with operational driver if used.
> 
> Signed-off-by: Karthick Gopalasubramanian <kargop@codeaurora.org>
> Signed-off-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/net/wireless/ath/wil6210/debugfs.c | 27 ----------------------
>  1 file changed, 27 deletions(-)

Why is this a patch for stable kernels?  debugfs is only for root, and
can do much worst things than this, which is why it shouldn't be
mounted/enabled on "real" systems.

thanks,

greg k-h
