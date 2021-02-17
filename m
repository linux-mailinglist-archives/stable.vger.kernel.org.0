Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B918D31DF49
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 19:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhBQS47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 13:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbhBQS44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 13:56:56 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164BFC061574
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 10:56:17 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id m6so9018969pfk.1
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 10:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hmQctkzoxWFLooFok54tsP8g5CfEvyUkYi7gxzRTeLk=;
        b=mvB2+6ABbp97/7Hkj2QGoPcekx8xn0YBXamjvBYYlJucJ5vG1ZJCaKqeb+pEzYemuN
         ONmfG5pP/CTmpoVJpjS9CBushGTm24dtEbTrynSmj33LX+4NNFdYjsL61Hsj8KkoNIPn
         +RfIMuepJN0VNkLSyVGoyKXPOv2cg/GM+HFxBxuAVVB7CLHoIPMHtCJbYzwxRfGwFWo2
         evYZs2MqyjIrD6WsxNOzApVYPwRxrGuv8fZThBvTxzZAp0vISLjAgCZiB4PszNRZWfCn
         ig3DaAjpkI5xaRBdB/3giEiznZnj/U9WbLssuXsD8ODpXb3ffrGlR7o4s/Y2c/AUODno
         utEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hmQctkzoxWFLooFok54tsP8g5CfEvyUkYi7gxzRTeLk=;
        b=s9d9/XsO8hNUYT3W037+H3dDeK99qya/N8CnKu/sdtSnyWFKz2M63DwmuaVlMwnyLk
         YN7X4yywvCKqgDIoctCA1u3LUNkkVInBBh87glyKx0n8iMZ5v+7ygdb/7ukxzR1g6wIE
         PRviIMg2XOLo7ZSpN8RdgQ1lw/KG9O96o1VxIDpuIKiRaioWHNTDmCEbfZtEy/ZiE4dX
         bL/YwAP/lGfektaa/Oa+QJg6l3QBJPUWXyd0FHPT6vdP/MXtiBk+nEAuuuGsEdNfD9c5
         jfet1l/TwdGeFH09c/UNvJUlwQGAItbqxWTYYTl0p5RFvngHUkfgh5wYwwmXbypALoKB
         ypcg==
X-Gm-Message-State: AOAM5326St8+SnShJFt9z4BuM+VU45kFYRBqQRWfLZ+OcpC+8mp4N/QI
        CkI1Q8uEganzzCI5lhRluZ+ahMaGVv7ruw==
X-Google-Smtp-Source: ABdhPJzLgHYEXNpvMUE7TvKM77j115z7GC4lKaikSm0e8jiDynwbOgakyFGaCIgEQcETSrdNqwcJqw==
X-Received: by 2002:a65:4381:: with SMTP id m1mr664435pgp.427.1613588176327;
        Wed, 17 Feb 2021 10:56:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e12sm3040648pjj.23.2021.02.17.10.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 10:56:15 -0800 (PST)
Message-ID: <602d66cf.1c69fb81.c0917.65a2@mx.google.com>
Date:   Wed, 17 Feb 2021 10:56:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.176-37-g10e94a933ee7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 78 runs,
 1 regressions (v4.19.176-37-g10e94a933ee7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 78 runs, 1 regressions (v4.19.176-37-g10e94a=
933ee7)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.176-37-g10e94a933ee7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.176-37-g10e94a933ee7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      10e94a933ee725c4b025156debce95285c785bdc =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/602d2d9d0c17cea8bbaddd7e

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-37-g10e94a933ee7/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-37-g10e94a933ee7/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/602d2d9d0c17cea8=
bbaddd81
        new failure (last pass: v4.19.176-37-g99b2feb86d78c)
        1 lines

    2021-02-17 14:50:19.789000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2021-02-17 14:50:19.790000+00:00  (user:khilman) is already connected
    2021-02-17 14:50:34.983000+00:00  =00
    2021-02-17 14:50:34.984000+00:00  =

    2021-02-17 14:50:34.984000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2021-02-17 14:50:34.984000+00:00  =

    2021-02-17 14:50:34.984000+00:00  DRAM:  948 MiB
    2021-02-17 14:50:34.996000+00:00  RPI 3 Model B (0xa02082)
    2021-02-17 14:50:35.082000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2021-02-17 14:50:35.137000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (367 line(s) more)  =

 =20
