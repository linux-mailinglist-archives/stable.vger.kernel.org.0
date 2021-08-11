Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0003E899B
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 07:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbhHKFOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 01:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233813AbhHKFOP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 01:14:15 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7D6C061765
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 22:13:52 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id l11so1156526plk.6
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 22:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=07fQT+B/6xQ3vvySi+JFSirwA7RR65+/18JG7DRC5B8=;
        b=PMiBuqUGw92QogSjZqebvbzfAE5MLz7Pyuub4bwMREOgMjVuX7LPq50DdcZIoY6oBU
         vd0fxkBZRMrcntgK10X/QhpKHeBZo3FusOpuRA36zglLmFe/aOzo5GV/mZm+eUtbbQdW
         8TnW/OOHZzuH9Umgkx3SCnXRGicWkxZmyWRE2nkcWhV8Q3hKf3THoo5URcded24NkoW8
         nshx32hJrEze0i43vu5J5ThMaEenKroXUtb/U+A52eURPuge5Ed6iRlkn6ht+AN4piuf
         sy0BZykZybE7TdLARZgVe6yW4qj1Kk5/kJEEub957IcXjhQe49/+IcZeqqerWVUdzLy8
         KL9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=07fQT+B/6xQ3vvySi+JFSirwA7RR65+/18JG7DRC5B8=;
        b=LgPjV1fc4IfmdfdzGiRm8nVdQlEMCAioj64N7e422vGxUnw5y0aUAIB5Dt61M4AbKO
         PjcEV4V/4Z1U4Is6VhznrRdm21CSkhgepyQUawsYbdvs6bcx34r5iNRQ9/Mf+96jO66U
         hSly+J65amAKhq0TWKx+oBkcPiwGA/j+/deHlRvmxJKEVfwx/hkWb3/XEn5VTndXJ94w
         di38WKo+dGTe+V9AVGA+Wm22Vv2kmXRD2R5m4EnWfLU+AshCRDtS9YrM1FoyVil4vbR+
         9XfH475Gvew+uTLaVAgSZnVVeZQsc0EESaK7fjAKh4+wsSX5SyUGB7NhVKiND+LxdW/E
         +uMg==
X-Gm-Message-State: AOAM5321jQIStXKdzMoPsp74D5fChhnjBPDoBfOU3cnPVMCyIBlZYe8r
        TVpjPt4TaHa2rHCoyUvtSAttH+AD/f6P9RnR
X-Google-Smtp-Source: ABdhPJxTjzvktqtn98IUKQT2+IHWZOH9fQdPb1w19Y6d8c+i/WbtvO9RltBf+OgZA1KN8s8RNwMMmQ==
X-Received: by 2002:aa7:8a13:0:b029:3be:c2a:7a45 with SMTP id m19-20020aa78a130000b02903be0c2a7a45mr32796860pfa.8.1628658832042;
        Tue, 10 Aug 2021 22:13:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c21sm25450350pfo.193.2021.08.10.22.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 22:13:51 -0700 (PDT)
Message-ID: <61135c8f.1c69fb81.94a9c.c2c4@mx.google.com>
Date:   Tue, 10 Aug 2021 22:13:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.57-136-g252d84386e00
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 154 runs,
 4 regressions (v5.10.57-136-g252d84386e00)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 154 runs, 4 regressions (v5.10.57-136-g252=
d84386e00)

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
nel/v5.10.57-136-g252d84386e00/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.57-136-g252d84386e00
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      252d84386e003502ea789f777bda459363174184 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6113277d7a77949f2cb1367e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
7-136-g252d84386e00/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
7-136-g252d84386e00/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6113277d7a77949f2cb13=
67f
        failing since 40 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/61132b942d4fadff28b13663

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
7-136-g252d84386e00/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
7-136-g252d84386e00/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61132b942d4fadff28b1367b
        failing since 56 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-08-11T01:44:41.679076  /lava-4345604/1/../bin/lava-test-case
    2021-08-11T01:44:41.696364  <8>[   13.282582] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-11T01:44:41.696803  /lava-4345604/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61132b942d4fadff28b13693
        failing since 56 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-08-11T01:44:40.252030  /lava-4345604/1/../bin/lava-test-case
    2021-08-11T01:44:40.270106  <8>[   11.855632] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-11T01:44:40.270341  /lava-4345604/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61132b942d4fadff28b13694
        failing since 56 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-08-11T01:44:39.232494  /lava-4345604/1/../bin/lava-test-case
    2021-08-11T01:44:39.237382  <8>[   10.836135] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
