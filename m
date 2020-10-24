Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1372297DD2
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 19:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762639AbgJXRjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 13:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761094AbgJXRjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 13:39:07 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6DBC0613CE
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 10:39:07 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id w21so3681397pfc.7
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 10:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jCGjJj2uFVbaS2RWs7JFudcCXW0+GNSw1DoV5LVKOzg=;
        b=CloYSqhmHt1tyog6MEq4irLOzVCUQpX0NkjnQ3LJDktNWS+vtFIfLaaC+fRC0KYaVX
         CXBLSsOtUUTZOpinWW9hohys/M5CkNYBB6AGoDo9Ha2huMOEfkChu4rFrRhvhniShuMT
         4pT7N64eM5a42iOYv2xh/CRbvjAw1owwvFsd9gD0hl2eJBym+BzFbjR3taPEln6i845/
         KieDCemRHaJ3iyJ37EjLIFXpTYIWmu2p9VOX4soh+1EuiMsSH6EOMNQpVm7ww9jKB7w2
         oJSBvSVgZp/T6g2znuLkscozsLtMZ/8IaCYcB4WVunXgxZkaCa+TRuRU7GuiNDoFn8F4
         MWCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jCGjJj2uFVbaS2RWs7JFudcCXW0+GNSw1DoV5LVKOzg=;
        b=NM05KbGnwzpI9490JbaBztpHd56x07ADPppT/EAORS+LnuKSF8e3dtR2ZmL6R975JA
         5EWRqoVX0BzOdpjBiRHKepc1UHrdNKO6BED2Xbge2tKYdugOoV+wkGq1+Bq3+uhXA6PA
         XdwUxhn+7eVmHmmPK9QECdsiWeLmr4k1Il79SFUXrGroHKLfOwKMPJkGj3nkWqAkXi3G
         5HIJjcX4FvkIfpZ74T0uReAGNoSxzMtKSDtdcqRSVtZlagLJlAgcSs1ZTkOyMYHBLIRn
         1acWMq9XmN5jxnAXv3mFqTy9cgWDnuf+foqP0O9flklcANv1RoJT4fLNwbg8krAEoQTV
         vVmA==
X-Gm-Message-State: AOAM532VsOEZ53XoCNP/CB40xEN9nN0ZY+o/QlVObvhp44JjCJER109k
        bLzdnKotJYzlD0kzQasynKhCVgZNGNzuvA==
X-Google-Smtp-Source: ABdhPJxP2WvV4wQh7usz53kD122uimOZJXS6AtPHqA/aXSJhAWTlDo9JpXT9YOO3sPQmMH4cSG+T6w==
X-Received: by 2002:a63:f441:: with SMTP id p1mr6589673pgk.243.1603561146831;
        Sat, 24 Oct 2020 10:39:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r22sm6473513pfg.51.2020.10.24.10.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2020 10:39:06 -0700 (PDT)
Message-ID: <5f9466ba.1c69fb81.9b6f1.bae0@mx.google.com>
Date:   Sat, 24 Oct 2020 10:39:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.152-32-gbf893f9b586a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 172 runs,
 2 regressions (v4.19.152-32-gbf893f9b586a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 172 runs, 2 regressions (v4.19.152-32-gbf893=
f9b586a)

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
nel/v4.19.152-32-gbf893f9b586a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.152-32-gbf893f9b586a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bf893f9b586a5d7efd62c29d3e62006a21be78b1 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9431ff07a181cd2a381018

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-32-gbf893f9b586a/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-32-gbf893f9b586a/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9431ff07a181cd=
2a38101d
        failing since 1 day (last pass: v4.19.152-15-g0ea747efc059, first f=
ail: v4.19.152-15-gc47f727e21ba)
        1 lines

    2020-10-24 13:52:17.643000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-24 13:52:17.643000+00:00  (user:khilman) is already connected
    2020-10-24 13:52:33.489000+00:00  =00
    2020-10-24 13:52:33.489000+00:00  =

    2020-10-24 13:52:33.489000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-24 13:52:33.489000+00:00  =

    2020-10-24 13:52:33.489000+00:00  DRAM:  948 MiB
    2020-10-24 13:52:33.504000+00:00  RPI 3 Model B (0xa02082)
    2020-10-24 13:52:33.591000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-24 13:52:33.623000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (362 line(s) more)  =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9433e5e6db8d1da438102f

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-32-gbf893f9b586a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-32-gbf893f9b586a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9433e5e6db8d1=
da4381036
        failing since 0 day (last pass: v4.19.152-15-gc47f727e21ba, first f=
ail: v4.19.152-30-g31ec31f50737)
        2 lines =

 =20
