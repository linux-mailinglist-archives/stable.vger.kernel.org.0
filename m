Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D40374F2
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 15:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfFFNQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 09:16:11 -0400
Received: from mx1.emlix.com ([188.40.240.192]:36960 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfFFNQL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 09:16:11 -0400
Received: from mailer.emlix.com (unknown [81.20.119.6])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id B23E860076;
        Thu,  6 Jun 2019 15:16:07 +0200 (CEST)
From:   Rolf Eike Beer <eb@emlix.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: Linux 4.9.180 build fails with gcc 9 and 'cleanup_module' specifies less restrictive attribute than its target =?UTF-8?B?4oCm?=
Date:   Thu, 06 Jun 2019 15:16:03 +0200
Message-ID: <259986242.BvXPX32bHu@devpool35>
Organization: emlix GmbH
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1874232.lpsZmVzLgH"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart1874232.lpsZmVzLgH
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

I have at least these 2 instances:


In file included from /tmp/e2/build/linux-4.9.180/include/drm/drm_vma_manag=
er.h:28,
                 from /tmp/e2/build/linux-4.9.180/include/drm/drmP.h:78,
                 from /tmp/e2/build/linux-4.9.180/include/drm/drm_modeset_h=
elper.h:26,
                 from /tmp/e2/build/linux-4.9.180/include/drm/drm_atomic_he=
lper.h:33,
                 from /tmp/e2/build/linux-4.9.180/drivers/gpu/drm/tilcdc/ti=
lcdc_drv.c:24:
/tmp/e2/build/linux-4.9.180/include/linux/module.h:138:7: error: 'cleanup_m=
odule' specifies less restrictive attribute than its target 'tilcdc_drm_fin=
i': 'cold' [-Werror=3Dmissing-attributes]
  138 |  void cleanup_module(void) __attribute__((alias(#exitfn)));
      |       ^~~~~~~~~~~~~~
/tmp/e2/build/linux-4.9.180/drivers/gpu/drm/tilcdc/tilcdc_drv.c:757:1: note=
: in expansion of macro 'module_exit'
  757 | module_exit(tilcdc_drm_fini);
      | ^~~~~~~~~~~
/tmp/e2/build/linux-4.9.180/drivers/gpu/drm/tilcdc/tilcdc_drv.c:748:20: not=
e: 'cleanup_module' target declared here
  748 | static void __exit tilcdc_drm_fini(void)
      |                    ^~~~~~~~~~~~~~~
In file included from /tmp/e2/build/linux-4.9.180/include/drm/drm_vma_manag=
er.h:28,
                 from /tmp/e2/build/linux-4.9.180/include/drm/drmP.h:78,
                 from /tmp/e2/build/linux-4.9.180/include/drm/drm_modeset_h=
elper.h:26,
                 from /tmp/e2/build/linux-4.9.180/include/drm/drm_atomic_he=
lper.h:33,
                 from /tmp/e2/build/linux-4.9.180/drivers/gpu/drm/tilcdc/ti=
lcdc_drv.c:24:
/tmp/e2/build/linux-4.9.180/include/linux/module.h:132:6: error: 'init_modu=
le' specifies less restrictive attribute than its target 'tilcdc_drm_init':=
 'cold' [-Werror=3Dmissing-attributes]
  132 |  int init_module(void) __attribute__((alias(#initfn)));
      |      ^~~~~~~~~~~
/tmp/e2/build/linux-4.9.180/drivers/gpu/drm/tilcdc/tilcdc_drv.c:756:1: note=
: in expansion of macro 'module_init'
  756 | module_init(tilcdc_drm_init);
      | ^~~~~~~~~~~
/tmp/e2/build/linux-4.9.180/drivers/gpu/drm/tilcdc/tilcdc_drv.c:740:19: not=
e: 'init_module' target declared here
  740 | static int __init tilcdc_drm_init(void)
      |                   ^~~~~~~~~~~~~~~



In file included from /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52=
xx/mpc52xx_lpbfifo.c:17:
/tmp/e2/build/linux-4.9.180/include/linux/module.h:138:7: error: 'cleanup_m=
odule' specifies less restrictive attribute than its target 'mpc52xx_lpbfif=
o_driver_exit': 'cold' [-Werror=3Dmissing-attributes]
  138 |  void cleanup_module(void) __attribute__((alias(#exitfn)));
      |       ^~~~~~~~~~~~~~
/tmp/e2/build/linux-4.9.180/include/linux/device.h:1360:1: note: in expansi=
on of macro 'module_exit'
 1360 | module_exit(__driver##_exit);
      | ^~~~~~~~~~~
/tmp/e2/build/linux-4.9.180/include/linux/platform_device.h:228:2: note: in=
 expansion of macro 'module_driver'
  228 |  module_driver(__platform_driver, platform_driver_register, \
      |  ^~~~~~~~~~~~~
/tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:5=
81:1: note: in expansion of macro 'module_platform_driver'
  581 | module_platform_driver(mpc52xx_lpbfifo_driver);
      | ^~~~~~~~~~~~~~~~~~~~~~
In file included from /tmp/e2/build/linux-4.9.180/arch/powerpc/include/asm/=
io.h:27,
                 from /tmp/e2/build/linux-4.9.180/include/linux/io.h:25,
                 from /tmp/e2/build/linux-4.9.180/include/linux/irq.h:24,
                 from /tmp/e2/build/linux-4.9.180/arch/powerpc/include/asm/=
hardirq.h:5,
                 from /tmp/e2/build/linux-4.9.180/include/linux/hardirq.h:8,
                 from /tmp/e2/build/linux-4.9.180/include/linux/interrupt.h=
:12,
                 from /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52=
xx/mpc52xx_lpbfifo.c:12:
/tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:5=
81:24: note: 'cleanup_module' target declared here
  581 | module_platform_driver(mpc52xx_lpbfifo_driver);
      |                        ^~~~~~~~~~~~~~~~~~~~~~
/tmp/e2/build/linux-4.9.180/include/linux/device.h:1356:20: note: in defini=
tion of macro 'module_driver'
 1356 | static void __exit __driver##_exit(void) \
      |                    ^~~~~~~~
/tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:5=
81:1: note: in expansion of macro 'module_platform_driver'
  581 | module_platform_driver(mpc52xx_lpbfifo_driver);
      | ^~~~~~~~~~~~~~~~~~~~~~
In file included from /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52=
xx/mpc52xx_lpbfifo.c:17:
/tmp/e2/build/linux-4.9.180/include/linux/module.h:132:6: error: 'init_modu=
le' specifies less restrictive attribute than its target 'mpc52xx_lpbfifo_d=
river_init': 'cold' [-Werror=3Dmissing-attributes]
  132 |  int init_module(void) __attribute__((alias(#initfn)));
      |      ^~~~~~~~~~~
/tmp/e2/build/linux-4.9.180/include/linux/device.h:1355:1: note: in expansi=
on of macro 'module_init'
 1355 | module_init(__driver##_init); \
      | ^~~~~~~~~~~
/tmp/e2/build/linux-4.9.180/include/linux/platform_device.h:228:2: note: in=
 expansion of macro 'module_driver'
  228 |  module_driver(__platform_driver, platform_driver_register, \
      |  ^~~~~~~~~~~~~
/tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:5=
81:1: note: in expansion of macro 'module_platform_driver'
  581 | module_platform_driver(mpc52xx_lpbfifo_driver);
      | ^~~~~~~~~~~~~~~~~~~~~~
In file included from /tmp/e2/build/linux-4.9.180/arch/powerpc/include/asm/=
io.h:27,
                 from /tmp/e2/build/linux-4.9.180/include/linux/io.h:25,
                 from /tmp/e2/build/linux-4.9.180/include/linux/irq.h:24,
                 from /tmp/e2/build/linux-4.9.180/arch/powerpc/include/asm/=
hardirq.h:5,
                 from /tmp/e2/build/linux-4.9.180/include/linux/hardirq.h:8,
                 from /tmp/e2/build/linux-4.9.180/include/linux/interrupt.h=
:12,
                 from /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52=
xx/mpc52xx_lpbfifo.c:12:
/tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:5=
81:24: note: 'init_module' target declared here
  581 | module_platform_driver(mpc52xx_lpbfifo_driver);
      |                        ^~~~~~~~~~~~~~~~~~~~~~
/tmp/e2/build/linux-4.9.180/include/linux/device.h:1351:19: note: in defini=
tion of macro 'module_driver'
 1351 | static int __init __driver##_init(void) \
      |                   ^~~~~~~~
/tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:5=
81:1: note: in expansion of macro 'module_platform_driver'
  581 | module_platform_driver(mpc52xx_lpbfifo_driver);
      | ^~~~~~~~~~~~~~~~~~~~~~


So this needs a6e60d84989fa0e91db7f236eda40453b0e44afa, which needs=20
c0d9782f5b6d7157635ae2fd782a4b27d55a6013, which can't be applied cleanly=20
because a3f8a30f3f0079c7edfc72e329eee8594fb3e3cb is missing in 4.9.

I have applied a6e60d84989fa0e91db7f236eda40453b0e44afa and modified it to=
=20
directly use __attribute__((__copy__(initfn))) and (exitfn), which fixes th=
e=20
build for me.

Greetings,

Eike
=2D-=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
=46on +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 G=C3=B6ttingen, Germany
Sitz der Gesellschaft: G=C3=B6ttingen, Amtsgericht G=C3=B6ttingen HR B 3160
Gesch=C3=A4ftsf=C3=BChrung: Heike Jordan, Dr. Uwe Kracke =E2=80=93 Ust-IdNr=
=2E: DE 205 198 055

emlix - smart embedded open source
--nextPart1874232.lpsZmVzLgH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iLMEAAEIAB0WIQQ/Uctzh31xzAxFCLur5FH7Xu2t/AUCXPkSEwAKCRCr5FH7Xu2t
/P0UA/0XEEE4SV1K9Al7Kp/Z6zR+qxR0yf9Q2txh7aiTE8mSU3ZIbe3Lhv8pp6Ba
Mtq0rPwTkVUe1LlxVfrSGOERfzqCQ6VEJLtBLcUhWwCBZCE6kkA2TdlHp3bViSYd
D6xZTXffWUVq/tgrRaYrMXH4bRIXSV+YRT2xpuYT9ZYn6fls9A==
=lCyW
-----END PGP SIGNATURE-----

--nextPart1874232.lpsZmVzLgH--



