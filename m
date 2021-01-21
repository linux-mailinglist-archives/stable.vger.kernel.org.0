Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6492FF48B
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 20:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbhAUTbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 14:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbhAUTFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 14:05:06 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0E0C0613D6;
        Thu, 21 Jan 2021 10:53:53 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id b5so2767896wrr.10;
        Thu, 21 Jan 2021 10:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GSNo4GQaMF01CN3jcOZYky+NX759MUu9sdXp7CoIzS0=;
        b=nAQr/sRJATdK0DqAwkGDw0KKvUrP1/VyLrtLabyHoZZQAjVySysTjzEjvXARgPpYQS
         ivx/E8XQ+kStGQummVVzsk8djxm1W5e5QVWTn0mTvSRLxnU20fmx8EGKMRtn7VBQiatZ
         p0nHYtI+edbkBt+ad0HJIw4xjgaSo5IO6tMSopKQkoIi/5nAj5SbnVG8x1HQqLIO7r9M
         XyM98dnWNXdkccXdZ1VPDdi3ks+6GawTeU+YDT1YW6MPfXgMXA5ZubrOBB4mnKQAmTOz
         B/4NGdLPWqiW2W9WN2d4z2vItET0EZ8rQmJlnaZzpRN7Ykkg6Yai5BDrTFrFf730Lj9M
         tucQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GSNo4GQaMF01CN3jcOZYky+NX759MUu9sdXp7CoIzS0=;
        b=efT1Ka00wc0UgxK14fVrOCygS83lM8vp9wp4uj2pRz38fZN86SHAwTmNc6hoTRNUE3
         wpq9GlpXUg4p7TumsjqbPjx5EobXtjfJ/7k7BqvSY1NoqPciz6Q8WtwaUhLOlnBp3lyu
         Rn2PhGephgYZytx1sbY2X9MHbUHqb1eszEw+cx5B51HLjVJdnJFl0GkSRmNBZiVX33lV
         YXeGPh7xM87lD4ncImzK/GbItFmf8KB+/lOiQRLbSC7z/6Ga+Ut7X6PPmxErglOWKyQf
         6BsJozdXBWpbJlXmuHqylR2ltJQ7LGz8guGzNo5J/h5/5t2WLTpjpWwzVQjBvrpfhF9n
         eqsw==
X-Gm-Message-State: AOAM532V3CtOqtqygvqNS26Ikxa908WrbaP8qhUCfufYzftctN/Ebk64
        YvXShec688mMN7ST3QnPktRulfucW+I=
X-Google-Smtp-Source: ABdhPJz5DlIzazgq+BpxAwHtAA/1THEgWazEtaOcDMZtKX1BTXdxh2SoRvXrjAQxa2kh0FKvRjOjbQ==
X-Received: by 2002:adf:f5c5:: with SMTP id k5mr893553wrp.286.1611255232632;
        Thu, 21 Jan 2021 10:53:52 -0800 (PST)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id h16sm8830498wmb.41.2021.01.21.10.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 10:53:51 -0800 (PST)
Date:   Thu, 21 Jan 2021 19:53:49 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     JC Kuo <jckuo@nvidia.com>
Cc:     gregkh@linuxfoundation.org, jonathanh@nvidia.com,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] arm64: tegra: Enable Jetson-Xavier J512 USB host
Message-ID: <YAnNvTtlx8jHyRG3@ulmo>
References: <20210119022349.136453-1-jckuo@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RWasVtTkUFJY1dK5"
Content-Disposition: inline
In-Reply-To: <20210119022349.136453-1-jckuo@nvidia.com>
User-Agent: Mutt/2.0.4 (26f41dd1) (2020-12-30)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--RWasVtTkUFJY1dK5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 19, 2021 at 10:23:49AM +0800, JC Kuo wrote:
> This commit enables USB host mode at J512 type-C port of Jetson-Xavier.
>=20
> Signed-off-by: JC Kuo <jckuo@nvidia.com>
> ---
>  .../arm64/boot/dts/nvidia/tegra194-p2888.dtsi |  8 +++++++
>  .../boot/dts/nvidia/tegra194-p2972-0000.dts   | 24 +++++++++++++++++--
>  2 files changed, 30 insertions(+), 2 deletions(-)

Applied, thanks.

Thierry

--RWasVtTkUFJY1dK5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmAJzbUACgkQ3SOs138+
s6FGwA//XuVbtQA6LY/Mptb4ENgPKL5kotvFnpTGdmQRuBhTV/Ga+zORCUVCSiRt
P9x5LUnMSHpgyZn+TKaNiZIrcxdV8m//TnjrwL+bDIlEZDBxHVOmapanhTjkNEhY
MNZ0NGXZsmzFRXeb2q6FC51lQEQeBT9yC33fe/5/KTCnMr+15NcmCy9nd+aWmImH
PHx7OJwoen7dXfcTKR/Q6Kxc0yKjcujyXKH64gXlSRjWJUnInF114Gc6GnGIMSOu
CBnW2i63lw21RAiR3s7Ys91pnjhXudoP/GogEeK05Zf/LufuW3vZ7hhLrk/sqG/g
LFbhE1UKGc44wuoMq2OFT/HwHsg9PcvNOaJ3sil1/9Pzjak4xeLHsF5W3NFWyiCj
LeqICBXqCqABTKckIjWy0U+LCcieHxVACb3gltOzASiJ5EA7ivzu4nebtPGuy4O3
PF2vC8xHO6beTQwYYAjK9J6cydttiOqrJeY0d5mhla6U0hR+YeSONeLJ+hNNfI8u
Y9gwJ53QRLW6t79av1NcBe5I+O9fguko3fqlnVwhvW0saqpIneYBy8J7a61KvqvH
PcLk4M2rfIMsWUTraaRw2q5gpM/ApPz46Nbdv+U17wJZQL5QbbIQeI7pYXeXulAG
4vz3q57PdpLkEMt0dfmflHZx0k2LxPRBkb3hcx4vrfPUPwYZf5E=
=Pioz
-----END PGP SIGNATURE-----

--RWasVtTkUFJY1dK5--
