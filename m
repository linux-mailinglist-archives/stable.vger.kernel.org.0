Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23330505DC3
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 19:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241883AbiDRR5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 13:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345630AbiDRR5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 13:57:11 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B8934BB4;
        Mon, 18 Apr 2022 10:54:29 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B88D21C0B77; Mon, 18 Apr 2022 19:54:27 +0200 (CEST)
Date:   Mon, 18 Apr 2022 19:54:27 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/32] 4.19.239-rc1 review
Message-ID: <20220418175427.GA20121@duo.ucw.cz>
References: <20220418121127.127656835@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <20220418121127.127656835@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.239 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.

We have some problems with testing, but it seems there are real
failures there, too.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/5=
18905412

We seem to have ethernet failure on siemends-de0-nano:

https://lava.ciplatform.org/scheduler/job/664854

[    0.000000] Linux version 4.19.239-rc1-g6124afa49867 (root@runner-vacchx=
9n-project-14394223-concurrent-1f2btv) (gcc version 8.3.0 (Debian 8.3.0-2))=
 #1 SMP Mon Apr 18 14:05:18 UTC 2022
[    0.000000] CPU: ARMv7 Processor [413fc090] revision 0 (ARMv7), cr=3D10c=
5387d
=2E..
[    1.210887] mmc0: new high speed SDHC card at address 59b4
[    1.217318] mmcblk0: mmc0:59b4 SD    3.75 GiB=20
[    1.223255]  mmcblk0: p1 p2
[    1.279623] Micrel KSZ9031 Gigabit PHY stmmac-0:01: attached PHY driver =
[Micrel KSZ9031 Gigabit PHY] (mii_bus:phy_addr=3Dstmmac-0:01, irq=3DPOLL)
[    1.303607] socfpga-dwmac ff702000.ethernet eth0: No Safety Features sup=
port found
[    1.311339] socfpga-dwmac ff702000.ethernet eth0: registered PTP clock
[    1.318187] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    4.484377] Unable to handle kernel NULL pointer dereference at virtual =
address 00000000
[    4.492433] pgd =3D (ptrval)
[    4.495145] [00000000] *pgd=3D00000000
[    4.498714] Internal error: Oops: 805 [#1] SMP ARM
[    4.503483] Modules linked in:
[    4.506531] CPU: 1 PID: 266 Comm: kworker/1:1 Not tainted 4.19.239-rc1-g=
6124afa49867 #1
[    4.514496] Hardware name: Altera SOCFPGA
[    4.518500] Workqueue: events_power_efficient phy_state_machine
[    4.524400] PC is at socfpga_dwmac_fix_mac_speed+0x3c/0xbc
[    4.529864] LR is at arm_heavy_mb+0x2c/0x48
[    4.534028] pc : [<c05d992c>]    lr : [<c01182e8>]    psr: 60000013
[    4.540265] sp : ee9c5e58  ip : ee9c5e48  fp : ee9c5e7c
[    4.545465] r10: 00000001  r9 : ef243800  r8 : 00000000
[    4.550665] r7 : 00000000  r6 : 000003e8  r5 : eebec000  r4 : eeb0f880
[    4.557163] r3 : 00000001  r2 : 00000730  r1 : 00000000  r0 : eeb0f880
[    4.563660] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment=
 none
[    4.570762] Control: 10c5387d  Table: 0000404a  DAC: 00000051
[    4.576482] Process kworker/1:1 (pid: 266, stack limit =3D 0x(ptrval))
[    4.582807] Stack: (0xee9c5e58 to 0xee9c6000)
[    4.587146] 5e40:                                                       =
ef243800 eebec000
[    4.595288] 5e60: eebed000 eebec538 00610c8c eebec500 ee9c5eb4 ee9c5e80 =
c05ccf84 c05d98fc
[    4.603430] 5e80: c0705800 c018fabc eebec000 ef243800 eebec000 ef243a90 =
00000000 00000000
[    4.611572] 5ea0: c0c77830 00000000 ee9c5ecc ee9c5eb8 c05bae3c c05ccdf0 =
ef243a64 ef243800
[    4.619715] 5ec0: ee9c5ef4 ee9c5ed0 c05b911c c05bae08 ef243a64 ef182200 =
ef7e1fc0 ef7e5500
[    4.627857] 5ee0: 00000000 c0c77830 ee9c5f34 ee9c5ef8 c013e18c c05b8de0 =
ef7e1fc0 ef7e1fc0
[    4.635998] 5f00: 00000008 ef7e1fd8 c0c02d00 ef182200 ef182214 ef7e1fc0 =
00000008 ef7e1fd8
[    4.644141] 5f20: c0c02d00 ef7e1fc0 ee9c5f74 ee9c5f38 c013f178 c013df74 =
c013f118 c09e2128
[    4.652283] 5f40: c0c77250 ffffe000 ee9c5f74 ef188400 ef1885c0 00000000 =
ee9c4000 ef182200
[    4.660425] 5f60: c013f118 ef14be74 ee9c5fac ee9c5f78 c0144ac8 c013f124 =
ef18841c ef18841c
[    4.668567] 5f80: ee9c5fac ef1885c0 c014495c 00000000 00000000 00000000 =
00000000 00000000
[    4.676709] 5fa0: 00000000 ee9c5fb0 c01010e8 c0144968 00000000 00000000 =
00000000 00000000
[    4.684850] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000
[    4.692991] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000 =
00000000 00000000
[    4.701128] Backtrace:=20
[    4.703578] [<c05d98f0>] (socfpga_dwmac_fix_mac_speed) from [<c05ccf84>]=
 (stmmac_adjust_link+0x1a0/0x21c)
[    4.713104]  r9:eebec500 r8:00610c8c r7:eebec538 r6:eebed000 r5:eebec000=
 r4:ef243800
[    4.720818] [<c05ccde4>] (stmmac_adjust_link) from [<c05bae3c>] (phy_lin=
k_change+0x40/0x4c)
[    4.729133]  r10:00000000 r9:c0c77830 r8:00000000 r7:00000000 r6:ef243a9=
0 r5:eebec000
[    4.736925]  r4:ef243800
[    4.739452] [<c05badfc>] (phy_link_change) from [<c05b911c>] (phy_state_=
machine+0x348/0x580)
[    4.747850]  r5:ef243800 r4:ef243a64
[    4.751418] [<c05b8dd4>] (phy_state_machine) from [<c013e18c>] (process_=
one_work+0x224/0x518)
[    4.759905]  r9:c0c77830 r8:00000000 r7:ef7e5500 r6:ef7e1fc0 r5:ef182200=
 r4:ef243a64
[    4.767619] [<c013df68>] (process_one_work) from [<c013f178>] (worker_th=
read+0x60/0x5ac)
[    4.775674]  r10:ef7e1fc0 r9:c0c02d00 r8:ef7e1fd8 r7:00000008 r6:ef7e1fc=
0 r5:ef182214
[    4.783466]  r4:ef182200
[    4.785994] [<c013f118>] (worker_thread) from [<c0144ac8>] (kthread+0x16=
c/0x174)
[    4.793358]  r10:ef14be74 r9:c013f118 r8:ef182200 r7:ee9c4000 r6:0000000=
0 r5:ef1885c0
[    4.801149]  r4:ef188400
[    4.803675] [<c014495c>] (kthread) from [<c01010e8>] (ret_from_fork+0x14=
/0x2c)
[    4.810863] Exception stack(0xee9c5fb0 to 0xee9c5ff8)
[    4.815892] 5fa0:                                     00000000 00000000 =
00000000 00000000
[    4.824033] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000
[    4.832172] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    4.838759]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:0000000=
0 r5:c014495c
[    4.846550]  r4:ef1885c0
[    4.849075] Code: e59394b8 f57ff04e ebecfa64 e3a03001 (e1c830b0)=20
[    4.855171] ---[ end trace d50de8fdda236faf ]---
[    4.859852] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Matched prompt #3: Stack:\s+(.*\s+-+\[ end trace (\w*) \]-+)
login-action: trace
[login-action] Waiting for messages, (timeout 00:09:06)
[    4.883589] Sending DHCP requests ...... timed out!
[  205.043594] random: fast init done
[  418.243624] random: crng init done

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYl2l0wAKCRAw5/Bqldv6
8lhgAJ96wISX1/ZXo8pF/pczRjvoEPHMaACdG4rDKJVHj/cIboZB+Zb156i88dM=
=0Bfx
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
