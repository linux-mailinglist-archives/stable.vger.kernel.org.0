Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194D2339E51
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 14:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhCMNhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 08:37:04 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49433 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230309AbhCMNgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 08:36:37 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 263A45C007D;
        Sat, 13 Mar 2021 08:36:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 13 Mar 2021 08:36:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=VMnf5am6yd9LBVhW85kPkWQpEjs
        0Fz4nhL9CLJa5A2o=; b=BET5N3p4cl9R/1Tggojp7kr9ZvbnxBQdVvCVQRajA1s
        d17r9urveWzocADIk0Pntt67rIes62YFbkyVXXvdcda/rfaa20yzq3MWHTwqqrPa
        YQJA40/2inTXK4A1YcM55deptzBPHtbh92gteaaIwULx3EnI5O3KxabLZyEt3VPi
        2iS3Y9xnnH/MQ/E+ls3Z8/CNFzMc3J0hHnUjWwKMXjX+peGD2wnyizhR+dOo5P3R
        eiRBYftvmFovcbDNC7Ok8feBXIfncjFE71aSZhWtmBN3KYT3vRnZSbXmrs8URQVM
        oJvebJ5l4LmZWWXGHnbvZ1IbujEG0dBAgjmGBNk1KLw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=VMnf5a
        m6yd9LBVhW85kPkWQpEjs0Fz4nhL9CLJa5A2o=; b=cCzdCVIPnCuXgDEN9A4rUy
        /AN/NeUOMtMUcOsyb2sYUWr2ufp5IvasX4xN/VHb3yeSGRuKNF97ROxcLuTeWTHg
        Gs9BLXJKSVkhm+FJozx+UiKNuH6mH98vft7Y8Fg9LDT2rolKcjuv5JMWWmMODL29
        LhHSmZttqxX8oy6zE40QfIW2Fv6f7VkLzJyqV8FgoXMWhe233Y96GzEP4hvLm16l
        S9v0NyfqGJBuCmgcABrWzI9BBo4DGJdmGmxY1b1XeFwMsciok2jvotKEyY3J9qIO
        27xtYUtbXnLJRO+3s2eXyyCBDKRtDh3KDZT1AO5/WIAvrBb7x8QbCWQ/7qcwj69A
        ==
X-ME-Sender: <xms:5L9MYINw2ngmDzCoD0tqEa2vlcwmkS7BfrS48M9hjSNDregDh8cDNA>
    <xme:5L9MYO-10VCQwB3W9Bk6fUEllFOsdsKNDbELFjO8JgyMXEGKA4tTfXG4rdw2uAorR
    wQFjRfgkSg_Xw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvgedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:5L9MYPSIc8RN6OfLA9KqgCKU0_bGUN0UdL1zgO-Nlqe4J7wpu7FaYA>
    <xmx:5L9MYAv0D5Cxdw4gcx97zhfEyvwsS55Sbsi54KjPyosfhYkplSbfrA>
    <xmx:5L9MYAePdGxxlbEpvMnLbjg50VSfU6a0iRr9jHNCpWc8tLOKz776-A>
    <xmx:5b9MYMFVj7CKjT5-b1zd0VFjaTuOLVHsNUHs2-YoqGbrDW5yWqaLzQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6C0ED24005A;
        Sat, 13 Mar 2021 08:36:36 -0500 (EST)
Date:   Sat, 13 Mar 2021 14:36:34 +0100
From:   Greg KH <greg@kroah.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     stable@vger.kernel.org, Allen Pais <allen.pais@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH stable v4.4] libertas: fix a potential NULL pointer
 dereference
Message-ID: <YEy/4jYcjQWCRdiV@kroah.com>
References: <20210312165117.15870-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312165117.15870-1-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 05:51:17PM +0100, Krzysztof Kozlowski wrote:
> From: Allen Pais <allen.pais@oracle.com>
> 
> commit 7da413a18583baaf35dd4a8eb414fa410367d7f2 upstream.
> 
> alloc_workqueue is not checked for errors and as a result,
> a potential NULL dereference could occur.
> 
> Signed-off-by: Allen Pais <allen.pais@oracle.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> [krzk: backport applied to different path - without marvell subdir]
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  drivers/net/wireless/libertas/if_sdio.c | 5 +++++
>  1 file changed, 5 insertions(+)

Now queued up.

greg k-
