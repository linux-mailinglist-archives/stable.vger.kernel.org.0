Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D4B521364
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 13:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbiEJLUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 07:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240506AbiEJLT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 07:19:59 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274F21868CB
        for <stable@vger.kernel.org>; Tue, 10 May 2022 04:16:01 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 6B4853200786;
        Tue, 10 May 2022 07:15:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 10 May 2022 07:16:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1652181358; x=1652267758; bh=YyM7yeUs3a
        HFiLPCPRAvBYCeFNVAzx6V2dCbjJ3xBh0=; b=K3tAwaxvsBuqd8/JeIVxpoDQPv
        8bjNRmSvnPTppPIURbuc30ib8xB4ChSrXVE05833dMu97vQojtZlcwNvUeazRcAv
        EAxAnQ3H0LqA50fVhNucINfNY16dD+BtWTRrwJhmnli+Q7YsRpwjSj+gZcCZEcqY
        x4M2bR8zml54Z5M6dnEsMg/I+mkAHhKzQfArQvPofMTIth5qL5gqwEMzz4O7xVrc
        wUg0XbPusAg9SgK75qksegeC56Mc5Dyx8tdHUjTp7FRGvLr0olbNL6m5swqKMkxr
        a+iGkPdTokGZW9KrvdG3gn03ASORgqJqX5huLpDJDhYeLgE+Mf9KhK7gIoPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1652181358; x=
        1652267758; bh=YyM7yeUs3aHFiLPCPRAvBYCeFNVAzx6V2dCbjJ3xBh0=; b=S
        Ko69YE/zBIGWN5wXpqvQJv22nRSVY1f1KwbIOj/7obCRYLtPJwOABsEWHJaIW4Vb
        HLXcvZx9OS8luD9Jr7pqfVHfeEocckSgIpxvgRBTSh7vGTsC7Qt+rEsmnHzfvW0X
        XbxS5begyZfeqd6UeKJd0hU7ayG6oTwbO4KdQ7Ah1y9QrqcKaAADZ2aeWZ892gTz
        aECl1c2wpqc73ZZLdLFEEIqGUzC1B1l/vSELsDyFXT44lgF3jVQ4eZ+xssjaWIOf
        vVoKMjuRIaHPlttc2vI4HmN3qfG06Swvf5upYoGXSMGKb8rpt8Gc3ZlswLYUk86w
        BSDNeROsWs9LguvCeY9yg==
X-ME-Sender: <xms:bkl6YlkMqKv-4fnZXsTzd5g7LJSAO1hRbrM8Ss3AL0B64mzLgV1pag>
    <xme:bkl6Yg1Up-ktL-lDQU94HIknDljqBOKo-3V4iUVm0PvoYGbFjvwL_uMAB0zUKIg_7
    zA-mDVGL29jLA>
X-ME-Received: <xmr:bkl6YrrPHouSo_WMCOPTZBx5m725cb9obee-ziXAofydRgCRTcCzB93-Rog3FQ3cj7-6xdH25v8Xsq6qBagH5r2bpmR0OEDS>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgedugdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:bkl6Yln6GvtCrr53KyuOQcF_VhCMKM9aN8UyETCYfKdpo_e-ouEwWA>
    <xmx:bkl6Yj1SuFvdIqJlUfVy9CxKjgbvqU7c2wQI14a8M-aMgTROUkqUpA>
    <xmx:bkl6YktugN7vRFPeo3aH8UoAueIQ_4MyYY-1Rjqxv-6jN-t1chwX0A>
    <xmx:bkl6YsIaaagLIeT_cEscDK1CTS8jqGWGN9b_IY9CvEQoblnvF53mXg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 May 2022 07:15:58 -0400 (EDT)
Date:   Tue, 10 May 2022 13:15:56 +0200
From:   Greg KH <greg@kroah.com>
To:     Johannes Nixdorf <j.nixdorf@avm.de>
Cc:     stable@vger.kernel.org,
        Christoph =?iso-8859-1?Q?B=FCttner?= <c.buettner@avm.de>,
        Nicolas Schier <n.schier@avm.de>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 5.4] net: ipv6: ensure we call ipv6_mc_down() at
 most once
Message-ID: <YnpJbLU+lszXf4P/@kroah.com>
References: <20220504140610.880318-1-j.nixdorf@avm.de>
 <20220504140610.880318-2-j.nixdorf@avm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504140610.880318-2-j.nixdorf@avm.de>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 04, 2022 at 04:06:10PM +0200, Johannes Nixdorf wrote:
> commit 9995b408f17ff8c7f11bc725c8aa225ba3a63b1c upstream.
> 
> There are two reasons for addrconf_notify() to be called with NETDEV_DOWN:
> either the network device is actually going down, or IPv6 was disabled
> on the interface.
> 
> If either of them stays down while the other is toggled, we repeatedly
> call the code for NETDEV_DOWN, including ipv6_mc_down(), while never
> calling the corresponding ipv6_mc_up() in between. This will cause a
> new entry in idev->mc_tomb to be allocated for each multicast group
> the interface is subscribed to, which in turn leaks one struct ifmcaddr6
> per nontrivial multicast group the interface is subscribed to.
> 
> The following reproducer will leak at least $n objects:
> 
> ip addr add ff2e::4242/32 dev eth0 autojoin
> sysctl -w net.ipv6.conf.eth0.disable_ipv6=1
> for i in $(seq 1 $n); do
> 	ip link set up eth0; ip link set down eth0
> done
> 
> Joining groups with IPV6_ADD_MEMBERSHIP (unprivileged) or setting the
> sysctl net.ipv6.conf.eth0.forwarding to 1 (=> subscribing to ff02::2)
> can also be used to create a nontrivial idev->mc_list, which will the
> leak objects with the right up-down-sequence.
> 
> Based on both sources for NETDEV_DOWN events the interface IPv6 state
> should be considered:
> 
>  - not ready if the network interface is not ready OR IPv6 is disabled
>    for it
>  - ready if the network interface is ready AND IPv6 is enabled for it
> 
> The functions ipv6_mc_up() and ipv6_down() should only be run when this
> state changes.
> 
> Implement this by remembering when the IPv6 state is ready, and only
> run ipv6_mc_down() if it actually changed from ready to not ready.
> 
> The other direction (not ready -> ready) already works correctly, as:
> 
>  - the interface notification triggered codepath for NETDEV_UP /
>    NETDEV_CHANGE returns early if ipv6 is disabled, and
>  - the disable_ipv6=0 triggered codepath skips fully initializing the
>    interface as long as addrconf_link_ready(dev) returns false
>  - calling ipv6_mc_up() repeatedly does not leak anything
> 
> Fixes: 3ce62a84d53c ("ipv6: exit early in addrconf_notify() if IPv6 is disabled")
> Signed-off-by: Johannes Nixdorf <j.nixdorf@avm.de>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [jnixdorf: context updated for bpo to v4.19/v5.4]
> Signed-off-by: Johannes Nixdorf <j.nixdorf@avm.de>
> ---
>  net/ipv6/addrconf.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 9d8b791f63ef..295adfabf870 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -3660,6 +3660,7 @@ static int addrconf_ifdown(struct net_device *dev, int how)
>  	struct inet6_dev *idev;
>  	struct inet6_ifaddr *ifa, *tmp;
>  	bool keep_addr = false;
> +	bool was_ready;
>  	int state, i;
>  
>  	ASSERT_RTNL();
> @@ -3725,7 +3726,10 @@ static int addrconf_ifdown(struct net_device *dev, int how)
>  
>  	addrconf_del_rs_timer(idev);
>  
> -	/* Step 2: clear flags for stateless addrconf */
> +	/* Step 2: clear flags for stateless addrconf, repeated down
> +	 *         detection
> +	 */
> +	was_ready = idev->if_flags & IF_READY;
>  	if (!how)
>  		idev->if_flags &= ~(IF_RS_SENT|IF_RA_RCVD|IF_READY);
>  
> @@ -3799,7 +3803,7 @@ static int addrconf_ifdown(struct net_device *dev, int how)
>  	if (how) {
>  		ipv6_ac_destroy_dev(idev);
>  		ipv6_mc_destroy_dev(idev);
> -	} else {
> +	} else if (was_ready) {
>  		ipv6_mc_down(idev);
>  	}
>  
> -- 
> 2.36.0
> 

All now queued up, thanks.

greg k-h
