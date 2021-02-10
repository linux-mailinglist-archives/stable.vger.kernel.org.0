Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B50317178
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 21:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhBJUfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 15:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbhBJUft (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 15:35:49 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8D7C061574
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 12:35:09 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id d26so2059924pfn.5
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 12:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8qETQL9xVVvjWchzFenKKK+pabNLO5DYal4FsvH0KS8=;
        b=iJWnaM6G2Gf66RgOEXu4NLYPdDl1mJEFf5Zwn8Iv+T4S5uG28fj4sNZRQIVSMiHMDl
         FN30rzlMeCNPTwh3fdt7X6MxLj6AYLwHRIcKz2kgJp8v2DcF2XWcTtiaCGEiWt/hHtc1
         M4cBW/vRdrTfWrypAey07N0VOSezu/vCjwYADey2Zz9EIRhCZNKdXN3BhsH/VYBUBgQ7
         /SpdO4VWxOZR8tvn57pp3lHJwE0PlL1K7YnQmoXVKCyiCFTHgumH5HBrCLdUXbV8z+Q4
         u2JErk5daK0QlTLiDfDmVqjhMn51aYTVFPWNDavtiqsyqLfR1Lm2PPLGNjUAUGhl6981
         PPSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8qETQL9xVVvjWchzFenKKK+pabNLO5DYal4FsvH0KS8=;
        b=keJvVHljw9NQpHlMlNmBvIuIDkzU8xslA328ny8kiTLGb/zribRbqI1W5YJkn5wUDK
         Tos79HxZoqYNTw/kfLKDzRTd+1XYaCaErd8fpfSaHok2rZhS0MKaEAlL/Vzm7PVCvbQv
         iHQEBgUHRYyheYsUNLsmHxmvueSfjHtbSEepUt0P9dxerb/4CVYaQQKhsTPPJz3CN8k9
         szkHW/ZGUM8q49F0AKCuZ7fnN2gjBNqDjPjW9yKib2ibcM8AgmIoHX2f7Zlo/COP7+j7
         uawL1W9NvNgIoLfEFEyElajIOGvvNr8S94wF8yPM/8/0VDyWqu1IJRtMJCtUGjjnhBQZ
         cnwQ==
X-Gm-Message-State: AOAM530yOHm2DtfcRQnIfnvgvl66MWDDal7Og4hK7HdU54CNHYZNiAj/
        mXpisRP4m0VHaqsT+t+9SWIO6iBsLpR2tQ==
X-Google-Smtp-Source: ABdhPJxgodPG3lrC2Zh8jPWrDsRPhor8LD9+hKe6DzzQ0bZsWaUB6BU9bzp6FtzW26Nzf4hclK7hNw==
X-Received: by 2002:a63:cd4f:: with SMTP id a15mr4681704pgj.105.1612989308248;
        Wed, 10 Feb 2021 12:35:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i67sm3287171pfc.153.2021.02.10.12.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 12:35:07 -0800 (PST)
Message-ID: <6024437b.1c69fb81.dec7e.75ac@mx.google.com>
Date:   Wed, 10 Feb 2021 12:35:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.220-34-gb8348ef67192
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 61 runs,
 2 regressions (v4.14.220-34-gb8348ef67192)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 61 runs, 2 regressions (v4.14.220-34-gb8348e=
f67192)

Regressions Summary
-------------------

platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =

panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.220-34-gb8348ef67192/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.220-34-gb8348ef67192
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b8348ef6719260ae0d4b0b99d1f22e4acf559d85 =



Test Regressions
---------------- =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =


  Details:     https://kernelci.org/test/plan/id/602410391b47c7d3993abe8f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-34-gb8348ef67192/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-34-gb8348ef67192/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602410391b47c7d3993ab=
e90
        failing since 64 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/602411cc77217272f33abea4

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-34-gb8348ef67192/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.220=
-34-gb8348ef67192/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602411cc7721727=
2f33abeab
        failing since 3 days (last pass: v4.14.219-15-g82c6ae41b66a6, first=
 fail: v4.14.219-15-g8b9453943a205)
        2 lines

    2021-02-10 17:03:04.958000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/103
    2021-02-10 17:03:04.968000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
