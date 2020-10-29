Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68BA429E3F9
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 08:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgJ2H00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 03:26:26 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:41309 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728399AbgJ2HZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 03:25:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 613EB230;
        Thu, 29 Oct 2020 01:40:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 29 Oct 2020 01:40:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=e3pDUFoQ3JbuZ9ezgK53b4D7DPc
        gSygaeigheHtVxxQ=; b=pJCnngYRvSBV9nj8uspVhLfe7P9Uvwy/PmlNUHnfHio
        4FRJeovxo4HyuolVTRnIJ048OHb8PQvsl+ymyvlqh1S8FR2OiG7r7s51llb12342
        cEULdKw1KHBlZkK18/WXOGCeowFzOsGgdbTPhEZixl9F+mOSYzjZ9bCQq45aDteo
        TLdF6WXxERmUzCZE8t2CCWIltld3qCrknw9prDEqCZMiAZCmFPQ/AurvvGhmiNHd
        co9qlNzfxGwhckWMPLsHrrBDyMxl1YfBlLeFF6gF5N7xGCwXVx/gC+W1hwsImG4+
        eg37Si6rbLKCm2/tx4Z1ExZotma/4/0QZO4ya5IgrXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=e3pDUF
        oQ3JbuZ9ezgK53b4D7DPcgSygaeigheHtVxxQ=; b=oEWnAr6uM2Sdx4W2WrS5CZ
        Q60qQETMl2kAnoMc5vbKtAWBJEvl7Qo7VJWPQSCPTgC5R88cYaiCDxT7ZDgPrtBM
        Kk6nYYriWwB1K7Y+FLJos812UDXGb4eXaRUWbyoDzlc+WGaprTKwuv870dS9UXc+
        Acliy5x3MKCJfS9EGpqLqTkqKesUMxsXA0k3BJ8z7tWZ7qB7cpUpzbwF7dNrbBI+
        e+QAiIPm6l1zblkqkO8/nHV7qZwis4zV/MXCeGngcAg6yPNrPUZADHCQzCpMcp4z
        Ods9EUtehWZiHE+xj52SJ8FnrFFf7trsgNVvJFPcsLscAEpRiPEGwQBGH7OZBEaQ
        ==
X-ME-Sender: <xms:6FWaX4EtksxDjkMGzl3snPMAk1Qzd-zErR3pniLCc2b60hLWHUtb8g>
    <xme:6FWaXxViAYixAcFJdgVizEDSrrH6XoBcxgIGBArh5oGAIznOPBm_cZLkwoDDh3M3s
    iY5vlaDtUF_RQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrledvgdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:6FWaXyL5cb868DBvVqgVkAGyN7x2S8eAG_jAHSi7fzOkbPD5Ihs26A>
    <xmx:6FWaX6ELl1VkzkuDFA3rigjUiLSdRGImYWWHeig4KhLrpvjbAXLLTw>
    <xmx:6FWaX-VdcrjmTf1DrdJJHGx4GuBAI142kDCyWwopOX0EjxNcjOro4A>
    <xmx:6VWaXwd7K9i5wdKmvPgXBmE582Y7bEtij-36nZj94COkWK0Uv2hhOw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6E4D43064683;
        Thu, 29 Oct 2020 01:40:56 -0400 (EDT)
Date:   Thu, 29 Oct 2020 06:41:47 +0100
From:   Greg KH <greg@kroah.com>
To:     FirstName LastName <lzye@google.com>
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        trivial@kernel.org, stable@vger.kernel.org, linzhao.ye@gmail.com
Subject: Re: [PATCH] Add devices for HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE
Message-ID: <20201029054147.GB3039992@kroah.com>
References: <20201028235113.660272-1-lzye@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028235113.660272-1-lzye@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 28, 2020 at 04:51:13PM -0700, FirstName LastName wrote:
> Kernel 5.4 introduces HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE, devices
> need to be set explicitly with this flag.
> 
> Signed-off-by: Chris Ye <lzye@google.com>

Your email client needs to be fixed, as your "name" up there is very odd :)

