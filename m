Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2256ABF91
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 13:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjCFMeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 07:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjCFMd7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 07:33:59 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944831968E
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 04:33:55 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id x34so9637615pjj.0
        for <stable@vger.kernel.org>; Mon, 06 Mar 2023 04:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678106035;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=V3FY/QMIp3O9jt+V348AbO5GemTGcqLYfOPv8Z80T+4=;
        b=bsnR1MgEWrADL2j9m+35H1q/jZpv4BcZ/RLQndiSn+6gtUMmD9oQlg2YEL9dusOH7j
         pAEWIgSKH42rgE2j9DWFDCCqzkPDxshDFcmOc9HNAwiVIcDVtvyL+a9S+bsofTHaraI+
         96poVufb5g99nHgeg9HkBd24YmTEZND7mWovHwQOJy1gVVGqOsAVWvqYb8aZb5WRr7Wt
         QbylFLExM7btGkyAxaP0NSvzGhUdBAtQZHugV2wXFhHJZrvW1Pln8sOOOW/yCJG9605p
         UH5r/xwXnxaXF4Aayp5Fb3UN5iW61MX9Gp7ndQ1SLcBM2O55BmiGKjiDJ1g3x50GbAq2
         rduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678106035;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V3FY/QMIp3O9jt+V348AbO5GemTGcqLYfOPv8Z80T+4=;
        b=45mSxOsfBPXbTkvlRDfabBeVRrCNKVwvpZVjEQpqI/hT/M8ZMAH22qjm6uvI4FkX0M
         uVdkcSwc8UAuxHPxK5NJCF5SHRwpU5SyuJ4UHyfAuL8W6R/LYEoZZCTUSiPvyRp2bDTt
         9W3KKZVID7JmcN09OqKdsL/FFAxr4Gyo5NoqgHsK4IlqFf3JPLS8YIlP5ep4ShoIOE/B
         b16r4Af1wFDFb7Qcn9tw8VLRSXgJBMGRJYgz53JqCrx3Pmz0ac/oDPwsRY6uXQGmhy2E
         /apZ7OXGUiNwHz1bMiVlV5btpWws0dVLpk5aH3MlaQwHvwG3jGkfibVUYD+u6ntovYVh
         Fr2w==
X-Gm-Message-State: AO0yUKVxpTixmqKhjgU6XwTSedgeEngR2coC6G+V/cxwqS9YIJZPKkM0
        4ahlus9Dn6NOE2hzE/MvcKXBN+H6Afz+PNO0ZcXQT6EE
X-Google-Smtp-Source: AK7set9ptTc09u+pgXfwXUJEqpxXB33kxeceydwJVc6RNRrwOIh9PYbK4oa2abFHUPL38wkRgKJhnA==
X-Received: by 2002:a17:903:2291:b0:19e:b988:e81f with SMTP id b17-20020a170903229100b0019eb988e81fmr6243962plh.0.1678106034777;
        Mon, 06 Mar 2023 04:33:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s2-20020a170902ea0200b001992fc0a8eesm6593788plg.174.2023.03.06.04.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 04:33:54 -0800 (PST)
Message-ID: <6405ddb2.170a0220.aab73.af0b@mx.google.com>
Date:   Mon, 06 Mar 2023 04:33:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.15-650-g40afe6d834bf
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 133 runs,
 4 regressions (v6.1.15-650-g40afe6d834bf)
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

stable-rc/queue/6.1 baseline: 133 runs, 4 regressions (v6.1.15-650-g40afe6d=
834bf)

Regressions Summary
-------------------

platform               | arch   | lab           | compiler | defconfig     =
    | regressions
-----------------------+--------+---------------+----------+---------------=
----+------------
bcm2835-rpi-b-rev2     | arm    | lab-broonie   | gcc-10   | bcm2835_defcon=
fig | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig  | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig  | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.15-650-g40afe6d834bf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.15-650-g40afe6d834bf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      40afe6d834bf9907b777aac924240b4ee9d262e9 =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
    | regressions
-----------------------+--------+---------------+----------+---------------=
----+------------
bcm2835-rpi-b-rev2     | arm    | lab-broonie   | gcc-10   | bcm2835_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6405a6e1fa81589bcc8c863c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-65=
0-g40afe6d834bf/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-65=
0-g40afe6d834bf/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6405a6e1fa81589bcc8c8645
        failing since 8 days (last pass: v6.1.13-47-ge942f47f1a6d, first fa=
il: v6.1.13-47-g106bc513b009)

    2023-03-06T08:39:40.297652  + set +x
    2023-03-06T08:39:40.301401  <8>[   17.804705] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 105918_1.5.2.4.1>
    2023-03-06T08:39:40.419238  / # #
    2023-03-06T08:39:40.521771  export SHELL=3D/bin/sh
    2023-03-06T08:39:40.522528  #
    2023-03-06T08:39:40.624352  / # export SHELL=3D/bin/sh. /lava-105918/en=
vironment
    2023-03-06T08:39:40.625417  =

    2023-03-06T08:39:40.727405  / # . /lava-105918/environment/lava-105918/=
bin/lava-test-runner /lava-105918/1
    2023-03-06T08:39:40.728689  =

    2023-03-06T08:39:40.734751  / # /lava-105918/bin/lava-test-runner /lava=
-105918/1 =

    ... (14 line(s) more)  =

 =



platform               | arch   | lab           | compiler | defconfig     =
    | regressions
-----------------------+--------+---------------+----------+---------------=
----+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6405a65e032330baa48c8641

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-65=
0-g40afe6d834bf/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-65=
0-g40afe6d834bf/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6405a65e032330baa48c8=
642
        failing since 1 day (last pass: v6.1.15-4-gf9fbed52efb7, first fail=
: v6.1.15-651-g1da2ded14cbf3) =

 =



platform               | arch   | lab           | compiler | defconfig     =
    | regressions
-----------------------+--------+---------------+----------+---------------=
----+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6405a64e4655e9b5c18c86ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-65=
0-g40afe6d834bf/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-65=
0-g40afe6d834bf/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6405a64e4655e9b5c18c8=
6ad
        failing since 1 day (last pass: v6.1.15-4-gf9fbed52efb7, first fail=
: v6.1.15-651-g1da2ded14cbf3) =

 =



platform               | arch   | lab           | compiler | defconfig     =
    | regressions
-----------------------+--------+---------------+----------+---------------=
----+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6405a640d53d7858318c8654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-65=
0-g40afe6d834bf/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-65=
0-g40afe6d834bf/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6405a640d53d7858318c8=
655
        failing since 1 day (last pass: v6.1.15-4-gf9fbed52efb7, first fail=
: v6.1.15-651-g1da2ded14cbf3) =

 =20
