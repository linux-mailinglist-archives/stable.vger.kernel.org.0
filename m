Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C248377D31
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 09:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhEJHff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 03:35:35 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47089 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230158AbhEJHff (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 03:35:35 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 77A415C0145;
        Mon, 10 May 2021 03:34:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 10 May 2021 03:34:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=M
        gzGV2kQgNQylL/+aGD6XS2IKaJapAZ8/XfT9g2ZKOQ=; b=nQgU8/Z70JgrmbbPJ
        akBBzPvtVVm7rQc9umimnT1RCpH0bAkHJVSx9vxoIQUc27MRxlzMtvxjCHRS7oew
        g5mChV5nxoNH3kkgZ50EXQVtrdQf+MOYAwlMvfrQIoukxJmaC4RLG+qdvLPv4Avh
        BiklnCqxsLWPoJqSVNEeOcXcPNs8CHyIT3fCSwg2dhEYnR3C99oG5oIssEVPTfqU
        WsIjBw1Y1V6FRCBpd9zXDcp0ATiSBVJKAcBIVRnAFpBuMo8eaVdgSA8qs9Uz9xf2
        yKDdEFa1/BCZigSCx5R/F9yteypYP0rTR1k2ovaDvj3nSW5XEfzvgx031gb+1oGn
        rnBFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=MgzGV2kQgNQylL/+aGD6XS2IKaJapAZ8/XfT9g2ZK
        OQ=; b=k8Wt4wHg2Ae/HVp8DwspzWRDU9Ywc0qcLitIlZd37q8/O5J+jiZHjBIfR
        OZyPQtREQVM8MJyU9GeXhoSY+CUy7v/SS/nurvf+tqDEUIW/U4UDa0Lsh3EDmxgZ
        QSQTpg3yDqCiVk38GJTj/NZTFjxwAjztdCbHOEd6HEJjTRin/tgNiCB7QeyB+Oqk
        HCADv4t9obq2OHQx7T30lBN2ZQDM2JijgWDhKey3Eg3qhY/1yaBrRBEqX/KQHja9
        dUmIq2mBqKzddHsaDzD+m6HDyiCV+2s4hDPOt/QSoRX1GQbNHA3l1UzK5EjQ+UgE
        5vl6fF4ava0EotbdNRbMX8wGOy1EA==
X-ME-Sender: <xms:BeKYYO0rMvPaxRN1F12nodYyQHCT37K5rrBobeO2zuZpCXMTk2-UBg>
    <xme:BeKYYBG-RexTnQZT48ftyF7qA44a886w73GDC2-37cQWrDmcQpXGm1L92WHgh2Fon
    5UZxTY18H4uDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegjedguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevtd
    eileeuteeggefgueefhfevgfdttefgtefgtddvgeejheeiuddvtdekffehffenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:BeKYYG6LgS8V6GOPfHcPFkea3Px7Rp1ABTRR-F9LEWbUKHiPxQfIvw>
    <xmx:BeKYYP2duM9Ajv2IahiuvabHl5C4Yfzg4zuL44b_SeeS7WeHBKP24Q>
    <xmx:BeKYYBFXDJcfSQgNKHimZURmze0_yKFsLCUTPGFp3E0Oxq6YWqvqwQ>
    <xmx:BuKYYBC94yVh5gPbv2qQsLjqskMIBo9V55XYj1bafiTl1le6EQIxXA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 03:34:29 -0400 (EDT)
Date:   Mon, 10 May 2021 09:34:27 +0200
From:   Greg KH <greg@kroah.com>
To:     Richard Weinberger <richard@nod.at>
Cc:     Joel Stanley <joel@jms.id.au>, stable <stable@vger.kernel.org>
Subject: Re: JFFS2 Backports
Message-ID: <YJjiA7EaAOgPEHUV@kroah.com>
References: <CACPK8Xe9K5QzfY5RnfhGeX_x7x7r69+uYSZLnafbh7j4B525jA@mail.gmail.com>
 <1496964795.7092.1620629026246.JavaMail.zimbra@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1496964795.7092.1620629026246.JavaMail.zimbra@nod.at>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 10, 2021 at 08:43:46AM +0200, Richard Weinberger wrote:
> ----- Ursprüngliche Mail -----
> > Can we please have the following jffs2 patches added to the stable tree:
> > 
> > 960b9a8a7676 "jffs2: Fix kasan slab-out-of-bounds problem"
> 
> This one is already marked for stable inclusion.

And it's already queued up everywhere.

> > 90ada91f4610 "jffs2: check the validity of dstlen in jffs2_zlib_compress()"
> 
> Acked-by: Richard Weinberger <richard@nod.at>

Now queued up.  It is already in 5.12.

thanks,

greg k-h
