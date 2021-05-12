Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A3437BC9D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbhELMg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbhELMg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 08:36:26 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7134C061574
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:35:17 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b17so26874068ede.0
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B+qYBeg0LU7qe9FeyoLl+k4V1mooIx6Srj0QdL7z8tc=;
        b=FjXQxpNwImq2bwYHzsIHZLnrerzRfxMcSSRNqhZcZYWNzdINe0Vud0wr78sKhIMNl8
         7RVwgVC3SFE2FTAH3/OKgQ3pYusBtFHs63VR1zSSynQ6Nu3LiYXoaMeX6IX/z68TUtBh
         xRVK0jid++g22nW+OgpdaAeiC4g/7OVZmYqtAC3KSDV9cyAFhDjgcSPsGY9XJX2/P0GJ
         1+JnRi+MohHNZ+UxlZeB4JWmm2EowBV99AYQX6NWjOk11ELtxr5ltAmQ9IMB2R0sHe4d
         YDFKTVSMDLn/atY6dyKbmxafzU8Xlaz6WeTAjqmEW8An0PzErJC8I1q9wpKaJ/LgOm50
         oUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=B+qYBeg0LU7qe9FeyoLl+k4V1mooIx6Srj0QdL7z8tc=;
        b=fVwIJwRLbd2b9IqIfyozkeNsxJV28MC5+Dth3pwSfNj/h2QbFYM7APo2ujLPspcMnY
         9aWnAFPJfz7QurtY2AWdJY2EelbVgUblntx85IFH99ujM4cyGlcO2gLE1qHFnhZMpBCx
         DUMAW2NkF1Lfi4ByjAIpE+JKCGHmUar0ZGst6m3I4ZJgxCZePxiOh1z/JxwCe8bTHnX7
         nRCNaWpGG25TggDYup2lJC2sPtf1vGP1kBHGfYC2cNrxzxAdcwp/WtPH8Dq51q3mhLlv
         e+coxjfkdiU7Cu5EXRTrWOPJZp1LbBU78zpyti7WTqCxKtQegLDjhVE8tDWkrMu8oSow
         jHrg==
X-Gm-Message-State: AOAM533yqWtlTRDP7sgmSqWtIs1tGcVnFO6YmIDMxQNUsDX3bc/h2EOp
        zceqpxIb3eN332nxKmfluOdJJ7pYe9+ZhySU
X-Google-Smtp-Source: ABdhPJwOn721K04BSYLRQMvOMWYGauXUTgOMfrqtnATQJOY4kZOMqeaSneYD7dczYVMqzx327jVNDQ==
X-Received: by 2002:aa7:d658:: with SMTP id v24mr42258523edr.290.1620822916561;
        Wed, 12 May 2021 05:35:16 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id v1sm11896366ejw.117.2021.05.12.05.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 05:35:15 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Wed, 12 May 2021 14:35:14 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     gregkh@linuxfoundation.org
Cc:     lucien.xin@gmail.com, davem@davemloft.net,
        orcohen@paloaltonetworks.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] sctp: delay auto_asconf init until
 binding the first addr" failed to apply to 5.12-stable tree
Message-ID: <YJvLguBJ8zTUptlX@eldamar.lan>
References: <162082148164230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162082148164230@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

[disclaimer, just commenting as a bystander, noticing this failed
apply]

On Wed, May 12, 2021 at 02:11:21PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.12-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 34e5b01186858b36c4d7c87e1a025071e8e2401f Mon Sep 17 00:00:00 2001
> From: Xin Long <lucien.xin@gmail.com>
> Date: Mon, 3 May 2021 05:11:42 +0800
> Subject: [PATCH] sctp: delay auto_asconf init until binding the first addr
> 
> As Or Cohen described:
> 
>   If sctp_destroy_sock is called without sock_net(sk)->sctp.addr_wq_lock
>   held and sp->do_auto_asconf is true, then an element is removed
>   from the auto_asconf_splist without any proper locking.
> 
>   This can happen in the following functions:
>   1. In sctp_accept, if sctp_sock_migrate fails.
>   2. In inet_create or inet6_create, if there is a bpf program
>      attached to BPF_CGROUP_INET_SOCK_CREATE which denies
>      creation of the sctp socket.
> 
> This patch is to fix it by moving the auto_asconf init out of
> sctp_init_sock(), by which inet_create()/inet6_create() won't
> need to operate it in sctp_destroy_sock() when calling
> sk_common_release().
> 
> It also makes more sense to do auto_asconf init while binding the
> first addr, as auto_asconf actually requires an ANY addr bind,
> see it in sctp_addr_wq_timeout_handler().
> 
> This addresses CVE-2021-23133.
> 
> Fixes: 610236587600 ("bpf: Add new cgroup attach type to enable sock modifications")
> Reported-by: Or Cohen <orcohen@paloaltonetworks.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 76a388b5021c..40f9f6c4a0a1 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -357,6 +357,18 @@ static struct sctp_af *sctp_sockaddr_af(struct sctp_sock *opt,
>  	return af;
>  }
>  
> +static void sctp_auto_asconf_init(struct sctp_sock *sp)
> +{
> +	struct net *net = sock_net(&sp->inet.sk);
> +
> +	if (net->sctp.default_auto_asconf) {
> +		spin_lock(&net->sctp.addr_wq_lock);
> +		list_add_tail(&sp->auto_asconf_list, &net->sctp.auto_asconf_splist);
> +		spin_unlock(&net->sctp.addr_wq_lock);
> +		sp->do_auto_asconf = 1;
> +	}
> +}
> +
>  /* Bind a local address either to an endpoint or to an association.  */
>  static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
>  {
> @@ -418,8 +430,10 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
>  		return -EADDRINUSE;
>  
>  	/* Refresh ephemeral port.  */
> -	if (!bp->port)
> +	if (!bp->port) {
>  		bp->port = inet_sk(sk)->inet_num;
> +		sctp_auto_asconf_init(sp);
> +	}
>  
>  	/* Add the address to the bind address list.
>  	 * Use GFP_ATOMIC since BHs will be disabled.
> @@ -4993,19 +5007,6 @@ static int sctp_init_sock(struct sock *sk)
>  	sk_sockets_allocated_inc(sk);
>  	sock_prot_inuse_add(net, sk->sk_prot, 1);
>  
> -	/* Nothing can fail after this block, otherwise
> -	 * sctp_destroy_sock() will be called without addr_wq_lock held
> -	 */
> -	if (net->sctp.default_auto_asconf) {
> -		spin_lock(&sock_net(sk)->sctp.addr_wq_lock);
> -		list_add_tail(&sp->auto_asconf_list,
> -		    &net->sctp.auto_asconf_splist);
> -		sp->do_auto_asconf = 1;
> -		spin_unlock(&sock_net(sk)->sctp.addr_wq_lock);
> -	} else {
> -		sp->do_auto_asconf = 0;
> -	}
> -
>  	local_bh_enable();
>  
>  	return 0;
> @@ -9401,6 +9402,8 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
>  			return err;
>  	}
>  
> +	sctp_auto_asconf_init(newsp);
> +
>  	/* Move any messages in the old socket's receive queue that are for the
>  	 * peeled off association to the new socket's receive queue.
>  	 */
> 

Before applying this patch one needs to revert first
b166a20b07382b8bc1dcee2a448715c9c2c81b5b .

So first apply 01bfe5e8e428 ("Revert "net/sctp: fix race condition in
sctp_destroy_sock"") and then apply 34e5b0118685 ("sctp: delay
auto_asconf init until binding the first addr").

Regards,
Salvatore
