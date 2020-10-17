Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42CE529128A
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 16:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438429AbgJQOwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 10:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411523AbgJQOwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 10:52:46 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8D5C061755
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 07:52:46 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id az3so2904612pjb.4
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 07:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8pftj553tGKNzn3HJSujaUOJRB0G+Gi8oJG5ZZk2/tg=;
        b=zGRqna06IC0b0UIb5xcy7PvYqVuxw+fmPOXnvd3DUJSgYiAOVW0omPUFxOQZITGt26
         uxkmSUr6t8Rmmmgkbs6eupANVqiZZekXc7eU1ro3WhjBsuEEI1YFL6uo68mc0GL+yXsn
         ZhLj0WYPYFQANHWqLfft1UWVb9U3Lq78U1n2K41qMYhFPSfEvifBVIKkQF4Cmu7OFNLA
         CM/rsp5RpyzH6SLj2Typ/z6uwSd7SPnz9yya84tGC40DUSlioowu207tKILfJV8NsyBq
         mRyX89cmJlMYeVmKmhigH9IlHSwx6zNfPbGrg5EGPmHJbHYXjKPa3LOAGgiV/Pq7fbDh
         b6/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8pftj553tGKNzn3HJSujaUOJRB0G+Gi8oJG5ZZk2/tg=;
        b=ZIvBB+qcfGFyX9o6GNgXCfmgXx4iv54rkC11AXk6/vtVneSVTJgXz3K1kpiGREDlwd
         Fjuk2CTX8IjbqEmsl81PIne2tSaiH9+LQjxZxQmrfM5NidKziTU/mirddwgMAGsu5Qtr
         6PlfVHHByVkym9MutiO4Dl3j+SMIIYFAonViK+KpjZTWAve3RlgbT9X/WjQfAMQSag/n
         YBwSiWtaGrIWB0gvakE5H9oiPPzCCYmFGHMgdB6jegU2yPEXkyqAuVWVvD+YnOSUVxl8
         Q+Vx4JbJW1I2MaSTmumvaa112aNHiHs0E90suUfO0OOiX26g0IK2Wf7sKzFUpGuEzZOe
         m9jg==
X-Gm-Message-State: AOAM533Cy3uNg9Y7yWujvDJF0PUvKootfBTsPRX7YoMR4Rb9523lhHw1
        2gGt/IG9xAHFhFRSz5DxtJauXffSaJaJew==
X-Google-Smtp-Source: ABdhPJyJ7/cEtfGSdP09kJszMjNnEV6ehyIXqsVyobimWad3bJ74EIW7rbuzo8UttLMjCi2Xu2Yo1Q==
X-Received: by 2002:a17:90a:7089:: with SMTP id g9mr9270932pjk.4.1602946365510;
        Sat, 17 Oct 2020 07:52:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 20sm6021779pfh.219.2020.10.17.07.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 07:52:44 -0700 (PDT)
Message-ID: <5f8b053c.1c69fb81.2a172.cdb3@mx.google.com>
Date:   Sat, 17 Oct 2020 07:52:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.72
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 201 runs, 4 regressions (v5.4.72)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 201 runs, 4 regressions (v5.4.72)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
| 0/1    =

rk3399-gru-kevin      | arm64 | lab-collabora | gcc-8    | defconfig       =
| 85/90  =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.72/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.72
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      52f6ded2a377ac4f191c84182488e454b1386239 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
| 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f8acad59063e6fb424ff3ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.72/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.72/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f8acad59063e6fb424ff=
400
      failing since 121 days (last pass: v5.4.46, first fail: v5.4.47)  =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
rk3399-gru-kevin      | arm64 | lab-collabora | gcc-8    | defconfig       =
| 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f8ac9e3ea01a3d0e14ff3e0

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.72/arm=
64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.72/arm=
64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f8ac9e3ea01a3d0e14ff3f4
      failing since 15 days (last pass: v5.4.68, first fail: v5.4.69)

    2020-10-17 10:39:22.792000  /lava-2729553/1/../bin/lava-test-case
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f8ac9e3ea01a3d0e14ff3f5
      failing since 15 days (last pass: v5.4.68, first fail: v5.4.69)

    2020-10-17 10:39:23.814000  /lava-2729553/1/../bin/lava-test-case
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f8ac9e3ea01a3d0e14ff3f6
      failing since 15 days (last pass: v5.4.68, first fail: v5.4.69)

    2020-10-17 10:39:24.836000  /lava-2729553/1/../bin/lava-test-case
    2020-10-17 10:39:24.846000  <8>[   24.924015] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>
      =20
