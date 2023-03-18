Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1CD6BFA3A
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 14:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjCRN22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 09:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjCRN21 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 09:28:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8577911E82;
        Sat, 18 Mar 2023 06:28:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 269D860C69;
        Sat, 18 Mar 2023 13:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184D6C433D2;
        Sat, 18 Mar 2023 13:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679146105;
        bh=TlKsaYYaeZ1vVIIm7B3Drx1Yx68Hl+MZWOEw8FpObtg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NjxYKFANms3HAiQGPKvlsSLhquTx8K5HxHQxbUZtIfAvO3P/dj3e6mF3AEasCGY1M
         lljNnTP5JZn9DIAaozjx3hFiBqB8m5OsbMTMQS56Ihh86WJ4nZ4J7tHYnPngbxURtB
         rsHnv0KJmIGAqU/z3/epnG2xjRWSJlRtSN1igcFelWzVUCCI8XcE6LPxgCSNOo0Abb
         bbYGJ4mITwa4P0ByQ/488EPlEJKPJ5689BtdMMXaaEego3n8zznDuF0soYrTzrF6e4
         Yn+hhKL9zOnaFKCeJZA8GQl79b0125UhJReg0BTaoVIhK6XsCGaE+cLuc4w710gMMu
         ApIM/YJwL5wJA==
Date:   Sat, 18 Mar 2023 09:28:23 -0400
From:   William Breathitt Gray <wbg@kernel.org>
To:     William Breathitt Gray <william.gray@linaro.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] counter: 104-quad-8: Fix Synapse action reported for
 Index signals
Message-ID: <ZBW8dyn5J4XiVP/O@ishi>
References: <20230316203426.224745-1-william.gray@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RLQhA2XMIn9J6rWQ"
Content-Disposition: inline
In-Reply-To: <20230316203426.224745-1-william.gray@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--RLQhA2XMIn9J6rWQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 16, 2023 at 04:34:26PM -0400, William Breathitt Gray wrote:
> Signal 16 and higher represent the device's Index lines. The
> priv->preset_enable array holds the device configuration for these Index
> lines. The preset_enable configuration is active low on the device, so
> invert the conditional check in quad8_action_read() to properly handle
> the logical state of preset_enable.
>=20
> Fixes: f1d8a071d45b ("counter: 104-quad-8: Add Generic Counter interface =
support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: William Breathitt Gray <william.gray@linaro.org>

Applied to counter-fixes.

William Breathitt Gray

--RLQhA2XMIn9J6rWQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSNN83d4NIlKPjon7a1SFbKvhIjKwUCZBW8dwAKCRC1SFbKvhIj
K9XBAQDkACR5VdxratfcON5smFkxIDriwuWgdIM5SK2d2kMXiAD+Kd87+isZ/teu
NLccryDsgdxA50JPFKnRKcunDht9wgQ=
=WQLr
-----END PGP SIGNATURE-----

--RLQhA2XMIn9J6rWQ--
