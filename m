Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E232608DDE
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 17:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJVPLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 11:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJVPLT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 11:11:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CBC97D75;
        Sat, 22 Oct 2022 08:11:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25D6760522;
        Sat, 22 Oct 2022 15:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0836C433C1;
        Sat, 22 Oct 2022 15:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666451476;
        bh=9xs8QE2qnzLKaj6lFMdhXBuAnxRzdgVkiIl6nYkhVoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BASvgnxqVkhcJpCBtFhQ8f9Atg01Qbo+l4N+OGZFfGufrEY1QeHpzqiuZANDzG/8q
         QwZCPXUnmhJg8s7XHnwY+jStcT/CjdXrdt4+30Q+ovU244Eben1AeImVzcWt0v/brk
         pu74j6iUxLARD4TsVohRwTwkwwXns7WB2MwbrnBs2Dq68vzCx2QKqTWF5TxfgwFZEv
         bBfJX04VU0wpArFqL08aU7Tz1spp4MteosMXgOgwnEJRRSC92iRGjM59IlC79MEFZK
         FOS5jy33Sv+VeQkzuLRjo0tZAccg0vfZy1sQCtFdWa5QRIz1GnoSqx3R++tkeL6ppJ
         hqmqZ8JHtEBIw==
Date:   Sat, 22 Oct 2022 11:11:12 -0400
From:   William Breathitt Gray <wbg@kernel.org>
To:     William Breathitt Gray <william.gray@linaro.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Kamel Bouhara <kamel.bouhara@bootlin.com>
Subject: Re: [PATCH v2] counter: microchip-tcb-capture: Handle Signal1 read
 and Synapse
Message-ID: <Y1QIEPBaYFcjtw+7@ishi>
References: <20221018121014.7368-1-william.gray@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="p1S8upHQyjbUoLz2"
Content-Disposition: inline
In-Reply-To: <20221018121014.7368-1-william.gray@linaro.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--p1S8upHQyjbUoLz2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 18, 2022 at 08:10:14AM -0400, William Breathitt Gray wrote:
> The signal_read(), action_read(), and action_write() callbacks have been
> assuming Signal0 is requested without checking. This results in requests
> for Signal1 returning data for Signal0. This patch fixes these
> oversights by properly checking for the Signal's id in the respective
> callbacks and handling accordingly based on the particular Signal
> requested. The trig_inverted member of the mchp_tc_data is removed as
> superfluous.
>=20
> Fixes: 106b104137fd ("counter: Add microchip TCB capture counter")
> Cc: stable@vger.kernel.org
> Cc: Kamel Bouhara <kamel.bouhara@bootlin.com>
> Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
> ---
> Changes in v2:
>  - Simplified action_read() changes to just handle qdec_mode and
>    non-TIOA Signals before continuing with existing code

Queued for counter-fixes.

William Breathitt Gray

--p1S8upHQyjbUoLz2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSNN83d4NIlKPjon7a1SFbKvhIjKwUCY1QIEAAKCRC1SFbKvhIj
K++tAQDXFZWn/HfRjhWoQtjL9COX6tTdBW+GBnHuNY1F5OZJuwD+O4BgyQcytFjO
vc2bRSUznJOKQRr/oG84q+qQSQO/cQA=
=6sLC
-----END PGP SIGNATURE-----

--p1S8upHQyjbUoLz2--
