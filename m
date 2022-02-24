Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3624C38F6
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 23:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235438AbiBXWqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 17:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235600AbiBXWqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 17:46:54 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C5B29DD74;
        Thu, 24 Feb 2022 14:46:24 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DCEAA1C0B7F; Thu, 24 Feb 2022 23:46:22 +0100 (CET)
Date:   Thu, 24 Feb 2022 23:46:22 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        shuah@kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 09/13] selftests/ftrace: Do not trace
 do_softirq because of PREEMPT_RT
Message-ID: <20220224224622.GD6522@duo.ucw.cz>
References: <20220223023152.242065-1-sashal@kernel.org>
 <20220223023152.242065-9-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4zI0WCX1RcnW9Hbu"
Content-Disposition: inline
In-Reply-To: <20220223023152.242065-9-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4zI0WCX1RcnW9Hbu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2022-02-22 21:31:48, Sasha Levin wrote:
> From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>=20
> [ Upstream commit 6fec1ab67f8d60704cc7de64abcfd389ab131542 ]
>=20
> The PREEMPT_RT patchset does not use do_softirq() function thus trying
> to filter for do_softirq fails for such kernel:
>=20
>   echo do_softirq
>   ftracetest: 81: echo: echo: I/O error
>=20
> Choose some other visible function for the test.  The function does not
> have to be actually executed during the test, because it is only testing
> filter API interface.

This needs -rt patch even on mainline, right?

It is certainly not needed in -stable branches.

Best regards,

								Pavel


> +++ b/tools/testing/selftests/ftrace/test.d/ftrace/func_set_ftrace_file.tc
> @@ -33,7 +33,7 @@ do_reset
> =20
>  FILTER=3Dset_ftrace_filter
>  FUNC1=3D"schedule"
> -FUNC2=3D"do_softirq"
> +FUNC2=3D"scheduler_tick"
> =20
>  ALL_FUNCS=3D"#### all functions enabled ####"


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--4zI0WCX1RcnW9Hbu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYhgKvgAKCRAw5/Bqldv6
8k1QAJ0dLY9MiXUuLtpLd68WDfYLmHVHDgCeL2mSqReE5mPxz6I5P3J2uT6BV8I=
=yWFJ
-----END PGP SIGNATURE-----

--4zI0WCX1RcnW9Hbu--
