Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53CD514362
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 09:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355243AbiD2HrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 03:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351092AbiD2HrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 03:47:02 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6633A8888;
        Fri, 29 Apr 2022 00:43:44 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DCD121C0B8E; Fri, 29 Apr 2022 09:43:41 +0200 (CEST)
Date:   Fri, 29 Apr 2022 09:43:41 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        iwamatsu@nigauri.org, dinguyen@kernel.org
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/53] 4.19.240-rc1 review [net: ethernet: stmmac:
 fix altr_tse_pcs function when using a]
Message-ID: <20220429074341.GB1423@amd>
References: <20220426081735.651926456@linuxfoundation.org>
 <20220426200000.GB9427@duo.ucw.cz>
 <YmkrZ5t2cb1JSHR8@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="St7VIuEGZ6dlpu13"
Content-Disposition: inline
In-Reply-To: <YmkrZ5t2cb1JSHR8@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > This is the start of the stable review cycle for the 4.19.240 release.
> > > There are 53 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
=2E..
> > I still see problems on socfpga:
> >=20
> > [    1.227759]  mmcblk0: p1 p2 p3
> > [    1.269825] Micrel KSZ9031 Gigabit PHY stmmac-0:01: attached PHY dri=
ver [Micrel KSZ9031 Gigabit PHY] (mii_bus:phy_addr=3Dstmmac-0:01, irq=3DPOL=
L)
> > [    1.284600] socfpga-dwmac ff702000.ethernet eth0: No Safety Features=
 support found
> > [    1.292374] socfpga-dwmac ff702000.ethernet eth0: registered PTP clo=
ck
> > [    1.299247] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> > [    5.444552] Unable to handle kernel NULL pointer dereference at virt=
ual address 00000000
=2E..
> > [    5.478679] Workqueue: events_power_efficient phy_state_machine
> > [    5.484579] PC is at socfpga_dwmac_fix_mac_speed+0x3c/0xbc
> > [    5.490044] LR is at arm_heavy_mb+0x2c/0x48

> > https://lava.ciplatform.org/scheduler/job/669257
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/23=
77419824
>=20
> Can you run git bisect?

Not a bisect, but we guessed e2423aa174e6 was responsible, and tested
it boots with that patch reverted.

Best regards,
								Pavel

commit e2423aa174e6c3e9805e96db778245ba73cdd88c

    net: ethernet: stmmac: fix altr_tse_pcs function when using a
    fixed-link

    [ Upstream commit a6aaa00324240967272b451bfa772547bd576ee6 ]
   =20
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--St7VIuEGZ6dlpu13
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmJrly0ACgkQMOfwapXb+vLeHgCcDTzrfnL1ZpnCLpPO1czIfto3
bbIAoKcaBBlem+j0GygF58WrrPRFTn7d
=UPXn
-----END PGP SIGNATURE-----

--St7VIuEGZ6dlpu13--
