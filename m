Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F05508D20
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 18:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380440AbiDTQY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 12:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356606AbiDTQYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 12:24:25 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF6C387A8
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 09:21:39 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ga4-20020a17090b038400b001d4b33c74ccso1511746pjb.1
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 09:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rSznwwBPHdjV07E/oldsLP2GrSbUDaA83FfqN+Om5qM=;
        b=A+tPdOqAw1tVF0AgrhKYzb5KuJR2iVvgmzFSE0hR0GVmdqNU3EoFLoNvlwzncPRZJS
         5FQlHbHAmr1lKMwPXt6caFMF0ek+9Fi7Tow8EVuiNLgQ/MC8VwFfejSYwmyaF4UajpKf
         TgNA22p1sEP5uCQ1VdKkiL3sA6yrOiVb/fSxRE/aQMJMHF1CoYpDUYIglP3awNK/vCCO
         1upbvdKtctafdmXPtbtC1u7P3rTZpH3rhiqZCsRkkowS7wF03MTUIf/2zmNNttJsyXMB
         YjC2kCEac/0sO51ZB95K/MCYGjvrSqmA85wonF8UUlP7zJ+XCz85b1ouNai/sFZp7dbm
         1+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rSznwwBPHdjV07E/oldsLP2GrSbUDaA83FfqN+Om5qM=;
        b=xf6hqnZ9joQK6XQmhybpHCbTE7Jy6spSlKHP3FXkSeg7eIzsDEvJwcy/pYFP2B2Fbu
         r0WT+fLqcI5xb8Xi/WsDjipODJqdPgy/C/BJvAu2DL3NRZoiCD2DUImH6xd/tkte+i3v
         ID0JkQZOgc/lcgRpdyScskN2UnVyN8+uOSJlUZL1w5YXUNDukyHvER2gI30CmVuF0dCL
         iDZ35vGrzLB/VdFn+A75s1Pm6dAqxdIebDgm0JMXvPRE3yaGizBUNtFOFzXFn/itv1gz
         oZObRPuSQZT5g41YDAJU9IMkgL6+SPp47HnaoJIQWnUZLJJjh50Cd4e2/MqjHEXSBL5f
         HpbQ==
X-Gm-Message-State: AOAM532ScEMDbKDzCcjUxGKxTDZb2DLWOCCI//A7r0hk336RQlJ4v/z+
        0AHwJUIwyJguMjdBM2JGGfbgQuMrYOk/z1KddqY=
X-Google-Smtp-Source: ABdhPJxdbkLXQSxdKbyCdNe1hZoh/m/f1bJAdN1fqc18OGY+1x701W0kcPuLkLgd1qS+nHcAwFFs/A==
X-Received: by 2002:a17:90b:354a:b0:1cd:db3a:8f87 with SMTP id lt10-20020a17090b354a00b001cddb3a8f87mr5383207pjb.44.1650471698496;
        Wed, 20 Apr 2022 09:21:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id by8-20020a056a00400800b0050a96357226sm6361067pfb.40.2022.04.20.09.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 09:21:38 -0700 (PDT)
Message-ID: <62603312.1c69fb81.82f33.f21d@mx.google.com>
Date:   Wed, 20 Apr 2022 09:21:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.112
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 138 runs, 2 regressions (v5.10.112)
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

stable-rc/linux-5.10.y baseline: 138 runs, 2 regressions (v5.10.112)

Regressions Summary
-------------------

platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =

rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.112/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.112
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1052f9bce62982023737a95b7ff1ad26a5149af6 =



Test Regressions
---------------- =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/62600190cdfab83b49ae0699

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
12/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
12/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62600190cdfab83b49ae0=
69a
        new failure (last pass: v5.10.111-106-gd5c581fe77b51) =

 =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/626000477fb905ef4dae06af

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
12/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
12/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/626000477fb905ef4dae06d1
        failing since 43 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-04-20T12:44:42.505586  <8>[   33.127175] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-20T12:44:43.529251  /lava-6131271/1/../bin/lava-test-case   =

 =20
