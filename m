Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B7463AABE
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 15:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbiK1OUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 09:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbiK1OUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 09:20:06 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CD455B0;
        Mon, 28 Nov 2022 06:20:05 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C36A61C09FF; Mon, 28 Nov 2022 15:20:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1669645203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wmhxe7dqaTB28i9oOPRs5Ictd7Us7hjC3o0PsblUOBM=;
        b=Z1YPY158T+8qBD/eZ1uylwdMbOxfhKr/TR4xMtnpsFxVfCKarzWRAPLP/fC9EtLtBHerym
        WQ76v9ytr4PS0uDzkrg7XKJXoUFkM2eX8Zoa1q57r9GKFt1GYfGS5wrLrf1EytNefa0Npf
        BT+vJ1MIti6iq79p8kNrtoJQ/5KT5TE=
Date:   Mon, 28 Nov 2022 15:20:03 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Starke <daniel.starke@siemens.com>,
        jirislaby@kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10] Revert "tty: n_gsm: avoid call of sleeping
 functions from atomic context"
Message-ID: <Y4TDk9xptEWUiWkB@duo.ucw.cz>
References: <20221123181916.6911-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1G0f11PKnt5DdlU9"
Content-Disposition: inline
In-Reply-To: <20221123181916.6911-1-pchelkin@ispras.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1G0f11PKnt5DdlU9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2022-11-23 21:19:16, Fedor Pchelkin wrote:
> From: Fedor Pchelkin <pchelkin@ispras.ru>
>=20
> [ Upstream commit acdab4cb4ba7e5f94d2b422ebd7bf4bf68178fb2 ]
>=20
> This reverts commit eb75efdec8dd0f01ac85c88feafa6e63b34a2521.
>=20
> The above commit is reverted as the usage of tx_mutex seems not to solve
> the problem described in eb75efdec8dd ("tty: n_gsm: avoid call of sleeping
> functions from atomic context") and just moves the bug to another place.
>=20
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Reviewed-by: Daniel Starke <daniel.starke@siemens.com>
> Link:
https://lore.kernel.org/r/20221008110221.13645-2-pchelkin@ispras.ru

Reviewed-by: Pavel Machek <pavel@denx.de>

--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--1G0f11PKnt5DdlU9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY4TDkwAKCRAw5/Bqldv6
8lxKAKCkoRW8WrF6jIvqNDZZWA/O4fev9wCeO9MeK3sduO+34hJO36rneWpT4rA=
=BxsO
-----END PGP SIGNATURE-----

--1G0f11PKnt5DdlU9--
