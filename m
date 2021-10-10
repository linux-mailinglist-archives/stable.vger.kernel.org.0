Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF588427F38
	for <lists+stable@lfdr.de>; Sun, 10 Oct 2021 06:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbhJJEvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Oct 2021 00:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbhJJEvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Oct 2021 00:51:20 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A6BC061570
        for <stable@vger.kernel.org>; Sat,  9 Oct 2021 21:49:22 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id g184so7462656pgc.6
        for <stable@vger.kernel.org>; Sat, 09 Oct 2021 21:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=E0DCdkvO/bPJj5iB1JUmtEl6BkBnTbRyQ+Rqo/mgXlk=;
        b=lAI5NHzdwSNb0jL0qCpK6WrulgynnsoRk0Ssw3vA5zOwEuUi2lxO2CD1lbv+D3BR+u
         UDxnx5d9LYQtvSDalUOdeQIoUnkKdhzToqCFTXOCwaZdDoASfpp7haPBlchVF7d+mx84
         9V0EhTGQH7ESHsOMqkoNpVezQZKIwkCJYkXEeEiJnZKueTAmIl24RSV1N0GossMzHRI3
         ce2O8+U2oid6X038mRuddakhlW6fD2EtKgUTosddL9VaazMK5NrKyIvTnPeJ8DegDkv7
         uSlrU64EZ3pv2A5PTlWTLv9MnO2HJxqaklTHPyCoSKSroegdK1CbwP7O4IaDyIxVHUXy
         JR3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=E0DCdkvO/bPJj5iB1JUmtEl6BkBnTbRyQ+Rqo/mgXlk=;
        b=RY8kXViS/JjHr44zc2NTDMJnjekfH35Nj1SwCLhZMLicYxF1NXPe2WhjMEs1KhDsbp
         uL1DhbUPRGAMhccv/ANCdDln8DJnirNBZewDQH0l7IMsH0XX+e+V28pWb+nLt9JsK0Ay
         XO8CAslu2QouKrotUaVPJom2IxQFH3d3Ze3ObvOWpUiorUcaKu7FWzceIdDwHLaHhJxk
         cuiIyAoRyuhpFjSXh7ey9zKuwyNHhv2KqLZ5nL6WHuGjvIEzxghoQeN8Ehph3/KBcEsT
         MPHjXm3ga/f9FPveKocMoTaOMKBMjlYes+EzsZohcDoyxkXxUwtX59FS7jV0vxX8Zhzp
         +7aA==
X-Gm-Message-State: AOAM5322T/APmUMZwyaaW1QHIKPReaEnPILGNw82mQZLUrQgdx0ZTwAH
        vJU7LLS2ZKSzGU6VwcYUKePoGfu+ct9LT8go
X-Google-Smtp-Source: ABdhPJxDFb7oB8JRSZ60fF6g9Ps0go0TeSF8xXJdrUsGo3Y4m4fgQfKYcUHf/jKVIRbdPTosLyXTnQ==
X-Received: by 2002:a63:ce52:: with SMTP id r18mr12253801pgi.350.1633841361880;
        Sat, 09 Oct 2021 21:49:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c11sm3536626pfm.55.2021.10.09.21.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 21:49:21 -0700 (PDT)
Message-ID: <616270d1.1c69fb81.8d3a9.ab3f@mx.google.com>
Date:   Sat, 09 Oct 2021 21:49:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.11
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.14.y
Subject: stable-rc/linux-5.14.y baseline: 193 runs, 4 regressions (v5.14.11)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 193 runs, 4 regressions (v5.14.11)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      924356b31dcbb1d5a4a210d3614372fc4c27e6f3 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/61623f12f491171bf499a325

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
1/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
1/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61623f12f491171bf499a=
326
        failing since 1 day (last pass: v5.14.10, first fail: v5.14.10-49-g=
24e85a19693f) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61623feeb9e5fe111e99a31d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
1/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
1/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61623feeb9e5fe111e99a=
31e
        failing since 2 days (last pass: v5.14.9-173-gd1d4d31a257c, first f=
ail: v5.14.10) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/616240649b8e9cabe899a2f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616240649b8e9cabe899a=
2fa
        failing since 2 days (last pass: v5.14.9-173-gd1d4d31a257c, first f=
ail: v5.14.10) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61623f6d8821d895a099a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
1/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
1/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61623f6d8821d895a099a=
2eb
        failing since 33 days (last pass: v5.14-12-g95dc72bb9c03, first fai=
l: v5.14.1-15-gafbaa4bb4e04) =

 =20
