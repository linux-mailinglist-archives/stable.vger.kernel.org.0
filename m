Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5000D394EA0
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 02:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbhE3A0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 20:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhE3A0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 20:26:08 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7EDC061574
        for <stable@vger.kernel.org>; Sat, 29 May 2021 17:24:30 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id u7so3407671plq.4
        for <stable@vger.kernel.org>; Sat, 29 May 2021 17:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CHmu72bKgemkM56sZ43bG8djNMjOUt+IAqCjiZsgycI=;
        b=E1paEvP2SJalPKfCUGdl0Mbl++sd5cNNn1pTV2HYCn607TtQAEnTBQX+W8u5aDekTs
         kWXHDzP1z4G4jxELNiKDQmWVwI71x/c1sActi5mklQBT0QXxVZBF9QLu+gpNcLag3ZMn
         0n1Ipwh6uB/SHC5dv7IzlHP0I5DX9go/Jt0dxC9jjQlY8xcYDvJSOdnDNQgwAkWME8+k
         Iays0veLdtQZhrJLklb8Cm2n3vUa1d+H0+WaJd7XdhxR9/ujfbqeB+GRqkG5wxz/xVCk
         M04CcT8E8EN/8xdMjpA3kl8F7fNG/8MgUCLLve4fOt+8pjMjF0fpjc0PGs2qqvWgemog
         rG0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CHmu72bKgemkM56sZ43bG8djNMjOUt+IAqCjiZsgycI=;
        b=jrrxzltkdfdAJr6+lMXCSvF/KSeImVoShZ//hUh5UQ7T6sAuTs9nmmCf6KST1tiMLb
         R3fPrFq9inuIwsCn19ptwgGdio4X+WcfWv+nzHQtCdsJXS6KhJ78kxF/T7X4J2bkk2Rc
         /N8v6+DHjWnsyXF6+FftUHUeA6DC/nm+Tt4PMEwwQBoT32ache1N3y9PldcetuA0dX3J
         P1aMoMUF42nfoBDwNL1j274CtYsp0GqGeuHr8T6X3Hink7PmZKSC8yBzxmr4kvzt2hWF
         5ifeErfqsRREk0GtAKc20L5ZJbn6Hl4fYjEkw1FTLM+c5BcjXXJDVpyWASazEr/pockP
         6Hkg==
X-Gm-Message-State: AOAM532IbbaEk3y3FwSlWFv6w6Kvda2iK5+Ww0wGIwylblWdY+CiTBu2
        16iJtorCxUmCXJ/CgUPCoMw3PP7f0U2JFk72
X-Google-Smtp-Source: ABdhPJyHDZaBRRGGw6Rx7IwImJUMBe78fEPDmCFpLu2pGNOpwygkrZwCgA6j1B5ly8ejB6Ololvf9w==
X-Received: by 2002:a17:902:da86:b029:ef:70fa:7b39 with SMTP id j6-20020a170902da86b02900ef70fa7b39mr14228046plx.81.1622334270054;
        Sat, 29 May 2021 17:24:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a15sm7267188pfc.29.2021.05.29.17.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 17:24:29 -0700 (PDT)
Message-ID: <60b2db3d.1c69fb81.dd46f.85c8@mx.google.com>
Date:   Sat, 29 May 2021 17:24:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.122-45-g589476275c7f
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 187 runs,
 2 regressions (v5.4.122-45-g589476275c7f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 187 runs, 2 regressions (v5.4.122-45-g5894762=
75c7f)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =

meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.122-45-g589476275c7f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.122-45-g589476275c7f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      589476275c7f9730354f54d295ac2e2e6bc8afaa =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b2a415824f0dd86fb3afa5

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.122-4=
5-g589476275c7f/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.122-4=
5-g589476275c7f/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60b2a415824f0dd8=
6fb3afaa
        new failure (last pass: v5.4.122-44-g4f993f074caf)
        1 lines

    2021-05-29 20:26:47.941000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2021-05-29 20:26:47.941000+00:00  (user:khilman) is already connected
    2021-05-29 20:27:03.480000+00:00  =00
    2021-05-29 20:27:03.480000+00:00  =

    2021-05-29 20:27:03.480000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2021-05-29 20:27:03.480000+00:00  =

    2021-05-29 20:27:03.481000+00:00  DRAM:  948 MiB
    2021-05-29 20:27:03.495000+00:00  RPI 3 Model B (0xa02082)
    2021-05-29 20:27:03.583000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2021-05-29 20:27:03.614000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (387 line(s) more)  =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b2a5d770fa2e15cab3af99

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.122-4=
5-g589476275c7f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.122-4=
5-g589476275c7f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b2a5d770fa2e15cab3a=
f9a
        new failure (last pass: v5.4.122-44-g4f993f074caf) =

 =20
