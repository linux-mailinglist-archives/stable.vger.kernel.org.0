Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B918282BE3
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 19:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgJDRGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 13:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgJDRGm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 13:06:42 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103E9C0613CE
        for <stable@vger.kernel.org>; Sun,  4 Oct 2020 10:06:41 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id y14so1687914pfp.13
        for <stable@vger.kernel.org>; Sun, 04 Oct 2020 10:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=euzlAbABqpBXkrbwfmvMWYPiA0EdtY+rbZ0JrZ230VY=;
        b=qW6asP1gcOPZ6sLMBWExEEmA3ssgD4+H152+f3LT19qXunrxPlQdA3XhfZGiRjFINa
         7cNs05XuxZCc/UjioNepFJaxxpTP044K5F6gnhWwhx+bnnAc16RojVe6QP9fL4MQEb3C
         0SeAwQwgIp7w+WN7+dE6bKDvFv08dqi3plcISDw9MUuEv9bUqSgzeCp6nG2BU5AjuXZj
         7+dhrRe11ItIyH/CDzBnXcUMBFlRqqZNJnYlnF0S9m/W6irDwurdRs/dgUI4+YFOl4jH
         QUGuN+X3m1ktAEJQbaWOuAgbBIY07S/LB1oxXCLcx5hte3BeHeLeFLmnhDtH7fRFWlMD
         h8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=euzlAbABqpBXkrbwfmvMWYPiA0EdtY+rbZ0JrZ230VY=;
        b=nUzG+BRXSmpJUJmoBYFzIjs3fKRnS/UTEv1Mzs3cci4iWiGa0KU3eLB5rqydi+svS3
         A30z8WSlPrkjxsoDrzvbit9EBt+ltsghghAjumeAhourtTztq3Es0J+UZQAHTGYBMURf
         qVr2dJVxsYZXmVkDRYopHyC/7EqsJlM0xajPGxQXz3VxDQ9AwD4I4+91hm3yuY1qM+Bg
         OXR43NCq1SjzbWp3fAPbVGs9WUxtI4IY5W4GNoN1U3A6FyCeBsMlBbkgU2S8Nh4yq4BD
         Ogs2pezJOHd+6AYYkFhH8RtMHqV2BXMgIPKK6E07r7Ptoy6qyRej9zGmLfsNJ5SUIj/F
         km3A==
X-Gm-Message-State: AOAM5317hP5zksWhZK7WU/q4GzjfqigNtaLHKnmBWLFL3TBZuVgnnDes
        tJClICleX5ma8Tb4pkCND1UlPgm6rkyCgg==
X-Google-Smtp-Source: ABdhPJymZTRKOjgtZdoRTMRczrF2YdTL9IzWnUMBFRImi6i83cirbTmaKTs5Qn71LMprZfnValNHqg==
X-Received: by 2002:a63:c64d:: with SMTP id x13mr10824611pgg.380.1601831199926;
        Sun, 04 Oct 2020 10:06:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v3sm5448461pju.44.2020.10.04.10.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 10:06:39 -0700 (PDT)
Message-ID: <5f7a011f.1c69fb81.4eb4e.a904@mx.google.com>
Date:   Sun, 04 Oct 2020 10:06:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.238-3-g44c1a5097bba
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 87 runs,
 6 regressions (v4.4.238-3-g44c1a5097bba)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 87 runs, 6 regressions (v4.4.238-3-g44c1a5097=
bba)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | results
----------+------+---------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 1/4    =

panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =

peach-pi  | arm  | lab-collabora | gcc-8    | exynos_defconfig    | 80/132 =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.238-3-g44c1a5097bba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.238-3-g44c1a5097bba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      44c1a5097bbad5cb5a86e30f46e29995d38af7e9 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | results
----------+------+---------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:     https://kernelci.org/test/plan/id/5f79c85145a391b1ef4ff41c

  Results:     1 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-3=
-g44c1a5097bba/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-3=
-g44c1a5097bba/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f79c85145a391b1=
ef4ff420
      new failure (last pass: v4.4.237-85-gcd7b2e899081)
      1 lines

    2020-10-04 13:02:25.660000  Connected to omap3-beagle-xm console [chann=
el connected] (~$quit to exit)
    2020-10-04 13:02:25.660000  (user:khilman) is already connected
    2020-10-04 13:02:37.065000  =00
    2020-10-04 13:02:37.071000  U-Boot SPL 2018.09-rc2-00001-ge6aa9785acb2 =
(Aug 15 2018 - 09:41:52 -0700)
    2020-10-04 13:02:37.076000  Trying to boot from MMC1
    2020-10-04 13:02:37.265000  spl_load_image_fat_os: error reading image =
args, err - -2
    2020-10-04 13:02:37.506000  =

    2020-10-04 13:02:37.506000  =

    2020-10-04 13:02:37.512000  U-Boot 2018.09-rc2-00001-ge6aa9785acb2 (Aug=
 15 2018 - 09:41:52 -0700)
    2020-10-04 13:02:37.512000  =

    ... (447 line(s) more)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f79c85145a3=
91b1ef4ff422
      new failure (last pass: v4.4.237-85-gcd7b2e899081)
      28 lines

    2020-10-04 13:04:11.314000  kern  :emerg : Stack: (0xcb995d10 to 0xcb99=
6000)
    2020-10-04 13:04:11.322000  kern  :emerg : 5d00:                       =
              bf02b8fc bf010b84 cb961010 bf02b988
    2020-10-04 13:04:11.331000  kern  :emerg : 5d20: cb961010 bf2200a8 0000=
0002 cb8a6010 cb961010 bf246b54 cbbfa6f0 cbbfa6f0
    2020-10-04 13:04:11.339000  kern  :emerg : 5d40: 00000000 00000000 ce22=
8930 c01fb3f0 ce228930 ce228930 c0859648 00000001
    2020-10-04 13:04:11.347000  kern  :emerg : 5d60: ce228930 cbbfa6f0 cbbf=
a7b0 00000000 ce228930 c0859648 00000001 c09632c0
    2020-10-04 13:04:11.355000  kern  :emerg : 5d80: ffffffed bf24aff4 ffff=
fdfb 00000027 00000001 c00ce2e4 bf24b188 c0407090
    2020-10-04 13:04:11.364000  kern  :emerg : 5da0: c09632c0 c120ea30 bf24=
aff4 00000000 00000027 c0405564 c09632c0 c09632f4
    2020-10-04 13:04:11.372000  kern  :emerg : 5dc0: bf24aff4 00000000 0000=
0000 c040570c 00000000 bf24aff4 c0405680 c0403a30
    2020-10-04 13:04:11.380000  kern  :emerg : 5de0: ce0b08a4 ce221910 bf24=
aff4 cbbde440 c09ddba8 c0404b7c bf249b6c c0960460
    2020-10-04 13:04:11.388000  kern  :emerg : 5e00: cbcdb200 bf24aff4 c096=
0460 cbcdb200 bf24e000 c0406144 c0960460 c0960460
    ... (16 line(s) more)
      =



platform  | arch | lab           | compiler | defconfig           | results
----------+------+---------------+----------+---------------------+--------
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f79c84445a391b1ef4ff3f8

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-3=
-g44c1a5097bba/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-3=
-g44c1a5097bba/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f79c84445a391b=
1ef4ff3ff
      new failure (last pass: v4.4.237-85-gcd7b2e899081)
      2 lines  =



platform  | arch | lab           | compiler | defconfig           | results
----------+------+---------------+----------+---------------------+--------
peach-pi  | arm  | lab-collabora | gcc-8    | exynos_defconfig    | 80/132 =


  Details:     https://kernelci.org/test/plan/id/5f79c5d28568dad9414ff403

  Results:     80 PASS, 51 FAIL, 1 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-3=
-g44c1a5097bba/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-peach-pi.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-3=
-g44c1a5097bba/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-peach-pi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f79c5d28568dad9=
414ff487
      new failure (last pass: v4.4.237-85-gcd7b2e899081)
      1 lines

    2020-10-04 12:51:44.563000  [Enter `^Ec?' for help]
    2020-10-04 12:52:00.583000  =00
    2020-10-04 12:52:00.584000  =

    2020-10-04 12:52:00.584000  U-Boot 2016.11 (Jan 07 2017 - 15:15:17 +010=
0) for Peach-Pi
    2020-10-04 12:52:00.585000  =

    2020-10-04 12:52:00.585000  CPU:   Exynos5800 @ 1.8 GHz
    2020-10-04 12:52:00.593000  Model: Samsung/Google Peach Pi board based =
on Exynos5800
    2020-10-04 12:52:00.593000  Board: Samsung/Google Peach Pi board based =
on Exynos5800
    2020-10-04 12:52:00.594000  DRAM:  3.5 GiB
    2020-10-04 12:52:00.643000  EXYNOS_TMU: WARNING! Temperature sensing no=
t done
    ... (662 line(s) more)
     * baseline.dmesg.alert: https://kernelci.org/test/case/id/5f79c5d28568=
dad9414ff488
      new failure (last pass: v4.4.237-85-gcd7b2e899081)
      4 lines

    2020-10-04 12:52:43.339000  kern  :alert : pgd =3D c0004000
    2020-10-04 12:52:43.349000  kern  :alert : [ffffffe0] *pgd=3D4fffd861, =
*pte=3D00000000, *ppte=3D00000000
    2020-10-04 12:52:43.350000  kern  :alert : Fixing recursive fault but r=
eboot is needed!
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f79c5d28568=
dad9414ff489
      new failure (last pass: v4.4.237-85-gcd7b2e899081)
      39 lines

    2020-10-04 12:52:43.372000  kern  :emerg : Process irq/146-max9809 (pid=
: 1528, stack limit =3D 0xecc8e210)
    2020-10-04 12:52:43.382000  kern  :emerg : Stack: (0xecc8fec0 to 0xecc9=
0000)
    2020-10-04 12:52:43.383000  kern  :emerg : fec0: ed5fb944 00000014 ed5f=
b944 60000013 00000008 edc78a00 00000014 c0036538
    2020-10-04 12:52:43.394000  kern  :emerg : fee0: 00000000 ed5fb910 ecc7=
9a00 edeb3ca4 edeb3c80 c045568c 00000004 00000004
    2020-10-04 12:52:43.406000  kern  :emerg : ff00: edeb3c80 edead540 0000=
0001 c0067b14 ffffe000 edead540 00000001 c0067e0c
    2020-10-04 12:52:43.417000  kern  :emerg : ff20: 00000000 c0067bf4 edeb=
3c80 00000000 edeb3cc0 ecc8e000 edeb3c80 c0067cc4
    2020-10-04 12:52:43.417000  kern  :emerg : ff40: 00000000 00000000 0000=
0000 c003dd48 00000000 00000000 00000000 edeb3c80
    2020-10-04 12:52:43.427000  kern  :emerg : ff60: 00000000 00000000 dead=
4ead ffffffff ffffffff ecc8ff74 ecc8ff74 00000000
    2020-10-04 12:52:43.438000  kern  :emerg : ff80: 00000000 dead4ead ffff=
ffff ffffffff ecc8ff90 ecc8ff90 edeb3cc0 c003dc40
    2020-10-04 12:52:43.439000  kern  :emerg : ffa0: 00000000 00000000 0000=
0000 c000f650 00000000 00000000 00000000 00000000
    ... (28 line(s) more)
      =20
