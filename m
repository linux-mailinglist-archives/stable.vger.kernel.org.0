Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29CD20C85F
	for <lists+stable@lfdr.de>; Sun, 28 Jun 2020 16:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgF1OP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 10:15:56 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54177 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726344AbgF1OP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Jun 2020 10:15:56 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id F12E85C010F;
        Sun, 28 Jun 2020 10:15:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 28 Jun 2020 10:15:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=OcSkYjbF8K7CYQzUJ2xEpYaoK3o
        iRxtnuydqmK7xetg=; b=rghCKqeMb3qZnuh8PjTZZ8gmFY6Za6PxrG5j5sJbIje
        FKF7Vh2flDSxvvLMHxv3rwqlmAegU30E413MkK/BxQKR7L9OZMVfUfPbMI3UMxdc
        Yj/i4Q9ssDn7QLPuy0KA2W94ZdcTIjszTt1NRgYJUzEeFobekwpitXFxn+nYC6l0
        ruY/ztD5cFzScje1UzoqWq4s/zgiNBury8eYMifHOaNFBGbVnm+locYnGvbvwlwr
        bjQBX2R5KJL9ywbJmx3qBmzSSDPkbcxAh9ndc9mDMj8cvu73zl2uVIGcX3ojERZL
        zDXT9f6bIAE8efyNk9hhQ9xIoKaYifTjcvz/x0Om/Lg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=OcSkYj
        bF8K7CYQzUJ2xEpYaoK3oiRxtnuydqmK7xetg=; b=kc6KnikgP79NhlR2ZzKcmv
        QPUQbw9Fgn1BxecjeldrmDIVXD4MY2gyW3e5sYsq7FyrXghUvzbLllv4mCos4Qae
        2L5iVdEkFW7vWF21i//QamCBOKYbggPORcpdSl+eMQQh/IDNCqZoc23L3mTcpcKJ
        ZEX+C2oSvokn/8w+i8DJ3PWJPMnIamtkyLarG0+pFKyilB/dPeUQM11qnobW/vEE
        YBTl8yVSOy5b/6Qb5XgfSxTTLVrkGApD0LZQ+LyALda8574/yb3gZkFSj+wgb1Cs
        Cl5FIt+TQrsZA8YWTUgALawFUxXWQVkVmEYLFhlVXtdjJHF88z+MI1GGpx4WfZfw
        ==
X-ME-Sender: <xms:Gqb4Xra4Wv7ukAjryv4k-CXHBhpcQhlEvPGS_FPi1reZTnlWjBSVng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeliedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Gqb4XqZFUjK71irRrigBb2YrG0tGgJidUioDvOnicYK80J2Dr92xiQ>
    <xmx:Gqb4Xt8jA3jRMCm6esDisYgv4_VBWAC8iN8gKFmj8s7qialXqZvh4A>
    <xmx:Gqb4XhoMCKT-zIJ4I3-Hx5ML_I4r-dWeWetaKAQGNbrG23HRbVWoCw>
    <xmx:Gqb4Xj1ECWuuwVwot0dw2Rl4dCDkz7ETlfwlnDoNFMu-XmKCsOlR_w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1939F3280059;
        Sun, 28 Jun 2020 10:15:54 -0400 (EDT)
Date:   Sun, 28 Jun 2020 16:15:44 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200628141544.GA3205457@kroah.com>
References: <20200627.175512.748691393060790645.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200627.175512.748691393060790645.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 27, 2020 at 05:55:12PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.4 and v5.7
> -stable, respectively.

All now queued up, thanks!

greg k-h
