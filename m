Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14AA6504F62
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 13:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbiDRLh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 07:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbiDRLhZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 07:37:25 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64C1120BF
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 04:34:42 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 344BC3201F68;
        Mon, 18 Apr 2022 07:34:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 18 Apr 2022 07:34:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1650281679; x=1650368079; bh=tYWFaprF4d
        j9WQiGTzBde/5dbLt5xrp6SM9mEO9qZ9k=; b=FuWnN4kpkLtpi/hOuvZHjweyIt
        E9MukUe4dWo/euGUDYDVzOXddeYiG5GCd5XOazN8qYJVXj+E8w4unyYlwfhRCMI5
        yIcQc2YPkUrXfXg39EAQj08nH9pmdaOymLCPH1FNa0/HuBzYSNE+5VUXawZUUFTW
        8n3I41n628/qu/fTO5Wc9Doa+eiW8DtPyvd+02Rs1qTxj+bTv+qQF5RF0tggiPL/
        +VQ/ayfa8+JnG5EdqdDEfAAQw9qR5GOlnQJvo6SHPYKe/ettNPa8m4UZL9VFnyrp
        e51ejO7K5s3KLQDnlEoFZW/5OtCj0EZuOp8y+JF3sJqXoBIlXSz9ZCYAfBsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1650281679; x=
        1650368079; bh=tYWFaprF4dj9WQiGTzBde/5dbLt5xrp6SM9mEO9qZ9k=; b=z
        kyS0Zb2UijqHkbIjZ+lrWsQzbNOgfzm2oovFtqdxz+7KpKi4YaKZAPkqgtwxh/N1
        fAzPLISIgeAjLf/Y39nDU0BKYyYMmfzR3RP0LyrQRGPElDadiRza3UJ4nUJZ505L
        l2+zCAXhsgUoaSLlfaNXIqju71XHRJoYLNLedRAoAVjeiPp5FGPmELmb98df2DsD
        D+dQyBaPbh1a9lhCc88nWQkc7tITsa3jh/Oybv9VRLVdfRdLGOFWFBVxFVUni4cY
        cUkJrRAAC5xSGM2JZokbQnp6EOfzqus6LFFAEf4ZVxvh7FcXollHOyUENShbnv7Z
        crjwxl85gy0qztg4P0gYw==
X-ME-Sender: <xms:z0xdYtUl2gF3TCP6oZHgWA3awhORp0o3JNoLXZsoTHvuPJDy0nbLew>
    <xme:z0xdYtmVMaaJ8zK-Osjz5BYrelebeFti-7g3fV9sXMOpLI0MTaONFYsLfyH0ss7OF
    b-NnPgJRKKavA>
X-ME-Received: <xmr:z0xdYpYbKplfTLBzzIz8FHUHyYziTNOx2BImsMffWU6zP3I55m8DND1TRdmRy1YP3QKHEDk8GBl9tBTDhViMjBnayPOQz3kZ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrvddtuddggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:z0xdYgXv4dKQ0U0TKC8BZX7_YlTZ-QZol12hKomj2IzLjILMI3r5cg>
    <xmx:z0xdYnkH0bHmkzuJBfD9Kvm827jvesgc2BcwrFYXBgWc16Fhgfpfuw>
    <xmx:z0xdYteAKdX-Wy0qkDaa8HIL5TCU-5HLDtTke-wigveJ-eRC97aY0g>
    <xmx:z0xdYswq3rcgg4TsPPunPJIpiaKtw2La55qNEXSbXwIdJ9DJ3RaciQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Apr 2022 07:34:38 -0400 (EDT)
Date:   Mon, 18 Apr 2022 13:34:36 +0200
From:   Greg KH <greg@kroah.com>
To:     Dragos-Marian Panait <dragos.panait@windriver.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 1/1] can: usb_8dev: usb_8dev_start_xmit(): fix
 double dev_kfree_skb() in error path
Message-ID: <Yl1MzNB4LKCxyxv0@kroah.com>
References: <20220418090332.2340160-1-dragos.panait@windriver.com>
 <20220418090332.2340160-2-dragos.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418090332.2340160-2-dragos.panait@windriver.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 18, 2022 at 12:03:32PM +0300, Dragos-Marian Panait wrote:
> From: Hangyu Hua <hbh25y@gmail.com>
> 
> commit 3d3925ff6433f98992685a9679613a2cc97f3ce2 upstream.
> 
> There is no need to call dev_kfree_skb() when usb_submit_urb() fails
> because can_put_echo_skb() deletes original skb and
> can_free_echo_skb() deletes the cloned skb.
> 
> Fixes: 0024d8ad1639 ("can: usb_8dev: Add support for USB2CAN interface from 8 devices")
> Link: https://lore.kernel.org/all/20220311080614.45229-1-hbh25y@gmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> [DP: adjusted params of can_free_echo_skb() for 4.19 stable]
> Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
> ---
>  drivers/net/can/usb/usb_8dev.c | 30 ++++++++++++++----------------
>  1 file changed, 14 insertions(+), 16 deletions(-)

You sent this twice, why?  What is the difference between the two?

Also, why not cc: the maintainers and developers involved?  Please do
so.

thanks,

greg k-h
