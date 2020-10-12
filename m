Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44D828B05B
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 10:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgJLIhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 04:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbgJLIhF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 04:37:05 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A2BC0613CE
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 01:37:05 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id n14so12857634pff.6
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 01:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fkIWq4LiWYQ9zG63f7GG3V9Ey+OL2G1/S3FQBHhgQs0=;
        b=pAteyJ3JvCdnd3JkzPVDtdhlQgj97xZng7Uxr9BffWdHVExzttYjmiIuY34qjkXnJ6
         GYMIy2LICBKefsnEfSJQXYezAgosV4alwEnOhneNqWZ7dmr0LIydjP3i/tFPLfoboXPa
         apcSiMugUKTfF0snQWrTOaN1ooxFf4QLZyMQ7KRiVBKGETHVLx1yXYRLJEn+p0rQfiuS
         uIU8KMS3erCSdKbUfGkdYsRyIaPMa4DMwKjNGc02cfgpfQRxlw1yf+kHcd70eK0j3y3f
         UGCu1ek9ZI2pVlWvihoy5pvlqBPiCw0XV8KblRc3y0J8V8vfcRj4gSZV1v6Hl/V0hvfo
         8pGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fkIWq4LiWYQ9zG63f7GG3V9Ey+OL2G1/S3FQBHhgQs0=;
        b=U+Jg5Nx++d2FcfSW6pVmVCMxr+25JDi2baT+XFF8v+edcd7+lG99KAy+yIYeMhJlWc
         5MgwZGcyPfn1RGdQKNtlDjSQ1qvuxrsuFmo+vO58hVe+k6JWDZslHdQqnDkmsCeSUyAm
         MW2KJBxy5DBkizEgru3g1SUyqcThQNDET4YYjQSUivFcqIBQsq+Z168QstglsI7p7zKm
         CGt5gbLupZTvjSDsFFyDop0tkf0bcY4Ibf6vS40Q+Q3X1N2YOjbwOTPEYLm3UWVKmQ3T
         VQeKr5nw6CHHED9pz1X5o4GXWtcYSZzlM1RrwRmTkTwf+skbH5iTKh1m9JdMUmeo0Eyp
         /wew==
X-Gm-Message-State: AOAM530nyOE5egkg28NX0MIajpSPadXU3E4imSc2gqbq93cL+FDkWgAW
        Ai9hrhyngzuTe/jHpvk0m4Cs8AvafMd5eA==
X-Google-Smtp-Source: ABdhPJyU+DJ30TqW4oKobyKzh7sgvZBtNFmjkEl5/2DBrOUnbe5FFrO8KvCrTQyDvh6vx8oAsbGV8g==
X-Received: by 2002:a63:308:: with SMTP id 8mr2974410pgd.203.1602491824398;
        Mon, 12 Oct 2020 01:37:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t13sm19391441pfc.1.2020.10.12.01.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 01:37:03 -0700 (PDT)
Message-ID: <5f8415af.1c69fb81.21cb8.52eb@mx.google.com>
Date:   Mon, 12 Oct 2020 01:37:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.14-53-g01c3ea5ad565
X-Kernelci-Branch: queue/5.8
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.8 baseline: 83 runs,
 1 regressions (v5.8.14-53-g01c3ea5ad565)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 83 runs, 1 regressions (v5.8.14-53-g01c3ea5ad=
565)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.14-53-g01c3ea5ad565/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.14-53-g01c3ea5ad565
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      01c3ea5ad56505f6bb3ca15b882b28a1bcfb46b1 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f83b276420e58b59c4ff3ef

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.14-53=
-g01c3ea5ad565/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.14-53=
-g01c3ea5ad565/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f83b276420e58b5=
9c4ff3f3
      failing since 0 day (last pass: v5.8.14-25-g7f6f73185983, first fail:=
 v5.8.14-45-g4e0cc9fc2e6f)
      1 lines

    2020-10-12 01:31:39.691000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-12 01:31:39.691000  (user:khilman) is already connected
    2020-10-12 01:31:55.682000  =00
    2020-10-12 01:31:55.682000  =

    2020-10-12 01:31:55.682000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-12 01:31:55.683000  =

    2020-10-12 01:31:55.683000  DRAM:  948 MiB
    2020-10-12 01:31:55.698000  RPI 3 Model B (0xa02082)
    2020-10-12 01:31:55.786000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-12 01:31:55.818000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (382 line(s) more)
      =20
