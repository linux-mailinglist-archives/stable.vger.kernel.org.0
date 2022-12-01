Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5698A63F34F
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 16:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiLAPEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 10:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbiLAPE3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 10:04:29 -0500
Received: from sonic314-19.consmr.mail.gq1.yahoo.com (sonic314-19.consmr.mail.gq1.yahoo.com [98.137.69.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58DDB68E2
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 07:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1669907067; bh=EoZwF8UwqOAmAJStbnEAfvG3llARIIJGE5OLX74rhRE=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=j4XsAa+uKh+axQ+twP+JXYyl1H/UTV3NmU9Iu5TxzLVp01NY129pinBKQJMjtZtekCIfYH6qp0KopVPk6QAWoJxCdO/4WVT2BaGq83nbpfYBBUXVhJWwmhKNN5UZSMTbYjdVAs9X/YNP0Jf4ONfv7KDYafTsDcVyGgvoUxE41kgiWpxosTp78l9OOZXdmUMz+23O7311axi181oAl6sbaN8ZIqJFEMrTkU0AXUX6j7DUgrcRn6Y6uR1My6QqnqZTSa3vlGIHXzW29TFHYha6oAT8iroKjnzoeyn8ZvWQ6GezyoNd+78KVYQon1WGWximdUR0ai0asJciHQPaedFr4Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1669907067; bh=FmKxouu63y6LDdCRjahWp8DnpvQBETbOTR45vdCsRFx=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=KoKBaO/eSLif88Gwxip7fk7ptyviGxhMD8lbpou3UynTLcxzqyL07h7p2407mfd64SpocB3UzjqS2q4zut47mhoKHmDDZsFdOGrrW/XhlUET9d9LDc6aCg+g3G7CYQWs9eeZ3tG0AVlNUb36nVxLGI3HDi+IWE6UyVCMa6RFopoEt/u5/gsceGS9KRg0eKN3lYCYbU6AEcuSqID71qpQbeyMjHwkGGwMZaqEGxhCOsgn2m5gIpQEEAXFJxgJ5bC8IKnY4Lc7O+qtdOUwIVI5VE66YfAlVd4WnL4KQyl/zFDM+qmg9LV0PMXFRfKCxeuXeHQjM+JRvlMNUMojIxmb+g==
X-YMail-OSG: LaquuCoVM1kETuYM6FNoXQI9zqpH87RhKXvfmDF0GuUN0bHnTM73Pf9CiTMN_At
 aMEtBU_Kv1S7v9xNYxn4OGKXskJXhipt25ytRGjxLG96xHiGtaaQGCQcKIJDu3ltQsg1fvwKOwH2
 uIc7r0lyE2ElgXA44Snb0xXwUEdDMrj31QHkh0YXPJBFFW0MbZh2xpXOanV3JFUnOGyQv0qIhKzF
 J7i18jn17gSIA1NJz_cc.FReoRO1pEDXznDlLlcrVzHHBMO6GkLGHaAQO5gviJ2WXrnSxAhWKldA
 fCgRHI1mxNKxpLiiCpAUZWKjxh.TdZ2bO0BQ2csXYPUiBGmyqkccdFeUcqOauG7bA5UY2MadaDWe
 Dc48k3YYHA_JGR1gg.Kq3r8WrxR9CfP2R05OAOH05FKJgnzXSeWBCSuCgPSXPh5zkoUMh_RZIN.5
 1T3GIhaSW.58j4n9UJ7O9TUYmyBDl4ixSU1XKrIPHZ3eFayDpfK77Dd8iD3v3SNf9pvbcvnvgHog
 rl4aa6_QKC_58p2l4naeXIEPQE754BMnlgiZUg3k3Lm.xuTaJXXmKTMTzWJPdiqRFhWS818W_3R1
 3bB3Md9qJ2qK7CBTYhHgrJvf1I2OeiLdqh2WqRFdqWI9OCNjVQIlXZizDQidx8WN323qMDJzFxCi
 CuT69YxEeBHdTKVw4JLl193rq3.EUc2qWzpq6tmgLclfMpjkIo0cUeUhRJjBGjCbU4fx5IoQE5oq
 WtaKSbpFewruH9cn6.vR6CPe0OcRp_yVZK_q7m7bJoUSjdivl.x7NK8Gm1xNIeR8ybAK4srMqWzP
 z6IzEQjn_KgpPUkBXHK_wpxlATVqEMh6toKNs42LvPfBG7o1nhzIGhbawjfJXY16vjdSzB0Tyxx1
 Us98O1t5Y0AgHKuxCz28J.TwTtFkZQuqNv4NshAjJgffpnpe5xQWGzEdmtn5OWTD.jtmz0KSYTZL
 DzWzEbn1QhO_lIWoBsc2rvZzQPQDpMk5kJnNSs8TeKgUJ7539u1B7ZmB91FZA7cjSlZ3TUEIbxGY
 diJm2gh078yolgJxrynE97tOuvD9CBCMU3CditiXrhtbDjAEcPrlv9_I6AZN3d11dbD4RYUmWhDT
 mx8l7utGqx8zc7fad2GMucR38PmIAq.6yDeBvODTlWvJZ7p6reIbNqYhx9XZbldVXlNI0Us1gt8X
 Zm_4pBUaLXoCrDDjqY98Y5BVr20jV7O59pxHCKXmCJ3lfPAyYAApafWfzYGpqkJxNrLXmEbOWEmR
 5n0JH2yA1P5Cxb6kSdjv1ig6e1sTU3fGa_PY381DKoqwwgUOXCXJsi6LE9dUqA9EaZrP9C_lHKgA
 S3kqvhPoXt2.4n9ZAXBRkXvNaKzJ43BXkkK.d.kYcwidDx.3Ahm.6pWTGR9tEfAXwg5Y2z15WRAe
 FVAIMyQU6UIe_.A8JMhO.e4geCMHQmSfyGGILx.qK4ssl4A18B8a1kLLm6GszJBMsSnosbq8XBbw
 x4988UUx0ZW8Aw_GTDLRQ4.tPisB4VD7jGyHyHwazcDLYKNgL_Z4giwh2n4UQESuM7YJtx.SJx0T
 Ggwp422d5vSKD3.PPwhCW5PtLq8h0imGPDiSg88vahYjCpSnLyRkjNAxcsc7XyGL3WsF0ZuRyvr7
 P2gTlyzotMEMHMwpwEbexj8_8.tjLLNpamSJLOTtOxa.fFb.NPLRhMGhLwpjDy92i24xTXGEGNKA
 vgRGPuoVO5yFLnqEp8nM2pfWHwnfnFePBNer5LOpulxpJlnrUHXak87lRSI5btZMpv_NUJmcZoZX
 WUUcJvwbxow6BhB0inkaHVzI1VZL6lQpCLa3zJKrnbyYMgEbGdpHkShXAVEJZb5QtAXiZOShqb93
 AW.Y5RwE2CxCf1RT2W1pLDo6Hp_qEi0IzHEWWmAnlmubiWe.v78aCCeAAc5oLr_VenVhklkdKU8Y
 jVIQp_O1qfMmXk75Tn4DJZNdHGeE9seJjFkVN3q3CU_1Md4jGMfgBrHzlEo5niwlogM761diZDKn
 0I9AXq3Y.0nn_j_6X.AT4vFUE3qL5k29ZdAIFgeqCnHMV95S5SXthfxqSFxZ_n9pnopWEyFSCJZf
 GtesjYDOpMterz_F9.V4iI5stR8waBiIrb98BtbjgpdPfHsUREImB2RVckyicFojo.Jk3q2S1wY0
 _pIokRYWphrKhsV8kvvWMhdYpu7CginXeUUItZKB6lujFY_F6X64bhUq7qz7TTrBa_ONMWJrV26n
 G5rJxIcSlfC5E0WM-
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.gq1.yahoo.com with HTTP; Thu, 1 Dec 2022 15:04:27 +0000
Received: by hermes--production-bf1-5458f64d4-97x65 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID ef7f625359272beb46d3d973227cb652;
          Thu, 01 Dec 2022 15:04:22 +0000 (UTC)
Message-ID: <d8498407-f8d0-b8e8-e9ff-9cbe732a41cc@aol.com>
Date:   Thu, 1 Dec 2022 10:04:20 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 6.0 075/289] net: neigh: decrement the family specific
 qlen
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev,
        Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
References: <20221130180544.105550592@linuxfoundation.org>
 <20221130180545.841413547@linuxfoundation.org>
Content-Language: en-US
From:   Chuck Zmudzinski <brchuckz@aol.com>
In-Reply-To: <20221130180545.841413547@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20863 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/30/22 1:21 PM, Greg Kroah-Hartman wrote:
> From: Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
>
> [ Upstream commit 8207f253a097fe15c93d85ac15ebb73c5e39e1e1 ]
>
> Commit 0ff4eb3d5ebb ("neighbour: make proxy_queue.qlen limit
> per-device") introduced the length counter qlen in struct neigh_parms.
> There are separate neigh_parms instances for IPv4/ARP and IPv6/ND, and
> while the family specific qlen is incremented in pneigh_enqueue(), the
> mentioned commit decrements always the IPv4/ARP specific qlen,
> regardless of the currently processed family, in pneigh_queue_purge()
> and neigh_proxy_process().
>
> As a result, with IPv6/ND, the family specific qlen is only incremented
> (and never decremented) until it exceeds PROXY_QLEN, and then, according
> to the check in pneigh_enqueue(), neighbor solicitations are not
> answered anymore. As an example, this is noted when using the
> subnet-router anycast address to access a Linux router. After a certain
> amount of time (in the observed case, qlen exceeded PROXY_QLEN after two
> days), the Linux router stops answering neighbor solicitations for its
> subnet-router anycast address and effectively becomes unreachable.

In my environment, without this patch to 6.0.y, IPv6 proxy
neighbours lose connectivity after two or three hours at most
because at that point qlen > PROXY_QLEN in my router.

>
> Another result with IPv6/ND is that the IPv4/ARP specific qlen is
> decremented more often than incremented. This leads to negative qlen
> values, as a signed integer has been used for the length counter qlen,
> and potentially to an integer overflow.
>
> Fix this by introducing the helper function neigh_parms_qlen_dec(),
> which decrements the family specific qlen. Thereby, make use of the
> existing helper function neigh_get_dev_parms_rcu(), whose definition
> therefore needs to be placed earlier in neighbour.c. Take the family
> member from struct neigh_table to determine the currently processed
> family and appropriately call neigh_parms_qlen_dec() from
> pneigh_queue_purge() and neigh_proxy_process().
>
> Additionally, use an unsigned integer for the length counter qlen.
>
> Fixes: 0ff4eb3d5ebb ("neighbour: make proxy_queue.qlen limit per-device")
> Signed-off-by: Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/net/neighbour.h |  2 +-
>  net/core/neighbour.c    | 58 +++++++++++++++++++++--------------------
>  2 files changed, 31 insertions(+), 29 deletions(-)
>
> diff --git a/include/net/neighbour.h b/include/net/neighbour.h
> index 3827a6b395fd..bce6b228cf56 100644
> --- a/include/net/neighbour.h
> +++ b/include/net/neighbour.h
> @@ -83,7 +83,7 @@ struct neigh_parms {
>  	struct rcu_head rcu_head;
>  
>  	int	reachable_time;
> -	int	qlen;
> +	u32	qlen;
>  	int	data[NEIGH_VAR_DATA_MAX];
>  	DECLARE_BITMAP(data_state, NEIGH_VAR_DATA_MAX);
>  };
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 84755db81e9d..35f5a3125808 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -307,7 +307,31 @@ static int neigh_del_timer(struct neighbour *n)
>  	return 0;
>  }
>  
> -static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net)
> +static struct neigh_parms *neigh_get_dev_parms_rcu(struct net_device *dev,
> +						   int family)
> +{
> +	switch (family) {
> +	case AF_INET:
> +		return __in_dev_arp_parms_get_rcu(dev);
> +	case AF_INET6:
> +		return __in6_dev_nd_parms_get_rcu(dev);
> +	}
> +	return NULL;
> +}
> +
> +static void neigh_parms_qlen_dec(struct net_device *dev, int family)
> +{
> +	struct neigh_parms *p;
> +
> +	rcu_read_lock();
> +	p = neigh_get_dev_parms_rcu(dev, family);
> +	if (p)
> +		p->qlen--;
> +	rcu_read_unlock();
> +}
> +
> +static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net,
> +			       int family)
>  {
>  	struct sk_buff_head tmp;
>  	unsigned long flags;
> @@ -321,13 +345,7 @@ static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net)
>  		struct net_device *dev = skb->dev;
>  
>  		if (net == NULL || net_eq(dev_net(dev), net)) {
> -			struct in_device *in_dev;
> -
> -			rcu_read_lock();
> -			in_dev = __in_dev_get_rcu(dev);
> -			if (in_dev)
> -				in_dev->arp_parms->qlen--;
> -			rcu_read_unlock();
> +			neigh_parms_qlen_dec(dev, family);
>  			__skb_unlink(skb, list);
>  			__skb_queue_tail(&tmp, skb);
>  		}
> @@ -409,7 +427,8 @@ static int __neigh_ifdown(struct neigh_table *tbl, struct net_device *dev,
>  	write_lock_bh(&tbl->lock);
>  	neigh_flush_dev(tbl, dev, skip_perm);
>  	pneigh_ifdown_and_unlock(tbl, dev);
> -	pneigh_queue_purge(&tbl->proxy_queue, dev ? dev_net(dev) : NULL);
> +	pneigh_queue_purge(&tbl->proxy_queue, dev ? dev_net(dev) : NULL,
> +			   tbl->family);
>  	if (skb_queue_empty_lockless(&tbl->proxy_queue))
>  		del_timer_sync(&tbl->proxy_timer);
>  	return 0;
> @@ -1621,13 +1640,8 @@ static void neigh_proxy_process(struct timer_list *t)
>  
>  		if (tdif <= 0) {
>  			struct net_device *dev = skb->dev;
> -			struct in_device *in_dev;
>  
> -			rcu_read_lock();
> -			in_dev = __in_dev_get_rcu(dev);
> -			if (in_dev)
> -				in_dev->arp_parms->qlen--;
> -			rcu_read_unlock();
> +			neigh_parms_qlen_dec(dev, tbl->family);
>  			__skb_unlink(skb, &tbl->proxy_queue);
>  
>  			if (tbl->proxy_redo && netif_running(dev)) {
> @@ -1821,7 +1835,7 @@ int neigh_table_clear(int index, struct neigh_table *tbl)
>  	cancel_delayed_work_sync(&tbl->managed_work);
>  	cancel_delayed_work_sync(&tbl->gc_work);
>  	del_timer_sync(&tbl->proxy_timer);
> -	pneigh_queue_purge(&tbl->proxy_queue, NULL);
> +	pneigh_queue_purge(&tbl->proxy_queue, NULL, tbl->family);
>  	neigh_ifdown(tbl, NULL);
>  	if (atomic_read(&tbl->entries))
>  		pr_crit("neighbour leakage\n");
> @@ -3542,18 +3556,6 @@ static int proc_unres_qlen(struct ctl_table *ctl, int write,
>  	return ret;
>  }
>  
> -static struct neigh_parms *neigh_get_dev_parms_rcu(struct net_device *dev,
> -						   int family)
> -{
> -	switch (family) {
> -	case AF_INET:
> -		return __in_dev_arp_parms_get_rcu(dev);
> -	case AF_INET6:
> -		return __in6_dev_nd_parms_get_rcu(dev);
> -	}
> -	return NULL;
> -}
> -
>  static void neigh_copy_dflt_parms(struct net *net, struct neigh_parms *p,
>  				  int index)
>  {

Hi Greg,

I tested this patch on my IPv6 router. Given that without this patch,
connectivity of IPv6 proxy neighbours is lost after 2-3 hours in my
environment, a successful test requires:

- connectivity of IPv6 proxy neighbours must last at least six hours
- connectivity of IPv6 proxy neighbours must persist until router reboot
- no other observed bugs or regressions

I tested three kernels:

- Official Fedora 37 6.0.9 kernel plus this patch
- Official Fedora 37 6.0.10 kernel which includes this patch
- 6.0.11-rc1 kernel

All three kernels passed the test, with the longest test before
rebooting the router of 12 hours for the 6.0.11-rc1 kernel.

On the Debian bug tracker, there is also a report of a successful
test of this patch which resulted in 24 hours of continued IPv6
connectivity for IPv6 proxy neighbours (see the Link tag below).

AFAICS, 6.0.11-rc1 works great on my IPv6 router.

Thanks to all who worked on this for the quick fix.

Best regards,

Chuck Zmudzinski

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1024070#44
Tested-by: Chuck Zmudzinski <brchuckz@aol.com>
