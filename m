Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5B6679B56
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 15:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbjAXOQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 09:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234836AbjAXOQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 09:16:16 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E1647EC8
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 06:16:10 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id e10-20020a17090a630a00b0022bedd66e6dso2119790pjj.1
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 06:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9b5OTLfcrAWRdZxwXyXWa9x7zHfH1VmLF2GpF+curPA=;
        b=yNZC5AqZ4aOpmeNLeW4BDnrYsoTalfvnf5iuT7f05XpaWg7gCAWRCIsuYEz6vGNF2h
         a8O4Uk/HWmDAPqlgSi1RnzI1ttkQAw9YsG7l3+nVq8Zp/P3cn7h63lkGA2Zpg6OTvLth
         Yq0Ui+5y/YdRT6MIbQcOs4meWES+E0PVu1NoRHrLGNN0AwFo8g9RSonDKQjGD4zUEM9e
         cXWJjzPD9bvCVQR5umvTrKiRN+bzzzFCbqlHZ/NWzCrQuizQySoru91eQfCUhBrp9a5d
         LeoMv4qM+juTmvksocrNGDXehmzF0Ik5iqi7c8/T47SQIHGzjpEcnhKJvnHDMCKVIkfl
         LK6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9b5OTLfcrAWRdZxwXyXWa9x7zHfH1VmLF2GpF+curPA=;
        b=7Kqu9lXh++MLS5Mx+nuuQLinmM71U7ggIHUT2n/JG4rrORi4HrYde05dIBw63iAdVq
         ZD2WDQ7a35+GlRq99lnRYj/pUnUVXfYtXyoh1A5p/qtHsgunEKRaXDqrCvB5LGZk+2rp
         CpOZgAPSfQCKcQXivtqA6/s7VqN1rTmNFXaWYdjs9qFsL+SXfFDf0BYau7ORcvKH/xN4
         8waYCQudWaNOaTJniVowXGLN6Sis6XmaRmadNEW2/xqu7ig53QSR4yN0vQ2TqjbIAgv/
         SzA4f6vNAmRbx5yJbMBNOWfoit7EaBQ8TGwDLo9TcxVuCQB89XcZKkhEAedhd0O59ngh
         T1KQ==
X-Gm-Message-State: AFqh2krMTXK74eAhpaceu/z2nF01WfWRis0w1DtELLm6E5HEKzaeQvZF
        uLlh/JQb3CUDsJv+gPQMinqARFRUNzqAEbSwu8A=
X-Google-Smtp-Source: AMrXdXthIR45Gry8ujLgPf2JtpDOC6fgluBOJ7TcJih7RQZGRVb3QkaM/yrXOIi7Di86nhANNpyDRg==
X-Received: by 2002:a05:6a20:8ba4:b0:b9:dac:f985 with SMTP id m36-20020a056a208ba400b000b90dacf985mr24638101pzh.37.1674569769643;
        Tue, 24 Jan 2023 06:16:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p26-20020a63951a000000b004b25a51d6f4sm1482477pgd.36.2023.01.24.06.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 06:16:09 -0800 (PST)
Message-ID: <63cfe829.630a0220.d544b.2095@mx.google.com>
Date:   Tue, 24 Jan 2023 06:16:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.90
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 240 runs, 3 regressions (v5.15.90)
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

stable/linux-5.15.y baseline: 240 runs, 3 regressions (v5.15.90)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
             | regressions
----------------------+-------+---------------+----------+-----------------=
-------------+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-10   | multi_v7_defconf=
ig           | 1          =

cubietruck            | arm   | lab-baylibre  | gcc-10   | multi_v7_defconf=
ig           | 1          =

mt8173-elm-hana       | arm64 | lab-collabora | gcc-10   | defconfig+arm...=
ok+kselftest | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.90/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.90
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      aabd5ba7e9b03e9a211a4842ab4a93d46f684d2c =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
             | regressions
----------------------+-------+---------------+----------+-----------------=
-------------+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-10   | multi_v7_defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfb4b10c62324ee5915ebb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.90/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.90/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfb4b10c62324ee5915=
ebc
        new failure (last pass: v5.15.89) =

 =



platform              | arch  | lab           | compiler | defconfig       =
             | regressions
----------------------+-------+---------------+----------+-----------------=
-------------+------------
cubietruck            | arm   | lab-baylibre  | gcc-10   | multi_v7_defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfb3c991bf618406915eee

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.90/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.90/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfb3c991bf618406915ef3
        failing since 5 days (last pass: v5.15.82, first fail: v5.15.89)

    2023-01-24T10:32:05.970369  <8>[    9.975525] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3197948_1.5.2.4.1>
    2023-01-24T10:32:06.079550  / # #
    2023-01-24T10:32:06.182395  export SHELL=3D/bin/sh
    2023-01-24T10:32:06.183406  #
    2023-01-24T10:32:06.285483  / # export SHELL=3D/bin/sh. /lava-3197948/e=
nvironment
    2023-01-24T10:32:06.286508  =

    2023-01-24T10:32:06.287098  / # . /lava-3197948/environment<3>[   10.27=
3589] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-01-24T10:32:06.389344  /lava-3197948/bin/lava-test-runner /lava-31=
97948/1
    2023-01-24T10:32:06.391272  =

    2023-01-24T10:32:06.396197  / # /lava-3197948/bin/lava-test-runner /lav=
a-3197948/1 =

    ... (12 line(s) more)  =

 =



platform              | arch  | lab           | compiler | defconfig       =
             | regressions
----------------------+-------+---------------+----------+-----------------=
-------------+------------
mt8173-elm-hana       | arm64 | lab-collabora | gcc-10   | defconfig+arm...=
ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfb65a27abc1e66b915ee3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook+kselftest
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.90/a=
rm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt8=
173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.90/a=
rm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt8=
173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfb65a27abc1e66b915=
ee4
        new failure (last pass: v5.15.89) =

 =20
