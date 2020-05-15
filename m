Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5761D4E3F
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 14:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgEOM5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 08:57:55 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50045 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726162AbgEOM5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 May 2020 08:57:55 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 0139C5C00FC;
        Fri, 15 May 2020 08:57:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 15 May 2020 08:57:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=yGfTBbEn12x2aYPGCj4Ld+cP/ES
        aPpzYxtnjwHiaM38=; b=LhUcei5zJ2k12/Dfk1eFM1g1E8kqC8GWbiCmVLR0AnH
        5VpbYwYuv47VW436UcklP0KpqLWueCSv0/qbIQb7d1hkKddQH6b/hH2sFBC/8G9L
        tziM9MMIjfdR9aJMHC1gR3SdaHChgjnaGfFKgxaz4gR2o8T/wk01qG3TI23TipgY
        HFJIE5353SHc4+cWKczAmXbDvYQo4c06rd6zGQ0/qo1Xsu/PrAQ0nbwi9RAz/ujp
        ClpnMa8mpPPktkb66z4Z85RFGYfYJu/gSAYLM5wtgc8Qd1zWLzA9f3qgSkYXZAmL
        IbDu35fECFk6bbzskfxlC+uxSTe8MaB32+RAT/h5zIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yGfTBb
        En12x2aYPGCj4Ld+cP/ESaPpzYxtnjwHiaM38=; b=pPrgrjpqyCWTTOHZF/PAMf
        J1p4AUigd/MJyMNhik/HRrV6WSJQ5F3FBRjcyE9HMdipFTAiJ4Ojubp1lrELPKxX
        J6xP5K4ioD8/LI1uvdt82DBTH9JCV+AVD3SxpUtjaLEyd9LzlaUEqzfHgnwGi+MC
        p2hQ0UKG4dcucRv674TjuzlMxcwDhWjQpRZlCQ/tfuN7Do/7BHBm+pcfLzBO4IsW
        iFt9cfsf+rGh+wf6yPoOYdm7zOVwNcfJBUYI/XPal91hlBcsfQBq5cwG046SCT0J
        +1ggvXqr0bx9VXS5w9eXdVi1IbfU09KbNtRoEaO1/rLopBRNuiqjAM4uAzk0EP4A
        ==
X-ME-Sender: <xms:0ZG-Xmn_vb3CnOIu3Nm9fpyDFjLlWiMmk_pLfn93RN1IxCQiKett0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrleekgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:0ZG-Xt0xIEgkCLhjBKknPzqH2M7kMyb7FAWyFRNjR0JUH90dkdNuNQ>
    <xmx:0ZG-XkohnjeO-uhMhcmDLqcnYNRRbe_CRqOUW-9CUlLg_YYU8W3wtg>
    <xmx:0ZG-XqkUWOGoI5bhbRX2JMiOC7y5ffxN9URs4Y6GUGRdmzjYAzYcdQ>
    <xmx:0ZG-Xh-s888oKz-YbOKRPX8tB2xAMAs2uz5wu6jlp5ViT_N65L84_g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BBA1F328005A;
        Fri, 15 May 2020 08:57:52 -0400 (EDT)
Date:   Fri, 15 May 2020 14:57:48 +0200
From:   Greg KH <greg@kroah.com>
To:     Henning Schild <henning.schild@siemens.com>
Cc:     stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: Re: backport of cifs patch to 4.4.x and 4.9.x
Message-ID: <20200515125748.GA1936050@kroah.com>
References: <20200515134420.50480bb7@md1za8fc.ad001.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515134420.50480bb7@md1za8fc.ad001.siemens.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 15, 2020 at 01:44:20PM +0200, Henning Schild wrote:
> Hi,
> 
> please backport the following path to 4.4.x and 4.9.x
> 
> subject: cifs: Fix a race condition with cifs_echo_request
> hash: f2caf901c1b7ce65f9e6aef4217e3241039db768

It does not apply cleanly, can you provide a working backport so that we
can queue it up properly?

thanks,

greg k-h
