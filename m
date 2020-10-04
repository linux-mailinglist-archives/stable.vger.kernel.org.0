Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3ED4282C9E
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 20:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgJDS46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 14:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbgJDS46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 14:56:58 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80494C0613CE
        for <stable@vger.kernel.org>; Sun,  4 Oct 2020 11:56:58 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id k8so5072477pfk.2
        for <stable@vger.kernel.org>; Sun, 04 Oct 2020 11:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZuZAyrSjZoeBSUQFLnXf/X5OIFnt8GHWO3Tj5daOgVs=;
        b=J9htiS6W2xY+h9EykkV2YcAFkIDBurT+w912UPJzgR91Zs9qufpAXzcVEMHx22szkb
         XI/o7M7jAO0WdrghefwdJCTwuSeGLHwdqEx5DlnebNefpkQ0+GRnj5eDhECHvnhE7Gbm
         azHPLT/Mn4kWrtGCztBXuAf4i4W3o5Movcjtd8ghcqR13N+R1teY9Hsfcd6F7BS20t+m
         9fOx34nzmR4nga5xqjEAuNYrbj4YxxG8nJRHsU2yfAIlpHWpEnqNHZxQPHuGyo0PNCKr
         ko4OWbMJRJGW/YYNKGYbFgtZJa4VQFncNesXAFzgmMTaB3IEndm56Dcqi6Ew5aLKi83C
         vfLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZuZAyrSjZoeBSUQFLnXf/X5OIFnt8GHWO3Tj5daOgVs=;
        b=FeFdChTSS+uBIqgtVi2QtkZeyPQy8kAf9mam+DLc1kzFnyFKPOTFfrioDzgcIo3wWn
         wCJ5Zv2ly/fFIYloglWlU7XZ7kL9w6HU7bse8Hz8m+E45IlJpZO/gYiZA1jQK3Up2e+F
         5HNf5TGc0FbySO8oXm23NU/cVIsa9InZIbsu8+ERieM7L1R1GTpshZace3Y9xGzmny96
         vum+PCpmr6B7GVkO6yvOZ382GsGv8q2ob34H2AIZ1lVSQyZlfRVDE/jQNU+aUaHCdjG5
         7qQY2KH4l6qUMCgLaaH9AgmWnU42rErdS9GUwyLqW8iH+BXWLnsgTIiGPMOr2Km4LQVn
         SiqQ==
X-Gm-Message-State: AOAM531wujlNadcvfNV29oWvozVojiDaKTm7uz3u5GrsuXm+8AsotI+P
        lAONaLYR2viP5Ysog39IpBFZhJ68uB7CEg==
X-Google-Smtp-Source: ABdhPJxBAHb7YnH9iBUZ0JSmKJd8JtVOxeffwbh86dP8YfSXFWh8nwXBaYxNmJXPC/arXCpG2cjodQ==
X-Received: by 2002:a63:d257:: with SMTP id t23mr11195855pgi.212.1601837817508;
        Sun, 04 Oct 2020 11:56:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t4sm588831pgg.76.2020.10.04.11.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 11:56:56 -0700 (PDT)
Message-ID: <5f7a1af8.1c69fb81.c4bb.1052@mx.google.com>
Date:   Sun, 04 Oct 2020 11:56:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.69-15-g134ae1b4b162
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 74 runs,
 4 regressions (v5.4.69-15-g134ae1b4b162)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 74 runs, 4 regressions (v5.4.69-15-g134ae1b4b=
162)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.69-15-g134ae1b4b162/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.69-15-g134ae1b4b162
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      134ae1b4b162a205ae703f40f093485a84121700 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f79e0cef5fb7757b74ff3e0

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-15=
-g134ae1b4b162/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-15=
-g134ae1b4b162/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f79e0cef5fb7757=
b74ff3e4
      failing since 0 day (last pass: v5.4.69-3-gf31ade88ddd8, first fail: =
v5.4.69-16-gde6f85667998)
      2 lines

    2020-10-04 14:46:32.087000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-04 14:46:32.087000  (user:khilman) is already connected
    2020-10-04 14:46:47.526000  =00
    2020-10-04 14:46:47.526000  =

    2020-10-04 14:46:47.527000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-04 14:46:47.527000  =

    2020-10-04 14:46:47.527000  DRAM:  948 MiB
    2020-10-04 14:46:47.542000  RPI 3 Model B (0xa02082)
    2020-10-04 14:46:47.630000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-04 14:46:47.662000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (384 line(s) more)
      =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f79e0b3c7e9c47c1a4ff3fd

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-15=
-g134ae1b4b162/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-15=
-g134ae1b4b162/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f79e0b3c7e9c47c1a4ff411
      failing since 4 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-04 14:48:11.278000  <8>[   23.345843] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f79e0b3c7e9c47c1a4ff412
      failing since 4 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-04 14:48:12.300000  <8>[   24.367838] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f79e0b3c7e9c47c1a4ff413
      failing since 4 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-04 14:48:13.322000  <8>[   25.389290] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>
      =20
