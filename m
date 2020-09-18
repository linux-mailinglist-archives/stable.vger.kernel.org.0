Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6316026EA5F
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 03:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgIRBQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 21:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgIRBQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 21:16:42 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1882C06174A
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 18:16:42 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id y1so2444328pgk.8
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 18:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c//KXuLrmnjcdYdUSSJhMm/vbrWch+QSR67q3X5oLNk=;
        b=JW50dEcbyyihx8i1nCIwLLHgyzft+hnHk5YO8PKmE5KYSuxqIrBdtgvATa8EuWpuy2
         b5FNtcyCiJsQo738Y0Vh0/EYNPFylVnAZroTHpxO3ZcTRPUHnOBVg4oqyE7famvgAXc5
         gVQntiXdZawYE/AhrXlGeG8AfuUvGZ7ykQoNTz27ZhGwt61ZTxS9/PigHOEEFe93cAwC
         JuSk47cNDLBRJZCa9WyvPSMgli6uoUbfY4+fOgdVFvF4X6yZd5Pgp3f8CNHLqyOcwsq9
         zYHvN5ba2jgdMuhoQxE0k3Ff9jKLb3kpGRxGrv8NebjMbwHN1E8gDoZqbhzWrrCc1Sqz
         M5Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c//KXuLrmnjcdYdUSSJhMm/vbrWch+QSR67q3X5oLNk=;
        b=Y5v2gnG1rku+/lXiaG5cYTsar/aaQCudjyqFJmkBLco2OhrZ6CP12PHxXZTSj0mj+p
         rF9C+IfxnloijEq4aO1xT4T+3KsjUcCDCpZH6dni3qG64w7Rd5CnL9S7O5qwC4JfCL01
         yWEdTQAbCeF914yaHzx5n6X+ykc3AU3HLURmTaMtLbQCQq8bgfT/29Fgepb0MYdLKzvd
         Bf2ciTLT6LMBmM/CCk87720jAlkPY3swwHXf/j7AJP0lDqowaVKOw4G8rbOHkPOJPjQ7
         VglcN/02MGiYAiwiHIeIbBjYB7MQMTo+/w6TIDdQgw1lFw7+tYCOxw4wuGhqfMW1I7kz
         DicA==
X-Gm-Message-State: AOAM531Kpex1J7bdTE6yvIw7or3cerVyvgZaI4fmq3Ek5oLC4KM6dzs8
        oeUhqE0Z/PrNtar4Y8+gqWzn5sqEvDVHWw==
X-Google-Smtp-Source: ABdhPJyI36OOL5gOQY9+bAcejkMAGH6V249jIlObDz7/LJGd+nC5BUKZeALSnQSJ2DRmAdVdq4K5Tg==
X-Received: by 2002:aa7:8197:0:b029:142:2501:3981 with SMTP id g23-20020aa781970000b029014225013981mr13602192pfi.70.1600391801737;
        Thu, 17 Sep 2020 18:16:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m21sm894095pfo.13.2020.09.17.18.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 18:16:41 -0700 (PDT)
Message-ID: <5f640a79.1c69fb81.e6908.2ac2@mx.google.com>
Date:   Thu, 17 Sep 2020 18:16:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Kernel: v4.4.236-28-g753a2b628a72
Subject: stable-rc/queue/4.4 baseline: 111 runs,
 3 regressions (v4.4.236-28-g753a2b628a72)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 111 runs, 3 regressions (v4.4.236-28-g753a2b6=
28a72)

Regressions Summary
-------------------

platform   | arch | lab           | compiler | defconfig           | results
-----------+------+---------------+----------+---------------------+--------
beagle-xm  | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 1/4    =

odroid-xu3 | arm  | lab-collabora | gcc-8    | exynos_defconfig    | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.236-28-g753a2b628a72/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.236-28-g753a2b628a72
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      753a2b628a72795170d32ed7120a4382e2e98b80 =



Test Regressions
---------------- =



platform   | arch | lab           | compiler | defconfig           | results
-----------+------+---------------+----------+---------------------+--------
beagle-xm  | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:     https://kernelci.org/test/plan/id/5f63d8948abe4faa3bbf9df4

  Results:     1 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.236-2=
8-g753a2b628a72/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.236-2=
8-g753a2b628a72/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f63d8948abe4faa=
3bbf9df8
      new failure (last pass: v4.4.236-28-gd232545e8fcc)
      1 lines

    2020-09-17 21:41:57.881000  Connected to omap3-beagle-xm console [chann=
el connected] (~$quit to exit)
    2020-09-17 21:41:57.881000  (user:khilman) is already connected
    2020-09-17 21:41:57.882000  (user:) is already connected
    2020-09-17 21:42:09.507000  =00
    2020-09-17 21:42:09.513000  U-Boot SPL 2018.09-rc2-00001-ge6aa9785acb2 =
(Aug 15 2018 - 09:41:52 -0700)
    2020-09-17 21:42:09.517000  Trying to boot from MMC1
    2020-09-17 21:42:09.707000  spl_load_image_fat_os: error reading image =
args, err - -2
    2020-09-17 21:42:09.947000  =

    2020-09-17 21:42:09.947000  =

    2020-09-17 21:42:09.954000  U-Boot 2018.09-rc2-00001-ge6aa9785acb2 (Aug=
 15 2018 - 09:41:52 -0700)
    ... (448 line(s) more)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f63d8948abe=
4faa3bbf9dfa
      new failure (last pass: v4.4.236-28-gd232545e8fcc)
      28 lines

    2020-09-17 21:43:43.463000  kern  :emerg : Stack: (0xcb9afd10 to 0xcb9b=
0000)
    2020-09-17 21:43:43.471000  kern  :emerg : fd00:                       =
              bf02b8fc bf010b84 cb99ec10 bf02b988
    2020-09-17 21:43:43.479000  kern  :emerg : fd20: cb99ec10 bf22e0a8 0000=
0002 cb8ac010 cb99ec10 bf24fb54 cbcba510 cbcba510
    2020-09-17 21:43:43.487000  kern  :emerg : fd40: 00000000 00000000 ce22=
8930 c01fb390 ce228930 ce228930 c08595ac 00000001
    2020-09-17 21:43:43.496000  kern  :emerg : fd60: ce228930 cbcba510 cbcb=
a5d0 00000000 ce228930 c08595ac 00000001 c09632c0
    2020-09-17 21:43:43.504000  kern  :emerg : fd80: ffffffed bf253ff4 ffff=
fdfb 00000028 00000001 c00ce2e4 bf254188 c0406ee0
    2020-09-17 21:43:43.512000  kern  :emerg : fda0: c09632c0 c120ea30 bf25=
3ff4 00000000 00000028 c04053b4 c09632c0 c09632f4
    2020-09-17 21:43:43.520000  kern  :emerg : fdc0: bf253ff4 00000000 0000=
0000 c040555c 00000000 bf253ff4 c04054d0 c0403880
    2020-09-17 21:43:43.528000  kern  :emerg : fde0: ce0b08a4 ce221910 bf25=
3ff4 cbbe02c0 c09ddba8 c04049cc bf252b6c c0960460
    2020-09-17 21:43:43.536000  kern  :emerg : fe00: cbce9780 bf253ff4 c096=
0460 cbce9780 bf257000 c0405f94 c0960460 c0960460
    ... (16 line(s) more)
      =



platform   | arch | lab           | compiler | defconfig           | results
-----------+------+---------------+----------+---------------------+--------
odroid-xu3 | arm  | lab-collabora | gcc-8    | exynos_defconfig    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f63ebaab44ffdba04bf9db3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.236-2=
8-g753a2b628a72/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-odroid-xu=
3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.236-2=
8-g753a2b628a72/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-odroid-xu=
3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f63ebaab44ffdba04bf9=
db4
      new failure (last pass: v4.4.236-28-gd232545e8fcc)  =20
