Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5002C111E
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 17:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730997AbgKWQy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 11:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730595AbgKWQy4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 11:54:56 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C20C0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 08:54:56 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 62so14776353pgg.12
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 08:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y8vuDl4DECe44zialrC4RmjoiVdCdhf60vIPi+J9zek=;
        b=VWjRVXTU4CZKkPuV1KkcrWqTO7z8LkyYGK1La9RVTGx4myyewAPD1zsn6raJ8xDYaz
         wIcxwyBAhaVIrvfHimx2katI4uv9sZllOntRRWYDWXoYfpB1C+gtkt2+kUE/CwsMZa3J
         KV7l/3C+aty+FAHxanBJ9wmKo5UP/SoILFqY1Maj5n0VgUaX/EroGUxHYuX+2RC+7gYi
         QNWu6Xi0zlWj20+7wk1lj9bNGjq8EiX15i9lONyeNya/zwUH158C5yflMke9RUN5NeWu
         4oG1A0aM00lZynsX0X4yo1daL/gKB3oLP0x3JdlLGXVuy5IifltbS40xWJfnQGdaTR+d
         8M5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y8vuDl4DECe44zialrC4RmjoiVdCdhf60vIPi+J9zek=;
        b=KCJcSzSbzRFIhRcfl9TxkFHzCoge4dUG1prQfRVXk1lEp7+a1/SmeHJDAbODHUEMc3
         YOnemS6bxdWcM+KdpZxUWYG3paXdeMn2kmu8qaVddkmbPWFyYfea0UwdlakXoVaHGWF2
         x3eDPLZzmNr3HifMDxBvSnRx9hJgy6hvLFXfBW7/MNRS8W310ojn4QC3iUzFZQBqgMBY
         4EVLdbhKcj8F+ex6JMCbxvgSbwEluJzLuSxr8FtbN33B65qi7ylVTiawdH0T+88HP/1o
         hc7HBpjlnp4Q1ylQDLanyRWGx4yuP6XYLTwblC55FiuKHb1FpR3uSsEj/jLE5UYvfFSq
         f4xg==
X-Gm-Message-State: AOAM530zWCQrnfE8GdpCkH13b4GvhsUMjh6BlD6FKC8TlZdv6u7Q8v+j
        JHA5bEieP91xDxX7MdtOVcbVf1mCaa3Szw==
X-Google-Smtp-Source: ABdhPJyGSD+k+HeDx7oTC+Z5XkPUKnNK6wzBdZS2h6JJUyaMqr2/65Y2e7F+GaXfHNItxNQi/DMauQ==
X-Received: by 2002:a63:8743:: with SMTP id i64mr301688pge.288.1606150495407;
        Mon, 23 Nov 2020 08:54:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f134sm12173501pfa.208.2020.11.23.08.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 08:54:54 -0800 (PST)
Message-ID: <5fbbe95e.1c69fb81.e4829.a597@mx.google.com>
Date:   Mon, 23 Nov 2020 08:54:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.79-159-g0048695749b2
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 183 runs,
 8 regressions (v5.4.79-159-g0048695749b2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 183 runs, 8 regressions (v5.4.79-159-g00486=
95749b2)

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

hifive-unleashed-a00  | riscv | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

rk3288-veyron-jaq     | arm   | lab-collabora | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.79-159-g0048695749b2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.79-159-g0048695749b2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0048695749b29788fab5e9fff442f5a5968290d3 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbb5f863fdeabb67d8d919

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.79-=
159-g0048695749b2/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.79-=
159-g0048695749b2/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbb5f863fdeabb67d8d=
91a
        failing since 225 days (last pass: v5.4.30-54-g6f04e8ca5355, first =
fail: v5.4.30-81-gf163418797b9) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbb48171de0c4324d8d8fd

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.79-=
159-g0048695749b2/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.79-=
159-g0048695749b2/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fbbb48171de0c43=
24d8d900
        new failure (last pass: v5.4.79)
        3 lines

    2020-11-23 13:06:37.709000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-23 13:06:37.709000+00:00  (user:khilman) is already connected
    2020-11-23 13:06:53.499000+00:00  =00
    2020-11-23 13:06:53.500000+00:00  =

    2020-11-23 13:06:53.516000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-23 13:06:53.516000+00:00  =

    2020-11-23 13:06:53.516000+00:00  DRAM:  948 MiB
    2020-11-23 13:06:53.531000+00:00  RPI 3 Model B (0xa02082)
    2020-11-23 13:06:53.621000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-23 13:06:53.653000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (386 line(s) more)  =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
hifive-unleashed-a00  | riscv | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbb5dd9aa94d5c00d8d909

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.79-=
159-g0048695749b2/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.79-=
159-g0048695749b2/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbb5dd9aa94d5c00d8d=
90a
        failing since 3 days (last pass: v5.4.77-152-ga3746663c3479, first =
fail: v5.4.78) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbb422482eea4d62d8d939

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.79-=
159-g0048695749b2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.79-=
159-g0048695749b2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbb422482eea4d62d8d=
93a
        failing since 8 days (last pass: v5.4.77-44-g28fe0e171c204, first f=
ail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbb4271f4abf3396d8d921

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.79-=
159-g0048695749b2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.79-=
159-g0048695749b2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbb4271f4abf3396d8d=
922
        failing since 8 days (last pass: v5.4.77-44-g28fe0e171c204, first f=
ail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbb423482eea4d62d8d93c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.79-=
159-g0048695749b2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.79-=
159-g0048695749b2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbb423482eea4d62d8d=
93d
        failing since 8 days (last pass: v5.4.77-44-g28fe0e171c204, first f=
ail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbb3caa5bb31e5add8d901

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.79-=
159-g0048695749b2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.79-=
159-g0048695749b2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbb3caa5bb31e5add8d=
902
        failing since 8 days (last pass: v5.4.77-44-g28fe0e171c204, first f=
ail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
rk3288-veyron-jaq     | arm   | lab-collabora | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbbb37c7923ac64dd8d99c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.79-=
159-g0048695749b2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.79-=
159-g0048695749b2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbbb37c7923ac64dd8d=
99d
        new failure (last pass: v5.4.79) =

 =20
