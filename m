Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854924AA912
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 14:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239069AbiBENP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 08:15:26 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41353 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232557AbiBENPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 08:15:25 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id E8D605C00DF;
        Sat,  5 Feb 2022 08:15:24 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sat, 05 Feb 2022 08:15:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=nEfsi3e9hJGhRVn/s3Xkclcuo+lsriGkX7loXU
        3CYmM=; b=FnM9DhAa5TXFN3xNSI4O1qas+HzuL0rsCF/nSAS8fuRAxBmxa8MAyP
        5HRZl05y4rOVGEMnZRWx2wndaPWYWmdx1raVIQaYY+WUCGKKzTfrKinjk8kPfKa6
        3FGlnAxfOSyF/8vuIOX8kkTn0lzhXerB3q4dd7HyejW5pWaorZvlarVtEOVWY0XG
        m+pJww9MQembKoVMa2E0o+20m7I4Kql2svCvRv7d4GdJ3PtwxXuwZC7vSee+gGEl
        2Lofskbcvu2oYMPTbIXVPbDSidn/PYgCu7BdFa9Qn2MMZ66vt8BuaeiPf7sLb6Th
        z+uFqVXROdduuZQSCxuoSAlu2KZS+Weg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nEfsi3e9hJGhRVn/s
        3Xkclcuo+lsriGkX7loXU3CYmM=; b=d7I9d8Td55gDVdwDyP5yETfYV2OWPVKPF
        vff/dPoFi/B0jb+ThTc1p0pWXxHKttDs0mAm4rJIXnFVlgX1ZTanJ1ST+vXL2ggP
        wThddAzsKCSWiDfHOwDpOuoRiiYDAsGg5eCePciBM61S0AyrHcawfzF9k0xqENBd
        Sb3WiAcCzhOby5T+v7Ui4ljrL7njXrENFTM/nTE0Jcc78spy+85s2zAXJMjpIyON
        mE+ECD0letZg2DvLPgV892y7HbZWgXZ8774A7VN5+iCr+eJgjZxj/NV9UkaRRdeL
        UZdaQTXxTgdhoJ2ZOrJBWiRgQupwjY8HcPgXFTdPdJoxgWnHxULiA==
X-ME-Sender: <xms:bHj-YeEKJ7e4eU44jR3blAKQsiQn_QzliPEhAP2zYuDKafCI8FQ5Zg>
    <xme:bHj-YfXjx3wksdiajqehU7p5MGvZ-Nz5VK42Lh9nmzo7WYCgA2A05T_YkIYgQenPe
    gblE7J_lE1rOQ>
X-ME-Received: <xmr:bHj-YYKFJkuE2gZ58a_5aFo9708p_INaaw1cGzFygCrAhx9y2dsFoD8DGwOBgJ6FqOU4GW2CJ-Iroq7kA2cDr6nhw6vOTyST>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrhedugdeglecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:bHj-YYEQFbD_UTymjua3OkZJ4yeffV7-rYSbtrQPmKos1GHJhlXQJg>
    <xmx:bHj-YUWx-zaeDJcdGrofrBSaeq_Al2NfG7mPtR5gPsKoqyvxRSz3sw>
    <xmx:bHj-YbMU8UwEc1RxP9oYjVH9PpgUKt2s_5m7mB3GYNvV33B3kyho1w>
    <xmx:bHj-YWLqYMiaz6RlCnBV1BSYztkzNGaG721d0GCzvcmci3Asj4Xq8g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 5 Feb 2022 08:15:24 -0500 (EST)
Date:   Sat, 5 Feb 2022 14:15:22 +0100
From:   Greg KH <greg@kroah.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     stable@vger.kernel.org, mptcp@lists.linux.dev,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] mptcp: fix msk traversal in mptcp_nl_cmd_set_flags()
Message-ID: <Yf54auq4qLWyJ562@kroah.com>
References: <20220205010231.189151-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220205010231.189151-1-mathew.j.martineau@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 04, 2022 at 05:02:31PM -0800, Mat Martineau wrote:
> commit 8e9eacad7ec7a9cbf262649ebf1fa6e6f6cc7d82 upstream.
> 
> The upstream commit had to handle a lookup_by_id variable that is only
> present in 5.17. This version of the patch removes that variable, so the
> __lookup_addr() function only handles the lookup as it is implemented in
> 5.15 and 5.16. It also removes one 'const' keyword to prevent a warning
> due to differing const-ness in the 5.17 version of addresses_equal().
> 
> The MPTCP endpoint list is under RCU protection, guarded by the
> pernet spinlock. mptcp_nl_cmd_set_flags() traverses the list
> without acquiring the spin-lock nor under the RCU critical section.
> 
> This change addresses the issue performing the lookup and the endpoint
> update under the pernet spinlock.
> 
> Cc: <stable@vger.kernel.org> # 5.15.x
> Cc: <stable@vger.kernel.org> # 5.16.x
> Fixes: 0f9f696a502e ("mptcp: add set_flags command in PM netlink")
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
>  net/mptcp/pm_netlink.c | 34 +++++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 9 deletions(-)

Now queued up, thanks.

greg k-h
