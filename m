Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98610330A91
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 10:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhCHJv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 04:51:59 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36073 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231224AbhCHJvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 04:51:43 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 340B75C0097;
        Mon,  8 Mar 2021 04:51:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 08 Mar 2021 04:51:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=A/ZAbF35kVJb0O6ltOTEQLBV9ts
        HExHaU0hBdQUKle4=; b=t5AOpIWYFE1NLn4Mb/DwEX6h35n4Z5JECU1IVrV8/hN
        o3OAcui7QUaIOrwpbWZGDTtByrm7ue7CxDysHoBYu7jh7VpoeTrKHOIT2V81Jr1d
        q7LQ18EqoC5A9HlhktEkArc1unwzbQwmZ5F33eG3P0FfTNbrfcJ18v5uO1ovLbb6
        6a7fspxcj1A8eDmiXI5V/FU9/CGbLQJloxrkqYXewL40K2PzTY7v4C96/IJ0FoxI
        46MwP7Q4s+JlmDNTepq4Fc5sVxRhfbmACIybVhu1bsZjupxncDZZ6uQw3IfppAR6
        9d+lO1neCVLKVHAKx4OIUZQHlwksexrMtVWD1JUh9hw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=A/ZAbF
        35kVJb0O6ltOTEQLBV9tsHExHaU0hBdQUKle4=; b=XzmuYiOTVbNKwrBpaissN3
        J9n1CI3JdRCRdB3PjpJXNfmEnDiJ0zLb0rmWLUxsSjrKQBqjj/X5fwjLO5pIGLUl
        SfEgrMbVTCfzShXA1875BkThVlzP45QPEZLrID+zMvPpvVE18Vyl4dwbPXHpKgOH
        h2IAg1a60gII+tggkzihe3o4g8P70ensq0v9m1lxdjli0XrPu6YWNEF5sZ69trVG
        mAjzZCoCri/sQ1q4Y6tTLuR4q+51DuA4PMx0GX8jqOiy3DrUomdYIcS3cGNGLMDQ
        RRdIxylg8cKCs4MQxpzNJUXwbzXFeI7DzpI8MxUUhVS58ozSohN/gfA0m7+CbqIA
        ==
X-ME-Sender: <xms:rvNFYKBYASs5gf0NgKO5El8mdvv-ZFAm-fJImS8ktATI16wQMCabSg>
    <xme:rvNFYEiYqEAYP0dl2tzzcP-bwRFfwmAdhd5BhS9Fmx4rPxtPWVvDs7IwCLh1qLvVZ
    1w3TBA3uwoqUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudduvddgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:rvNFYNneWcoQrcw5pL0RJT1nHttVAjJeIsgiIq5qi9vnDMt7q_bGZg>
    <xmx:rvNFYIxEasl6PoDnwUjP9SkjNTTyN1H5UiahAZ1Xm4q922kYHOOl0A>
    <xmx:rvNFYPS7KBHK8KQPG-FABCXuudZz_GhLD2fSFsWMSghoZD0YYg6y0A>
    <xmx:r_NFYJcxJGInnLiA_EQOT38ZUyeQ8m3vKNSPtjGHrGzpYKwfFfNwXQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3EADE1080066;
        Mon,  8 Mar 2021 04:51:42 -0500 (EST)
Date:   Mon, 8 Mar 2021 10:51:39 +0100
From:   Greg KH <greg@kroah.com>
To:     Neil Armstrong <narmstrong@baylibre.com>
Cc:     stable@vger.kernel.org, linux-amlogic@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>,
        =?iso-8859-1?B?Suly9G1l?= Brunet <jbrunet@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>
Subject: Re: [PATCH stable 5.10] Revert "arm64: dts: amlogic: add missing
 ethernet reset ID"
Message-ID: <YEXzq5EUM/mcLY9L@kroah.com>
References: <20210308092241.17058-1-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308092241.17058-1-narmstrong@baylibre.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 08, 2021 at 10:22:41AM +0100, Neil Armstrong wrote:
> It has been reported on IRC and in KernelCI boot tests, this change breaks
> internal PHY support on the Amlogic G12A/SM1 Based boards.
> 
> We suspect the added signal to reset more than the Ethernet MAC but also
> the MDIO/(RG)MII mux used to redirect the MAC signals to the internal PHY.
> 
> This reverts commit f3362f0c18174a1f334a419ab7d567a36bd1b3f3 while we find
> and acceptable solution to cleanly reset the Ethernet MAC.
> 
> commit 19f6fe976a61f9afc289b062b7ef67f99b72e7b9 upstream.

Now applied, thanks.

greg k-h
