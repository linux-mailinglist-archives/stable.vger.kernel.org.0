Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007606D2BF7
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 02:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbjDAACr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 20:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjDAACr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 20:02:47 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8988CA
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 17:02:45 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id d13so22151716pjh.0
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 17:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680307365;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=VjwGt4COLfqLs/qz8Tu6HB5c6aFTQDY0uUOw6llzjEQ=;
        b=zgUPqfy99TI9Jt8rB91MBGgSNcxgdaF7pFq3cIrxrwp/dwUxX0+x+WGLm34QDFgTMg
         9C425GWLGkhIRWB669imdhGydY7JPktaX1JVu+RaKkZho79MihJKKs9v+Ql7yZmDP5zQ
         D/cbRCZl2kL74cQ2zQ2d8YVGuiRV19CwsOHjh9nt/SfhVmL9Vk//FHcHntlHgKpOaIUs
         j6enDAMvINntZNB8f0pzh8Ezgip+XX/+Uf18OqN6zhE9v6JxrKYBtjJS6io5MfGlvnVA
         lKEYmIra3OLCYBzlGKS1gGssmeZtMLHJEOcSzt0pCWd+/RVGgu1WRJYhCH5e+soPgZCA
         SWSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680307365;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VjwGt4COLfqLs/qz8Tu6HB5c6aFTQDY0uUOw6llzjEQ=;
        b=uqpeg0hYbCIJdr/kzAim2pn1NiUzLkMHRUvp13IvWD06GvIZv5GVW4WATpRAkfAqIX
         8l6TCxt+MYqpDR9EIa7J7wy5SlyBDuQsbnxqq44FIYRihzttbGti9lcGcZjCm6mleEsb
         lAAzY5TJ25TkPVO33mNDtDADx9E9xT3fTPqAPs4RjCrv2whp8CQvr8CIFlGNe3EolMro
         v7GwIOY2OPaxdh7D9Jh3UtZ7HCpCn4JRbzlHXquLeyRq8rEO7GzvGzoa1y0ToDw1LMYo
         h0rbAsx8pxRIkwd3+2uiPb19wAVQ7qJPA3XRwxx+NeNmeo+xevb4T4oMi7GNeFXx9IEY
         AJhw==
X-Gm-Message-State: AO0yUKUE1U8Ic/IjBQnDDFoOja/ZOGEae7SbiaKZZvMP+3OaDL6l3ZO0
        jjxrFJ0wvK2Qt1S9HT5cWGEO2Raq55YTlz3VWNLpXw==
X-Google-Smtp-Source: AK7set+T5qq9K5Ns+ckjh1XP+TQD+8ud3VQCA3stmvrREWXTc0uXTXuSK9a2jOZs/m/odwIZ7Cr37g==
X-Received: by 2002:a05:6a20:1994:b0:d9:9994:5136 with SMTP id bz20-20020a056a20199400b000d999945136mr21135893pzb.7.1680307364915;
        Fri, 31 Mar 2023 17:02:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 18-20020a630d52000000b005033e653a17sm2076214pgn.85.2023.03.31.17.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 17:02:44 -0700 (PDT)
Message-ID: <642774a4.630a0220.c7dfb.5007@mx.google.com>
Date:   Fri, 31 Mar 2023 17:02:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.279-62-gd009556a422b
Subject: stable-rc/queue/4.19 baseline: 105 runs,
 2 regressions (v4.19.279-62-gd009556a422b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 105 runs, 2 regressions (v4.19.279-62-gd0095=
56a422b)

Regressions Summary
-------------------

platform      | arch | lab          | compiler | defconfig          | regre=
ssions
--------------+------+--------------+----------+--------------------+------=
------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | multi_v5_defconfig | 1    =
      =

cubietruck    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.279-62-gd009556a422b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.279-62-gd009556a422b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d009556a422b6858920c1bba8854ef52d7cacdb0 =



Test Regressions
---------------- =



platform      | arch | lab          | compiler | defconfig          | regre=
ssions
--------------+------+--------------+----------+--------------------+------=
------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | multi_v5_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6427403846b773494562f779

  Results:     42 PASS, 9 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-62-gd009556a422b/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-62-gd009556a422b/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6427403846b773494562f7ab
        failing since 4 days (last pass: v4.19.279-25-g8270940878fa3, first=
 fail: v4.19.279-25-gc95d797f10041)

    2023-03-31T20:18:22.798859  + set +x
    2023-03-31T20:18:22.804085  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 259876_1.5.2=
.4.1>
    2023-03-31T20:18:22.916960  / # #
    2023-03-31T20:18:23.019776  export SHELL=3D/bin/sh
    2023-03-31T20:18:23.020531  #
    2023-03-31T20:18:23.122455  / # export SHELL=3D/bin/sh. /lava-259876/en=
vironment
    2023-03-31T20:18:23.123208  =

    2023-03-31T20:18:23.225177  / # . /lava-259876/environment/lava-259876/=
bin/lava-test-runner /lava-259876/1
    2023-03-31T20:18:23.226483  =

    2023-03-31T20:18:23.232829  / # /lava-259876/bin/lava-test-runner /lava=
-259876/1 =

    ... (12 line(s) more)  =

 =



platform      | arch | lab          | compiler | defconfig          | regre=
ssions
--------------+------+--------------+----------+--------------------+------=
------
cubietruck    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/642740e0ec3d622ebf62f790

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-62-gd009556a422b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-62-gd009556a422b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642740e0ec3d622ebf62f795
        failing since 73 days (last pass: v4.19.269-9-gce7b59ec9d48, first =
fail: v4.19.269-521-g305d312d039a)

    2023-03-31T20:21:34.548564  <8>[    7.394970] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3459941_1.5.2.4.1>
    2023-03-31T20:21:34.659535  / # #
    2023-03-31T20:21:34.762928  export SHELL=3D/bin/sh
    2023-03-31T20:21:34.763895  #
    2023-03-31T20:21:34.865959  / # export SHELL=3D/bin/sh. /lava-3459941/e=
nvironment
    2023-03-31T20:21:34.866951  =

    2023-03-31T20:21:34.969198  / # . /lava-3459941/environment/lava-345994=
1/bin/lava-test-runner /lava-3459941/1
    2023-03-31T20:21:34.970757  =

    2023-03-31T20:21:34.975532  / # /lava-3459941/bin/lava-test-runner /lav=
a-3459941/1
    2023-03-31T20:21:35.059174  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
