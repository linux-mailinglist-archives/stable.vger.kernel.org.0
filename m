Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DAB28EE60
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 10:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730173AbgJOIWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 04:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730160AbgJOIV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 04:21:59 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77142C061755
        for <stable@vger.kernel.org>; Thu, 15 Oct 2020 01:21:59 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id u3so1536712pjr.3
        for <stable@vger.kernel.org>; Thu, 15 Oct 2020 01:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ub0lf2yWj86dPCxg+urfykxbEF1x0ro2KfNcZBXIgOo=;
        b=KiB24DiNc6nxkXxZaCoEQbZn6VdW9tQT2x8r/URrI+Z53jkmBxnRxTt8yrx5f7b60w
         gVoQRBjF73p1T8AmTKKAiDAjauClEtOBIkozAMd7SMT0PunQ3mNA6tV6jRXgWknio95i
         P/BnU4YupBV6boid+gVoVxX76Y5ZhYRwR1h9fhkcFb2bD51g/d9JMQir6bQ/0pknS1Tn
         ueaV2Pe9KdW1ggRrvFfShANVZYMzjOUEN8G66w4kH5TDt+/4FcxR7JFl7IoZmvNJW75L
         VXWC+1KMUM02swVJozGjWmIHTQ4uX9y+/ilXu4YCNsHYGfyMv3P+QISnmJVRia90vuhd
         Cxqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ub0lf2yWj86dPCxg+urfykxbEF1x0ro2KfNcZBXIgOo=;
        b=KvF85GhaRZ/JX3aFE4kv+Ettro3VFYURhukwtn5bMbsvnIsWOtjETmgz2IxUAZqTFD
         SBNKMKCPsT0y04QgXxsP+s9NXZXRcARoIHbVZCNeA3zGYNmxddZBj+9xGK8zHObGxYsC
         gmLg/Ux2OUy4ZiaWt+cFt2k5KvjpmtRJxcaQShQFs0toeKcfRw8fizLAyuxv8suifDNs
         kQ6i2XTGwptdTooWbulAR/SvaBmYFdiws3Gf2nb3IIaIVzpUCUj6gAft/0ujTUIEF4PN
         xH8yh7BBtUK7/x/jUitCk8Fo/Zqo1O1zU0rteoNP/m+S1KrF4Evg4eDd4xVtd+KS+78h
         eIvg==
X-Gm-Message-State: AOAM532lZwGnw6wA6hw8nyO0VPowGvzkq6ff+mU8rRbsxHqDfLqtN10Z
        87QiQG3lJcaaylb1IJ9CLpFd1+kJflIFdg==
X-Google-Smtp-Source: ABdhPJwauOyhLA6YqRXAc0rIZ5iTMfSUWi3CnVq+21eFXi3LS7HC4i9eZUc7O79yZQAnzEoX3pQyrQ==
X-Received: by 2002:a17:902:eacc:b029:d3:b362:72c0 with SMTP id p12-20020a170902eaccb02900d3b36272c0mr2720821pld.23.1602750117593;
        Thu, 15 Oct 2020 01:21:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n15sm2177047pgt.75.2020.10.15.01.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 01:21:56 -0700 (PDT)
Message-ID: <5f8806a4.1c69fb81.7292a.4aae@mx.google.com>
Date:   Thu, 15 Oct 2020 01:21:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.150-54-g2e74820a6c13
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 182 runs,
 2 regressions (v4.19.150-54-g2e74820a6c13)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 182 runs, 2 regressions (v4.19.150-54-g2e748=
20a6c13)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
3/4    =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.150-54-g2e74820a6c13/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.150-54-g2e74820a6c13
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2e74820a6c13eb47450d103e1e702fc552c3bbe5 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
3/4    =


  Details:     https://kernelci.org/test/plan/id/5f87cb6fcd68de77864ff403

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.150=
-54-g2e74820a6c13/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.150=
-54-g2e74820a6c13/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f87cb6fcd68de77=
864ff407
      failing since 0 day (last pass: v4.19.150-49-g269cfef6b429, first fai=
l: v4.19.150-49-gfc7c0b3e8029)
      1 lines

    2020-10-15 04:07:30.503000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-15 04:07:30.503000  (user:khilman) is already connected
    2020-10-15 04:07:46.447000  =00
    2020-10-15 04:07:46.448000  =

    2020-10-15 04:07:46.448000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-15 04:07:46.464000  =

    2020-10-15 04:07:46.464000  DRAM:  948 MiB
    2020-10-15 04:07:46.479000  RPI 3 Model B (0xa02082)
    2020-10-15 04:07:46.567000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-15 04:07:46.600000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (362 line(s) more)
      =



platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
4/5    =


  Details:     https://kernelci.org/test/plan/id/5f87cd556426cf5bba4ff3eb

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.150=
-54-g2e74820a6c13/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.150=
-54-g2e74820a6c13/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f87cd556426cf5=
bba4ff3f2
      new failure (last pass: v4.19.150-49-gfc7c0b3e8029)
      2 lines  =20
