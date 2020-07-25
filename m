Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3369522D8E9
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 19:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgGYRZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 13:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726904AbgGYRZc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jul 2020 13:25:32 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B0DC08C5C0
        for <stable@vger.kernel.org>; Sat, 25 Jul 2020 10:25:31 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id u5so6906717pfn.7
        for <stable@vger.kernel.org>; Sat, 25 Jul 2020 10:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DqIrDwUajT5UhojeuG7UB3vdMOHnd4OSFX8cSjTRvGA=;
        b=1Y3W5P7ajK/Kk4YEqXyczyfT18i9hRBT3zrbbYRnOJy4eD3lUXH5XcrQanLCwOyyG9
         CpYvDYFEEqjiSf/9gyrqlhlkkE8siUHT35c/8d8qB9Id37F0Mn7vWA8w2hrtvv0VWH6y
         d+frFfn3yHGzsvwg+zK5dclfI3b/FwYv32pc1Kf70+xgDXTZIVXZAwrRAkphyT2Z5RlR
         yEeYWyw4RZ8PGLSSZgqzu/1gEYFFkLiH9l3feT2jm1O9Hc7Mz4wzWL/JcAQfAWkPh90y
         742da9Nt7MluL/iiPTAM3KgHxe5tAOyzhXN37Wa5Zw+/bt2wArqG6gGYOHtwWdfUspry
         mkEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DqIrDwUajT5UhojeuG7UB3vdMOHnd4OSFX8cSjTRvGA=;
        b=J3BSgSG28BxbHwsA7WYo3m9cBQ0z10Ma8mdJpXU7jn/bRKhPaPRVLLK1Ms7tE9iRD8
         9uMrhwNhUJTTrgj/akOyZwtDX/spCBPvw6OhSNhm2JJgFR1E+KRJme1d9N/CRcJBkiJQ
         mEEcgeJTEz77/icI74wnKAXpUaLts1Z4SUXwwiLiDWQsaDDnI6qUc/BI75k5XdsH+QsA
         tny44AUVP8wrH8Y0/vjxKCHO0IS+Ef80YqP3hGIKc6Yapg8u1R+dykf9UNtzmQWnNWCw
         KHSe6oOEHnpsGVrHNqUhExP29+wE3aJNKXmEVViG5TnbgYo8Ejpo3bgNaf3OP7LEFHNs
         85aw==
X-Gm-Message-State: AOAM530F6lLdYXtHeiTac6OhS60JESC1He3p3DumvBzFp2bnAAdGq6IQ
        gIEokSaxqK6TUwSOhZDNhenT91ycRE8=
X-Google-Smtp-Source: ABdhPJzZBJOjwLOS9hsGSh98/ulPuyUjOu6Rkmvg4LznDdV2jM6ZKq3ZTqEBiGp+cvWLc6+KJuZwXA==
X-Received: by 2002:a63:6744:: with SMTP id b65mr13456212pgc.42.1595697930776;
        Sat, 25 Jul 2020 10:25:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a10sm324538pfk.26.2020.07.25.10.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 10:25:30 -0700 (PDT)
Message-ID: <5f1c6b0a.1c69fb81.b2f27.0ae8@mx.google.com>
Date:   Sat, 25 Jul 2020 10:25:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.7.10
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.7.y
Subject: stable-rc/linux-5.7.y baseline: 178 runs, 4 regressions (v5.7.10)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 178 runs, 4 regressions (v5.7.10)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | results
-------------------------+-------+--------------+----------+---------------=
-----+--------
at91-sama5d4_xplained    | arm   | lab-baylibre | gcc-8    | sama5_defconfi=
g    | 0/1    =

imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 3/5    =

meson-gxl-s905d-p230     | arm64 | lab-baylibre | gcc-8    | defconfig     =
     | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.10/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.10
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      780e72b005455d117e2f733707ceca14792a67f1 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | results
-------------------------+-------+--------------+----------+---------------=
-----+--------
at91-sama5d4_xplained    | arm   | lab-baylibre | gcc-8    | sama5_defconfi=
g    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f1abcff027d8f1b1f85bb31

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.10/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.10/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f1abcff027d8f1b1f85b=
b32
      failing since 7 days (last pass: v5.7.8-167-gc2fb28a4b6e4, first fail=
: v5.7.9) =



platform                 | arch  | lab          | compiler | defconfig     =
     | results
-------------------------+-------+--------------+----------+---------------=
-----+--------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f1abd9b699794f7b385bb2e

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.10/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboard=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.10/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboard=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5f1abd9b699794f=
7b385bb32
      new failure (last pass: v5.7.9-244-g7d2e5723ce4a)
      4 lines* baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f1a=
bd9b699794f7b385bb33
      new failure (last pass: v5.7.9-244-g7d2e5723ce4a)
      35 lines =



platform                 | arch  | lab          | compiler | defconfig     =
     | results
-------------------------+-------+--------------+----------+---------------=
-----+--------
meson-gxl-s905d-p230     | arm64 | lab-baylibre | gcc-8    | defconfig     =
     | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f1c0feb310f01ad9285bb31

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.10/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.10/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f1c0feb310f01ad9285b=
b32
      new failure (last pass: v5.7.9-244-g7d2e5723ce4a) =20
