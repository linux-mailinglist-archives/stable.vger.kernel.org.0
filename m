Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7052A0C02
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 18:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgJ3RBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 13:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727267AbgJ3RBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 13:01:08 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68551C0613D7
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 10:01:08 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id g12so5717528pgm.8
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 10:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=24N1MGjrajUCxy2fvcLJqSbvI/1W+W+lwma0TMllEl4=;
        b=IzqS1aiIhOFPIrb40WDfdT4AVpDhw8zqYWDf7hrn/KS/DMudS9cz44geVlmYYl6chu
         0UhZDcvCm9LtiKgqk8DFluvh1Uwn0ELoiAdrIEQGRaCBiNNzH96zAKC3/ggu7f3Dojze
         BJQksaOhKFbZfxHj4c66JAyCryoND8VJtkABuFPcZbxYzhvRnf38GzGoWK+/2ZHcdRvc
         3pD0LO+kPSzSuv5CiJEkdAgQinTBqlTMpxaUOEfwFuEhUkROIuBUqAc64n40U3bMZB1B
         NfZKw+zhYckw9Gxlsv9Uo5sTk3/a/ZkQGG+iHI1R4udV6nLLPzJZkmQvcV2hwFF6qRh/
         VvYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=24N1MGjrajUCxy2fvcLJqSbvI/1W+W+lwma0TMllEl4=;
        b=J5w6EqJdcwrnNEhsyd89qHFqiPpLQfO7Qo1wR0yrvs1+VckVEeFSDdzurl0rI03I5p
         fZxOf06xQSAkeASVYfGMX/fYfEHpO5ZK3IqnGXFB21druZE/bMNDwYLL05LE9w+KM3Ib
         iU8QoeDQmZcJgudQzOjKAsStMRJTTwAyj9tXDEicBB63910IZ5OOLyuexi67050uACUZ
         EM2Ov+ZpDqpFeJ+lFb3/sYr3QaY+jD4V4kJ7R5UTRmAvVRohdaWcClUc0/vyMCIgsdgZ
         DOj+Pj0GZ3tEhXwdlY+NM3sx6iJaRtx7HyliAu2v8511duKJmff4GUZBHCVyCaHs1wWM
         xtUA==
X-Gm-Message-State: AOAM533lul1DsziP+M5/YJ8PrkNm5+5JtNg+hKbB2zhzn3TraOjLolfp
        Yp5Wb+VyhTLplAD87/TfsPpyTWX8m63n8g==
X-Google-Smtp-Source: ABdhPJwo5mDZaUmcy6Q0R1AYhzlWabC2POduDZAmgRVXPZEux3iidMqEHXgD7MrC+3g4n2KOg+ulmQ==
X-Received: by 2002:a17:90b:204:: with SMTP id fy4mr4311209pjb.156.1604077267448;
        Fri, 30 Oct 2020 10:01:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e7sm2909528pge.51.2020.10.30.10.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 10:01:06 -0700 (PDT)
Message-ID: <5f9c46d2.1c69fb81.f9776.6d84@mx.google.com>
Date:   Fri, 30 Oct 2020 10:01:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.73-9-g98c61b1447e0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 194 runs,
 3 regressions (v5.4.73-9-g98c61b1447e0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 194 runs, 3 regressions (v5.4.73-9-g98c61b144=
7e0)

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
el/v5.4.73-9-g98c61b1447e0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.73-9-g98c61b1447e0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      98c61b1447e049c4cf3a1fab3fad294b1e8dbd63 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9c1410624fd4a63e381021

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g98c61b1447e0/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_=
xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g98c61b1447e0/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_=
xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9c1410624fd4a63e381=
022
        failing since 1 day (last pass: v5.4.72-409-gbbe9df5e07cf, first fa=
il: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9c11b7037a5ace5a381032

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g98c61b1447e0/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g98c61b1447e0/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9c11b7037a5ace=
5a381037
        failing since 0 day (last pass: v5.4.73-9-ga9c55e5daa9c, first fail=
: v5.4.73-9-g812d5e88da7e)
        2 lines

    2020-10-30 13:12:26.007000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-30 13:12:26.007000+00:00  (user:khilman) is already connected
    2020-10-30 13:12:40.996000+00:00  =00
    2020-10-30 13:12:40.996000+00:00  =

    2020-10-30 13:12:41.012000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-30 13:12:41.012000+00:00  =

    2020-10-30 13:12:41.013000+00:00  DRAM:  948 MiB
    2020-10-30 13:12:41.028000+00:00  RPI 3 Model B (0xa02082)
    2020-10-30 13:12:41.119000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-30 13:12:41.151000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (381 line(s) more)  =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9c1505ed6719092538102a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g98c61b1447e0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157=
c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g98c61b1447e0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157=
c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9c1505ed67190925381=
02b
        failing since 4 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first fa=
il: v5.4.72-402-g22eb6f319bc6) =

 =20
