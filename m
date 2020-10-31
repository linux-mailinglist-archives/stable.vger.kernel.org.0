Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566D22A17FA
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 14:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbgJaNxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 09:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727461AbgJaNxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 09:53:01 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61490C0617A6
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 06:53:01 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 72so767102pfv.7
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 06:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wuI9NmqGNHhBGluWZus45+z36agnPy9MfNCp4mHVyZI=;
        b=bnN5f2JOvH+cB1L/Lknv9nfdyLcSP/mGYRVFnls8awtu1iZHCd5JmWwrtS4SvgJJv9
         I3U8WDVM9lRc6960MGxLaubHi/b8PiBeyI8bra9pxdT9XcKGh/skVSb+Prt4QzIs28dJ
         dZQ8TyyhK/MwABVrAH6FDOVvRws5bIU2be0znthnH02KIXTaBn7im3LyMbZ4oXO0W3xK
         bBOXniHAKoPrB2+fsob1i1m5KWPHkcUQ9iUILMoPU0EYcIhtVQhc2UonKYltA7waZI5H
         AdiF2/FaeDCa+gPV6q4pCwIvuz/6XSQtXMlWI+zfAjKd0MiGOp/97cjny1hracX3+H1J
         HzgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wuI9NmqGNHhBGluWZus45+z36agnPy9MfNCp4mHVyZI=;
        b=sZvGuHEFS2tE28VyT3MziGJKvFkvFnALnxsLylw00HbQEkO2PBRgdVcz44a1DXF9Ya
         MjWANoT1/y+nEsbgf1aqRkTXGZYOInJUnYeMID5b589FlYKbdJtJ6ZDpJ5ESNgZb9V/c
         r0zM+KUTUEkrIEOY4BVeZ0yuNPmLiL0DDxYG+TJYGYO1emZIP9jiD/OpK2GiqbRiweA6
         yY61pHRcL+ikUPYGTRFl1pgVYEXmOFtipsRl+YQki3HUVuKFwMgp2TYIKO4yMOiQaMNO
         1V2CWZ9gO6nu9xh5zycQtzSCFzSYGl0v5eBmmzRAHXWWSC6P7he0fMG44HbbZsGUDEVC
         2nmA==
X-Gm-Message-State: AOAM530ThqBrCfWyIP74Q3n9FntxKmr7n7g07aq/OIomX1zccsFaXGh5
        RvfJbqyJ7JmbICg3qPEtnUCh1ibiFMk9aw==
X-Google-Smtp-Source: ABdhPJyz9VZCfpF1YIaRQSwraudHsYulJyaR+VMMSlMhPQ38WY/FzRHozBOmlaH+X+6WaqaVc6wMeg==
X-Received: by 2002:a63:5152:: with SMTP id r18mr6107580pgl.381.1604152380478;
        Sat, 31 Oct 2020 06:53:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l18sm8982539pfd.210.2020.10.31.06.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 06:52:59 -0700 (PDT)
Message-ID: <5f9d6c3b.1c69fb81.231ac.5c62@mx.google.com>
Date:   Sat, 31 Oct 2020 06:52:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.17-48-ge9fb604dafdf
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 192 runs,
 4 regressions (v5.8.17-48-ge9fb604dafdf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 192 runs, 4 regressions (v5.8.17-48-ge9fb604d=
afdf)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig  |=
 2          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig          |=
 1          =

stm32mp157c-dk2    | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.17-48-ge9fb604dafdf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.17-48-ge9fb604dafdf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e9fb604dafdf20c494380812d10fa08e58d8d9e3 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig  |=
 2          =


  Details:     https://kernelci.org/test/plan/id/5f9d3803ccef549a1b3fe7fa

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-48=
-ge9fb604dafdf/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-48=
-ge9fb604dafdf/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5f9d3803ccef549=
a1b3fe800
        new failure (last pass: v5.8.17-26-gabb7089aa00f)
        4 lines

    2020-10-31 10:09:59.574000+00:00  kern  :alert : pgd =3D 42d6e7f6
    2020-10-31 10:09:59.575000+00:00  kern  :alert : [40e9a350] *pgd=3D0000=
0000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9d3803ccef549=
a1b3fe801
        new failure (last pass: v5.8.17-26-gabb7089aa00f)
        63 lines

    2020-10-31 10:09:59.617000+00:00  kern  :emerg : Process sh (pid: 124, =
stack limit =3D 0x812a30ca)
    2020-10-31 10:09:59.619000+00:00  kern  :emerg : Stack: (0xc43d5d08 to =
0xc43d6000)
    2020-10-31 10:09:59.619000+00:00  kern  :emerg : 5d00:                 =
  c43d5d2c c43d5d18 c01f3964 c01f36e8 eaa19240 60000094
    2020-10-31 10:09:59.620000+00:00  kern  :emerg : 5d20: c43d5d54 c43d5d3=
0 c01f40a8 c01f3944 60000013 c0e24978 00000001 c0e997ac
    2020-10-31 10:09:59.621000+00:00  kern  :emerg : 5d40: c01f3f7c 0000000=
0 c43d5d84 c43d5d58 c01f46e0 c01f3f88 00000009 c0e24938
    2020-10-31 10:09:59.660000+00:00  kern  :emerg : 5d60: c429e000 c0e0424=
8 00000000 c429e1c0 c429e000 c429e000 c43d5d94 c43d5d88
    2020-10-31 10:09:59.662000+00:00  kern  :emerg : 5d80: c01f4ddc c01f465=
8 c43d5dac c43d5d98 c01f4f34 c01f4dc8 c4333060 c429e000
    2020-10-31 10:09:59.662000+00:00  kern  :emerg : 5da0: c43d5dbc c43d5db=
0 c01f4fe0 c01f4f14 c43d5e24 c43d5dc0 c0218ee4 c01f4fd0
    2020-10-31 10:09:59.663000+00:00  kern  :emerg : 5dc0: 00000000 0000000=
0 c43d5dfc c43d5dd8 c0385820 c03856f4 00000000 c011adf4
    2020-10-31 10:09:59.664000+00:00  kern  :emerg : 5de0: c0e23528 c429e00=
0 c43d5e0c c43d5df8 c08766a8 ad53453a 00000000 c429e000 =

    ... (52 line(s) more)  =

 =



platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5f9d36e7b15097cd823fe7ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-48=
-ge9fb604dafdf/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-48=
-ge9fb604dafdf/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9d36e7b15097cd823fe=
7f0
        failing since 1 day (last pass: v5.8.16-658-gc32c23a5a4dd, first fa=
il: v5.8.17-26-g4cd0eaef7939) =

 =



platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
stm32mp157c-dk2    | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5f9d3b32e83f04194d3fe7e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-48=
-ge9fb604dafdf/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-48=
-ge9fb604dafdf/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9d3b32e83f04194d3fe=
7e3
        failing since 5 days (last pass: v5.8.16-78-g480e444094c4, first fa=
il: v5.8.16-626-g41d0d5713799) =

 =20
