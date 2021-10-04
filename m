Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC71F421915
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 23:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbhJDVQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 17:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbhJDVQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 17:16:12 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA2AC061745
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 14:14:23 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id oa6-20020a17090b1bc600b0019ffc4b9c51so340042pjb.2
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 14:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RR4u6QSvnb5hvZHifiZpaWwedLevRnJngJGRpy5PN+M=;
        b=yOs/ZhWtQwKCfQ11yoQiRbbFLqQM5beJXdNYTKWoe+H4YSyEe21+4/0GJsXrhNuu1n
         n+uL6I+XqjCA1ptl50FjT/vATjtXH3cBQglhDmi5oxQ8j+UiNvvcnnlw/ROnQFn9c/2i
         4SsxJLLW7HRxdOARu7f47q5o8uBDEkXc/tvVSf/Rn1NHP9j54AHiOWDnhYeXAK9ufczi
         NT56oh0CyCNxiOxwRMJm4uLj5keOiFiFq//Vh/EN87INXSybaiSkW+WLEuyP828sJteR
         Pxp1TqH3V5nCHQmOt016Ja9tXc/IrHWO5e5HbRCbxdM9u8H38aBqeXF3f6VpF0rGUyba
         pJUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RR4u6QSvnb5hvZHifiZpaWwedLevRnJngJGRpy5PN+M=;
        b=Q+ukrt7atDZbF84zk/2s1V63s+BLJCu2rgDrx3fUelb6YC4LVcGZmWXzRuaCDERZ0A
         Tg/OFae912vhi05Wh556ohHeCGV0K10nFxPuAoWF1XOJkSIwHnqdvUhXnJoUWRnH10LT
         b1Wxpcc6hM2OfEma5qXoAm4vbr5svAjAABcPbQBadLwl1HF5AotSepYykUmd8youHYTo
         6pOvNaztMk9odgSf3+gqRptchn1Az61Wy0MJxhSoT1xQm/m9NF2GkNvOiPZtnFu3icF/
         dh7vc8lODQrSTHLbEKA3rgH1l5IIAPeqZIb/2GMD7KbDGnbxNeEJq2sftAgi6y28wQFL
         5lMw==
X-Gm-Message-State: AOAM530ApJ5Mxb6J2S2Vocd5BhCMm99duvXjJQmEkQUlQjbuiRyNzU+5
        glY3y6lvWhHkH2PHq4OEU7qR4vo8bSkFFWHB
X-Google-Smtp-Source: ABdhPJz43eZ/EoV64RIhT1is9mLLF/iPEnrECJRShSpnng4X1E6Lne1EmeEOs1o7xjgr9WkDO29YfA==
X-Received: by 2002:a17:90b:1e47:: with SMTP id pi7mr39446950pjb.135.1633382062945;
        Mon, 04 Oct 2021 14:14:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u24sm16119416pfm.27.2021.10.04.14.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 14:14:22 -0700 (PDT)
Message-ID: <615b6eae.1c69fb81.ce613.fe03@mx.google.com>
Date:   Mon, 04 Oct 2021 14:14:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.284-58-g12f4032656ef
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 84 runs,
 4 regressions (v4.9.284-58-g12f4032656ef)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 84 runs, 4 regressions (v4.9.284-58-g12f403=
2656ef)

Regressions Summary
-------------------

platform             | arch   | lab          | compiler | defconfig        =
   | regressions
---------------------+--------+--------------+----------+------------------=
---+------------
d2500cc              | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig =
   | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm    | lab-cip      | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.284-58-g12f4032656ef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.284-58-g12f4032656ef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      12f4032656ef06215bbc9839bcfa37925216ac6f =



Test Regressions
---------------- =



platform             | arch   | lab          | compiler | defconfig        =
   | regressions
---------------------+--------+--------------+----------+------------------=
---+------------
d2500cc              | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/615b33848350de220599a2fb

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-58-g12f4032656ef/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-58-g12f4032656ef/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/615b33858350de2=
20599a303
        new failure (last pass: v4.9.284-36-g66817f7dd335)
        1 lines

    2021-10-04T17:01:33.894464  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2021-10-04T17:01:33.905927  [   11.821417] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2021-10-04T17:01:33.906309  + set +x   =

 =



platform             | arch   | lab          | compiler | defconfig        =
   | regressions
---------------------+--------+--------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm    | lab-baylibre | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/615b32bf67f9ec94f599a2f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-58-g12f4032656ef/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-58-g12f4032656ef/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b32bf67f9ec94f599a=
2f8
        failing since 324 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab          | compiler | defconfig        =
   | regressions
---------------------+--------+--------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm    | lab-broonie  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/615b3b8dbea3b4278999a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-58-g12f4032656ef/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-58-g12f4032656ef/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b3b8dbea3b4278999a=
2e7
        failing since 324 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab          | compiler | defconfig        =
   | regressions
---------------------+--------+--------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm    | lab-cip      | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/615b3a20908e425bb299a351

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-58-g12f4032656ef/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-58-g12f4032656ef/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b3a20908e425bb299a=
352
        failing since 324 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
