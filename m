Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577DF29F5E4
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 21:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgJ2UKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 16:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgJ2UKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 16:10:07 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAE1C0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 13:10:07 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id h6so3266304pgk.4
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 13:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F2+9iLbn+DyaQLANG2J/Ve7Z+pATt/WsfeZyP6+8bZU=;
        b=Re0yQUVr8jsCvxsywFlNiLFsLoqV9G9zlPjJKtTv1RyWlRnve8fpKoYD73ZXj7bppA
         PHOrmAi9hKgGJogGEF3sACc3+yYD43HAkVll2FhkNKrsytYuLYuJ1G25UawIU/o7oZfw
         ULNUcv4l2gR7/UBet3KpAhJUa5HWlPJmLchh/kU/Rx9znTlLyJPwbM0C+p84XzdhfSou
         TFaAkr+yeYovuv1WhFJYwO13+VRxIRIYP8eC2FRSPt7nokpkCkDMy8MXTY9KYOvHPbyw
         /mo0m4pCelK3WJ23HyfZoljllK4RdR3qFY+ugt0FKVTn8CcGZ6L5NJ69LayKh52wDuIs
         ELlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F2+9iLbn+DyaQLANG2J/Ve7Z+pATt/WsfeZyP6+8bZU=;
        b=Y/C5a/X6CPe78Ea+4ljCkkOdqgrf2Xilt5IKrxSLM2vlru0D5DajQKgGsfaOmg3UUt
         vXrbN/tRMim9V+SBIPF3haaZTqt4xq47PFfQ52ekse682oE/v+mdrgH5wssQB9SslvX7
         xWvjdfdYU+/+kgYvRriHh6nKsO9pl+8T8rDHnZWOOYbe9yDZBrlaQXHeT/7LeG5EN13F
         RkWoPSa9/wa4Q6r+zoJylVfaC9yiwuCLvkCC3d+8A4qQlH9tGVYtiNg3Vl66FXaO1dHJ
         TC/kGG2Yq0WmakmYOYhOS83pSH+4o2S6TXAxxWqOPJmnOOnhr/zJL5orfKzEOaLrDEt2
         8KgQ==
X-Gm-Message-State: AOAM531aTk/NByODb0eqSYtOdAePhtl0acRAiYn+2tOkmagQZPpSwDoG
        alSv9fL7tPHOMJptHSRekK9hI2Wev6l9GQ==
X-Google-Smtp-Source: ABdhPJwjJAgdYMBvpQ9hExTfrQs5gJBsHH03KjagsNMqyqhm1pn983/sqPeHLPtNCU4v+17T10MgpQ==
X-Received: by 2002:a05:6a00:8b:b029:164:2a80:e13 with SMTP id c11-20020a056a00008bb02901642a800e13mr5972452pfj.74.1604002206252;
        Thu, 29 Oct 2020 13:10:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t13sm3814010pfc.1.2020.10.29.13.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 13:10:05 -0700 (PDT)
Message-ID: <5f9b219d.1c69fb81.b23c0.9476@mx.google.com>
Date:   Thu, 29 Oct 2020 13:10:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.73-8-ga2f033fa0bbd
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 201 runs,
 3 regressions (v5.4.73-8-ga2f033fa0bbd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 201 runs, 3 regressions (v5.4.73-8-ga2f033fa0=
bbd)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =

stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.73-8-ga2f033fa0bbd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.73-8-ga2f033fa0bbd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a2f033fa0bbd630df244673c7836a13b25bb7701 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9aef9a195dd4a4c6381081

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-8-=
ga2f033fa0bbd/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_=
xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-8-=
ga2f033fa0bbd/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_=
xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9aef9a195dd4a4c6381=
082
        failing since 0 day (last pass: v5.4.72-409-gbbe9df5e07cf, first fa=
il: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9aede2dd97f67d9e381074

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-8-=
ga2f033fa0bbd/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-8-=
ga2f033fa0bbd/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9aede2dd97f67d=
9e381079
        new failure (last pass: v5.4.72-408-g4434824fa314)
        1 lines

    2020-10-29 16:27:24.688000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-29 16:27:24.688000+00:00  (user:khilman) is already connected
    2020-10-29 16:27:40.722000+00:00  =00
    2020-10-29 16:27:40.722000+00:00  =

    2020-10-29 16:27:40.723000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-29 16:27:40.723000+00:00  =

    2020-10-29 16:27:40.723000+00:00  DRAM:  948 MiB
    2020-10-29 16:27:40.738000+00:00  RPI 3 Model B (0xa02082)
    2020-10-29 16:27:40.826000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-29 16:27:40.857000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (375 line(s) more)  =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9af0f8b0b7c8f4a838102b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-8-=
ga2f033fa0bbd/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157=
c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-8-=
ga2f033fa0bbd/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157=
c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9af0f8b0b7c8f4a8381=
02c
        failing since 3 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first fa=
il: v5.4.72-402-g22eb6f319bc6) =

 =20
