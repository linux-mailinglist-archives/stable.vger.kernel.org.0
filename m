Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94693DE0C4
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 22:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhHBUiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 16:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbhHBUiX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 16:38:23 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDCEC061760
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 13:38:12 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id u2so12790342plg.10
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 13:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lIACwDGPWiSMIUXxnhJ75hmEH/D+tEiwn07U3vfkHco=;
        b=ztIM59vRO2OfFGvivuL+X+uCHjZzCqt17uAoW0w+Kmm+uYDrAXOt8MKX8Ek9m7pUup
         txN4amDmeoUqrngibu7dVu7ot6USYpdCgfVSrKfjQp5mlwgc6b8+8AUHNKXXg7jien48
         h5ZenY4AYruLrqt0d98T7QjlGq9T7n9k4OhfxzH1oUJhocV8ge4XFueXSU4BGATtX3Rh
         9B4MwLht8TiABl5fLHdZyvmcWvbk2P/fhubG8x39iqKptX2yBDQp1Dz/4jxXqDhn5BXr
         MJerarM2cJlxewU6PaKuf7FUDJ+vlvO0MHEdSaKS2FYpi1+H1Ar7ED4MZ384lTsiMXV8
         kixQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lIACwDGPWiSMIUXxnhJ75hmEH/D+tEiwn07U3vfkHco=;
        b=HeLWRvSjl195D3gR78TE6c+HLAS34tBYnKYXaZR45XFe/LGI9yZholwG57WkkD4Czh
         pdjcoY+6cMAbwiCBcuhy1Jq7de2W5ykESbAdDyYIq2XiOod6PHHf0QAY4pjKoiQMlJ/D
         N2qimwVkICbKFj9wy2Qicqe2oLiJCDK2wmLcNZbYa0uaCjLxCO4S7ctyfmwDhcFh5lkp
         RlIuMfOkZ1Ujd+lXO46OehbT3VBOfr6kvv3MQTg1YKUSUeCr3eJ4piijLsKQEpiN4uE+
         jdfVPG2hicPHwied5vIGPgei2hNT5abKgkuCSyez5Wi9xHlVBsAl0licZAS3/Z/8vezm
         fMpA==
X-Gm-Message-State: AOAM532QLKuV52V+6ycYnUt6PgzFWkSGlDkCYYvE14sjAgF7pMu1+6Ai
        jL07joUidSUIHqXwYccKSTZWWMqtV42X6v6I
X-Google-Smtp-Source: ABdhPJzzb6varCZAlFBV/5nll7fOer9cIekWrraGiYGgmRmwYeLxqJ0o5ECl39H2Imd4VfXB6Y9mdQ==
X-Received: by 2002:a17:90a:4204:: with SMTP id o4mr632508pjg.199.1627936691737;
        Mon, 02 Aug 2021 13:38:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t1sm13956505pgp.42.2021.08.02.13.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 13:38:11 -0700 (PDT)
Message-ID: <610857b3.1c69fb81.ded6e.8a6f@mx.google.com>
Date:   Mon, 02 Aug 2021 13:38:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.7-105-gcd55ef855022
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.13.y baseline: 177 runs,
 2 regressions (v5.13.7-105-gcd55ef855022)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 177 runs, 2 regressions (v5.13.7-105-gcd55=
ef855022)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.7-105-gcd55ef855022/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.7-105-gcd55ef855022
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cd55ef855022f15ca361d562635918bb2738f143 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/610822d9e426c2dcc8b1366b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.7=
-105-gcd55ef855022/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.7=
-105-gcd55ef855022/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610822d9e426c2dcc8b13=
66c
        failing since 12 days (last pass: v5.13.3-350-g6c45a6a40ddee, first=
 fail: v5.13.3-349-g1d9dba03aebe5) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6108242e112459804ab13663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.7=
-105-gcd55ef855022/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.7=
-105-gcd55ef855022/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6108242e112459804ab13=
664
        failing since 18 days (last pass: v5.13.2, first fail: v5.13.2-254-=
g761e4411c50e) =

 =20
