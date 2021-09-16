Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CAD40D39B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 09:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbhIPHNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 03:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbhIPHNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 03:13:41 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B05C061574
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 00:12:21 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id t4so3269137plo.0
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 00:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eZJ3iElMnAPrafiXtVM9rD0oJ3ucNAr7vkmtfXAOw/g=;
        b=qOkEsMJdkF+m8Uw7v0b732U+MVJBuSIll1UBQMnVntEkP7OOYMNUkT8/IGJWyiRtRM
         GgtAGi27kGgNdnUH/V1paQhj+g7b0E0XmAqoKCgakEjXhl300rjsJpnWnkg11jR2Y41S
         qD9efoqbidP+MgFh7J86UVxBFWqo3rsAh4kccChVHeLaUCmGaD0Xe3IjyfVqz1xm+IDi
         YvBWogMP/IDy8ZnQaqecUa2Q4beSGRJz8uILnAwaTGkSrD8Pl7fXe+fZZxgowbT31qIT
         xA2ZDex+KfXbQw6b0gs05g84VG3R6TFPi4iNN4Zu1Fc4D6YDqdFCKusgjRHaxxEM9ym5
         LpMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eZJ3iElMnAPrafiXtVM9rD0oJ3ucNAr7vkmtfXAOw/g=;
        b=b7JwSyUTOSZoKFvXjcecH5gYgAV/ge5t0+L9xtcEs6+Mg0hl/lltqEymEM7jcoi7gZ
         FrMD2nnygRvq9+h+dt73ZqmYz+o6d+RrHHCKIrkxD5vAUjG5lRmWkBdvVrmPsBkxYKXI
         gm1RDzuCSoF+1HVYydIzX8Ps3koKHQjQzBEtNdwQYJJ08GbX/8HqihomNNvdO1IjAUPM
         4Fmbke4gGZitFjBrQpvmJaNuLv8PDy05zemDP/9i+mKf2EUO9sT+zx+pXR9p9hElD2OW
         FVHXZQYzrAPs2p6WoUqrbHOHnbNLW2Ti6j+1XwOLCRJQKm2yRNIKYkzewgkDm4P5Oy2F
         Rufw==
X-Gm-Message-State: AOAM531cTAQUom4ndYbEylv98Sd3e6NJHw7P5Dnd01LfOKQ0roootdHB
        EWzyYUZJhC6k2Rc0EmLPJ9L+9233s2YlQL0ozk0=
X-Google-Smtp-Source: ABdhPJxd3SBfdsiPwmKgrlN1C8Y5owjNY0oEbVJhSjHmHBtra2+UVM6qbxNgfBHYNbQMsbQXjg7WuQ==
X-Received: by 2002:a17:90b:1e11:: with SMTP id pg17mr13241167pjb.144.1631776340928;
        Thu, 16 Sep 2021 00:12:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u24sm2096399pfm.81.2021.09.16.00.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 00:12:20 -0700 (PDT)
Message-ID: <6142ee54.1c69fb81.5e5f7.82e8@mx.google.com>
Date:   Thu, 16 Sep 2021 00:12:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.4-395-ga49a6c3da2c6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 102 runs,
 2 regressions (v5.14.4-395-ga49a6c3da2c6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 102 runs, 2 regressions (v5.14.4-395-ga49a6c=
3da2c6)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.4-395-ga49a6c3da2c6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.4-395-ga49a6c3da2c6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a49a6c3da2c6a33a55d8f6f81b03f800b09b4df1 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6142bcd92148112ac799a2f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.4-3=
95-ga49a6c3da2c6/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.4-3=
95-ga49a6c3da2c6/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6142bcd92148112ac799a=
2f8
        failing since 0 day (last pass: v5.14.4-24-g6da4ee8977f4, first fai=
l: v5.14.4-73-gc291807495af) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6142bbbd710aca026199a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.4-3=
95-ga49a6c3da2c6/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.4-3=
95-ga49a6c3da2c6/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6142bbbd710aca026199a=
2dc
        new failure (last pass: v5.14.4-73-gc291807495af) =

 =20
