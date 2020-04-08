Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A0B1A2A09
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 22:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgDHUDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 16:03:07 -0400
Received: from sonic306-27.consmr.mail.ne1.yahoo.com ([66.163.189.89]:40669
        "EHLO sonic306-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729075AbgDHUDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 16:03:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1586376185; bh=11FOWFgabX1Du2lOWou44vYT2TyAqUHFBtMPqxv4cvM=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=BgaXkunj2iFFyh6XrBIuBDcXFskS2AVSapaj/J3kNqAvO2/VwDzYOFYBJQ7YFC2G4RhsFRpBht+q5+BcqHYhYDtAIAGzs8QwhP59eoi5kBs5oyu2Z5ruPPAvlogKzj7xXxNQGZ75jAXAAVYyUu0YimD+CDPjdcs8xAUDrUl6StqfnkBDOfA0RG+8gGhbIf9HEY6VV2NhRHGSN3tYxDiYDR+F4vnYWOg0wAO92qNAtepKa3Zuau5aiYyWxag+XJEiqD4WV94upqj7d/x2ghIUvEy0nwev6fwxTV6AcMuzLM5JgdhiGk0vYfcdJK4f2t8chez5+IoeUHZuvTp4PIlbrQ==
X-YMail-OSG: aqZ2VsIVM1mlu.2zHjRXKCuG9Ch10Snj2o02aS49C3VgB.OyZOys1Px.NnHqtf5
 p9S4n52WlC758mbOZ3TEiq8_s4SNWNv0EVFJp..4ohOrPKl801lIQdS9ccXpPRHPrjjETzvID_0r
 WwpUKFqeCzUUVswpClxfgsfLEDQit4ah15xBnkBn6zP6mtUwqvPezcfP6nkQEpuoiPQ2UrW_4dXq
 sSOJ8vog0G5OPYb7voiBa3QBWfvtBVFs4T0fwDLJaNF.YUjkG6UGBbaOLl0tpx8uPOjnuwtDAthi
 1z4_bx.sPihjwTeqCE6ffbaBKvELqS7EiFvA5WB9211XhgrZFFYeCL68P3.cN_uJiFjkBp4flEaM
 l72XzuvP70.3OSiNnQuzqxeyyCYUJIwTamdnUcGC6ALDxU.K_isi7N60j4ebJCTMqyOCal9siayF
 HK89pAL21wkmX7l3ObOLZGbjg1BekCRtid9qC7fhjDZAO6KqHuALN62ZvzmCAU2yKvUiQZ1093lK
 CTbmeLhn183zxQa3PQOrb25RqbfdggN227gjnhQRBxLFBhyftox1u9ZhzzGjXX8RUohPmvoDqO1a
 nFXuOtNxu1YYr7v3_937ix__NhyybjNReXtriVOgL1dR4m3EXIOmT3lgWwApJvHcEiWZLOSViopy
 o4E8xqri3_BY.YeJIWjV9SJAVWoMN.5q98cZPAi8Tz_KplVQEofOsuqKvIT5fhbQriDuFQUxJ3WN
 ig3tEjCxEtR2RRAprHa1q892vNGKpu51c453fM4yxfN6Log5E.R_4zGTKZM4_bp.ROtCPzLLoRuo
 LHsxOZ36MAG9IzTcics8EXPnUnqtBK_Thv3_MZBbcV_OxStB1AD08aFIQRnLY6tpy5h7c7fs76Ne
 PzUsQ6DQ83sr4nL6QEFPnTzvTyMFdpHHSAGCepW7Cby_10TD35TlTKNq70PP2jrdyduMopUC8dg2
 xLzf1V_4xEAZB6iVOCv_kllyvbM5h6nB6Y7xoJaMKB5KNGxnR.qOfv9tf8SNAsTt0rKqhIO_Y5L9
 M0UiYJTvSgweoTmNAjlWDVh9dIzxtetJUgQ7r3I41VIAmrPeYcKXQHGQ1GN.Dh7JCWnCoaQWKvAh
 uMmPtNbw4UwlyECr2ei.kXBRU6_LHEihNk6rt8L2Mlgyh.2N1puh7qvaBmUAtbAzkVOM1A1in7K0
 5t2qlexLjQ.eSnbJSBFuavbjJx6CD8aKh1nxnrOrbyWk34jph5_zEqYS4eek3ybqP0sz7625HevY
 1jdzeRtUTWazNuvIVPhxidDj2sEaPgL4DeqJrhXU59jjtdzI7fbAEY5cFDjgqHDpXRmZRqk16Luq
 Rvat3YVVAVL1mfxe8zR28x4yeWkIFwjr1lVVWg2VRTUR35CmHZbO1V6.noTrfFyoBDgpSMBU579h
 68xP5XSUUCX7orQZVmcEcbTMp7faZN6t3
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Wed, 8 Apr 2020 20:03:05 +0000
Received: by smtp423.mail.ne1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID b1627f4242558d62f05c663240c36897;
          Wed, 08 Apr 2020 20:03:01 +0000 (UTC)
Subject: Re: [PATCH] smack: avoid unused 'sip' variable warning
To:     Arnd Bergmann <arnd@arndb.de>, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Cc:     stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20200408190448.778791-1-arnd@arndb.de>
From:   Casey Schaufler <casey@schaufler-ca.com>
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <b5ea0969-f2bf-eab6-131f-c9c2847c7571@schaufler-ca.com>
Date:   Wed, 8 Apr 2020 13:03:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200408190448.778791-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Mailer: WebService/1.1.15620 hermes Apache-HttpAsyncClient/4.1.4 (Java/11.0.6)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/8/2020 12:04 PM, Arnd Bergmann wrote:
> The mix of IS_ENABLED() and #ifdef checks has left a combination
> that causes a warning about an unused variable:
>
> security/smack/smack_lsm.c: In function 'smack_socket_connect':
> security/smack/smack_lsm.c:2838:24: error: unused variable 'sip' [-Werror=unused-variable]
>  2838 |   struct sockaddr_in6 *sip = (struct sockaddr_in6 *)sap;
>
> Change the code to use C-style checks consistently so the compiler
> can handle it correctly.
>
> Fixes: 87fbfffcc89b ("broken ping to ipv6 linklocal addresses on debian buster")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>


Thanks. I will take this, assuming it passes testing.

> ---
> There are lots of ways of addressing this, if you prefer a different
> way, please just treat this patch as a bug report and apply the
> replacement patch directly.
> ---
>  security/smack/smack.h     |  6 ------
>  security/smack/smack_lsm.c | 25 ++++++++-----------------
>  2 files changed, 8 insertions(+), 23 deletions(-)
>
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index 62529f382942..335d2411abe4 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -148,7 +148,6 @@ struct smk_net4addr {
>  	struct smack_known	*smk_label;	/* label */
>  };
>  
> -#if IS_ENABLED(CONFIG_IPV6)
>  /*
>   * An entry in the table identifying IPv6 hosts.
>   */
> @@ -159,9 +158,7 @@ struct smk_net6addr {
>  	int			smk_masks;	/* mask size */
>  	struct smack_known	*smk_label;	/* label */
>  };
> -#endif /* CONFIG_IPV6 */
>  
> -#ifdef SMACK_IPV6_PORT_LABELING
>  /*
>   * An entry in the table identifying ports.
>   */
> @@ -174,7 +171,6 @@ struct smk_port_label {
>  	short			smk_sock_type;	/* Socket type */
>  	short			smk_can_reuse;
>  };
> -#endif /* SMACK_IPV6_PORT_LABELING */
>  
>  struct smack_known_list_elem {
>  	struct list_head	list;
> @@ -335,9 +331,7 @@ extern struct smack_known smack_known_web;
>  extern struct mutex	smack_known_lock;
>  extern struct list_head smack_known_list;
>  extern struct list_head smk_net4addr_list;
> -#if IS_ENABLED(CONFIG_IPV6)
>  extern struct list_head smk_net6addr_list;
> -#endif /* CONFIG_IPV6 */
>  
>  extern struct mutex     smack_onlycap_lock;
>  extern struct list_head smack_onlycap_list;
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 8c61d175e195..e193b0db0271 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -50,10 +50,8 @@
>  #define SMK_RECEIVING	1
>  #define SMK_SENDING	2
>  
> -#ifdef SMACK_IPV6_PORT_LABELING
> -DEFINE_MUTEX(smack_ipv6_lock);
> +static DEFINE_MUTEX(smack_ipv6_lock);
>  static LIST_HEAD(smk_ipv6_port_list);
> -#endif
>  static struct kmem_cache *smack_inode_cache;
>  struct kmem_cache *smack_rule_cache;
>  int smack_enabled;
> @@ -2320,7 +2318,6 @@ static struct smack_known *smack_ipv4host_label(struct sockaddr_in *sip)
>  	return NULL;
>  }
>  
> -#if IS_ENABLED(CONFIG_IPV6)
>  /*
>   * smk_ipv6_localhost - Check for local ipv6 host address
>   * @sip: the address
> @@ -2388,7 +2385,6 @@ static struct smack_known *smack_ipv6host_label(struct sockaddr_in6 *sip)
>  
>  	return NULL;
>  }
> -#endif /* CONFIG_IPV6 */
>  
>  /**
>   * smack_netlabel - Set the secattr on a socket
> @@ -2477,7 +2473,6 @@ static int smack_netlabel_send(struct sock *sk, struct sockaddr_in *sap)
>  	return smack_netlabel(sk, sk_lbl);
>  }
>  
> -#if IS_ENABLED(CONFIG_IPV6)
>  /**
>   * smk_ipv6_check - check Smack access
>   * @subject: subject Smack label
> @@ -2510,7 +2505,6 @@ static int smk_ipv6_check(struct smack_known *subject,
>  	rc = smk_bu_note("IPv6 check", subject, object, MAY_WRITE, rc);
>  	return rc;
>  }
> -#endif /* CONFIG_IPV6 */
>  
>  #ifdef SMACK_IPV6_PORT_LABELING
>  /**
> @@ -2599,6 +2593,7 @@ static void smk_ipv6_port_label(struct socket *sock, struct sockaddr *address)
>  	mutex_unlock(&smack_ipv6_lock);
>  	return;
>  }
> +#endif
>  
>  /**
>   * smk_ipv6_port_check - check Smack port access
> @@ -2661,7 +2656,6 @@ static int smk_ipv6_port_check(struct sock *sk, struct sockaddr_in6 *address,
>  
>  	return smk_ipv6_check(skp, object, address, act);
>  }
> -#endif /* SMACK_IPV6_PORT_LABELING */
>  
>  /**
>   * smack_inode_setsecurity - set smack xattrs
> @@ -2836,24 +2830,21 @@ static int smack_socket_connect(struct socket *sock, struct sockaddr *sap,
>  		return 0;
>  	if (IS_ENABLED(CONFIG_IPV6) && sap->sa_family == AF_INET6) {
>  		struct sockaddr_in6 *sip = (struct sockaddr_in6 *)sap;
> -#ifdef SMACK_IPV6_SECMARK_LABELING
> -		struct smack_known *rsp;
> -#endif
> +		struct smack_known *rsp = NULL;
>  
>  		if (addrlen < SIN6_LEN_RFC2133)
>  			return 0;
> -#ifdef SMACK_IPV6_SECMARK_LABELING
> -		rsp = smack_ipv6host_label(sip);
> +		if (__is_defined(SMACK_IPV6_SECMARK_LABELING))
> +				rsp = smack_ipv6host_label(sip);
>  		if (rsp != NULL) {
>  			struct socket_smack *ssp = sock->sk->sk_security;
>  
>  			rc = smk_ipv6_check(ssp->smk_out, rsp, sip,
>  					    SMK_CONNECTING);
>  		}
> -#endif
> -#ifdef SMACK_IPV6_PORT_LABELING
> -		rc = smk_ipv6_port_check(sock->sk, sip, SMK_CONNECTING);
> -#endif
> +		if (__is_defined(SMACK_IPV6_PORT_LABELING))
> +			rc = smk_ipv6_port_check(sock->sk, sip, SMK_CONNECTING);
> +
>  		return rc;
>  	}
>  	if (sap->sa_family != AF_INET || addrlen < sizeof(struct sockaddr_in))
