Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750356E987F
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 17:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjDTPkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 11:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbjDTPkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 11:40:09 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBF39F
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 08:40:07 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-63b509fe13eso920507b3a.1
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 08:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682005206; x=1684597206;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=s6Avk8X1jNV+l3JFKg5MXSw84lG7Zyz42ITKByhoLas=;
        b=eXEpbM5/GoGplb8YQ9yKOgaGNb8kOjMbqr2yh1Aw2s6kZ2z0S6w+Kjc2/oiiN7cjSL
         feAGPBGVkoblR9ntjdLltJj0FxzRyG8oZXbssNSyCnyclGjgvvmObmvPYsNrJ3JBCKDH
         OA1LC2sudjrRyzUmd9pugj/a3lJF+p32BWExIQiRsfy11q78Qq6OWLqL9b4JzkwDaRXX
         ivvi3aAEu8xB+eCSKWA3pYdF9xCcS12MG9/g15tJ4PZwseuo1M4gOT0ziMDcV/3YH5zB
         oVWFIE4lN18HYyDTRRvQaysBPE5g7Xu096iaC5fqWlpjR7axtPowFKSJHTfy3liz+6hM
         +B6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682005206; x=1684597206;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s6Avk8X1jNV+l3JFKg5MXSw84lG7Zyz42ITKByhoLas=;
        b=dMjtjh9PUPtXgY0MoGBZriy5B79LQ8StQKduk70iBm1jzSlgm4BTEykoHuOCQeCJU6
         eKSi7Y9XKwI9DuHvDLpolyc9Jq6PSBBWsXmoRbTzVgVAYBsKKVffJQlO/O4tAJecgcAd
         43FCeA8TLFH+ln7Wki/lt+NqfDg4Yd1BC38+zQyOjXLbyrrEkT1x31ao+kyzJoYGT7f6
         +Z++Qc0j57QvjT5dEytgid4RBU+TMMMcFCT5V7BclCvViMi8V1J5UBeGkJwZUvlZjcLP
         JmexDDUxxhkGsIy4zzFslt85eSDPpv+jCNYNX9iSOZBaeb3M8uDaRc4t5FlNB4Ao6bc8
         PWFg==
X-Gm-Message-State: AAQBX9dMQKHQvVFVwxNY6nXqXS7RiJSEF4qucXGhzYKMfEsUyt5SxjZ5
        sCJSEwxtmxR7J/JF9pL1/quy19VXJaAnl0PNAxlTIbYP
X-Google-Smtp-Source: AKy350ZAae3KfprCki5fK5N0jbccxJq3PpXBBlBLb7u979VhJ6AfS4VmcwiBRt4jBFH9xnBRiMBtLQ==
X-Received: by 2002:a05:6a00:1589:b0:63d:3a99:f9e0 with SMTP id u9-20020a056a00158900b0063d3a99f9e0mr1861244pfk.28.1682005206197;
        Thu, 20 Apr 2023 08:40:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j3-20020a635503000000b0051b72ef978fsm1289172pgb.20.2023.04.20.08.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 08:40:05 -0700 (PDT)
Message-ID: <64415cd5.630a0220.f9f89.25ef@mx.google.com>
Date:   Thu, 20 Apr 2023 08:40:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-474-gecc61872327e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 135 runs,
 11 regressions (v6.1.22-474-gecc61872327e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 baseline: 135 runs, 11 regressions (v6.1.22-474-gecc618=
72327e)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

imx6dl-riotboard             | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

kontron-pitx-imx8m           | arm64  | lab-kontron     | gcc-10   | defcon=
fig                    | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

qemu_mips-malta              | mips   | lab-collabora   | gcc-10   | malta_=
defconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-474-gecc61872327e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-474-gecc61872327e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ecc61872327e0311099318d6256540932d6efd91 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644127929251fe0e462e85f5

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644127929251fe0e462e85fa
        failing since 22 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-20T11:52:32.430817  + set +x

    2023-04-20T11:52:32.437336  <8>[   10.588688] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10060865_1.4.2.3.1>

    2023-04-20T11:52:32.546083  #

    2023-04-20T11:52:32.547445  =


    2023-04-20T11:52:32.649647  / # #export SHELL=3D/bin/sh

    2023-04-20T11:52:32.650416  =


    2023-04-20T11:52:32.752223  / # export SHELL=3D/bin/sh. /lava-10060865/=
environment

    2023-04-20T11:52:32.752977  =


    2023-04-20T11:52:32.854888  / # . /lava-10060865/environment/lava-10060=
865/bin/lava-test-runner /lava-10060865/1

    2023-04-20T11:52:32.856141  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644127a14ecf7c67c02e8616

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644127a14ecf7c67c02e861b
        failing since 22 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-20T11:52:50.678572  + set<8>[    9.030454] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10060902_1.4.2.3.1>

    2023-04-20T11:52:50.679213   +x

    2023-04-20T11:52:50.788128  / # #

    2023-04-20T11:52:50.890556  export SHELL=3D/bin/sh

    2023-04-20T11:52:50.891338  #

    2023-04-20T11:52:50.993209  / # export SHELL=3D/bin/sh. /lava-10060902/=
environment

    2023-04-20T11:52:50.993976  =


    2023-04-20T11:52:51.095999  / # . /lava-10060902/environment/lava-10060=
902/bin/lava-test-runner /lava-10060902/1

    2023-04-20T11:52:51.097301  =


    2023-04-20T11:52:51.102645  / # /lava-10060902/bin/lava-test-runner /la=
va-10060902/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644127964d78424fee2e862a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644127964d78424fee2e862f
        failing since 22 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-20T11:52:33.730712  <8>[   10.568254] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10060839_1.4.2.3.1>

    2023-04-20T11:52:33.734241  + set +x

    2023-04-20T11:52:33.835945  =


    2023-04-20T11:52:33.936870  / # #export SHELL=3D/bin/sh

    2023-04-20T11:52:33.937027  =


    2023-04-20T11:52:34.037924  / # export SHELL=3D/bin/sh. /lava-10060839/=
environment

    2023-04-20T11:52:34.038077  =


    2023-04-20T11:52:34.138982  / # . /lava-10060839/environment/lava-10060=
839/bin/lava-test-runner /lava-10060839/1

    2023-04-20T11:52:34.139319  =


    2023-04-20T11:52:34.143859  / # /lava-10060839/bin/lava-test-runner /la=
va-10060839/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64412966c3d79e46302e8613

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64412966c3d79e46302e8=
614
        new failure (last pass: v6.1.22-477-g2128d4458cbc) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644127a034438094692e8630

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644127a034438094692e8635
        failing since 22 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-20T11:52:49.374608  + set +x

    2023-04-20T11:52:49.381502  <8>[   10.997647] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10060894_1.4.2.3.1>

    2023-04-20T11:52:49.486254  / # #

    2023-04-20T11:52:49.587325  export SHELL=3D/bin/sh

    2023-04-20T11:52:49.587541  #

    2023-04-20T11:52:49.688440  / # export SHELL=3D/bin/sh. /lava-10060894/=
environment

    2023-04-20T11:52:49.688627  =


    2023-04-20T11:52:49.789547  / # . /lava-10060894/environment/lava-10060=
894/bin/lava-test-runner /lava-10060894/1

    2023-04-20T11:52:49.789894  =


    2023-04-20T11:52:49.794787  / # /lava-10060894/bin/lava-test-runner /la=
va-10060894/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6441278a4d78424fee2e8616

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6441278a4d78424fee2e861b
        failing since 22 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-20T11:52:26.008501  <8>[    9.927272] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10060869_1.4.2.3.1>

    2023-04-20T11:52:26.012027  + set +x

    2023-04-20T11:52:26.116631  / # #

    2023-04-20T11:52:26.217652  export SHELL=3D/bin/sh

    2023-04-20T11:52:26.217857  #

    2023-04-20T11:52:26.318718  / # export SHELL=3D/bin/sh. /lava-10060869/=
environment

    2023-04-20T11:52:26.318910  =


    2023-04-20T11:52:26.419819  / # . /lava-10060869/environment/lava-10060=
869/bin/lava-test-runner /lava-10060869/1

    2023-04-20T11:52:26.420093  =


    2023-04-20T11:52:26.425955  / # /lava-10060869/bin/lava-test-runner /la=
va-10060869/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644127a02e315ecbde2e8604

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644127a02e315ecbde2e8609
        failing since 22 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-20T11:52:44.280038  + set<8>[   10.856143] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10060905_1.4.2.3.1>

    2023-04-20T11:52:44.280121   +x

    2023-04-20T11:52:44.384760  / # #

    2023-04-20T11:52:44.485769  export SHELL=3D/bin/sh

    2023-04-20T11:52:44.485928  #

    2023-04-20T11:52:44.586676  / # export SHELL=3D/bin/sh. /lava-10060905/=
environment

    2023-04-20T11:52:44.586858  =


    2023-04-20T11:52:44.687617  / # . /lava-10060905/environment/lava-10060=
905/bin/lava-test-runner /lava-10060905/1

    2023-04-20T11:52:44.687961  =


    2023-04-20T11:52:44.692609  / # /lava-10060905/bin/lava-test-runner /la=
va-10060905/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6dl-riotboard             | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/644127f33115d241582e85ec

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644127f33115d241582e85f1
        new failure (last pass: v6.1.22-477-g2128d4458cbc)

    2023-04-20T11:54:05.874936  + set[   14.885279] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 932166_1.5.2.3.1>
    2023-04-20T11:54:05.875146   +x
    2023-04-20T11:54:05.981324  / # #
    2023-04-20T11:54:06.083106  export SHELL=3D/bin/sh
    2023-04-20T11:54:06.083565  #
    2023-04-20T11:54:06.184810  / # export SHELL=3D/bin/sh. /lava-932166/en=
vironment
    2023-04-20T11:54:06.185342  =

    2023-04-20T11:54:06.286654  / # . /lava-932166/environment/lava-932166/=
bin/lava-test-runner /lava-932166/1
    2023-04-20T11:54:06.287420  =

    2023-04-20T11:54:06.290541  / # /lava-932166/bin/lava-test-runner /lava=
-932166/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
kontron-pitx-imx8m           | arm64  | lab-kontron     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64412c1b450e1d12822e8687

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-im=
x8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-im=
x8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64412c1b450e1d12822e8=
688
        new failure (last pass: v6.1.22-477-g2128d4458cbc) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6441279fa67ed06d322e860f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6441279fa67ed06d322e8614
        failing since 22 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-20T11:52:46.281639  <8>[   11.561098] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10060872_1.4.2.3.1>

    2023-04-20T11:52:46.386731  / # #

    2023-04-20T11:52:46.487614  export SHELL=3D/bin/sh

    2023-04-20T11:52:46.487780  #

    2023-04-20T11:52:46.588689  / # export SHELL=3D/bin/sh. /lava-10060872/=
environment

    2023-04-20T11:52:46.588873  =


    2023-04-20T11:52:46.689804  / # . /lava-10060872/environment/lava-10060=
872/bin/lava-test-runner /lava-10060872/1

    2023-04-20T11:52:46.690076  =


    2023-04-20T11:52:46.694181  / # /lava-10060872/bin/lava-test-runner /la=
va-10060872/1

    2023-04-20T11:52:46.700944  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_mips-malta              | mips   | lab-collabora   | gcc-10   | malta_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/64412a605de75624ac2e8621

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
4-gecc61872327e/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64412a605de75624ac2e8=
622
        failing since 2 days (last pass: v6.1.22-462-g16a9aa862d1a, first f=
ail: v6.1.22-479-g35f051d5ebe4) =

 =20
