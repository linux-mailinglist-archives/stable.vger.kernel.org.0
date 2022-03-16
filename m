Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4B14DB83E
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 19:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354461AbiCPSyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 14:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357790AbiCPSyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 14:54:46 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A9117E17
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 11:53:31 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id mv2-20020a17090b198200b001c65bae5744so2166009pjb.5
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 11:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X7YWcm+jGG2Biz4WrX2PSfAyZg32NFJMOn0LVS8xVNg=;
        b=K5OIJihngVzvokuMns6Bd7SQOT4YdKxM5Beza+hZusXA+FOePtqK3Sht9yvf3ut6nZ
         Wyt56aGKZoABpBi6R/+bW+4ShYHz+ickHCvB0ms7Sjde44JhAuNgPAx5SjkRGzowOBWg
         g9nzUif08muQDFPXeQhrN/cWoox1mOrYRoJzjqcv59le3NFSGuvNGcb7iDwnZsWJUETd
         C/+KMTEisXxiFBTq/JY09EdHA0suNRS/ql1yd7++bHLiSCMZ7iUBp0hiXiKlIjz615H6
         FsdnGFSLT5RzAnRhh6KghDWqQ559J3LwKKjH3AOdzygaS4IymqSHWw/caSN3Q6Hck50X
         /4Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X7YWcm+jGG2Biz4WrX2PSfAyZg32NFJMOn0LVS8xVNg=;
        b=c9x988HEG0TT98pXAlFf4npqu1DJx5vFyE2EYrt17RRMLmF05JnYjAwUIYYSSKzNYu
         moNun5cNMuKsBnqKJBMNiPnwQhmDeQotDLFcyfJIIJTV+OTMxrsUsZ9FnLAeOgKtdWIH
         syY74cFU7/nVdnGnDfNRPsPpMPPms3gKY9VAUs7fzNcWaHY3sBbMBf5js/tlom7Ik3si
         ewodWu9dnW0vcPWlc/sq2XtBB4gKkhE9mBCr++M1HZ6k1DGgGeFroEUXEW+oUquedndp
         SEHQJyUBUBtvVvQrYn+wgMQ+iOQ1uPlpgBOdyb3eKIXcYB9SFicNYMx6RSRmguVBTA8B
         gWQw==
X-Gm-Message-State: AOAM530gPHw8dPUaOblhGhFJIwo0MGqn5o5kSTXBJO4dpyI5vwqLWXUn
        z0FAp/QmB+7HNKZ7fH1LdO4G985Dw4F9QSrBWIE=
X-Google-Smtp-Source: ABdhPJwGGglJtIbk0rmjtBzXAmOAJ9yabt/EuSTEb7DMptX9oC3sd9j7VnDt/VF0JgCESfB9TdBXXg==
X-Received: by 2002:a17:903:1108:b0:151:9c42:7d1 with SMTP id n8-20020a170903110800b001519c4207d1mr1389577plh.54.1647456810567;
        Wed, 16 Mar 2022 11:53:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r4-20020a638f44000000b0038105776895sm3306332pgn.76.2022.03.16.11.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 11:53:30 -0700 (PDT)
Message-ID: <6232322a.1c69fb81.11d5e.7fc6@mx.google.com>
Date:   Wed, 16 Mar 2022 11:53:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.234-28-g170c349dc1b8
Subject: stable-rc/queue/4.19 baseline: 79 runs,
 1 regressions (v4.19.234-28-g170c349dc1b8)
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

stable-rc/queue/4.19 baseline: 79 runs, 1 regressions (v4.19.234-28-g170c34=
9dc1b8)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.234-28-g170c349dc1b8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.234-28-g170c349dc1b8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      170c349dc1b83e6cedfa6f1c511ff318edf0ab2a =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6231fe19e2f46574a5c62975

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.234=
-28-g170c349dc1b8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.234=
-28-g170c349dc1b8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6231fe19e2f46574a5c6299b
        failing since 10 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-03-16T15:11:15.170285  <8>[   35.707354] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-16T15:11:16.184890  /lava-5891233/1/../bin/lava-test-case
    2022-03-16T15:11:16.193080  <8>[   36.731236] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
