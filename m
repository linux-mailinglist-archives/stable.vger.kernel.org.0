Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B65E69EB16
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 00:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjBUXSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 18:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjBUXSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 18:18:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D15D93C6
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 15:18:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B29BB81107
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 23:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C12C433EF;
        Tue, 21 Feb 2023 23:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677021480;
        bh=Mh//mLUoyP5yIuIIjymXpRAj8FV23s77Ahtu7KJhh4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qo4sH0rGPaRwtE/jWl91YCy9BGsPsoFN12cToQolh/EGEFCjn515f0fEsN0phuWZZ
         5v1SZyRZZ3qkfgBH33r1tZVX9KD3pO+zPtGIYBJmgtGebZFgG4Ya6PEP56o6Hz+6vF
         QIxRfosAqo5LoMF7nxnrpaUMoFWcYn3YRkXyaDGtsUa3TTbKnI+U1Gw4HB0Gk4llpX
         xso+KKkh4iCcXo5Dohdk8pvjGohJp/LTpo8iENgwZEv8F+1KiZ3JHQ5+N6srGMCGOJ
         iWTIeiahOSnScylPBbh2vi7RiwqF8wKCsvsVzC7SgyFIDEbpb/cB+iCPRh9eQPt0+a
         lRzfIxbJfUbig==
Date:   Tue, 21 Feb 2023 23:17:56 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Conor Dooley <conor.dooley@microchip.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        llvm@lists.linux.dev,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>
Subject: Re: stable-rc: 5.10: riscv: defconfig: clang-nightly: build failed -
 Invalid or unknown z ISA extension: 'zifencei'
Message-ID: <Y/VRJF0QKKqkFN6g@spud>
References: <CA+G9fYt9T=ELCLaB9byxaLW2Qf4pZcDO=huCA0D8ug2V2+irJQ@mail.gmail.com>
 <Y/SLn5fto6+9xX0r@wendy>
 <Y/VGu9IOJEKi6VwS@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="whT7Q92xxSfANgK+"
Content-Disposition: inline
In-Reply-To: <Y/VGu9IOJEKi6VwS@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--whT7Q92xxSfANgK+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 21, 2023 at 03:33:31PM -0700, Nathan Chancellor wrote:
> On Tue, Feb 21, 2023 at 09:15:11AM +0000, Conor Dooley wrote:
> > On Tue, Feb 21, 2023 at 02:30:17PM +0530, Naresh Kamboju wrote:
> > > The riscv defconfig and tinyconfig builds failed with clang-nightly
> > > due to below build warnings / errors on latest stable-rc 5.10.
> > >=20
> > > Regression on riscv:
> > >   - build/clang-nightly-tinyconfig - FAILED
> > >   - build/clang-nightly-defconfig - FAILED
> >=20
> > > Build log:
> > > ----
> > > make --silent --keep-going --jobs=3D8
> > > O=3D/home/tuxbuild/.cache/tuxmake/builds/1/build ARCH=3Driscv
> > > CROSS_COMPILE=3Driscv64-linux-gnu- HOSTCC=3Dclang CC=3Dclang LLVM=3D1
> > > LLVM_IAS=3D1 LD=3Driscv64-linux-gnu-ld
> > > riscv64-linux-gnu-ld: -march=3Drv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p=
0:
> > > Invalid or unknown z ISA extension: 'zifencei'
> > > riscv64-linux-gnu-ld: failed to merge target specific data of file
> > > init/version.o
> > > riscv64-linux-gnu-ld: -march=3Drv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p=
0:
> > > Invalid or unknown z ISA extension: 'zifencei'
> > > riscv64-linux-gnu-ld: failed to merge target specific data of file
> > > init/do_mounts.o
> > > riscv64-linux-gnu-ld: -march=3Drv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p=
0:
> > > Invalid or unknown z ISA extension: 'zifencei'
> > > riscv64-linux-gnu-ld: failed to merge target specific data of file
> > > init/noinitramfs.o
> > > riscv64-linux-gnu-ld: -march=3Drv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p=
0:
> > > Invalid or unknown z ISA extension: 'zifencei'
> > > riscv64-linux-gnu-ld: failed to merge target specific data of file
> > > init/calibrate.o
> > > riscv64-linux-gnu-ld: -march=3Drv64i2p0_m2p0_a2p0_zicsr2p0_zifencei2p=
0:
> > > Invalid or unknown z ISA extension: 'zifencei'
> >=20
> > > Build details,
> > > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build=
/v5.10.168-58-g7d11e4c4fc56/testrun/14869376/suite/build/test/clang-nightly=
-tinyconfig/details/
> >=20
> > binutils 2.35 by the looks of things, I **think** that zifencei didn't
> > land until 2.36. zicsr and zifence get added via cc-option-yn, which,
> > IIRC, doesn't do anything with the linker. I dunno if anyone in RISC-V
> > land cares this much about "odd" configurations back in 5.10, but while
> > a fix is outstanding, you could use a newer binutils?
>=20
> This is new in clang-17 so I bisected LLVM down to commit 22e199e6afb1
> ("[RISCV] Accept zicsr and zifencei command line options"), so I think
> we need something like commit aae538cd03bc ("riscv: fix detection of
> toolchain Zihintpause support") for zifencei to make sure all three
> tools stay in sync, since I suspect that this is reproducible in
> mainline with GNU ld. We just happen not to notice when using
> LLVM=3D1 LLVM_IAS=3D1 since the tools have symmetrical support.

At least if it is in mainline there'll be interest in fixing it!
Nobody was shipping hardware worth mention when 5.10 was en vogue, so
little interest in it :(

> I can work up something like that change tomorrow if that seems like the
> path worth taking.

I'm not sure if this one is the same as Zihintpause though, because
zifencei & zicsr were part of i prior to a spec update, so we may need
to be careful about the spec version that clang/llvm is using if we
decide not to pass zifencei/zicsr to it. See arch/riscv/Makefile, about
L55 for a comment...
I'll go get myself a clang-17 tomorrow and give things a whirl if you
want Nathan?

Cheers,
Conor.

--whT7Q92xxSfANgK+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/VRJAAKCRB4tDGHoIJi
0iDBAP4pOrkepLUC1dzex3KN1VvvGvYahiVr0Y2E42GJuoT7ZgD+KUgJ9xGpMiZh
vl3u969fkX/wptXNeEpGotMF0w2OxQs=
=Mg48
-----END PGP SIGNATURE-----

--whT7Q92xxSfANgK+--
