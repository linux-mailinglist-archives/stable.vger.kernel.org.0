Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A1A6BB620
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 15:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjCOOfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 10:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjCOOfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 10:35:09 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F267D520
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:35:05 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id v21so10120142ple.9
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678890904;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Mk5UWnU4LCOvz7cBTLS7He8dWX8s233ww9rtuXB79uo=;
        b=Nmr9RhTplOBlV35hE1Vv2kmdYZRFu50hsgz5W0AGDUdjH/9HYfR4JfT1G3Y+jGtX3c
         A5RyzjXTc0VrWYaX8IsvlFzdCKVO572wJFCz2O6aqvdov4KddELaUA5MhxhSTvlfKUh8
         JtppbAgIZtSJsMvsvAURnvF0sOZeUD/xYgnNkpXvGW44hM+zLF4M3HP81d1kV387Ctn6
         sFkZ/qv1uWxqEtJxOag/ZU58W31l1Tl7CQdkd4eBmrJP2fXVz7T98tcMGqFRR1HTot0s
         Zmg8OlvTJkmmEEjgLvnHmgd95Tfwxw8O2Cw/9YpnWOMgcbHVRB8bDWo13xCRqPV51nQ+
         029g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678890904;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mk5UWnU4LCOvz7cBTLS7He8dWX8s233ww9rtuXB79uo=;
        b=CepCvPcTfEg2k6GKMyvDw03eYgc+QqXTIfWS6VvGDC7DH2/Jy32omf02DnUq1+dlzf
         0bX79Mi14rGzEyCbbStEQJI4vsWYXGk7a4wa7GSRS0ziEVM8ltvx+3b1PAvIRsPBNMdO
         QJzmvIbUC1/ACQBwYhH9WiA2xZb8tH95bvwc1n8DNrak7MgLZD6HrGztATm2x5Dv34E/
         mTAlWAiSngN9275eVpjYwfZiDm7oZ5pj3OWYtHlsuAS8RIUye+ZJ8FovKdqAKcV7ayiN
         u7H6g/iRoKhUoviWMWYxP22pyc2omt4kPBvqdtj5SOMo2YTITgYBfagaMS36tWlDSfhr
         qIwQ==
X-Gm-Message-State: AO0yUKVP4cpn0FuJDzLoLEXKLUHgq1nBlWllfuN27NJ6xw1UTOzqLaay
        oPvaEM0AbMYrtA/nb9L2lU2tAWKKhKib2UYT9MoqAthe
X-Google-Smtp-Source: AK7set8iwFZJCDU/KdlsbUhk1yQew3CrMQK5NKKPTs8NvotD2lNR51+08fnqZ499swZKF54CApZb9A==
X-Received: by 2002:a17:902:f0ca:b0:1a1:7c2b:4aea with SMTP id v10-20020a170902f0ca00b001a17c2b4aeamr1260764pla.0.1678890904445;
        Wed, 15 Mar 2023 07:35:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kt16-20020a170903089000b0019a8b057359sm3739305plb.130.2023.03.15.07.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 07:35:04 -0700 (PDT)
Message-ID: <6411d798.170a0220.2e5d1.86d6@mx.google.com>
Date:   Wed, 15 Mar 2023 07:35:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.101-146-g4faa8112f175
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 171 runs,
 2 regressions (v5.15.101-146-g4faa8112f175)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 171 runs, 2 regressions (v5.15.101-146-g4f=
aa8112f175)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
cubietruck      | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =

fsl-lx2160a-rdb | arm64 | lab-nxp      | gcc-10   | defconfig          | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.101-146-g4faa8112f175/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.101-146-g4faa8112f175
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4faa8112f175ba2eb173966c20c5fdc4f26bd1c4 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
cubietruck      | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6411a25e799806eaa58c866b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
01-146-g4faa8112f175/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
01-146-g4faa8112f175/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6411a25e799806eaa58c8674
        failing since 57 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-03-15T10:47:38.642255  <8>[   10.005944] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3413336_1.5.2.4.1>
    2023-03-15T10:47:38.752451  / # #
    2023-03-15T10:47:38.856362  export SHELL=3D/bin/sh
    2023-03-15T10:47:38.857246  #
    2023-03-15T10:47:38.959291  / # export SHELL=3D/bin/sh. /lava-3413336/e=
nvironment
    2023-03-15T10:47:38.960175  =

    2023-03-15T10:47:39.061738  / # . /lava-3413336/environment/lava-341333=
6/bin/lava-test-runner /lava-3413336/1
    2023-03-15T10:47:39.062420  =

    2023-03-15T10:47:39.067302  / # /lava-3413336/bin/lava-test-runner /lav=
a-3413336/1
    2023-03-15T10:47:39.153885  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
fsl-lx2160a-rdb | arm64 | lab-nxp      | gcc-10   | defconfig          | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6411a3b05be3d220448c8631

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
01-146-g4faa8112f175/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
01-146-g4faa8112f175/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6411a3b05be3d220448c8638
        failing since 11 days (last pass: v5.15.79, first fail: v5.15.98)

    2023-03-15T10:53:17.315647  [   15.830981] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1173661_1.5.2.4.1>
    2023-03-15T10:53:17.421350  / # #
    2023-03-15T10:53:17.522978  export SHELL=3D/bin/sh
    2023-03-15T10:53:17.523376  #
    2023-03-15T10:53:17.624660  / # export SHELL=3D/bin/sh. /lava-1173661/e=
nvironment
    2023-03-15T10:53:17.625211  =

    2023-03-15T10:53:17.726767  / # . /lava-1173661/environment/lava-117366=
1/bin/lava-test-runner /lava-1173661/1
    2023-03-15T10:53:17.727591  =

    2023-03-15T10:53:17.730072  / # /lava-1173661/bin/lava-test-runner /lav=
a-1173661/1
    2023-03-15T10:53:17.746737  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
