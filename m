Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C226CC37BD
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 16:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389223AbfJAOlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 10:41:14 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:34723 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388938AbfJAOlN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 10:41:13 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A60314AD;
        Tue,  1 Oct 2019 10:41:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 01 Oct 2019 10:41:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=FFqKLIf6BfE9pF4MyEWXPwCgLk3
        IMPxYpxjWm9IhRy0=; b=lwkoH+/T2nfHwCotEu9EJHKVZFPaOu16ZXncKEjfcYB
        GAht9l8OM7RJ5p3E8PUZutMtKnlA85o5AHn49tUZtkTd6btp8CPSFbEVF7+6nZMK
        MfVA5dOXwK1OB05nl40fuOGtMG5UE4p85BrG09W0m9j1nkiRG5fYsySZfT3VaN+A
        zkl+HpBv1leDnlFsdZZ1ivqucaXVuoATgVUA1RJ5b2wLGBDUdaCxeZwelPt6Fxyg
        OEvxegwwO5u+ZducMPH4Fu59/7Ex/hygcItGn/HfdhL6QmHHqZioTL0pWiLVKi6J
        TrkeTuLxrK/wIh2XS1a/CY0wVZ9zsxPtYXnPM9GjpMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=FFqKLI
        f6BfE9pF4MyEWXPwCgLk3IMPxYpxjWm9IhRy0=; b=WA3a54zqungIVVvukXy3QU
        dgbk84IUX0DYXpMQ8fU9ubzbH3Pjd4K0C1TQhccNzUfTVM6n2k8l9YFOJ+RjZe+0
        dAKpWf+giO8uVJoX2tXxtAhruva/sLk85/QMPzaXYo+4IKHnetOzLzGSc+lMaXMk
        aLH/Aqv61MuIzYx5TJEWbZel3XPHmRIHte/hJmNs+4Nfouu9XU+zU+I6HVemXjKF
        Gl6IHbnBDM8oCBKVbY5x+CzCjNwbPH5Pkg2fHLtFi7QyfwOb9yClzMKN98P9TcF9
        8eFl6LebRX5YULAwz5iJNLzSVvBnAKqVaUGH2g8jch+jO7ctX3IqcsLQXpTDTdFg
        ==
X-ME-Sender: <xms:iGWTXfrS8f2qK0-XKgc8vNudqLdMvI99Vx-PS-YqMQBwbcPoCh0feA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeggdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:iGWTXcCWbZEA7pjDYgzcbveZjN1n4N9l2cPAdhh_5L8Eq3MLTTYEMg>
    <xmx:iGWTXVexrNMFk7EwSiC7CSzT8LMZYmkpsiQ3JJhStnXu7Dr9FdnBmw>
    <xmx:iGWTXWBX0MGp-y6zdm0dFsswTQKXJVsmfLmtSIQhy-XIJz--ZRvKFA>
    <xmx:iGWTXWPL_m3jTibJTHRiMHUfVPHhOgszCZtiACykvq_CxZL3jklkYg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D7E7DD6005A;
        Tue,  1 Oct 2019 10:41:11 -0400 (EDT)
Date:   Tue, 1 Oct 2019 16:41:09 +0200
From:   Greg KH <greg@kroah.com>
To:     Adam Ford <aford173@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: ARM: omap2plus_defconfig: Fix missing video
Message-ID: <20191001144109.GB3294715@kroah.com>
References: <CAHCN7xKaSJWzZFQgdAzvnO_QEZtHDV4P3QJudhZDpCifmgHmKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCN7xKaSJWzZFQgdAzvnO_QEZtHDV4P3QJudhZDpCifmgHmKg@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 01, 2019 at 08:26:07AM -0500, Adam Ford wrote:
> Please apply 4957eccf979b ("ARM: omap2plus_defconfig: Fix missing video")
> to the 5.2, and 5.3 branches.
> 
> This fixes an issue where video is lost due to the removal of a driver
> and its replacement was not enabled.

Now queued up, thanks.

greg k-h
