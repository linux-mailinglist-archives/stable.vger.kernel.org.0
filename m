Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2653339F9B6
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 16:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbhFHO6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 10:58:23 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:40655 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232833AbhFHO6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 10:58:22 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.west.internal (Postfix) with ESMTP id 3E6CA1B7C;
        Tue,  8 Jun 2021 10:56:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 08 Jun 2021 10:56:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=LsjfloHh5GDJEC3lTSp1I0iptth
        Ud9iSw/Q5cYHpyZ4=; b=mOBIbGns6nUjiI8VBF1b8FebY3owHEuFvh0OLmubnPQ
        3cwQ2Ek4+yAJFTh+WuHFnlG+mfA7A9uAW/cZFHY10a93TkrcI4gaDIxRf+iYIBQP
        9HFHap0vlJXdC1RvxEAAyxN4SFeQ6yWV/+TclrxGyiHSVJrf+WbJessdg2yUAx2r
        I1pN6WZ71PFEGlPHP/OffZsC7V9iZ8FbnanMujbnfXcDOt0OD2J2nY38Gq/SrbPw
        fz2hUZy25mJTsU3jJ/s8vT4oxZ3eufaoUnw12osap3wEDPydylg5PRE2l21joCU+
        4lyxfh75n3+nIY03817OZxfDeODyqo6PLWSwPvCfG/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Lsjflo
        Hh5GDJEC3lTSp1I0iptthUd9iSw/Q5cYHpyZ4=; b=OGEsFKhZEbl2+TjixfpgMZ
        Rc4Xtcn/iyIPxoPt1etk/WTzZbRbtsMrwP9S9fUhFxgprhsp5YU/V7XY1SL4oaIW
        +Js+qabx6XD7pyTT7/qpTyxBAlDnb2LAz6pNvDpI4Y8k5rW5mr5G281gcZtOYvu3
        BwmTETXblQBznsNWn2ARsowAIK1MLQ7Or9CfWa3Walm9vQkd8WIvP25GeicFMBp7
        FYzAIjRefiuUZncjyexpDrtYD8NuR/3A9AuCgyJZhZ11Yl+mya2ZF5kwc6ZAOnCk
        ZboI+ejvUfzyt3m0ogiug32XR4OaGXXxKVVKw5OpbQy9VlztPgkmlfdkrUAqgfHA
        ==
X-ME-Sender: <xms:G4W_YNYesRWHQxM60EVgcIADrlVCeUeYDDstuOvzhDfQyF_88yPe3Q>
    <xme:G4W_YEaBXKc6Yey-tHyNUPGEF36o20c88YM88mHrEX1javMlGFZV6nojP9fxyOYN5
    PNvIW78a8-3yQ>
X-ME-Received: <xmr:G4W_YP9GcDZhQi2i3wCpJq8W0rfz05SLj8APTM9XxFJqG8vuC1wQcqHupgwd8iDaSMU5E68DUGP11T3qrV4pu8zEW9dS6bsV>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeffkefhge
    fgvdejvdelteegheeiffdtieeiudeitdeklefhfefhjeefudegudevgeenucffohhmrghi
    nheplhgruhhntghhphgrugdrnhgvthenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:G4W_YLrAjueq1frKOpKCtw-r4zDwKUb9HJ66rxy9ZUy4OQe32RCoOQ>
    <xmx:G4W_YIrvqgxQwCb4DHXluUi4Mm9dJ8RuwIxKXo7SqU-RbRVZ5BFZ3g>
    <xmx:G4W_YBSWHPjMR_5zB_ol1O1sVlGeMR6JKv6K1nZpoqj4QL3Hb2Oo4g>
    <xmx:G4W_YOiG_8WXfKQG9xu2No5KGjd7dHzZWOXL2b7a0MAjFiTXxadr8e9G3Zg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 10:56:26 -0400 (EDT)
Date:   Tue, 8 Jun 2021 16:56:24 +0200
From:   Greg KH <greg@kroah.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     stable@vger.kernel.org, thibaut.collet@6wind.com,
        jean-mickael.guerin@6wind.com, alfonso.sanchez-beato@canonical.com,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH stable v5.4] bnxt_en: Remove the setting of dev_port.
Message-ID: <YL+FGIKepS2B0knc@kroah.com>
References: <20210608144621.668749-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608144621.668749-1-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 08, 2021 at 04:46:21PM +0200, Krzysztof Kozlowski wrote:
> From: Michael Chan <michael.chan@broadcom.com>
> 
> commit 1d86859fdf31a0d50cc82b5d0d6bfb5fe98f6c00 upstream.
> 
> The dev_port is meant to distinguish the network ports belonging to
> the same PCI function.  Our devices only have one network port
> associated with each PCI function and so we should not set it for
> correctness.
> 
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> 
> ---
> 
> For stable v5.4. Earlier could work as well, just did not check.
> 
> Reported for Ubuntu backport here:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1931245
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 -
>  1 file changed, 1 deletion(-)

Now queued up, thanks.

greg k-h
