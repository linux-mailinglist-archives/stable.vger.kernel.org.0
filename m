Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3014839D6
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 02:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbiADBdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 20:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiADBdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 20:33:12 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED45AC061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 17:33:11 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id jw3so30056995pjb.4
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 17:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Tds6EHzGr3QERJyvMcyQhQFa4Ahhg64jmE8dNvKzdoc=;
        b=Yy+qTPlZyJGtKgAT+9lawlXNMDjV5+cCssReqFABuJIzGNGVqQkMsEV8iFCMtpRMd8
         KlI7f4NJe3ZP0Kn0XSJ3h0+okC8qgL4P6MYjf/dyOFGFQvD+tw/kwhmyhimapx4nNnWm
         PNebhWZCCsZDFbyjtpLLk67O4KszDDq0oBaZth9+57HldFthuy040HeZfXS2E7VqY+VY
         kCTzWLGVeXMx64Rc0+R/EG0lvQbefQ8YDvpuWxNS6ke6Qt46XdLKlnVu0mJxc6YdqNpZ
         dBTMXTvV02cQUY7Eq3i7Zm8GJqLWxOSFHWjUkjwcG6wEa56CtdL4x6Hop1Eprpxy4Gwl
         HyMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Tds6EHzGr3QERJyvMcyQhQFa4Ahhg64jmE8dNvKzdoc=;
        b=iS2eT6JEwTEwDheDv6Bf00wjAG8CF9z1GmbYdB1PMVDkRnUhRhwRrj0YL4VOG74vha
         kth07AezP/Z2ne3ZgPfLP+sC9WrsF2l5WLaNk5cMB+jBYwyK8T35kbYl6k12gbwXcLg3
         P5ehFVrwOkjgFRvppJfgUXswvN1JiRwV1w4IJVmh7gGCMnp0XEFjO7fc9DULcR8me6ta
         fd5ViL1YnQmm/AMv8SdRHZKejf8dGtJDXMxX0afW04C6Q9Bz0NzKqZfAyOU9jX06sdt7
         NAAnr2Oaajb8YxOk4zbSJjEdlkcFmkhU/rPyPq7+lEHzkwOJJqrtAZacXIa53+UUkBRH
         RRzA==
X-Gm-Message-State: AOAM531Hkv+7Ft7GncPgFH5hGFjXSMOtwUWQa8E6f0UU/Mj3E9+2er87
        a8hr4UxTpHcxXTbT8denxqiOWGvzRcC5309Q
X-Google-Smtp-Source: ABdhPJyidZ5GKhsuxnIfZfFO8mFFxnk5JnjFzm9YNI/U+zx0qRW48/qWa+w+Q66u4HxIOglJ9eUEIw==
X-Received: by 2002:a17:90b:4f82:: with SMTP id qe2mr57696546pjb.128.1641259991341;
        Mon, 03 Jan 2022 17:33:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ds24sm39261112pjb.36.2022.01.03.17.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 17:33:11 -0800 (PST)
Message-ID: <61d3a3d7.1c69fb81.5956e.c0b4@mx.google.com>
Date:   Mon, 03 Jan 2022 17:33:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.223-27-g939eabea13d4
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 138 runs,
 4 regressions (v4.19.223-27-g939eabea13d4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 138 runs, 4 regressions (v4.19.223-27-g939ea=
bea13d4)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxbb-nanopi-k2 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

panda                | arm   | lab-collabora | gcc-10   | omap2plus_defconf=
ig        | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.223-27-g939eabea13d4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.223-27-g939eabea13d4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      939eabea13d488fa0321703ec46ec58239a28a2c =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxbb-nanopi-k2 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/61d371935ed266ca32ef6765

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.223=
-27-g939eabea13d4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-n=
anopi-k2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.223=
-27-g939eabea13d4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-n=
anopi-k2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d371935ed266ca32ef6=
766
        new failure (last pass: v4.19.223-17-g3995985dae4a) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
panda                | arm   | lab-collabora | gcc-10   | omap2plus_defconf=
ig        | 1          =


  Details:     https://kernelci.org/test/plan/id/61d36f25da3e85af34ef6741

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.223=
-27-g939eabea13d4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.223=
-27-g939eabea13d4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d36f25da3e85a=
f34ef6744
        new failure (last pass: v4.19.223-16-ge86e6ad8a5c1)
        2 lines

    2022-01-03T21:48:07.412323  <8>[   21.165100] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-03T21:48:07.457755  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2022-01-03T21:48:07.466831  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 2          =


  Details:     https://kernelci.org/test/plan/id/61d372433d0c760fa3ef6751

  Results:     82 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.223=
-27-g939eabea13d4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.223=
-27-g939eabea13d4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.cros-ec-sysfs-attr-kb_wake_angle: https://kernelci.org/=
test/case/id/61d372433d0c760fa3ef6794
        new failure (last pass: v4.19.223-17-g3995985dae4a)

    2022-01-03T22:01:22.233361  /lava-5345303/1/../bin/lava-test-case
    2022-01-03T22:01:22.243098  <8>[   27.219414] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sysfs-attr-kb_wake_angle RESULT=3Dfail>   =


  * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/tes=
t/case/id/61d372433d0c760fa3ef6797
        new failure (last pass: v4.19.223-17-g3995985dae4a)

    2022-01-03T22:01:18.110856  <8>[   23.086371] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dpass>
    2022-01-03T22:01:19.122643  /lava-5345303/1/../bin/lava-test-case
    2022-01-03T22:01:19.132456  <8>[   24.108148] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>   =

 =20
