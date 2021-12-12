Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76540471A5C
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 14:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhLLNT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 08:19:28 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46523 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229907AbhLLNT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 08:19:27 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3512E5C0101;
        Sun, 12 Dec 2021 08:19:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 12 Dec 2021 08:19:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=9YiL4Wfiy0p+Py9fS+lYkEqMFCH
        mMq33xXCyFncKeIA=; b=T8+17HILb0ltHz8jaTtJcRJaTOTWVTApOogzWX5/63c
        ve4ABQkNsksr5UnaJuQhPfn/B4Eh+TfN0Ehfjq1mPs/3UGUs1lemv/N8DX080MLb
        O4SdEEDhYsC4Al37IDWDTWyA/FEcB+JVw2Nm9WE1nSSedI4on34yACIE8gnGDlqn
        p5SpwTgL7OC5h/GHXvpJntHX2rT1+n4v791fI4xFCP1UXQGdGkNo6fPwyIhNjrDi
        wbAylM1mUtvQpPJTZ7W2sDXLeKKcFxLjAU0qs/X3pLDDo5n0yPlvqGjNjOkoGfWe
        yBDvWBr+ioyzEjt1Re+R7ZkdCcTUZgF7uXvO3azZPAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=9YiL4W
        fiy0p+Py9fS+lYkEqMFCHmMq33xXCyFncKeIA=; b=lBGEWcHwlgG3LmC7gw4v5H
        8RRymMgJJnmR81F3SGvXG8E6fLLEsuvNWCEIzYNg+p1rJ2wcNTRvesXm/+KsAsyb
        lB1z3kajdcblrhQrpHZqnwALBUwNZZOjNW6wRIL0F7oa/pIWLE2rADxfMs599e04
        gkcaF6OznhPiqn9yMkM7RzdzbOiuOdAJGPUeEcR13KQb3yDBcuDeLgXxSywgKreE
        xKem82iZvSSIGZBBRIOBmZ+giBxP4x2rGLaG8DwEx7mFxvSUrlrKVhkgTUpptxLk
        UqpCw2zoig/nSTyXJ/baJbEaWUVP11S/I2YbrZZIeKIzHJ1w3y/bc2/NCn1325Rw
        ==
X-ME-Sender: <xms:3va1YTC-zmd9lHST1WJSd9G2noJJwCPHd2Ypbwbh37YGBBsy-zVdLg>
    <xme:3va1YZg2HC5g-NiHZA2bfTInHQEfjvhcMd4hPhHau1doiYVn1mov9SaNpbZz1TnXF
    WQjt1WbFrfwBA>
X-ME-Received: <xmr:3va1YekmkBZoJ0OMG5wlXChvtAWPkBzgRTgOW47VhB_xhsK4lV5nl8Qm78DJAzn69ZaZznRJjipxcSaIQEXxIQhS-bUgRTog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrkeeigdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:3va1YVxTBVBJ44TdwLRCKSLW6Y9eV0rxF0nncaIpAlbpnImKVf8dqQ>
    <xmx:3va1YYTqPLikgcCvBlWwghPsa6_d1xyslnvjVFNnJB0xEHhBGP0lVw>
    <xmx:3va1YYYOOVednSPXsnAvb7lqdL6tW17QwutWGcI_6aphAss5jr2BOQ>
    <xmx:3_a1YeMxL8TkhnBlBvUrgSFjpVQVb_4m-ocv-Ow_I-6uhlXiMiDTrg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 12 Dec 2021 08:19:26 -0500 (EST)
Date:   Sun, 12 Dec 2021 14:19:22 +0100
From:   Greg KH <greg@kroah.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: Re: [PATCH] can: pch_can: pch_can_rx_normal: fix use after free
Message-ID: <YbX22nbGbYFWKele@kroah.com>
References: <20211211212306.797338-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211211212306.797338-1-mkl@pengutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 11, 2021 at 10:23:06PM +0100, Marc Kleine-Budde wrote:
> From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> 
> commit 94cddf1e9227a171b27292509d59691819c458db upstream.
> 
> After calling netif_receive_skb(skb), dereferencing skb is unsafe.
> Especially, the can_frame cf which aliases skb memory is dereferenced
> just after the call netif_receive_skb(skb).
> 
> Reordering the lines solves the issue.
> 
> Fixes: b21d18b51b31 ("can: Topcliff: Add PCH_CAN driver.")
> Link: https://lore.kernel.org/all/20211123111654.621610-1-mailhol.vincent@wanadoo.fr
> Cc: stable@vger.kernel.org
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> [mkl: backport to v5.10]
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
> Hey Greg,
> 
> this is the backport of
> | 94cddf1e9227 ("can: pch_can: pch_can_rx_normal: fix use after free")
> to v5.10

Now queued up, thanks.

greg k-h
