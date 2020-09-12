Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B67267CA3
	for <lists+stable@lfdr.de>; Sun, 13 Sep 2020 00:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgILWUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 18:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgILWUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Sep 2020 18:20:43 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4226C061573
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 15:20:42 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id y6so2640218plt.9
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 15:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4Lmhg1lFB1++CwUSdHLSAWe0h7I9QTZGupAg4UpdgbE=;
        b=aKnBYrc+eKDAhkKPODkgGZG2MwAkGU3VhlipF6bGWv3jVfml6ReMgI5bC8z6Z8Gh+v
         Tz+rWdGXviPedQSVFzERCXiw7OPOG0IsCiL4lB2CXxIzaHYjkd6nwxT3ajcWSNCMNIQr
         doxEzvlXoTdz84SjaSPNgXcVobBfqez5PS1FF6yUPvO/noGlCjzdN7Gc44hYP7CsFeoJ
         nA2S+zBzn03cX4xU40zL+coGnaMrVuu9QW4XB8oIH1EuXwJOBuF02sdPyq8L5EB/k8Mw
         JOLTu+FY9D25e+Tv6f4LGoMsnZu6m4JGaKZAJjN0sLw/3ItIOAUtSfYFFKRvzJy3rQBS
         47tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4Lmhg1lFB1++CwUSdHLSAWe0h7I9QTZGupAg4UpdgbE=;
        b=JCM31/OLk7bXjrnVG8+LEx2vy00tGBcKaFx0/TyGI9dSWBbO2XE9TIA/5mVPA1fgQ3
         MU0uZwAOb0JXmpZJyiQ7NhEW/8e9UbRk+KTfisvNhDe6FhSQEw55NNvGmrUin64PmG6h
         9mXnsBuaIDDoXarkLejKl/DdgGSUvhI7AVvg0qc7Q/YR1fZxxMYMkgWMyK4cdlm1GqNZ
         qiLmCVzDGpznhPl2zwjpseU55U8e7JF/9sLa5bSQRgGfdlRDPARof8GdhWC54dMlndaQ
         eRJiOq97CdyKHCGuDSAOfZqj3ME6F3pQkr2BfqUekfbCQvya/bsYSpCd/jzRbC/B+v95
         iQeg==
X-Gm-Message-State: AOAM5335itEcdOGgRIfA7weFs1cgW5wq+1Odyc0JTIYnZ01TYYl/X0/w
        iiQvo3kKQUhGL2a+Rxn8RShgFIk7G7EA/A==
X-Google-Smtp-Source: ABdhPJz8z7iiSJCZ9RpsmaBns4mQ7+2QKczF0xCKF8ZYfmoB3YIYKAsuWp4jZxGEKI8/mdDyc3mjLA==
X-Received: by 2002:a17:902:a507:b029:d1:844d:ac88 with SMTP id s7-20020a170902a507b02900d1844dac88mr7990787plq.7.1599949237145;
        Sat, 12 Sep 2020 15:20:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d1sm5062369pjs.17.2020.09.12.15.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 15:20:36 -0700 (PDT)
Message-ID: <5f5d49b4.1c69fb81.5b89c.cd34@mx.google.com>
Date:   Sat, 12 Sep 2020 15:20:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.8-16-ga447c0d84b6f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 181 runs,
 1 regressions (v5.8.8-16-ga447c0d84b6f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 181 runs, 1 regressions (v5.8.8-16-ga447c0d84=
b6f)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.8-16-ga447c0d84b6f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.8-16-ga447c0d84b6f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a447c0d84b6f9c7a0d51ca41ba4a55565d151704 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f5d13b1f8adcbc6a9a60914

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.8-16-=
ga447c0d84b6f/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.8-16-=
ga447c0d84b6f/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f5d13b1f8adcbc6=
a9a60916
      new failure (last pass: v5.8.8-16-gbd542de38b92)
      1 lines

    2020-09-12 18:27:27.023000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-09-12 18:27:27.023000  (user:khilman) is already connected
    2020-09-12 18:27:42.079000  =00
    2020-09-12 18:27:42.079000  =

    2020-09-12 18:27:42.080000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-09-12 18:27:42.080000  =

    2020-09-12 18:27:42.080000  DRAM:  948 MiB
    2020-09-12 18:27:42.095000  RPI 3 Model B (0xa02082)
    2020-09-12 18:27:42.182000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-09-12 18:27:42.214000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (388 line(s) more)
      =20
