Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7BF392A9F
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 11:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbhE0JWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 05:22:53 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:46851 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235608AbhE0JWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 05:22:53 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id D8350F43;
        Thu, 27 May 2021 05:21:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 27 May 2021 05:21:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=f8k2TxQDJ/UWFTsye+bRNhUXdP4
        NpOxSwSpuAiFWXBE=; b=tFQpwtb2y55uipH9P6Op0ltEzDpIFd3tr+nds5JzmkJ
        8YSQjtue1b+6slB0iJi5pOIXHx3jp80D4mC96bpQCKt4Xq2rDwAAbP36ry1nDD+3
        jotXP89v6CmBW2zJTE1nxmbUh2hVF4ZWBm0SG1bcdWe7XD6TvMrOkacBZO0Uhf/M
        A7Na54HpjVhRHYma7bVnKrqUjTUoBU8bLqoU/osLUfKtCq5HvjNUh0Y9A1sERrpY
        dKva103ia6GqGjNfQIMKLz81IuAOAWG4L+zDjdsxRvgsG53CNBlykEOhdKRvk+yz
        pdeZrDMLTjClDPdhualkylNkTFZQKesLrOy0qvQF0lA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=f8k2Tx
        QDJ/UWFTsye+bRNhUXdP4NpOxSwSpuAiFWXBE=; b=Ry3c0Atvju8K2zAYYb3Ffm
        8gebIqd6/ksBLGuiGh3HHLxeprLmHyfjKowHWASSM063gk551nrrmjRo6ObNFQIl
        AM7YmxKp+ZmEFENHVEoo4UvdWAxpIrovs75GHC/kgX9y6zc1FengzXCJIT1LIvak
        ntBFjMUr9f1/xrWOPvpQx+QUXQ3GdmXBpWIKMuGyQFLGFI/6vGHNdo0/b+nyx7Q1
        G2sUCgW3O1Fhl3LR8nxpEANkfUEB3toNdml8faLeI0b4sLSgJ2r78VIIgRrhniem
        6nNVfw2DRKsnLiTH98FxKMUAGRJbTR7d5U4QN1Rgt3Cu/kgB68UqfV/Yh18JwVHw
        ==
X-ME-Sender: <xms:jGSvYMSCjR8bVZJ-Qm84L-HpcYg_QNdQRuB-82fftCRhvzOSHELwqA>
    <xme:jGSvYJzhYl-T3piqQcDR3qCNulPpVgAFiEm2SSwQP3fRzpz57fu6JLQ1-CgDK46hd
    rLqcE340px_wg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekhedgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:jGSvYJ2P_K49qdvaB8ca7TqfBHBQ7ylANaOkDvnOR6NsH1ZqEQ1gyA>
    <xmx:jGSvYACgLzrhd55cf4g2iZFNABS_w2cWABbLfvj5WuOh0odHWX6izA>
    <xmx:jGSvYFjkSkzACI4d8hjR8uAziq5YSuAVqGF55gZxxuwv93mOHODHNw>
    <xmx:j2SvYFar2k9ZtgPpzlrGVVsMnkPqu8WJS6-_qXawtT6h-ASfODHpKA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Thu, 27 May 2021 05:21:16 -0400 (EDT)
Date:   Thu, 27 May 2021 11:21:14 +0200
From:   Greg KH <greg@kroah.com>
To:     Nicolas Schier <nicolas@fjasle.eu>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.14 0/2] Allow builds and script usage on current systems
Message-ID: <YK9kivY4s5OWs7sJ@kroah.com>
References: <20210526041728.4114392-1-nicolas@fjasle.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526041728.4114392-1-nicolas@fjasle.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 26, 2021 at 06:17:26AM +0200, Nicolas Schier wrote:
> Current distributions start removing support for Python 2 (and thus
> /usr/bin/python).  To still be able to build v4.14.y and to run
> supplementary scripts fix shebang lines to use 'env' and switch
> diffconfig and bloat-o-meter to Python 3 explicitly.
> 
> Python 3 availability should be given on v4.14 based distributions
> (for comparison: Debian jessie 8 (est. 2013) shipped a 3.16 kernel and
> Python 3).
> 
> Both upstream commits are originally included in v5.11 and re-applied on
> v5.10, v5.4 and v4.19.

All now queued up, thanks.

greg k-h
