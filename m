Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747D81D4F64
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 15:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgEONlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 09:41:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45283 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726174AbgEONlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 May 2020 09:41:00 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 297515C00F3;
        Fri, 15 May 2020 09:40:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 15 May 2020 09:40:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=CUPzAAljkRlg9vWIBad2c6jdEig
        CeQzuRQjidwwJgVw=; b=bUq5pWTKcvaiVN9pEUr5Z4mJAdYu/Fievg2jdHAvEbl
        oTp9Px75BAFJ9TLyeHUvURqAWd9jzIvgQB+LjIu1aWPqWZ7uu+DNJQuMpq2vWmwK
        +LqyDeONZYTI//tIfls11UR7SJMBMvftEOWdOb4gMPSf5Ikemr76MC9NbgRHGvNe
        PXYnjomWOBoNXKlzSCt8xcaXdwSmV4t+fuV2YU+GIsBpoymUFMRzmJHqRTX2v3DX
        klZB2AjXIZpBqAivJtfGLAc/GO6t7r9a8giilJPvM0IKkzUaLkJMGo2sGfmfCR0O
        NEMYpqBgmT4l+RS4Vp26WTPi05pIJdoFsvC0hT3DTVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=CUPzAA
        ljkRlg9vWIBad2c6jdEigCeQzuRQjidwwJgVw=; b=ZlbLeNnYkc9jau46FgwnNl
        zXq9ZqF6btJnzXIR/zgIev7K5VotCyXVF211Q+oXJ5vQPzRSjGKwOqdS4aKHgbaf
        QsmYQM7fAXpms2qL2/JShWUZR+cBDjXHVGf1zT5VmTd5ZzC3M+y9/uKmW7+ZQefd
        Yjgw0U3hx4MPrSpdiLabhkb3Asxq4FZBdIk3cIRQUdJLvk2HOLvRj3O3PjYaA5+w
        xXK9BMLAtBovWRupiC0vvoUyv9J5Y+9y7YMtViYIWo84KKh4mndPWuQtGu35ZVVI
        T/noXiaCEnS1dA8vgvGE1jK8lIJtSvAHbkDyB/xWtKHwjjWAjWiLmdeWoHYLrKcQ
        ==
X-ME-Sender: <xms:6pu-Xq-y-u-1PcwVxtTbMHq2vlp-YE4x9t4FGheQkkLGXxKS0z0Q_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrleekgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:6pu-XqtqkS1cgHmbF4FykrlwCiwdAgbgKjvyCV28GzSbgw_9mqBNYw>
    <xmx:6pu-XgBlxKPnC6ZauiD51C3NiYJz7dI03m600OPb0GUfycmeNtwHgg>
    <xmx:6pu-XidtQI4wHSumoz-uebNxAMdmtDXvizlRFkTNms25vaDqigUdkw>
    <xmx:65u-XoZAOj7PjI6GUS20KfeJfadc2NczrUvcNIgHilZwohTvyZjzjg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 34054306634B;
        Fri, 15 May 2020 09:40:58 -0400 (EDT)
Date:   Fri, 15 May 2020 15:40:56 +0200
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Henning Schild <henning.schild@siemens.com>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: Re: backport of cifs patch to 4.4.x and 4.9.x
Message-ID: <20200515134056.GA2051562@kroah.com>
References: <20200515134420.50480bb7@md1za8fc.ad001.siemens.net>
 <20200515125748.GA1936050@kroah.com>
 <20200515133159.GE29995@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515133159.GE29995@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 15, 2020 at 09:31:59AM -0400, Sasha Levin wrote:
> On Fri, May 15, 2020 at 02:57:48PM +0200, Greg KH wrote:
> > On Fri, May 15, 2020 at 01:44:20PM +0200, Henning Schild wrote:
> > > Hi,
> > > 
> > > please backport the following path to 4.4.x and 4.9.x
> > > 
> > > subject: cifs: Fix a race condition with cifs_echo_request
> > > hash: f2caf901c1b7ce65f9e6aef4217e3241039db768
> > 
> > It does not apply cleanly, can you provide a working backport so that we
> > can queue it up properly?
> 
> I've queued these two for 4.9 and 4.4:
> 
> f2caf901c1b7 ("cifs: Fix a race condition with cifs_echo_request")
> 76e752701a8a ("cifs: Check for timeout on Negotiate stage")

Thanks!
