Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D4D6AE679
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjCGQ33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCGQ32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 11:29:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87777EA01
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 08:29:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90421B818F6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 16:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF41C433A0;
        Tue,  7 Mar 2023 16:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678206564;
        bh=ypKYeB44nZk3GsTe9aHbAwt1mCa8FTmXB+MLF0MCt5c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QkREw+ZqQFKRKZmsOPv50EtFVaKR6FftFpJtM8rFsWHm8bF7GnfwANgvZktvSD5Go
         grwZJy+KmhKa5g23hsjVhg/qd1AvpwSGfCNNhAWB3l69m9yzwQ2wqgjL/6OQtJMDbZ
         /d353Uwjl+PNHi1RchToM6OU1aBdCQ9VnfYM8Y3LNrqXj51xyGwlCSVXxK6skZIG6Y
         +ymsYbEENoDojx6OQrmPBm2hRSMNZanXj+Uxd+EJcBYx9+GumlKh2OKjK3c2zXAKF4
         WmrF3QurQvn1oCQrHNGyKpKnE9aUQcqecw8Tt81ZAQXGPuloA4lBJFTLF2dklSbSgW
         eLTI+Ew9WgNfg==
Date:   Tue, 7 Mar 2023 16:29:20 +0000
From:   Conor Dooley <conor@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     heiko.stuebner@vrull.eu, ajones@ventanamicro.com,
        conor.dooley@microchip.com, palmer@rivosinc.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] RISC-V: fix ordering of Zbb extension"
 failed to apply to 6.2-stable tree
Message-ID: <0b0d89a0-45f1-4540-aad5-16ce52716d4b@spud>
References: <167820482516243@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Dn4iJnLKF2+W0Awo"
Content-Disposition: inline
In-Reply-To: <167820482516243@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Dn4iJnLKF2+W0Awo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 07, 2023 at 05:00:25PM +0100, gregkh@linuxfoundation.org wrote:
>=20
> The patch below does not apply to the 6.2-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This shouldn't be backported as Zbb support was a v6.3 feature.
>=20
> To reproduce the conflict and resubmit, you may use the following command=
s:
>=20
> git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.gi=
t/ linux-6.2.y
> git checkout FETCH_HEAD
> git cherry-pick -x 1eac28201ac0725192f5ced34192d281a06692e5
> # <resolve conflicts, build, test, etc.>
> git commit -s
> git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16782048251=
6243@kroah.com' --subject-prefix 'PATCH 6.2.y' HEAD^..
>=20
> Possible dependencies:
>=20
> 1eac28201ac0 ("RISC-V: fix ordering of Zbb extension")
> 80c200b34ee8 ("RISC-V: resort all extensions in consistent orders")
>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> >From 1eac28201ac0725192f5ced34192d281a06692e5 Mon Sep 17 00:00:00 2001
> From: Heiko Stuebner <heiko.stuebner@vrull.eu>
> Date: Wed, 8 Feb 2023 23:53:27 +0100
> Subject: [PATCH] RISC-V: fix ordering of Zbb extension
>=20
> As Andrew reported,
>     Zb* comes after Zi* according 27.11 "Subset Naming Convention"
> so fix the ordering accordingly.
>=20
> Reported-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Tested-by: Conor Dooley <conor.dooley@microchip.com>
> Link: https://lore.kernel.org/r/20230208225328.1636017-2-heiko@sntech.de
> Cc: stable@vger.kernel.org
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
>=20
> diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
> index 420228e219f7..8400f0cc9704 100644
> --- a/arch/riscv/kernel/cpu.c
> +++ b/arch/riscv/kernel/cpu.c
> @@ -185,9 +185,9 @@ arch_initcall(riscv_cpuinfo_init);
>   * New entries to this struct should follow the ordering rules described=
 above.
>   */
>  static struct riscv_isa_ext_data isa_ext_arr[] =3D {
> -	__RISCV_ISA_EXT_DATA(zbb, RISCV_ISA_EXT_ZBB),
>  	__RISCV_ISA_EXT_DATA(zicbom, RISCV_ISA_EXT_ZICBOM),
>  	__RISCV_ISA_EXT_DATA(zihintpause, RISCV_ISA_EXT_ZIHINTPAUSE),
> +	__RISCV_ISA_EXT_DATA(zbb, RISCV_ISA_EXT_ZBB),
>  	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
>  	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
>  	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
>=20

--Dn4iJnLKF2+W0Awo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZAdmYAAKCRB4tDGHoIJi
0p5lAP4u3b/gQQ9jyGef19DPvpfL1sgdAulxkFMlrXf7FEaXPgD8Cep2G4yRK3im
dE2Kyc2zp3J0cP3OLILEYZdxeV7Gmw8=
=XDrB
-----END PGP SIGNATURE-----

--Dn4iJnLKF2+W0Awo--
