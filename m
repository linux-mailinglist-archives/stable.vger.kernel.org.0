Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F193975D9
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 16:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbhFAO6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 10:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233924AbhFAO6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 10:58:06 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472A3C061574
        for <stable@vger.kernel.org>; Tue,  1 Jun 2021 07:56:24 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id c13so2085122plz.0
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 07:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8wEsUJKRo8EvLr5+34iwf6hIW3wRT3/Amb1aDgpHdOU=;
        b=p/8/Xgahjn4xRmOnA+biRdQ0kCy+KZIqLgxKUJa569lRiBOgcTTC5rsvjAD9Zind9U
         FilkJl3OretC+sPzCnTAAJxVwA+S5L851v/8D0R8BPi5NR4Dvl8brHfI8gZgrJ5Zt9n4
         8qT1DFGxdCG/ISe8qsuBDtiZVdMka2BT78yVMudeZwsYhU1Q7kwWQa5aK0SocMdTzzAb
         6vA1aDSLV6fn9/Y3ijMwzvA2L5CzRiwggeWuF7W4ifdsfm21OVzBiGUkmMCGVR5bUKot
         u3ZX0tqK+y9dBTFHyNWDKqB0eYmHEz64et9GUQ1PCtajQaP+Xn4rdsMQU3ALlDSqP8ef
         0V5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8wEsUJKRo8EvLr5+34iwf6hIW3wRT3/Amb1aDgpHdOU=;
        b=k0XgQ9ygZmePfWMjE3P9GpkZa+Z1HOebaQNUKdpvtBeXuSKCJXTY8edui1b12bipTq
         NSO3yGx4e48AkXh2+ejHxmyqcYnAODgTVDK6oKBhU4paby9TBVWUZHu1kcpJgV43QkIb
         8jd3IVlf5kxKomJ/tzzNstB0AFckh0eVJ0w4wdmAStohY8vQTlk7rm+z8g/uwCId2qH2
         2MZ5aSqrIBdWDkub2OQHlv0BOzOLotnPzxRnowLd1RW1rb4C2C9/J1dIba3oe29TpIzM
         KOyBaccf8J0lfwddBI4kUKFEFo47r+WhAUzizK3Ikq3LkRo2vqfwavHEEFlKBDUR2Wrj
         q2Vg==
X-Gm-Message-State: AOAM533aMO0GyXqYf4x3JwLpuObhMjmh3+FrWiKW1x113bcpG5JHYN+R
        HZLAUh2Rtm2I/cDnDUaNwROe6ZMtM4pAu20t
X-Google-Smtp-Source: ABdhPJwb5qS5K43u7Bw0UV8qf9NHE/CnZ13gEKyYLqdmFQMd49gjoLYsa6JzCro1+ZdHWwDFkU2yfw==
X-Received: by 2002:a17:902:c951:b029:106:513f:58ff with SMTP id i17-20020a170902c951b0290106513f58ffmr7445756pla.37.1622559383590;
        Tue, 01 Jun 2021 07:56:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s123sm13482417pfb.78.2021.06.01.07.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 07:56:23 -0700 (PDT)
Message-ID: <60b64a97.1c69fb81.56ba6.a2fb@mx.google.com>
Date:   Tue, 01 Jun 2021 07:56:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.270-64-gb5717d0b4fd8
X-Kernelci-Branch: queue/4.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 89 runs,
 1 regressions (v4.4.270-64-gb5717d0b4fd8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 89 runs, 1 regressions (v4.4.270-64-gb5717d0b=
4fd8)

Regressions Summary
-------------------

platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.270-64-gb5717d0b4fd8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.270-64-gb5717d0b4fd8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b5717d0b4fd82fe12e499c248b97d7f357500b52 =



Test Regressions
---------------- =



platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/60b6104294c150c131b3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-6=
4-gb5717d0b4fd8/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-=
cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.270-6=
4-gb5717d0b4fd8/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-=
cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b6104294c150c131b3a=
fa5
        failing since 1 day (last pass: v4.4.270-53-gddff99e02e2f, first fa=
il: v4.4.270-54-g222f2191a91e) =

 =20
