Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3B53096AB
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 17:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhA3QWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 11:22:23 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52885 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232060AbhA3Pgw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jan 2021 10:36:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 59C695C00DE;
        Sat, 30 Jan 2021 09:53:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 30 Jan 2021 09:53:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=jLsSKdpRh6df22y6UziEoni8WLB
        LKtS37mDY6OxCe8o=; b=Son7sHYtqPjq52LJfpVJOk9dZI8SpcOaodIdQSda0Ms
        bSb8a58pnn3U81caHHygdD9ZV2hEkvkVS93fEw+0jXGZZOF8qcieML3P8Bb7Lt7c
        ONWxrDC9e/xSxMCYVuxCN9SpLWmi33ZZaE7TceqjhUZKDNjs/A0ISVkqAwHavNa6
        QCy2m+4+Gmdwo/zNVgNLNdd5Uj1Hq5Xt3ULIkUEzM7E2wOl9UHmDOITIsKaF+25H
        cHUCaR9GLdXs6uVu9BD0AcTMySmmsa6TnjQbdsnhnayhhg/rSi4TFHJOl040ZMmS
        Ed10cOpWm3lccsgWbFq+OhkTAAfEwara+ykaqHjgdjA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=jLsSKd
        pRh6df22y6UziEoni8WLBLKtS37mDY6OxCe8o=; b=St89TsSyX3/Z7VKyFdCvLr
        8ieGS5QTfua77s3kio85NOEC0XGTdgiwNf1JZ9mGuCu4zcGWUGGxfCY4z9xNdvIr
        YPT5hSYa6/Wxc0FFP6tDGHZngWs3O7qD7ifo+sEsEihsYGPWa1IdMuGFn0JXnzSh
        iWijAgTEKfgIuUhp2AD4nMniKCLfAtmsHvKWN6dFEd8g9ZT3yEHMsXr9Lp71Sd9T
        UWvAjD11QmFMGyoNN0CH3idtJtnbqaq575mGhulxUWPMFeHfnW8wqJe4bsj9ZTsy
        /MmQBSVTQmwE7oaZVbOxUube8BNTbQzD6RN7nzpA/uJXo0vVO0+53cr0+w+hB1NA
        ==
X-ME-Sender: <xms:B3MVYBRj1LU_TKJcrNZ7Zy-ajbekO_3Ia9MYDve9uGf2APHvNhK2tg>
    <xme:B3MVYKxD2DIfKJTQE7WtYVkltjOy3MRhsH8rfi9OEaWyOiPx8_yuqaVZLbXMCykbw
    5a7JfTDB0g2Bw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeggdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomh
X-ME-Proxy: <xmx:B3MVYG2w0XR7Ke1AzjJgMA3inAgrHlAziihe49zKASVPFiAbqFmu0g>
    <xmx:B3MVYJB4KZHSFrCktskW5fcfwjjQ5Qa95zkwCOc1LCXdzFNpjbCBQg>
    <xmx:B3MVYKh5_VGllwU50R1RD_2MBKt64rFrx0yo6spKfK4ZKIS_cpJ3rw>
    <xmx:B3MVYAfAiOtXGjV0YLXFgj7W1LyeIiopxakFrrWf6q97vRgI_gm20A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D683D1080057;
        Sat, 30 Jan 2021 09:53:58 -0500 (EST)
Date:   Sat, 30 Jan 2021 15:53:56 +0100
From:   Greg KH <greg@kroah.com>
To:     Robert Hancock <hancockrwd@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Patch for stable: iwlwifi: provide gso_type to GSO packets
Message-ID: <YBVzBMteZ3uHnzeC@kroah.com>
References: <CADLC3L3RS-fYZXqPB_oZwfoFgBRou8O+5-1p4DetwQTH1UssyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADLC3L3RS-fYZXqPB_oZwfoFgBRou8O+5-1p4DetwQTH1UssyA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 29, 2021 at 09:40:33PM -0600, Robert Hancock wrote:
> I'm told netdev patches are going through the regular stable queue
> now, so I'd like to nominate this commit from mainline, if it hasn't
> been picked up already (I don't see it in the queue currently).
> 
> This patch is reported to fix a severe upload speed regression in many
> Intel wireless adapters existing since kernel 5.9, as described in
> https://bugzilla.kernel.org/show_bug.cgi?id=209913 .
> 
> commit 81a86e1bd8e7060ebba1718b284d54f1238e9bf9
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Mon Jan 25 07:09:49 2021 -0800
> 
>     iwlwifi: provide gso_type to GSO packets
> 
>     net/core/tso.c got recent support for USO, and this broke iwlfifi
>     because the driver implemented a limited form of GSO.
> 
>     Providing ->gso_type allows for skb_is_gso_tcp() to provide
>     a correct result.
> 
>     Fixes: 3d5b459ba0e3 ("net: tso: add UDP segmentation support")
>     Signed-off-by: Eric Dumazet <edumazet@google.com>
>     Reported-by: Ben Greear <greearb@candelatech.com>
>     Tested-by: Ben Greear <greearb@candelatech.com>
>     Cc: Luca Coelho <luciano.coelho@intel.com>
>     Cc: Johannes Berg <johannes@sipsolutions.net>
>     Link: https://bugzilla.kernel.org/show_bug.cgi?id=209913
>     Link: https://lore.kernel.org/r/20210125150949.619309-1-eric.dumazet@gmail.com
>     Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Now queued up, thanks.

greg k-h
