Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE09D505DF2
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 20:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiDRSVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 14:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiDRSVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 14:21:14 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82126414;
        Mon, 18 Apr 2022 11:18:34 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8C7331C0B77; Mon, 18 Apr 2022 20:18:33 +0200 (CEST)
Date:   Mon, 18 Apr 2022 20:18:33 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/63] 5.4.190-rc1 review
Message-ID: <20220418181833.GA3239@duo.ucw.cz>
References: <20220418121134.149115109@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <20220418121134.149115109@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.4.190 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I see that AUTOSEL patches from Apr 11 are in this series, but patches
=66rom Apr 6 are not. Is there story behind that?

Best regards,
									Pavel

Apr 6:

 4.9 1/7] gfs2: assign rgrp glock before compute_bitstructs                =
          =20
 4.9 2/7] um: Cleanup syscall_handler_t definition/cast, fix warning
 4.9 3/7] um: port_user: Improve error handling when port-helper is not fou=
nd
 4.9 4/7] Input: add bounds checking to input_set_capability()
 4.9 5/7] MIPS: lantiq: check the return value of kzalloc()
 4.9 6/7] drbd: remove usage of list iterator variable after loop
 4.9 7/7] ARM: 9191/1: arm/stacktrace, kasan: Silence KASAN warnings in unw=
ind_frame()

 4.19 05/11] Input: stmfts - fix reference leak in stmfts_input_open
 4.19 06/11] crypto: stm32 - fix reference leak in stm32_crc_remove
 4.19 10/11] nilfs2: fix lockdep warnings in page operations for btree nodes
 4.19 11/11] nilfs2: fix lockdep warnings during disk space reclamation

 5.10 02/25] rtc: fix use-after-free on device removal
 5.10 03/25] rtc: pcf2127: fix bug when reading alarm registers            =
          =20
 5.10 08/25] nvme-pci: add quirks for Samsung X5 SSDs
 5.10 09/25] gfs2: Disable page faults during lockless buffered reads
 5.10 10/25] rtc: sun6i: Fix time overflow handling
 5.10 12/25] crypto: x86/chacha20 - Avoid spurious jumps to other functions
 5.10 13/25] ALSA: hda/realtek: Enable headset mic on Lenovo P360
 5.10 14/25] s390/pci: improve zpci_dev reference counting
 5.10 15/25] vhost_vdpa: don't setup irq offloading when irq_num < 0
 5.10 16/25] tools/virtio: compile with -pthread
 5.10 17/25] nvme-multipath: fix hang when disk goes live over reconnect
 5.10 18/25] rtc: mc146818-lib: Fix the AltCentury for AMD platforms  =20
 5.10 19/25] fs: fix an infinite loop in iomap_fiemap
 5.10 22/25] platform/chrome: cros_ec_debugfs: detach log reader wq from de=
vm

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYl2reQAKCRAw5/Bqldv6
8vUQAKCDHKlsbSDvnhV4m85zggXGPAsM2gCgjsUqnA5UH2yv7XRjAY9BltgTt3E=
=5RTg
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
