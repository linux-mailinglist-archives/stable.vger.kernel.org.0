Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F77933FF13
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 06:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhCRFwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 01:52:25 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:60251 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229454AbhCRFvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 01:51:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 063A41C8C;
        Thu, 18 Mar 2021 01:51:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 18 Mar 2021 01:51:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=+6iPzoRx2ESrDGGV6WGQzYBsg1q
        qB0EGDDFPE5s/JGI=; b=viEdywMad5JviBnmG39ZpK3Vgd+cAEwoL6N8KspkBXC
        rKZceqP4nGWJ9yiKN/1BdO6SZ4bKeuSNepQawUty4FK3CxJRewE7apMa0zptkPd4
        O8mg5DD1yEjH/BXA2doTSE6SMjh82dLAU0AU7FwgfwmnwwtRt5ngxQeHOE1h+ntY
        11SKgXbGOaD9/Yww90/Gz8HsjHkp8jCS/sjy+yvBtljvGSMA2b30w0BfTwprE2tr
        r7gGzo9F0v1DQV2qDhCGzh80DwGSsjhxceSe7prZ9YpD7OiL6dPnq5iP9xgGyxBf
        zp03EsVe6XyVqnIYZyeerq4qOcXV9PC3HMgrV6AVMjA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+6iPzo
        Rx2ESrDGGV6WGQzYBsg1qqB0EGDDFPE5s/JGI=; b=sOY70Kpl5pSlk4YyVlDY90
        8NpuWSuSh5hYtG3IaWwMlIlpN8SmkUt64ZGG+3ukbf477iPWe9UW48yT/WNa6TDn
        8JCB9roixZZLNsj3rlJLZITV55aIIqVueIiqWuqderItxlE9k3S/AbuHh3YCqBpC
        FfjgS75FYZLhvTfH98SHBS/9ZJlaXmsOubpJC3pc9dTNKVyEI6BTyZcG3ZRwbdOm
        LZ3Ma1FKKHflsI5UPo8HbPsTNdaZTXmOj94as7CzjiGr+kpkYVB7DO37B/GCiDQy
        QUIrDOsryD4EThpbdo23ipRGJymj0xKDPi81qIVvkmNsSnuj5RLL/s7niiqOZk+g
        ==
X-ME-Sender: <xms:eOpSYL4SNdvc8EH0R0lAod1NWk_XA6SLOxmlGqlgBzjiZgf2y5Gb6A>
    <xme:eOpSYA7LjVcWJ7i4rfM9O3i3wxvzT3Pbh9dmkpbyxnj59GFZih7RtKm8R2ttvEtie
    4GMDdX6xTqziA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefhedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:eOpSYCdhFvichOrurjbEvJf3GGJjXhwQgwsBCOMR-ILX6sOfUA9kSw>
    <xmx:eOpSYMLTp2ONqewa6L0Am-Phlr1TazXAUp2YZNZdQ_WZzfkAyjar5Q>
    <xmx:eOpSYPI50eW6PX3bnHv8hFHwOpuKbL3h7eAkGojXrH0B9ye_Pn4Wbg>
    <xmx:eOpSYFjViElLheyA2CyKRO41Ka3I1hfQre1gzyirm3TGyCdkrZnLlQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 00055240057;
        Thu, 18 Mar 2021 01:51:51 -0400 (EDT)
Date:   Thu, 18 Mar 2021 06:51:49 +0100
From:   Greg KH <greg@kroah.com>
To:     Gwendal Grignou <gwendal@chromium.org>
Cc:     lee.jones@linaro.org, stable@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] platform/chrome: cros_ec_dev - Fix security issue
Message-ID: <YFLqdVAb2XIKKi5y@kroah.com>
References: <20210317235522.2497292-1-gwendal@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317235522.2497292-1-gwendal@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 17, 2021 at 04:55:22PM -0700, Gwendal Grignou wrote:
> commit 5d749d0bbe811c10d9048cde6dfebc761713abfd upstream.
> 
> Prevent memory scribble by checking that ioctl buffer size parameters
> are sane.
> Without this check, on 32 bits system, if .insize = 0xffffffff - 20 and
> .outsize the amount to scribble, we would overflow, allocate a small
> amounts and be able to write outside of the malloc'ed area.
> Adding a hard limit allows argument checking of the ioctl. With the
> current EC, it is expected .insize and .outsize to be at around 512 bytes
> or less.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> ---
>  drivers/platform/chrome/cros_ec_dev.c   | 4 ++++
>  drivers/platform/chrome/cros_ec_proto.c | 4 ++--
>  include/linux/mfd/cros_ec.h             | 6 ++++--
>  3 files changed, 10 insertions(+), 4 deletions(-)

What stable tree(s) are you wanting this to be applied to?

Always give us a hint...

thanks,

greg k-h
