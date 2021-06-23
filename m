Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCC33B20C8
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 21:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhFWTIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 15:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWTIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 15:08:30 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48512C061574
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 12:06:12 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id m15-20020a17090a5a4fb029016f385ffad0so1994975pji.0
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 12:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y83ak5ZJ31tvuGlyzB5MVRWiKpDn5aDvXscPckfaj3w=;
        b=Z8zH5JmqXB/HtaPG0hSi8z5tp3X1tIJvXRtbgDjlW1RDLxL33Rd3xuK5CWKidVkbFO
         IBnSmfJB2P11sXACLe/dJBxf4xcFOXuFO0FdcoC23sqn7sjjyEOk68sBeoo0DpmVm1nv
         lRZh0YZPEoLQwt4wIBEZXRWDcPGouIK173mHCVtbJqNxS2qqxRtgExdTWKLjC3aEMJ/m
         Mg6MSwZNddBGuqXRr0w8V3E3rmDaxUnKSTqGjeuFxNARAYeRi9SEGMxD8sGUe28ckzyS
         K+W9qFWvT68u84wCYAEEx53Y5+6ZoTHe1t20P0TPzvOkfetCAXU6vuwJmFYTrKtXlBlT
         konA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y83ak5ZJ31tvuGlyzB5MVRWiKpDn5aDvXscPckfaj3w=;
        b=JtWt9+oduOaU8aaCXGT0hk5i3Ej19UTI+a53U22qhMpEIFlZPcH5BvNUq+mnw3QIoI
         1OpUWZ0jknSYooYevS1X06ERMDCDTyNXW92YftDVY0UHxa0coOmvCGE8uy03NiNqJfK7
         TmwBfZ6Db/u4oidJFAoEkFmeR2uYr7bGBjB2ZNPOJLOJQp59zIQxwfBhPrmC5NcQzxVt
         D36xctbAl9KvfUusIUj/OR3bXFfvBiQRkJS6gSGVMKU0D8d0WtOO8Km9ZpFYgph/ySjx
         GkFDgF46NDWdFXD/E8BMHIMem6XwP4mOg3wNjwPKlIBdiN4hC2gMm8suCO9oks0/zT39
         x/XA==
X-Gm-Message-State: AOAM531zpoafuXRNSbp+Cp5dTMatPxDktxCoy1RMfybOFqqoJzcGZj/Q
        6MLruYg9+iPMk/U+UF1tqcXM3z6ppZnnWwFw
X-Google-Smtp-Source: ABdhPJyJ6YjEbdTxDtj18xWrWO3OSaR2aW1VliWUJvIAQ2oQ6LrVbfabWC27EPfjVReJ8SexourGow==
X-Received: by 2002:a17:90a:a585:: with SMTP id b5mr11145425pjq.10.1624475171578;
        Wed, 23 Jun 2021 12:06:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g17sm621738pgh.61.2021.06.23.12.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 12:06:11 -0700 (PDT)
Message-ID: <60d38623.1c69fb81.f9f66.2255@mx.google.com>
Date:   Wed, 23 Jun 2021 12:06:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.13
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.12.y baseline: 183 runs, 1 regressions (v5.12.13)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.12.y baseline: 183 runs, 1 regressions (v5.12.13)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.12.y/kernel=
/v5.12.13/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.12.y
  Describe: v5.12.13
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      1463281b5efd2a55223e4d39e78fbc2e2a5a192f =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d3559b29dae03897413266

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.13/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.13/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60d3559b29dae038=
97413269
        new failure (last pass: v5.12.12)
        1 lines

    2021-06-23T15:38:37.101366  / # =

    2021-06-23T15:38:37.111878  =

    2021-06-23T15:38:37.214998  / # #
    2021-06-23T15:38:37.223822  #
    2021-06-23T15:38:38.482330  / # export SHELL=3D/bin/sh
    2021-06-23T15:38:38.492839  export SHELL=3D/bin/sh
    2021-06-23T15:38:40.114421  / # . /lava-480305/environment
    2021-06-23T15:38:40.124910  [   18.051946] hwmon hwmon1: Undervoltage d=
etected!
    2021-06-23T15:38:40.125126  . /lava-480305/environment
    2021-06-23T15:38:43.082695  / # /lava-480305/bin/lava-test-runner /lava=
-480305/0 =

    ... (10 line(s) more)  =

 =20
