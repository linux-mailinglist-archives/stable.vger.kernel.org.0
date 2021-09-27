Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB224191D2
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 11:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbhI0JxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 05:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbhI0JxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 05:53:09 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7255AC061575
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 02:51:27 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id g14so15352346pfm.1
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 02:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VnQLaAr/EHmsgSmLePhSTRYb1wvwg5YW92vE9rGTUPI=;
        b=tPgFn/1SEa0P7e8mMKROPEa7cDDgRouKCG/bGJ7aQ8bQ+fulGTbA7kkM9LsF/Tj0h2
         AtxDzpYcD2nyHg92XYCiKZhGOIRTv2JIeQUVdkyaT6tN9uB9HCvS0t/JZdNHMt/8IKuZ
         dAXIrNQ1/0I/gQ9VGCwXx8FP4wl08HL2d48sB/NgCqnGpfHCihD1vYO/CPUX090BWFeM
         9FJkjQfNgN/icFmvscuYYv+ZbkDmm40u4Dpa+bDSTfjqxNIjMdmvfgC6PjFKqgPSW5n3
         k0pmbVxT5Cn1XFw/y0c+9KnDou4sNJ7gituB77u3afYgQ3hf61+RSyI/r2lDUiLqC+Lm
         eYjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VnQLaAr/EHmsgSmLePhSTRYb1wvwg5YW92vE9rGTUPI=;
        b=8AvKPOmQ/gAy5CCM/w4wBsYWmkPmk358GCLI8g1gbuJeaeT/YZYV3lWU6CR7RSwvqg
         YCZP87yvvEfYjcn8wvubnxwvAynaRizo4DBbDfnI6tDPdQ4LSTvD52kEfXGpvJFgyM2s
         kN2+CAaG4SJjOCVd7Qy3tyk8Meox/Rz63d0MocrkMYoVfpWDLBMeYgbPpAzC8F5A+gKm
         bU0HSJTZuFbA/TDvJhrZkD+8PP6mZsru6yeSFbPxeVDaOCjgq1fBTeOJ21jTC7RSqQph
         mhmwlw3rV/bc9nDwjMfUQC8nJrUPekslEa3Q5pCpSXk9gP3oJBafd43gBfnL6aIbyQvI
         Swyg==
X-Gm-Message-State: AOAM531CZVJ8yQkjkHdV0uSGCWoa9BVq9wchoptD1RLLzkLYiFAEXRLl
        83d7rtKxa5eX4gQc3hsbbzyi5emIoYFgF5SN
X-Google-Smtp-Source: ABdhPJwBs0bB88v9PFGn1bwUfFTprHgD5hWF8YqV7aDTs8rABsZY56Fh+VM7egZDuoNJIv0kqloT/A==
X-Received: by 2002:a62:8306:0:b0:44b:9184:e47f with SMTP id h6-20020a628306000000b0044b9184e47fmr2409826pfe.32.1632736286777;
        Mon, 27 Sep 2021 02:51:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e5sm16780715pfj.181.2021.09.27.02.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 02:51:26 -0700 (PDT)
Message-ID: <6151941e.1c69fb81.7048f.669e@mx.google.com>
Date:   Mon, 27 Sep 2021 02:51:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.284-46-g51be31f74d03
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 40 runs,
 3 regressions (v4.4.284-46-g51be31f74d03)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 40 runs, 3 regressions (v4.4.284-46-g51be31f7=
4d03)

Regressions Summary
-------------------

platform    | arch   | lab          | compiler | defconfig           | regr=
essions
------------+--------+--------------+----------+---------------------+-----=
-------
beagle-xm   | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig | 2   =
       =

qemu_x86_64 | x86_64 | lab-broonie  | gcc-8    | x86_64_defconfig    | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.284-46-g51be31f74d03/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.284-46-g51be31f74d03
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      51be31f74d031c6a6d168c045dc4bf9b93d3ab94 =



Test Regressions
---------------- =



platform    | arch   | lab          | compiler | defconfig           | regr=
essions
------------+--------+--------------+----------+---------------------+-----=
-------
beagle-xm   | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig | 2   =
       =


  Details:     https://kernelci.org/test/plan/id/61517a6a254300990699a306

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-4=
6-g51be31f74d03/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-4=
6-g51be31f74d03/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61517a6a25430099=
0699a30c
        new failure (last pass: v4.4.284-22-gc303bfe4d32c)
        1 lines

    2021-09-27T08:01:27.704758  / # #
    2021-09-27T08:01:27.705766  =

    2021-09-27T08:01:27.809877  / # #
    2021-09-27T08:01:27.810492  =

    2021-09-27T08:01:27.911857  / # #export SHELL=3D/bin/sh
    2021-09-27T08:01:27.912328  =

    2021-09-27T08:01:28.013472  / # export SHELL=3D/bin/sh. /lava-889375/en=
vironment
    2021-09-27T08:01:28.013972  =

    2021-09-27T08:01:28.115151  / # . /lava-889375/environment/lava-889375/=
bin/lava-test-runner /lava-889375/0
    2021-09-27T08:01:28.116412   =

    ... (10 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61517a6a2543009=
90699a30e
        new failure (last pass: v4.4.284-22-gc303bfe4d32c)
        28 lines

    2021-09-27T08:01:28.579024  [   50.047485] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-09-27T08:01:28.630825  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-09-27T08:01:28.636663  kern  :emerg : Process udevd (pid: 108, sta=
ck limit =3D 0xcb93c218)
    2021-09-27T08:01:28.641182  kern  :emerg : Stack: (0xcb93dd10 to 0xcb93=
e000)
    2021-09-27T08:01:28.649333  kern  :emerg : dd00:                       =
              bf02b83c bf010b84 cba64810 bf02b8c8   =

 =



platform    | arch   | lab          | compiler | defconfig           | regr=
essions
------------+--------+--------------+----------+---------------------+-----=
-------
qemu_x86_64 | x86_64 | lab-broonie  | gcc-8    | x86_64_defconfig    | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/61515c6a81906cc11c99a308

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-4=
6-g51be31f74d03/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-4=
6-g51be31f74d03/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61515c6a81906cc11c99a=
309
        new failure (last pass: v4.4.284-33-gbd4cf2734324) =

 =20
