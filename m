Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238B32D452A
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgLIPN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbgLIPNz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:13:55 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00DEC0613CF
        for <stable@vger.kernel.org>; Wed,  9 Dec 2020 07:13:15 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id t8so1201420pfg.8
        for <stable@vger.kernel.org>; Wed, 09 Dec 2020 07:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cPLd9mFK59pPemVB9mBDibu+U1IOm4VuPpxuWeWRP3g=;
        b=ruDcoNsutytRWja5g2KEzfvLYfX2AEgQPw5cIanNAtESa/laQeTBfB1LvDsH96hGBI
         aQT6AdjMa3zI2W/zseB4yp1ipK7knWce5VFU8H1ybrSUtlqW30ta0JY/MMKByzb4JrFz
         yPPV0v1v/zmnniJLXn4peT7ODkxJdI/+ynP9PF3BQWpBpml0BhNZ6IJsu2WAfr6Mhd4R
         zoILmvAl17CW73pLnpw9uhle0Sw4FUcrx5tSLbHOTM/LI10C/kTeodTv1AzFdpEWQW8S
         mXwcmYXJmAB5SdP03EeiqVB4nQRSk1F27d6os3cr/YfeHIHM+/2ETTbpmNFc8caSIPWi
         c4JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cPLd9mFK59pPemVB9mBDibu+U1IOm4VuPpxuWeWRP3g=;
        b=Blvghw/Oozb/HzHSWI847dBmUNDnojFiBwH+Gsp6kI/zU2IbZiwdoTqgDbW1XvgL+l
         TMVE5X4sIgyI56JmXvMKrLzmJT0zBVamRIIUIN9RLOlD+YtZgJorVOG0UUG9ExflHJdx
         D1ppPsZC1dlPMjJ3miXiU1avDK4bbVBX83v+y04Q2ZjmMoNbc1R6wApuS/jpAc/C1UQl
         dmWW7HX/Xd7HLGXqzeY81ZbtO4c7mmFHXwoaqypAeCHhL5a/hOuG0JVlO58fACYMxcGi
         hNY9/jUj+gHkx6vTiSnpxmYSRKjZmwQws+wd9ZDCseVjfPUeDN6gYUkvVjFJAsfwHNJg
         9wAg==
X-Gm-Message-State: AOAM531cwPAFTWFenI8iGCMnVGCtump/IyE+bpaXSdwmzfMIBBdy8pfa
        Pq4jqqvi7x6fizYKo1gEKBmkQZlMqm5cUA==
X-Google-Smtp-Source: ABdhPJy9hQzco0LJefQWbyG5+BR0xn1fx01QwMUXd4khytkYvSIwcl0M9RQsMsX/ZvKq/vAph1HcFA==
X-Received: by 2002:a62:6346:0:b029:198:3d33:feb with SMTP id x67-20020a6263460000b02901983d330febmr2738535pfb.8.1607526794672;
        Wed, 09 Dec 2020 07:13:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g33sm2898027pgm.74.2020.12.09.07.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 07:13:13 -0800 (PST)
Message-ID: <5fd0e989.1c69fb81.4994.51da@mx.google.com>
Date:   Wed, 09 Dec 2020 07:13:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.247-34-g5c4e61c1e935
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 124 runs,
 6 regressions (v4.9.247-34-g5c4e61c1e935)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 124 runs, 6 regressions (v4.9.247-34-g5c4e6=
1c1e935)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.247-34-g5c4e61c1e935/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.247-34-g5c4e61c1e935
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5c4e61c1e93588156e79a19b51b19c5f17b14f05 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0b7689af3c572d6c94cc7

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-34-g5c4e61c1e935/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-34-g5c4e61c1e935/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fd0b7689af3c57=
2d6c94ccc
        new failure (last pass: v4.9.247)
        2 lines

    2020-12-09 11:38:50.394000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/119
    2020-12-09 11:38:50.403000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0b58880d2e93207c94ccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-34-g5c4e61c1e935/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-34-g5c4e61c1e935/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0b58880d2e93207c94=
ccc
        failing since 24 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0b6dd0ab157988bc94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-34-g5c4e61c1e935/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-34-g5c4e61c1e935/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0b6dd0ab157988bc94=
cc4
        failing since 24 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0b592865c132995c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-34-g5c4e61c1e935/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-34-g5c4e61c1e935/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0b592865c132995c94=
cba
        failing since 24 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0b5349afe15223ac94ceb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-34-g5c4e61c1e935/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-34-g5c4e61c1e935/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0b5349afe15223ac94=
cec
        failing since 24 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0b5bf28e8524b6ac94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-34-g5c4e61c1e935/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-34-g5c4e61c1e935/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0b5bf28e8524b6ac94=
ccb
        failing since 21 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
