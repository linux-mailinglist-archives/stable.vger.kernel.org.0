Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72810403837
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 12:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347481AbhIHKvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 06:51:36 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56341 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348972AbhIHKvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 06:51:31 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id D240B5C0189;
        Wed,  8 Sep 2021 06:50:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 08 Sep 2021 06:50:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=m42N7Xn7CS/K9uuaheQNRkh/MX3
        zzlTawLAXqvGPqlM=; b=Sy1viz6bxMkTcOjHTWATFTPzJg/Dw0BKd0G1q6pizZo
        /X1wLFQRbon39waTWBwHkUDHZS3l32OyzGrkiZ3bds9pAghcpMRgcaCBYYwHRCKM
        rEtjL475BLjWT+iD04LJ+s+4jBAyO657dKQ8c7Vc31hxWRVQTTkohygx+MwlcELM
        GC+Qezbw/hw4Sl/cxT5UCnm7S7b/gSIEgoH1eiwsqS6EthmvJttBzzn+retQss0o
        snXlgNbmVlwhmt7mq+ZGyFnmjovftPLPMoDvBXp4RlsbxZ/0aM2p8ld9xUoL/+Nj
        /wlHlIAmCU5LwSm1y68GbVwe4SB1TB3sG6rKOJSbzoQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=m42N7X
        n7CS/K9uuaheQNRkh/MX3zzlTawLAXqvGPqlM=; b=s/KyjrjWncbAUJqg1a68th
        ZovDxBbhZQ/dNDNBy9K3UE6bTGWzpfGj3o25N0YjBtlf0jZEAlj5URXAO6XzKX6k
        m80KZp3EA+fmvnS456dowNiKARkd4gSBTrMw+O2hVRFlnpGT0SwcgrFZQ539NeCS
        I9Adr3ycF6IIj4mvS3zHvsnGXM3viSriPU1KxNF/N3z5vVu5MMF5J/JVVX1bybZ5
        y6u39wBG3O07am4SIBKNVdfgH4ZLorH0bFOu/rYBmpJlyaE9SBvI8/i2s4v72W3l
        IS1J+YT1eIbc9SGB63RgG5PVQupAHuNJUuokaL4DgNVnbgtfNCBkJfHJbnnB6j2A
        ==
X-ME-Sender: <xms:bpU4YfZmHSUfGGFdRvqRgYeDO4qIxLJia4uZVTN5LFTQeuGHtZEg7w>
    <xme:bpU4Yeb2w758e4heIQOITXvRV5fRJdaSNBvwyB-qHC11LwmHgpGdKFOkjvrxcDsH4
    y9cnb_HaWcUyw>
X-ME-Received: <xmr:bpU4YR8cq1BtcsFVVS-WqTcAVZdjpk4iMC4MYU3gOSjvmctKzagnzp0xJ2Q7P_a4sZ6F1oEFih77q5_2JglK4NM-AC8aScvt>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudefjedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheegle
    ekveelteduhfehheehhffftedtvdehhfelteetffekvdeiheehlefggeenucffohhmrghi
    nhepqhgvmhhurdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:bpU4YVo_lifaz5LRH07sxoXwswxElYJ9-S02tuXrn9k61ShvGZNo3Q>
    <xmx:bpU4YaqZH4diAyFenOedFLxjXNiGVzSyXRZUA5qoeP4--LsJMt2y2g>
    <xmx:bpU4YbTFIYKa4mogN10jdQaGo87-sc3m8zEtzXIayBr-gZBbxt2YZQ>
    <xmx:bpU4Ybd1Kjpoe2P8Un-Mp18Q5cDOEWQz1TNBcQvZs5_I_9xH5gHjdw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Sep 2021 06:50:21 -0400 (EDT)
Date:   Wed, 8 Sep 2021 12:50:19 +0200
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/1] igmp: Add ip_mc_list lock in ip_check_mc_rcu
Message-ID: <YTiVa8U+vw9wj0aG@kroah.com>
References: <20210908101534.185105-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210908101534.185105-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 08, 2021 at 11:15:34AM +0100, Lee Jones wrote:
> From: Liu Jian <liujian56@huawei.com>
> 
> [ Upstream commit 23d2b94043ca8835bd1e67749020e839f396a1c2 ]
> 
> I got below panic when doing fuzz test:
> 
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 0 PID: 4056 Comm: syz-executor.3 Tainted: G    B             5.14.0-rc1-00195-gcff5c4254439-dirty #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> Call Trace:
> dump_stack_lvl+0x7a/0x9b
> panic+0x2cd/0x5af
> end_report.cold+0x5a/0x5a
> kasan_report+0xec/0x110
> ip_check_mc_rcu+0x556/0x5d0
> __mkroute_output+0x895/0x1740
> ip_route_output_key_hash_rcu+0x2d0/0x1050
> ip_route_output_key_hash+0x182/0x2e0
> ip_route_output_flow+0x28/0x130
> udp_sendmsg+0x165d/0x2280
> udpv6_sendmsg+0x121e/0x24f0
> inet6_sendmsg+0xf7/0x140
> sock_sendmsg+0xe9/0x180
> ____sys_sendmsg+0x2b8/0x7a0
> ___sys_sendmsg+0xf0/0x160
> __sys_sendmmsg+0x17e/0x3c0
> __x64_sys_sendmmsg+0x9e/0x100
> do_syscall_64+0x3b/0x90
> entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x462eb9
> Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8
>  48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48>
>  3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f3df5af1c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 000000000073bf00 RCX: 0000000000462eb9
> RDX: 0000000000000312 RSI: 0000000020001700 RDI: 0000000000000007
> RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f3df5af26bc
> R13: 00000000004c372d R14: 0000000000700b10 R15: 00000000ffffffff
> 
> It is one use-after-free in ip_check_mc_rcu.
> In ip_mc_del_src, the ip_sf_list of pmc has been freed under pmc->lock protection.
> But access to ip_sf_list in ip_check_mc_rcu is not protected by the lock.
> 
> Cc: <stable@vger.kernel.org> # 4.4+
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  net/ipv4/igmp.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
> index 00576bae183d3..0c321996c6eb0 100644
> --- a/net/ipv4/igmp.c
> +++ b/net/ipv4/igmp.c
> @@ -2720,6 +2720,7 @@ int ip_check_mc_rcu(struct in_device *in_dev, __be32 mc_addr, __be32 src_addr, u
>  		rv = 1;
>  	} else if (im) {
>  		if (src_addr) {
> +			spin_lock_bh(&im->lock);
>  			for (psf = im->sources; psf; psf = psf->sf_next) {
>  				if (psf->sf_inaddr == src_addr)
>  					break;
> @@ -2730,6 +2731,7 @@ int ip_check_mc_rcu(struct in_device *in_dev, __be32 mc_addr, __be32 src_addr, u
>  					im->sfcount[MCAST_EXCLUDE];
>  			else
>  				rv = im->sfcount[MCAST_EXCLUDE] != 0;
> +			spin_unlock_bh(&im->lock);
>  		} else
>  			rv = 1; /* unspecified source; tentatively allow */
>  	}
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 

Now queued up, thanks.

greg k-h
