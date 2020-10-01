Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F6A2801B8
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 16:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732360AbgJAO4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 10:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732299AbgJAO4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Oct 2020 10:56:34 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5135BC0613D0
        for <stable@vger.kernel.org>; Thu,  1 Oct 2020 07:56:34 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id q123so4758147pfb.0
        for <stable@vger.kernel.org>; Thu, 01 Oct 2020 07:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Qyekbht+kRTGOUCU9cBIyYreSDo/SweFbGqo47co5mU=;
        b=mZToOojVrAtuicOMUf+RX11gy9Wd9qN0yQ6Ph7dBaJ9myle/RZD1SBEqfTdPmdOIDR
         hSZlBTQb1dDtGtAEpXtqmnljvVmhLG4fq5UAbHt/QWCGgAu3zPhpYlXnAL5L6IKYmvEI
         IzIJsCWfzygIl6/AFytZzXKlATesVxss+8CcLGdAW5sA0eFDGbHmd7zwgp7om1ohgPzn
         3YCEO3EEuE29o2I4XJ5xGREnwbLzxkg44540mH8uGP9+ISTsUam5YyADBftrccwzwP+c
         AnqFYfj4nRdwHcVBuHyBJVXrGmKoxL0M6nHvg+eZ4SGiWW3i7mVV8XhQZm+0covQBOvt
         qEgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Qyekbht+kRTGOUCU9cBIyYreSDo/SweFbGqo47co5mU=;
        b=sL2Km2/3SQikLUzLzJrgeoYFVROGa/L1hQqb66ekCfIvP9Vq394aPqzCki4jcDVolc
         35Yr2Z6/0Y8Uy8BHeKlqiLu+HdYtZBCfVXZBXx8wABwMAYdUM1H+WcWaUoa7G7fWuCWw
         lyJ44G47NDBKWaVVR58YE7zpB4YvlNrvUxI6iiWCt3Wqbez78si+XGwtmF3mAMHfHp4Z
         EQY2NjhN0/5ikxE8Kcv8KWFH8GkZpkEieK43nuli/1sJaYwtYmECCbedEd7s2OYq3LZH
         GYMRMdEKiUmU5azRtzR9b7lu/oDQknH9GIdxKXteeaT8xGezWPinLkp8NQYgvqRRkN30
         zHbQ==
X-Gm-Message-State: AOAM533SrrABYN38JFi1jKfpbSG1HTBix2PKR7CUNStwOo7SDzRrOStP
        Ck9xOiCtmgkOhHlBbVlCnAyxXjNQOytC3g==
X-Google-Smtp-Source: ABdhPJzQ0whsgKT/BvuWTGVZMO7WfQ/K/uo2qpuX3m/x8dy3jRE0B96bJ9tfqsfU1qgHVKO/FVWAfw==
X-Received: by 2002:aa7:8e54:0:b029:142:2501:34d2 with SMTP id d20-20020aa78e540000b0290142250134d2mr7225015pfr.43.1601564193370;
        Thu, 01 Oct 2020 07:56:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o11sm6142074pgq.36.2020.10.01.07.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 07:56:32 -0700 (PDT)
Message-ID: <5f75ee20.1c69fb81.8e0f4.ca41@mx.google.com>
Date:   Thu, 01 Oct 2020 07:56:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.68-388-g42cb2591ce05
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 164 runs,
 4 regressions (v5.4.68-388-g42cb2591ce05)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 164 runs, 4 regressions (v5.4.68-388-g42cb259=
1ce05)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.68-388-g42cb2591ce05/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.68-388-g42cb2591ce05
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      42cb2591ce0507d90a7bcea1f9f8df30f3b6f19d =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f75b7a3bc6ef9510c877169

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.68-38=
8-g42cb2591ce05/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.68-38=
8-g42cb2591ce05/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f75b7a3bc6ef951=
0c87716d
      new failure (last pass: v5.4.68-388-gcf92ab7a7853)
      1 lines  =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f75b77d6fef9646de877172

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.68-38=
8-g42cb2591ce05/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kev=
in.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.68-38=
8-g42cb2591ce05/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kev=
in.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f75b77d6fef9646de877186
      failing since 1 day (last pass: v5.4.68-384-g856fa448539c, first fail=
: v5.4.68-388-gcf92ab7a7853)

    2020-10-01 11:03:16.281000  /lava-2675225/1/../bin/lava-test-case
    2020-10-01 11:03:16.290000  <8>[   20.718339] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f75b77d6fef9646de877187
      failing since 1 day (last pass: v5.4.68-384-g856fa448539c, first fail=
: v5.4.68-388-gcf92ab7a7853) * baseline.bootrr.cros-ec-sensors-gyro0-probed=
: https://kernelci.org/test/case/id/5f75b77d6fef9646de877188
      failing since 1 day (last pass: v5.4.68-384-g856fa448539c, first fail=
: v5.4.68-388-gcf92ab7a7853)

    2020-10-01 11:03:18.324000  /lava-2675225/1/../bin/lava-test-case
    2020-10-01 11:03:18.333000  <8>[   22.761399] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>
      =20
