Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844FF2993B4
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 18:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1422045AbgJZRYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 13:24:32 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:38902 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392010AbgJZRYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 13:24:32 -0400
Received: by mail-pl1-f172.google.com with SMTP id f21so707019plr.5
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 10:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bZV7/uFknEnTLz+iMEtd4EHiMdJAlywuzl2Y7sE5W/Q=;
        b=cAN5uAwbaMK/ITxvRzJGF2+Gl9tiLo+P8i1QDJp9ZmqgC+SIOmnRESuZUq7283rSZ7
         gLhVB/HIS6ifOZHLMA82+eu6Cxx9hcBgIXAcUT5faWc7msdGbwDO46RFgQu/n1gzgZzq
         VAoO9xG14RVbeOYrgyTcA0NDgPXeqktSpo1ofCyTpN1vw6VKaGDvcG9NYYUlX6Oh/3eS
         v9uM8nUwWSKTUal7mIBS07mDZehBtshxrXTzl7MYbHsDH//dMC9hce1KvdjUp8OZmOK9
         i4Bk/DAsOoJ1dS1wu1+9KRJJP0/Go8u8ZTBJlmnMBOG49AErI4SGZNbaTvc4NuOmw/LO
         cjbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bZV7/uFknEnTLz+iMEtd4EHiMdJAlywuzl2Y7sE5W/Q=;
        b=tk7eMbQgqj2cH7dMnqlkifpXh+98PpuZ/Rh7DgcFscwclOeJ5tAS4UentWaYNzK3s5
         ZKxliqbZ8y19DQYLFVO8aWIHfHwmbGAxXWjqM7uzAqK+MMntzKx4Cvv3xP6hEIqQplgm
         weEhyRTIxVezsLYq+vAdEw3gKAqZRkXymR45NJSXsPZhl4VbcXjm86lagp5xpfMD1vXu
         AF6FSMvwm3li3Z7XxTPR3GarHP/xPJMMV9DD6GGwNj/y/mcuSb+aH+LdIsCAy37NtQ6S
         jyqrDgOazmdkwIeU02Z+gY8VZZBsoTVsmmdvWA4S5D+tL8bFsim5udGc0v1OEPDMFhIJ
         FZhQ==
X-Gm-Message-State: AOAM530FXpzbygIQx506+NdH6kfhIhEODMzz8pzE4YL5QqEi94eDLajY
        Mo3z1TW8lrjMEPD98y760rZiUL74jGRM3Q==
X-Google-Smtp-Source: ABdhPJxKFI2qVNTRgITPM04yCYBnkLlKWMB+8eE9OvZVewQNJ/9e4b1+ftqCIvPTa/MLaGZZdigAxQ==
X-Received: by 2002:a17:902:aa94:b029:d3:b593:2736 with SMTP id d20-20020a170902aa94b02900d3b5932736mr18403289plr.57.1603733071274;
        Mon, 26 Oct 2020 10:24:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l82sm12876067pfd.102.2020.10.26.10.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 10:24:30 -0700 (PDT)
Message-ID: <5f97064e.1c69fb81.58bdb.ad89@mx.google.com>
Date:   Mon, 26 Oct 2020 10:24:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.72-402-ga4d1bb864783
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 194 runs,
 4 regressions (v5.4.72-402-ga4d1bb864783)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 194 runs, 4 regressions (v5.4.72-402-ga4d1bb8=
64783)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
   | regressions
----------------------+-------+---------------+----------+-----------------=
---+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
   | 1          =

bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
   | 1          =

jetson-tk1            | arm   | lab-collabora | gcc-8    | tegra_defconfig =
   | 1          =

stm32mp157c-dk2       | arm   | lab-baylibre  | gcc-8    | multi_v7_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.72-402-ga4d1bb864783/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.72-402-ga4d1bb864783
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a4d1bb864783ae54a755d999a7753a8ae5d6fe1f =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
   | regressions
----------------------+-------+---------------+----------+-----------------=
---+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5f96d3288d30d00350381024

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
2-ga4d1bb864783/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
2-ga4d1bb864783/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f96d3288d30d00350381=
025
        failing since 2 days (last pass: v5.4.72-24-g088b4440ff14, first fa=
il: v5.4.72-54-g5ae53d8d80cb) =

 =



platform              | arch  | lab           | compiler | defconfig       =
   | regressions
----------------------+-------+---------------+----------+-----------------=
---+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5f96d52183aeb7a7b738103b

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
2-ga4d1bb864783/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
2-ga4d1bb864783/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f96d52183aeb7a7=
b7381040
        new failure (last pass: v5.4.72-402-g22eb6f319bc6)
        3 lines

    2020-10-26 13:51:58.884000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-26 13:51:58.884000+00:00  (user:khilman) is already connected
    2020-10-26 13:52:14.619000+00:00  =00
    2020-10-26 13:52:14.620000+00:00  =

    2020-10-26 13:52:14.636000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-26 13:52:14.636000+00:00  =

    2020-10-26 13:52:14.636000+00:00  DRAM:  948 MiB
    2020-10-26 13:52:14.651000+00:00  RPI 3 Model B (0xa02082)
    2020-10-26 13:52:14.742000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-26 13:52:14.773000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (387 line(s) more)  =

 =



platform              | arch  | lab           | compiler | defconfig       =
   | regressions
----------------------+-------+---------------+----------+-----------------=
---+------------
jetson-tk1            | arm   | lab-collabora | gcc-8    | tegra_defconfig =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5f96d5950dbe8a534b381015

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
2-ga4d1bb864783/arm/tegra_defconfig/gcc-8/lab-collabora/baseline-jetson-tk1=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
2-ga4d1bb864783/arm/tegra_defconfig/gcc-8/lab-collabora/baseline-jetson-tk1=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f96d5950dbe8a534b381=
016
        new failure (last pass: v5.4.72-402-g22eb6f319bc6) =

 =



platform              | arch  | lab           | compiler | defconfig       =
   | regressions
----------------------+-------+---------------+----------+-----------------=
---+------------
stm32mp157c-dk2       | arm   | lab-baylibre  | gcc-8    | multi_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f96d6383648f9044938101b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
2-ga4d1bb864783/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
2-ga4d1bb864783/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f96d6383648f90449381=
01c
        failing since 0 day (last pass: v5.4.72-54-gc97bc0eb3ef2, first fai=
l: v5.4.72-402-g22eb6f319bc6) =

 =20
