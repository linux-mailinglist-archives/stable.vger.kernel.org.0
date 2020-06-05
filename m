Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19661F0367
	for <lists+stable@lfdr.de>; Sat,  6 Jun 2020 01:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgFEXLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 19:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728290AbgFEXLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 19:11:40 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0ABC08C5C2
        for <stable@vger.kernel.org>; Fri,  5 Jun 2020 16:11:40 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 23so4756103pfw.10
        for <stable@vger.kernel.org>; Fri, 05 Jun 2020 16:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=18IjtuAQaHXDWwnTIIJ5ULGwevY8AnbCUWHkw+nyR6Q=;
        b=y6zHnY2U/jRNsn9XBGKfKTDG9VtEKS/Ek24Rt/5T11LaJ4NtoBuAFv1Rwe30yyCiFl
         eG0ipaD8pGkwG0bafm7BYuq7iOi5nFUAdNH8gwrLC73cZ1bTOhpuN3/BePWIw1z4PF72
         6CBOWtC7Ydl1oiEI/mhospGkVyITRnTbLKyQW69feeb2IOT5h9l/ekBral/jBxTdRslz
         8I5vj4aR58CU7+LHeLqQaLc1kl5bYauyNEL0pLf0j+sPfJX9JdYuwhZOmSe8j9ONTbyL
         vTFIoLneETXPWO2pXcOimLl38FUStA26ci1SxF5gIPw6LtjBR3upg3bRYWn5g+L2fnys
         xa5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=18IjtuAQaHXDWwnTIIJ5ULGwevY8AnbCUWHkw+nyR6Q=;
        b=IS4oJ+ablJnGRa8YLa2b+mFCOzON3kmvij1gdFyUcJT7qcKr2132PcoKh7sOExeQCC
         vyCHzV95gXJVjBr67+fG5cd5HSczLfGKx7ukUpGQUyP277gWYTfbGCISC84pvRZmdRCP
         U7OPymK1rpdY0oDqsjfhhLxJBcUm9XBhOs9HWDnhqkqfOSSTfY04U+z1UFnHmqQzfKzk
         55/Y9kAgNYFYRJmDt/NhSjacXW+b8BACDMC0Uw18jqwHpjUn/5W4uCp6k35agwUJWwpw
         XQUo1CFdbhz6O00oETigXYH7VoJlEXp6QOd2uZsC/GFeKDGUla+tkP//QKyheCHHUpUA
         VAyQ==
X-Gm-Message-State: AOAM532Mecm+IZkdS7qNPtLD9QMnkyJPmEQ29pqeVaqAFfKBDyVTe/3U
        3eFsaIufPNhD18KbUrk26ZiHr1Sa1ZA=
X-Google-Smtp-Source: ABdhPJxr8L/7/cunAeZFHquftiUdrWb9nOcqFB4I0okvZNOsZl0dTwIsrsbmmdsTd9QFoLaJcwEBIw==
X-Received: by 2002:a62:504:: with SMTP id 4mr12042414pff.67.1591398699266;
        Fri, 05 Jun 2020 16:11:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n24sm8706509pjt.47.2020.06.05.16.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 16:11:38 -0700 (PDT)
Message-ID: <5edad12a.1c69fb81.ade78.f5fe@mx.google.com>
Date:   Fri, 05 Jun 2020 16:11:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.44-39-g0e4e419d5fc3
Subject: stable-rc/linux-5.4.y baseline: 118 runs,
 3 regressions (v5.4.44-39-g0e4e419d5fc3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 118 runs, 3 regressions (v5.4.44-39-g0e4e41=
9d5fc3)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
at91-sama5d4_xplained        | arm   | lab-baylibre | gcc-8    | sama5_defc=
onfig | 0/1    =

bcm2837-rpi-3-b              | arm64 | lab-baylibre | gcc-8    | defconfig =
      | 4/5    =

meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre | gcc-8    | defconfig =
      | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.44-39-g0e4e419d5fc3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.44-39-g0e4e419d5fc3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0e4e419d5fc3f776cc5ac829737dd6020f89f2a6 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
at91-sama5d4_xplained        | arm   | lab-baylibre | gcc-8    | sama5_defc=
onfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5eda977d64cb52356897bf09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
39-g0e4e419d5fc3/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
39-g0e4e419d5fc3/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5eda977d64cb52356897b=
f0a
      failing since 55 days (last pass: v5.4.30-54-g6f04e8ca5355, first fai=
l: v5.4.30-81-gf163418797b9) =



platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
bcm2837-rpi-3-b              | arm64 | lab-baylibre | gcc-8    | defconfig =
      | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5eda9fa64cc47b33de97bf29

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
39-g0e4e419d5fc3/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
39-g0e4e419d5fc3/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5eda9fa64cc47b33=
de97bf2c
      new failure (last pass: v5.4.44)
      1 lines =



platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre | gcc-8    | defconfig =
      | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5eda9ff4077dbb478c97bf40

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
39-g0e4e419d5fc3/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s805=
x-libretech-ac.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
39-g0e4e419d5fc3/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s805=
x-libretech-ac.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5eda9ff4077dbb4=
78c97bf45
      new failure (last pass: v5.4.44)
      2 lines =20
