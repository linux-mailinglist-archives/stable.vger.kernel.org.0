Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D0341323D
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 13:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhIULFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 07:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbhIULFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 07:05:01 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6036C061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 04:03:33 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id q23so17008979pfs.9
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 04:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VkBEjbXII7qVchV1/rEZ/mvIrfEOgY8t+WUJSWgK9hc=;
        b=OwS3ar+Qjr6ZbSRtv7umyay9dSakH422B5+bfUyxEdiCrosqlfOtI0wbkJGeBR1Jhg
         HHEFc5oRmWoFUnF3MgZkY1QgxNuAqkWA0LDZWiaMb2D3QiFRF9HDOqyKMXrOgIFU8Ia+
         2nJFN4vxGWSrNUVT+aGcTJnwuugeWa5bmuGtIIQbfuCJUVGFNDgGY0lbPSEmglpdQrz3
         SUDjBw0tYtMMA0eazGGF1hIkKhY7kkstyNhopk008jhF6BuxtyxbcrYwV4jOaAooidRp
         VpXMfddZQSRMdhyXWtkm9XNUJvLx3EDEAsn6Ab5b+g/5QzZkWZ63Grwe33bqwmGqWkFZ
         4nSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VkBEjbXII7qVchV1/rEZ/mvIrfEOgY8t+WUJSWgK9hc=;
        b=3kP8TWdJ05Tcfwt5EsYBrFqQ/Ub5OSe4Em1S++UAj6n3qbKFltHzde4n0efdz4Hs5J
         g4TES7IQ4eIGZLydK7DYV/sPMKau58rnMrBRLu9Z7YmEtM7BGn1FqIXnY8Hz+wuhTh2w
         ByQ3Tif3Db4ZNiDzc04yV8yTgaa9VlHRUXLji6IzJU8sHeElJWQZGpZffGohvuOqjrSu
         CyrgLoesYbfo+SxUXZFtPxMSp3mmGNU8yOPArhiGehVCtRMuVFhItoX4BNYcPZ8gdLVK
         fU1fy4QS1XSGeuv8Fa7i5+mmUdD/OPzj9y1kYF5kpGwwEQFHr+BBejDJZrwp4un8xLY5
         EfXA==
X-Gm-Message-State: AOAM5328mbzFmvHgQN8pYK9gijQDoEBf51FVo2yHo4K3JPgYuiXVSvjA
        XOrOKncNLzKkWor+f+cQnefW0ACcJyx/E5V7
X-Google-Smtp-Source: ABdhPJzHqEm6MDYHooVG0sNmJSUo7iO7kB/8PEMAtDIOiP/RK0UlLhn23VVzLfpcs5rdgqEgZZBqXg==
X-Received: by 2002:a63:d34f:: with SMTP id u15mr27795148pgi.200.1632222212913;
        Tue, 21 Sep 2021 04:03:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y9sm1957918pfm.129.2021.09.21.04.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 04:03:32 -0700 (PDT)
Message-ID: <6149bc04.1c69fb81.c23d4.4c94@mx.google.com>
Date:   Tue, 21 Sep 2021 04:03:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.67
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 166 runs, 4 regressions (v5.10.67)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 166 runs, 4 regressions (v5.10.67)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxbb-p200   | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.67/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.67
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      faf816b0f8d0fa8ea24f579fb6a51e5ed3efd750 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxbb-p200   | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61498690e25d836ed399a30a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.67/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.67/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61498690e25d836ed399a=
30b
        new failure (last pass: v5.10.64) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/614985ada6290bc33399a2e4

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.67/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.67/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/614985ada6290bc33399a2f8
        failing since 96 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-09-21T07:11:13.484713  /lava-4547514/1/../bin/lava-test-case
    2021-09-21T07:11:13.501590  <8>[   13.786864] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/614985ada6290bc33399a310
        failing since 96 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-09-21T07:11:12.060688  /lava-4547514/1/../bin/lava-test-case
    2021-09-21T07:11:12.079170  <8>[   12.363640] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-21T07:11:12.079591  /lava-4547514/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/614985ada6290bc33399a311
        failing since 96 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-09-21T07:11:11.042642  /lava-4547514/1/../bin/lava-test-case
    2021-09-21T07:11:11.047862  <8>[   11.344173] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
