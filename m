Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAF41AEB15
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 11:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgDRJJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 05:09:00 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:47821 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725857AbgDRJJA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Apr 2020 05:09:00 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 83C82800;
        Sat, 18 Apr 2020 05:08:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 18 Apr 2020 05:08:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=I3+hNamD06GpqMcpkaeQWqXgF+q
        rqmvtjmVJA5/PzPU=; b=ndFhUrxTRSDpZ3Nv735GHBkD+lwYO2qUfycnBWeTShu
        4wtYZ6/7WdxQE6mFdm//uaZhWpPRpCh01CEwBRoG9tFuN6lYZ5WBMbTDHRQrzxew
        +MHoIt2zRgUuv5fKTyq+dAQKU+Vl/rA+QVIu94PJj4axK4a9tMZcx7s6lc2q6G03
        pEQgTjp8qUyTDZKGoCE4g8C5uQNWMbzDgOa87EYzTjlB+dA9GUOKwRYQ2RryVX4G
        GDqJsHNj0Fm7mytc6DaNEwcTmC6dpeWxe9ILrmZ4S5Y5ocEB78FnmpPQR04lcmX2
        AwEYv9/IKAg/l8Lp/McSOUnrpeOMMyvlQMdpzFaLlKA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=I3+hNa
        mD06GpqMcpkaeQWqXgF+qrqmvtjmVJA5/PzPU=; b=KxI/Onr1WJx6aTQvVuJQFR
        0xOB3k1H3oj+PTXZS/m+Qa1JTI8WFLy/HppbtF6tsuRFe+YMk99pVK2EhkJnGqDO
        oN+Uksdb8IIm6nxU5WA7GL+bQ3UPQ+U7SJSO1PQHtP/7QADG3klEwIMQD9nJ/Wz/
        W75pBw2p6FTcbHuqGKuHoAIdODQNoGNiax/Ekz3vrhqskfkcQdtvoCiVW+k2BqXy
        MUbTTrGIkbNdBPIAoEkE//dxSetZkajoW4ifIrXI55vGhg4Uh2IElC4d78nhFin0
        VPcUWmQR40dCxF6qpn5IrcWl9P2oA0t+UNU5xY6OaN4PzzG+jCipzCWweXTK11DA
        ==
X-ME-Sender: <xms:qsOaXnz_qb9RbEOhxMlXp0jpD_IhHa5ZA54teusH9Hmzw0ZN7Nfhdg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeelgddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:qsOaXsqY-_gqCkmhA6SWZnBTBnNOcXkuxLRjRLaUXaO8m5-K8VVcYA>
    <xmx:qsOaXq2aD9e6-OOqObxjtp3mZHJyOQszjiwQ-6k9W8acT2QkDDtgVg>
    <xmx:qsOaXswLk71zXYEsiQI_qG04Zz3tSahf3DHproWSsS9RZudZeo-mZw>
    <xmx:q8OaXvwCfo8-GPSeE-68h2J3dIth63qc7kjhnHMbO7iN5DIHDuWNIA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 93A15306005F;
        Sat, 18 Apr 2020 05:08:58 -0400 (EDT)
Date:   Sat, 18 Apr 2020 11:08:33 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200418090833.GA2432903@kroah.com>
References: <20200417.105100.821338189941807731.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417.105100.821338189941807731.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 17, 2020 at 10:51:00AM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for
> v5.5 and v5.6 -stable, respectively.

All now queued up, thanks!

No need to do v5.5 patches anymore, that kernel tree is now end-of-life
after this next release.

thanks,

greg k-h
