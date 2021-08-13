Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D975B3EB41E
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 12:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235482AbhHMKir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 06:38:47 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:57065 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240029AbhHMKiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 06:38:46 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id AD05D32001FF;
        Fri, 13 Aug 2021 06:38:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 13 Aug 2021 06:38:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=mw792gZN0Imdc0DF/tjvXEL90GU
        EvSAKhh5V07TsRUI=; b=WwZERVahuYEVcaOc1hhpbTIC2iw0zZ9AhvYw/kVL6ft
        QMSMYkLoVk+YYoDB23/AHp9DmzoxoIp2xFf8Vfv7vHgaFUIcPqqqrfCJDINFtQbg
        yxaKt+awqrPflJQk636uxMFSZg66idE9HxvrtwexCirwFkq6yyefXaT7T60D8LcR
        GEcBQPVB2hnrBTHKI3lH1pL94fNQdW24QOkXehbeT3Fw70msQCqqyhiMq6tyYTbK
        qkL+O+7j4jfGF2wIUjyUw2Vis/PJPFNH7CMmZVO8GDIu/wpe9nAHlhJV619uzSlx
        FtWsusLwjVCC+OPCtn+ywyHjQe2RPYIR/yKjdP6FetA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=mw792g
        ZN0Imdc0DF/tjvXEL90GUEvSAKhh5V07TsRUI=; b=l1VmmeLbtESDYM9MC4Nj87
        ssxI6p0iCRa2jGIvevnYCuYeHD7XJAzcALQRzIpPiWr1SrsOISAacVt91xHycxjl
        4yUVU9lOX2BrQDd95J6TsRLq2BMCr2A+dGhUAyDHnWwDWtZmZ6KBsR0WQEI0drbD
        ejN3qNdFmxYvxgrm+0+Kk2y9W0JSqSBGozEFU7b/jMlG9mjxJF0Gl4HFkqRVxtma
        W6GWpYhiJ7Ag/VuHJeywvaRDucdddaeeGCHmBKt5NR3g9uPHCdmk0QaTyknjIUnI
        0CKdNqN9RogEP5ZN99t/AUh1ELERscd78ZNpEV9Pj5Xas3oPabHQ4Wv8v9HJ1zRg
        ==
X-ME-Sender: <xms:mksWYTlrF58PWQpaiTGZGbr2xJjpTmcp-ftUrIuzjbWxqY6X7Efk1A>
    <xme:mksWYW35z1WT2QckE2Cjo5FxcmtiA82L79ZNxj5Vy_tR50XpgfcuvFMbJ6jGFiJa3
    suw8NyM-Bqqrw>
X-ME-Received: <xmr:mksWYZp5gdFRT6V3knKFsFiKhEm9ROY-4yioHxNJFLa8EOA_Pr2Jsiz9CSU2LOYUNZn7gaarP4Muup1GllhoCYTsDPs04uYv>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkeehgdeftdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:mksWYbmOPHLBEgUxMYIZsHDxMdqK5PCykGmkxThhWj5D7AffVTbJEA>
    <xmx:mksWYR2_0kjPUcKWY4zSZvM2GLxZoXc8187c3kxc6XU5geUk--pyug>
    <xmx:mksWYasJEi-yJv3YMawQudhURj4aKXX2CKUc5S-DprULS0GECGehWg>
    <xmx:m0sWYcTVR25dUNvrtObEFaVOiUhzAJwZLERYS80V-v3pGq7qHi_pag>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Aug 2021 06:38:17 -0400 (EDT)
Date:   Fri, 13 Aug 2021 12:38:15 +0200
From:   Greg KH <greg@kroah.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     stable@vger.kernel.org, yuehaibing@huawei.com
Subject: Re: [PATCH 4.4 4.9 4.14 4.19 5.4 5.10] net: xilinx_emaclite: Do not
 print real IOMEM pointer
Message-ID: <YRZLlysTiHFFV4hi@kroah.com>
References: <20210813102840.GA31185@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813102840.GA31185@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 12:28:40PM +0200, Pavel Machek wrote:
> From: YueHaibing <yuehaibing@huawei.com>
> 
> Commit d0d62baa7f505bd4c59cd169692ff07ec49dde37 upstream.
> 
> Printing kernel pointers is discouraged because they might leak kernel
> memory layout.  This fixes smatch warning:
> 
> drivers/net/ethernet/xilinx/xilinx_emaclite.c:1191 xemaclite_of_probe() warn:
>  argument 4 to %08lX specifier is cast from pointer
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> ---
>  drivers/net/ethernet/xilinx/xilinx_emaclite.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Now queued up, thanks.

greg k-h
