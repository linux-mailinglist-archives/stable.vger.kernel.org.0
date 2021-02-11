Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701263183A4
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 03:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbhBKCjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 21:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhBKCjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 21:39:01 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE8BC061574
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 18:38:21 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id j5so2706933pgb.11
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 18:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wvrlBmy9XyurwZAlnl+aAbBE+BkRXdH43n4StiHgCaU=;
        b=iFrUlLJjrH60WJke1G0vc/4fAKRDrlnxxT9CuZa1ZttXoesU8hsDWquMZKzSDE6ByY
         BcXn0gWlbzcZI0KOVjotuUTv+8sELXZjsbeUXseI6Qg5PdzyRBw4Svq9hOwHVRUa0rkt
         ydaONu9iTPqjNVDWqrTaWDrILslkaJyxxPS0uNRuAr1binlw2iTfp5YVgK5nbePiX0lN
         u5P6iHoJCM7WibjB/AzLh9n1SYCNlM1KEx3rnyECdWIow5GbRYj6dFbXx89QyvMf6Htp
         DPQr3l7xKbw/GsM1l6sWDCFLcSdoKwUAT61tKnYcvdXXdc6VKuoVz0UFU9QrR6LkN3Wm
         2e2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wvrlBmy9XyurwZAlnl+aAbBE+BkRXdH43n4StiHgCaU=;
        b=jmoz4k7tAVcHNzaGVUtJW8mFqwcAYgNPsSjwlgdpC9d7qxIjp0oYlIH4nevaR5HYTg
         bGlzEeObPVrNTWPWD6g9YPcyr3kXXHkZKzfxA1TuPlja5ctXLzd1eYUo0mlbGx3eRBec
         2J9G+yF4Jr7VPU7bLn18j48aMX4274Uq3HOEROYBeDgLS1DgEAll4cqtoRSCR/UbvTbv
         XjS5ZP0ti1tbHHCioxX6qgdden2N5iG6Lm3z0WnYl4yPVUIKNV/SvxlaHFxHkYN9gbMz
         Bo13t0Gw2mLvKNf276rlTTmpJ0wL4dZCIqRoaJvIJwdM7NfE5WoXdekPsdDIJV4iSLT/
         uYsw==
X-Gm-Message-State: AOAM530YlArkYm1Mn8BH3vSC2uhO909QaiEt0Gb78bSiEdE021noF8KJ
        8cGbQL2u8yc3p0Zy5XfnuJgJq3WZ+TTMJA==
X-Google-Smtp-Source: ABdhPJwuDS/vwq0uP2nyU2pMrcnRf1pIToTE4B9RhAroQdb9EaeyVaGHJAd6qEtXCtwD1RYrsm5rvA==
X-Received: by 2002:a63:4207:: with SMTP id p7mr5949066pga.406.1613011100263;
        Wed, 10 Feb 2021 18:38:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x9sm3432196pfc.114.2021.02.10.18.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 18:38:19 -0800 (PST)
Message-ID: <6024989b.1c69fb81.27773.8b08@mx.google.com>
Date:   Wed, 10 Feb 2021 18:38:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.175
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 74 runs, 2 regressions (v4.19.175)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 74 runs, 2 regressions (v4.19.175)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.175/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.175
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      54354bc5e2a599518c25769b56d76eabe94e67c9 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/6024668cdd283d1c653abe62

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
75/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
75/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6024668cdd283d1c=
653abe67
        new failure (last pass: v4.19.174-39-g69312fa72410)
        3 lines

    2021-02-10 23:02:18.129000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2021-02-10 23:02:18.130000+00:00  (user:khilman) is already connected
    2021-02-10 23:02:34.312000+00:00  =00
    2021-02-10 23:02:34.312000+00:00  =

    2021-02-10 23:02:34.332000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2021-02-10 23:02:34.333000+00:00  =

    2021-02-10 23:02:34.333000+00:00  DRAM:  948 MiB
    2021-02-10 23:02:34.348000+00:00  RPI 3 Model B (0xa02082)
    2021-02-10 23:02:34.435000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2021-02-10 23:02:34.467000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (385 line(s) more)  =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6024667cfdbb1e37833abe97

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
75/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
75/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6024667cfdbb1e3=
7833abe9e
        failing since 1 day (last pass: v4.19.174, first fail: v4.19.174-39=
-g69312fa72410)
        2 lines

    2021-02-10 23:04:23.726000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/102
    2021-02-10 23:04:23.736000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
