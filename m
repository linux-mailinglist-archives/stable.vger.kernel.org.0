Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C710356CA8
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 14:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbhDGMwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 08:52:06 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:58205 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230234AbhDGMwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 08:52:06 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 8FEFAED5;
        Wed,  7 Apr 2021 08:51:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 07 Apr 2021 08:51:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=/aYFMyNkSf9zo3OlT7kr7GvBGzf
        jsnq44x3V0w1uOpw=; b=MpFDT/bjcI0sIrpFQGKk+H2BigHIUx4wanidcWPC0ar
        xOH4ilcCeNsLxtO5GWFZDkUpT12Xny08O/MMEO3N4Ut/pmWWdv9w2Zxg5jqY6uBQ
        m2Ph5Xr/ktTuswnc4hGTBSYJEzME55a0a1Gv4ZZn8MRZGOxIVV179jW/c1LYEm8v
        1ee85d2MnLDZjUnYv/y8z+6BDssDqFMlsCVZx0j0LRF5ZslkBz514oFEkSwBIvnl
        2dqOLbMlftQoyQoVRNOV09U1Esv9/xT+ffi1LmP0D00ph9k4MJdgUzD87+Xcu7pQ
        pnbZ5WF/qUN9vqX6Qz9x/wZMv1GoeiyxtldwgMG30zw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/aYFMy
        NkSf9zo3OlT7kr7GvBGzfjsnq44x3V0w1uOpw=; b=ZKdRYkZ4LzFP3Dri3B157f
        8P0M0hfe3QusKUzImbUSG+9X48n55d7LGWMN0bCoDa0hW/mtDHtRH7RdJ8Oz6Tlv
        40QIEyRi0fG6LitwBBFJKegIW2oN/TY0TCloeSQZoCwDFj58S+7PggFloWV/CRnl
        9iGA9fy2EnDgHoaCWDNN6hTY16qQec+tP0w4G99M3IxuvMyOXvzR2q6NdDSFp7fu
        wp17zOxxAmS4D8UgUXGp9gefVzrhMz+ZX5zTyFVxYNnZVtQ8HLXzO1Jvdg1Bm/CZ
        2HLFvayJZ1KlK3X+worrtSe9Gi0Hs11ZtYM9Ugyp04OeNZ/PrhGu7H9vQQd/nbtQ
        ==
X-ME-Sender: <xms:7KptYEpZpxxxeiCcDDhc8UhUbRRZFbnfiNbR2w5FiUZo62tYuwdQuQ>
    <xme:7KptYKqcp1HCyMbvY8hiJoDokd4TcAcqheGk7pRm2SOOLocv3DaE9PG60MAirbViX
    -vhLnP_A9TypA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejjedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:7KptYJPINitpyFQniKyyR6__s_C0gyxYYaxuUZ55pr4IRDQDhLC0Gw>
    <xmx:7KptYL7k7kSMvHLnFu3x0gN2_US4gfEnfILEBaRQZaylAKxB5cCHzw>
    <xmx:7KptYD7dpdriY_CBrbdRE-QYuNnfRsNt7k-sDQv-zb51V4M6V62Vwg>
    <xmx:7KptYMX6PkvCF__ygBQfKNVaS0yWocpoG6zZ-MowOMB67NvnCVX3xw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BB17D24005A;
        Wed,  7 Apr 2021 08:51:55 -0400 (EDT)
Date:   Wed, 7 Apr 2021 14:51:53 +0200
From:   Greg KH <greg@kroah.com>
To:     Jianxiong Gao <jxgao@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v5.10 0/8] preserve DMA offsets when using swiotlb
Message-ID: <YG2q6Tm58tWRBtmK@kroah.com>
References: <20210405210230.1707074-1-jxgao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405210230.1707074-1-jxgao@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 09:02:22PM +0000, Jianxiong Gao wrote:
> Hi all,
> 
> This series of backports fixes the SWIOTLB library to maintain the
> page offset when mapping a DMA address. The bug that motivated this
> patch series manifested when running a 5.4 kernel as a SEV guest with
> an NVMe device. However, any device that infers information from the
> page offset and is accessed through the SWIOTLB will benefit from this
> bug fix.

But this is 5.10, not 5.4, why mention 5.4 here?

And you are backporting a 5.12-rc feature to 5.10, what happened to
5.11?

Why not just use 5.12 to get this new feature instead of using an older
kernel?  It's not like this has ever worked before, right?

thanks,

greg k-h
