Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D931D2A1FCD
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 18:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgKARC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 12:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgKARC7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 12:02:59 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2604C0617A6
        for <stable@vger.kernel.org>; Sun,  1 Nov 2020 09:02:58 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id b3so9000042pfo.2
        for <stable@vger.kernel.org>; Sun, 01 Nov 2020 09:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OqG18Uc/otdpe0f2nOQb6hwInJlorStPpA74P9quFUo=;
        b=HRpxB84fn8+JhkYVUw0TYLy7CDtGSzZU7lrw9bP0gQsUNEZwOjMJDOaOroVlsIw0xL
         19fWm12vRJPwhwDoM68JxX+6J6xq9viqm3pLBT/WJsbpYLe2XpYUCALL4STw3mGGnGEO
         /emRZh3hUb6J9bOuSgraRwE6e9RoQt8y8CwxjiqTGPCCGK/5MgbA5IZ6S4TCjkq480/d
         zGK4ETleY8ESy5RD+y9IUlcPvq3iEezg6r22zqkqkgfjQPGK6F2bZwY9PTDbtO06PPri
         t0wpjkS+iQmXSk4dfhwEx9FYTUZg/etrn36sEq1Ojb3yErJ7OmGY8VEnYfMJLJS3X7QK
         nmGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OqG18Uc/otdpe0f2nOQb6hwInJlorStPpA74P9quFUo=;
        b=XOlHNn6cv/DvjBOLeJg6nsKdZMekpkK5+K4QtR4qI6e9TYRcYT39cNTYMbANkSCGZK
         IXYDQOblT/UPnUD+moDgzrO69QPuNjdvEeyskPx0yREbqaE7bBk8Hio433/LicU3RgGv
         pTRy0Zlyom9N1JA82jo7MLTPL7R2TldRZT90+Hk+qp+FCh9PMI0goKjo1Yi5I7eRKWI6
         3ngxnEyk8S9HEm5R/4/6zOYxP2/gRL1ALk/68VNIvwUFO6KDcKD13udC5ABAtfodaR9/
         KGBzK7ztTZ7ufly0K8DkSRuh+CARX2ZB3iQf9LkLANtdClti73YqStho5bA2mp27MIe1
         QE+g==
X-Gm-Message-State: AOAM530EU5PywKgUe0W/pXQdcHE+pE7NPu4NGbGtNydmEApcS1fahYnv
        Mb2o25uOfP3w3gBfsnOWW9FdN4A2Ehs2mw==
X-Google-Smtp-Source: ABdhPJyUN8HPZBju5CUwjaQSjnR8bmVgoNZDLtfZ3tWC1dqj7BmHE1x4vepWWkcGo7o6OnPzNBnsIg==
X-Received: by 2002:a65:4b84:: with SMTP id t4mr10167921pgq.138.1604250177956;
        Sun, 01 Nov 2020 09:02:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z22sm11832792pfa.220.2020.11.01.09.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 09:02:57 -0800 (PST)
Message-ID: <5f9eea41.1c69fb81.75a0e.efe8@mx.google.com>
Date:   Sun, 01 Nov 2020 09:02:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.73-48-g756e19810764
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 208 runs,
 3 regressions (v5.4.73-48-g756e19810764)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 208 runs, 3 regressions (v5.4.73-48-g756e1981=
0764)

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
el/v5.4.73-48-g756e19810764/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.73-48-g756e19810764
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      756e19810764d69ee3261de39391aa2b70667087 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9eb76fe2f7e1c0f33fe7d5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-48=
-g756e19810764/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-48=
-g756e19810764/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9eb76fe2f7e1c0f33fe=
7d6
        failing since 3 days (last pass: v5.4.72-409-gbbe9df5e07cf, first f=
ail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9eb60ca8733be58d3fe7f5

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-48=
-g756e19810764/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-48=
-g756e19810764/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9eb60ca8733be5=
8d3fe7fa
        new failure (last pass: v5.4.73-48-g1a794ced991d)
        1 lines

    2020-11-01 13:18:14.431000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-01 13:18:14.431000+00:00  (user:khilman) is already connected
    2020-11-01 13:18:30.091000+00:00  =00
    2020-11-01 13:18:30.091000+00:00  =

    2020-11-01 13:18:30.091000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-01 13:18:30.092000+00:00  =

    2020-11-01 13:18:30.092000+00:00  DRAM:  948 MiB
    2020-11-01 13:18:30.108000+00:00  RPI 3 Model B (0xa02082)
    2020-11-01 13:18:30.194000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-01 13:18:30.226000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (376 line(s) more)  =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9eba0a6c759bae5e3fe7de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-48=
-g756e19810764/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-48=
-g756e19810764/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9eba0a6c759bae5e3fe=
7df
        failing since 6 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first fa=
il: v5.4.72-402-g22eb6f319bc6) =

 =20
