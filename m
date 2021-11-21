Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98176458637
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 20:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhKUT6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 14:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhKUT6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Nov 2021 14:58:18 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37873C061574
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 11:55:13 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 8so14196206pfo.4
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 11:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aOoTMe6da63TbvUsrzIcxxgnDvskYDZsvwhynGBBeNg=;
        b=OJMxlyooI3OkufavX6m1NXP9zIeuN52oyI8A+Tfo8mBwjxbXYpBnvtaOXDaB8Wu5At
         SORiY+l0ws7wisEWYvx6sCcIvqBt8PRofva/wJ2RzWoOdU4JNS449/yzSgp3GVvBwWQc
         KlpZDkLWkdcIqkn8I/8FDztRCNyKCYr7sgk+qCN8ev0oSbkp6XnYUqPZVgXqzrKV6yS4
         UxX2ZfpU4e3gNii8pWoOZi/Au+IKRW05/46RFIsolIX5pT0JAR6LnrHEXFijMuijbHPY
         Uj731C3qIs11xOZwNFfQhf5iznEC2rcO7WZumorS/TJqmJITSXOvujuUjCq7EVycA29p
         RyUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aOoTMe6da63TbvUsrzIcxxgnDvskYDZsvwhynGBBeNg=;
        b=5Ya5uT1No402utxyxP+bPNSMM3h3lRp7u7Zc0cpnJi/+NIEBIRvBVZ6pCfOl2lIJBt
         48tcJi1IvkK/lssIxmnQl1j7aP8xTaH0mn9mhZB7WE9hTUd0x5+A4O1UNG006DLAYndv
         5LqTvug7wR2uYxGrPV0OJy41xrt3OC2H2gQsETcDt/2GyNY0OKyzDyeBEMR2uOrOcqcC
         k4nqV8TfkP9efX4EtwEl9asPNvtRKB3PdrhDbrEb1WU4Woal8UT7MWxCJvdwhpEVczOK
         KHJ1oXqk2zD/nBA0q6sKbi2MFMj3ZTzCXO8X0XueBi2736JFIcc8l870HfrLEA53V5Jr
         kiQQ==
X-Gm-Message-State: AOAM530zKWJyClylXQvm0k0qupvso9TR9lAUjmX/OTeq1YKo//ppswWc
        5e8LsTrG68nCS8VGatw6Gxm/kFf7fWN/MtwL
X-Google-Smtp-Source: ABdhPJwtxbK5/LkdVU7piU1WyRDkdTwSiQWQIsaSiliEZgIFYJb2iMafQtgAJGUx96c8mVD6jeT/iQ==
X-Received: by 2002:a65:6814:: with SMTP id l20mr2071137pgt.326.1637524512482;
        Sun, 21 Nov 2021 11:55:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f18sm5361710pfk.105.2021.11.21.11.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 11:55:12 -0800 (PST)
Message-ID: <619aa420.1c69fb81.18838.f64f@mx.google.com>
Date:   Sun, 21 Nov 2021 11:55:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.80-21-g6fc1e3c907b9c
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 186 runs,
 2 regressions (v5.10.80-21-g6fc1e3c907b9c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 186 runs, 2 regressions (v5.10.80-21-g6fc1e3=
c907b9c)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.80-21-g6fc1e3c907b9c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.80-21-g6fc1e3c907b9c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6fc1e3c907b9cb73310281c6814946464e64c838 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/619a693123f75aedf7e551f8

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.80-=
21-g6fc1e3c907b9c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q=
-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.80-=
21-g6fc1e3c907b9c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q=
-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/619a693123f75ae=
df7e551ff
        new failure (last pass: v5.10.80-21-g8580de58e453f)
        4 lines

    2021-11-21T15:43:14.960965  kern  :alert : 8<--- cut here ---
    2021-11-21T15:43:14.961477  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000313
    2021-11-21T15:43:14.962403  kern  :alert : pgd =3D (ptrval)<8>[   42.64=
7949] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>
    2021-11-21T15:43:14.962670  =

    2021-11-21T15:43:14.962905  kern  :alert : [00000313] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619a693123f75ae=
df7e55200
        new failure (last pass: v5.10.80-21-g8580de58e453f)
        46 lines

    2021-11-21T15:43:14.978076  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2021-11-21T15:43:15.020178  kern  :emerg : Process kworker/2:5 (pid: 94=
, stack limit =3D 0x(ptrval))
    2021-11-21T15:43:15.020445  kern  :emerg : Stack: (0xc36bfd68 to 0xc36c=
0000)
    2021-11-21T15:43:15.020682  kern  :emerg : fd60:                   c3b7=
5db0 c3b75db4 c3b75c00 c3b75c00 c14459d4 c09e310c
    2021-11-21T15:43:15.021152  kern  :emerg : fd80: c36be000 c36c4200 c36c=
4208 c3b75c00 000002f3 c3a0bb80 c2001d80 ef86c160
    2021-11-21T15:43:15.021390  kern  :emerg : fda0: c09f085c c14459d4 0000=
000c c2347340 c19c7a10 5143c142 00000001 c3a0ed40
    2021-11-21T15:43:15.021852  kern  :emerg : fdc0: c3a0c200 c3b75c00 c3b7=
5c14 c14459d4 0000000c c2347340 c19c7a10 c09f0830
    2021-11-21T15:43:15.063248  kern  :emerg : fde0: c14436f8 00000000 c3b7=
5c00 fffffdfb bf048000 c22d8c10 00000120 c09c6828
    2021-11-21T15:43:15.063515  kern  :emerg : fe00: c3b75c00 bf044120 c3a0=
e280 c3a6a908 c235adc0 c19c7a2c 00000120 c0a23200
    2021-11-21T15:43:15.063996  kern  :emerg : fe20: c3a0e280 c3a0e280 c223=
2c00 c235adc0 00000000 c3a0e280 c19c7a24 bf1050a8 =

    ... (36 line(s) more)  =

 =20
