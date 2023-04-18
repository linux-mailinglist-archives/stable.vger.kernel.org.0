Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8976E6EB6
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 23:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbjDRV5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 17:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbjDRV5O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 17:57:14 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D793C3580
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 14:57:12 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1a6cf95d559so12435875ad.3
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 14:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681855032; x=1684447032;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=hlVju5bQ1xkd5pyaFr2Vw13D9EMP9TOLqdGDuA/96yM=;
        b=KxWgXib/b70jPm9rC3z4G259jOumxsR/MMTCRG5pcBqjV8nN7XEdktt2tP+MdZwuTJ
         raHDMOIR5OH7N+Szat+Z88ENnGZyt/gu3QRHj+B81J2nXkYQdvp7obps6uk5p8XERtq6
         UMZIvm8YM3aW8NuNok8d/+7s0txK9Fu2+Eyfhx19voEZ33vEPr6oV7raOKzKjYcgwviV
         RZ8KfSTj0BqPJwvQ/eH+RaCtsHnt+K0OuhAEUtaLP/bmxXhOgNj0VtaM4cFsVQgTSehG
         h+MGhe0E+aghBV4+0a5Z19+SDO8bv16TNOZQoD35z7XR82zA4C2uUS11ApKC/7fjY+nA
         zsQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681855032; x=1684447032;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hlVju5bQ1xkd5pyaFr2Vw13D9EMP9TOLqdGDuA/96yM=;
        b=K+foKzON3H/AlfYba8rzyYMfFgFEi70wEpeypCdrdlkzvPZDCGcznogJ69ADVhnaPT
         895uDFtsDoc/wzd0gjdew0AbjOVBGsPRIt2M/IvvtNLKAFUQMSYsJCiHIEVxhm++s8A/
         g87Tv75yQc8FpsS64q5sWDoWwOc20lDA4kp+sohVe3zrO7AWFmYhh8U2VUf5bGKIYGHA
         JLCu8iX0bDY1/AHMBCAKAFZBGdLvhSAgueBXElbrkD1WO0t9o3mUa686QF0EBkrkwb3j
         b1T2+ROrKyn+glMLovlJiDk43yplTgdNwPFtteCyyVJ+Q3E/aC+hXYBSe9XvHG51b+Ls
         ZLNA==
X-Gm-Message-State: AAQBX9cHSTcRlfi+grX9Z+UYjg/OU23fmBaIZbFhWhLbtopcvVd7ZQ6c
        WpnGXMMYZLvKA6vou0s6kUVg1Il3hh46fwgXsSql9PBr
X-Google-Smtp-Source: AKy350b1kZ80aihsG2b3l1gDpY/LPyxfquEa4rS8MEAEJTpr8Y/9KKSRMaeTOHvb6XNeq1NI7nokVg==
X-Received: by 2002:a17:903:1245:b0:19f:1871:3dcd with SMTP id u5-20020a170903124500b0019f18713dcdmr3630991plh.5.1681855032092;
        Tue, 18 Apr 2023 14:57:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e11-20020a170902b78b00b0019acd3151d0sm10086018pls.114.2023.04.18.14.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 14:57:11 -0700 (PDT)
Message-ID: <643f1237.170a0220.bed4b.6eee@mx.google.com>
Date:   Tue, 18 Apr 2023 14:57:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-298-g19b9d9b9f62e
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 78 runs,
 2 regressions (v5.10.176-298-g19b9d9b9f62e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 78 runs, 2 regressions (v5.10.176-298-g19b=
9d9b9f62e)

Regressions Summary
-------------------

platform          | arch | lab          | compiler | defconfig          | r=
egressions
------------------+------+--------------+----------+--------------------+--=
----------
cubietruck        | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1=
          =

r8a7743-iwg20d-q7 | arm  | lab-cip      | gcc-10   | shmobile_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.176-298-g19b9d9b9f62e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.176-298-g19b9d9b9f62e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      19b9d9b9f62ea8e4affa74f1901b7a0c4ab90ef4 =



Test Regressions
---------------- =



platform          | arch | lab          | compiler | defconfig          | r=
egressions
------------------+------+--------------+----------+--------------------+--=
----------
cubietruck        | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/643ee0b6ec2491b1392e8606

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-298-g19b9d9b9f62e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-298-g19b9d9b9f62e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ee0b6ec2491b1392e860b
        failing since 90 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-04-18T18:25:36.869516  <8>[   11.065286] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3508868_1.5.2.4.1>
    2023-04-18T18:25:36.976582  / # #
    2023-04-18T18:25:37.077913  export SHELL=3D/bin/sh
    2023-04-18T18:25:37.078278  #
    2023-04-18T18:25:37.179417  / # export SHELL=3D/bin/sh. /lava-3508868/e=
nvironment
    2023-04-18T18:25:37.179734  =

    2023-04-18T18:25:37.280614  / # . /lava-3508868/environment/lava-350886=
8/bin/lava-test-runner /lava-3508868/1
    2023-04-18T18:25:37.281115  =

    2023-04-18T18:25:37.285742  / # /lava-3508868/bin/lava-test-runner /lav=
a-3508868/1
    2023-04-18T18:25:37.366172  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform          | arch | lab          | compiler | defconfig          | r=
egressions
------------------+------+--------------+----------+--------------------+--=
----------
r8a7743-iwg20d-q7 | arm  | lab-cip      | gcc-10   | shmobile_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/643ee035098d650d412e8600

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-298-g19b9d9b9f62e/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-298-g19b9d9b9f62e/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643ee035098d650d412e8=
601
        failing since 26 days (last pass: v5.10.175-100-g1686e1df6521, firs=
t fail: v5.10.176) =

 =20
