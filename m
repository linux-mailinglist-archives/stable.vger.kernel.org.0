Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25083E0C56
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 04:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238250AbhHECLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 22:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbhHECLv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 22:11:51 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7484CC061765
        for <stable@vger.kernel.org>; Wed,  4 Aug 2021 19:11:38 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id nh14so5821340pjb.2
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 19:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MfaEI+AhNU46EpvRWw16fH5eUTgN9UBXHwCejGXeCEo=;
        b=SRL8aUqnnPtPntGnVINSAA9+BHKnJAlK9VU4EZ9X96NMwvSL2i/lVjNGXlZr4ITdB0
         z4ATxS+crIAD0K5ciFGpDubVWG78hpiKIaXI0YT2LXk1wEUS0Ko0i9+IyF8X1gK1i1sU
         pe9gWXDNY+cmjWfGBi/rjorpg3bQQ2YNfqy02QQx5UK+sDdjrYrkUewJu0vU8ek8xrNZ
         dmXSH80MCWsjYCxqg8Qe4Zc36txKOPqqWMe17zo8kjKm5uRBZUd6PugP5nHUoiwCMoXZ
         ngGqXuVsSZe2aSmps4iDEpM7EpvoNr4xOkC7LaWPQS/60yA4PJkDDscEZTrKT74UjkYR
         mGVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MfaEI+AhNU46EpvRWw16fH5eUTgN9UBXHwCejGXeCEo=;
        b=XvKOHUxDbZYTdOGX6BPViUWM0VKfjR95OC43GZvdGASiFSsya3JjEBz9rann/UHee9
         gJLIFPjRvKGwiImDVoqRUW3rzlcqe6TolPgvRr3SRONBSzSAXPUVR5Eu0uBi7EY7g6rI
         9E1idbOTkLsai0gCvLW7UiTWeMCp9WWQdKZrVLyJ4rZhfU4kQVYVrnGKlSkiFhJte9D0
         XOBXXZmOLhUMsPpL2MQxapvcUMIbVN0borW8lEKkxMTLE37u+xdtj58xSwBeVWGRIgHe
         DXRE0tB75xc7eBeOhyNp44JhemoPLBU8341cNBLkWxDPD9bJPlQ/wAEWUq+F3tn/HDu3
         33bw==
X-Gm-Message-State: AOAM531gqABbe0+2zLE7F+thlHn1XbDrIe626L0UAa+FhoZ+y7XfbiQI
        sWnrEiiB6jEHphh4swh4qAqqNaBOb1jZmf4L
X-Google-Smtp-Source: ABdhPJwmkYsxHrXNUo55XXZg8hjNz8Q58DUXLziaUztihckqIWZoEDdIqwXL7Ng8NW92YN+Vk5XSTA==
X-Received: by 2002:a17:90a:f310:: with SMTP id ca16mr2137874pjb.181.1628129497848;
        Wed, 04 Aug 2021 19:11:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kr6sm7556133pjb.23.2021.08.04.19.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 19:11:37 -0700 (PDT)
Message-ID: <610b48d9.1c69fb81.fd31b.7e14@mx.google.com>
Date:   Wed, 04 Aug 2021 19:11:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.278
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 52 runs, 2 regressions (v4.9.278)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 52 runs, 2 regressions (v4.9.278)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.278/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.278
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      29bb8b3fc24fda91eecc1df462f055d60eab817f =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/610b1c60a5a07c64b4b1367d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.278=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.278=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b1c60a5a07c64b4b13=
67e
        failing since 263 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/610b0c56a5669ed126b13666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.278=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.278=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b0c56a5669ed126b13=
667
        failing since 263 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
