Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EF6424D3D
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 08:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240184AbhJGGWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 02:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240281AbhJGGWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 02:22:46 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659D4C061746
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 23:20:52 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id v11so4680662pgb.8
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 23:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rTCUR1AXEeiniGY7rlRXoAciTpENkhbzdwimC94N9tg=;
        b=syxffHQgQyQgNVZV8IrV5QY8dVgbJVp8uoCbQ1AYZsiEvyFrO6XhA3jabKy7vsbCYk
         ktZgSGQXEPGTBODNbSfraanKBefd1rZO29CKfqmg88HHsdryqXNAXK4azsP4PuWKiK0C
         ACsB2XLdsUll0kWnLh/ImsUUKhkwiUrwqlC7JsTu/lyBfkPBdEGV6c14ha+nTYYx+R78
         5pIkt7Ef/D+/FrchHdM2JddS7HbaIpT/WzzdUMzLehtHcBcaKmtfxz0yQkQnMHSmHI62
         BKq3/zgk2kctm+KzTMSrP+FjOEm4WVQHvRXYXF/QuQeSuf01L8uwtzfrEDVrIRr8DcTe
         vJ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rTCUR1AXEeiniGY7rlRXoAciTpENkhbzdwimC94N9tg=;
        b=a9YGYw29irpakvHd3QXweyYai8xDG6zyxyYnTr5eTA0GUiNN2zMma+ZpN5aT/utF87
         3zLqmsNRbqZmQKWYk5wbSV7av27eQpqr5wgm27tuNJ8XOc6n7SdXfXyMROB307so+EBl
         JAB7Fhw20f+kHGFc37Ly1OSrqRo61N3JLaty4b07RfgdXzob075s7y2aGDh467IqbOgA
         JTuUmqRNEBPd8l4OTc9CcDqEHskatAnkhhNLjXsU2SDd5yAeGQosOG2IZZU8XstOcHas
         w6wF7/svjCtSNoGDmIYOlcBrSuXC+3llorZSbAEvNsOdOS7CFLK4ch0ly0IkwELUOrg6
         CeQg==
X-Gm-Message-State: AOAM531eCmjkihi9UW1LupD6mK3oEjxVRw7G4Uq5yO5sTRDZob9IxCzW
        BkYwZiwl33k53g60fNahju3BW9hFxyQrxqGo
X-Google-Smtp-Source: ABdhPJy6+Zr4Boggf9LunzYSkhVJs4gk7pFL7jBpd0EsVM/ONolgVl7guTzH+aY/h/tPFyrqzTrDMQ==
X-Received: by 2002:a62:1ac3:0:b0:44b:85d0:5a98 with SMTP id a186-20020a621ac3000000b0044b85d05a98mr2337077pfa.18.1633587651773;
        Wed, 06 Oct 2021 23:20:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a17sm11741439pfd.54.2021.10.06.23.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 23:20:51 -0700 (PDT)
Message-ID: <615e91c3.1c69fb81.9b326.4020@mx.google.com>
Date:   Wed, 06 Oct 2021 23:20:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.71
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 159 runs, 5 regressions (v5.10.71)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 159 runs, 5 regressions (v5.10.71)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =

imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.71/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.71
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5cd40b137cba45a5a3d0b9a8554f779a3e0e93b4 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/615e61c0978d01938299a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.71/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.71/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615e61c0978d01938299a=
2e0
        failing since 14 days (last pass: v5.10.64, first fail: v5.10.68) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/615e6243bbf4fa8d2f99a3f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.71/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.71/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615e6243bbf4fa8d2f99a=
3f6
        new failure (last pass: v5.10.68) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/615e70d3c8dff2d87299a2de

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.71/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.71/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615e70d3c8dff2d87299a2f2
        failing since 112 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-10-07T04:00:08.691213  /lava-4659802/1/../bin/lava-test-case<8>[  =
 13.448026] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-10-07T04:00:08.691567  =

    2021-10-07T04:00:08.691778  /lava-4659802/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615e70d3c8dff2d87299a308
        failing since 112 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-10-07T04:00:07.247041  /lava-4659802/1/../bin/lava-test-case
    2021-10-07T04:00:07.264622  <8>[   12.021695] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-10-07T04:00:07.264877  /lava-4659802/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615e70d3c8dff2d87299a309
        failing since 112 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-10-07T04:00:06.227437  /lava-4659802/1/../bin/lava-test-case
    2021-10-07T04:00:06.233143  <8>[   11.001880] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
