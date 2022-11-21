Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F59631C4F
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 10:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiKUJFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 04:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiKUJFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 04:05:34 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779056D97F
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 01:05:33 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id e13so15287987edj.7
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 01:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=qDWeL7jc4/35AF+ADfDh02dTLU1sO6uodzAuMYhWMM0=;
        b=tZYS1uoowwqd/tcDS4Cu94X4NYh83kkFml9Nk283kAvFeqign+M9RK4ubB/77t89dM
         NpdJzv2BRmia4wdbUC54tgOLSEuZ5wJbTizXgeLsxjsHLeKn3VHWJSxmO8IrX84CAImP
         2EmVljgh+dIG2vnLj4YpK1RHfmZFu/G/RYUdU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qDWeL7jc4/35AF+ADfDh02dTLU1sO6uodzAuMYhWMM0=;
        b=D0rlc093QqEy+ePxBjhDaJtlJ5YXK3sX2/DoXWD90EUEeJ9b6aU7Co8Xe3i41f+q5P
         Od/B/AewE/NCR+HQ0raRMy7qTsXn5S6oJpJz9QfJT8eNP6CsKENv9ZS1hg4HuEc2vxe0
         fssjP1L9Y6G9RNwMxMM3Odwu8JO2tPCL3EYiCgpSeaH3LAsvFPXKMdpBHql+fcO+up5l
         yk1X587SG4eeP/ZdoOsxEg8O3OJGtkSAl4CeXWYVs9b2uZ9vV+u2VGUoaRHuGdbRNPlE
         WsCAPemqXmepavEfxPJGdbhcGTCy/fiyB3YijiNGMSU7hcNDdzFxmGZ6JbklPU6udVlX
         hFOg==
X-Gm-Message-State: ANoB5pnHp7hedcHbSS37tFi1jJockCFztF5725KX3O7bl7BVeB/7+1CV
        XRmYZEkorRTyom6/rnCw2sOFTxhX1dzxww==
X-Google-Smtp-Source: AA0mqf5tT6eoM5NnB65gCAL422Zjgx0CdkDQ/Zc4pGEFr5pbxgWrNq83MtEElgQVsudM1Yv9l/3rfA==
X-Received: by 2002:a05:6402:12d5:b0:469:885b:fcfd with SMTP id k21-20020a05640212d500b00469885bfcfdmr678550edx.177.1669021531800;
        Mon, 21 Nov 2022 01:05:31 -0800 (PST)
Received: from cloudflare.com (79.184.204.15.ipv4.supernova.orange.pl. [79.184.204.15])
        by smtp.gmail.com with ESMTPSA id v10-20020a170906292a00b007ad96726c42sm4835441ejd.91.2022.11.21.01.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 01:05:31 -0800 (PST)
References: <20221121050850.2600439-1-sashal@kernel.org>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: Patch "l2tp: Serialize access to sk_user_data with
 sk_callback_lock" has been added to the 6.0-stable tree
Date:   Mon, 21 Nov 2022 10:05:11 +0100
In-reply-to: <20221121050850.2600439-1-sashal@kernel.org>
Message-ID: <87o7t07k4l.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Mon, Nov 21, 2022 at 12:08 AM -05, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
>
>     l2tp: Serialize access to sk_user_data with sk_callback_lock
>
> to the 6.0-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
> The filename of the patch is:
>      l2tp-serialize-access-to-sk_user_data-with-sk_callba.patch
> and it can be found in the queue-6.0 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

Please don't add the commit below to stable tree, yet.
We have a fix-up for it under review:

https://lore.kernel.org/netdev/20221121085426.21315-1-jakub@cloudflare.com/

> commit 87a828cfa5ce4b2075d26660756c07751648d13f
> Author: Jakub Sitnicki <jakub@cloudflare.com>
> Date:   Mon Nov 14 20:16:19 2022 +0100
>
>     l2tp: Serialize access to sk_user_data with sk_callback_lock
>     
>     [ Upstream commit b68777d54fac21fc833ec26ea1a2a84f975ab035 ]
>     
>     sk->sk_user_data has multiple users, which are not compatible with each
>     other. Writers must synchronize by grabbing the sk->sk_callback_lock.
>     
>     l2tp currently fails to grab the lock when modifying the underlying tunnel
>     socket fields. Fix it by adding appropriate locking.
>     
>     We err on the side of safety and grab the sk_callback_lock also inside the
>     sk_destruct callback overridden by l2tp, even though there should be no
>     refs allowing access to the sock at the time when sk_destruct gets called.
>     
>     v4:
>     - serialize write to sk_user_data in l2tp sk_destruct
>     
>     v3:
>     - switch from sock lock to sk_callback_lock
>     - document write-protection for sk_user_data
>     
>     v2:
>     - update Fixes to point to origin of the bug
>     - use real names in Reported/Tested-by tags
>     
>     Cc: Tom Parkin <tparkin@katalix.com>
>     Fixes: 3557baabf280 ("[L2TP]: PPP over L2TP driver core")
>     Reported-by: Haowei Yan <g1042620637@gmail.com>
>     Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index f6e6838c82df..03a4ebe3ccc8 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -323,7 +323,7 @@ struct sk_filter;
>    *	@sk_tskey: counter to disambiguate concurrent tstamp requests
>    *	@sk_zckey: counter to order MSG_ZEROCOPY notifications
>    *	@sk_socket: Identd and reporting IO signals
> -  *	@sk_user_data: RPC layer private data
> +  *	@sk_user_data: RPC layer private data. Write-protected by @sk_callback_lock.
>    *	@sk_frag: cached page frag
>    *	@sk_peek_off: current peek_offset value
>    *	@sk_send_head: front of stuff to transmit
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index 7499c51b1850..754fdda8a5f5 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -1150,8 +1150,10 @@ static void l2tp_tunnel_destruct(struct sock *sk)
>  	}
>  
>  	/* Remove hooks into tunnel socket */
> +	write_lock_bh(&sk->sk_callback_lock);
>  	sk->sk_destruct = tunnel->old_sk_destruct;
>  	sk->sk_user_data = NULL;
> +	write_unlock_bh(&sk->sk_callback_lock);
>  
>  	/* Call the original destructor */
>  	if (sk->sk_destruct)
> @@ -1469,16 +1471,18 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>  		sock = sockfd_lookup(tunnel->fd, &ret);
>  		if (!sock)
>  			goto err;
> -
> -		ret = l2tp_validate_socket(sock->sk, net, tunnel->encap);
> -		if (ret < 0)
> -			goto err_sock;
>  	}
>  
> +	sk = sock->sk;
> +	write_lock(&sk->sk_callback_lock);
> +
> +	ret = l2tp_validate_socket(sk, net, tunnel->encap);
> +	if (ret < 0)
> +		goto err_sock;
> +
>  	tunnel->l2tp_net = net;
>  	pn = l2tp_pernet(net);
>  
> -	sk = sock->sk;
>  	sock_hold(sk);
>  	tunnel->sock = sk;
>  
> @@ -1504,7 +1508,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>  
>  		setup_udp_tunnel_sock(net, sock, &udp_cfg);
>  	} else {
> -		sk->sk_user_data = tunnel;
> +		rcu_assign_sk_user_data(sk, tunnel);
>  	}
>  
>  	tunnel->old_sk_destruct = sk->sk_destruct;
> @@ -1518,6 +1522,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>  	if (tunnel->fd >= 0)
>  		sockfd_put(sock);
>  
> +	write_unlock(&sk->sk_callback_lock);
>  	return 0;
>  
>  err_sock:
> @@ -1525,6 +1530,8 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>  		sock_release(sock);
>  	else
>  		sockfd_put(sock);
> +
> +	write_unlock(&sk->sk_callback_lock);
>  err:
>  	return ret;
>  }

