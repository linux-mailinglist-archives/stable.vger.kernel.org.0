Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96433326B20
	for <lists+stable@lfdr.de>; Sat, 27 Feb 2021 03:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhB0CNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 21:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhB0CNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 21:13:22 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02707C061756
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 18:12:42 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d11so6245570plo.8
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 18:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0UYrpp+F/yTFp4Hop0indmOj+9BlDNH8o64khN7n5so=;
        b=qd7RFHCg10eUR+Y9Qn6RPzyvYVigZkmaEnqUcd64YZ7F2oco8lyZkFK3yG2YzFi8ZZ
         Gt67cWzXr5E2VpDO2jb0a1F+D0qRBvKrk9XGIDW6ZDsOBfme/VuhRw7gjRGrzA7XV7r3
         zPfwq/b0Eyxiw556jBiFdpyMQX7YDDACi/pS8BF4k0E9MYDv4NXqWlJdbW+I5001hPpi
         j5WrkthA5PH6xRAkPuSbuVUEcILBtWgLrWb1UZNkn8SUVWn3OLFJEdI6GCZEr7OSZb0I
         JzdesL/Sz+wj++W1wtDAefnLI/dbId2Khkie81gZ63CQK2KYl/aGEe37opu07pS+e8RC
         N5+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0UYrpp+F/yTFp4Hop0indmOj+9BlDNH8o64khN7n5so=;
        b=PKrd6TFQTnwskIVxPnIhzwMN0KoFsQ/YW8eaMZlWKvc29/szsvN32aHiCiSK7AuylW
         m7GXcwf1cnMsfVr8TqXMcqNsxBKCTDuueSWkYhN39kmaI/+/T1axQUwuqpVPa8Oy3Vl9
         OVpx4B+It85fjU9kT57GugSD8hrMrUbroqjoHblDmAsz2n8u+IBlmDcBLHebve9F9B9o
         b0rvbWfkA8o8p3RHNzEt5iEvsLX/NIn9oYnw2oDd6iOGH7mVOvde+XXiCH4QRJcId5ak
         G1wFCBY5iJLcNlCRtlVWN/1eLxpokIUB59Hg59DqZqdsNbpyeSOKqRroIaxQkHnMgaLf
         SgXQ==
X-Gm-Message-State: AOAM530D8AleCf5quju1R38vLq2bEoBDSit1bf4ZwmbyekQKA3QLSFfR
        kdJ6zxECbHNCpdRvSRgKpVaoOc73/iTJzw==
X-Google-Smtp-Source: ABdhPJxcjOnDN0e50vWt1O7Di7SI1LKNV2CmIPRcztL/ieIgK8zS9fb/X/JnYvoL1A+OmcNgimMoiA==
X-Received: by 2002:a17:90a:b282:: with SMTP id c2mr6380889pjr.54.1614391961040;
        Fri, 26 Feb 2021 18:12:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q95sm118351pjq.20.2021.02.26.18.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 18:12:40 -0800 (PST)
Message-ID: <6039aa98.1c69fb81.bc378.0874@mx.google.com>
Date:   Fri, 26 Feb 2021 18:12:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.101-2-g74001afa8f115
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 100 runs,
 2 regressions (v5.4.101-2-g74001afa8f115)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 100 runs, 2 regressions (v5.4.101-2-g74001afa=
8f115)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =

meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.101-2-g74001afa8f115/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.101-2-g74001afa8f115
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      74001afa8f115110aa35c5daf166944aa4967dfb =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6039727d6e0c0a6431addcba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-2=
-g74001afa8f115/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-2=
-g74001afa8f115/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6039727d6e0c0a6431add=
cbb
        failing since 98 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/603974b95cd2ff5327addcce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-2=
-g74001afa8f115/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-2=
-g74001afa8f115/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603974b95cd2ff5327add=
ccf
        new failure (last pass: v5.4.101-2-gdbf277cedc872) =

 =20
