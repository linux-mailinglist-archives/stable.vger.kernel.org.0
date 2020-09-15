Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0AE26A8FD
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 17:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgIOPmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 11:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbgIOPjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 11:39:44 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199D3C061222
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 08:39:21 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id v14so1889322pjd.4
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 08:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i6F743JR0kzd97CY8JnPO10B8edGCzO5C/92KtNsRFI=;
        b=SKpmnOTZEv5Vq44LmLJwUpNjiCgkZOB5xv55tTwpeZ76aZF34/GY1C0Xp4LHajTi7Q
         8RwTKaZox5baDmxAp+HXs9QHCXRtTTgKflhmDbC20AJpEt3mVx1xjPtZo/Is36zpO4NN
         P4aTIK/Wdos6DWxRrk/jviLyWbx1Sw+OTKZjeCNyZetD8B7/MR8pK8bg3uFC93l8JruB
         d0RXqByyXh5NzH72NF1lUkL9Gt5hXej+893qLd/VgqBhrVakI2iWGi/j+zZKxGnJFvOO
         3oDf1T35cK+YlUVJlqLpbVh1Bbl6NTs082eH/oiZ/7Qi+Qg2lW6co56rftlLXRc622qe
         rSSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i6F743JR0kzd97CY8JnPO10B8edGCzO5C/92KtNsRFI=;
        b=KgFTECIyJkUlkoJmhzR334rexXKlROVRuSicIgp7WEkaM4z12cq9ibpqwzS0riaYIk
         av1DkqCNYypSQ6lCh88Xptp0Jy/T4GHH0+djp9g+tNnlU9R7puZAa66KDCVAdUQ8DbP8
         q7MWVDxJOfWch78EYTpXggiFNLhxR36N+DsBI4EjX5/wvsT7pgNeumsyKiuW4lqxV8tm
         HYiM9DgE8dwu+3wBU5G3UsejK+QQzcudhDBVuihzTM/uXGhuszVtCbquomZYGnOkKQ2Z
         05ZNxS0igLyNWRH+U0BQKpKbKNjR9DUE3DWRsOv/SrO40WN1Azi6YeVqxLQQlRMOlujc
         PaVA==
X-Gm-Message-State: AOAM532+Djl4yP/ik0t3n/3OTZL1bn89kVO2TCb1resqKCe3r3Rp5zOK
        lFP3G8KsAnetbfF1yNZ9uAvEq5+cHzn2pA==
X-Google-Smtp-Source: ABdhPJxh0ETcFQBLrLgmiJqRhVsMvU//3/vv/YoeRUj5iVg1BI/w9ktB4mRtgjFtTdo/xoHxMimNcg==
X-Received: by 2002:a17:90a:380a:: with SMTP id w10mr4550840pjb.23.1600184360186;
        Tue, 15 Sep 2020 08:39:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fu11sm12390268pjb.47.2020.09.15.08.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 08:39:19 -0700 (PDT)
Message-ID: <5f60e027.1c69fb81.33798.00d4@mx.google.com>
Date:   Tue, 15 Sep 2020 08:39:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.236-19-g85b7132c76df
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 115 runs,
 3 regressions (v4.4.236-19-g85b7132c76df)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 115 runs, 3 regressions (v4.4.236-19-g85b7132=
c76df)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig        | results
---------+------+---------------+----------+------------------+--------
peach-pi | arm  | lab-collabora | gcc-8    | exynos_defconfig | 80/132 =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.236-19-g85b7132c76df/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.236-19-g85b7132c76df
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      85b7132c76df8a361e1eb6832fc3a648b5a81aeb =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig        | results
---------+------+---------------+----------+------------------+--------
peach-pi | arm  | lab-collabora | gcc-8    | exynos_defconfig | 80/132 =


  Details:     https://kernelci.org/test/plan/id/5f60afeb26011d9fa8a60914

  Results:     80 PASS, 51 FAIL, 1 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.236-1=
9-g85b7132c76df/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-peach-pi.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.236-1=
9-g85b7132c76df/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-peach-pi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f60afeb26011d9f=
a8a60917
      new failure (last pass: v4.4.236-16-g95e9f04b4e51)
      1 lines

    2020-09-15 12:11:38.004000  [Enter `^Ec?' for help]
    2020-09-15 12:11:53.048000  =00
    2020-09-15 12:11:53.048000  =

    2020-09-15 12:11:53.048000  U-Boot 2016.11 (Jan 07 2017 - 15:15:17 +010=
0) for Peach-Pi
    2020-09-15 12:11:53.048000  =

    2020-09-15 12:11:53.049000  CPU:   Exynos5800 @ 1.8 GHz
    2020-09-15 12:11:53.058000  Model: Samsung/Google Peach Pi board based =
on Exynos5800
    2020-09-15 12:11:53.058000  Board: Samsung/Google Peach Pi board based =
on Exynos5800
    2020-09-15 12:11:53.058000  DRAM:  3.5 GiB
    2020-09-15 12:11:53.117000  MMC:   EXYNOS DWMMC: 0, EXYNOS DWMMC: 1
    ... (662 line(s) more)
     * baseline.dmesg.alert: https://kernelci.org/test/case/id/5f60afeb2601=
1d9fa8a60918
      new failure (last pass: v4.4.236-16-g95e9f04b4e51)
      4 lines

    2020-09-15 12:12:36.703000  kern  :alert : pgd =3D c0004000
    2020-09-15 12:12:36.714000  kern  :alert : [ffffffe0] *pgd=3D4fffd861, =
*pte=3D00000000, *ppte=3D00000000
    2020-09-15 12:12:36.714000  kern  :alert : Fixing recursive fault but r=
eboot is needed!
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f60afeb2601=
1d9fa8a60919
      new failure (last pass: v4.4.236-16-g95e9f04b4e51)
      39 lines

    2020-09-15 12:12:36.735000  kern  :emerg : Process irq/146-max9809 (pid=
: 1529, stack limit =3D 0xecd86210)
    2020-09-15 12:12:36.736000  kern  :emerg : Stack: (0xecd87ec0 to 0xecd8=
8000)
    2020-09-15 12:12:36.746000  kern  :emerg : 7ec0: edf60144 00000014 edf6=
0144 60000013 00000008 edc78a00 00000014 c0036538
    2020-09-15 12:12:36.758000  kern  :emerg : 7ee0: 00000000 edf60110 ed48=
1c00 edf43464 edf43440 c04561bc 00000004 00000004
    2020-09-15 12:12:36.758000  kern  :emerg : 7f00: edf43440 edf3d540 0000=
0001 c0067b14 ffffe000 edf3d540 00000001 c0067e0c
    2020-09-15 12:12:36.768000  kern  :emerg : 7f20: 00000000 c0067bf4 edf4=
3440 00000000 edf43480 ecd86000 edf43440 c0067cc4
    2020-09-15 12:12:36.779000  kern  :emerg : 7f40: 00000000 00000000 0000=
0000 c003dd48 00000000 00000000 00000000 edf43440
    2020-09-15 12:12:36.790000  kern  :emerg : 7f60: 00000000 00000000 dead=
4ead ffffffff ffffffff ecd87f74 ecd87f74 00000000
    2020-09-15 12:12:36.791000  kern  :emerg : 7f80: 00000000 dead4ead ffff=
ffff ffffffff ecd87f90 ecd87f90 edf43480 c003dc40
    2020-09-15 12:12:36.802000  kern  :emerg : 7fa0: 00000000 00000000 0000=
0000 c000f650 00000000 00000000 00000000 00000000
    ... (28 line(s) more)
      =20
