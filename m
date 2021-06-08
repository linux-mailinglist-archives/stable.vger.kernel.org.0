Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13FC3A0750
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 00:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbhFHW6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 18:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbhFHW6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 18:58:18 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EC8C061574
        for <stable@vger.kernel.org>; Tue,  8 Jun 2021 15:56:25 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id 69so11500241plc.5
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 15:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s0aGquoWc5tHWzVPpjosEfoqGixeOAUG38q2RU7F4I4=;
        b=FQqFEbVshtzA+CzRG4z7vEcxUczJT/ehRSkV9yFPilW2UeoaLVL0Zzw8kUcSHQPPf3
         1lEAcXrZ2hRT/2Osvgyj+4NbP7H29QDnMPBzkzKDkWRsbl69USgy9GiuhqiRFwZPnw4W
         qc+o+5NbQk3duKib1u38Jfc5dlR5m8HvtO602kgFzI0D/Mu6WHxAQVZ1VQYiZHkU/JJZ
         hY64Mv7IFx8Va3NjRjp/J4yCnFd2GuKk8olk1pjDYEohUXn7+rmd9/TYbw4LpgDAVHFD
         xGCGeu5OC0EISePziHIJ0cnIFUzzILq8ZK0X2JRg2urRI3sGUdKM8VW/o7EsVGkwELxK
         R40Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s0aGquoWc5tHWzVPpjosEfoqGixeOAUG38q2RU7F4I4=;
        b=e34K/giLGFQzWIFsS/+CnOqpm/ssu5RINheCP87X82gxXuheb4y4PRiGQuj9Upjsjf
         5pONxWjKM5cCOAlA1tPW5NsKOvWqmcEGYIRWo2caQ4kSxYjsspaePS5kAN7GoSbA5qrh
         kuDkKcmq5YK1nOZ66XB/L815zJVa0WmyXqLUIJurgNTYHRO1JNqhJkVhkQ384SwOjk8C
         a4nF8GS4/kL0ce7ICEVRq8Sz9N7rFrtAFhzmTHO4HdCIDNdelPc0QE/PY/IVPFKy70rF
         xvxZJV2c00shA6QwTmtgLFN6NhSePE4gyXg2OgDfSV089o7zP/Bgc+reepHqwVsb+YFR
         +PMA==
X-Gm-Message-State: AOAM5327Ds9QlEFJ3HEwRXDlM8A+V/KcXN2gA+DBdrDhkIFhmhFd7Uml
        A/7M270ZI2RAQd3iC5N7fO/hQVI1VTX/uFdS
X-Google-Smtp-Source: ABdhPJya5zfevRDxSNCT3VIAEviKKq87lIDFP4Dp/jZF0oKKrg5rmApSuvn9Nln+NFPpDeSQzzmr9g==
X-Received: by 2002:a17:902:d305:b029:10d:c8a3:657f with SMTP id b5-20020a170902d305b029010dc8a3657fmr2069914plc.0.1623192984641;
        Tue, 08 Jun 2021 15:56:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f17sm12110896pgm.37.2021.06.08.15.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 15:56:24 -0700 (PDT)
Message-ID: <60bff598.1c69fb81.b9d40.5df5@mx.google.com>
Date:   Tue, 08 Jun 2021 15:56:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.9-161-ge6befd55293b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 162 runs,
 3 regressions (v5.12.9-161-ge6befd55293b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 162 runs, 3 regressions (v5.12.9-161-ge6befd=
55293b)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =

r8a77960-ulcb      | arm64 | lab-baylibre | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.9-161-ge6befd55293b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.9-161-ge6befd55293b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e6befd55293b20d6f64e0fafefba99d253bbb161 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60bfc2899f471ed3ed0c0e09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.9-1=
61-ge6befd55293b/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.9-1=
61-ge6befd55293b/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfc2899f471ed3ed0c0=
e0a
        new failure (last pass: v5.12.9-153-g7a4b632f5146) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60bfc5c1c5b8213e2e0c0e60

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.9-1=
61-ge6befd55293b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.9-1=
61-ge6befd55293b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfc5c1c5b8213e2e0c0=
e61
        new failure (last pass: v5.12.9-153-g7a4b632f5146) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
r8a77960-ulcb      | arm64 | lab-baylibre | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60bfc3b5f22e6b7b1e0c0e02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.9-1=
61-ge6befd55293b/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-ulcb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.9-1=
61-ge6befd55293b/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-ulcb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfc3b5f22e6b7b1e0c0=
e03
        new failure (last pass: v5.12.9-153-g7a4b632f5146) =

 =20
