Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F823EBB8F
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 19:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhHMRjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 13:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhHMRjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 13:39:23 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B488C061756
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 10:38:56 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id qe12-20020a17090b4f8c00b00179321cbae7so6379670pjb.2
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 10:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NZGyar/K64VU5oVsIFUTbF6F7eKWYEMV1PTIq3wxwRw=;
        b=TJRaKqRpTr8FW3z9EbDVfK6E7TLPQWl0hjncI5Bphr2NhFjf+p27oh0t/TMuIt8kXN
         WScD9tYa7nV9CERqQNSxv1EWB5nANV9W/Wj3hhJgX+l8U1QbCtWYct8H7+QFKsAQ0AAB
         uPA5Eg7Nw6Cj/FOJgBeGdGMRs2EMNWQ2nk/y6oke4vsrShpm4THdMIhncFUoXoMoQLJK
         n8Q38EFR6Ngd9PwudXycd7ycA4j1BSxpmB566MT9wfutYDQKv6a/UUQsv7o7gmoe5NVN
         5s9DvxuKbMfabjzf6ys9sSQ3eZgEANFP5IASrXt4XUTT0FDVoZGWdl8JOXTPvPvfUYum
         c03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NZGyar/K64VU5oVsIFUTbF6F7eKWYEMV1PTIq3wxwRw=;
        b=dgFww/7s/i1TUE59YV4jdSTq3YDHPJYpgzaC+6KW6x6Spp3B34YorKZz5Y9n1gtTkR
         tBqoUgFOwvWJJ+6qsLV1dbqsrBYsQWGhwu33tI9yCToc3MHoeytFN65fkff0ldjHVVNh
         YuJE8RmCAAJdCg7pFU7XaJYAY07aEyoabUXX5Vlru5dMvcwDABuVlTKtGYaYW6OqRSG2
         n9uezXqRL6ZVlcRj1xsfflB1myYnO9jasVmZv8X03NzsMOfT0LT5uGNj9xIWeqhTnG+x
         AR+uYPZPz0HkKGVOULctRM6rrWSc1+lgzDzVKj6GovG87Qlko8hG8nkdfmmg93Yctub4
         BMSA==
X-Gm-Message-State: AOAM531T46R/MPB7rjHgp+PPDgkSk39Z/DN/3vu82GpjwBiguzhUCVQ4
        rUHRJgO6ljepjvnZYCqeoCdZqpmM7sLHUdXT
X-Google-Smtp-Source: ABdhPJwgxFzRfdD1Ywu4StktR9qaoOvaiZG1jwM2PuEn51jOlGdi08ZDUkf1k6OPBPDwUlMmPcDFnA==
X-Received: by 2002:a17:90b:312:: with SMTP id ay18mr3682653pjb.144.1628876335570;
        Fri, 13 Aug 2021 10:38:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h24sm3013532pfn.180.2021.08.13.10.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 10:38:55 -0700 (PDT)
Message-ID: <6116ae2f.1c69fb81.409c1.7068@mx.google.com>
Date:   Fri, 13 Aug 2021 10:38:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.279-37-g88568359f5e3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 91 runs,
 9 regressions (v4.4.279-37-g88568359f5e3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 91 runs, 9 regressions (v4.4.279-37-g88568359=
f5e3)

Regressions Summary
-------------------

platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
dove-cubox          | arm    | lab-pengutronix | gcc-8    | mvebu_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_i386           | i386   | lab-broonie     | gcc-8    | i386_defconfig =
              | 1          =

qemu_x86_64         | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon..=
.6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.279-37-g88568359f5e3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.279-37-g88568359f5e3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      88568359f5e386de7e2a62f23f0c817a9b281b53 =



Test Regressions
---------------- =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
dove-cubox          | arm    | lab-pengutronix | gcc-8    | mvebu_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/61167a459b2888addfb13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-3=
7-g88568359f5e3/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-=
cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-3=
7-g88568359f5e3/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-=
cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61167a459b2888addfb13=
662
        failing since 0 day (last pass: v4.4.279-34-g9d38276e9859, first fa=
il: v4.4.279-34-g734b6f166fd0) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/61167a69feaac24975b13682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-3=
7-g88568359f5e3/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-3=
7-g88568359f5e3/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61167a69feaac24975b13=
683
        failing since 272 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/61167a911894f131dfb1366e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-3=
7-g88568359f5e3/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-3=
7-g88568359f5e3/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61167a911894f131dfb13=
66f
        failing since 272 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6116850ef6f195d091b13682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-3=
7-g88568359f5e3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-3=
7-g88568359f5e3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6116850ef6f195d091b13=
683
        failing since 272 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/61167a6aaf8dc197dab13678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-3=
7-g88568359f5e3/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-3=
7-g88568359f5e3/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61167a6aaf8dc197dab13=
679
        failing since 272 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/61167b3108d82c6af0b137aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-3=
7-g88568359f5e3/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-3=
7-g88568359f5e3/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61167b3108d82c6af0b13=
7ab
        failing since 272 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/61168591f0ba277205b13666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-3=
7-g88568359f5e3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-3=
7-g88568359f5e3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61168591f0ba277205b13=
667
        failing since 272 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_i386           | i386   | lab-broonie     | gcc-8    | i386_defconfig =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/61167b8171ace8b438b13666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-3=
7-g88568359f5e3/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-3=
7-g88568359f5e3/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61167b8171ace8b438b13=
667
        new failure (last pass: v4.4.279-34-g734b6f166fd0) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_x86_64         | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6116797b6835d524b3b1366f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-3=
7-g88568359f5e3/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-3=
7-g88568359f5e3/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6116797b6835d524b3b13=
670
        new failure (last pass: v4.4.279-34-g734b6f166fd0) =

 =20
