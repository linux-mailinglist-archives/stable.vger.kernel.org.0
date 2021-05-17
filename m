Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24CCB38296A
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 12:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbhEQKIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 06:08:17 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:58689 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231754AbhEQKIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 06:08:16 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id E885145D;
        Mon, 17 May 2021 06:06:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 17 May 2021 06:07:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=fyOhurtoNCQnl5bYUwK7k6hSHpk
        Q7aqdgQkhQ0o0TQk=; b=RIXK8WXWWcShM76BuSir2J9NEd/mVY9SVMiZVuQHJ2c
        vJ3ILsl5VavO3Mt2aT8cTGylxdPo9slKaOWH484Hf85zRitqVlS/1hl0tORqaMtb
        36zLtHx+9/DJrKmqsCQZ67mZid97AWSoISZZhE7+vZdBJAaY7T0T5LRD/6JU/eb9
        SsA58smWP4QrbhnzqjuzTus1a9VErs7pPtofxsZuOyURt5pshe+Q90mz/oyki7d0
        r4yfXtLk+4gS9MvHFQoMcnwfroW05fuyDsyPifpg8zfwD0+zFYsP4LTJRKQlhQHP
        mqzSMNVx1D5Nf2A8ikbVRrxRaR/dKUmXHLS7zc6y/lg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fyOhur
        toNCQnl5bYUwK7k6hSHpkQ7aqdgQkhQ0o0TQk=; b=mekiPMTbbuWVSmFcXUvNLi
        giugVkzsY/v3ilzFJphzO4+FNvIlefbEVc/RwtqcLfkl+JWwWitjmlw35Pvsett4
        nMOnq0PdaY1Zdb1Z/AuPX7ed+2/jQRGIpbYGACDdAxV4v1O9nYg2RY7TGJenlCRa
        XK4M9tK27gyMp9vcgudSRFDDp9bfzpjCopFjVH4LQKQfitnyMibaNXk8t8Fj1VP9
        keiNt4vOai0cWmiMunJUlDn0+gn/p9fhlLWN8BEHy6sQS1LyG4ebc+4I5y5H/qKI
        b5hx+2S9HDnB0XAOEp33DMqac/C9g6tAi2ryVFRBg44fPyHbWk9T9jJpi73RRFIA
        ==
X-ME-Sender: <xms:Q0CiYAv5LaYIqAmsxFA6L3meOgZ7u9v2TLj5pdFX-BUB2CZnSVXDHw>
    <xme:Q0CiYNcHbXcivFtT7EViccJefaodunwep2IT3SbwRxP_ODk6BZMil0o3t8rc7c9Ho
    jhBeN5gr0Rmew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuggftrfgrthhtvghrnhepveeuheejgfffgfeivddukedvkedtleelleeghfeljeeiue
    eggeevueduudekvdetnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtoh
    hm
X-ME-Proxy: <xmx:Q0CiYLzYC3LplOX30MHmPEGxYWIJaapPWE7epATQEWSAw7I8XARHnQ>
    <xmx:Q0CiYDOc901og8L802zbNAwKffs7zfrxR-LR8S83ImRNf5T9W_6Oew>
    <xmx:Q0CiYA8YCx7NnAoXzLvbfhiBgviNYJdafRlyUxJSf7UibBF_Wx7YJA>
    <xmx:Q0CiYOnapDK36R87m9cqLHkIi4hqB4Vn1p2iPDpOOdYBssiUVBq8Fg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 06:06:58 -0400 (EDT)
Date:   Mon, 17 May 2021 12:06:56 +0200
From:   Greg KH <greg@kroah.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] mm: fix struct page layout on 32-bit systems
Message-ID: <YKJAQB7jEhdk80eT@kroah.com>
References: <20210516121844.2860628-1-willy@infradead.org>
 <YKEQib+uC8t+gr8z@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKEQib+uC8t+gr8z@casper.infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 16, 2021 at 01:31:05PM +0100, Matthew Wilcox wrote:
> Forgot to label this one -- it applies to 5.10/5.11/5.12.
> See other patch for 5.4.
> 

Thanks, all now queued up.

greg k-h
