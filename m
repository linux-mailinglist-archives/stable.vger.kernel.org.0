Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728F7327F42
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbhCANQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:16:30 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54573 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235519AbhCANQO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:16:14 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 4C0EC5C00EC;
        Mon,  1 Mar 2021 08:15:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 08:15:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=1
        Pe2IyPmY560XOFrxaPfizQCmaqW+xt4WTzJ89t7Qds=; b=da8PxaQSuz53U+9dT
        pfB3wkj51toBqy8Iy7pGVN5w1qzuT2l9G9/N0e2YbLuVdBpTVrAn0WZw43ggFhCr
        i/zZODE4AbmB4QJ7vqE4+DjVF3tBPdQiuZ9rfF0p6+Wimk9x93QdCNRBpOxAa2qP
        LZO5f7NLks8t7qhtGfEK+WhtVr4fJkBFCBjK8ETiMaGptmNmLV2T9+rmGWM7NGHu
        m+6wkOwPglBn2vmbVASlg0X86blmuP7aTyvCbORl96U1LrmP1tK0md9qtPUiNnhL
        YuxUtJ+TyeIpe8E7ugVhlyqdQqLr9Lj7YN5bfdkaQ8FEFLO228REVhIZWGBro5LE
        kEjKQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=1Pe2IyPmY560XOFrxaPfizQCmaqW+xt4WTzJ89t7Q
        ds=; b=g+7ZblKhsNLdaEw6RP9H+oSv7IvfdLtk6BSc8kzgbEMNebAgv1zNtkpEm
        aAk2kbeXr2aie/dyLnIn5Y0DwpPU5jVKucanNiAjW++P0B+xaLupw1W5ktQUStH0
        KNXrfDnCPgWyq+ieWSX6WYZyu0jCflKpxxaLUrYTfz4cByidkdLOfWwmOOXpJW1r
        e2YOnp7V0GbR1xbSTXIN6CaAj6r2DuJZFP+/BPQDOXHdhFlUu08eqOhUtcHXJJRN
        aO/tzpAqZgYRx3wCZ/zJs+ErNERYJtzTx4HlttkYqzvBuVZs7FVGhMm2/qtqgA/v
        qKii73V41EcwTmxIdCgXK9mnJRcfg==
X-ME-Sender: <xms:1eg8YK-rPAf68_0L0-L2w_uE7dBE5wXkJ3imu-0MjlLwVVIbpTY10A>
    <xme:1eg8YKtvXuZqpzhp_kndux_01F01lC0XxE2yMnnkuqtaa3caOoJ8NWS0qJS72kV5U
    W18I2QlcMwaCA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpedvfffgue
    eiuefhheevheetgfehvdefgeekfeevueejfeeftdetudetiefhheffvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:1eg8YACGjSHYzLHc7YjNgwD8ex0s_O6itykxFsnshFWPFNQNQvo-wg>
    <xmx:1eg8YCd6iTzUI-jn2lqY-fsT9z5Mmm4EuAROw0qhLnR_1DPKlnG0Yw>
    <xmx:1eg8YPPQf_SkKxvWAieRtewY6V-NajUN6r2j4DJXBYNhGC_-MX3ylg>
    <xmx:1ug8YIbpKsQ75oFbrIxpWpL7GjM5Xw8S-3jH-54_zd3IuG5fGPemmw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 39E52108005C;
        Mon,  1 Mar 2021 08:15:01 -0500 (EST)
Date:   Mon, 1 Mar 2021 14:14:59 +0100
From:   Greg KH <greg@kroah.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     fedora.dm0@gmail.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH for 5.10] powerpc/32: Preserve cr1 in exception prolog
 stack check to fix build error
Message-ID: <YDzo01MSvxr4CftS@kroah.com>
References: <f6d16f3321f1dc89b77ada1c7d961fae4089766e.1613120077.git.christophe.leroy@csgroup.eu>
 <YCqFn/4YuT+445xW@kroah.com>
 <d0b1ff43-59e0-29a4-1bd0-47bcfff8effa@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d0b1ff43-59e0-29a4-1bd0-47bcfff8effa@csgroup.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 03:39:20PM +0100, Christophe Leroy wrote:
> 
> 
> Le 15/02/2021 à 15:30, Greg KH a écrit :
> > On Fri, Feb 12, 2021 at 08:57:14AM +0000, Christophe Leroy wrote:
> > > This is backport of 3642eb21256a ("powerpc/32: Preserve cr1 in
> > > exception prolog stack check to fix build error") for kernel 5.10
> > > 
> > > It fixes the build failure on v5.10 reported by kernel test robot
> > > and by David Michael.
> > > 
> > > This fix is not in Linux tree yet, it is in next branch in powerpc tree.
> > 
> > Then there's nothing I can do about it until that happens :(
> > 
> 
> It now is in Linus' tree, see https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3642eb21256a317ac14e9ed560242c6d20cf06d9

Now queued up, thanks.

greg k-h
