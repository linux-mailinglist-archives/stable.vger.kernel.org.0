Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C711D0C5D
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgEMJhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:37:06 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53065 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726891AbgEMJhF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 05:37:05 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id B21575C013C;
        Wed, 13 May 2020 05:37:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 13 May 2020 05:37:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=/bysaxoFtZbhiN+/iyGCIki1PgJ
        2l6ObgRjyef/n24c=; b=fZjHTrcYUkiYlxB6MVffUDow4uT+x5m3+e+TXojI8E3
        4DOBIB8xnsQCBqNn8pWz0LmV/pqM2TU9MY1hzwJ1oyQVwXW12lIpbMjE3o5318j8
        h5EJc3cbaM8cXne6R+O8Noz/wekKbRowVTZFt0HfQ/SqAsHfhf1QR4WVatzEl50v
        XAXeCQrwjQAieKkrqVe6NXkyCAXXfU3N26zwnkgjpnpOF0D+POqBWb8OMF5wAX9w
        hHXGRTisBLLKFtzuz2uv/N5C+Y21tmHTRDwK4BFGOJsZHnH+aC3xP//Uy0mOTcLr
        A3gwHnqbBvcoLrlSThcFlyRDFJKu8gLKQKFO0N1zZSg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/bysax
        oFtZbhiN+/iyGCIki1PgJ2l6ObgRjyef/n24c=; b=x9NWzWVgoPr/zYiBm7OSY0
        CbeiS+ASo8nUf9hz9K9itBbTMSZVcBKSsMN2ofK8DG1bLYxnActe73u995tyvXdW
        bbzFWlKTZcHcklQXA54h5Vde+r39f1oHB/d6Hgdrziqm6qZF8bSDu7VvpeNo0M9S
        BNYY7rZ14aZF0ORe1ZSZFlryuO7mHPE4NhTViB6DBKYK5XYB9IpoossdJpZDHb4A
        p68UAThjRTQKUB0wJNNAqTelOL1YonFv12yvxunGrdaHAjfXWHQgItDZnpAK62HY
        MOuH3hCWXfD9sIU2Tolo6k9q5pWaLmT9vT4DhQ/oN0gB+RixiZ2hQuyDJ3oLHIsA
        ==
X-ME-Sender: <xms:wL-7XlIywqC7E2wfvKx27ZNdr_qHOWrH-dq_husRAGtWuSpo7dUF1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrleeggddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:wL-7XhI1c7NXOUiaEghTzAf2IHu44xTmBmyvXpCOGCuTL8_1OwbcSg>
    <xmx:wL-7XtsctGmVcnPS20qqEHaeCC3RAmCGPqb8zkdSegk_kbfxeOcu0g>
    <xmx:wL-7XmZ3ZJzGpAW1T-2Wg2Er6-7d3Tcdlh2YcNQr1L1yXav33st2dg>
    <xmx:wL-7XlDaF9eYh3Dp8LYwk9ez6wJlW3853KJTltxiJzQAAMhudRh5_Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 32A3C3066309;
        Wed, 13 May 2020 05:37:04 -0400 (EDT)
Date:   Wed, 13 May 2020 11:37:03 +0200
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 4.4 06/16] clk: Fix debugfs_create_*() usage
Message-ID: <20200513093703.GE830571@kroah.com>
References: <20200423204014.784944-1-lee.jones@linaro.org>
 <20200423204014.784944-7-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423204014.784944-7-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 23, 2020 at 09:40:04PM +0100, Lee Jones wrote:
> From: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> [ Upstream commit 4c8326d5ebb0de3191e98980c80ab644026728d0 ]
> 
> When exposing data access through debugfs, the correct
> debugfs_create_*() functions must be used, matching the data
> types.
> 
> Remove all casts from data pointers passed to debugfs_create_*()
> functions, as such casts prevent the compiler from flagging bugs.
> 
> clk_core.rate and .accuracy are "unsigned long", hence casting
> their addresses to "u32 *" exposed the wrong halves on big-endian
> 64-bit systems. Fix this by using debugfs_create_ulong() instead.
> 
> Octal permissions are preferred, as they are easier to read than
> symbolic permissions. Hence replace "S_IRUGO" by "0444"
> throughout.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> [sboyd@codeaurora.org: Squash the octal change in too]
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/clk/clk.c | 30 ++++++++++++++----------------
>  1 file changed, 14 insertions(+), 16 deletions(-)

What about 4.9?

I'm going to stop here and wait for a fixed up series of this, and any
newer kernels that need the patches as well.

thanks,

greg k-h
