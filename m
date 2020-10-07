Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21E9285EEE
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 14:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgJGMSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 08:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728037AbgJGMST (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 08:18:19 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5B0C061755
        for <stable@vger.kernel.org>; Wed,  7 Oct 2020 05:18:19 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id l126so1237211pfd.5
        for <stable@vger.kernel.org>; Wed, 07 Oct 2020 05:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ej20ZFqBLuVD1CdXNzqTn76jA42Z2XTSitHHDKuwzxk=;
        b=Uj7wUZV64+/szavHFhplRrWDp6kRg6FjhKfmnUNMyfAYyBC8GzyXeLdumgsq7TJ5QC
         qu1oSJj33TnsUOhGnl9zKXZo8+e5Y9dm2JewqbBvuPRz8bT4ToF6PXbpUkC0ht8NyINA
         m7Mj2xpYfHoIwvaabQYfmVQj73/VN5L7CiTvv031izOFEYMjR9Kc4v/wEEKlT0ip1Z1q
         PfsKFPOM+4xOoeLnvuwLD2DWcwiGBugfroF6OWoQvMxtVoauhQnQx6nGuT2NdsNxM42V
         bbMhowf9h6mFNonJWlV423Zj7CbMR88HUPgI2gkIGxK9sjZyOyVsS3dy1542PjbFJJV9
         mihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ej20ZFqBLuVD1CdXNzqTn76jA42Z2XTSitHHDKuwzxk=;
        b=O178R+lZfgmrahRjOgRvcY0jDOY8dvqdLkUIVHgCPHYx9X9oh4E/XtIHfmMfnduTR1
         X6HivJsRrG/OoXQtFHJ8cvMx9EjassJZ+MaBVOZkPfvIIBdakvfujzkTx968IxZPvJnK
         SjHx/iwRxJGByuBWlonyYPxU12fwUnHTtb6RcvMvDHpd4k9Tf4w4toVa6DMjpK7S/ewU
         B13lsVfx5TLTE0yTVVgOSEVRRM2U7gd4FliMmdxTOLvWNDdMzYczYFwHWG6VR91KGSVz
         77pJLPkFB4ky0fJPMb90es6WMa/dROuwpW3UZEDqEiuQ9ePvrzTe4DQV4K0qHJa9sPBZ
         R0Gw==
X-Gm-Message-State: AOAM533sRpJY5KUFgd5CqkmgNzBwJU0vkJSNBbO3DBXV0IC0eLNnu5pX
        Cc2ysznmMRyj2InOyjPTfs68tHxZuR1Zzw==
X-Google-Smtp-Source: ABdhPJxDgkncImWfkwRG2WXqwmnjo5Fqf0MWJW50XsC0+DeXe7GDiRBgNOJqfwDuIBtydlzQT7DOcA==
X-Received: by 2002:a63:f741:: with SMTP id f1mr2659338pgk.38.1602073098830;
        Wed, 07 Oct 2020 05:18:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n7sm3093578pfq.114.2020.10.07.05.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 05:18:18 -0700 (PDT)
Message-ID: <5f7db20a.1c69fb81.11404.59ab@mx.google.com>
Date:   Wed, 07 Oct 2020 05:18:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.69-57-gf9fba2b4f8ec
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 132 runs,
 4 regressions (v5.4.69-57-gf9fba2b4f8ec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 132 runs, 4 regressions (v5.4.69-57-gf9fba2b4=
f8ec)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.69-57-gf9fba2b4f8ec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.69-57-gf9fba2b4f8ec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f9fba2b4f8ec9ce04a3c80ee4e970e901141d5d7 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f7d73c75b371cd7544ff409

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-57=
-gf9fba2b4f8ec/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-57=
-gf9fba2b4f8ec/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f7d73c75b371cd7=
544ff40d
      new failure (last pass: v5.4.69-57-g6e2946aac4c3)
      3 lines

    2020-10-07 07:50:01.598000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-07 07:50:01.598000  (user:khilman) is already connected
    2020-10-07 07:50:16.836000  =00
    2020-10-07 07:50:16.836000  =

    2020-10-07 07:50:16.836000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-07 07:50:16.836000  =

    2020-10-07 07:50:16.837000  DRAM:  948 MiB
    2020-10-07 07:50:16.851000  RPI 3 Model B (0xa02082)
    2020-10-07 07:50:16.940000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-07 07:50:16.972000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (386 line(s) more)
      =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f7d73706355a3db644ff401

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-57=
-gf9fba2b4f8ec/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-57=
-gf9fba2b4f8ec/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f7d73706355a3db644ff415
      failing since 7 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-07 07:51:04.243000  /lava-2698796/1/../bin/lava-test-case
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f7d73706355a3db644ff416
      failing since 7 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-07 07:51:05.264000  /lava-2698796/1/../bin/lava-test-case
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f7d73706355a3db644ff417
      failing since 7 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-07 07:51:06.286000  /lava-2698796/1/../bin/lava-test-case
      =20
