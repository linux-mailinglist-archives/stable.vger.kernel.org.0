Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555453261BB
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 12:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhBZLEc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 06:04:32 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49999 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230430AbhBZLEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 06:04:21 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id BCD045C005E;
        Fri, 26 Feb 2021 06:02:36 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 26 Feb 2021 06:02:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=C
        Z2O07BJViQR9CxHpGvrSnFxsJN7ZsihXrlMMEDT4xY=; b=fy/bXOO/hPTQcQBy3
        SncVeaCfKEF/vOucDsbmRXqqeyG61YR8uPEQ78tqzy/7KdK1A/8s6aLn+Ycr2oDj
        SYwgVcni/xTI3KzQD30sl2CDFR8hpqQaw3/i5h+zPCqAhelGTvStN67xGTHzsmky
        7C2PgzpdvmtuNg5eZnUuXwHfE5ANTYbtCIduoPkBJWo3Bsy661lBZftw3JsVAR/D
        y44bbUHhKR9U1haeFxmWXr6M50cjJDUKQm4V5begVI4cB7L/FfqpPSsZ2OV9sapg
        cLwuiVhcCtOEaYWaExIDPJOEP+BilfZ1jjgbof+wednwcg69cGCx/PzUivxxUKjU
        e8yDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=CZ2O07BJViQR9CxHpGvrSnFxsJN7ZsihXrlMMEDT4
        xY=; b=aWWPRvpOHg5bGYudiiOwOgNYvM7OK0kJPV6oC1ucGg3K4GsrP5pah84w0
        oHKKcQj/Wo2odNjy1c0+7DBCAAo/8rxxG4+C7LmkpTaIKy0joix+Oqn9S+u+Btlk
        oSfPGli9SetsFgwWHDUNruAdH32V9S/53FlVGnivBxonSzp0HWbp/EI1izhGeOc3
        Fc31b6FdC0dgrr86FetHDTMRFaV1RRTTI+3GTo3JGTioI1pfoSYlOdHsngWfrIX1
        JXlF9HakXC1mgs0U6tZnKRaf/PysjAtOcan+saFRTa1MO3MkuDoIo10rO60bBvC0
        48FHXt0iB+KCkdm44t5Rb8qsswjkw==
X-ME-Sender: <xms:TNU4YO_2ky1hQot727ctus235LEjZLsQ3-kCh2nNZAjaTdAKZMxLeg>
    <xme:TNU4YOv5JIbsBpych4w1rU2xLpa3rDTo1Rp6SjfQygHzmbA--PXO__DJ5ieslfZzm
    ADMXU5EXXmKAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrledugddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevtdeile
    euteeggefgueefhfevgfdttefgtefgtddvgeejheeiuddvtdekffehffenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:TNU4YEDjS3y2EfM3cLtRBmvtNpotc8AD7GvrNArcpkZtx1fRB9wa2Q>
    <xmx:TNU4YGeuXl70BIT9tEwt4jq__UakDcqPC-sln6sk1Qwh-UpflFyfgw>
    <xmx:TNU4YDOQOJQ0gcYx7w_6Dgx_idxLozxSXBUnR2VmXnbocSOWqBhOlA>
    <xmx:TNU4YFUoeug11KO93PTC5kDzTtnh07V6ltaZI9Z_IzuPWmzVX1NYKQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 59E221080054;
        Fri, 26 Feb 2021 06:02:36 -0500 (EST)
Date:   Fri, 26 Feb 2021 12:02:34 +0100
From:   Greg KH <greg@kroah.com>
To:     =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 5.11.2
Message-ID: <YDjVShQyMIVWfZU7@kroah.com>
References: <1614334214168@kroah.com>
 <s1ak0f$p2g$1@ciao.gmane.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s1ak0f$p2g$1@ciao.gmane.io>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 26, 2021 at 11:54:07AM +0100, Jörg-Volker Peetz wrote:
> Hi,
> 
> thanks for the upgrade.
> There seems to be a dangling link in the git repository:
> `scripts/dtc/include-prefixes/c6x`

Is that new?  What commit caused it?

thanks,

greg k-h
