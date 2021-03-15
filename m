Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC9233AEDB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 10:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhCOJan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 05:30:43 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52847 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229684AbhCOJad (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 05:30:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 3F2A85C013F;
        Mon, 15 Mar 2021 05:30:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 15 Mar 2021 05:30:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=4JEfYRelNflwp7QTABnwYzy8bpa
        KghL4PcFJAiB+uMo=; b=ZpLfl8dykp5pOGw+EEiT9AJJ1K6kwe9d3fdiYzsQ8rw
        yZ5dpR/iV/pjglUtHb5B9q+W2szmOJ/nXRLouyhaEs1o2ogC6HGL+bx288YYGhGB
        e0R/rIqZATlLHHsZlLjiMUBopSi5fd1vUgihfQsWHoRBPIdARgx99hfqpsFbzhF4
        BJOzsWhb/bCQozBfaDO7V7bhi46p5DtxCx9KOvKWi/UvMoumeNsLcX1tNUE1J4s8
        lSEI4DPE1q+MKi3OQ1zSmxbJ1KGj5u8TRMK6bMHi8MyaUzTSjTL//J/Qe+P4H9MT
        kthI3uDL1gZPBiKe9oPqjTy2HnU0bzQrzRtgQJOYDig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4JEfYR
        elNflwp7QTABnwYzy8bpaKghL4PcFJAiB+uMo=; b=c50L4+J/FaohsSs+bErf7s
        0ESWlojD3JxdQE5Vh2v5FFi6d7uG10ocxJQLwcBz0ue3jpya4WBib9aymXYrx8kD
        FakkE76RDYAaHswvk0vWfK46XpxZ4wRCboO9teFvUY9QRsWwkp99Ept8Je0Z8Zzt
        dnlhR+BhmiF0CHdG9tDViQFJ4hEisWKobhm1jgFoT4yk/7w7jOccBqguJLsRSEIe
        oLBt4MF5FvXApMDKaIDCNWKOEAW+iHZc1oh3TkbZyq78tlxrzIkf+IvUSKmic3Rw
        FuIVadRrp7x6kEGgWz4spCp7WhWifmpbRtaGjkD3FipH9S5a5By68FXZZm6FU13A
        ==
X-ME-Sender: <xms:OClPYEmTjswaBIhRRpBCzohSW9tfmu65n2Y_cZC1k1WgTgq3jfpr5g>
    <xme:OClPYD1oSo4mUUtyRzqAf47WV7-UTx51D76TThVj5-DWcwm_KGrzxc7ZCKPR36djA
    KTT8nsLzW99nQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvledgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:OClPYCqI8WS1AkMW5DC__eOIHixOBhSMq6r7D0nhCckG55iPqggF2g>
    <xmx:OClPYAkiyDKWmziPnKlEgFzT7-qzBzZfnOZcD3sLFvLOZ8y8-QWB1Q>
    <xmx:OClPYC1YWtjKjgBw29jW7He39B37qdlCQ94wHEb9wXeG5IuKTXL9Hg>
    <xmx:OSlPYFSfD2JBkq_xYp4nhhyaLNcCrnQnawuRLSzcgVjIlBLX9Jd2yw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 67A2C240054;
        Mon, 15 Mar 2021 05:30:32 -0400 (EDT)
Date:   Mon, 15 Mar 2021 10:30:30 +0100
From:   Greg KH <greg@kroah.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>, stable@vger.kernel.org,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org,
        Guohan Lu <lguohan@gmail.com>, Boyang Yu <byu@arista.com>
Subject: Re: hwmon: (lm90) Fix max6658 sporadic wrong temperature reading
Message-ID: <YE8pNiyFWxKy228+@kroah.com>
References: <20210304153832.19275-1-pmenzel@molgen.mpg.de>
 <20210311221556.GA38026@roeck-us.net>
 <9243482c-0a34-d6d1-1955-bee00a75554f@molgen.mpg.de>
 <d4756f39-3a4b-7348-c49b-25701e31f99b@roeck-us.net>
 <02b9c3fe-5961-6a23-3fd0-6d7687867fb1@molgen.mpg.de>
 <20210312192457.GA17220@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312192457.GA17220@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 11:24:57AM -0800, Guenter Roeck wrote:
> On Fri, Mar 12, 2021 at 05:53:49PM +0100, Paul Menzel wrote:
> > Dear Linux folks,
> > 
> > 
> > Could you please apply commit 62456189f3292c62f87aef363f204886dc1d4b48 to
> > the Linux 4.19 stable series?
> > 
> 
> v4.9.y..v1.19.y, actually, please.

Now done, thanks.

greg k-h
