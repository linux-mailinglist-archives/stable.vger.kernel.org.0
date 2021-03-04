Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E0A32D442
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbhCDNgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:36:51 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:37345 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240738AbhCDNgk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 08:36:40 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id E422413EA;
        Thu,  4 Mar 2021 08:35:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 04 Mar 2021 08:35:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=YbEqXm7OCVVq6KDWOv+4UYVYPhc
        Vb6mS/nW+qqWR/Mg=; b=syD9rnanQBlXoUpZcjBLNH2kL1ACF/WcZtG8iSI7RPR
        h7K3rxfs336hHFcr3DXs/ydEkqAfcgratgEzqr1cGC9T/tFsRZOF6yKHWjqEtaAa
        0flr12gbwbq4ZEqeFfXYvNYKeZ6oyYLGruoRcNZTf6Duo9OMDBEZ1dTY7wfSmYKp
        lh26n19WgG+De5z9pV1aXTqu6L7XbplyyleGXbcB3ZlWJYwsGycC77OMWg5gX1BK
        ajXdAk3Mt2rin9fpqOjtYmEzXq3nIYedZ6dBXcgAjw/JDazmoyVE2ZV+d8KQA0/O
        yCnKEloWJuWAi+VnZCduGBwR5EvHm7Ei0Oz1OgSQMbw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YbEqXm
        7OCVVq6KDWOv+4UYVYPhcVb6mS/nW+qqWR/Mg=; b=GInD7XZ4Z/FqW7fzkt9Tma
        XoxEootulTL367YqbJrXS5T4PNYZhiBI/XjolQwcMc8gBCvyfTW3AnZbrEXA4pGP
        rkyIPubF9rQLo4uyjtyjw/PzWiSMpXjvyX8yRLOQ+51vgwnHUPpa8evBO0gieTnm
        Q30l0icvDFOGEKkEQtZh7MqzkD6HM+oYWDj9pe/pCELlmxn/bqirZABlBnkSLd4Y
        GVSLhnYz7y0R2mqjnyQYBu5FBSwloicT/Kd3+ZuRkOcP0JXHds1sCciIERWUi+d5
        dfWG2ohpL8eRcC6kpkNpOM9zgbc1zRMxhRno5dBppxvWW606TjKwTeJy24wFG5PQ
        ==
X-ME-Sender: <xms:JeJAYIXG5WQnVnHMGWiO0_TU2a_zHjM6pXzuVHkxYQhY-l4GxvxULA>
    <xme:JeJAYA368V9plHDCit3VzRXVwWLhCV5wSS81T3HJXuohCD-7EPdXSWU3cYWIfb5f4
    TbYX63eTWoRhA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:JeJAYHYSVsxb8Zq5JzHfquB9jYU1PQFQf5QzRCDndtO_yDOsBf_0tg>
    <xmx:JeJAYLrpAr0TFT1yUSk-Z23kvtWMWFPx8akgy8o9_D9NWxlS1zG64w>
    <xmx:JeJAYLo_RrQ_DKYfX4fdPQQWU7nWtu8kHgjCcPPn5Le3eaTE7lTv6A>
    <xmx:JuJAYFqPxFjOD2QC-hMIvoCUIfdpNyRalhp40dgs69EqwdNx-GktkA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9F0A924005A;
        Thu,  4 Mar 2021 08:35:33 -0500 (EST)
Date:   Thu, 4 Mar 2021 14:35:31 +0100
From:   Greg KH <greg@kroah.com>
To:     Rolf Eike Beer <eb@emlix.com>
Cc:     stable@vger.kernel.org
Subject: Re: [4.14 / 4.9 / 4.4] backport of
 2cea4a7a1885bd0c765089afc14f7ff0eb77864e and
 fe968c41ac4f4ec9ffe3c4cf16b72285f5e9674f
Message-ID: <YEDiI2dBEzPrSzOT@kroah.com>
References: <4669336.5LvBrcZMKH@devpool47>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4669336.5LvBrcZMKH@devpool47>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 04, 2021 at 08:23:34AM +0100, Rolf Eike Beer wrote:
> Hi,
> 
> the attached patches are the backport of these 2 patches for tools/Makefile 
> that allows building when OpenSSL is not at the default location. They apply 
> cleanly to both to 4.4, 4.9, and 4.14. Backports to 4.19 and 5.4 were already 
> sent and are already queued up.

All now applied, thanks.

greg k-h
