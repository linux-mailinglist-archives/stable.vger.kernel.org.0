Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC50565FB9
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 01:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiGDXY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 19:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiGDXY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 19:24:59 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A672BE4
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 16:24:57 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id w24so10551668pjg.5
        for <stable@vger.kernel.org>; Mon, 04 Jul 2022 16:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=crUlXbz23tQ0qhRy/uqoDPqLVUspM9GxmDDaAbqX4O4=;
        b=ReNKItrJ1zYP4Jfh7cVW6y/AfhBZUBSHeBZUdJolSbMvBTV9oI4iQIvS2rQqaumaKB
         +yszoc9n0oDkX4Ttqu/28WAm76CiqcMJku64XtmFm/HujdBb7cGEy+mRkAcXQ8JygygI
         CP3asJpe3C+V1f6m3zXiOnluMuAhtfHTsYHNJNHi+Z5H1KTC+2j29gtusawaxzImbJth
         2q7twcP1RdsC+bNe/kBq1qDVxFCV7mpVnS+dtUpHsTxT6grHprBlLU7f/GKJC0EEpuZH
         RG5mFm5bpPQteWqeo+TqTwDVKoFrowZxsntt/1vIm2Wdu6pXMgpu4vcQFEGzvDo/LmkQ
         mEJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=crUlXbz23tQ0qhRy/uqoDPqLVUspM9GxmDDaAbqX4O4=;
        b=kuw2oREqHgHmNtP6gONE8/5g3SPbJiWx6m42GnyBj3B4pvIJmuYc9MqNI9Bfed9tXG
         ej1G1T+8loX0GBQkaV0X+TKdMMjo6YxqBqaO+qNPk67LdSZGRJ+ETBfBgi38Bb6Ogs0z
         MQHTf7ZgEZEXEgnPjKEBWJaRap04DscMJFIC0CmgoLqp+C2qPzHXbAUkbX1a1wBOYsHg
         aw/cQiEJnrLH3fPST9qgpZxyblskAZ6jrAllIVtZIazuBj5Xz7U6ODykhYARVAIqPkOW
         j1/Qg/Gerd7yxhVeaSvZ1Awu7WJZUwbVQ6KxnXRPETI9hfL8Y9DRYi5jjc9UIqZigbpZ
         N0MQ==
X-Gm-Message-State: AJIora/dL8AXewtIC8IcPg+q6NzAY131E8X3mDmmZIU2bYBpRiWB5M0G
        +lgtI91KqmjBtjIBjO1DCuyoGvGiP04rNXuW
X-Google-Smtp-Source: AGRyM1tJdvx5fxDa3Zubh8uz5vRbf9tWKqfGHnB68qOBMqPUqlho+RFcVTpZkvTxY2OIq4Sw0Z9W/Q==
X-Received: by 2002:a17:90b:4b4c:b0:1ec:a857:46bb with SMTP id mi12-20020a17090b4b4c00b001eca85746bbmr39630718pjb.108.1656977096849;
        Mon, 04 Jul 2022 16:24:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q11-20020a63504b000000b004126f1e48f4sm177388pgl.20.2022.07.04.16.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 16:24:56 -0700 (PDT)
Message-ID: <62c376c8.1c69fb81.2d2e8.0539@mx.google.com>
Date:   Mon, 04 Jul 2022 16:24:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.128
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 75 runs, 1 regressions (v5.10.128)
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

stable-rc/linux-5.10.y baseline: 75 runs, 1 regressions (v5.10.128)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.128/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.128
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ea86c1430c83aa91f2c4122408922e34a1279775 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62c3458df30768b2b4a39c39

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
28/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
28/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c3458df30768b2b4a39=
c3a
        failing since 27 days (last pass: v5.10.118-218-g22be67db7d53, firs=
t fail: v5.10.120) =

 =20
