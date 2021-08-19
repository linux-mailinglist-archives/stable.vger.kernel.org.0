Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278CE3F1003
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 03:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbhHSBhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 21:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbhHSBhN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 21:37:13 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5307C061764
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 18:36:37 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 7so3993989pfl.10
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 18:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mtfZeig1TPaFc6spHdFEd6vmzx0/WJjthifIKAWeTXk=;
        b=Xyl+SzaHjVW18KMe4LmOsYIC8oG0Y6+vgEAnYobnFKmq3AEmJhVVXCeyaKCSKkCNi7
         UOFXOi6rpL1O2xA4/9pOdBweclAZFFyzqj7C524J/FBkQH6uxK0eeVuUSUQExRZZDzoq
         I1wEzHKj+p2FO/7S7Pi5zgUad0eKaZ3XLoigZlWyTt5wEhbfxuqY4coK5zckW6T4FPE+
         41tTYK8yTQihyPseip+9JvBePeG/xJhm7X28cvW0gw9KpAsWzs4a3ZG/kn1iw15D3YAl
         AXH1CFHiueA/l/bM3wHkEb6udNs5TP8SDzppZ2OKjBWS5O4xeyq2E/It6iepxAHIYEbX
         vvEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mtfZeig1TPaFc6spHdFEd6vmzx0/WJjthifIKAWeTXk=;
        b=KwyhFxNiyaQmkrmJ96ofiDvTAggfA9oQ0iA3mtPLgngBTzqAfUShJMOYb3HDcgD+D0
         /07SiHt0wbGpyNhL6D7NPKINnVJ8XhD3jtcBeanOVSBe5OUlUY3UkKkocFFOmOdgGQ0+
         ewp/BHk+l7SfvIW3NDZnJs0TMamhq7Q28EB3ApgAPIUMXiGcPKKqQP1Zw2MKfOLxVJSX
         5/8asheUqpfBwrNaaOOwkyflnWXVtgcQYggClzcNZlwUawbvxPvy9odjavMAsgipljPt
         5q7NqFJScp6oK/Dr/RElioPnF1EuxonjcvwAGgXd71Qokiu4TXeAJZ22fBuK4tDFF8rB
         zo3g==
X-Gm-Message-State: AOAM531tG9Ttc1o9CDZ4pkqLAV5sD0eKJM0wrOTD7h/vy2clqxFkV5n1
        gpGBsu9OOsbm+R7jf4YA370Vc39Mqq1xGig2
X-Google-Smtp-Source: ABdhPJwyauEqxMyRli0WFhFKwtbavQziZ1teAwruWhlP593u7xLqbMCOhs2ilqv+bWCjznUs3/nDlw==
X-Received: by 2002:a63:d607:: with SMTP id q7mr11613672pgg.268.1629336996909;
        Wed, 18 Aug 2021 18:36:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c14sm1157826pgv.86.2021.08.18.18.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 18:36:36 -0700 (PDT)
Message-ID: <611db5a4.1c69fb81.2ddd6.5e78@mx.google.com>
Date:   Wed, 18 Aug 2021 18:36:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.12-1-g3b7bb0adff56
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 159 runs,
 4 regressions (v5.13.12-1-g3b7bb0adff56)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 159 runs, 4 regressions (v5.13.12-1-g3b7bb0a=
dff56)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.12-1-g3b7bb0adff56/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.12-1-g3b7bb0adff56
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3b7bb0adff56c7519a6bb1566cd89893c9354d9b =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/611d865b666ce8a797b13668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
1-g3b7bb0adff56/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
1-g3b7bb0adff56/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d865b666ce8a797b13=
669
        new failure (last pass: v5.13.8-35-ge21c26fae3e0) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/611d8508d9845135e3b13675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
1-g3b7bb0adff56/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
1-g3b7bb0adff56/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d8508d9845135e3b13=
676
        failing since 21 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/611d846b6dc11075fdb13677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
1-g3b7bb0adff56/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
1-g3b7bb0adff56/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d846b6dc11075fdb13=
678
        failing since 12 days (last pass: v5.13.8-33-gd8a5aa498511, first f=
ail: v5.13.8-35-ge21c26fae3e0) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/611d839871c6aeb002b13673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
1-g3b7bb0adff56/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
1-g3b7bb0adff56/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d839871c6aeb002b13=
674
        new failure (last pass: v5.13.11-151-g712b967cfd54) =

 =20
