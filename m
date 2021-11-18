Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A3C455FA0
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 16:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbhKRPhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 10:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbhKRPht (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 10:37:49 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68FCC061574
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 07:34:49 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso6056027pjb.2
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 07:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2FCm8kmh0CxrObHE5MvgzHLuaP87a/cE3pD63OAWbL4=;
        b=6UYZj8ggH6m4SZuVqMvp7KAsHZESzj4qvtQEdvs8PBCGKUkmTgsrPti2wcOVKk4lQB
         Ozvc7fQUMoFCJVZvUyE2XOmfPQNpfgfQkY5POlLeUhgpiDjWTDtUGnlnifLyyYwFfMiP
         zbgZZrny7CxOmFrNEQ69anffPRH+qziMcGzpB/3pw8griiwv3aO45T86etpJQEtJWKsq
         BGN6ahLpPVCfyGVz7UmRKohPgo9DDMqE4OMEOu4Kc67rip24eajr1n1/eeVCjNlME6ET
         /IL/4I1TZxEDz6QYHGfr/M9MjaZNytZ4ne7MyitKrk/WohoPSaVueTPtFIlKNEur2GpQ
         WHPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2FCm8kmh0CxrObHE5MvgzHLuaP87a/cE3pD63OAWbL4=;
        b=XgV7W0gUHxY+HFXEWllvD3b8QVdmFEM4/GrHeBAQjtFVpdPMr7RRfmUdK9pACUJkrv
         FNfBXXkYt3y6VOVWKpTfPCqq+ScTmfufpVZre6pUmL8caTklrU9F9gmq7Sn0P6lyECK9
         1ZNbBrkIWRsuqMWudueeJIk+wLtOZJozz9AmworfevOP/xbHT7hNcgWvtBjzLMyBKNTh
         SGWO6WLniBZg78j40phhGMn5/I2IJNXbJGpZ3wPWRda2qisg8YK1NDfbclIONyYN4Gcs
         gKoYZhAnp5zKIbNLiNDVCQoHmKh+6v/dvn/3jyk1Q1NGWFXO587ObvLB/YMLg0tA4CJ5
         r13g==
X-Gm-Message-State: AOAM5328h4vZ53i7GEB6GCCs4cmpBtGCkYClmBl7GExETbCN6VqJw1lN
        2gX8KKIFhxYSYALsi1omO0YVy1CdhZIxU8Is
X-Google-Smtp-Source: ABdhPJyx3jfhXTfGL6hEg7rmRUKTSaD5mVtE2hwhU9kLZmV7jHM/ZFUxDkCwG44WVYAVoLZOkSB8Dg==
X-Received: by 2002:a17:90b:1648:: with SMTP id il8mr11387318pjb.246.1637249688870;
        Thu, 18 Nov 2021 07:34:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t18sm72873pgv.21.2021.11.18.07.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 07:34:48 -0800 (PST)
Message-ID: <61967298.1c69fb81.26642.04fc@mx.google.com>
Date:   Thu, 18 Nov 2021 07:34:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.79-570-g9b865fd3ba992
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 160 runs,
 2 regressions (v5.10.79-570-g9b865fd3ba992)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 160 runs, 2 regressions (v5.10.79-570-g9b865=
fd3ba992)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =

meson-gxbb-p200    | arm64  | lab-baylibre  | gcc-10   | defconfig         =
           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.79-570-g9b865fd3ba992/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.79-570-g9b865fd3ba992
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9b865fd3ba992c81567885de060ed6bc12cea9af =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61964252c9f82de2d7e551d2

  Results:     17 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.79-=
570-g9b865fd3ba992/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.79-=
570-g9b865fd3ba992/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61964252c9f82de=
2d7e551e4
        new failure (last pass: v5.10.79-569-g878c6aeb961b)
        1 lines

    2021-11-18T12:08:42.679775  kern  :emerg : __common_interrupt: 1.55 No =
irq handler for vector
    2021-11-18T12:08:42.689770  <8>[   10.726429] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
meson-gxbb-p200    | arm64  | lab-baylibre  | gcc-10   | defconfig         =
           | 1          =


  Details:     https://kernelci.org/test/plan/id/619643ca1ff343ea58e551cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.79-=
570-g9b865fd3ba992/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.79-=
570-g9b865fd3ba992/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619643ca1ff343ea58e55=
1cd
        new failure (last pass: v5.10.79-569-g878c6aeb961b) =

 =20
