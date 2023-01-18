Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148B867272E
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 19:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjARShl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 13:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbjARSh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 13:37:29 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA5E5D7E8
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 10:37:07 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id v23so32887985plo.1
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 10:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=u76jeNBDQqlq+ejUYF0QunxLKhjbabH/yFPYyPECv6c=;
        b=hvfUmYkuyQY6uDhHfNEzR5v+cD2zGDoKw8iFclod/DuRYatHQyNVYl0Ke127p58lae
         odHr+MsabZGb28Wd7WcW26/W1PWh5DnsDjkcvljvErG3ZrNG2i5MuQrjUKl8kWvuxUIu
         3sbXS0zzQS0ZKCBe29ubPPItLOopQwqS1l8zpan2gA0ZGOx5Q9yq7kXOC1EqIc8u928N
         8dsyUk+CioPHS971aybIsidHo5NAh2wLyoPKyOCD2X4WTHaAizk4S0JPmZzd/iIx8Mko
         GBrBmAZ810j8bA5Du7gQ9J4JOG7n1VUeQdfHKYSA9zq1MevOil3/jGwkrp0M8nTXTPrk
         79KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u76jeNBDQqlq+ejUYF0QunxLKhjbabH/yFPYyPECv6c=;
        b=bSMfrN2yrpitV5P6JwN3N/900XJD8cNwKP8QoI3CYdKPP+9LfSeM+RcToPIkbftPtj
         z3cfqxfCcp/5tn1fbGHMokV1fqpsNJLzS/Te/o8drZ7bJELiFt4X52KupcsutyslldVT
         hfu7LFvc37PgNMJqEk7DgcOu7J4DYTOTNjrOIeXOuDAd/3VxqgscZsxcKdQ+uuCBpwx/
         RDY2dA6inEEZNHGLCBe/7oalXoJwGk13SZSJG+5QirxlbY0Al5/JdWKZp8FYKjzh+J++
         HNf7BO1ko+2ZkZ0MYWTrK695HhnB25qIYp1pkAXZSh6TpbKmrP1ii6uXpWW+wyKcF9wj
         dCAQ==
X-Gm-Message-State: AFqh2ko+si4RdLXLbqp5926kHMsgpP0nXYVvy/RJpQ//2wlrRQ0Y7T5X
        aeUoazl0+oCU3qTMoko8A+GLqJ5SunOHMrNt6rotKQ==
X-Google-Smtp-Source: AMrXdXv8oKsvcCeSU3nMu67nEd0IR/pXRrmJjJXNkk+zrJ6TdbqXUKWzB6aXy05szFvOr4iOldGFiA==
X-Received: by 2002:a17:902:b195:b0:194:4484:8e61 with SMTP id s21-20020a170902b19500b0019444848e61mr7810257plr.69.1674067026578;
        Wed, 18 Jan 2023 10:37:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t2-20020a170902e84200b001946a3f4d9csm11032459plg.38.2023.01.18.10.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 10:37:06 -0800 (PST)
Message-ID: <63c83c52.170a0220.62c70.1e1e@mx.google.com>
Date:   Wed, 18 Jan 2023 10:37:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.162-851-gae91cde757a0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 156 runs,
 2 regressions (v5.10.162-851-gae91cde757a0)
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

stable-rc/queue/5.10 baseline: 156 runs, 2 regressions (v5.10.162-851-gae91=
cde757a0)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =

cubietruck            | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.162-851-gae91cde757a0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.162-851-gae91cde757a0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae91cde757a0d43a9e67ac6a75925e110932e730 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/63c8099c14b24f753c915ed0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-851-gae91cde757a0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91=
-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-851-gae91cde757a0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91=
-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c8099c14b24f753c915=
ed1
        new failure (last pass: v5.10.162-851-geb4da590103d) =

 =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
cubietruck            | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/63c837e7200356f546915ebd

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-851-gae91cde757a0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-851-gae91cde757a0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c837e7200356f546915ec2
        failing since 0 day (last pass: v5.10.159-16-gabc55ff4a6e4, first f=
ail: v5.10.162-851-g33a0798ae8e3)

    2023-01-18T18:17:56.757641  + set +x<8>[   11.059873] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3158468_1.5.2.4.1>
    2023-01-18T18:17:56.757977  =

    2023-01-18T18:17:56.864716  / # #
    2023-01-18T18:17:56.966189  export SHELL=3D/bin/sh
    2023-01-18T18:17:56.966552  #
    2023-01-18T18:17:57.067686  / # export SHELL=3D/bin/sh. /lava-3158468/e=
nvironment
    2023-01-18T18:17:57.068149  =

    2023-01-18T18:17:57.169399  / # . /lava-3158468/environment/lava-315846=
8/bin/lava-test-runner /lava-3158468/1
    2023-01-18T18:17:57.170142  <3>[   11.372394] Bluetooth: hci0: command =
0x0c03 tx timeout
    2023-01-18T18:17:57.170333   =

    ... (13 line(s) more)  =

 =20
