Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A3310ADB6
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 11:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfK0K3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 05:29:50 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:58865 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726545AbfK0K3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 05:29:50 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 1F9D4A3E;
        Wed, 27 Nov 2019 05:29:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 27 Nov 2019 05:29:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=Ut/Lfu6DkFYyf6ou7MXFfOD/TYq
        Pv8KxNzLLn60lJVs=; b=h35y9lXn6q4b1bXxUmUJUn4G0YxywL6rbJaVFd9ccky
        BrJdmyJR+N42/aR4C1FOrtmMIg4H286xIvkYzLV1LUzz7xtdSCDY6eg9D1peThpu
        J8XIjoNYqG5umHGIJukYetbgaa4y8Aom9eKUmRES6np8Y40/9eCTcjMNdOnD+t7S
        tA0oIwtrfAyIW52+r2bWFfAkt+sKeRogNNyO6qYJh4RXDJfWIRjBJTy5CvECdqap
        1Tdkq6q+pAJdoUC32KpiEVcIEHWQ4cXtfYzfCHorh8wFrp1t1wHCQni6XWHDZvmX
        0lBJZFmmgQFF47uC6kgzTYYDiyFuhrjOeuL920THqig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Ut/Lfu
        6DkFYyf6ou7MXFfOD/TYqPv8KxNzLLn60lJVs=; b=bFBL8Dp16Gyc7IJBH3Eas3
        OHioWJY6VdTGSjslEhL3chaP1yqTjgCN94C+Qi9sNUKCtu1JQF8MYT3aFDg6TEyY
        1W6YI/uHZqSKFOVGUbygDydLLXCd2Pr5v+PR3tp2nfwq2pjnl3SkHkTJq9XNrqBq
        UKRL48UCcrYWzvpfxexNyIWmxrxETmWy//5I6Fo3MfkfpGd/QJq0Cdx3m3/N3UjB
        wvI8JllOIi2Ze9Ad54Qy5ZjNjlpIJ+Ad7QxtzYfZqCJtwh4OFxxEn47tfn0GoAQv
        AUQEqx3+4Ntbn3ZaePnNkFFvjI1g4ZMa6Y5TxXpl6OvbohwVS8cFNvBsKQBh2FMQ
        ==
X-ME-Sender: <xms:HFDeXbDbBb9RYaOvc1wIVYfCMYFFrQ0p7z3pGTEHWQJjfw94lX7FhQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeihedgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:HFDeXW4HMVrnZgGt7pWZHICwHkKoPg_PZrJuDCsAkME7gMTQHVKHjQ>
    <xmx:HFDeXTAAGYQ_a5tt98cB2HNaGZ66CSvo9N0QrS3sdP_f54ZJYPQ6Rw>
    <xmx:HFDeXS7GUKV2OV9fG8dqoHKHODkdA3sPg-woDCN7PsC4HwbKwpu8Og>
    <xmx:HFDeXaxZAkAeNC1qh5lB0vQ21uSD7Gu6jfMQWTlQVuYBKxxh0FIk-Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D78B88005B;
        Wed, 27 Nov 2019 05:29:47 -0500 (EST)
Date:   Wed, 27 Nov 2019 11:28:26 +0100
From:   Greg KH <greg@kroah.com>
To:     Nicolas Schier <n.schier@avm.de>
Cc:     stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/1] l2tp: don't use l2tp_tunnel_find() in l2tp_ip and
 l2tp_ip6
Message-ID: <20191127102826.GA1996965@kroah.com>
References: <cover.1574846983.git.n.schier@avm.de>
 <bd3a519ba6770a838d09550f1a6602d5fb7e80cb.1574846983.git.n.schier@avm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd3a519ba6770a838d09550f1a6602d5fb7e80cb.1574846983.git.n.schier@avm.de>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 27, 2019 at 11:02:49AM +0100, Nicolas Schier wrote:
> From: Guillaume Nault <g.nault@alphalink.fr>
> 
> commit 8f7dc9ae4a7aece9fbc3e6637bdfa38b36bcdf09 upstream.
> 
> Using l2tp_tunnel_find() in l2tp_ip_recv() is wrong for two reasons:
> 
>   * It doesn't take a reference on the returned tunnel, which makes the
>     call racy wrt. concurrent tunnel deletion.
> 
>   * The lookup is only based on the tunnel identifier, so it can return
>     a tunnel that doesn't match the packet's addresses or protocol.
> 
> For example, a packet sent to an L2TPv3 over IPv6 tunnel can be
> delivered to an L2TPv2 over UDPv4 tunnel. This is worse than a simple
> cross-talk: when delivering the packet to an L2TP over UDP tunnel, the
> corresponding socket is UDP, where ->sk_backlog_rcv() is NULL. Calling
> sk_receive_skb() will then crash the kernel by trying to execute this
> callback.
> 
> And l2tp_tunnel_find() isn't even needed here. __l2tp_ip_bind_lookup()
> properly checks the socket binding and connection settings. It was used
> as a fallback mechanism for finding tunnels that didn't have their data
> path registered yet. But it's not limited to this case and can be used
> to replace l2tp_tunnel_find() in the general case.
> 
> Fix l2tp_ip6 in the same way.
> 
> Fixes: 0d76751fad77 ("l2tp: Add L2TPv3 IP encapsulation (no UDP) support")
> Fixes: a32e0eec7042 ("l2tp: introduce L2TPv3 IP encapsulation support for IPv6")
> Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Nicolas Schier <n.schier@avm.de>
> ---
> Please consider queuing this patch for v4.9.y.

Now queued up, thanks.

greg k-h
