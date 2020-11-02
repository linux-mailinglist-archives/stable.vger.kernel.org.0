Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9960B2A2AD4
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 13:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgKBMjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 07:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728582AbgKBMjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 07:39:20 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBAAC0617A6
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 04:39:19 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id o3so10659784pgr.11
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 04:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wh+OKczN/220uRSscwioGn3DpXmVUXLTupH5w5hSmtQ=;
        b=fswOzrjpTkhz+dstJF3O6UOk4BJ61R3qzn9Pm6hgYS1aGGgdri3balXNXlV0DxY1NV
         KbBLiRyTO/d5FKoCzlcngNIhMgcHA/RV+sXqB6cpuYNq5sS8HnFZApcTwGpWv1/YdQn9
         HKqBaHRl/L89OrI+4soSDeHfI64lR/BeAet6I95+Q88XpPoL02aVJsFrSR1Owtu0tbLw
         vnTzOVyQDqWmFQbB/edUDyRjGhdgSoWMiYm7yX569Ih6yGl7LKzz9HbQWe1RJXzbHP5S
         C4rlAZEQSQM9Qtc9fs+ajlP1tk6Slk6XZYVzA7vzPezLZ3nUCvUcDYlYr7QjbDYNRZf3
         90RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wh+OKczN/220uRSscwioGn3DpXmVUXLTupH5w5hSmtQ=;
        b=Y8QDhbdKTTuw/NsdvnQsDZdjPD7h8CTZFd9o/7EY3JH85WjG1uwO/9IwgsKctYfSly
         u4HSiGgNaKhuJyCPDPX9ZAj+pDOxOSZJZACuJI5/cj48xPY6EqYfFFonD0IcA/x9veK5
         ADFjODzWdxpCcg/Ca2qFepJhqirAGpS2TPpO2wmn53GilbrYfnoPLazZqhRiJpBEmLaM
         vkSEcqffR9OhopjSASTS97dHJuKPKYoOH4y8kyz8jZuuedSg3KhjGrh90vlimHLX/08k
         b8M4ZoJOmfB99eOUwsbKfPYSQF8QGjXQx7MGto0f9ruqPXkVGCSC9nYRGP7a4ruekMgJ
         /epg==
X-Gm-Message-State: AOAM532i41z7xJLGGYwrT3xpx8lQQHt7J0MtHYCHSB0hicsMYeTf372/
        S9qIkWzuXMNPahqmaz5o63XPfAP2Z4KHOQ==
X-Google-Smtp-Source: ABdhPJz8MUNrBt+2ceOtcnCYKXMYEtvqLkFfMpP4dDECqnP8gqSHFBsqh+xJonceIvYzM5MymdfZ4A==
X-Received: by 2002:a17:90a:7f81:: with SMTP id m1mr18081486pjl.197.1604320759023;
        Mon, 02 Nov 2020 04:39:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m3sm14201268pfd.217.2020.11.02.04.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 04:39:18 -0800 (PST)
Message-ID: <5f9ffdf6.1c69fb81.63217.703d@mx.google.com>
Date:   Mon, 02 Nov 2020 04:39:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.18-149-ga0808a23b576
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 205 runs,
 4 regressions (v5.8.18-149-ga0808a23b576)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 205 runs, 4 regressions (v5.8.18-149-ga0808a2=
3b576)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
bcm2837-rpi-3-b    | arm64 | lab-baylibre | gcc-8    | defconfig          |=
 1          =

bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig  |=
 1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig          |=
 1          =

stm32mp157c-dk2    | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.18-149-ga0808a23b576/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.18-149-ga0808a23b576
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a0808a23b5762e1e5b874b37f9f7d68833baf4af =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
bcm2837-rpi-3-b    | arm64 | lab-baylibre | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5f9fc6f8b8085a58b53fe7f4

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-14=
9-ga0808a23b576/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-14=
9-ga0808a23b576/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9fc6f8b8085a58=
b53fe7f9
        new failure (last pass: v5.8.17-70-gaad856e7dc92)
        2 lines

    2020-11-02 08:42:27.161000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-02 08:42:27.161000+00:00  (user:khilman) is already connected
    2020-11-02 08:42:43.217000+00:00  =00
    2020-11-02 08:42:43.217000+00:00  =

    2020-11-02 08:42:43.217000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-02 08:42:43.217000+00:00  =

    2020-11-02 08:42:43.217000+00:00  DRAM:  948 MiB
    2020-11-02 08:42:43.233000+00:00  RPI 3 Model B (0xa02082)
    2020-11-02 08:42:43.320000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-02 08:42:43.351000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (385 line(s) more)  =

 =



platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5f9fc7a8d6e3d536c13fe7e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-14=
9-ga0808a23b576/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-14=
9-ga0808a23b576/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9fc7a8d6e3d536c13fe=
7e9
        new failure (last pass: v5.8.17-70-gaad856e7dc92) =

 =



platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5f9fc8cd3d428076c03fe7e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-14=
9-ga0808a23b576/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-14=
9-ga0808a23b576/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9fc8cd3d428076c03fe=
7e3
        failing since 0 day (last pass: v5.8.17-49-g114a0c1f9474, first fai=
l: v5.8.17-70-gaad856e7dc92) =

 =



platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
stm32mp157c-dk2    | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5f9fcdd9ffcdfe40293fe7e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-14=
9-ga0808a23b576/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-14=
9-ga0808a23b576/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9fcdd9ffcdfe40293fe=
7e9
        failing since 7 days (last pass: v5.8.16-78-g480e444094c4, first fa=
il: v5.8.16-626-g41d0d5713799) =

 =20
