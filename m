Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616A63FDDF7
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 16:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhIAOsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 10:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbhIAOsd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 10:48:33 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC6DC0613D9
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 07:47:35 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id n18so2986379pgm.12
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 07:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JAVoJtD636NVX4DjCamua1wVeOs/MXJpiGYGxnuKSzQ=;
        b=UiyPBTQxbDzohUuYX0mlrKVUqBCHrM0SyrwaTQoameyi513Jr+i4qM9lLlY2Tuub7x
         6c2IBqG6d8Pby0G5MEh5kz6d5g4M/N1WBM72CkvYjfLBGNtWAzr/ZAQj+fg74wkCddGU
         59TU1nwf6A0tc42VDOMK+WkOtEsxuUP4CIX7CS+pjnO/I+T2swGEsE89dLmrQyNMuJAa
         VViASvryAAXplFK5LXKtMYhGfo5pG7/FC59GzUkGxBiTDcDH+AFRWWnW41Hh5FEgekhE
         VA4kliihKnCzoSu3mN6teBMi6+HuaSJc/Z4L2M0SrUdUOHY7rBLrwE4pCDY71IhC16k+
         gHDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JAVoJtD636NVX4DjCamua1wVeOs/MXJpiGYGxnuKSzQ=;
        b=AmuYr3CTdi1suSpTPbYKn3ZAT8a2UuQDGGcYpAzpTCusalrTeJSmaBlLgzTDm5Uui3
         /IClQxwtvR/JbmLFEHWere7OrkvZ17v0zsHFEaSMz7tCGV1kccQr4zM8alFKFu7/SE9+
         etcQDuNoQNPRjOPFVt0qJILy5Vm2HW5EhSg6kENj8D7MZIrHRZZVxTtMr93hLhnYgh/+
         jW0gi8sx6eJ73vqZpyyyiWWi38SGJIfZskWpyqib2CX7mUI/amn33IadQTd8Nt4Nk/vA
         R+HVZzEwAy5mHo3UzgcxbdRSTZS8fupDwwD8IIL9JdAXsk/I8zmfZOrEdD2EdH3fgOpL
         JXDw==
X-Gm-Message-State: AOAM531HM8rr7BVkcN2rowrBQ+iLK2A6561cMvRFeSrGsFOk94Y5K/tu
        6CPKsmZSviskwmycpsBEesqI0/VoNUyQDFD3fsE=
X-Google-Smtp-Source: ABdhPJwV283uWlBeCa5jmRrkrb4iXtrHs7m+FB1IRdeB+FsqPYipMvdU0WOI+AOPUQhr7YyaPIQBQw==
X-Received: by 2002:a63:2bc5:: with SMTP id r188mr32444401pgr.179.1630507655075;
        Wed, 01 Sep 2021 07:47:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w11sm28898pgf.5.2021.09.01.07.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 07:47:34 -0700 (PDT)
Message-ID: <612f9286.1c69fb81.1854b.015b@mx.google.com>
Date:   Wed, 01 Sep 2021 07:47:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.61-100-g568e40c72849
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 174 runs,
 3 regressions (v5.10.61-100-g568e40c72849)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 174 runs, 3 regressions (v5.10.61-100-g568e4=
0c72849)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =

r8a77950-salvator-x      | arm64 | lab-baylibre | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.61-100-g568e40c72849/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.61-100-g568e40c72849
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      568e40c72849a1a540bf189e00b618716737232c =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/612f602480721a16738e2ca5

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
100-g568e40c72849/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
100-g568e40c72849/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/612f602480721a1=
6738e2cac
        new failure (last pass: v5.10.61-70-g66c70ebfc197)
        4 lines

    2021-09-01T11:12:17.988422  kern  :alert : 8<--- cut here ---
    2021-09-01T11:12:18.024511  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000313
    2021-09-01T11:12:18.025054  kern  :alert : pgd =3D 9e45a326<8>[   14.86=
8586] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>
    2021-09-01T11:12:18.025301     =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/612f602480721a1=
6738e2cad
        new failure (last pass: v5.10.61-70-g66c70ebfc197)
        47 lines

    2021-09-01T11:12:18.026595  kern  :alert : [00000313] *pgd=3D00000000
    2021-09-01T11:12:18.075663  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2021-09-01T11:12:18.076206  kern  :emerg : Process kworker/0:2 (pid: 51=
, stack limit =3D 0xf8b9d661)
    2021-09-01T11:12:18.076456  kern  :emerg : Stack: (0xc240dd50 to 0xc240=
e000)
    2021-09-01T11:12:18.076686  kern  :emerg : dd40:                       =
              c34625b0 c34625b4 c3462400 c3462414
    2021-09-01T11:12:18.077149  kern  :emerg : dd60: c144aca4 c09c71fc c240=
c000 ef8714e0 8020001c c3462400 000002f3 17f82514
    2021-09-01T11:12:18.077625  kern  :emerg : dd80: c19c78b4 c2001d80 c3ae=
f480 ef86dde0 c09d4954 c144aca4 c19c7898 17f82514
    2021-09-01T11:12:18.118734  kern  :emerg : dda0: c19c78b4 c3ca7f80 c3ad=
8e00 c3462400 c3462414 c144aca4 c19c7898 0000000c
    2021-09-01T11:12:18.119253  kern  :emerg : ddc0: c19c78b4 c09d4924 c144=
89cc 00000000 c346240c c3462400 fffffdfb c2298c10
    2021-09-01T11:12:18.119500  kern  :emerg : dde0: c3a14f40 c09aa844 c346=
2400 bf048000 fffffdfb bf044138 c3ca5c40 c3bb2708 =

    ... (39 line(s) more)  =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
r8a77950-salvator-x      | arm64 | lab-baylibre | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/612f6255e9e29f34598e2c9e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
100-g568e40c72849/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
100-g568e40c72849/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612f6255e9e29f34598e2=
c9f
        new failure (last pass: v5.10.61-70-g66c70ebfc197) =

 =20
