Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFC225E491
	for <lists+stable@lfdr.de>; Sat,  5 Sep 2020 02:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgIEANn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 20:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgIEANl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 20:13:41 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196EDC061244
        for <stable@vger.kernel.org>; Fri,  4 Sep 2020 17:13:40 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id z19so3297306pfn.8
        for <stable@vger.kernel.org>; Fri, 04 Sep 2020 17:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x7lbGdQ4hRxetxLMFaeyEpmySOrXasXMGFfmLa4O4UM=;
        b=WNIZ8McgvzUANMy5ZjuTOwW0PoSz6V4SnmNtCVHt7oZi7uuOLrB4Vcg7wQs1rdWsV3
         SFClYTzRIUyn0nrumDe+6qVnxt88AxXZycGhesz0oriJKDv6yFrgS6e0MK21XPdHc8zc
         3kJ5uJBGYP/Bt54939IHbuKQaHuao4Yu2bChsltle6tpTujkuiDI+tpbXjG+mPzyvHvy
         //JecRN+afJZ0RlpjLxAQWa1u3q3RJUa+8TvZrCSLm4pe6hNyUimHld7aG973QeBU2DC
         czzX/JYrbgZzZdkQYE3NvXEQY7l14CNjOt6gIvf6XzzRG0FQtr3i29y5rcSxZbWQdEcD
         gY2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x7lbGdQ4hRxetxLMFaeyEpmySOrXasXMGFfmLa4O4UM=;
        b=NDGHS9q5Fd6DM+ZRvbedY6okeHyqNBOXuG+OJo6G9h6+oHXhHxE/7yFGg02veOxXmz
         rzc2cgskV7BT628m/Pnda+i8lnIANNohAir7oehgPs/z96Buamrc5P/PokBPsmVdDoGt
         PowXfy7LAl563Wsnpi8CmCR5dO5FdeVxKoaWcdBz1zSHbjiFFF9IW+Nn/1bbR2NLJDWM
         VMs/b9Oz9Ow6dlJQRtAX9ZBKDsatQKseHtP/HtIcI9KR/wKq0+PjgeXHnd7q6ssDdak0
         YvwAuOtZz+pSmzfEYB6oLxHoebd4/WkH5Z2sPk8SCQ3hdXcHvBbSkwGUQpaCffvSPGyX
         Y2SQ==
X-Gm-Message-State: AOAM53173meBuvEHTKuhxqolY4Qe1UgnRn6bO/4+t695plu/QslIMrZj
        SJY/AhFgJWdoGoYBo426RUevD3DWwYolgg==
X-Google-Smtp-Source: ABdhPJy3185wy7GJ31mg7VWMi6TqQ7crQ9Rol3WXT3JSY8UiGALAkZQ3pCDnA219kZjLyVBIs8Z6KA==
X-Received: by 2002:a63:c543:: with SMTP id g3mr9270576pgd.203.1599264817405;
        Fri, 04 Sep 2020 17:13:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id br22sm348131pjb.35.2020.09.04.17.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 17:13:36 -0700 (PDT)
Message-ID: <5f52d830.1c69fb81.5788e.1520@mx.google.com>
Date:   Fri, 04 Sep 2020 17:13:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.142-131-g5ddc8f4b00eb
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 169 runs,
 2 regressions (v4.19.142-131-g5ddc8f4b00eb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 169 runs, 2 regressions (v4.19.142-131-g5d=
dc8f4b00eb)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig      | 3/4    =

hsdk            | arc   | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.142-131-g5ddc8f4b00eb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.142-131-g5ddc8f4b00eb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5ddc8f4b00eb432233b7101d54fe1ff79424c958 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig      | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f529f59a6975a96c2d35385

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
42-131-g5ddc8f4b00eb/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
42-131-g5ddc8f4b00eb/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f529f59a6975a96=
c2d35387
      new failure (last pass: v4.19.142-126-gae6e3cc29bb4)
      1 lines

    2020-09-04 20:09:09.096000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-09-04 20:09:09.096000  (user:khilman) is already connected
    2020-09-04 20:09:24.324000  =00
    2020-09-04 20:09:24.324000  =

    2020-09-04 20:09:24.338000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-09-04 20:09:24.339000  =

    2020-09-04 20:09:24.339000  DRAM:  948 MiB
    2020-09-04 20:09:24.371000  RPI 3 Model B (0xa02082)
    2020-09-04 20:09:24.446000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-09-04 20:09:24.478000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (362 line(s) more)
      =



platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
hsdk            | arc   | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f52a2f9d13029b0e2d35395

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
42-131-g5ddc8f4b00eb/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
42-131-g5ddc8f4b00eb/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f52a2f9d13029b0e2d35=
396
      failing since 46 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =20
