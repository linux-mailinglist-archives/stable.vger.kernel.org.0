Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C3A34D21A
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 16:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbhC2OH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 10:07:58 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:60007 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229502AbhC2OHh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 10:07:37 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 6EC9617A9;
        Mon, 29 Mar 2021 10:07:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 29 Mar 2021 10:07:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=e7OaR4l6KaD5n4UnPI6CYcLv6KC
        5usIANcXzbQv2syo=; b=KlqRsgIWH3+HiU/khNzVntBtxW9EA3p05bUPkxuIQ4H
        qZTJBUZCqbcKZp6ttzcIpQtqJYySw2pNqIpbxMaTwNDgFSAnL1YHj0ibd8jVLHS6
        EVvhFDkhGC09JLeB5GyMMckHBGR5dqyrTQ7eLmiCV9zbdeucF2qAjjKwpd4KKWUf
        dc6hyODv6Q559NCemcPrTuvd71gSPeW+IPdudib/xsBJC+Wzf/Q8WTNf7zkTlhDm
        e1cIaIZ6rdpBnZ0BnlZr0X+lBmFDP1JjETerPjTKdi42rR0TWn/U99zi71wanCb2
        VLoi7AVYJSBD1xoyi0pyHfktrGT5XoCvn2Q01//B0Wg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=e7OaR4
        l6KaD5n4UnPI6CYcLv6KC5usIANcXzbQv2syo=; b=wfY+dSbW3LRSqqUWUj9SC0
        mQIHzNv1HgLEvMVHr8kAIFUUEGUHUdDu2Esj3AYnRJ05bNBJTy3zv1NGhMd3cLNd
        Pxyx2vsoykz2atgka1Nz1Ic3MlHDXdRzJNCup0elQFzwzc56EcKn1eM1UaT3IrvY
        0bWfXl9/tQt9iWcTwdkQsgIwKqqLeudWMIwxLTnjdfx1qWA0+EzH/SgWDz6GXXIj
        56g4jgrkDps9OA+o0dpQ/e3Af1ECLL7+U5pEocY/GRIZCiq++pIjFoHm1CUdXVip
        lmuTnL0Bt510CwD80aW/iFAruvCqkW71YmPnvHjqxRwAlD/7YYViGbwK2jWGWETw
        ==
X-ME-Sender: <xms:Jt9hYKgZTUNE4_NhoNprUdiL5PwGafHrQQjt8M2WAOJ6m6Yo4GtIKw>
    <xme:Jt9hYLD4tot5cHC_7tDDijvvMqGWYr3nXao2bWZP6QjAa1rNJvM2_Flsi8BpGd3KK
    SavGQrqIbYzU7fre4o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepleekgeehhfdutdeljefgleejffehfffgieejhffgueefhfdtveetgeehieeh
    gedunecukfhppeeltddrkeelrdeikedrjeeinecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:Jt9hYCFb9rnpmhX2nzZhKRqUF3LZOf8_2GXhU0CCobBBH-lWU_4Bbw>
    <xmx:Jt9hYDTfE2ndM76EphWv3SL_ri8o46Q6CxlPiz2RosrU9JMalIH4VQ>
    <xmx:Jt9hYHyFMrCjq0GKxcCAs3YdguVcmZEfc3zYtkQMgyqVUupYkRjIMg>
    <xmx:KN9hYOwOkIllRqQyNky0O3BczfasznFyR7zHRzFlfHsn476192vfUw>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id AD5741080067;
        Mon, 29 Mar 2021 10:07:33 -0400 (EDT)
Date:   Mon, 29 Mar 2021 16:07:31 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Simon Ser <contact@emersion.fr>, od@zcrc.me,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm: DON'T require each CRTC to have a unique primary
 plane
Message-ID: <20210329140731.tvkfxic4fu47v3rz@gilmour>
References: <20210327112214.10252-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ma4fyhct6ctei5gf"
Content-Disposition: inline
In-Reply-To: <20210327112214.10252-1-paul@crapouillou.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ma4fyhct6ctei5gf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 27, 2021 at 11:22:14AM +0000, Paul Cercueil wrote:
> The ingenic-drm driver has two mutually exclusive primary planes
> already; so the fact that a CRTC must have one and only one primary
> plane is an invalid assumption.

I mean, no? It's been documented for a while that a CRTC should only
have a single primary, so I'd say that the invalid assumption was that
it was possible to have multiple primary planes for a CRTC.

Since it looks like you have two mutually exclusive planes, just expose
one and be done with it?

Maxime

--ma4fyhct6ctei5gf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCYGHfIwAKCRDj7w1vZxhR
xUSDAPsGqc5zzSnYZCfcmnojYZS7LuvWh9Kha68wIFR3M6Oh3QEAqnn4XrHQSQK6
VUKwLex2PKocNX/KvUrb6Mi0W++SgQo=
=PloT
-----END PGP SIGNATURE-----

--ma4fyhct6ctei5gf--
