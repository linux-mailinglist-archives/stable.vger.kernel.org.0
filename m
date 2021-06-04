Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE6839B4CB
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 10:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhFDIZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 04:25:22 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:37763 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230237AbhFDIZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Jun 2021 04:25:20 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 6CCE3F11;
        Fri,  4 Jun 2021 04:23:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 04 Jun 2021 04:23:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=1YE+o6m3QGGHV14dI9ElhzbIvim
        YcvexbXDRBR5aKq0=; b=Ilnkv9J1vodNxdcA6kc3rcDYd5vYroPx5zW1qDXG/lx
        cDkxm2ixZWbQRjIxXjxNmROP3vgcTh7KQ8hfx5vuI0pK+LNqP+VVgJr9gqkZ4ubk
        KEoF/lQbFJ9CxSz1pk5IAPUYcTCCUhHvBGdEdvEi4tNDkfrYNQRNwSBjzp15Hf74
        BmPrXuSImysOEAjhgxAWMqtIgI/URecJE1rwUkluI9VRPZ3F/1mqE758+aljadZu
        fs/3HwlNSiJALUelgwaNpkdvfXGCGggqVB9Gz/uAA+hHECY3fqGkwfWG24K707+/
        MJt5OTkmH2WjV4xq9rs9/z/wUYud9VSY62OzCOHpXMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1YE+o6
        m3QGGHV14dI9ElhzbIvimYcvexbXDRBR5aKq0=; b=DDjXDR1qQu685VxyaWgoWZ
        2W4fpWDEOjWavvrHUudayMzOqcPYNtPUsrZYE7XjJony61q9HN/V3DMGoIMZ70Ft
        uiFjpY9MGJA9yYvPuQohi2hkKOAY4CU1cAMRt5lJFf+PLpf83DaL+kw9gk7BoBEq
        Ubnd60FKbpcKuoS6WjfDe5dBYdUSVigPLvnw7bpt0DN5371Ysmtid4EAA9FiLRs6
        fDkF2/Z3V3Hc1ulw+YElwVNDZYpvLLYvXMrqeDvVs+N5NAI2lg/YxrV/hMf4SelI
        vfNCn8jLFpmuXPQ1qXyEKQJPaWgK6aFaZvKgN+DIFsBd6uEMruJZ1bp918vl9t5Q
        ==
X-ME-Sender: <xms:BeO5YFDE_zxOhTiArel1qVyRs0JHd_Xw-ZjINkU-D1B9MSgLanxIfw>
    <xme:BeO5YDiS_GSg0TBFERB8K6kRfyixspGgm4KtROFRq1bSgdLuABC6tP67RNsOrhUFX
    pREDK9JMxKEkg>
X-ME-Received: <xmr:BeO5YAnq6D3xkcocjkqMcrYa8yiect-5mFsaJVMBPhdk7nQ4QGOHV0jJF7NqkHe1L1ReSVps8P8qG-iYyfkr-UJ4pK3q9skn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtuddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuggftrfgrthhtvghrnhepueelledtheekleethfeludduvdfhffeuvdffudevgeehke
    egieffveehgeeftefgnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:BeO5YPwnn3Gv8ohyZ4wJ5y_ZjoSxkUwemJ5YJOhuPLFooBy__-0jPw>
    <xmx:BeO5YKQyRP8Ig_16-q-_O1MGUHQWdBxzFFcevEHP67c4TKQFd8GDkg>
    <xmx:BeO5YCaEn13JeBIhLVg6KJJb9yMGYeYVuMf3Z9zSOC_eN6Qw7YRZ6A>
    <xmx:BuO5YFdwvS17UPyAWv7J4zOhWJbYj08aZ3vcjZ7SFr7tEhFYoQUhVg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Jun 2021 04:23:32 -0400 (EDT)
Date:   Fri, 4 Jun 2021 10:23:30 +0200
From:   Greg KH <greg@kroah.com>
To:     ricky_wu@realtek.com
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] misc: rtsx: init of rts522a add OCP power off when no
 card is present
Message-ID: <YLnjAoAsHupQUPm7@kroah.com>
References: <20210604072508.3049-1-ricky_wu@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604072508.3049-1-ricky_wu@realtek.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 04, 2021 at 03:25:08PM +0800, ricky_wu@realtek.com wrote:
> From: Ricky Wu <ricky_wu@realtek.com>
> 
> Power down OCP for power consumption
> when no SD/MMC card is present
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Ricky Wu <ricky_wu@realtek.com>
> ---
> 
> v2: update the subject line and description
> ---
>  drivers/misc/cardreader/rts5227.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
