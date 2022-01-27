Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7F049E629
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 16:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbiA0Pgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 10:36:35 -0500
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:41591 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237659AbiA0Pgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 10:36:35 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 602D22B000EF;
        Thu, 27 Jan 2022 10:36:33 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 27 Jan 2022 10:36:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; bh=MM3mlkgPNz3VRanbe6Q2yF8PwWWepcvoMK3Gfx
        hgWQs=; b=P2YQ8gi+Lu9QFkGb5ntAXFjxYQyHkFcM9oLOuKOo3uYqntdqgXi9+w
        NRAHIcF3yeMynrermh13Zfu+wxYNYQ6GbI1tmPrI7UxS8W6eKx7akBmr7FqqXOe3
        cPaFA+WocVMqf+3n8/nU1MKO6di/QioQ11RaP1e7JIJ2n4vuDhlQ3ZIJxvYe0PtG
        ywUNjwb2+M2AChhmiQZQe8AZeQh0MFCgjBTygURKRpX3b8nlKjj7ZktSYHBOG2oT
        pL4Kp6oVTlOqlVEcuRwg9TRMLrdZvZfaoJT4KjSSoLyFL3j6sV8bdOEG/KpO2ai2
        tDLIQkHFbQeZHOdkeAa3OAnQ3SgUMJzQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=MM3mlkgPNz3VRanbe
        6Q2yF8PwWWepcvoMK3GfxhgWQs=; b=k5s14h60VAO9d7lRux0hmyLpKCkELrhQr
        0feRYcYkI8gSlWOUh5z5wg4MBcVdoRlgQ8xKWQdsvZ79swSemahTM1Zx2y7Icw6p
        LbgCVFEJbvbbhJmCM4/ra7/s+AVy0l0aP5UqMpPKAtdKhytoq0XpYg+ErBw+Y3vQ
        MwGyVXMs/bfibdKOT5aoIbJ7TPsPtp/nmgda40BoxFhjlT3xk3xJ3msg9x4Bmkvp
        Ku46z6O3dw2RZ2ZwIc5G+lELDVWgkvy/BMo3hxyXaNIgpDuYb1y+VmkBijTftYjr
        N1Np2u4RUxadnAQjBd+Pn+bPahB8pJRgOsLoWtJxfEFoGcIsYrXLQ==
X-ME-Sender: <xms:ALzyYYO0iSMvUjjw3vH0eDhjRm1D1w7prLtfqhpSE92AbmjuBlwCOA>
    <xme:ALzyYe-piSTp-wF-Hq-ai8aEX4aOtbM4QgKrnH0J1F5LnvJo3mL9M2YV8L0luGdbn
    95BZI-66RgX6Q>
X-ME-Received: <xmr:ALzyYfRs_h4yA49YU1L76R-fJ2DaA-HQZ-Y95746-hfQFWJzZXG6iZHlje2zCdIZDvl76yYBs1S6L3HFkb75oSzyN-pggH9q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrfeefgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:ALzyYQsICxZJEZAFI8FD2CXpjHpnjyqLGZ07pi78Le03L_alj5_c9A>
    <xmx:ALzyYQcTVHyhWzBfCX2762smN6R8Fq3KRpEqaOTVe0Le2nLxatpRkg>
    <xmx:ALzyYU0AP5aPgPcFzUuCWfUCugOS4z8tf-7S6JxNnNNtWUzRQebdOg>
    <xmx:ALzyYb00atEtGdARpqP5IaPw3auPRm4aR2ItJzpNLYUNOKfoD1yYoXByDow>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Jan 2022 10:36:32 -0500 (EST)
Date:   Thu, 27 Jan 2022 16:36:30 +0100
From:   Greg KH <greg@kroah.com>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        Stefan Agner <stefan@agner.ch>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [4.9 PATCH] ARM: 8800/1: use choice for kernel unwinders
Message-ID: <YfK7/goKdy5qlhEc@kroah.com>
References: <20220125134148.3390940-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125134148.3390940-1-anders.roxell@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 02:41:48PM +0100, Anders Roxell wrote:
> From: Stefan Agner <stefan@agner.ch>
> 
> commit f9b58e8c7d031b0daa5c9a9ee27f5a4028ba53ac upstream.
> 
> While in theory multiple unwinders could be compiled in, it does
> not make sense in practise. Use a choice to make the unwinder
> selection mutually exclusive and mandatory.
> 
> Already before this commit it has not been possible to deselect
> FRAME_POINTER. Remove the obsolete comment.
> 
> Furthermore, to produce a meaningful backtrace with FRAME_POINTER
> enabled the kernel needs a specific function prologue:
>     mov    ip, sp
>     stmfd    sp!, {fp, ip, lr, pc}
>     sub    fp, ip, #4
> 
> To get to the required prologue gcc uses apcs and no-sched-prolog.
> This compiler options are not available on clang, and clang is not
> able to generate the required prologue. Make the FRAME_POINTER
> config symbol depending on !clang.
> 
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> ---
>  arch/arm/Kconfig.debug | 44 +++++++++++++++++++++++++++---------------
>  lib/Kconfig.debug      |  6 +++---
>  2 files changed, 31 insertions(+), 19 deletions(-)

Now queued up, thanks.

greg k-h
