Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479793BBD6E
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 15:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhGENY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 09:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhGENY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 09:24:26 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D2EC06175F
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 06:21:49 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id a2so18293164pgi.6
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 06:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=auJ/njjOztwIxx9qvsnnPV/thVWKNlor3S1x/iF+EqQ=;
        b=EJ5e2rz3gZEgwGg1cOkV4IwuhSBrZdmAk67oDdkb44ENQux/6zZ3gEBvvCw/3NWxoB
         aZPAtRXhq+X9f7ZvO8K7iBkLEofIdWwyLlmlj2gUUchkx6PX4KGfc7TO7yKe9EXcemv+
         R0QxvVIH6gk2cheV63KN2lo8T5jAzhvcX1l62dGLpnBojXil1mjEiKeRiJhgNhyxMIn3
         cVobUc36ooALjUY5H/CtYkNhPE0rr/lzDGHUhrtwaW47vW+FOMAu0mj0aJ4iQlGj6CVK
         xXWDkBT14Fki9mRybC/UNwEJo5a+GXeTkC3Tam1Brgx8WakEAXaoC6BWEaS15PyOqyev
         6b7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=auJ/njjOztwIxx9qvsnnPV/thVWKNlor3S1x/iF+EqQ=;
        b=QkSlBV0LsGudD4hDn52EXumA09LBBQX2SDzBkLYsI8pP5eqnApxep5VTi2/0eDN+R7
         t7cPwwxfDz3NKU9E87rCsoLzyABUWMHIjRukPevUjzNYUMa14VmCXgWT9v15F//sau70
         HxE45ZKlMyoX50qjT/3J/GXweCrmrV9C0VqUgdFl/8vXQnAchRogtORWr3OVGrL+AGpw
         0GXt6gziqoUUmGnnl1iuJ99Baw//BN3d0JmRz5B4arscIuaLm9+YWZHZAzssevsjAO+C
         I8Z9QcXJ7P7bz5Mrzc4yLE60AfJoPahwVohNkGkhupW3Lc0rR3QvCgUYGvwAIWAoSLKy
         mQgA==
X-Gm-Message-State: AOAM530O/BO5l1GmmLaxfUyKXI8EmRERe+2nxy5uGYhsbm1+HmAvF0ya
        TJygrxOxK761Ew6+4HoVb04gGqiHPw5wVLsh
X-Google-Smtp-Source: ABdhPJxtAkGxq/EEuNfO24Rha5x4JCA6HVmKBApGioHXW3g26KrX7rykxzXih6bU07QuNoqYS+w4uA==
X-Received: by 2002:a63:f256:: with SMTP id d22mr15830488pgk.399.1625491308332;
        Mon, 05 Jul 2021 06:21:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h14sm9269478pgv.47.2021.07.05.06.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 06:21:48 -0700 (PDT)
Message-ID: <60e3076c.1c69fb81.96cf2.885c@mx.google.com>
Date:   Mon, 05 Jul 2021 06:21:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.47-7-gcdddae323831
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 184 runs,
 7 regressions (v5.10.47-7-gcdddae323831)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 184 runs, 7 regressions (v5.10.47-7-gcddda=
e323831)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre  | gcc-8    | bcm2835_defcon=
fig  | 1          =

hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =

imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =

rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.47-7-gcdddae323831/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.47-7-gcdddae323831
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cdddae323831fb389851e8cdd088987babc08a01 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre  | gcc-8    | bcm2835_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60e2d0701ab3f6a2aa117979

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
7-7-gcdddae323831/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
7-7-gcdddae323831/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e2d0701ab3f6a2aa117=
97a
        failing since 4 days (last pass: v5.10.46-101-ga41d5119dc1e, first =
fail: v5.10.47) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60e2da84cf28c36de5117984

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
7-7-gcdddae323831/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
7-7-gcdddae323831/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e2da84cf28c36de5117=
985
        failing since 3 days (last pass: v5.10.46-101-ga41d5119dc1e, first =
fail: v5.10.47) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60e2d7bb91021dad5e11796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
7-7-gcdddae323831/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
7-7-gcdddae323831/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e2d7bb91021dad5e117=
96b
        failing since 4 days (last pass: v5.10.46-13-g88b257611f2a, first f=
ail: v5.10.47) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/60e2db4294e3bbc8dd11797c

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
7-7-gcdddae323831/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
7-7-gcdddae323831/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e2db4294e3bbc8dd117994
        failing since 20 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-07-05T10:13:02.223728  /lava-4140541/1/../bin/lava-test-case
    2021-07-05T10:13:02.240844  <8>[   13.153554] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-05T10:13:02.241072  /lava-4140541/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e2db4294e3bbc8dd1179ac
        failing since 20 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-07-05T10:13:00.795896  /lava-4140541/1/../bin/lava-test-case
    2021-07-05T10:13:00.814046  <8>[   11.725722] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-05T10:13:00.814584  /lava-4140541/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e2db4294e3bbc8dd1179ad
        failing since 20 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-07-05T10:12:59.775597  /lava-4140541/1/../bin/lava-test-case
    2021-07-05T10:12:59.781554  <8>[   10.706029] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60e2d7b2e55b27206e11799d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
7-7-gcdddae323831/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
7-7-gcdddae323831/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e2d7b2e55b27206e117=
99e
        new failure (last pass: v5.10.42) =

 =20
