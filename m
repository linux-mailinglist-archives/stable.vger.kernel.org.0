Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564DF285F4B
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 14:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgJGMhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 08:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728081AbgJGMhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 08:37:48 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3979AC061755
        for <stable@vger.kernel.org>; Wed,  7 Oct 2020 05:37:48 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id o8so937975pll.4
        for <stable@vger.kernel.org>; Wed, 07 Oct 2020 05:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wXBxya3uDQOFbsmk0q65tNDyx7Jxs9xx/9qlB6emdZQ=;
        b=N3g8RZnvBvD1aMXmpmX8/zHGAsn2sBkMhH5a3tkD+VAnPyVvG/5XcnI/2Fh/Y6m9Lh
         xhKMSv89HEUvSc35z+vmOO6hNXCFe2PXVp16DtXdYnu+gWKFCwDfGVpQ0npxQQI2HZos
         zWq1+TOu/I3YJ0KGlOa4KH0ZPHiHtK6oSbbtIhVqrRxSiqk2NV7wukXzLc62tU4HKfDP
         Dw7h1y7jir0JHtVf2YGUVab6amkK32K3g07FIqkHt53RhXL+wQUnEAcOj0SqElcEdXCn
         6E3WV8N6gIfqDmCL7xGW7Ckm696xdEPH+YFZ3eaGvDfEH6nm66exdB8L9yxjrk/rOI/V
         HBYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wXBxya3uDQOFbsmk0q65tNDyx7Jxs9xx/9qlB6emdZQ=;
        b=VsmU28zdRrc/S04G+WSreFtxhdA610rnPEsbZha5ohaVCkXWCOBawm3Gyr9QYESNum
         Qjfmg35AByC+YaiDbpcUyJILbHU5R8AdZwdmFhflHx4Z5FuoHI43e6gLlqtGG95JvFsu
         xE6ZB1gsom+IFVVftzCyJ69+Vb4yFqnInhaUJckqFGVM0YjiJUmfugOc6BHGRw5/73LB
         IHOM4huNzjhrWoA6BHO1dhG20QlmBntexzTYS0v1uKfNVYPaGwcpV6M4AqeCZSWOmcH0
         8PANfx5lSPfSCrUkt4dTVNFUdVc6HUCJCvTEUTsteLv6WYw8Jpkv/ndKB9hSWr25oA5Y
         GxCQ==
X-Gm-Message-State: AOAM53252kU16m81jdCzRg5W6cN20TqXfruTjmqPZALMw1w21F284+AC
        ifePMgAmKIa7czft6ifo6Oo7RxuuBeJRTQ==
X-Google-Smtp-Source: ABdhPJzhbWr7rfkw0d2YpZeY/rnqpjKe2i23MTxP8Sj1R7L7Ba/pHkEL3Yl9PDZChgsXFnA8rFnDgg==
X-Received: by 2002:a17:902:6a8b:b029:d3:b4d2:11f0 with SMTP id n11-20020a1709026a8bb02900d3b4d211f0mr2685936plk.2.1602074267064;
        Wed, 07 Oct 2020 05:37:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x4sm3001891pfm.86.2020.10.07.05.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 05:37:46 -0700 (PDT)
Message-ID: <5f7db69a.1c69fb81.1bb41.58b0@mx.google.com>
Date:   Wed, 07 Oct 2020 05:37:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.14
X-Kernelci-Branch: linux-5.8.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.8.y baseline: 133 runs, 7 regressions (v5.8.14)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.8.y baseline: 133 runs, 7 regressions (v5.8.14)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 results
------------------+-------+---------------+----------+--------------------+=
--------
bcm2837-rpi-3-b   | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 3/4    =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 63/69  =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.8.y/kernel/=
v5.8.14/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.8.y
  Describe: v5.8.14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      70b225d0a8ca1242e8a75ded86b806070ec71b2f =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 results
------------------+-------+---------------+----------+--------------------+=
--------
bcm2837-rpi-3-b   | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f7d77a76af53559e54ff3f1

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.8.y/v5.8.14/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.8.y/v5.8.14/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f7d77a76af53559=
e54ff3f5
      new failure (last pass: v5.8.12)
      1 lines

    2020-10-07 08:07:10.450000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-07 08:07:10.450000  (user:khilman) is already connected
    2020-10-07 08:07:26.042000  =00
    2020-10-07 08:07:26.042000  =

    2020-10-07 08:07:26.042000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-07 08:07:26.042000  =

    2020-10-07 08:07:26.042000  DRAM:  948 MiB
    2020-10-07 08:07:26.057000  RPI 3 Model B (0xa02082)
    2020-10-07 08:07:26.145000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-07 08:07:26.177000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (381 line(s) more)
      =



platform          | arch  | lab           | compiler | defconfig          |=
 results
------------------+-------+---------------+----------+--------------------+=
--------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 63/69  =


  Details:     https://kernelci.org/test/plan/id/5f7d8283fbfc2226dd4ff3f2

  Results:     63 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.8.y/v5.8.14/arm=
/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.8.y/v5.8.14/arm=
/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-dev-driver-present: https://kernelci.org/test/c=
ase/id/5f7d8283fbfc2226dd4ff3f6
      new failure (last pass: v5.8.13)

    2020-10-07 08:55:21.778000  <8>[   13.050763] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-dev-driver-present RESULT=3Dfail>
     * baseline.bootrr.cros-ec-dev-probed: https://kernelci.org/test/case/i=
d/5f7d8283fbfc2226dd4ff3f7
      new failure (last pass: v5.8.13)

    2020-10-07 08:55:22.809000  <8>[   14.083150] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-dev-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-i2c-tunnel-driver-present: https://kernelci.=
org/test/case/id/5f7d8283fbfc2226dd4ff3f8
      new failure (last pass: v5.8.13)

    2020-10-07 08:55:23.853000  <8>[   15.125291] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-i2c-tunnel-driver-present RESULT=3Dfail>
     * baseline.bootrr.cros-ec-i2c-tunnel-probed: https://kernelci.org/test=
/case/id/5f7d8283fbfc2226dd4ff3f9
      new failure (last pass: v5.8.13)

    2020-10-07 08:55:24.895000  <8>[   16.167848] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-i2c-tunnel-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-keyb-driver-present: https://kernelci.org/te=
st/case/id/5f7d8283fbfc2226dd4ff3fa
      new failure (last pass: v5.8.13)

    2020-10-07 08:55:25.936000  <8>[   17.209050] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-keyb-driver-present RESULT=3Dfail>
     * baseline.bootrr.cros-ec-keyb-probed: https://kernelci.org/test/case/=
id/5f7d8283fbfc2226dd4ff3fb
      new failure (last pass: v5.8.13)

    2020-10-07 08:55:26.977000  <8>[   18.250668] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-keyb-probed RESULT=3Dfail>
      =20
