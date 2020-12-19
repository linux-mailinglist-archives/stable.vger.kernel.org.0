Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95AAC2DF09A
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 18:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgLSRGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 12:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbgLSRGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 12:06:32 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186FCC0613CF
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 09:05:52 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id e2so3384825pgi.5
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 09:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dCEXzENsQe0Pmox9MB/2WSGGcwKgoewXIvuO3MhHuio=;
        b=yCkpwJeTLnN+RANv3yAdZwPEGIAxSTcwohuVNblMeIc6f/Fo3P6ktt0JV6nS7617HI
         YBljx5O6wSZPJgDEmKga9HdUb7sGJmgEghlXouAeZAcd/Usc7oNPynZa3hwI1wNAM5tx
         fsuIWxnIakiEuZGRuq7K/48oGWr3MOcMy1SEP1QjSU+X+Tnkhdwr6addFuoFu3D43BqY
         p2LiVICn6TyOFFwLDYk21nNFYNmbPJ9vX4WZ2daANtfLfYnY3N1vQPtAzbfieUAPIx7O
         z5wzWzCCsVJ7zM3oamCrYWiSKaH5gXDDDmqlXf2pPvA3gyoG+YM1ExAkdUMyRuMO7sKN
         V9Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dCEXzENsQe0Pmox9MB/2WSGGcwKgoewXIvuO3MhHuio=;
        b=Tdvh3CbQpwWLI/F46UHWIQ9YP6gcL0wDVrZLrKo+dYrMRSMabdCx1kwJooQ7r420BL
         GVafCvJokoLxi4HQzJm18mQe+9sIxzDS8qndYGP/mLVUkb2T/HobiuWi0B7jlNiLL6iw
         aq3ndpeVKWXhGHBX1VQ3e70t6EFMBk5gVG9AHig+cEPNA3P/PBrmdtaqLzHvCawHU1k2
         i0baSdHvEXKMecVr9nvTbRjIkDvNfJCgtW21w4Z1hB9e4+5MIUk0G7Y9md9n2P90Kehf
         GvcYarqgZmffM+3VguilKZC3HLQrQW3KA/HrYveLIHqbECPDIb3LTRxkVjx8HTnGoaer
         bI3w==
X-Gm-Message-State: AOAM531UG5u2oEzrAn/3TR552sq7fjcexndKzVzRozhrnw7vfI/+DEUr
        OOD5+6RlTlzOOZt0FbpNOYSimigu+tUbDw==
X-Google-Smtp-Source: ABdhPJwhDkDZ/0O2gx17eLfK04K4/fPa/0fzKAEJ4nqQ57DaaJKKbrQpDqAsAs8n7AoP6w+ksf1MiA==
X-Received: by 2002:aa7:8712:0:b029:1a7:fe2e:1023 with SMTP id b18-20020aa787120000b02901a7fe2e1023mr8621929pfo.49.1608397551246;
        Sat, 19 Dec 2020 09:05:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bg20sm11007644pjb.6.2020.12.19.09.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 09:05:50 -0800 (PST)
Message-ID: <5fde32ee.1c69fb81.b19c8.e48d@mx.google.com>
Date:   Sat, 19 Dec 2020 09:05:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.83-71-gb8d18270c4a6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 146 runs,
 7 regressions (v5.4.83-71-gb8d18270c4a6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 146 runs, 7 regressions (v5.4.83-71-gb8d18270=
c4a6)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig=
   | 2          =

hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.83-71-gb8d18270c4a6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.83-71-gb8d18270c4a6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b8d18270c4a63087b3aafbab39fb3b01a627ba20 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig=
   | 2          =


  Details:     https://kernelci.org/test/plan/id/5fddff7dfac0b2a609c94ccf

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-71=
-gb8d18270c4a6/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-71=
-gb8d18270c4a6/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5fddff7dfac0b2a=
609c94cd3
        new failure (last pass: v5.4.83-55-gcba1195e54487)
        4 lines

    2020-12-19 13:26:09.677000+00:00  kern  :alert : Unable to handle kerne=
l paging request at virtual address 555554ed
    2020-12-19 13:26:09.678000+00:00  kern  :alert : pgd =3D 7ebc5a97
    2020-12-19 13:26:09.678000+00:00  kern  :alert : [555554ed] *pgd=3D0000=
0000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fddff7dfac0b2a=
609c94cd4
        new failure (last pass: v5.4.83-55-gcba1195e54487)
        22 lines

    2020-12-19 13:26:09.681000+00:00  kern  :emerg : Process udevd (pid: 98=
, stack limit =3D 0xac98de8b)
    2020-12-19 13:26:09.682000+00:00  kern  :emerg : Stack: (0xeaf1fdc0 to =
0xeaf20000)
    2020-12-19 13:26:09.720000+00:00  kern  :emerg : fdc0: 000000e6 eaf1fe6=
c c0e31cb8 fc51cd9b 00000000 c0254518 000000e6 c0e30fc4
    2020-12-19 13:26:09.721000+00:00  kern  :emerg : fde0: ea8ae770 eaf1feb=
0 eae87360 9280caf7 eaf1fe1c eaf1fea8 eaf4f000 00000000
    2020-12-19 13:26:09.722000+00:00  kern  :emerg : fe00: 00020241 eae8736=
0 ea8ae770 00000001 eaf1fea4 eaf1fe20 c024bcd8 c02541d4
    2020-12-19 13:26:09.723000+00:00  kern  :emerg : fe20: be889b60 000000c=
3 00000000 eaf1feb0 00000040 00000002 00000200 000041ed
    2020-12-19 13:26:09.724000+00:00  kern  :emerg : fe40: ea8ae770 0000004=
1 000081b6 00020241 eaf1ff58 c0241ef0 00000013 00000000
    2020-12-19 13:26:09.764000+00:00  kern  :emerg : fe60: 00000000 000020f=
f 000041ed eaf1fe6c eaf1fe6c 9280caf7 00000000 00000008
    2020-12-19 13:26:09.765000+00:00  kern  :emerg : fe80: c0d04248 eaf1ff5=
8 00000001 ffffff9c eaf1e000 00000142 eaf1ff54 eaf1fea8
    2020-12-19 13:26:09.766000+00:00  kern  :emerg : fea0: c024c444 c024b86=
8 ec5eec10 ea8ae770 fc51cd9b 00000009 ec51901f eaf1fec8 =

    ... (11 line(s) more)  =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddfefc255e1cf49dc94cdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-71=
-gb8d18270c4a6/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-71=
-gb8d18270c4a6/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddfefc255e1cf49dc94=
cde
        failing since 29 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddfeba1116106c6fc94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-71=
-gb8d18270c4a6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-=
p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-71=
-gb8d18270c4a6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-=
p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddfeba1116106c6fc94=
cbb
        new failure (last pass: v5.4.83-55-gcba1195e54487) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddfd6ee27be040fcc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-71=
-gb8d18270c4a6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-71=
-gb8d18270c4a6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddfd6ee27be040fcc94=
cba
        failing since 35 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddfdb1aa5466bc98c94cf6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-71=
-gb8d18270c4a6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-71=
-gb8d18270c4a6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddfdb1aa5466bc98c94=
cf7
        failing since 35 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddfd5c9e75cd7aa2c94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-71=
-gb8d18270c4a6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-71=
-gb8d18270c4a6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddfd5c9e75cd7aa2c94=
cbb
        failing since 35 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
