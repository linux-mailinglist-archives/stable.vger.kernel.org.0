Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82225908A9
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 00:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236178AbiHKWOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 18:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbiHKWOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 18:14:43 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11430A0330
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 15:14:43 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id z187so17590335pfb.12
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 15:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=97273FdPkDFq6FKgNASBtPqfAEtFQTOzHxiNGPOpUSI=;
        b=A5qIniiUVEu/AQ/WCvGOtaI9jsPUk3+YNGMZnXx3Eij2XR2A81UBjhHNXktlUldu8x
         66ibcl42DHbUZ4yMdOSL8qpSznMyu4TU08fOz3TDatdE7K9eORZXPWAZNlNH3HUp0mJh
         CdG6alECgEGcG5t4nc2oZbWruAPtVlUfK7LLQv7xvpNjPCTal8GV1pWmboW0cOsey+T8
         dB+HDO9ZIAa6u+x0iKR9/0Witop66D2rJzXB3mLZrx0pYCJbEuBfBRVn2AZU6k3fQW+E
         xWwBx8khqZnLnZLdsIeot5vt18wb/uKyXiqnl7Aa+Qqbrsk4F9EStEFMrOOqxZzb7WEl
         vHqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=97273FdPkDFq6FKgNASBtPqfAEtFQTOzHxiNGPOpUSI=;
        b=i0CgU4sL0SB1DCeCi4+Fp0/Hj3xp9lEAtQbAHdcws8BhI2F1ldCkQglySqfiPJPp+N
         8VcUwdlxtZyCMvlTYIG2tqSI9aadGekPkzG1TovhQ/LL5S+xhn6iYxgDwfiM3h9NjqJ+
         7RgOkB4kYA0xW2cFD0ySi4Jyv3fJNaaq6g1M32UmpzFQDfsC4vzMYum/EvTth7Ii5j6U
         7H0ke4QlmG14MrI3jt8bdS6I6Qp3zr0KBYrmvXoK7jaYb6NstWnHKnxwBdGBJaOXhM1e
         wqsbWQpdK/hK2EEJRCbW8cgf4YAYjTCkETVG0oHRFXdsUt2t1nOU22Doww9s2rfSrwU/
         czog==
X-Gm-Message-State: ACgBeo1I0hnMb4ZEA+drikwhQGMcbDkl9x/VTEakrLB6uOS/3TWG/4K/
        bJPLQmirEJ3hcobxul/56AoBdy7vqwmSQGaWJlM=
X-Google-Smtp-Source: AA6agR5bqhg5QXzYSXZLx+StrWsVHzJiYP9Yr3J3vFFhmeDtnqskijJCaqanfyPgiCuuppcDsbJ6Tg==
X-Received: by 2002:a63:1356:0:b0:41d:8edf:8ab1 with SMTP id 22-20020a631356000000b0041d8edf8ab1mr819232pgt.268.1660256082186;
        Thu, 11 Aug 2022 15:14:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b72-20020a621b4b000000b0052d3d08cd96sm190138pfb.67.2022.08.11.15.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 15:14:41 -0700 (PDT)
Message-ID: <62f57f51.620a0220.20637.0736@mx.google.com>
Date:   Thu, 11 Aug 2022 15:14:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.1-25-g07ccf42c5e7f9
Subject: stable-rc/queue/5.19 baseline: 158 runs,
 2 regressions (v5.19.1-25-g07ccf42c5e7f9)
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

stable-rc/queue/5.19 baseline: 158 runs, 2 regressions (v5.19.1-25-g07ccf42=
c5e7f9)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig          =
        | 1          =

mt8173-elm-hana    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chr=
omebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.1-25-g07ccf42c5e7f9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.1-25-g07ccf42c5e7f9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      07ccf42c5e7f993e873fb204ab996df2a354bc5b =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig          =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62f54b8955f3066213daf08a

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-2=
5-g07ccf42c5e7f9/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-2=
5-g07ccf42c5e7f9/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/62f=
54b8955f3066213daf09d
        new failure (last pass: v5.19.1-22-ge5ce4754e8465)

    2022-08-11T18:33:23.731849  /lava-153764/1/../bin/lava-test-case
    2022-08-11T18:33:23.732263  <8>[   22.770278] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-08-11T18:33:23.732508  /lava-153764/1/../bin/lava-test-case
    2022-08-11T18:33:23.732737  <8>[   22.790078] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy-driver-present RESULT=3Dpass>   =

 =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
mt8173-elm-hana    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chr=
omebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f54f98f80eedc452daf070

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-2=
5-g07ccf42c5e7f9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-mt8173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-2=
5-g07ccf42c5e7f9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-mt8173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f54f98f80eedc452daf=
071
        new failure (last pass: v5.19.1-22-ge5ce4754e8465) =

 =20
