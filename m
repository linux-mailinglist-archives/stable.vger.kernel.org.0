Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177BA298A68
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 11:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1737242AbgJZKaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 06:30:12 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:36617 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1769858AbgJZKaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 06:30:08 -0400
Received: by mail-pg1-f177.google.com with SMTP id b23so5844418pgb.3
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 03:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fs0DCwP63Sm/aUaJJX2Vl+BtwdhqbFxhpKzAy1OujpY=;
        b=uyEQAY/pTQpOeZYLOcUb9NJOw0hmo9o+/8o18PApo9fCpNofmdpzxVRSsp3tNCm87i
         u5NAbHlRAliTZzu88smPNEIHieQB0gWMjwYVUn+7RJ2IyEIEmYgRQ4KwX3tRUaaQpr0i
         EzIG9ZQGZwPNjkB/xHDrVGXZDndJYdb5im/jH/Iw7y3/9uDIcSK1O0E3SeoXb4W+PrTo
         1r5L4Lp8Ay0dQqKq8ar5/xTqLV0gD5Jtj4AkDvhE3XpR9r/YwkCIl0/2CGaTC0NOL1zs
         mv2mK9l65w1sKd8JNSZF5NM9W8jVDAE5fG1ix0Wiy9fh20soSdTWNo3pO+bBASUE7fwP
         w48Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fs0DCwP63Sm/aUaJJX2Vl+BtwdhqbFxhpKzAy1OujpY=;
        b=l7FRZRM3T07SMhXRBr/dtHI7coMV/Xufqqtk0Ak+dhWARokD/Ej5dmTY42p99m5+56
         VYRK+w3xQRmZL4qHhH/XM1o+3NudnL8fssnMyQANBjtGqqHu8jOOVdzFKeni14VpHUjp
         bmTtKgl1EKZT/LfJx7xVMXB6sUP0QXaCU6o1Ochi/T0eZdOKj/QNva7/gn5M4ri4cqm2
         nYVQYozgkaEaBxoHL+gDe6+h16bDocVCxw/HDJGdA9xxuEGpQlw2NakgaHv8HqX9PPuz
         hY6fc6o+rI+wWsTZr+WDf+lqB0nbDoXoLJ6M23o4msDMplDjGU/mAmbQwmnmN7jsz2yE
         6DsQ==
X-Gm-Message-State: AOAM53122wJZGCm/dacvMXB4nz0ZpAPU+IZoEmrPBgWNvNf7EZ+F/kkV
        trDFSNTSdE76BKjEMTgt7C0b1aOgnq+cEQ==
X-Google-Smtp-Source: ABdhPJwCJOr5qJafi2iWOkxCWPMnB4tmkHO+Ns79V6tahn3XQNyUjRj2NGvWMZt8Z678AHVI3qngow==
X-Received: by 2002:a63:5046:: with SMTP id q6mr2760743pgl.373.1603708206989;
        Mon, 26 Oct 2020 03:30:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p5sm11862399pjz.47.2020.10.26.03.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 03:30:06 -0700 (PDT)
Message-ID: <5f96a52e.1c69fb81.bad37.85e5@mx.google.com>
Date:   Mon, 26 Oct 2020 03:30:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.152-260-g13765aa29be3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 177 runs,
 2 regressions (v4.19.152-260-g13765aa29be3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 177 runs, 2 regressions (v4.19.152-260-g1376=
5aa29be3)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.152-260-g13765aa29be3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.152-260-g13765aa29be3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      13765aa29be363ca408d3012a3dc9a4aefaa178b =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9670b20376ce7e76381012

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-260-g13765aa29be3/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-260-g13765aa29be3/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9670b20376ce7e=
76381017
        failing since 3 days (last pass: v4.19.152-15-g0ea747efc059, first =
fail: v4.19.152-15-gc47f727e21ba)
        1 lines

    2020-10-26 06:44:21.003000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-26 06:44:21.003000+00:00  (user:khilman) is already connected
    2020-10-26 06:44:36.269000+00:00  =00
    2020-10-26 06:44:36.269000+00:00  =

    2020-10-26 06:44:36.285000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-26 06:44:36.285000+00:00  =

    2020-10-26 06:44:36.285000+00:00  DRAM:  948 MiB
    2020-10-26 06:44:36.301000+00:00  RPI 3 Model B (0xa02082)
    2020-10-26 06:44:36.392000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-26 06:44:36.423000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (362 line(s) more)  =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9670d03dcd163c6e38101b

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-260-g13765aa29be3/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-260-g13765aa29be3/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9670d03dcd163=
c6e381022
        failing since 1 day (last pass: v4.19.152-15-gc47f727e21ba, first f=
ail: v4.19.152-30-g31ec31f50737)
        2 lines =

 =20
