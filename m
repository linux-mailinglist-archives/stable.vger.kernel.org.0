Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752E1413485
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 15:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbhIUNmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 09:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbhIUNmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 09:42:00 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CD7C061575
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 06:40:32 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id 5so13376978plo.5
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 06:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UQbXdli0pZIb7ZIZ+7Q8AzB6BXryXnLnQL8YgbK9UhA=;
        b=HpnufTUjYJ+eiTb89zGkU7KINSRzFHAkXEhLPXffuaWyDbB0LGp2QsnjaaYj0tbkOC
         YohXGyfs992N7n0A9+ZpDE4fIKr3C1P49J5FuIJ/PSO+Ot16AfjvO8qh1R8aDxnq9zyo
         +PbZnwwRt20q0x+vHLvTeGZntLwjsTFryWt2Uc9Wykl328KWS9Gtkp/0MAu6I2Qo+/w8
         Er9mqGhInCPSWuDelIOdV2/wAeKZLQNphYVmSb7++1ALm+ZuJ3X0M8+6PQFn59SfuAD8
         /K42sOmgARfGzj1lW7uRwqei+APRGiLd/hIlodCjhvIitjLeX73eeE2CDWJSPDlpGuPA
         THtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UQbXdli0pZIb7ZIZ+7Q8AzB6BXryXnLnQL8YgbK9UhA=;
        b=Hfk3ei8xCSC8XqLu6novvjVNWZ2wHylBF9GMbX3EAUovpFoOya2RMzeZ0zFLQjEgdt
         fiZa2F44MvrR3sDJr5d1z2kSMsyaFCuJ3Ddn/JgSBckB7lmgHYCdwR5T3IXdJ062OMtl
         FJ88z694YwVJvVkDUh+csLKWv8buufQfyk3wE58y0meALI9usG/TUp5SRb5eynl+9M7z
         mTqHHU+NMmgPt/kU1FUeNgr0usDBzFho8QixcnAHaXW3FI/BH5Dp+FSi5+5LoMfhUflV
         9lPh3OIfkoV+vqugSPNoNVnm704kGfX8a3IW9pkLYPagG1tAFtQEmH97umx+QsXD4frd
         osWw==
X-Gm-Message-State: AOAM531xS7fQ/868sfX+UftJJR+sT8S+HaXiQUJ1JPEmGSy8KIAlpCDZ
        R6BH1+5ccZYT0pm9b2h+56t6mPiUAEhIUVxL
X-Google-Smtp-Source: ABdhPJyMIyRkY0GevHayOJ4JLVDI43LmBMcaqEtirhRgGSGa6pQjZWpVPXB5qS8efmQe8g0lxMvqow==
X-Received: by 2002:a17:90a:4a03:: with SMTP id e3mr3879050pjh.198.1632231631945;
        Tue, 21 Sep 2021 06:40:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a10sm17309051pfn.48.2021.09.21.06.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 06:40:31 -0700 (PDT)
Message-ID: <6149e0cf.1c69fb81.50c2c.0de5@mx.google.com>
Date:   Tue, 21 Sep 2021 06:40:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.67-125-gbb6d31464809
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 169 runs,
 4 regressions (v5.10.67-125-gbb6d31464809)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 169 runs, 4 regressions (v5.10.67-125-gbb6=
d31464809)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.67-125-gbb6d31464809/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.67-125-gbb6d31464809
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bb6d31464809e017d8cfd65963f6e802d7d1c66b =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6149aaf92079d3758e99a2e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
7-125-gbb6d31464809/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
7-125-gbb6d31464809/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149aaf92079d3758e99a=
2e8
        failing since 81 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/6149bf411769dcc0f299a2f6

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
7-125-gbb6d31464809/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
7-125-gbb6d31464809/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6149bf411769dcc0f299a30a
        failing since 98 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-21T11:16:54.364322  /lava-4549262/1/../bin/lava-test-case<8>[  =
 13.974406] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-21T11:16:54.364753  =

    2021-09-21T11:16:54.364948  /lava-4549262/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6149bf411769dcc0f299a322
        failing since 98 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-21T11:16:52.940475  /lava-4549262/1/../bin/lava-test-case<8>[  =
 12.550018] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-21T11:16:52.940858  =

    2021-09-21T11:16:52.941053  /lava-4549262/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6149bf411769dcc0f299a323
        failing since 98 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-21T11:16:51.903249  /lava-4549262/1/../bin/lava-test-case
    2021-09-21T11:16:51.908427  <8>[   11.530563] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
