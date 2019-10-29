Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06444E8315
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 09:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbfJ2ITs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 04:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728869AbfJ2ITs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 04:19:48 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D7BA2086A;
        Tue, 29 Oct 2019 08:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572337188;
        bh=ZRF796Wus2o0Ya1YW5Koj4SnZvUVISTZ2oEhfyYzeN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wEVhW4da2JeAw+Ddhxd52NlhX9cZj8HNq84M+PJTQsTrWHCN/WYR4BU8SgnxIMBzG
         vMFgmkP33ElOyQ0oYD8GjVNUL6l/Bllq8lvXxpyZU3eg39Kl63Ih+U6nRFukiaJNSO
         cvty9ZXBYVkMla+Noi6iKTf9r9AOWHntdAMPhHog=
Date:   Tue, 29 Oct 2019 09:10:32 +0100
From:   Maxime Ripard <mripard@kernel.org>
To:     Ondrej Jirman <megous@megous.com>
Cc:     linux-sunxi@googlegroups.com, stable@vger.kernel.org,
        Chen-Yu Tsai <wens@csie.org>,
        Russell King <linux@armlinux.org.uk>,
        "moderated list:ARM/Allwinner sunXi SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: sunxi: Fix CPU powerdown on A83T
Message-ID: <20191029081032.5xhysz3mv65e7azv@hendrix>
References: <20191028214914.3465156-1-megous@megous.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="c2ir2aunacvuu6l7"
Content-Disposition: inline
In-Reply-To: <20191028214914.3465156-1-megous@megous.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--c2ir2aunacvuu6l7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 28, 2019 at 10:49:14PM +0100, Ondrej Jirman wrote:
> PRCM_PWROFF_GATING_REG has CPU0 at bit 4 on A83T. So without this
> patch, instead of gating the CPU0, the whole cluster was power gated,
> when shutting down first CPU in the cluster.
>
> Fixes: 6961275e72a8c1 ("ARM: sun8i: smp: Add support for A83T")
> Signed-off-by: Ondrej Jirman <megous@megous.com>
> Cc: stable@vger.kernel.org

Applied, thanks

Maxime

--c2ir2aunacvuu6l7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXbfz+AAKCRDj7w1vZxhR
xabNAQDq9EMAe4I8hY+8J4KL3Khhrxd27KAbY3b3TIuqdn3a/AD/U7cgXhoTiEyI
oc9v/zgOOL7PxQCykeoNxNc8SHYdiQc=
=XYsh
-----END PGP SIGNATURE-----

--c2ir2aunacvuu6l7--
