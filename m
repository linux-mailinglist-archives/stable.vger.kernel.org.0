Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730093CD554
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 15:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237111AbhGSMUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 08:20:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37879 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236780AbhGSMU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 08:20:29 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 5E5A15C00EF;
        Mon, 19 Jul 2021 09:01:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 19 Jul 2021 09:01:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=z/xj2MtRHdqMELqOsdpmvxXOBQa
        /9fdksu9Jk/VIrGQ=; b=KI9ZY6dPdeHsjeuMnqUStkwr4Dsf01xZt3ey/ROFuCu
        wNxSA4pMKSHfloxUxv3ss0mBI21fwcK9K7KCuHMiqvARyiwj4WCxWjKSFQl7VQ8V
        1z66xZ/VsPDZG2zWl2Oh1QZfaZ1c+q85g5/zusuwjk0d2ZVNd8+yqWF8F5skZ3pn
        7NzmHO5yHFJMvqy7ixeyMQs1bu0jiDTcwVWNZux99TeZF0vJlnH2TZecmYlEPQ/g
        rzNDX5laiOIB0oozCxwQgxLQilcO1maoM4/vxWR63dkxVLoOXJw6aQ7WxrDCzg87
        qjY8pFDzlUqYt8cKuGCaILAlv/5d5dt9YIpqF4Ksltw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=z/xj2M
        tRHdqMELqOsdpmvxXOBQa/9fdksu9Jk/VIrGQ=; b=vaPVPBbL0gKCaQXmzCkOgb
        JiBirZZVNC7vAOAlRm1dm3fMEfbxYssRBAyjn22Uuzs6iU1dtNgq4Q5tMALkNYTo
        2J2VTCI8HW1YEXwqZK6FoV+4UZbZvlfBeEVsP7FHfSaVqitQDmxOu3Rndu1kiFb8
        do/WtF31V/jInMu1hxxXfsNRDxdeRmh0lLeGvtYCd4IacQhyBzgfCjSw/nnVmxK1
        zjJ9M8bF1clTe8kNEEIl24JDg9aI2vrs/PiLDvhdpKY3d0k4Db9BBYkCE2EJ7uZ7
        zV9afedM/GMhbl5OuU514DJkVoXtJeSPCwYiivYCCMtqkFQ5enbbrcQ6I0SCLXVg
        ==
X-ME-Sender: <xms:lHf1YDs13Ny35ge9CpnRaA90Imqil1bb3SZrbkwuxMXu_l6Gw2UXZQ>
    <xme:lHf1YEfI72U6x8sYgR7R-TkFIxyORRlJEI5mZ1dg9IV3bwmttpczM0l-xV04CegLS
    yP73pjmVEwthw>
X-ME-Received: <xmr:lHf1YGxo3P-fdxUuzieNy47VIsl1nsHTtHMmc7jujBLJ0ei1tPDh6IC2Zey-FKQYMdy0ZjbkDSduElOen-biaErrZbrSQuwW>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfedtgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:lHf1YCPqHCf_KFNNsyI7Cy1k_U3AxG_wxsMrx2LIFaRuac-11AmI6w>
    <xmx:lHf1YD_nMhC9Qr227-APdqvjYHCYP0qhTSiip4iY3BjObqFwTH9d4A>
    <xmx:lHf1YCWsafL4ENymP_dAuycL61csM9cIE5tMgtb4mEvsF02YzKRfwQ>
    <xmx:lXf1YDxffba1DUZwzogtTdPKzt34TKTokwf9lRxeoG187ZeAPfQAww>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Jul 2021 09:01:08 -0400 (EDT)
Date:   Mon, 19 Jul 2021 15:01:06 +0200
From:   Greg KH <greg@kroah.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     stable@vger.kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.13 1/2] net: bridge: multicast: fix PIM hello router
 port marking race
Message-ID: <YPV3kuo2hK0BWeoo@kroah.com>
References: <20210719125355.317449-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719125355.317449-1-razor@blackwall.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 03:53:54PM +0300, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> commit 04bef83a3358946bfc98a5ecebd1b0003d83d882 upstream.
> 
> When a PIM hello packet is received on a bridge port with multicast
> snooping enabled, we mark it as a router port automatically, that
> includes adding that port the router port list. The multicast lock
> protects that list, but it is not acquired in the PIM message case
> leading to a race condition, we need to take it to fix the race.
> 
> Cc: stable@vger.kernel.org
> Fixes: 91b02d3d133b ("bridge: mcast: add router port on PIM hello message")
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  net/bridge/br_multicast.c | 2 ++
>  1 file changed, 2 insertions(+)

Thanks for the backports, all now queued up.

greg k-h
