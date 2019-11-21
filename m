Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D2A105C83
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 23:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfKUWNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 17:13:14 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41009 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726554AbfKUWNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 17:13:14 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 312EE22BED;
        Thu, 21 Nov 2019 17:13:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 21 Nov 2019 17:13:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=l2Ca34z4X8RD02mqUT4q+3q/4Qc
        AVJW4yw8ntPvsUPo=; b=Gp6EEC4ISgsaX08nykRyMxNb7FL1GxvO777GR9iELi+
        00h5hTF9llAjkB4oWkRVtWUVfHWgQd1wy34PYfzjRvsVURek6e3i5q7BqghBakVO
        abWiwAUfOMrg8LVkTnGql1vl+wsJDFRvfLgHwIYTYAvNChkg7ZIN2ATwJ9TZPoiQ
        bdXvt5+F/56F5d7eP95Ixu9ahLTSlQzjv4TNh/lGR1yeSCV6MUozb2C9eCbxvaN/
        Kyaf4xcBNm+VPjEbPIWMUdNhMm4ZUTKCOwvLC5Kzzi2o3O/HvNWwPgg3A0UsUANi
        baAOd6CkF8dA3d0bLdvgjeV+O7diK23AGTX/H23/q1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=l2Ca34
        z4X8RD02mqUT4q+3q/4QcAVJW4yw8ntPvsUPo=; b=R2xnOMRtfcEB89sIfuvsTo
        Pm6jlOyYjAbP5bhcrq7sM9EgRuQFU7/a4Vgjoj1m01rse0yyj2gbJUFEq3NLtX7o
        m6NIhIEzx6DczkByVb82m+v2aCAVOjtehukAUnnTorggJKrRFa06MC2Efge+RICy
        8nDJeSzd4eI/G3v0Z1evujpFVgKt/f7Ldgg6loNYTqh+Ip2ovJCTr30ZpQRWJNr6
        sAIKkUomadeKBtHoE1ZprZ7sPEuEKyiilzH7kEPPbqZvckZag4ms7rTNJSigWFgr
        uZLynZiwN/RfJieig4uRYQ0AZna9XXPV/rxXxJFhRJdJ7lrcDLUHItKwZH2SrC+A
        ==
X-ME-Sender: <xms:-AvXXQOVVC5RGobttrTEKxNhOj6eZDFpiZguq7YPndAFTFY_0TOKlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudehvddgudeitdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjfgesth
    dtredttdervdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtgho
    mheqnecuffhomhgrihhnpehsphhinhhitghsrdhnvghtnecukfhppeekfedrkeeirdekle
    druddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:-AvXXRTLVUMxA_czKVmaZ9yO2bL8QMzJO0q-wf1D47qLgG4wrL6t0g>
    <xmx:-AvXXexf_pBqqzcNs8fk22U9OtBDfZbTEAOCDE_EcGum0qsz8HHXIA>
    <xmx:-AvXXXcUvS85WAhRNEKL8OKmLHUSDKOHbQIvY5YFw5Kn8xU_WoGIkg>
    <xmx:-QvXXWzN3Psru0BvwmrfqwzHU1VoKqNgeSq-_gttCMQxARlTuT8nHg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A8809306005C;
        Thu, 21 Nov 2019 17:13:12 -0500 (EST)
Date:   Thu, 21 Nov 2019 23:13:11 +0100
From:   Greg KH <greg@kroah.com>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, davem@davemloft.net
Subject: Re: Back-porting request
Message-ID: <20191121221311.GA1088624@kroah.com>
References: <20190729154234.GA3508@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729154234.GA3508@ubuntu>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 11:42:34AM -0400, Stephen Suryaputra wrote:
> Hello,
> 
> I'm requesting this commit to be back-ported to v4.14:
> ---
> commit 5b18f1289808fee5d04a7e6ecf200189f41a4db6
> Author: Stephen Suryaputra <ssuryaextr@gmail.com>
> Date:   Wed Jun 26 02:21:16 2019 -0400
> 
>     ipv4: reset rt_iif for recirculated mcast/bcast out pkts
> 
>     Multicast or broadcast egress packets have rt_iif set to the oif. These
>     packets might be recirculated back as input and lookup to the raw
>     sockets may fail because they are bound to the incoming interface
>     (skb_iif). If rt_iif is not zero, during the lookup, inet_iif() function
>     returns rt_iif instead of skb_iif. Hence, the lookup fails.
> 
>     v2: Make it non vrf specific (David Ahern). Reword the changelog to
>         reflect it.
>     Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
>     Reviewed-by: David Ahern <dsahern@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
> 
> We found the issue in that release and the above commit is on
> linux-stable. On the discussion behind this commit, please see:
> https://www.spinics.net/lists/netdev/msg581045.html
> 
> I think after the following diff is needed on top of the above commit
> for v4.14:
> 
> ---
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 4d85a4fdfdb0..ad2718c1624e 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -1623,11 +1623,8 @@ struct rtable *rt_dst_clone(struct net_device *dev, struct rtable *rt)
>  		new_rt->rt_iif = rt->rt_iif;
>  		new_rt->rt_pmtu = rt->rt_pmtu;
>  		new_rt->rt_mtu_locked = rt->rt_mtu_locked;
> -		new_rt->rt_gw_family = rt->rt_gw_family;
> -		if (rt->rt_gw_family == AF_INET)
> -			new_rt->rt_gw4 = rt->rt_gw4;
> -		else if (rt->rt_gw_family == AF_INET6)
> -			new_rt->rt_gw6 = rt->rt_gw6;
> +		new_rt->rt_gateway = rt->rt_gateway;
> +		new_rt->rt_table_id = rt->rt_table_id;
>  		INIT_LIST_HEAD(&new_rt->rt_uncached);
>  
>  		new_rt->dst.flags |= DST_HOST;
> ---

This only worked for 4.14, this also needs to go to 4.19.  Can you
provide a working backport for both trees so that I can apply it?  I'll
go drop the one I added, as it breaks the build :(

thanks,

greg k-h
