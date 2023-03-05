Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED526AB163
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 17:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjCEQem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 11:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCEQel (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 11:34:41 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA54B755
        for <stable@vger.kernel.org>; Sun,  5 Mar 2023 08:34:38 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so6704784pjg.4
        for <stable@vger.kernel.org>; Sun, 05 Mar 2023 08:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678034078;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=+XfRP0GtvUB6N7wTD4zR0UkIKmOKrNZVGdI8deg7UUU=;
        b=pjMaa9fVN7EaOpBg+93zcIb9HxgSsTCBIxoDxwH4OCB+H35twvfb0PMPmceRtvlqUc
         qixdie3Jcx1q5RkUDbmdHgfVblLeNFmL8v1HoqB7nhz5KhnqOQNQfFogavLsAJH8OlSA
         dX+CpveOAYSqZ4cHazXmWlnNEUeUlpZcEhbFCNUs11/zsBS7xl7B/EOqo4WWtII20hqW
         JFxmkDRLwVIYp61RxCXp0bWPGFeBTHuV5G/RFzVAMx3+EaYoDIBu6bB7PG0E60iUF8AI
         C/DchKUVM2QblWDcCy1MMrCakdnrhOi7TOlgoRdVXNPm7jEAHPMm0imKytma4nIaVCoS
         gt1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678034078;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+XfRP0GtvUB6N7wTD4zR0UkIKmOKrNZVGdI8deg7UUU=;
        b=frYsUYg0ERZcKXRCswQ2IDi+jGAunnaqj641yb9hazuYVWa/aLpuc0+txZqU83FPwN
         Ag5sdSEKSB2UjREOmQPi822kLqilmgmdPiMYWCn0U1UCPZpB+yqP1Xl5gSATjDqgbkB4
         xOyYcRIMlHiBbx0JgyCsu9PPz37omqZOL0sGDVSBLjsArR9QSWT/ltooWE4YmRM5QU4S
         qNNsxpkvO3/i5dM2duzGIpenUgQuvF8Q2hY8f5twDjx1t2h72pGk+ck7SxL78UXwC6NR
         shGo8dUx3JbzLJKqJ4jYSSQWqaVlfVQj+bEMCG9kUTiiaV213Fqj9IE0L3ssBaA6uB7R
         s6+A==
X-Gm-Message-State: AO0yUKUWs6p5jxt7MrO6b2SAMQk7aA0Uo5DVGmD0thcJ1k0JbM+7gQs5
        9I5t9CGdgNDWrv/VyeqkUyVVjEE+fpQUfWl6ExGinON4
X-Google-Smtp-Source: AK7set+JIhH601Ff6xw8Upsj8pmp5kX+NNiaU3Lnr/m6CaFGjqFVlAYEyV1uqjs2onxQVk+u8XWMZg==
X-Received: by 2002:a17:902:c946:b0:19c:1433:5fba with SMTP id i6-20020a170902c94600b0019c14335fbamr10257376pla.0.1678034077923;
        Sun, 05 Mar 2023 08:34:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x7-20020a1709029a4700b00186a2dd3ffdsm4950647plv.15.2023.03.05.08.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Mar 2023 08:34:37 -0800 (PST)
Message-ID: <6404c49d.170a0220.8cc25.8a25@mx.google.com>
Date:   Sun, 05 Mar 2023 08:34:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.98-430-gf4021390fc22
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 170 runs,
 14 regressions (v5.15.98-430-gf4021390fc22)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 170 runs, 14 regressions (v5.15.98-430-gf402=
1390fc22)

Regressions Summary
-------------------

platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
beagle-xm              | arm    | lab-baylibre    | gcc-10   | omap2plus_de=
fconfig          | 1          =

cubietruck             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =

imx53-qsrb             | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =

imx6qp-wandboard-revd1 | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =

qemu_i386-uefi         | i386   | lab-baylibre    | gcc-10   | i386_defconf=
ig               | 1          =

qemu_i386-uefi         | i386   | lab-broonie     | gcc-10   | i386_defconf=
ig               | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.98-430-gf4021390fc22/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.98-430-gf4021390fc22
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f4021390fc221aa7ba2ef5e0046979859464ff39 =



Test Regressions
---------------- =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
beagle-xm              | arm    | lab-baylibre    | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64049264c0a6bf0b1f8c87f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64049264c0a6bf0b1f8c8=
7f7
        failing since 30 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
cubietruck             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/640491b08f8a2aad0f8c8657

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640491b08f8a2aad0f8c8660
        failing since 47 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-05T12:57:12.550499  <8>[    9.989626] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3387742_1.5.2.4.1>
    2023-03-05T12:57:12.664003  / # #
    2023-03-05T12:57:12.768321  export SHELL=3D/bin/sh
    2023-03-05T12:57:12.769825  #<3>[   10.114074] Bluetooth: hci0: command=
 0xfc18 tx timeout
    2023-03-05T12:57:12.770710  =

    2023-03-05T12:57:12.873692  / # export SHELL=3D/bin/sh. /lava-3387742/e=
nvironment
    2023-03-05T12:57:12.875052  =

    2023-03-05T12:57:12.977607  / # . /lava-3387742/environment/lava-338774=
2/bin/lava-test-runner /lava-3387742/1
    2023-03-05T12:57:12.980027  =

    2023-03-05T12:57:12.985023  / # /lava-3387742/bin/lava-test-runner /lav=
a-3387742/1 =

    ... (12 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
imx53-qsrb             | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/64048fd07b523b2fff8c863d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64048fd07b523b2fff8c8646
        failing since 37 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-03-05T12:48:56.219324  + set +x
    2023-03-05T12:48:56.219476  [    9.306645] <LAVA_SIGNAL_ENDRUN 0_dmesg =
916179_1.5.2.3.1>
    2023-03-05T12:48:56.327349  / # #
    2023-03-05T12:48:56.428999  export SHELL=3D/bin/sh
    2023-03-05T12:48:56.429449  #
    2023-03-05T12:48:56.530765  / # export SHELL=3D/bin/sh. /lava-916179/en=
vironment
    2023-03-05T12:48:56.531240  =

    2023-03-05T12:48:56.632492  / # . /lava-916179/environment/lava-916179/=
bin/lava-test-runner /lava-916179/1
    2023-03-05T12:48:56.633076  =

    2023-03-05T12:48:56.635463  / # /lava-916179/bin/lava-test-runner /lava=
-916179/1 =

    ... (12 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
imx6qp-wandboard-revd1 | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/64048fce7b523b2fff8c862f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64048fce7b523b2fff8c8638
        failing since 0 day (last pass: v5.15.98-3-gaeb495359c8e, first fai=
l: v5.15.98-430-g53a7ecef4b2f)

    2023-03-05T12:48:55.784246  + set[    5.561960] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 916175_1.5.2.3.1>
    2023-03-05T12:48:55.784454   +x
    2023-03-05T12:48:55.898324  / # #
    2023-03-05T12:48:55.999957  export SHELL=3D/bin/sh
    2023-03-05T12:48:56.000559  #
    2023-03-05T12:48:56.101944  / # export SHELL=3D/bin/sh. /lava-916175/en=
vironment
    2023-03-05T12:48:56.102619  =

    2023-03-05T12:48:56.204036  / # . /lava-916175/environment/lava-916175/=
bin/lava-test-runner /lava-916175/1
    2023-03-05T12:48:56.204803  =

    2023-03-05T12:48:56.207215  / # /lava-916175/bin/lava-test-runner /lava=
-916175/1 =

    ... (12 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_i386-uefi         | i386   | lab-baylibre    | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/640490a796edc4b2b08c865b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i38=
6-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i38=
6-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640490a796edc4b2b08c8=
65c
        failing since 19 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_i386-uefi         | i386   | lab-broonie     | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/6404908dfde8fb54188c865c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6404908dfde8fb54188c8=
65d
        failing since 19 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6404905fc49cb02d6e8c865d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6404905fc49cb02d6e8c8=
65e
        failing since 19 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640490cec59fd16e0f8c8661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640490cec59fd16e0f8c8=
662
        failing since 19 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64049066b4ead325388c8638

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64049066b4ead325388c8=
639
        failing since 19 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640490a196edc4b2b08c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640490a196edc4b2b08c8=
633
        failing since 19 days (last pass: v5.15.93-48-g91b0616b8246, first =
fail: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6404905dd5797b7d3e8c8631

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6404905dd5797b7d3e8c8=
632
        failing since 7 days (last pass: v5.15.95-33-gc82275c7e6c8, first f=
ail: v5.15.95-37-gda3256d1340e) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640490cfaa7a6ea2e88c865f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640490cfaa7a6ea2e88c8=
660
        failing since 10 days (last pass: v5.15.95-30-gccb2246d6916, first =
fail: v5.15.95-33-gc82275c7e6c8) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64049065b4ead325388c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64049065b4ead325388c8=
631
        failing since 7 days (last pass: v5.15.95-33-gc82275c7e6c8, first f=
ail: v5.15.95-37-gda3256d1340e) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640490caaa7a6ea2e88c864c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.98-=
430-gf4021390fc22/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640490caaa7a6ea2e88c8=
64d
        failing since 10 days (last pass: v5.15.95-30-gccb2246d6916, first =
fail: v5.15.95-33-gc82275c7e6c8) =

 =20
