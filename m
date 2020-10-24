Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C77D297E5A
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 22:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764319AbgJXUNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 16:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764318AbgJXUNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 16:13:21 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F0DC0613CE
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 13:13:21 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id l2so973447pjt.5
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 13:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3jS6OihLrkl4L3239tIc/fdKxhYuuv1EW0INmsOwer8=;
        b=t/GcUZT01ZiDlLh7u0du0AyljRsZeS9l1vxM9bLB+7WkaU7pqlKv8/5Pp9A6JdCIN5
         qpTNeemQ9eE9mP6SE8hlQmbal7QLGs3XPvIM+dawyvNh4lMTL5O1DIsBT9md93M2VBDU
         XC7f8V6I1D9hSMJYqc350rL0enP9Jld6F/DqZLSpJ/Dcr8mzvCifcs1YH3biw1boqMLm
         J/9yKdAXKzm1njwTt4O68/gHYULtaDtPgIFBZsHQgwt1RktJ79jffyNZ+DdBxPDcX9+m
         AGFzP97ukx5wSZ5pY2rlj/2GQxT4mbNhcrIkip26nOZ8Qjsdcy87I5/Ax03fp4fubTRp
         Bsrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3jS6OihLrkl4L3239tIc/fdKxhYuuv1EW0INmsOwer8=;
        b=NCyuUShBGkwQCgw0cHCcikFKc7bzfHEvZ6ODwZQKGoBhsszVgTVivgAPQrlwyiVPcj
         mqEqt+6uByenzO5NHZRXyj04HFiHB0sfBaod810oQhc4vaQGL0VuYc3HfCSyhZW49Dsj
         FZhK5WFjTwt5Ent/vdH6WLf/eiz4tlgq2npcSZcXRZ+aass2ck/TQna/EePqoGd2ip/5
         pNAAFmd4OuiImH4mIzK60BmI+PF2cWmRNBauaExy6fLjGVt2/kDgu8w99HJ5V6Slwtvg
         4+1pnvDbUC0osJ5wLAAyWk0sAPyyZN3Fp/FLpOTNCok7dmmVqYSyWPlF+MzdgONz2ZeG
         HbiQ==
X-Gm-Message-State: AOAM531v7jeCoJvotvr7wK7GaVOKnfzLjfg5LY76WPxgs+FH0IfPZWSt
        hNKX5pJb1fTpUtgqeDiWpkaDo6EV+nYe8w==
X-Google-Smtp-Source: ABdhPJz9vFeA/5Eh2pwHW7f8O9GzknuwMqxCm/RcNcZDP/MnY2epnAI+soxuak4JXcNuusm71su7eA==
X-Received: by 2002:a17:90a:9414:: with SMTP id r20mr10703985pjo.29.1603570400303;
        Sat, 24 Oct 2020 13:13:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u13sm2052062pfl.162.2020.10.24.13.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2020 13:13:19 -0700 (PDT)
Message-ID: <5f948adf.1c69fb81.e7671.35d9@mx.google.com>
Date:   Sat, 24 Oct 2020 13:13:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.72-55-g7fa6d77807db
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 197 runs,
 2 regressions (v5.4.72-55-g7fa6d77807db)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 197 runs, 2 regressions (v5.4.72-55-g7fa6d7=
7807db)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 regressions
----------------------+-------+--------------+----------+-----------------+=
------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 1          =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.72-55-g7fa6d77807db/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.72-55-g7fa6d77807db
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7fa6d77807db2b6a904ffea27335aa3a0db69f1c =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 regressions
----------------------+-------+--------------+----------+-----------------+=
------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5f944fdb0ed8ebd2c0381022

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.72-=
55-g7fa6d77807db/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.72-=
55-g7fa6d77807db/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f944fdb0ed8ebd2c0381=
023
        failing since 195 days (last pass: v5.4.30-54-g6f04e8ca5355, first =
fail: v5.4.30-81-gf163418797b9) =

 =



platform              | arch  | lab          | compiler | defconfig       |=
 regressions
----------------------+-------+--------------+----------+-----------------+=
------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5f944c19fbe8925102381086

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.72-=
55-g7fa6d77807db/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.72-=
55-g7fa6d77807db/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f944c19fbe89251=
0238108b
        failing since 0 day (last pass: v5.4.72-24-g5d35a1803455, first fai=
l: v5.4.72-55-g1cab8730ace6)
        1 lines

    2020-10-24 15:43:30.795000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-24 15:43:30.795000+00:00  (user:khilman) is already connected
    2020-10-24 15:43:45.787000+00:00  =00
    2020-10-24 15:43:45.788000+00:00  =

    2020-10-24 15:43:45.788000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-24 15:43:45.788000+00:00  =

    2020-10-24 15:43:45.788000+00:00  DRAM:  948 MiB
    2020-10-24 15:43:45.803000+00:00  RPI 3 Model B (0xa02082)
    2020-10-24 15:43:45.890000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-24 15:43:45.921000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (375 line(s) more)  =

 =20
