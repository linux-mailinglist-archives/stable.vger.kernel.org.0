Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9452B3183B9
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 03:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhBKCtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 21:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhBKCtj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 21:49:39 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6645C061574
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 18:48:59 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id g3so2482394plp.2
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 18:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1A205EaFUTWtPWk3ilClyB7SnrNMkXGU7wL65q666HM=;
        b=1NTJk4xTmXaSPr3zTO1ZC5963PVULmeeKdiKSt5QJ+Na1TyRPdxzkWPRXHrzeJIAFl
         NlRWFx1B7RRrvFbmUsxfoXQMfN400E9NnDCQO8bGvvFc9AJQ7syi622uo7u2+caNewWb
         gNViIUjj8jpF8b7Ic3QMcSGKkgMyRgnmOIIReG2DsAIX4CYnlMerf8cH9Gc6lX/jTa+O
         kWp3zcRosF9uIqHwrQfKLjelU8bF7ViJzpPqYnIV8smAGf/RYvRnT56Gb5wIPuBzbWS8
         XOc35PPof3xXHe9qa0cTPF1hXzmO8PH7+y73kj41syMQZ3V+HQpwSjiJ1GLlEzU7eoAA
         2oQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1A205EaFUTWtPWk3ilClyB7SnrNMkXGU7wL65q666HM=;
        b=fNfBNfHz1vPiXUBfLtmTdhUxrMzFoet0wiQj8kpr5uDL4ScbhT+nPvTeRsHwtEaUPQ
         SnvtgDiih8GN79xdvjyZHGj3dOZ+KOLmafiqZ7x+HIIqna45q/PTJq+bnXhpPL7zOmWy
         JdrUPh0up1GPqioHPkNvR4skJNkPMv687X/ah8Nmmj3ZHof8xEvAzm9dcTJ4mXtZfuYj
         36JAAT2U9d4OjlhDr3CLC1v6EQLetxjgYKarkigvw7oE8iai3NpFDhS1NFwVirmEixUj
         99uwYU9nc7v7KZICY1/O4wFk2buaTztwB4TqxsEyQhWjPk3zzuGE+PNEf5qmRiUPU4x0
         OoyQ==
X-Gm-Message-State: AOAM532bC7On/A8Ts++3lJ/CtMH4xJA8ZLkJUNcvLn1k+jviuqRCMHM4
        Uj4dHmrmGj5E9tH/0SIn8uDRD0UK2ju+9w==
X-Google-Smtp-Source: ABdhPJzDg6WDPLdUgnBhvWO5HuVPKOkfcZ2TxIhFJwAa0JG/UZ0L1RQIEgnrQit98XyXrJHHZadyGA==
X-Received: by 2002:a17:902:b10b:b029:e3:103c:4c47 with SMTP id q11-20020a170902b10bb02900e3103c4c47mr1672589plr.8.1613011739184;
        Wed, 10 Feb 2021 18:48:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j22sm3619509pff.57.2021.02.10.18.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 18:48:58 -0800 (PST)
Message-ID: <60249b1a.1c69fb81.b7b8e.8ee3@mx.google.com>
Date:   Wed, 10 Feb 2021 18:48:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.257
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 42 runs, 2 regressions (v4.9.257)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 42 runs, 2 regressions (v4.9.257)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
panda              | arm   | lab-collabora | gcc-8    | omap2plus_defconfig=
 | 1          =

r8a7795-salvator-x | arm64 | lab-baylibre  | gcc-8    | defconfig          =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.257/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.257
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      282aeb477a10d09cc5c4d73c54bb996964723f96 =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
panda              | arm   | lab-collabora | gcc-8    | omap2plus_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60246a37aadb5ea56f3abe82

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60246a37aadb5ea=
56f3abe89
        failing since 1 day (last pass: v4.9.256, first fail: v4.9.256-44-g=
cffa06cb070f)
        2 lines

    2021-02-10 23:20:20.098000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-02-10 23:20:20.113000+00:00  [   20.386871] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
r8a7795-salvator-x | arm64 | lab-baylibre  | gcc-8    | defconfig          =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/602468b57fe1c539f53abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602468b57fe1c539f53ab=
e63
        failing since 84 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
