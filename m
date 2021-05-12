Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803E437BC24
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 13:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhELL7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 07:59:32 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:47187 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230182AbhELL7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 07:59:31 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 60CC612F1;
        Wed, 12 May 2021 07:58:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 12 May 2021 07:58:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=KZQBnBvM+xxo8a3tBNYpx0CtniP
        2XiCHo8PzRqBEDrY=; b=l5whdZOnf8RtfaWMHKs4bY6kn2DKJDHrOC+Z7KKgkYv
        dVfnKt6YlAWK214HwdlT2V88r5QlxGDvl2XbleBJQ5zEEItaAzGbymLCuWLoK2WJ
        fBcEpkLSExFBRfTHN7pgxhzVWnY9WXwC8kdWGPJrQqd2zuJdBHbFfpp8z83ioo+2
        6Mn5VIX/bcTBj/UGpSVpMAHuahZIRyZUBBw1hcVnQcN1BPXaXHxb3lf9gsq/vGg2
        d15jQ40MLWFm4+Y+rNM0Je99WlGaswFhUrovhk3RGoGbcyYn0D4p6d+I6vv0rCHA
        md/39oRD5w/s7GDFYa4UYlFjtH5g2f3X8ylOqvkSvmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KZQBnB
        vM+xxo8a3tBNYpx0CtniP2XiCHo8PzRqBEDrY=; b=LJhiWpgdN6KLIpoETqDb9G
        k/29ybK5/blOS0HW6GaS4IFv6mzpMHtVzwP2kMYaX/aoVkYr/jW/iAq23rdQ2sWJ
        b2j5evM4bkGjAfuYpmiasFWT+bnXFQUJL1makC+Px9Ix97noM5F3B92cTM3NFx9l
        6DdjTN+Zve25Ej0b7hEAdgTOcm3IaGPdNULcdvLrmgSOeAI7XPDwrYwdn1MhOX1O
        nYK9k51yK54Ew56dG1Xzn3dtOeYf39+E+0PFA/VPTDUi0DFL7R2GW7VuoQVttOAo
        34C0Khe1oFX2bay+4LuRwMQbXzYPweygu03qPViQ8EmGWPeqs4j6TDDy1egu5kxw
        ==
X-ME-Sender: <xms:3MKbYGQfNQy7LidoROcGLVjlz-shCXcy0xfqqfFP7aAjhTWpi8VqAA>
    <xme:3MKbYLxR-Nyt7Z1tdK9wgiMPGopM-kFtW3FtooE9a5IT4OMWBB_gdYbjDY1fefWnN
    9yRul82uES-vg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:3MKbYD0N2oepWKNuabaDVU14Pvd0QklPIsr_SzSiv90pHIxtc-V0zg>
    <xmx:3MKbYCDd2x79vu0XNkiOF0v43CgD3LWOWruSJ1crwNhQoJYsg-_Nqg>
    <xmx:3MKbYPiqC4KroMiCI5I7eQnTHkHUNWTimzq5uytVdTp7TbJZSpdEvA>
    <xmx:38KbYFbEVuSwHVKnEnThD5aT6PsO4jRpbyTjcnUXZoF0Osz7oZk2iw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 07:58:19 -0400 (EDT)
Date:   Wed, 12 May 2021 13:58:17 +0200
From:   Greg KH <greg@kroah.com>
To:     Nicolas Schier <nicolas@fjasle.eu>
Cc:     stable@vger.kernel.org, Finn Behrens <me@kloenk.de>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH v2 1/2] tweewide: Fix most Shebang lines
Message-ID: <YJvC2W9QTpc9JBp1@kroah.com>
References: <20210511185817.2695437-1-nicolas@fjasle.eu>
 <20210511185817.2695437-2-nicolas@fjasle.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511185817.2695437-2-nicolas@fjasle.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 11, 2021 at 08:58:16PM +0200, Nicolas Schier wrote:
> From: Finn Behrens <me@kloenk.de>
> 
> commit c25ce589dca10d64dde139ae093abc258a32869c upstream.
> 
> Change every shebang which does not need an argument to use /usr/bin/env.
> This is needed as not every distro has everything under /usr/bin,
> sometimes not even bash.
> 
> Signed-off-by: Finn Behrens <me@kloenk.de>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> [nicolas@fjasle.eu: ported to v4.9, updated contexts, adapt for old
>  scripts]

What about 4.14, 4.19, 5.4, and 5.10?  We can't add patches only to one
stable tree and not all of the newer ones as well.

And what problem is this solving?  What distro has problems with this
for this old kernel tree?

thanks,

greg k-h
