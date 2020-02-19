Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A5B164954
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 16:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgBSP6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 10:58:00 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34807 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726651AbgBSP6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 10:58:00 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3B4A92219C;
        Wed, 19 Feb 2020 10:57:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 19 Feb 2020 10:57:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=yR7ZFP5jnyQYDGWXj4DoIv/8TgX
        gvbgn3+/o7E/ImuY=; b=TTjtDNdYCwxvj6idPJY+4wBNWdnb+DCfxk2To/mlIGs
        tAip1rxCYFFiM6LAMPslY0DnHccbnApmApk/UT8mffvie5K3BrJmV7yNvOeJlRGb
        YN5Kk4QU8cX8/JwT8074n5wp0uOA5PmgJhpmPa6ZbS/ikfaL2eYu2+uG+ctpTvie
        SjjT4ZQemE+nQpogagIZHt9s1lkdCXHCFbPhQBnlXShn6R0AZYSpNyJqJAfg2XlT
        8Zcl5KF9EygpvaQgv9hh7icq+LYaxWtaIZ358kQwY12ZFPp2FZDzBfToZBUs7o+b
        3/ALpcRrPUp0coEOnzjQXHWAYO7ZrZrg0+1p4uwzbcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yR7ZFP
        5jnyQYDGWXj4DoIv/8TgXgvbgn3+/o7E/ImuY=; b=xrMle4Tk8VgE87uyNspfTD
        2hBU7zcs8WE9gFdgzEgY/rind5W/t/PTx+3CWjPHWXWtaTjEnGyZE7/8JNbcxBjS
        c6dhaD8SDpz2/9W570IsuRPK9iE7QyzxJfhAeWPFkUGMT7wiNalHBxlqwAhJhYbj
        k4Er3R3gGNVrA0uyyp6I8TXYIOiNcNy/O0Xjgh9SvfYnQBJWwtjOeQ2BBXVrOwg5
        f87BZ4EmpoUuzWyT6jvv820mBl4hHroVeLm+9s2ceOpgQwxfq9kda4zzyb+2LuZg
        UgWTpehb7RVlLgUjNR4LbECnERLs5mnViaKfQxVn9aa7AHcGMiQK4Y7PIzph7QzA
        ==
X-ME-Sender: <xms:BFtNXkoWWu9lBepEpMfiXGXNyOySUG20wKHfkzi8dl1erT5-_im8-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkedtgdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesghdtreertddtvdenucfhrhhomhepofgrgihimhgv
    ucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucfkphepledtrd
    ekledrieekrdejieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehmrgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:BFtNXhJvJoMDZ0HaE1S5qRV0DmIhfo9D-qwRAtZIotGg7v8ziu7--A>
    <xmx:BFtNXsYXvL5yIfgaWx4zpQrECCz2rTQbaxTeT_6KJRAJtqJNjT4mNg>
    <xmx:BFtNXl6YWhDDl8Br25JCv6loIDrsiwH0Q-3tjka0YGwZneh33VSUDw>
    <xmx:B1tNXmxSRsn1QcEl5mwSz8hMDeTsUHlrpwKuLro09sFzzEo0cAsQXg>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5E3CA328005A;
        Wed, 19 Feb 2020 10:57:56 -0500 (EST)
Date:   Wed, 19 Feb 2020 16:57:54 +0100
From:   Maxime Ripard <maxime@cerno.tech>
To:     Samuel Holland <samuel@sholland.org>
Cc:     Chen-Yu Tsai <wens@csie.org>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/sun4i: dsi: Avoid hotplug race with DRM driver bind
Message-ID: <20200219155754.vajepubw64hxfmum@gilmour.lan>
References: <20200217060906.15152-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="54gv4v2726dkjnkb"
Content-Disposition: inline
In-Reply-To: <20200217060906.15152-1-samuel@sholland.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--54gv4v2726dkjnkb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 17, 2020 at 12:09:06AM -0600, Samuel Holland wrote:
> We need to make sure that the DRM driver is fully registered before
> allowing the panel to be attached. Otherwise, we may trigger a hotplug
> event before sun4i_framebuffer_init() sets up drm->mode_config.funcs,
> causing a NULL pointer dereference.
>
> Fixes: 1a2703bd7356 ("drm/sun4i: dsi: Allow binding the host without a panel")
> Signed-off-by: Samuel Holland <samuel@sholland.org>

Thanks for following up on this, I've applied it

Maxime

--54gv4v2726dkjnkb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXk1bAgAKCRDj7w1vZxhR
xePFAQCYhA+x3yuXQWCrT9byki6JCFoJ0+xYDdlmkViFi6k1LgD7BAzzLGu8/hS1
PLrGCLHwJ0LBV1vFqXuLFHhBB7lBOwc=
=BDH/
-----END PGP SIGNATURE-----

--54gv4v2726dkjnkb--
