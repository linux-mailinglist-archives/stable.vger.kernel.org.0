Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A7B2474F1
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387421AbgHQTRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392233AbgHQTRR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 15:17:17 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3E0C061389
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 12:17:16 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id d19so8557570pgl.10
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 12:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iuQjdooPw+82DK8qK+HJh8tqOrTsjn7EvjIGcGqxI0c=;
        b=vcmnyaugpmNO9yZ6hTKLW0lBzYrUjoQjc5uyoYlNDmx3jv4vg0yXK7bUe/9VB/3eu7
         /ev5Lbo1cGTYC0iNxLwjh1A2xixqx4b4+N4ysaTTfCVOmVsbRka6XOQd6/99WhENgIMv
         4c7emdf0k+5x3E0KpCffi/892xkwFRkkgp5kn/o1vgpy86jRWLR9rdY5VRLIPTVCub2B
         BV1UeyNs4EI2jk0OZRAkgieIvCKXBLfRWHpfhc2KOPhkFwwlGHqlLbxCq5ibWEx9HaxL
         gmGLoEZg2d+ONUDlm8EZlLgne4T4wQegMM4lNUnJrCJ0cuQUCcNioBfE/TxwSUsuSsTN
         uzJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iuQjdooPw+82DK8qK+HJh8tqOrTsjn7EvjIGcGqxI0c=;
        b=r65chW+qkL6TLGx/CeO/I2/oSb/cRN+c98e13ntci/35+Xpn1wRXfgnXLyiJw94bJ6
         d19A8ufKmwdwK5mIe5u3Ki/+hHv4TJy1KQqTd7Qi5ho2jnozw6ISUjAy9UVEvHqfugeT
         KSJ+2RxKba7qt6tSkXdrsPAJcQsZwL6yl0QpBnfxAro0uDbDpnVLmkhEVWUOBi/MzPY6
         DjjnBZmeB7Uq5PYN5uS1r8Wb9tnU06H5hT9TI8kpP1OeXcfKqdn7vCJUxkvqvsLoSgt1
         zJqGL46cnv04afkaMk90phLEZ1EETGME0CYjPI3HM6Rzn40AkeKpkc21HfX1RnLNJjAt
         pLDw==
X-Gm-Message-State: AOAM530w8i7zqKhfX6OxSlg/Qbg6eKqLmUs761MSoB0eLdtvjbnA8+V1
        yfzaSffovN0C71aps1VaWRkUevymHeZezA==
X-Google-Smtp-Source: ABdhPJzW/uXlalEzQsioMweGNm4DNBlfntWBQdCjF58khxIWKu2Y6y469ddhv4Zia14m4jlgrwiCKQ==
X-Received: by 2002:a63:7251:: with SMTP id c17mr11232261pgn.101.1597691833862;
        Mon, 17 Aug 2020 12:17:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z26sm6259986pfa.55.2020.08.17.12.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 12:17:13 -0700 (PDT)
Message-ID: <5f3ad7b9.1c69fb81.7cec8.f636@mx.google.com>
Date:   Mon, 17 Aug 2020 12:17:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.232-120-g11806ba5e43a
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 117 runs,
 4 regressions (v4.4.232-120-g11806ba5e43a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 117 runs, 4 regressions (v4.4.232-120-g1180=
6ba5e43a)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
| results
-----------------+--------+---------------+----------+---------------------=
+--------
omap3-beagle-xm  | arm    | lab-baylibre  | gcc-8    | omap2plus_defconfig =
| 2/5    =

qemu_x86_64      | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 0/1    =

qemu_x86_64-uefi | x86_64 | lab-collabora | gcc-8    | x86_64_defconfig    =
| 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.232-120-g11806ba5e43a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.232-120-g11806ba5e43a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      11806ba5e43a59700083cc2b7ada489b7cea1487 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
| results
-----------------+--------+---------------+----------+---------------------=
+--------
omap3-beagle-xm  | arm    | lab-baylibre  | gcc-8    | omap2plus_defconfig =
| 2/5    =


  Details:     https://kernelci.org/test/plan/id/5f3aa423a26e435d20d99a48

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-120-g11806ba5e43a/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap=
3-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-120-g11806ba5e43a/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap=
3-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f3aa423a26e435d=
20d99a4b
      new failure (last pass: v4.4.232)
      1 lines

    2020-08-17 15:37:02.074000  / # =

    2020-08-17 15:37:02.178000  #
    2020-08-17 15:37:02.179000  =

    2020-08-17 15:37:02.280000  / # #export SHELL=3D/bin/sh
    2020-08-17 15:37:02.281000  =

    2020-08-17 15:37:02.382000  / # export SHELL=3D/bin/sh. /lava-286087/en=
vironment
    2020-08-17 15:37:02.382000  =

    2020-08-17 15:37:02.484000  / # . /lava-286087/environment/lava-286087/=
bin/lava-test-runner /lava-286087/0
    2020-08-17 15:37:02.485000  =

    2020-08-17 15:37:02.486000  / # /lava-286087/bin/lava-test-runner /lava=
-286087/0
    ... (8 line(s) more)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f3aa423a26e=
435d20d99a4d
      new failure (last pass: v4.4.232)
      28 lines

    2020-08-17 15:37:02.978000  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2020-08-17 15:37:02.983000  kern  :emerg : Process udevd (pid: 110, sta=
ck limit =3D 0xcb94a218)
    2020-08-17 15:37:02.987000  kern  :emerg : Stack: (0xcb94bd10 to 0xcb94=
c000)
    2020-08-17 15:37:02.996000  kern  :emerg : bd00:                       =
              bf02b8fc bf010b84 cb95b610 bf02b988
    2020-08-17 15:37:03.004000  kern  :emerg : bd20: cb95b610 bf2610a8 0000=
0002 cb912010 cb95b610 bf284b54 cbbed690 cbbed690
    2020-08-17 15:37:03.012000  kern  :emerg : bd40: 00000000 00000000 ce22=
8930 c01fafd0 ce228930 ce228930 c085646c 00000001
    2020-08-17 15:37:03.020000  kern  :emerg : bd60: ce228930 cbbed690 cbbe=
d750 00000000 ce228930 c085646c 00000001 c095f2c0
    2020-08-17 15:37:03.029000  kern  :emerg : bd80: ffffffed bf288ff4 ffff=
fdfb 00000021 00000001 c00ce2e4 bf289188 c0407510
    2020-08-17 15:37:03.037000  kern  :emerg : bda0: c095f2c0 c120aa70 bf28=
8ff4 00000000 00000021 c04059e4 c095f2c0 c095f2f4
    2020-08-17 15:37:03.045000  kern  :emerg : bdc0: bf288ff4 00000000 0000=
0000 c0405b8c 00000000 bf288ff4 c0405b00 c0403eb0
    ... (18 line(s) more)
      =



platform         | arch   | lab           | compiler | defconfig           =
| results
-----------------+--------+---------------+----------+---------------------=
+--------
qemu_x86_64      | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3aa4b95297226cbad99a39

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-120-g11806ba5e43a/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-120-g11806ba5e43a/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3aa4b95297226cbad99=
a3a
      new failure (last pass: v4.4.232)  =



platform         | arch   | lab           | compiler | defconfig           =
| results
-----------------+--------+---------------+----------+---------------------=
+--------
qemu_x86_64-uefi | x86_64 | lab-collabora | gcc-8    | x86_64_defconfig    =
| 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3aa4abf30e37204bd99a58

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-120-g11806ba5e43a/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qem=
u_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-120-g11806ba5e43a/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qem=
u_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3aa4abf30e37204bd99=
a59
      new failure (last pass: v4.4.232)  =20
