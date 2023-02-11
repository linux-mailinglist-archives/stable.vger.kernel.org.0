Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534266932DF
	for <lists+stable@lfdr.de>; Sat, 11 Feb 2023 18:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjBKRg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Feb 2023 12:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBKRg1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Feb 2023 12:36:27 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE560180
        for <stable@vger.kernel.org>; Sat, 11 Feb 2023 09:36:26 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id o13so8397247pjg.2
        for <stable@vger.kernel.org>; Sat, 11 Feb 2023 09:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=tTkI63pCV0vizNIkUFNkg1o9AE6TdavU7qOo9PqWDRo=;
        b=iO8IbuyTHrjEdfv8BUv3vWlVEMLEaZRZ0k4i+RKdUfPAW5M9iG8Zc+DeyDSpw67ppL
         HB4lkdAepHchH/EtyzNV9gzEGOQVstoLe3df5UV14462NgBfH04Md0wKTQ4irvj+7Wz3
         QhMGN81xcHsxhYFWCsLCCJ3ySodQf+gHvhjwgLxb0Epls0iXC5ghIt1XeIdFG4LNJ1eQ
         YUywCyDpkDezN/1+62kgROlnE8Ax5SeJ7STF7fpovwAWZc65Fcl/0SH5oCCY4Z4bZltD
         KJCAb5UBfmNJXGD3O70gf2xLje+TEROWaj41jbj7yrKY5mbhC9XdbB/B6y2rwxMfKiHI
         Gscw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tTkI63pCV0vizNIkUFNkg1o9AE6TdavU7qOo9PqWDRo=;
        b=cYjFqtUolode59rMJqvhciBlApFITAz0+E/8mE8SwFOB0m35+sXYTMrxOAd0wU1qhG
         dn6B5wKtI1+FjJfcRYtcadfPo1zKi2Mm2HF7jcs/gZWm9cr+h1IQ2pQIuxs5XmWMfLYM
         K7SELDp8NgBBMpeJziShws5Hvi4BT5/sMw+FqOGwa4rcz8gujVJFy+ab9XZMcVlNq2kF
         CgTq84JxovigUwOznNDK8jqv8nVoHq+SNPYLu/uwJ78knvidwW3DK0Bl5DbzCNNEChwo
         qOcwrlY/YARgw3Pu+PQHztAjyJrTfHNbWXm1mMpQ3DPjYdeCwUF9OwxSGMlLd9bTnq/+
         3Tkg==
X-Gm-Message-State: AO0yUKW0ByP1Zhb25CXXremrtIb0JGJlhk/JNE+drmNuvMCkQ3Ntauo5
        25zsEoq1svUS+hkt4v6heeM3vN3FYC3Tnt4crp6pVQ==
X-Google-Smtp-Source: AK7set+918NHQ7nAa6ZKXFI+/cwb3tzHLe6LVplF01TkUQIUcx04aPmowTGYO260hO8Bm8i9b4LZNg==
X-Received: by 2002:a05:6a20:3d8b:b0:be:d4be:50a2 with SMTP id s11-20020a056a203d8b00b000bed4be50a2mr24160384pzi.32.1676136986115;
        Sat, 11 Feb 2023 09:36:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g16-20020aa78750000000b0058e1e6a81e8sm158679pfo.38.2023.02.11.09.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Feb 2023 09:36:25 -0800 (PST)
Message-ID: <63e7d219.a70a0220.c83a4.0432@mx.google.com>
Date:   Sat, 11 Feb 2023 09:36:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.93-14-gdb3da3e676b7
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 150 runs,
 1 regressions (v5.15.93-14-gdb3da3e676b7)
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

stable-rc/queue/5.15 baseline: 150 runs, 1 regressions (v5.15.93-14-gdb3da3=
e676b7)

Regressions Summary
-------------------

platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
imx53-qsrb | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.93-14-gdb3da3e676b7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.93-14-gdb3da3e676b7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      db3da3e676b7400040f1b6126d101906277bd651 =



Test Regressions
---------------- =



platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
imx53-qsrb | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/63e7a1204b00721bd98c862f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
14-gdb3da3e676b7/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
14-gdb3da3e676b7/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e7a1204b00721bd98c8638
        failing since 15 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-02-11T14:07:04.588655  + set +x
    2023-02-11T14:07:04.588813  [    9.359245] <LAVA_SIGNAL_ENDRUN 0_dmesg =
904123_1.5.2.3.1>
    2023-02-11T14:07:04.696650  / # #
    2023-02-11T14:07:04.798313  export SHELL=3D/bin/sh
    2023-02-11T14:07:04.798748  #
    2023-02-11T14:07:04.899877  / # export SHELL=3D/bin/sh. /lava-904123/en=
vironment
    2023-02-11T14:07:04.900250  =

    2023-02-11T14:07:05.001427  / # . /lava-904123/environment/lava-904123/=
bin/lava-test-runner /lava-904123/1
    2023-02-11T14:07:05.001953  =

    2023-02-11T14:07:05.004093  / # /lava-904123/bin/lava-test-runner /lava=
-904123/1 =

    ... (12 line(s) more)  =

 =20
