Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00C92A0BAD
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 17:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgJ3Quc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 12:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgJ3Quc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 12:50:32 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64378C0613CF
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 09:50:32 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id w65so5800580pfd.3
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 09:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C3qLGs/fYWkpWaXH+/kJb7ePE6D98toFYVEs60nRMRc=;
        b=k/sic/xfiUIE/IIm2OY9sW4IgfZ1Uzo/tHiZ+MUKkIIQ0DukiD4Jp/WDdVctOTTZ8J
         dToWcDVgj+U/3wQTSl8NNNZxO1CqXJrZE6AhUeXWoEkaUs28zrWfjk2oJFonhh4boKxO
         P4NkRcmXylmRHIfrBuCBfAPZNGKXZpjcbtDmuJwI/bMWGn26r9AMRJFk+7V13RTClyvr
         o1qqIgrEpzbzOQN572arM47dr/bcsCmLR+ur1nr3qv1iZkyTnO6oLCyJ7917SBM7xmV9
         BYPNW1Nz0d74MQdIPGnbzEk9/CIojHLKfpWs7GhRHOkj0Bk1SI/u+m/ciuiFC8uLL3Fb
         GggQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C3qLGs/fYWkpWaXH+/kJb7ePE6D98toFYVEs60nRMRc=;
        b=jRHCJ916Kmqt+WV52DkDypJ/rdCmqr+W+F1KG6IOBBDrvBB5Irt4UMliQ4u6BJhdml
         l0E8Ka+hV5h/UbF6YQOqQJ9jWzAm1hRg/kvvFZOI2LLg4TnV1s3jGJ2QnD+uJO0pX2Xs
         75jBH2wnXM3JgbEAgmW28EBm4UK/C4bIZM960McoJjdZiQLjggpewUfKkYQCVHZJr0K1
         d9EeEk3IFuCuUgCfvKT02RaIzQAxBthBgqgT8uB5Ufpr912TQ4c3eLjIAydYykTNQI1w
         GUE4/sRc2K0xqdpC0w3Faq8FG22F+9EyKrdU+Ed7VrxZHHQGwuArTAYz6DEtxWpNqhYt
         u23w==
X-Gm-Message-State: AOAM53057Hio0uthxwwkwOaArTD5MhHuaMU+tTB5gAGm5heI5O2b5XPH
        u5k9EcI2AREk/WOmPa6ne2zZ6irmFZNERA==
X-Google-Smtp-Source: ABdhPJxaFIDP6yFZMfMXf6HXowK7okzkqBM07HzOpOl6/XYJCwRU2PVj7WKn66bDsTaKkGFid22LUA==
X-Received: by 2002:a17:90b:124b:: with SMTP id gx11mr3764958pjb.27.1604076631565;
        Fri, 30 Oct 2020 09:50:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o65sm6177930pga.42.2020.10.30.09.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 09:50:30 -0700 (PDT)
Message-ID: <5f9c4456.1c69fb81.1b0d6.d952@mx.google.com>
Date:   Fri, 30 Oct 2020 09:50:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.154
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 174 runs, 4 regressions (v4.19.154)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 174 runs, 4 regressions (v4.19.154)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =

bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

beagle-xm             | arm   | lab-baylibre  | gcc-8    | multi_v7_defconf=
ig  | 1          =

panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.154/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.154
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f5d8eef067acee3fda37137f4a08c0d3f6427a8e =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9c0f47a208d1a96638101c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
54/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
54/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9c0f47a208d1a966381=
01d
        failing since 136 days (last pass: v4.19.126-55-gf6c346f2d42d, firs=
t fail: v4.19.126-113-gd694d4388e88) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9c0fc3f86ea8a6163810ef

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
54/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
54/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9c0fc3f86ea8a6=
163810f4
        new failure (last pass: v4.19.153)
        1 lines

    2020-10-30 13:04:12.375000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-30 13:04:12.375000+00:00  (user:khilman) is already connected
    2020-10-30 13:04:27.747000+00:00  =00
    2020-10-30 13:04:27.748000+00:00  =

    2020-10-30 13:04:27.748000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-30 13:04:27.763000+00:00  =

    2020-10-30 13:04:27.764000+00:00  DRAM:  948 MiB
    2020-10-30 13:04:27.779000+00:00  RPI 3 Model B (0xa02082)
    2020-10-30 13:04:27.867000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-30 13:04:27.900000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (371 line(s) more)  =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
beagle-xm             | arm   | lab-baylibre  | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9c1448a032870d85381012

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
54/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
54/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9c1448a032870d85381=
013
        new failure (last pass: v4.19.153) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9c11f2eac96582b4381030

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
54/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
54/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9c11f2eac9658=
2b4381037
        new failure (last pass: v4.19.153)
        2 lines =

 =20
