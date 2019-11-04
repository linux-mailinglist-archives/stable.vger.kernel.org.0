Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0425EDB5A
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 10:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfKDJNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 04:13:43 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41271 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726441AbfKDJNm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 04:13:42 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B74AF21EE9;
        Mon,  4 Nov 2019 04:13:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 04 Nov 2019 04:13:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=eqE7jkhhGJ7JXgTopLE2xa0IXpQ
        VilX36GRSzSSK9MA=; b=PsER5tdwj7HKEF/WRQqZu8CyfmK2xk0vT81GKFlSZTB
        3UTncxDOySd25a8+/WXFY/Sxylelbme2mQef11pTE4JIu/j3cNA/tYfCCBbbulMc
        h+M81PifzKS+YK9CRaJ+BuN+3gC0quViaeD8767lIVZFY4+8DmZfPD5q62w/ieHz
        xaWbnCHPGtwLR5wchYTmkaja/InQNSZPS0DbWTQP611x0VJS/aE0EtqRwNWvtF1Q
        jn6zonBcGt97aOVaSOWsZqKlP3rvZuAFoeKovmV4p3rGDDVE98IZfuPLCPujXEpb
        xhcmSXyX/hEY+VOPpdz4ZS3OaIIyi80zP39gLdpBxjQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=eqE7jk
        hhGJ7JXgTopLE2xa0IXpQVilX36GRSzSSK9MA=; b=Pa3WAiSDUsunwlEJIBrRhC
        3UJwEyOFJolGhAdxIt8yg311wW0OH6BoRAhGfCu18OVOniLqXJsc6g2cIg8MubSJ
        zzqr4THVfkntLHPJB+QTAxqyJG1D32gJVipiDUt4AkQe7Nvf1FL6KlmbS1i5w7ha
        OyWpX9sVgksNfSJe1GJ/ABk6R27XXJPjlGx/3+N/R9RhR0NBiaRx7s7LAN2S8asF
        cdrXowGdvMuamj57v+Mnx+toMdiwuOoQ/lnRJIsMxf38ziRA48MkkACao4vToKjB
        +6WcS3eGKxveEH28HtWUmmaFNTQCfic5cioOBOUcQ+Kv3I3T9p28dE/PT6B4XISA
        ==
X-ME-Sender: <xms:xeu_XSZq2q1ZCinrSc_26xtmVrRHkybwV1K3K1yECvCtNoPlFOB8cg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddufedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:xeu_XccbCjBZnCyDPpKsvojT8Oqu1Ee8eEV5qfoK2KmK3D9DDdsBgg>
    <xmx:xeu_XRNP7UVD6LjjfLQaf8yhyO9-mvyeSa7mkO30tnVk_rASsSFf5A>
    <xmx:xeu_XXaZHuvHngKKfWEiPs8eKc5mJe1bqpdbO47RA_Pc785D5RMbHg>
    <xmx:xeu_XQgeBRJtlFXQgLnx3n1mrT7NX79sEBAbhjKUfEeK4fmqaPVbxA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BB41C8005C;
        Mon,  4 Nov 2019 04:13:40 -0500 (EST)
Date:   Mon, 4 Nov 2019 10:13:39 +0100
From:   Greg KH <greg@kroah.com>
To:     Markus Theil <markus.theil@tu-ilmenau.de>
Cc:     stable@vger.kernel.org, johannes.berg@intel.com
Subject: Re: [PATCH] nl80211: fix validation of mesh path nexthop
Message-ID: <20191104091339.GA1539175@kroah.com>
References: <20191104090016.12723-1-markus.theil@tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104090016.12723-1-markus.theil@tu-ilmenau.de>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 04, 2019 at 10:00:16AM +0100, Markus Theil wrote:
> commit 1fab1b89e2e8f01204a9c05a39fd0b6411a48593 upstream.
> 
> Mesh path nexthop should be a ethernet address, but current validation
> checks against 4 byte integers.
> 
> Cc: stable@vger.kernel.org
> Fixes: 2ec600d672e74 ("nl80211/cfg80211: support for mesh, sta dumping")
> Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
> ---
>  net/wireless/nl80211.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 105fdd8589d7..a9df1301436e 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -259,7 +259,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
>  	[NL80211_ATTR_MNTR_FLAGS] = { /* NLA_NESTED can't be empty */ },
>  	[NL80211_ATTR_MESH_ID] = { .type = NLA_BINARY,
>  				   .len = IEEE80211_MAX_MESH_ID_LEN },
> -	[NL80211_ATTR_MPATH_NEXT_HOP] = { .type = NLA_U32 },
> +	[NL80211_ATTR_MPATH_NEXT_HOP] = { .type = NLA_BINARY,
> +					  .len = ETH_ALEN },
>  
>  	[NL80211_ATTR_REG_ALPHA2] = { .type = NLA_STRING, .len = 2 },
>  	[NL80211_ATTR_REG_RULES] = { .type = NLA_NESTED },

Many thanks for the backport, now queued up.

greg k-h
