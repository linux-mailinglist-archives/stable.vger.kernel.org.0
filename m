Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCE126E54C
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 21:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgIQTTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 15:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgIQTRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 15:17:44 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0A5C06174A
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 12:17:44 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id x123so1839314pfc.7
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 12:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xn6tCGxb3v5Xq5HzZ3ooYctE8NCgYd+c0JVso3gpGh0=;
        b=kAw+5CxHPM98LGP+jOc/ErYMVWv3YNIM/fF6Wss3RBYHTvrexSqvuqVWr7n+wVLHS+
         dKRqkyjOvhCg+I9mg574m2HK+a+vq72z8PeaeXh/co7hmd/ErC7xRrqdCzamGSj/wvbQ
         I5hK/5Zu0jj7CKl6T5XoB0Eh6DIpU4uiZDjTuymWc7MUSlqVJJZQRGQpD3H/R2E7B533
         I372t6f3dTGt/XjJspi0rWD18DUwY1RtHPV6adLk5aoxccuKukQiDRtFf06oZ24XwkLj
         LGz7vr9DzfrZsVrK8i5iET2LSpHR0p7fU1C4obIb/nHyeVNfcPfhI6YaPc3xreFFW4ob
         l5Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xn6tCGxb3v5Xq5HzZ3ooYctE8NCgYd+c0JVso3gpGh0=;
        b=VF6K6q4LexOYYwWOQXGIF4w+JVNw/wKXTZw+alrWyOPQHlyP/7HFYOcpDKDHIkCWaj
         8O/6sh9Ua3trt7fgLsJ51Zs+f8gENK8lHXSx/xHgCvazTb5Ppee+aPPzdapIIlMUFKrn
         t88BnYrNWWEZ8e2CGsdcyZGirtDN1l6cc4iKOb/Pc/4BIDXK+fw4L/uoNvvAcNbzxvee
         vzFpsf+8Jh6Y5QfWNFudVEll8fsRluEIRimBoUB1NAtqOy2J1vbS36Kc4g1eYJbdGYSL
         MoGqbC4eKFjTO8gfzl7R6GKNAkxRDITBAiGqATJ+O/sudGmYdsWUM+cHx1ESPhLNzRCU
         NH9A==
X-Gm-Message-State: AOAM532khxthBueJNijvMLNtaEDnS0ZI/MpH/v4/ZLZtlGDV1iBhJE4U
        cXxCmOQI/BcjO96DzFU42QAWtpEcDeRkTw==
X-Google-Smtp-Source: ABdhPJyHVnDjTelW6DX0+im9Oup6l7+vfaqgc9Oky3n368/RZ57CDQXGnCoBDQA6qyVFAYKr8XX9EA==
X-Received: by 2002:a63:725d:: with SMTP id c29mr969824pgn.234.1600370263213;
        Thu, 17 Sep 2020 12:17:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id hk17sm392227pjb.14.2020.09.17.12.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 12:17:42 -0700 (PDT)
Message-ID: <5f63b656.1c69fb81.6cbba.0d1f@mx.google.com>
Date:   Thu, 17 Sep 2020 12:17:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
X-Kernelci-Kernel: v5.8.9-176-g68ffab81c30e
Subject: stable-rc/queue/5.8 baseline: 175 runs,
 4 regressions (v5.8.9-176-g68ffab81c30e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 175 runs, 4 regressions (v5.8.9-176-g68ffab81=
c30e)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | results
-------------------------+------+--------------+----------+----------------=
----+--------
bcm2837-rpi-3-b-32       | arm  | lab-baylibre | gcc-8    | bcm2835_defconf=
ig  | 2/4    =

imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 2/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.9-176-g68ffab81c30e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.9-176-g68ffab81c30e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      68ffab81c30ed2c39101bc7338f909b2af23170a =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | results
-------------------------+------+--------------+----------+----------------=
----+--------
bcm2837-rpi-3-b-32       | arm  | lab-baylibre | gcc-8    | bcm2835_defconf=
ig  | 2/4    =


  Details:     https://kernelci.org/test/plan/id/5f6380a7f76799ffe8bf9dd2

  Results:     2 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.9-176=
-g68ffab81c30e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.9-176=
-g68ffab81c30e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5f6380a7f76799f=
fe8bf9dd7
      new failure (last pass: v5.8.9-176-g2e4dee5d02d0)
      4 lines

    2020-09-17 15:28:27.540000  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000387
    2020-09-17 15:28:27.541000  kern  :alert : pgd =3D cbfa4793
    2020-09-17 15:28:27.542000  kern  :alert : [00000387] *pgd=3D04195835, =
*pte=3D00000000, *ppte=3D00000000
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f6380a7f767=
99ffe8bf9dd8
      new failure (last pass: v5.8.9-176-g2e4dee5d02d0)
      51 lines

    2020-09-17 15:28:27.545000  kern  :emerg : Process udevd (pid: 88, stac=
k limit =3D 0xc95cc351)
    2020-09-17 15:28:27.545000  kern  :emerg : Stack: (0xc417fd18 to 0xc418=
0000)
    2020-09-17 15:28:27.583000  kern  :emerg : fd00:                       =
                                c417fd54 c417fd28
    2020-09-17 15:28:27.584000  kern  :emerg : fd20: c024e6a4 c024d3f0 e88f=
e870 a0fea6f7 c417fe60 c417fe60 ea500042 00000002
    2020-09-17 15:28:27.585000  kern  :emerg : fd40: c0e04248 e88ec7f8 c417=
fd94 c417fd58 c024f20c c024e580 e88fe870 00000001
    2020-09-17 15:28:27.586000  kern  :emerg : fd60: 00000000 c68312d7 c417=
fd94 a0fea6f7 00000000 c417fe60 ea500042 b2d79a25
    2020-09-17 15:28:27.587000  kern  :emerg : fd80: 00000000 e88ec7f8 c417=
fdec c417fd98 c024f548 c024f184 c024d3ac d5679194
    2020-09-17 15:28:27.627000  kern  :emerg : fda0: 00000008 c0e04248 c417=
fdec c417fdb8 c024ffb0 c024d314 c417fdec a0fea6f7
    2020-09-17 15:28:27.629000  kern  :emerg : fdc0: c0244040 c417fe60 ea50=
0010 c422a540 00000001 c417ff18 befda1a8 00000142
    2020-09-17 15:28:27.629000  kern  :emerg : fde0: c417fe5c c417fdf0 c025=
1564 c024f2b0 c0243384 c0e04248 c417febc 00000010
    ... (40 line(s) more)
      =



platform                 | arch | lab          | compiler | defconfig      =
    | results
-------------------------+------+--------------+----------+----------------=
----+--------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 2/4    =


  Details:     https://kernelci.org/test/plan/id/5f6385fda111845be2bf9dd2

  Results:     2 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.9-176=
-g68ffab81c30e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var=
-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.9-176=
-g68ffab81c30e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var=
-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5f6385fda111845=
be2bf9dd7
      new failure (last pass: v5.8.9-176-g2e4dee5d02d0)
      4 lines

    2020-09-17 15:51:18.671000  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2020-09-17 15:51:18.672000  kern  :alert : pgd =3D (ptrval)
    2020-09-17 15:51:18.672000  kern  :alert : [cec60217] *pgd=3D1ec1141e(b=
ad)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f6385fda111=
845be2bf9dd8
      new failure (last pass: v5.8.9-176-g2e4dee5d02d0)
      26 lines

    2020-09-17 15:51:18.714000  kern  :emerg : Process kworker/1:1 (pid: 54=
, stack limit =3D 0x(ptrval))
    2020-09-17 15:51:18.715000  kern  :emerg : Stack: (0xeeba3eb0 to 0xeeba=
4000)
    2020-09-17 15:51:18.715000  kern  :emerg : 3ea0:                       =
              1e9b10fe 85294481 eeba2000 cec60217
    2020-09-17 15:51:18.715000  kern  :emerg : 3ec0: 00000000 00000000 0000=
0003 00000000 00000000 85294481 cec6020f ed0fe040
    2020-09-17 15:51:18.716000  kern  :emerg : 3ee0: ed0fe094 cec6008f 0000=
0000 c098f194 fffffc90 fffffc90 ed3aec00 ef7ad400
    2020-09-17 15:51:18.757000  kern  :emerg : 3f00: 00000000 c19b7570 0000=
0000 c098f368 ed3aeda0 ee944080 ef7aa200 c0361c54
    2020-09-17 15:51:18.758000  kern  :emerg : 3f20: eeb98600 ef7aa200 0000=
0008 ee944080 ee944094 ef7aa200 00000008 c1803d00
    2020-09-17 15:51:18.758000  kern  :emerg : 3f40: ef7aa218 ef7aa200 ffff=
e000 c0362238 eeb98600 c19b6d8f c13737b0 c0361f90
    2020-09-17 15:51:18.758000  kern  :emerg : 3f60: ee944080 ee8c9540 ee8c=
9580 00000000 eeba2000 c0361f90 ee944080 ee915ea4
    2020-09-17 15:51:18.759000  kern  :emerg : 3f80: ee8c9564 c0368624 0000=
0001 ee8c9580 c03684d4 00000000 00000000 00000000
    ... (15 line(s) more)
      =20
