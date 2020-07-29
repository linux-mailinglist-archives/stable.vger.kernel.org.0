Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200D2231D93
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 13:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgG2LnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 07:43:00 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52443 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726365AbgG2Lm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jul 2020 07:42:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 90DCC5C00A4;
        Wed, 29 Jul 2020 07:42:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 29 Jul 2020 07:42:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=CRYUrs+lke4hQzkCd/ZKDB1Kzeu
        02GsIZREf0ZZqge0=; b=Yem7fa94JNaSXL0cdsVefhzNGFK6kOifcfFxqSVDLqp
        DAUwnBtXQvNk/Y2NwichZVnRZh309+fCxe5yFXSXzsk+EktpU4gHyxwy6G9v/TqN
        pMmVG7v5GnQpcV4VIhjyIgPeX2saiXdkUglbGX/hL/nq6Gjyoq5+S9xDLKJUQHHJ
        RTJh2+86AaSjAmk0+GiISgwuNdzBoaQ3Lloz3VKS6pSNl76edkqoWpWl63w3YBcq
        8omrYDbh/ig+PqIbYsW9RnEa3LOEWkTMZRWIq8hppz5n3S478XidGQuoQEob0Y7E
        u6dXrdPGoTIIx3+mBrXySNpWSbV7JnDbsNIIRmQhhdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=CRYUrs
        +lke4hQzkCd/ZKDB1Kzeu02GsIZREf0ZZqge0=; b=r47oQ7vZ4Wr8QPaF2w+JPP
        8li1WcNyVIC2izEldm32wy5LUHE4p9EZhExacTDp1DIWAnIdrKP0HN2jz0RjapID
        jY/RML/0+blTYojphjqfBHXf/zQAxZ+QTT8wBsZ2+nUrGYXRY3tqM039JbuU/aFV
        Lzrk/4rRvRmu+rXDYdI3TB1LnZA8363PluGbRbUauOquTPVRCn58GBg3MXuDnjYi
        LLDgURck7C6ws7UT5AfXEKYnmzxkUmPll0ot/8btJNo+lHWHhy39+GJh/AAu4V8m
        2VoQXA5e+clJd+0YnJJzh8SlM2hXXSERqN3fbMfZ9T+fzzjGf5+Z4OvuEH3EtWqw
        ==
X-ME-Sender: <xms:wmAhX10-IzyW-3pCUpTHvxSWP6ZKaummv2jowfqLsFPywAQidHe0KA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrieeggdegfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:wmAhX8E3u7C5RMg4NnV920GLNYg1u8mn_w_toRp4nt2fdbHd_hdm5g>
    <xmx:wmAhX157Gi8BKpSIJ4n7WLoIkGy6dqwUva5IzomLor-BmLVzR6bW5A>
    <xmx:wmAhXy1nqFzOumUZns6y0H2YRsH_KW126Xt0jTbSG_Y_a2H8bTwfRA>
    <xmx:wmAhX8Q3CPejgRfN8LlPIUaQBQXC0vlbX_3xDQ1VX6XVkZOvMimqEg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 175E4328005E;
        Wed, 29 Jul 2020 07:42:57 -0400 (EDT)
Date:   Wed, 29 Jul 2020 13:42:34 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200729114234.GA2663520@kroah.com>
References: <20200728.201225.326596561038069277.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728.201225.326596561038069277.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 28, 2020 at 08:12:25PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.4 and
> v5.7 -stable, respectively.

All now queued up, thanks!

greg k-h
