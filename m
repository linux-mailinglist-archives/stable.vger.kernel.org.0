Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF10C417FE2
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 07:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347850AbhIYFwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 01:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbhIYFwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 01:52:33 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF91C061571
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 22:50:59 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id c1so10694182pfp.10
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 22:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=od3+TuBB37wcHkpPAriqvzZneh8IvhiTQR6Nsd8T/Bo=;
        b=EQhn7ASYbiiEtD1839ralYaXyrD1yDB5klVkzJ3kn5CA6RPrLmO94Wmi7B9YRfJqFZ
         wJrmF9Y3Li+rUR1iT3FUuRU3HIsb4hdYIY8x11jZX5wOjWiX0ZFmRdzl3C9l5cggJTFF
         WGFirHc8xtoylvdSCMocnuitbGS0UfU76NZ1FK7R3Pj06/REVMIOAlD6rO/9g9aJWRfN
         dqrNxxmjq4CG4Rd0jnajp/vbp9VJf2+moa2eGgPOJFPtKSgd4ZKpWwiztesNjDhBmnhq
         djEK6plHJ5EEVGPI5a/bBfCRdFUuYVfdn7/D6u4o/dzubiFm1N53yLR+1dl+qJSUQOrg
         aH3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=od3+TuBB37wcHkpPAriqvzZneh8IvhiTQR6Nsd8T/Bo=;
        b=T55+BLxH0qw/MkgHcS2jjA88bre7vmhR4x6e7V43fKqI0/Jtn2umjJJ9wJEoEtZSmy
         S5C8LZtMR/UKNTFQ43EK1iR1z+1SdxT94Yn8wtzpXwmT3rQukOnBRQt8NyzN3zFegimt
         obaZwcSYogdQX1xbnwmLLC95WBGzrh4MoFINS2TDCx+wioxNMq12y2VpWd5wvevp3roc
         8o6p2/93rfniIbeYGj0ctyZJ1pHZYMj0Z0eGL6Y+EgJwXUzKhNdJDWaqD5GOTnsr8cxA
         ewYQAQOvDpdzUEwYankLC9XbPIye/S3HJsDpZ6jQJ0cSUZGOYB2VrlKXgpXMIdLk2KCC
         J5BA==
X-Gm-Message-State: AOAM531XA/BN8dDDmFNx8uZ/WoU5uskOlrdr1wDGxlfyRLAy6BbZLKCr
        YpH6jYTRw2h5QlRo3EwXLKE8Wei7a4yizlm5
X-Google-Smtp-Source: ABdhPJznXMaW6iRS4Nse+bm19yAMS3crVZUrCoyJbK2YxpCcen1ed7oSvsldgwee+kLzXid2D3tdmw==
X-Received: by 2002:aa7:88c9:0:b0:447:d8c5:5d60 with SMTP id k9-20020aa788c9000000b00447d8c55d60mr13491949pff.34.1632549058479;
        Fri, 24 Sep 2021 22:50:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b7sm11438256pgs.64.2021.09.24.22.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 22:50:58 -0700 (PDT)
Message-ID: <614eb8c2.1c69fb81.1b912.6544@mx.google.com>
Date:   Fri, 24 Sep 2021 22:50:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.68-64-g60451d2e78d5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 104 runs,
 6 regressions (v5.10.68-64-g60451d2e78d5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 104 runs, 6 regressions (v5.10.68-64-g6045=
1d2e78d5)

Regressions Summary
-------------------

platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre  | gcc-8    | multi_v7_defco=
nfig | 2          =

rk3288-veyron-jaq        | arm  | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =

tegra124-nyan-big        | arm  | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.68-64-g60451d2e78d5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.68-64-g60451d2e78d5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      60451d2e78d512a2a991f8d2481c94f28a67bea0 =



Test Regressions
---------------- =



platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre  | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/614e81573f4f5b41bb99a2fa

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
8-64-g60451d2e78d5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q=
-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
8-64-g60451d2e78d5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q=
-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/614e81573f4f5b4=
1bb99a301
        new failure (last pass: v5.10.68)
        4 lines

    2021-09-25T01:54:13.788541  kern  :alert : 8<--- cut here ---
    2021-09-25T01:54:13.819467  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2021-09-25T01:54:13.819730  kern  :alert : pgd =3D (ptrval)
    2021-09-25T01:54:13.820828  kern  :alert : [<8>[   39.408983] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2021-09-25T01:54:13.821091  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/614e81573f4f5b4=
1bb99a302
        new failure (last pass: v5.10.68)
        26 lines

    2021-09-25T01:54:13.871228  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2021-09-25T01:54:13.871502  kern  :emerg : Process kworker/1:8 (pid: 71=
, stack limit =3D 0x(ptrval))
    2021-09-25T01:54:13.871977  kern  :emerg : Stack: (0xc30a3eb0 to<8>[   =
39.454921] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2021-09-25T01:54:13.872221   0xc30a4000)
    2021-09-25T01:54:13.872439  kern  :emerg : 3ea0<8>[   39.466521] <LAVA_=
SIGNAL_ENDRUN 0_dmesg 885228_1.5.2.4.1>
    2021-09-25T01:54:13.872654  :                                     1e9b1=
0fe cf404616 c213e680 cec60217   =

 =



platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq        | arm  | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/614e84f753ef9f262f99a2e6

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
8-64-g60451d2e78d5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
8-64-g60451d2e78d5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/614e84f753ef9f262f99a2fa
        failing since 102 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-09-25T02:09:34.003614  /lava-4581290/1/../bin/lava-test-case<8>[  =
 13.916781] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-25T02:09:34.003935     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/614e84f753ef9f262f99a311
        failing since 102 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-09-25T02:09:32.575008  /lava-4581290/1/../bin/lava-test-case
    2021-09-25T02:09:32.592061  <8>[   12.491938] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-25T02:09:32.592362  /lava-4581290/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/614e84f753ef9f262f99a312
        failing since 102 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-09-25T02:09:31.554312  /lava-4581290/1/../bin/lava-test-case
    2021-09-25T02:09:31.559688  <8>[   11.471685] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
tegra124-nyan-big        | arm  | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/614e87a7e618b42e0499a2e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
8-64-g60451d2e78d5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-tegr=
a124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
8-64-g60451d2e78d5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-tegr=
a124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614e87a7e618b42e0499a=
2e5
        new failure (last pass: v5.10.68) =

 =20
