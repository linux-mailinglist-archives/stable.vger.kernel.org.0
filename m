Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B378D422ABB
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 16:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbhJEOSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 10:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235717AbhJEOS2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 10:18:28 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675FCC061766
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 07:16:36 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so2167046pjw.0
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 07:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8FOKBkrFM6RuwuW0SYPV2a1OvFO91lfU/I7nkGPuuVM=;
        b=c6AFf75VEA720XulACW5PslJa3HCutqql9lYXDlcRSA3iVqdzJgVxVrIG/HFonQfxV
         WpSHZVfvgQkDqNeXDgINS0B7AB/C98Ogu2kKqmXkavmBWlpgA8fAX68f3ooJTjFgi+8A
         YK/+OkzOWYtSwy7B++n/3O8v1lvLyNdkD8MT8pqbnaVbSb/tE81ueRUZgbfYm5RMVgFV
         mn2B2taoRpn10y0YmeKZ4fm2PF6rkXMBRCIt/8zrMCibB4b+rXBwt5d4NPm0LhfUqt40
         3o8YFFdNjLvW4v7me5d1OtTV68vjvEUoOqRe/HhAXCtFzGWj2ef4VjFsyGwZjKcFJWRw
         QVwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8FOKBkrFM6RuwuW0SYPV2a1OvFO91lfU/I7nkGPuuVM=;
        b=jQgv+48K4gByNi6AVAXZHnS0MESUomqsnBrO4fwzv5S8b6tia3Pa/msi5P/NGYFKle
         S1HaCxcLybqRMGj3W02vn3MfyedwKca+QrW84yKrrke7WCjEW3jKE5f7k7hWOjuv0XqG
         fEofOkFqStW2k18TaFhc3J4j7/M4rKFZxzZZ32kj1xEJufQk5q7ugW8mXEtkyf28Zt01
         BTzWHaZtrGYWhoSANoQo4+9MmFLhWDxj45fg22dyuCH7vaXimKQL7HyvPaJhSwAxUzt4
         n4Vx9FhoT3WSP5X26ag0rXcNPb/EKQ+tx5JAcr4iaXNcvhiz6zfMLHnyPY7Vz1yEZSa9
         WoUw==
X-Gm-Message-State: AOAM531YunkXGUb+g7MAkhtlgkUoKpOomRhzUKeDxoS10syvrPpddFoh
        t2FRAx4fkG6voV3sODHapL4whVLpmrXcTlf3
X-Google-Smtp-Source: ABdhPJxzFTmp1q+F/UUIAFmIerGbwcsCEJQky0dFFsyTkNTAsOdoX0+y4t3G3+nBLAiHLlPoXgMhww==
X-Received: by 2002:a17:90a:8413:: with SMTP id j19mr4102821pjn.181.1633443395624;
        Tue, 05 Oct 2021 07:16:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l24sm18251628pgt.77.2021.10.05.07.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 07:16:35 -0700 (PDT)
Message-ID: <615c5e43.1c69fb81.63302.7cc0@mx.google.com>
Date:   Tue, 05 Oct 2021 07:16:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.284-58-ge7efcc55cce6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 99 runs,
 4 regressions (v4.9.284-58-ge7efcc55cce6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 99 runs, 4 regressions (v4.9.284-58-ge7efcc=
55cce6)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.284-58-ge7efcc55cce6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.284-58-ge7efcc55cce6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e7efcc55cce6ba10027969d4bbf10a0920381417 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615c26067e4c996f3599a2f5

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-58-ge7efcc55cce6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-58-ge7efcc55cce6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/615c26067e4c996=
f3599a2fb
        new failure (last pass: v4.9.284-58-g12f4032656ef)
        2 lines

    2021-10-05T10:16:20.518224  [   20.726013] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-05T10:16:20.560853  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/130
    2021-10-05T10:16:20.570163  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615c238c1ae789bd7199a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-58-ge7efcc55cce6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-58-ge7efcc55cce6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c238c1ae789bd7199a=
2e1
        failing since 324 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615c3eb12baefe2e9b99a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-58-ge7efcc55cce6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-58-ge7efcc55cce6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c3eb12baefe2e9b99a=
2df
        failing since 324 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615c251f8e0328be4599a30b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-58-ge7efcc55cce6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-58-ge7efcc55cce6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c251f8e0328be4599a=
30c
        failing since 324 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
