Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A34931F462
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 05:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhBSETI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 23:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhBSETG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 23:19:06 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700F0C061574
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 20:18:26 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id a9so2648357plh.8
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 20:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N7SyxKSpwhmWaxwaGwmqPE3InGLYyJgRPpDL8GHa/ug=;
        b=W/CunaiY72mzheY3hiOVKRspse94CnNiI4frXugiXtUHFy35vmIFZZhFdkrpYHD3hY
         h7pPCbnL31iNKJ7I/4UATSFQkO3DJmoziLgaShvsfOr0kz7z+D7VAfu/ZADuYYECyOx4
         T38chcqpldiTNa04RUmqIg30YxbA9SFvXncHzSxjLPh4yvyQHjNwjkcVopJAX0iu/rUo
         3tHFhVyEMBw5VTM96ZsgEWw9TNu0djOfb/uZS8Izdsr5IJT+YfdN9xXSOwkC7GhioAVE
         SuEg0MMtB5r/G+q774FVeRHSzWw/X0SEZwLaqFxpmboYat2p3znyEOrnHgshNJWQjMKn
         47Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N7SyxKSpwhmWaxwaGwmqPE3InGLYyJgRPpDL8GHa/ug=;
        b=lIMploNqQXR4gHMRS+cmYhqRDMZIBe+ZlEGVhpqlrJcYopLpK0VxdQNMTmtnGPp/X0
         5RNyqjtzaLeBfFByg91xvqJS2Ct6R6FHeHxbx917wMhR9Z+BtRA6R/g1/MVI6770g4Yk
         chOWd+HuCqyMnRHPdHIYuQhj672lUhhFx+Q0sV5KZIzWpGzJ/ckkWim71cX1OPlM+Bve
         tyLSR42qJVUrgRvwmul/DleRBTyexDOk4SgHzUjr2NnlilmHatobvwMuu850EVhx4p6B
         6CHrUqIaOZlQIRPM7xBVuJHcy1v4DfBvo6NntWFMB4CuoaG0YENTPor9Gee60I4QiW8Q
         nzVw==
X-Gm-Message-State: AOAM531ZjBHwhiJUZy8bL2aUARtZXZDoNABd/l9WqOUImblwn/E3NxMo
        jsIAq4X2YxQrde4jgQg06r9LRiAK3CHuFw==
X-Google-Smtp-Source: ABdhPJwFudna1HCoOplgu2SSL6hZrtwnxHV+F2/pz4AmM1t0qUxug37iTo9x4kFmkZ4j1CSBn9hmtQ==
X-Received: by 2002:a17:90a:4301:: with SMTP id q1mr7069286pjg.57.1613708305625;
        Thu, 18 Feb 2021 20:18:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t2sm3574330pfg.152.2021.02.18.20.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 20:18:25 -0800 (PST)
Message-ID: <602f3c11.1c69fb81.302a6.83af@mx.google.com>
Date:   Thu, 18 Feb 2021 20:18:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.99-1-ga268543f1a3af
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 113 runs,
 3 regressions (v5.4.99-1-ga268543f1a3af)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 113 runs, 3 regressions (v5.4.99-1-ga268543f1=
a3af)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig | regre=
ssions
---------------------+-------+---------------+----------+-----------+------=
------
bcm2837-rpi-3-b      | arm64 | lab-baylibre  | gcc-8    | defconfig | 1    =
      =

hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig | 1    =
      =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-8    | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.99-1-ga268543f1a3af/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.99-1-ga268543f1a3af
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a268543f1a3afe5b5b39287fb88f19cbe65a16a8 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig | regre=
ssions
---------------------+-------+---------------+----------+-----------+------=
------
bcm2837-rpi-3-b      | arm64 | lab-baylibre  | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/602f0a21603cd3e65eaddcb7

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-1-=
ga268543f1a3af/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-1-=
ga268543f1a3af/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/602f0a21603cd3e6=
5eaddcba
        new failure (last pass: v5.4.98-60-g39e91bfbe270)
        1 lines

    2021-02-19 00:43:14.485000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2021-02-19 00:43:14.486000+00:00  (user:khilman) is already connected
    2021-02-19 00:43:30.861000+00:00  =00
    2021-02-19 00:43:30.861000+00:00  =

    2021-02-19 00:43:30.861000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2021-02-19 00:43:30.861000+00:00  =

    2021-02-19 00:43:30.862000+00:00  DRAM:  948 MiB
    2021-02-19 00:43:30.877000+00:00  RPI 3 Model B (0xa02082)
    2021-02-19 00:43:30.965000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2021-02-19 00:43:30.997000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (386 line(s) more)  =

 =



platform             | arch  | lab           | compiler | defconfig | regre=
ssions
---------------------+-------+---------------+----------+-----------+------=
------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/602f0909dafba548b5addcc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-1-=
ga268543f1a3af/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-1-=
ga268543f1a3af/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602f0909dafba548b5add=
cc5
        failing since 90 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab           | compiler | defconfig | regre=
ssions
---------------------+-------+---------------+----------+-----------+------=
------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/602f0be9270c56a2a9addd10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-1-=
ga268543f1a3af/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-1-=
ga268543f1a3af/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602f0be9270c56a2a9add=
d11
        new failure (last pass: v5.4.98-60-g39e91bfbe270) =

 =20
