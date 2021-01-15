Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEB42F75FE
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 10:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbhAOJ4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 04:56:22 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43269 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728805AbhAOJ4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 04:56:21 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 6BACF5C0194;
        Fri, 15 Jan 2021 04:55:16 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 15 Jan 2021 04:55:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=nPLPKGJPqNerSPNfyuV7zXi6UIw
        d8aJLoN35yKzep7U=; b=Du69bdjGru1PeyJa8oe3OnRoHnAJvMDVFZfDPd/W9jF
        4GiiDokQwEF8RZZKHONIopgUAh4n5K57ZT5vkOWGkqKFGpNV3siZlJqH00U4PZBF
        tUJ9GKMeULVkdJ7hZnM346V69/6JaP7Msm1HE6nyDgrPceolxThfOnxjXN78nd7V
        QsXDPMb7upsvjFm3D32aXhbIlmg90Tjircmde7Q6GZJnc+wFEgGt/NLYfRCq747x
        gAoD7jpnpn0t8kYODu+ZjP+fRUyb0NsHxPJbdWwu+nFnQNDHyEhs54csHSU25lkr
        xpNJVcib8JERJ1ydwhCefdztg7Lm6hoQyhKH76+i6Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=nPLPKG
        JPqNerSPNfyuV7zXi6UIwd8aJLoN35yKzep7U=; b=X8zpqvimWsgz6yfBRaKpv7
        FSwEIFCIST22Jxu+I+OIkPVtAeDmwIIqGm8zkUDZHGhpDLit8RFK+VeEiv5TYe2S
        4KFi8Qbt5hLurZWZEUh/iHBCwtitOtkDmtNFSKijSFpidKkRdmNlGdWLfE0Ekqd2
        YXX5yzYVkjoqelrm9ULs9rdWxs/DJhl2ugITIQhbPegV/mjuExf+tYAeNhzcO4OL
        LM6+nVrjX8RFhAt8hP6F0WXbQVtJRVEM1cvtFqgR7naWDj9hbsA4/AwXpXJeC8Ae
        JZpTMJTR+4pLXLJG4b87kzGWjSkwJwRi3HpaFL7+3P+MXQEoNO5yIafxuG9iObTQ
        ==
X-ME-Sender: <xms:hGYBYH0d5lEYjp4i0Q-E7BgiDdViATxnSf92ycv3H2073udEqh9tfg>
    <xme:hGYBYGH4qnrozmSxgS6ijPD3vRHbxXH8J1VrIya98NK5HBch3og0BtRcvMHACns_A
    Z8AoUrc-T5H5g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddugddufeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevhefgje
    eitdfffefhvdegleeigeejgeeiffekieffjeeflefhieegtefhudejueenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:hGYBYH4_v-T9pxHQkHzDQLRPPAV3mxGNMMEVEyy5aOj8F1N5SnLXIA>
    <xmx:hGYBYM2ohEl8LhxqsMlLDsiTKoqklSZmTD0jyxPljKoeqYNYxCNReg>
    <xmx:hGYBYKHRYxz_bx7Dz_EpoqxMefFN6XEgSIgtLuFAkjPNfxzhISmNeg>
    <xmx:hGYBYFx2F5Xg3IbfV1Nl8S_VsiaWwVCEwmVmZ0XYKGkEiMbA0gxBfQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0681F240057;
        Fri, 15 Jan 2021 04:55:15 -0500 (EST)
Date:   Fri, 15 Jan 2021 10:55:14 +0100
From:   Greg KH <greg@kroah.com>
To:     Ping Cheng <pinglinux@gmail.com>
Cc:     stable kernel <stable@vger.kernel.org>
Subject: Re: [PATCH] HID: wacom: Fix memory leakage caused by kfifo_alloc
Message-ID: <YAFmgjODorqwZYwO@kroah.com>
References: <20201210045230.26343-1-ping.cheng@wacom.com>
 <CAF8JNhJupLp4hEaut-W2d1eO1EyV1WmdgRh0z0bPqHP1jGQkWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF8JNhJupLp4hEaut-W2d1eO1EyV1WmdgRh0z0bPqHP1jGQkWQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 14, 2021 at 09:01:27PM -0800, Ping Cheng wrote:
> This patch has been merged to Linus tree. The upstream commit ID is
> 37309f47e2f5.
> 
> The issue was introduced by 83417206427b ("HID: wacom: Queue events
> with missing type/serial data for later processing"). I forgot to cc
> stable.

Now queued up, thanks.

greg k-h
