Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2B632D467
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241446AbhCDNnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:43:15 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:42311 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241466AbhCDNm6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 08:42:58 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 1D1701366;
        Thu,  4 Mar 2021 08:42:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 04 Mar 2021 08:42:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=aDFOXRnNasYJKhA1/KLrLm+lMbO
        DNlRZX4sAgWW3gOE=; b=gKPm/9BluuzT6UmbDhAiVCBUuCwR4VHTCi2AKaAAxpS
        Ajtyi3al7f6gPf71HAZP0GslGdUExYb2yM2CTMtLOuB6kcarlDGyccd9sktsZ1Yh
        3iA7EulzdmNlapsoKJhfYl1MDFjAlUMEMs9hhrpNI1fsV3xqiNBt8EjJAZxYdF+f
        PZaq+I0VTube0ChoLS2ceZ3WDTQ1rxz05x63dgR3sZkMhfdDKwx1PbjUr1S5gCV8
        0RDgDeST2XxdYo+n57CrA++67GDH9mg1rxNGcjtbOHrPKwD/LdeWBE69Q1XCTo1a
        W0GZr4cHQVnFGC4zPs44XWS3iR/6+AoX21OHLvIIE2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aDFOXR
        nNasYJKhA1/KLrLm+lMbODNlRZX4sAgWW3gOE=; b=KdJR4yBkT7QOtSEDjM7JNi
        /eUgSeHDPi9DH6A5JxAijL81PwQLQd/D5j6IS9AnO91LcUOTsmN0asJA5zagJj3s
        ukyuh0b9AzSbCNayCC20lVM/NrdEl61ZsGW2U5EE6XWXZBuIWRhmv0Z2bQsFXQ1H
        tiGMDSm/faT96n4KOtvuPIRyveAIPIAyrPr559wcqeklxBoRBPcigtMa2sbgbn6D
        P24MxLitRpGzvOU6eWWvt/CYMwGQVMoVtD4ovCP3h1BkcNq070bsLASgLjzWl9f7
        DfWVVbP8Go+N6vbg7aC46XwqvfnKXZ29HTUZldYpZkEXCTAteHSbWA1itf0Hy9HQ
        ==
X-ME-Sender: <xms:tONAYK3jSwmN18_xI3M002XAvyAcZfFehmHjITgWcML_AdUvC4nDoA>
    <xme:tONAYNF6T1Xa6SDqkKJ0vqRjneKG2214sMPIIEFfptHlqQQk7YapOrQKSbszIpTt-
    eg-IN3xBtR9Ag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:tONAYC5pOylN3DqU5tcz-8u-mcpwPYT7SSv-4hXuVYIGHgAtiGAV_A>
    <xmx:tONAYL2IFg59vwcPeQ33fR_c85qWs46xjz0B5c1r42Lc1CnpxzRHfA>
    <xmx:tONAYNHK8W4ZiORBOgMU22Z3Ea9Ko7BNth6x7uZoF2Rx9awG13mb6Q>
    <xmx:tONAYLMOfRF_5LkO6h2U9-HGqkVQ4Mx3M2eUS84_YPZavIvjBifUXA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CA1821080059;
        Thu,  4 Mar 2021 08:42:11 -0500 (EST)
Date:   Thu, 4 Mar 2021 14:42:10 +0100
From:   Greg KH <greg@kroah.com>
To:     Marc Orr <marcorr@google.com>
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 5.4 1/2] nvme-pci: refactor nvme_unmap_data
Message-ID: <YEDjsidRbq4CGfVW@kroah.com>
References: <20210302173911.12044-1-marcorr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302173911.12044-1-marcorr@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 05:39:10PM +0000, Marc Orr wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> commit 9275c206f88e5c49cb3e71932c81c8561083db9e upstream.
> 
> Split out three helpers from nvme_unmap_data that will allow finer grained
> unwinding from nvme_map_data.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> ---
>  drivers/nvme/host/pci.c | 77 ++++++++++++++++++++++++++---------------
>  1 file changed, 49 insertions(+), 28 deletions(-)

Both now queued up, thanks.

greg k-h
