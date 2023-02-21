Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9649E69DCAA
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 10:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbjBUJPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 04:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbjBUJPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 04:15:41 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EB08693
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 01:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676970940; x=1708506940;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e0DmnT+SAfrNeMZkQPPGnVAjaAbuaGmqPifx6ERR0q4=;
  b=JkMg4zv/Y2bfzxMn56PDowf+RcxvVfxYE/fX7uGob1NsITfIGlQQWwwH
   LnYbLFWTGlT2Gp9d1fx0LOoeANDzTzKP5TnsZVr9r7UQ6FBbDD7hXVVEf
   7yZs+K7gJpmY2iiwH1v07ETXL0SO/VE6vliZLyQR5GtCeetUeBcvpi+V2
   osXaMZGiHKjbjDZS/u0VZmunxoAnVB2Udcz9BQfODYVNbdiRjlPw9Hym2
   RWVcxexYZaDRsYuW43arZZ6XAJTCwZIstDHwlgPp2gdbyy46s1peFok7+
   hlNtfk1fznUEKqg7u2ejzOUPDlwnUfEW8mT5tsBaZCuOPG4HN5DTH+vjk
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,315,1669100400"; 
   d="asc'?scan'208";a="201861307"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Feb 2023 02:15:39 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 02:15:38 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Tue, 21 Feb 2023 02:15:37 -0700
Date:   Tue, 21 Feb 2023 09:15:11 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
CC:     <llvm@lists.linux.dev>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-stable <stable@vger.kernel.org>,
        <lkft-triage@lists.linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, <conor@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>
Subject: Re: stable-rc: 5.10: riscv: defconfig: clang-nightly: build failed -
 Invalid or unknown z ISA extension: 'zifencei'
Message-ID: <Y/SLn5fto6+9xX0r@wendy>
References: <CA+G9fYt9T=ELCLaB9byxaLW2Qf4pZcDO=huCA0D8ug2V2+irJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZNjPGu8Cs6BNE/xO"
Content-Disposition: inline
In-Reply-To: <CA+G9fYt9T=ELCLaB9byxaLW2Qf4pZcDO=huCA0D8ug2V2+irJQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--ZNjPGu8Cs6BNE/xO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 21, 2023 at 02:30:17PM +0530, Naresh Kamboju wrote:
> The riscv defconfig and tinyconfig builds failed with clang-nightly
> due to below build warnings / errors on latest stable-rc 5.10.
>=20
> Regression on riscv:
>   - build/clang-nightly-tinyconfig - FAILED
>   - build/clang-nightly-defconfig - FAILED

> Build log:
> ----
> make --silent --keep-going --jobs=3D8
> O=3D/home/tuxbuild/.cache/tuxmake/builds/1/build ARCH=3Driscv
> CROSS_COMPILE=3Driscv64-linux-gnu- HOSTCC=3Dclang CC=3Dclang LLVM=3D1
> LLVM_IAS=3D1 LD=3Driscv64-linux-gnu-ld
> riscv64-linux-gnu-ld: -march=3Drv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p0:
> Invalid or unknown z ISA extension: 'zifencei'
> riscv64-linux-gnu-ld: failed to merge target specific data of file
> init/version.o
> riscv64-linux-gnu-ld: -march=3Drv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p0:
> Invalid or unknown z ISA extension: 'zifencei'
> riscv64-linux-gnu-ld: failed to merge target specific data of file
> init/do_mounts.o
> riscv64-linux-gnu-ld: -march=3Drv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p0:
> Invalid or unknown z ISA extension: 'zifencei'
> riscv64-linux-gnu-ld: failed to merge target specific data of file
> init/noinitramfs.o
> riscv64-linux-gnu-ld: -march=3Drv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p0:
> Invalid or unknown z ISA extension: 'zifencei'
> riscv64-linux-gnu-ld: failed to merge target specific data of file
> init/calibrate.o
> riscv64-linux-gnu-ld: -march=3Drv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p0:
> Invalid or unknown z ISA extension: 'zifencei'

> Build details,
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.=
10.168-58-g7d11e4c4fc56/testrun/14869376/suite/build/test/clang-nightly-tin=
yconfig/details/

binutils 2.35 by the looks of things, I **think** that zifencei didn't
land until 2.36. zicsr and zifence get added via cc-option-yn, which,
IIRC, doesn't do anything with the linker. I dunno if anyone in RISC-V
land cares this much about "odd" configurations back in 5.10, but while
a fix is outstanding, you could use a newer binutils?

--ZNjPGu8Cs6BNE/xO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/SLngAKCRB4tDGHoIJi
0olNAP9pkXL0kx8+BxRgZp9LY/qvnZ8Syy0+IoxvNK9MFe7RwwD/cJs7I84iYgZK
0x0D1LlFErcbyUOzYd6ixFsxBUeugwo=
=q8mA
-----END PGP SIGNATURE-----

--ZNjPGu8Cs6BNE/xO--
