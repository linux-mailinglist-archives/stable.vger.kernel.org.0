Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B8B59555D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 10:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbiHPIcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 04:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbiHPIbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 04:31:24 -0400
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C0812F707
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 22:49:20 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a7so17032055ejp.2
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 22:49:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=ewa872McneaPBNsnt6xADABH9eScK9ZFtViXeONVPPc=;
        b=vTbm8phKWtm16bNfBwy+JtZTfpEiXeYx2tWP1phlLkXsLN06bTK8WKppW5qOZZ3s0L
         LweQlaWmsVCkTlcrciKLNVaKflLNpoUcpV4CghxsTYR1S4K3kH8Rn+6neA2KznLVnfBC
         w1rHZkNUAv7X2qqWLLi9GvWWTIQfP7CQ80ZJfmy5uZP9gBsoYt6i2pIOAoUzTHZFl5CB
         7r3KcS2SVcV5HS9jvCQIP2dvpcnPoPzlGPNwfK1xJoPDhP8YqDPs7B3qbi46WNqpIlJ7
         4VFx67DavFzgGD5YjjOYn22KrwhVjGcVqyzcttX1vHeH88/ggUFq4dhVG+z7R1G4LGAx
         IRkQ==
X-Gm-Message-State: ACgBeo2bV4jY74WVkhcSRTzEh86OPsLUWsngCsAzdbyNwzh7cE1xVdl2
        Q2/lbUdHfbHZ9L3KHiSZAcU=
X-Google-Smtp-Source: AA6agR6FoIOir1PT0/HFecyxjMCW1ZVkrs87StsyWeBBcM14Wmyh65Xvq35B1FYdLXJSDc4p/q7dVA==
X-Received: by 2002:a17:906:4bd3:b0:731:3bdf:b95c with SMTP id x19-20020a1709064bd300b007313bdfb95cmr12378138ejv.677.1660628959087;
        Mon, 15 Aug 2022 22:49:19 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id dk1-20020a170906f0c100b0072b592ee073sm4883979ejb.147.2022.08.15.22.49.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 22:49:18 -0700 (PDT)
Message-ID: <47081c01-9e03-8505-6ff9-c6d3def2cc06@kernel.org>
Date:   Tue, 16 Aug 2022 07:49:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH stable 5.4] Revert "tcp: change pingpong threshold to 3"
To:     Kuniyuki Iwashima <kuniyu@amazon.com>, stable@vger.kernel.org
Cc:     Wei Wang <weiwan@google.com>, LemmyHuang <hlm3280@163.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <165919469116877@kroah.com>
 <20220815205129.6335-1-kuniyu@amazon.com>
Content-Language: en-US
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220815205129.6335-1-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15. 08. 22, 22:51, Kuniyuki Iwashima wrote:
> From: Wei Wang <weiwan@google.com>
> 
> commit 4d8f24eeedc58d5f87b650ddda73c16e8ba56559 upstream.
> 
> This reverts commit 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.
> 
> This to-be-reverted commit was meant to apply a stricter rule for the
> stack to enter pingpong mode. However, the condition used to check for
> interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
> jiffy based and might be too coarse, which delays the stack entering
> pingpong mode.
> We revert this patch so that we no longer use the above condition to
> determine interactive session, and also reduce pingpong threshold to 1.

I would wait a bit before backporting this to stable:
https://lore.kernel.org/all/ca408271-8730-eb2b-f12e-3f66df2e643a@kernel.org/

> Fixes: 4a41f453bedf ("tcp: change pingpong threshold to 3")
> Reported-by: LemmyHuang <hlm3280@163.com>
> Suggested-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Wei Wang <weiwan@google.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Link: https://lore.kernel.org/r/20220721204404.388396-1-weiwan@google.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   include/net/inet_connection_sock.h | 10 +---------
>   net/ipv4/tcp_output.c              | 15 ++++++---------
>   2 files changed, 7 insertions(+), 18 deletions(-)
> 
> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> index 13792c0ef46e..2e5f2c8b0663 100644
> --- a/include/net/inet_connection_sock.h
> +++ b/include/net/inet_connection_sock.h
> @@ -318,7 +318,7 @@ void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
>   
>   struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
>   
> -#define TCP_PINGPONG_THRESH	3
> +#define TCP_PINGPONG_THRESH	1
>   
>   static inline void inet_csk_enter_pingpong_mode(struct sock *sk)
>   {
> @@ -334,12 +334,4 @@ static inline bool inet_csk_in_pingpong_mode(struct sock *sk)
>   {
>   	return inet_csk(sk)->icsk_ack.pingpong >= TCP_PINGPONG_THRESH;
>   }
> -
> -static inline void inet_csk_inc_pingpong_cnt(struct sock *sk)
> -{
> -	struct inet_connection_sock *icsk = inet_csk(sk);
> -
> -	if (icsk->icsk_ack.pingpong < U8_MAX)
> -		icsk->icsk_ack.pingpong++;
> -}
>   #endif /* _INET_CONNECTION_SOCK_H */
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index ef749a47768a..7f9004ae44a4 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -166,16 +166,13 @@ static void tcp_event_data_sent(struct tcp_sock *tp,
>   	if (tcp_packets_in_flight(tp) == 0)
>   		tcp_ca_event(sk, CA_EVENT_TX_START);
>   
> -	/* If this is the first data packet sent in response to the
> -	 * previous received data,
> -	 * and it is a reply for ato after last received packet,
> -	 * increase pingpong count.
> -	 */
> -	if (before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
> -	    (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
> -		inet_csk_inc_pingpong_cnt(sk);
> -
>   	tp->lsndtime = now;
> +
> +	/* If it is a reply for ato after last received
> +	 * packet, enter pingpong mode.
> +	 */
> +	if ((u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
> +		inet_csk_enter_pingpong_mode(sk);
>   }
>   
>   /* Account for an ACK we sent. */

-- 
js
suse labs

