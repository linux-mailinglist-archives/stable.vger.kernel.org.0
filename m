Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931B63CD543
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 14:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237160AbhGSMQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 08:16:34 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:49001 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236935AbhGSMQd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 08:16:33 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 180643200930;
        Mon, 19 Jul 2021 08:57:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 19 Jul 2021 08:57:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=ZXaD9uLNcKUqkhseOf8qUNOR4ya
        V3HMJGpHyy54D6Pw=; b=jHWrHRoI0ByrtxBuFl5Yalgwxb/BcEDOntRff5KjxvS
        k+pvvCBPqPGowIR9Y54ZScsCeLrBaQ2XRKcX5eMPSYpjHXjfegirIYl/08mNFUrt
        DYjQjjNhnYZwiS9uUUuOBUOWTvMJ/PF3/C1IYj2GRtsEJrbOjZoKECSY77nHeRsn
        J/Hjb8CDyspqWG1TsM7cYA5wEfq5iEuykdG8vf5H160j9MrLjzrH8lTQ0V/IasTm
        +MIfKBtHk10aDrb+b13yS9GeTnszTo+ND6+gOS0Y6kbuLwKCVoHNnmX0aAQIUIlP
        31S7jO5FILyQ+D9M/L1ygP/322jMSvZ3zGV94edkuZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZXaD9u
        LNcKUqkhseOf8qUNOR4yaV3HMJGpHyy54D6Pw=; b=IWojW3I9nJ9Lrb8QKKunUu
        XUTuDVNba/AYMzAwc7OB8qzq4CLu5EMCaAoO9zX5c4FKFiM4y/NCr/1Cm3kTgaql
        JkZxPhWe8REgGrz+VXTm+cMuDklbMcDq2RBFCEyqMPnrJtjqNmqZ2MG/zhzJexoe
        LH+TM5h4j7JLVbwEw6ikZ84/L3cb6u5oaavcKnRDcZPBaBlARkIIgamCO87z9A/T
        7pA8nd+OWjnZYU+44lbL8Q7uVc6no0hTxvys/1XtoY6UDjHi9M0N02RCzNAL5jwZ
        Wn1dUPXs44VtILfwS+G8Y6fBA0h+U9SpqcizvzdjdWUAhrZUcWHpKQcYfHZ+Wfpw
        ==
X-ME-Sender: <xms:qHb1YLrV7vddjKNH4hcYy6HyhOVGr4HrWyiYTQHdyPV-_aVvWVsRbg>
    <xme:qHb1YFo4JMDGcd3gzKqt8cvdLfgkDWld-LaRs7H-SaPwuAeF1veHDh1lvce-BVSTD
    o56e3c3CaNO1A>
X-ME-Received: <xmr:qHb1YIMyZVCjVfo4eBMrGXGwNp4Ws7cX3vP6_gb-WF1H3xU6p3MNd6pDw7Ja8Z83zh0TnY5siYNIMkGC1Flo-EGYw8Px7ioq>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfedtgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:qHb1YO6fH5ZCLXKBsNpMLPZBBIq6IapBeiqSe285N4O-ic4-AQdWIw>
    <xmx:qHb1YK6w0mRjFpcWNMHLckEob3VcYAxH_P_ARQoZXsxdVcQusIEkLw>
    <xmx:qHb1YGgqwH2GbckbqZBmOHKmGVmj-bZSRM0Em5OCV9nR_uaey_JvAA>
    <xmx:qHb1YF2KEynKASM9F2FhNF4gUML9ieN_D7KPPAMog5BwlK4X5x159Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Jul 2021 08:57:11 -0400 (EDT)
Date:   Mon, 19 Jul 2021 14:57:09 +0200
From:   Greg KH <greg@kroah.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] stable-5.12 backport fixes
Message-ID: <YPV2pX0pmsOrW337@kroah.com>
References: <cover.1626651114.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1626651114.git.asml.silence@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 12:54:21AM +0100, Pavel Begunkov wrote:
> a298232ee6b9a1 ("io_uring: fix link timeout refs") was backported,
> however the second chunk of it got discarded, which breaks io_uring.
> It depends on another patch, so backport it first (patch 1/2) and
> then apply a298232ee6b9a1 again (patch 2/2).
> 
> It's a bit messy, the patch will be in the tree twice. Let me
> know if there is a better way.
> 
> Pavel Begunkov (2):
>   io_uring: put link timeout req consistently
>   io_uring: fix link timeout refs
> 
>  fs/io_uring.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)

Not a problem, thanks for these.  This is going to be the last 5.12.y
release, so it shouldn't be that confusing.

thanks,

greg k-h
