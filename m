Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86A048A193
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 16:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfHLOxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 10:53:34 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45767 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726689AbfHLOxe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 10:53:34 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5A0C8210DC;
        Mon, 12 Aug 2019 10:53:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 12 Aug 2019 10:53:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=B3I7YIzP126Whgj9tF1BCT1Cx4w
        EV7hz3a/rHtzIpVE=; b=nOJ+ana2vL8IYj945Ruz1PStQGeuJtAI1wlYrfvGLio
        sfW3sZZ/nhP/jqxnJyGJmylsKpXOzeiHbuWJtox5xrFJJxIiq/tRk/a6h3HhV7Gm
        tsKSkLAET6zI2hd2JRm6U9WJ/5Rnld3+Vaj9CctLsqSrl01B0BbBLZGiVa+AMHe5
        YLmwWoouWQOSaKHA+YtuqcscHI8vi1c6d97K2bkRTmFPJogZ8dxxN6ZWLMoAbWRN
        3lnqBHw8kTrTBKaUwSlAHZPk9UeBt9FmpVvKh42u9kNI+fchm8ZeRc3UGZpcLjhW
        r6mc6/tmiBmrfaKNuXbugdbJ/et4A2pZZitpHvwHa0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=B3I7YI
        zP126Whgj9tF1BCT1Cx4wEV7hz3a/rHtzIpVE=; b=j7KwKNJGhTCxhbikQ2kJ9w
        PhsGkE+H5L7eX3f0SC7nSSC+SjiGRiOveQnt+oSS8NqfkyIvDnZIRfHVPcd+hiaE
        mCgpdOa7pCUNYymHEKXpdKA3g7ynNmEXNoKc0CUgUTgSdWkNtW9pnpIkJUhQZ99+
        LX5k4HzWQRCAB/FWDp4DXcivetED3dKTRMXjpohtJ9Ucp9ey9w7fsc0yz2gUPEz1
        VPxMbjMNFKISUc8rim8UjxbGXNICRsZtMPOSeMgKjRBhXU5dGLPyuD3+dg7BwMCM
        QWrrsturwcjwAmBkv4OcJpMXFkPBFBA24Q1W2gvEaV+lx3CTrrqJCaNuYZwbjUhw
        ==
X-ME-Sender: <xms:bX1RXZYtQgpowiclvaaG5fOdXptKIdgXUxKdEiXu3YAmoKxRc0JY8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvgedgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:bX1RXXUu_eavnbf4FzTOMEoNCERQIg0g0o7uEhcHWiemvYPbYzX8dA>
    <xmx:bX1RXSaRJqfB8xjxpFgdEfYdDzNksglk45GXlZsqWQKLfNqhbsNV6Q>
    <xmx:bX1RXWL6Ttaj9T_Q7JyE2bYphgJRSAax0CsYUGZcWbnotCgVSUYEbg>
    <xmx:bX1RXVShVG-0LyzG3mMqL8bdFXwdHfH1YqaW1GMTmuPcV6EPxioEEg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 926C880063;
        Mon, 12 Aug 2019 10:53:32 -0400 (EDT)
Date:   Mon, 12 Aug 2019 16:53:30 +0200
From:   Greg KH <greg@kroah.com>
To:     Major Hayden <major@redhat.com>
Cc:     Stable <stable@vger.kernel.org>
Subject: Re: Reports from the CKI Project are back!
Message-ID: <20190812145330.GC22363@kroah.com>
References: <166c8369-e09f-6395-ca0e-e8825767ca75@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166c8369-e09f-6395-ca0e-e8825767ca75@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 12, 2019 at 09:43:39AM -0500, Major Hayden wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
> 
> Hello there,
> 
> The CKI is pleased to announce that we are enabling automated reports
> again for the stable mailing list! We now upload more logs to help
> with troubleshooting failures.

Great, good luck with this!

greg k-h
