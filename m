Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7EC16AC1FF
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 14:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjCFN5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 08:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbjCFN5Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 08:57:16 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F7F305FC
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 05:57:14 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so13215752pjg.4
        for <stable@vger.kernel.org>; Mon, 06 Mar 2023 05:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678111033;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=p7B+mSQizgNIfqOIjEI7lBAUozvRzjmVZ3G7iy4AUcY=;
        b=VFe+dytHDk0QTZxrx7jVQMYdxlp+luZua4Ck/jCHlFEzGtXx84J3yPZBZrhDNhJvp4
         By68F+DBGS6FqyoCf+TjW/Caf++hLulOAfgCXZc4KOj3mQNluVMk5aNbtnvsrtaxInbh
         X9GYqcQH9CWNLdgmAiwlq4w6GrYV2aCcRvAb/zrHnIUuzvF08z4cqOXqAV/4+ulKKP8a
         z6vg3tjqRNuKMGRw5k5JdexKsE4rhtzi6r3CxJX5gQBS23pTpXEUWco8amc9alWtIQEM
         44M3kBAbS913fBQw7ZUCkijp9XiBoNqGurIRiuww96k587L3fCIghNiJtTd9ouu5Dy7q
         RQWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678111033;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p7B+mSQizgNIfqOIjEI7lBAUozvRzjmVZ3G7iy4AUcY=;
        b=iRhpfrNVQaUlOiEzqk+mvQftv8Uyat7FJwL4WYPwBH54QqXM3P0eIvzScvhaH0Zqhh
         uBVmzulv4ywdSU6XlJ1/vopdrwJRzEaZBrSfDfQ3O+Nz8AhRzsmnTTbKF7IlizH9Rmcw
         yXSnx45A6P9hv6V6jvBHCLur9oPj/ebeO7rosb8/jahL/uoEuE4Bo0ChsjPcT4NRatHi
         /5z2oIqSyvH6BdRYD6IHMasAE+mGwpeEoYqQ2SKF4wzcfCh+boiBAJnMTNRyfEy243AL
         pFn80wYBY6DFsKKYrpMFWz6rlCoTIdn11T/n4cApwipavwTZYp8oolMx/i9f7wP6NEcd
         Ht/A==
X-Gm-Message-State: AO0yUKUhmUU7tER/VNY8qj1SYUGg8JcE+k/shlnMPITe2kjOpD8Kbc7G
        95wawXELLCOAfgwZbSONbrHB5aDTdqBPl+TMmu4hc8oi
X-Google-Smtp-Source: AK7set+jozYZA4pkUo/89nmBmKGoQTkv+OFyYcAmbKlf35/KRlUiCIwZYzOQX2qhaJy0pk7LJ3d+cQ==
X-Received: by 2002:a17:902:e5d2:b0:19a:75b8:f50c with SMTP id u18-20020a170902e5d200b0019a75b8f50cmr13724804plf.31.1678111033634;
        Mon, 06 Mar 2023 05:57:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l19-20020a170902f69300b0019956488546sm6739928plg.277.2023.03.06.05.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 05:57:13 -0800 (PST)
Message-ID: <6405f139.170a0220.c57eb.b36f@mx.google.com>
Date:   Mon, 06 Mar 2023 05:57:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.15-660-g430daf603d29
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 90 runs,
 4 regressions (v6.1.15-660-g430daf603d29)
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

stable-rc/queue/6.1 baseline: 90 runs, 4 regressions (v6.1.15-660-g430daf60=
3d29)

Regressions Summary
-------------------

platform               | arch   | lab           | compiler | defconfig     =
   | regressions
-----------------------+--------+---------------+----------+---------------=
---+------------
qemu_mips-malta        | mips   | lab-collabora | gcc-10   | malta_defconfi=
g  | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.15-660-g430daf603d29/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.15-660-g430daf603d29
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      430daf603d298c26d6b7cefb64e062844156a215 =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
   | regressions
-----------------------+--------+---------------+----------+---------------=
---+------------
qemu_mips-malta        | mips   | lab-collabora | gcc-10   | malta_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/6405ba52d96edb85748c863b

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-66=
0-g430daf603d29/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-66=
0-g430daf603d29/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6405ba52d96edb8=
5748c863f
        new failure (last pass: v6.1.15-650-g40afe6d834bf)
        1 lines

    2023-03-06T10:02:50.297344  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 7b336314, epc =3D=3D 80201bd4, ra =3D=
=3D 80204524
    2023-03-06T10:02:50.297491  =


    2023-03-06T10:02:50.325407  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-03-06T10:02:50.325495  =

   =

 =



platform               | arch   | lab           | compiler | defconfig     =
   | regressions
-----------------------+--------+---------------+----------+---------------=
---+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6405b9fb670ca2d0ef8c863b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-66=
0-g430daf603d29/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-66=
0-g430daf603d29/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6405b9fb670ca2d0ef8c8=
63c
        failing since 1 day (last pass: v6.1.15-4-gf9fbed52efb7, first fail=
: v6.1.15-651-g1da2ded14cbf3) =

 =



platform               | arch   | lab           | compiler | defconfig     =
   | regressions
-----------------------+--------+---------------+----------+---------------=
---+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6405b9ecf9e56147ea8c864c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-66=
0-g430daf603d29/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-66=
0-g430daf603d29/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6405b9ecf9e56147ea8c8=
64d
        failing since 1 day (last pass: v6.1.15-4-gf9fbed52efb7, first fail=
: v6.1.15-651-g1da2ded14cbf3) =

 =



platform               | arch   | lab           | compiler | defconfig     =
   | regressions
-----------------------+--------+---------------+----------+---------------=
---+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6405b9d8d66714cbb98c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-66=
0-g430daf603d29/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-66=
0-g430daf603d29/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6405b9d8d66714cbb98c8=
630
        failing since 1 day (last pass: v6.1.15-4-gf9fbed52efb7, first fail=
: v6.1.15-651-g1da2ded14cbf3) =

 =20
