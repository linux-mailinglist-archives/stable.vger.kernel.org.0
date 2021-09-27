Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28D94193F7
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 14:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbhI0MSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 08:18:43 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51565 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234259AbhI0MSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 08:18:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 714B25C00B1;
        Mon, 27 Sep 2021 08:17:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 27 Sep 2021 08:17:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=INVKYL/hImMLfwyu3HkJ3O9tiNp
        9okvbdqAbJgPUcIA=; b=HEkhCKoXGZEZORodRpbAWjivivkrQU32/NKBMeUNIr/
        SE/UA1g0Q4IKTILY5wQ0Ksl5temW9I/PFCe0zjkEgL48Z2GXwc/uwtbn4SMVwW50
        94vcZZxkAh2OOjWaHciM4Z3wsmf6H/BswbkfYjeRZw7hCV1ic7hrhNeactAkMnEC
        U2Ewz1e7BcMV6/wUwqL9+nMDcAIYgdj/7vItCyLCSpOmCuFd3phDJjzDuzg+Icpk
        Hgsjnzg+GT81QIJuIiA2ya7ep9G54GENmwOagn9j8psHOqQJ0LlyQENAxyRJU1SK
        WDcXeHatqUu6aymvdfk+zqV7AL9FndDl7xjr5TQutMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=INVKYL
        /hImMLfwyu3HkJ3O9tiNp9okvbdqAbJgPUcIA=; b=qUlBh2cEUgBPxYAaYwON2c
        l4Jau0kWOowJxoG5nf1hND7qcQ2P9yAqEHz0qrI3vvWe6Lw8lba4bJPrOpoSXwQk
        ldqVRtsq+nb8ByufS6d4qyxg4V3sRRZgjDqBdIjAd0hmOc0iVqp3rl4FfTg0gKPc
        /obrVBYXpm7HPMCnqC5aT/8bqRMnMRfMBNsafu3Wn1Ux1aEC/Ax+d3BR3WMXQLMA
        GlF3OqEQxJYEmZqby24ODTyiALCU9qGnZ9fK9SSJ8Q6vivbH05VCqEi981krd1uG
        GZdt4q2nZoX4MTIUNoVBshzYsWEvnrX7TwKdyXQbyPdRU3Wgk01zIyBwgEQynXJA
        ==
X-ME-Sender: <xms:PLZRYR_oPsu_zx5OC_RmwDERzdnaRnV12M56_qlz-jmVGKg95YdNCg>
    <xme:PLZRYVvL3jSe4xTXS8X-2QviMW9rIcvzcyuaGmnAn70HMMVYDhT3jDdud8H7R0UA5
    TN2VFeDtBbThg>
X-ME-Received: <xmr:PLZRYfCv1AamG7S4WiFpmgnFyiqEZPUz521dV70As8_7O8Mh2HGeDegaWq0EFCoDGpSrnOZrovjdonWJwCco9qChwgKGUIBK>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudejkedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:PLZRYVf1w5Tj_LYdfR74IMkJjmRe2nVp2jwlzWKNOxZv9p8VfxHDPQ>
    <xmx:PLZRYWNkU0AQA9A5KHz3PEWWbWgvvUzUVz0RuT55hvX8KYYiF_-qCg>
    <xmx:PLZRYXlM3TUyxspmM9IvcwDpKWi9RFdiLSewSUoa8amrV_KxATw6kQ>
    <xmx:PLZRYXh0z1WoZ01lEUbZfMJVBLFjvjflSkSnQyhhWUGHvOHQ4PxP4w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Sep 2021 08:16:59 -0400 (EDT)
Date:   Mon, 27 Sep 2021 14:16:57 +0200
From:   Greg KH <greg@kroah.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     stable@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Malte Di Donato <malte@neo-soft.org>
Subject: Re: [PATCH stable-5.10] USB: serial: cp210x: fix dropped characters
 with CP2102
Message-ID: <YVG2OVNtg9ScNIpW@kroah.com>
References: <20210927090012.14437-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927090012.14437-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 27, 2021 at 11:00:12AM +0200, Johan Hovold wrote:
> commit c32dfec6c1c36bbbcd5d33e949d99aeb215877ec upstream.
> 

Both now queued up, thanks.

greg k-h
