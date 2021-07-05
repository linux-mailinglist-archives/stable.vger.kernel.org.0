Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B053BC3CA
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 23:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhGEV6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 17:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhGEV6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 17:58:13 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB46C061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 14:55:35 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id w15so19479091pgk.13
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 14:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QDZo/TCqB+qXdNrkdqgWE71AvuXdLS/45BXiHQlQI9w=;
        b=LOw96LcDSOyxfmsL+RHlxQfzWAGrVlJLob5Fu00QjKkalPNvCyRb4rFWQ6Oc0lTB/H
         ip/W1qdU8UiNLXYSzDLWqtjbCzGybF9ga5lDXzls7DueobCvTibZxW/anvRZ8xJcSOc7
         2NFsbQ+KAIz94xnJpfh9r+pbN7KVpuiawJAb1dcx6zTbZhUElMLcb5eSE0Or+g1cOsmI
         sSHJVRZZiqgf+TSeRZBDuNb95vgAwSaSVj8wmqUpaKH9KMSrUDMTCSEe3g3M0uCxcSFs
         nklN+ui8agoJHIluAvHCT1hIpvRr8NY4kEveDKmOtmtSAYLB0NzSiU7xx6Ii1UOH6750
         lc8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QDZo/TCqB+qXdNrkdqgWE71AvuXdLS/45BXiHQlQI9w=;
        b=srwBTjLfS0m6Gf2c3PcnsDsp8OObZyDXqyqqMztyzw5WWDqzBFTXD2LQwwNJWPQuhM
         t+3vi8a3k7UTMkmguU466opezpAKKGUzvT53qD8f4/oK+1fYdV/QgldM0DWOZQ5rCSvo
         Dm8JIHk1XO6LOMdlyG0i80j0olxvozkzx/l9dbyd5EPFMi9JgqYRaBVJM/iGCoQTBBO3
         X5diogz1YSWONLug1hdQGo6Sk0DTAj5v4Q4ELXPGC4PWwPxR2/XOnXh5ZO9q1M4Re+pp
         9g6IH4vhTZ8U91ytPYENKc05PHV4n9pQRlMGijG1x/Zc0S2+1wxlaMfeRJiwl/LENSr4
         Lqcw==
X-Gm-Message-State: AOAM5305Ipo9QUrozFHZ1wTCPTF3yt16ISvGb+JZ03Kcu2jR/YI5Dl02
        3/ep8n0ltDqvcnH2iZFZWOvVd9yU1BYl9KgF
X-Google-Smtp-Source: ABdhPJyx3hU+orniKgsaDLeHJ7CVIX1E4AxFIGGJ8wHbght7OC3bblJgegha6NYdfKQWWUiaz34ZSg==
X-Received: by 2002:a62:1708:0:b029:31b:113f:174a with SMTP id 8-20020a6217080000b029031b113f174amr13091125pfx.68.1625522135121;
        Mon, 05 Jul 2021 14:55:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g10sm12033488pjv.46.2021.07.05.14.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 14:55:34 -0700 (PDT)
Message-ID: <60e37fd6.1c69fb81.6cfb0.3cbe@mx.google.com>
Date:   Mon, 05 Jul 2021 14:55:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13-3-geedde12f5355
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
Subject: stable-rc/linux-5.13.y baseline: 170 runs,
 3 regressions (v5.13-3-geedde12f5355)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 170 runs, 3 regressions (v5.13-3-geedde12f=
5355)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
2          =

meson-gxbb-p200    | arm64 | lab-baylibre | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13-3-geedde12f5355/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13-3-geedde12f5355
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eedde12f53553760b1f31f52f1ddf4445528ca23 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
2          =


  Details:     https://kernelci.org/test/plan/id/60e34953fe6e22e01611797e

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13-3=
-geedde12f5355/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13-3=
-geedde12f5355/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60e34953fe6e22e=
016117982
        new failure (last pass: v5.13-2-g58f1766113f0)
        17 lines

    2021-07-05T18:02:40.767200  kern  :alert : 8<--- cut here ---
    2021-07-05T18:02:40.810832  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00<8>[   18.344550] <LAVA_SIGNAL_TE=
STCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D17>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60e34953fe6e22e=
016117983
        new failure (last pass: v5.13-2-g58f1766113f0)
        59 lines

    2021-07-05T18:02:40.814757  000000
    2021-07-05T18:02:40.815489  kern  :alert : pgd =3D ebc4fbde
    2021-07-05T18:02:40.816136  kern  :alert : [00000000] *pgd=3D03609835, =
*pte=3D00000000, *ppte=3D00000000
    2021-07-05T18:02:40.816818  kern  :alert : Register r0 information: sla=
b dentry start c1ba2088 pointer offset 0 size 40
    2021-07-05T18:02:40.817472  kern  :alert : Register r1 information: non=
-paged memory
    2021-07-05T18:02:40.853629  kern  :alert : Register r2 information: non=
-paged memory
    2021-07-05T18:02:40.854422  kern  :alert : Register r3 information: NUL=
L pointer
    2021-07-05T18:02:40.856057  kern  :alert : Register r4 information: sla=
b dentry start c1ba2088 pointer offset 0 size 40
    2021-07-05T18:02:40.856865  kern  :alert : Register r5 information: non=
-slab/vmalloc memory
    2021-07-05T18:02:40.857578  kern  :alert : Register r6 information: sla=
b dentry start c1802088 pointer offset 0 size 40 =

    ... (44 line(s) more)  =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
meson-gxbb-p200    | arm64 | lab-baylibre | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60e34d62f835ecfae0117971

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13-3=
-geedde12f5355/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13-3=
-geedde12f5355/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e34d62f835ecfae0117=
972
        new failure (last pass: v5.13-2-g58f1766113f0) =

 =20
