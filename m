Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD9E297CC5
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 16:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760062AbgJXOT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 10:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760060AbgJXOT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 10:19:28 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB77C0613CE
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 07:19:28 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id b19so2518785pld.0
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 07:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a4rJsdLwAnMwvomMT9DnHX02bA7lMh5BsZibjr6nnBo=;
        b=VDZnU/gCCrEHyTOq7K+jnXLOy7Ik8NIte2883vcleUmoAl686kcLXCz5pUmerYIwRN
         gNMCmGvRN+Qcpahw3XK8Zsh0SvhJWRCSV71GAac4MkhgtB8TwpCBNBsSkgnizBAdXtBb
         w3jtMjp3wwPwylmmXbrfZyM+xsOtgW0510ETvKj/ObRSZFxr/dhNGjSb4QeTjHrWI3pv
         qkDK8r52y6BPv15+DNBLDFRxxQ2uB3hKkMF77COkw+6kfqAqAnSvZtE/amAS37GcqvXT
         3Taz2FTXdJzHddNyGm25c9JcXKEMmJOEs9wGSkW162/l1sNErnh+iUtceDvE7O0PNS1a
         CsMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a4rJsdLwAnMwvomMT9DnHX02bA7lMh5BsZibjr6nnBo=;
        b=KffEsqj0sJC550v+nh6Y8QZN+Z5kAQDi9Dy6TuP1kc0hH77UlA3DRSdCRQVxesXkzj
         SEFiAPEb3NR7jxgoE11F+EgILGwn62XR/7oFeaB/8yrRCpEwhe+vYzZU588W8rUHtAXZ
         UefslUJRLdO1DHI1CI6NFQstwNXhOgnOx+hVGrhmTv6y0YDXK6Qjnvx5UphzqWHKdIdo
         SIW5iCx4MQhHkUYEKPr3XsWB/ViRwLB67poPzylBBJ+u7s5azy87sGm/PnLXLlXFEKtu
         X0wmfCsk/cAZ+pb58L0V0GUELZ3I5zxnAwBIYr76f2FSlAHl2CPSqG2qrwF53wVoOzo0
         DFKg==
X-Gm-Message-State: AOAM530I8YAWf1JU1IKjTCatWR68F7eea7JDRe3Z+ymkOu7nUrbUYKcf
        /FylsaXeRLcILbFm2HlwfRzlupUFniR+6g==
X-Google-Smtp-Source: ABdhPJyOCS0ClLb5Lw2R94HkUvD4Aelp1gkc5HiDR0t5ppYhIWKXleTFQhcjF/i2BpGQJUHNx418hA==
X-Received: by 2002:a17:90a:9412:: with SMTP id r18mr7413991pjo.152.1603549167101;
        Sat, 24 Oct 2020 07:19:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f12sm6430805pju.18.2020.10.24.07.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2020 07:19:26 -0700 (PDT)
Message-ID: <5f9437ee.1c69fb81.4e21c.b54f@mx.google.com>
Date:   Sat, 24 Oct 2020 07:19:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.16-74-gd3913618d680
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 197 runs,
 4 regressions (v5.8.16-74-gd3913618d680)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 197 runs, 4 regressions (v5.8.16-74-gd3913618=
d680)

Regressions Summary
-------------------

platform               | arch  | lab           | compiler | defconfig      =
  | regressions
-----------------------+-------+---------------+----------+----------------=
--+------------
bcm2837-rpi-3-b        | arm64 | lab-baylibre  | gcc-8    | defconfig      =
  | 1          =

meson-sm1-khadas-vim3l | arm64 | lab-baylibre  | gcc-8    | defconfig      =
  | 2          =

odroid-xu3             | arm   | lab-collabora | gcc-8    | exynos_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.16-74-gd3913618d680/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.16-74-gd3913618d680
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d3913618d680cd77525d39f7370fdb67c9f340d6 =



Test Regressions
---------------- =



platform               | arch  | lab           | compiler | defconfig      =
  | regressions
-----------------------+-------+---------------+----------+----------------=
--+------------
bcm2837-rpi-3-b        | arm64 | lab-baylibre  | gcc-8    | defconfig      =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9402dfb89beef5ef3810d5

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-74=
-gd3913618d680/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-74=
-gd3913618d680/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9402dfb89beef5=
ef3810da
        failing since 3 days (last pass: v5.8.16-29-g970dd0292df8, first fa=
il: v5.8.16-29-g94b8033e99d8)
        1 lines

    2020-10-24 10:31:00.763000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-24 10:31:00.763000+00:00  (user:khilman) is already connected
    2020-10-24 10:31:16.194000+00:00  =00
    2020-10-24 10:31:16.194000+00:00  =

    2020-10-24 10:31:16.194000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-24 10:31:16.194000+00:00  =

    2020-10-24 10:31:16.194000+00:00  DRAM:  948 MiB
    2020-10-24 10:31:16.210000+00:00  RPI 3 Model B (0xa02082)
    2020-10-24 10:31:16.298000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-24 10:31:16.328000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (382 line(s) more)  =

 =



platform               | arch  | lab           | compiler | defconfig      =
  | regressions
-----------------------+-------+---------------+----------+----------------=
--+------------
meson-sm1-khadas-vim3l | arm64 | lab-baylibre  | gcc-8    | defconfig      =
  | 2          =


  Details:     https://kernelci.org/test/plan/id/5f9402b75629a78c3c38102c

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-74=
-gd3913618d680/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-sm1-khadas=
-vim3l.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-74=
-gd3913618d680/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-sm1-khadas=
-vim3l.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5f9402b75629a78=
c3c381032
        new failure (last pass: v5.8.16-29-g7f7c35e6fb34)
        11 lines

    2020-10-24 10:32:18.616000+00:00  kern  :alert : Mem abort info:
    2020-10-24 10:32:18.616000+00:00  kern  :alert :   ESR =3D 0x96000006
    2020-10-24 10:32:18.658000+00:00  kern  :alert :   EC =3D 0x25: DABT (c=
urrent EL), IL =3D 32 bits
    2020-10-24 10:32:18.658000+00:00  kern  :alert :   SET =3D 0, FnV =3D 0
    2020-10-24 10:32:18.658000+00:00  kern  :alert :   EA =3D 0, S1PTW =3D 0
    2020-10-24 10:32:18.658000+00:00  kern  :alert : Data abort info:
    2020-10-24 10:32:18.658000+00:00  kern  :alert :   ISV =3D 0, ISS =3D 0=
x00000006
    2020-10-24 10:32:18.658000+00:00  kern  :alert :   CM =3D 0, WnR =3D 0
    2020-10-24 10:32:18.659000+00:00  kern  :alert : user pgtable: 4k pages=
, 48-bit VAs, pgdp=3D000000007878d000
    2020-10-24 10:32:18.659000+00:00  kern  :alert : [0000000000000002] pgd=
=3D000000007878e003, p4d=3D000000007878e003, pud=3D000000007c037003, pmd=3D=
0000000000000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9402b75629a78=
c3c381033
        new failure (last pass: v5.8.16-29-g7f7c35e6fb34)
        2 lines

    2020-10-24 10:32:18.694000+00:00  kern  :emerg : Code: d503233f a9bf7bf=
d 910003fd 97ffffe0 (79400401)    =

 =



platform               | arch  | lab           | compiler | defconfig      =
  | regressions
-----------------------+-------+---------------+----------+----------------=
--+------------
odroid-xu3             | arm   | lab-collabora | gcc-8    | exynos_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5f94071fd9193cf8ba381030

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-74=
-gd3913618d680/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-odroid-xu3=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-74=
-gd3913618d680/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-odroid-xu3=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f94071fd9193cf8ba381=
031
        new failure (last pass: v5.8.16-29-g7f7c35e6fb34) =

 =20
