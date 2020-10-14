Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D6928E1E6
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 16:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgJNOJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 10:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727684AbgJNOJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 10:09:09 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65BEC061755
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 07:09:09 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id j18so2085273pfa.0
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 07:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3AyPugw+CZjG3oG45aqMSiqdbK5eNibc2orZdw1fKWk=;
        b=qvcIgG8NPYw5vm9aIWcthyMD1kl5LOzJIczrIyNny96jaMfpe3LpGVyFauMfLHtIGA
         jaM59sbsRSTq6RovBAMD3rvJFqT/75P68TTfVh7CLCLjy8jNw+dslqnpJVtDcBMDbexX
         kafRf4wYixT7FadEQCBBD59UgofmNmlok2Rcmq11LJ41XaRKsL63LdZ3mQ6R85d5jSCM
         P9pg0VytbedE6DxXGFx++FvxDiTbA8PQ9bNI9/ZI+Vyqk71BIj2SFYUfmTEvWA6A62xD
         hfVszYoS0VX3pzkqusJZplOvTaqcXkSahUMUBKMH9yC+DtBirCxlxWjUXpiyhVcuSrbz
         Vhmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3AyPugw+CZjG3oG45aqMSiqdbK5eNibc2orZdw1fKWk=;
        b=jvgvlNvMCbsztxl4Gpzo5MEJCvFa3B025iPcOwxNv3clPrlU2ZnZG5TSlxAJjJl3rr
         SfLLoIq3H0V2LGHroKX0P1BMhzFEEhm07Ty8pLZFYx+tZFOjBszULNQ7zEvGFDolG/qI
         FuTwFc0oxCTZmgMohmtaU1LiMag+jcL6Jqjzz43zKKEWwjs6J1aTJUMQ0IlyFpedSKFq
         Xvugx0q7XxirW9VoG0vPP/uUSbdFqFvK6EBP7ZnY+rkLN2TZY5zrxXspFMdEwdAFxvNg
         ASxVWiIea3BNRojV9Qn+fCk7wDC2eGjCIzehKXrsQDiE1UEGnK11/RT6HNw7Gpvgl2ga
         jUHw==
X-Gm-Message-State: AOAM531CbJvFWejY+A1KGVUpaWsRkn365+05KP6EgE2Sv7YOq+Axx9Z3
        Uuze7vvSHyDdkqP0gnnbBtVyd5jKUXtAKA==
X-Google-Smtp-Source: ABdhPJz3MAFc1Av02HXQPfS8jBNyAcfp43M7ylbdu5oyjj8nkLiM6/9DEUm5xZ/8CPd9tAE4n/K57A==
X-Received: by 2002:a62:aa10:0:b029:155:d56e:5196 with SMTP id e16-20020a62aa100000b0290155d56e5196mr4579711pff.44.1602684548341;
        Wed, 14 Oct 2020 07:09:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c10sm3567348pgl.92.2020.10.14.07.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 07:09:07 -0700 (PDT)
Message-ID: <5f870683.1c69fb81.c6340.6a58@mx.google.com>
Date:   Wed, 14 Oct 2020 07:09:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.150-49-gfc7c0b3e8029
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 153 runs,
 1 regressions (v4.19.150-49-gfc7c0b3e8029)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 153 runs, 1 regressions (v4.19.150-49-gfc7c0=
b3e8029)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.150-49-gfc7c0b3e8029/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.150-49-gfc7c0b3e8029
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fc7c0b3e8029f17fa83bafcafed2e1da943f8a08 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f86cf673b33d5dede4ff412

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.150=
-49-gfc7c0b3e8029/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.150=
-49-gfc7c0b3e8029/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f86cf673b33d5de=
de4ff416
      new failure (last pass: v4.19.150-49-g269cfef6b429)
      1 lines

    2020-10-14 10:12:10.537000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-14 10:12:10.537000  (user:khilman) is already connected
    2020-10-14 10:12:26.427000  =00
    2020-10-14 10:12:26.427000  =

    2020-10-14 10:12:26.427000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-14 10:12:26.427000  =

    2020-10-14 10:12:26.428000  DRAM:  948 MiB
    2020-10-14 10:12:26.442000  RPI 3 Model B (0xa02082)
    2020-10-14 10:12:26.530000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-14 10:12:26.561000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (362 line(s) more)
      =20
