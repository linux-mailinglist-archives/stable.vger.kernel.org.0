Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A8E1D6287
	for <lists+stable@lfdr.de>; Sat, 16 May 2020 18:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgEPQOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 May 2020 12:14:40 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:55491 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726210AbgEPQOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 May 2020 12:14:40 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id B17FD605;
        Sat, 16 May 2020 12:14:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 16 May 2020 12:14:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=diDMzxZYU3myu9ow771aoBjxi0Q
        MHriajuyfwMm4S70=; b=GqvySFOGisCUlhhZhk/J/XxqUK/aD1oMUDHqHSHTWnX
        92/VZgqX3ActzL5Cqp1mmKEHvOcxmOgHCQhpH9fkM/MOfCJTTly9SOocymG/DKeV
        GKnG+edqQAWb8fx7WFCalyK+gxtac+/vpG7QM7r6V2Ky1V0WseVe0TKeiP/FEQhE
        WKiq6QrA3cjcAdB6+vhC6GpvAb0RkpOVdsMjYILGNgAJvA1GfT2IAAlz71fc4sSo
        z5F2jsovPQi5+up/6HwWMKTIpBaeun6J4tdA428EQR32XTAZ2MAr0sk5z2Ctv240
        zbKc8a30VgAZpQMJm3M6+USrock7G35IYmZK2MMDSUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=diDMzx
        ZYU3myu9ow771aoBjxi0QMHriajuyfwMm4S70=; b=UTsX0dd9FoUGqpezsZNBuB
        r9d5AS12qwQ7qHOUQdlaSJAJiWP0YmtDjBwi2UyHf+Jiiir4joaSTq3dSyH1sZIC
        O+XXLsQdM25Bab/rhh1BwV4z5duDOzi8/V/vnIFEPaEaa7Nsz4daWCQCuZ6AgGAn
        4Nf2yv4g13XGwzVBPe0PEBLx0KYP61PM4qI0VXdzu6/fEIG8UeQ6PMrbuXkaJWQF
        lQu87mbTMfFlxG0bWHU9Pv8z14Tjv65C7qOJefBt7n3MbVproOfXkDLXmjdIojla
        rzMPkoPoLHFgjO3+RwdFU4prWKI4WFosajpNkUQk4/VvF49OFfVtObp8yIRXyZKg
        ==
X-ME-Sender: <xms:bhHAXkjq4LYdZa0EKh3-wWQOOI17OFg_oLH5tA3kvN_EyLjNKr_byw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddttddgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:bxHAXtCMlqJVoq3Mk7RwP6WzrQkvO3UG6lK-eygMcv21nxMMIoHXvg>
    <xmx:bxHAXsEsvaMDHXa-LSkkazdAKSg5rE4guAJWctfOW0rOncgc1XKrwA>
    <xmx:bxHAXlTgkJKiXXDRdSVFuSQDX0XzPHuC3exOfFfo-3vTzzXLEHlBIA>
    <xmx:bxHAXquJsXCrZrWCwfSa0qSS-WixN_DxexVStOlwFVxVWTVY5Ay-YA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A79EA306638D;
        Sat, 16 May 2020 12:14:38 -0400 (EDT)
Date:   Sat, 16 May 2020 18:14:35 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200516161435.GA589789@kroah.com>
References: <20200515.174410.254894300117278289.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515.174410.254894300117278289.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 15, 2020 at 05:44:10PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.4 and
> v5.6 -stable, respectively.

All now queued up, thanks!

greg k-h
