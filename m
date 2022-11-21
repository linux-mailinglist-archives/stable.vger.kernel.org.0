Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1A7631C4E
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 10:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiKUJFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 04:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKUJFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 04:05:14 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84BC6D97E
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 01:05:10 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id gv23so26959005ejb.3
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 01:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=3p3GFNmhQsAPA9cGyLZ3iyZwy0qWhUSbc1TXCe3CJlM=;
        b=x0UuC7UeCm+BfKYf4R+4jcpMbO+J26wevOwxT2gqlVt7IbQosN9PmTU8ibxIBPil/J
         qms/yqtkZg6YXxBFSyC5fMcIlBVJDSM/6OPxe/rdrNE52J3FYwwm1SaJuTiSmMl8NlqB
         nKHi0yxH37WensrlAu2ikKOh13kuneJxWgXsc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3p3GFNmhQsAPA9cGyLZ3iyZwy0qWhUSbc1TXCe3CJlM=;
        b=58NRER+qGYgtmRDk1DL50VKC/RLb3Y//O5yqdrgt+1VrQnV3pZDU92MeuJxof4U1+z
         PIUSyoqcwgdivufBsvG2/Scg04T9MZEVJpFQXRdqVRwpCmevfo70XGXPLAwwSrNwI82t
         AZbpj1XrdarZ9RCqbQW/rW3hHt2YBKs7O1iUjxGV2Q72VwrBIsLq6KihYAaMUHpthZyO
         DDVLTum9gmAiwbBrvRYeF6t6UrtzhiNtx8buGb0cJBRJbQL8AXzYJYb/fFvblteldfNO
         BM36VpZZRjiLfRtjdEIcMH7dGayxcJaStIaG2wFsoRgdwygmqepd6tdISYnSfcJ+61sE
         f4Dg==
X-Gm-Message-State: ANoB5pk8aul8y2Tw8J29+Kq/K2phSils0iEJRXcZ72snY36YJ4bwCpIj
        yF/5/8QEgaybCT7sGgD69tSNfnsmYQfoLQ==
X-Google-Smtp-Source: AA0mqf6t3nvuNWM/3pRSBGo5bH1T+dPXdHDnKg+LwbeLlB5Mjmq5Lk9YlKDrxhpia9xosUedzAjU1g==
X-Received: by 2002:a17:906:a2da:b0:7ad:84d1:5b56 with SMTP id by26-20020a170906a2da00b007ad84d15b56mr15054268ejb.205.1669021509160;
        Mon, 21 Nov 2022 01:05:09 -0800 (PST)
Received: from cloudflare.com (79.184.204.15.ipv4.supernova.orange.pl. [79.184.204.15])
        by smtp.gmail.com with ESMTPSA id q2-20020a17090676c200b007b43ef7c0basm2761043ejn.134.2022.11.21.01.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 01:05:08 -0800 (PST)
References: <20221121051216.2603260-1-sashal@kernel.org>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: Patch "l2tp: Serialize access to sk_user_data with
 sk_callback_lock" has been added to the 5.15-stable tree
Date:   Mon, 21 Nov 2022 10:03:55 +0100
In-reply-to: <20221121051216.2603260-1-sashal@kernel.org>
Message-ID: <87sfic7k58.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 21, 2022 at 12:12 AM -05, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
>
>     l2tp: Serialize access to sk_user_data with sk_callback_lock
>
> to the 5.15-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
> The filename of the patch is:
>      l2tp-serialize-access-to-sk_user_data-with-sk_callba.patch
> and it can be found in the queue-5.15 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

Please don't add the commit below to stable tree, yet.
We have a fix-up for it under review:

https://lore.kernel.org/netdev/20221121085426.21315-1-jakub@cloudflare.com/

> commit 92aa1132edc6e6e912efd056c698cd6e52b83c6f
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
> index e1a303e4f0f7..3e9db5146765 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -323,7 +323,7 @@ struct bpf_local_storage;
>    *	@sk_tskey: counter to disambiguate concurrent tstamp requests
>    *	@sk_zckey: counter to order MSG_ZEROCOPY notifications
>    *	@sk_socket: Identd and reporting IO signals
> -  *	@sk_user_data: RPC layer private data
> +  *	@sk_user_data: RPC layer private data. Write-protected by @sk_callback_lock.
>    *	@sk_frag: cached page frag
>    *	@sk_peek_off: current peek_offset value
>    *	@sk_send_head: front of stuff to transmit
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index 93271a2632b8..c77032638a06 100644
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
> @@ -1471,16 +1473,18 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
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
> @@ -1506,7 +1510,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>  
>  		setup_udp_tunnel_sock(net, sock, &udp_cfg);
>  	} else {
> -		sk->sk_user_data = tunnel;
> +		rcu_assign_sk_user_data(sk, tunnel);
>  	}
>  
>  	tunnel->old_sk_destruct = sk->sk_destruct;
> @@ -1520,6 +1524,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>  	if (tunnel->fd >= 0)
>  		sockfd_put(sock);
>  
> +	write_unlock(&sk->sk_callback_lock);
>  	return 0;
>  
>  err_sock:
> @@ -1527,6 +1532,8 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>  		sock_release(sock);
>  	else
>  		sockfd_put(sock);
> +
> +	write_unlock(&sk->sk_callback_lock);
>  err:
>  	return ret;
>  }

