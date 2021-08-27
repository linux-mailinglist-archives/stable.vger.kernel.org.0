Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9735F3F93B4
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 06:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhH0E35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 00:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbhH0E35 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 00:29:57 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779B0C061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 21:29:09 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id t42so4597513pfg.12
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 21:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9/DRU3R+L0UsnGSjjIur6s4b/FZ91QD8W+FgYptYANI=;
        b=n3sFc7sI+xy7utrdmuSBdOu1eXjYJcuNDIvm7v6qQjWIm0TGMuxHV3Dvv2Mq0uQoTd
         T0fVKs69yceuZEBPHPC2E636aAZ+a/NiNAo990dI/HjSV19VpvASEn/MPbCFpKlvl08A
         uPtH/bWUCT7zJ8YfqG8DIeIObl9+nt3IAHO/SosbOBgLJ397487Yk4laXYVf+GUkZKc0
         Jk65qOGMq6f5sIYjLa4goqUWHlEI2jM1pKHNG/Q0MYI32yq9IxZM1a6vzK2bGhPwLYja
         wIFlywYERBUPybebXchbdrHwHOyOkMVaBdwmR8KdPcz1m+biPVYP5le88QjKc1Jb3tLZ
         MKyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9/DRU3R+L0UsnGSjjIur6s4b/FZ91QD8W+FgYptYANI=;
        b=b/VrOsH0ShCFIcTzmAtQZW/BT+Xg2M/q6WOVK5o+KolXLZjVyObV0LE4GQ+kXIRQmn
         t2H7XFl0lk9wtFu0xcL4AaOpX/ujSRXjphAtfX8oNZ3BkWldJReDTT0Gl3JKZ5egiWuv
         4dSU6GrbY0QgbmB10GcAOBNRGEn6xIcTniZ/hCrqSjnA74N+ECfVdQNEyaRIh2raCx8y
         +BSM52pDZ8nGCAJKHAaHufhgixNMrWx7RrywFf+AzyVnk+h529pgKaN/PjmORfudnKQz
         fT/YwgWihPhClrKoYfMEQ9lYKeYznWvpWRpx+BMqWIeYi3xu+OG2xUCGoqHunhS/4peX
         BqHQ==
X-Gm-Message-State: AOAM531I7wPAmb6p75qNqX/m7PEsCF4UoxG6DeXiWg7AuonSIO0o0VxT
        CUJ8v3Zy76eD7VmRYp6nXhxK3y9iuSslYTEo
X-Google-Smtp-Source: ABdhPJxd0mmNZ/JXn9hgsxZ8bo/Wr8WO1qJthcePl/r7JzkENpwOi+vAqZzaZW3HsY0qFEnqho1TeQ==
X-Received: by 2002:a62:ee0f:0:b029:335:a681:34f6 with SMTP id e15-20020a62ee0f0000b0290335a68134f6mr7105689pfi.55.1630038548857;
        Thu, 26 Aug 2021 21:29:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h21sm5243554pgg.8.2021.08.26.21.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 21:29:08 -0700 (PDT)
Message-ID: <61286a14.1c69fb81.337ad.f945@mx.google.com>
Date:   Thu, 26 Aug 2021 21:29:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.61
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 138 runs, 2 regressions (v5.10.61)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 138 runs, 2 regressions (v5.10.61)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
meson-gxbb-p200         | arm64 | lab-baylibre | gcc-8    | defconfig | 1  =
        =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.61/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.61
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      452ea6a15ed2ac74789b7b3513777cc94ea3b751 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
meson-gxbb-p200         | arm64 | lab-baylibre | gcc-8    | defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/612836edc8ac575cf18e2c79

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.61/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.61/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612836edc8ac575cf18e2=
c7a
        new failure (last pass: v5.10.60) =

 =



platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/6128376d5fb191a4498e2c91

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.61/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.61/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6128376d5fb191a4498e2=
c92
        failing since 13 days (last pass: v5.10.56, first fail: v5.10.58) =

 =20
