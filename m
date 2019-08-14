Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF4B8CF3A
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 11:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfHNJWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 05:22:19 -0400
Received: from mail-wm1-f98.google.com ([209.85.128.98]:50466 "EHLO
        mail-wm1-f98.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbfHNJWQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 05:22:16 -0400
Received: by mail-wm1-f98.google.com with SMTP id v15so3939535wml.0
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 02:22:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SSG5SsTgRz8aknwV+vEeWON9FnHe2hziZgnl35xjJZc=;
        b=MpCreqsN6p3pMYA33JqNrsWG6hscmA81YDLbLhjtnDetI8frzkAxuThsdeAHlioq9H
         o2VA/8DZ/att2uBbCGktS/Jj+QXAU+G58l0A0JbbxmTRaX4n5wzveuY0OGWRYXwOm6JX
         MQz1zKz3x+i5sLMgFfg0NymlYrzdR+XzGHXtmRKY6pPj58uu+9n4CL88Z8q0Bf/VHUun
         LXywjYEx60i2QRzXkU+Ho8+vbPdBBK85uWSo7Exqsa+OBLuGrDSAyZL11HEIiF7aP5Qh
         ul990Muo2QpndqFzzJtSXaK0ku4QhwcPYtw+1SgZToX4dewv02H50hwkTvV1nDM89pRy
         7h8Q==
X-Gm-Message-State: APjAAAWpgwzp91IGwS9wuBInmhN2yUIAIGBUnt7ZlmhbIXCRhESE87ff
        an1LfJfI6E5nya8/3HH7+c/mX5CmD92BCbuebYg/vTLZVBC7DvvAivR7bzdt/vUl4A==
X-Google-Smtp-Source: APXvYqwk1pZdmTm8xzObKTTZgelMb2/Nqjd7ldXvP8RIGZSwCBDfeOtAx9e281abWnZfBAflakFtD5GOtPIa
X-Received: by 2002:a1c:6782:: with SMTP id b124mr5525568wmc.143.1565774534331;
        Wed, 14 Aug 2019 02:22:14 -0700 (PDT)
Received: from heliosphere.sirena.org.uk (heliosphere.sirena.org.uk. [2a01:7e01::f03c:91ff:fed4:a3b6])
        by smtp-relay.gmail.com with ESMTPS id m2sm33363wmg.0.2019.08.14.02.22.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 02:22:14 -0700 (PDT)
X-Relaying-Domain: sirena.org.uk
Received: from ypsilon.sirena.org.uk ([2001:470:1f1d:6b5::7])
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1hxpTy-0004dk-2r; Wed, 14 Aug 2019 09:22:14 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 737A12742B4F; Wed, 14 Aug 2019 10:22:13 +0100 (BST)
Date:   Wed, 14 Aug 2019 10:22:13 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ricard Wanderlof <ricard.wanderlof@axis.com>,
        Ricard Wanderlof <ricardw@axis.com>
Subject: Re: [PATCH AUTOSEL 5.2 040/123] ASoC: Fail card instantiation if DAI
 format setup fails
Message-ID: <20190814092213.GC4640@sirena.co.uk>
References: <20190814021047.14828-1-sashal@kernel.org>
 <20190814021047.14828-40-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="f0KYrhQ4vYSV2aJu"
Content-Disposition: inline
In-Reply-To: <20190814021047.14828-40-sashal@kernel.org>
X-Cookie: Bridge ahead.  Pay troll.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--f0KYrhQ4vYSV2aJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2019 at 10:09:24PM -0400, Sasha Levin wrote:
> From: Ricard Wanderlof <ricard.wanderlof@axis.com>
>=20
> [ Upstream commit 40aa5383e393d72f6aa3943a4e7b1aae25a1e43b ]
>=20
> If the DAI format setup fails, there is no valid communication format
> between CPU and CODEC, so fail card instantiation, rather than continue
> with a card that will most likely not function properly.

This is another one where if nobody noticed a problem already and things
just happened to be working this might break things, it's vanishingly
unlikely to fix anything that was broken.

--f0KYrhQ4vYSV2aJu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1T0sQACgkQJNaLcl1U
h9Dlhgf/SR61ZIrJGolkp7rFvrAe5gVGCY1dA1YOv8xsh+klKIFA/mYQygTalGzO
vdEeVShGrPlbSXr4LKkOF97cB1Reflot2WD9jPjVPN509G/Kw01cI63Zh4fPco7q
UebertPWgV6fJqMNBwOv8ecLpF1dvtfyTt7APxEQx1Qgj3JIcXY0n2oRVQzHVnRF
QQBP5i2uCsqbyqJmcMMbYTwyXmETLFKbZZcl/JHcKayztlZSW4pvIG9nhtqQctZ8
Rl551stNHaRmcPn59Y6DcLSyt46MQoA+U3kndIp+hJS89MCcv+4iGfZ+OoSX1cJ8
kv8hFunAg3CxrcC7CPQxRYIAbzLcpw==
=PJBh
-----END PGP SIGNATURE-----

--f0KYrhQ4vYSV2aJu--
