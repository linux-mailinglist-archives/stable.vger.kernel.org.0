Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34EF93DD2CC
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 11:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhHBJTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 05:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbhHBJTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 05:19:07 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21099C0613D5
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 02:18:57 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l19so24433160pjz.0
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 02:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xcKoBB867Pd+vR+8r5rZ2VknwX1806yRZRYI1SnGjBY=;
        b=ngQnHFpKzRGUoz/mxbTKVu8DLafaKoHxIMrwbi2lc0ZIMukqsHp68apl5lveaOqy3t
         JpcV4XAQ3K4FH1UIdSjvKU73Zs7ox/UiveidEBRZgcF4tSdsy96bQXxx9MSNqs/724nt
         WJklL8If/rYc+dJQDkTjPhtb1LJE2vpzoeM+ikxikf3mA8RcYQjDkfx/Mu+lEI4HpJJG
         A0AsvFqzyYYoYZmpP5ag+mhOB0U/f1kt5gEGji7x9mj2VJ3f3YahlsGHbkbBpNIYhQMH
         3/rEfADKmrmfnxv4ScwqmzId3e4XBbDqMCACiyPEcfJ7TbZOM9lFQ8Z6gKoublQhd8F8
         leZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xcKoBB867Pd+vR+8r5rZ2VknwX1806yRZRYI1SnGjBY=;
        b=ZmewEvivhIZxfaig8IiyPRirCap+mM0Gjl4WP4nK6+JayumXOkTswoI6AxqICiFEPi
         s0XBCddOjUPKnJB4fEOlHgSBcTcFM2T1oNMPBTmJ+GkdI3YeJojg+/pQxKO+GpgsfcNT
         ahj16fQUFX0Ox5tVu4moqsBbQEz+aAtu8ogxGZDTaj84dz7znAD5uqGn0UC6jKtwEKrl
         iueOig+QdqVubbJoX//iC1dOM+sMxUGnrMoGXXZYCBKWKa0ORAvmTRvxW52ejZ5btaLz
         2eDe396+ggv89AIhXlhAfavJRkeVs2HssC5XdK7EuoYxYJwJFicvGam6ojS9ZO/S0BHh
         So9w==
X-Gm-Message-State: AOAM530f1j7UOW/d8uXKsDPy1eDNf2EknH5wQM0doLiQK29Icvw7yeaT
        QSyXTIYV3TE60TlvgYgJT4sAf6AV68mf0WMt
X-Google-Smtp-Source: ABdhPJxXPRqdIa/5rkyQCHM18hy6rFAcCF5EWaX6lT22+sUr7/bVloIDHswnq+2V0lxTHC+DFq2QNQ==
X-Received: by 2002:a05:6a00:180d:b029:331:bcb5:1589 with SMTP id y13-20020a056a00180db0290331bcb51589mr15833747pfa.27.1627895936544;
        Mon, 02 Aug 2021 02:18:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e16sm10412453pja.14.2021.08.02.02.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 02:18:56 -0700 (PDT)
Message-ID: <6107b880.1c69fb81.1bf9d.cfd8@mx.google.com>
Date:   Mon, 02 Aug 2021 02:18:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.55-59-gb0f0b0da3e3b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 181 runs,
 6 regressions (v5.10.55-59-gb0f0b0da3e3b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 181 runs, 6 regressions (v5.10.55-59-gb0f0b0=
da3e3b)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =

imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =

rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.55-59-gb0f0b0da3e3b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.55-59-gb0f0b0da3e3b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b0f0b0da3e3b420e0e018c21d1d76093a396c574 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6107852b61a7db84af85f473

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
59-gb0f0b0da3e3b/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
59-gb0f0b0da3e3b/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107852b61a7db84af85f=
474
        failing since 31 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6107840f8f4f93a30085f57a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
59-gb0f0b0da3e3b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
59-gb0f0b0da3e3b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107840f8f4f93a30085f=
57b
        failing since 1 day (last pass: v5.10.54-2-g41c54732efb5, first fai=
l: v5.10.55-27-ge0b8a9439c81) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/610789304a6861422685f467

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
59-gb0f0b0da3e3b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
59-gb0f0b0da3e3b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/610789304a6861422685f47b
        failing since 48 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-02T05:56:52.796853  /lava-4303857/1/../bin/lava-test-case
    2021-08-02T05:56:52.814482  <8>[   13.347027] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-02T05:56:52.814971  /lava-4303857/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/610789304a6861422685f493
        failing since 48 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-02T05:56:51.370360  /lava-4303857/1/../bin/lava-test-case
    2021-08-02T05:56:51.388255  <8>[   11.920385] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-02T05:56:51.388746  /lava-4303857/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/610789304a6861422685f494
        failing since 48 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-02T05:56:50.357238  /lava-4303857/1/../bin/lava-test-case<8>[  =
 10.900852] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-08-02T05:56:50.357548     =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6107839a18d019b7e885f578

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
59-gb0f0b0da3e3b/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
59-gb0f0b0da3e3b/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107839a18d019b7e885f=
579
        new failure (last pass: v5.10.55-57-gb2d53f9b52f5) =

 =20
