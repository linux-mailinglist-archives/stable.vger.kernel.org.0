Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE0F29EBBE
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 13:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgJ2MTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 08:19:41 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:50059 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725613AbgJ2MTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 08:19:41 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 407CFB3C;
        Thu, 29 Oct 2020 08:19:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 29 Oct 2020 08:19:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=z1jpc/+P501Z4Rr9gUEeTb2mzTN
        vqDSRhl+82jpcErk=; b=mReIW/FVWVSUePHNYFrJIj4CuTfMS8Z+9zJ/6RtO2vo
        UcdhHvSKNMiCfSL+c49XPmxoD4PaJpIeH/rAc3oaGyjfRu+wEqJC+SaQvvlLUjqf
        O1q4CvRYdCAK4JxA/sghnsxmxqOk8NRmZcbQbB8NxuUJ9bxipQnT+d/B2B1i/nLR
        qMNIBKumNhE5VlliD7IQKkDtBe0cRMNqeUeYZj5y/QvusgS1NY1x7mqCPpZJehBF
        XtxfBxqWTTCb4vNlbpqeFtfk7OA4T+19ymqGdL+5I98fXjtU4Z2l5N4ldB+nDo9j
        QimEl5PLnidL00Gv2YGew8Bf3kYmsVR/U4jQJyb8QmA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=z1jpc/
        +P501Z4Rr9gUEeTb2mzTNvqDSRhl+82jpcErk=; b=nRAK1n4nmnzIMM9sDt9I1o
        qUYxmkn0TkVLRUPPXzA3G6OI+XENRcUXB3zke8VwbfD5n0SMqjluH6yK1YzaaXRR
        xpzngRVZTCJgqSLHWur+3Vz3kZIZznJmZDBboRCsY2SZ0iRbN4mmeB5XjgJVB9xk
        uS5PXSjtmtNw3qAYvQqXpc2UTbW+VUqjFzTmqsKV/746jlxPXCSrk8FtXdCCXdes
        AwWuk34WSEZnRBdj4jVDwXMfrRg7Olqhks1Tcc3pyqDufze1Jbb9U8an6oX3PL/2
        yWFnGCVXWdtzI1r+1lV5teg8TSw+b1mrRrqfNIOv9/xLc7GwCDYWR7wChk6H4JcA
        ==
X-ME-Sender: <xms:W7OaX2G_zuUd2KIYUO7oC-y4ek2NiYXx2jSDd5LgZ61qrHVmMgp4UQ>
    <xme:W7OaX3W-WmyviyyIzCzFky6IzqsaVF9vY0K0rVAyeX_5YwnHaHU4O-MdPA22s9HlS
    gA-PbiijzHPKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleefgdefkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:W7OaXwKO_KqmDCkwsKjHTGxCgi7AntulMemk2iXOcvyFTPKDgYC57w>
    <xmx:W7OaXwGv2Z93Nt1gOXl8GDbOkvmcOzit-xdLP3nzwlZw1WPlH8NP6A>
    <xmx:W7OaX8UtGhIRGvPMw1sM1rHkItR96Gu7GlfjKyfj1lOv4J_udjTcrA>
    <xmx:W7OaX_BqqvURL4RNK6bEyXDWBz4_pux4VIoaKHdAA6PmLfxbtbdvhw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 358453064684;
        Thu, 29 Oct 2020 08:19:39 -0400 (EDT)
Date:   Thu, 29 Oct 2020 13:19:55 +0100
From:   Greg KH <greg@kroah.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: 5.9 stable inclusion request
Message-ID: <20201029121955.GA1620833@kroah.com>
References: <115609b0-9167-dfda-85eb-de8d87f33e75@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <115609b0-9167-dfda-85eb-de8d87f33e75@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 28, 2020 at 10:31:23AM -0600, Jens Axboe wrote:
> Hi,
> 
> Please include this series of patches for 5.9-stable, thanks.

All now queued up, thanks!

greg k-h
