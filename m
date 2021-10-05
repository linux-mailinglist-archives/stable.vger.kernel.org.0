Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488A4422C87
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 17:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhJEPd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 11:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhJEPd0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 11:33:26 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA01C061749
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 08:31:35 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id x4so2565404pln.5
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 08:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hSESgfqVAcjJ9oJdHyWqNt0rchTNhCExywT+Hg6KaME=;
        b=WaZvds+1E/slUdSi8tgzHl+nYM/KTBqhQEGJloINXnAEui8DM9vC528DsBQfmEQhyy
         UqJVEiqlXBfHouNSsLcLkpgRzgtWddueeLD06Ri6U8/ng2lzWSa8vvhHv4mUjIoRVdq9
         Ra2/WzN+bCFESqG40OX21JsdbaYF2MVd7lFGIN2Q77AHZXwQ4qet9SWgqfJeIz5ZFLvw
         p7Ufsy4ya460PV8HKoJunsPUoC6wQkwVYUoJtDWxzB6M3Rbp/JGBqrceOWCZ14IqA8nA
         jgDa8tG+nF/tcntYBUOYDotsq4gGdkzx1BH6doceL+z1QIwZkg6VvsJG/eSYAZjhOq4A
         iRNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hSESgfqVAcjJ9oJdHyWqNt0rchTNhCExywT+Hg6KaME=;
        b=7Bharg3JOHwQaog6AHkB+RWs0pXyT5KboqR/oC/xrt+OneS2EJUL8r6WRk17WTPJtR
         lXu/YgDqCTWmUXivzf/lhXykfcl49Upv8pAWU/v1VGyCuYENoZQYaHKxahW0XHzkYaz6
         NpmFQzJP9gjHRN3ZzVDlAENrhYbkFRJ8rL7D97H4OPDgQywOPEWlsbtQ0LYmbFqF+Th6
         Ecnfu3k+MU+R6Ile+sRHGdsxqwZv93yPC6vq8+TN+aSp2gHdMuQG97TjK2cbN11yG1oL
         y9zDt6hAd0ljEWlKIVINlI15dkgG1GwpGdbtyf6iIAYrWE3dFPtCHxoNyu6EsWSGn/qy
         ihwQ==
X-Gm-Message-State: AOAM531IzgaRa3o/QZK1Fag92FH5kkVPKPY01Dgq7gqBxru/yFHTTWNg
        NxJ2dPo6c1e4iswy0bmLzhJ0jEkv7FHfDWv0
X-Google-Smtp-Source: ABdhPJzA2CDZye9kpXEXnOTopFhgf0jVIVyWBpl2IJ9z1uLcPgn9/Ns+vd1Ah2iuUbX3hndd/iAiyA==
X-Received: by 2002:a17:903:246:b0:13a:8c8:8a31 with SMTP id j6-20020a170903024600b0013a08c88a31mr5723904plh.87.1633447895179;
        Tue, 05 Oct 2021 08:31:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e12sm18306612pgv.82.2021.10.05.08.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 08:31:34 -0700 (PDT)
Message-ID: <615c6fd6.1c69fb81.1b193.8629@mx.google.com>
Date:   Tue, 05 Oct 2021 08:31:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.208-95-g55efedf0abfc
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 128 runs,
 3 regressions (v4.19.208-95-g55efedf0abfc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 128 runs, 3 regressions (v4.19.208-95-g55efe=
df0abfc)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.208-95-g55efedf0abfc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.208-95-g55efedf0abfc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      55efedf0abfc3284a501c0bac1337e6ab62057f7 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615c3a4ca93285827399a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g55efedf0abfc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g55efedf0abfc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c3a4ca93285827399a=
2f3
        failing since 325 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615c4ff9206c00ada599a30a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g55efedf0abfc/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g55efedf0abfc/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c4ff9206c00ada599a=
30b
        failing since 325 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615c3a5c6669965b9d99a2e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g55efedf0abfc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g55efedf0abfc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c3a5c6669965b9d99a=
2e2
        failing since 325 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
