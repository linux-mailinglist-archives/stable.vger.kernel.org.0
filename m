Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B91B37376F
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 11:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbhEEJZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 05:25:02 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:45891 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232936AbhEEJYs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 05:24:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 3BD94161F;
        Wed,  5 May 2021 05:23:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 05 May 2021 05:23:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=xjZ9WGm7ltBF3btDPYLZrwPnMBr
        jK21do/NKeHQUcKM=; b=YtGmNBirtyV7qvYYdgTpzUoruufCGciUPSg0UU1bu/V
        HEBBnFX91ONLgOjrhPqjJiFddcrSbixkgu/ZR3xsZw678tfO3DvRm/z7zcta8IMg
        /QLl9YiWEUxI0B8bgoJd0oIy/d7fzT9jX36J88XvVF8HwD6TrYLrFtsxO0/DTT0l
        cSTW5ocx2rWCYKWTQflG2BqBYGod2fziQEh9TWePuRSUf9pitRXnQ60vEsQZLBgS
        h26sVMe/biqm/6LPuIaaWIsnjyG9vMJFJhgP2zVZmVZGLTiC0kWjpqv122V2OwAY
        guFp/+hE5dWLt8gcyElEbM3FNlqMTzPovs4Y6O2pzLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xjZ9WG
        m7ltBF3btDPYLZrwPnMBrjK21do/NKeHQUcKM=; b=gPEjcgYqWI58ppU3yeciX+
        hyTm886eFWzCsztN0LV4O7J8q6tmrAUICfpJZveSCCfk/hvGT5/uvD4wRe0KoWC4
        oXXfxPyvPe/EYVaD8I1MjvvS27kjHJ3WgFJY6VdBJWjcm/XkNVdroAOKOYLYLAh3
        SNQFaly1kvfnRU+JTIrxdlf+ebVT0t5/S+Cq7Siphhac500CtLOZ37lKPX92DQhs
        5fPgfZrfCSIxJE+s0kQkcZivjFDNwB1QHsbTTu7zmfDxmbgSuie1T5uUaAE1LSAk
        KF6X4b9kDYYcBL+swaX5cP3DEtL7TNkPjd+v2Yg/efBxcwRUyd3RW2RXDlkJoM8w
        ==
X-ME-Sender: <xms:JmSSYCcB4wVT7cxsG7KWXK5ZUaiiKkilTAwcAd5Azmisb_KZUUsrIw>
    <xme:JmSSYMOjmp6qozpFk3plWy_eWY6AJBwMKZc3HR4jtCkLAgQr0zBwPQk6owacl8C4n
    IiyZpVHXYqiLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefkedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:JmSSYDhEHYBakM_hIp2m8avA-QR5hDrPUl7qeqRUhi1T7kcJQymMlA>
    <xmx:JmSSYP_HQ5AtZHsYf7t_vpwgWuhYSoUxW05tdsbZKzZacgdNRSurTA>
    <xmx:JmSSYOsF4w__io3U03tdqARVWH_XQNfhFjedDkDd79_ox779FyB8dg>
    <xmx:JmSSYDU0JhYkIbweGZPI7Pza4ps8_oAKzaXdI9mrIZ9_JSLjB6k-ew>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed,  5 May 2021 05:23:50 -0400 (EDT)
Date:   Wed, 5 May 2021 11:23:48 +0200
From:   Greg KH <greg@kroah.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19/5.4 backport] ovl: allow upperdir inside lowerdir
Message-ID: <YJJkJAI2HwdC5khy@kroah.com>
References: <YJJZs8vKYDvKo3Db@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJJZs8vKYDvKo3Db@miu.piliscsaba.redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 05, 2021 at 10:39:15AM +0200, Miklos Szeredi wrote:
> Hi Greg,
> 
> This is a backport of commit 708fa01597fa ("ovl: allow upperdir inside
> lowerdir").

Thanks for this, now queued up!

greg k-h
