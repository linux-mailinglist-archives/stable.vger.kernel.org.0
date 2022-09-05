Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F255AD71E
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 18:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiIEQKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 12:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIEQK3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 12:10:29 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3064A2126A
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 09:10:28 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 202so8420789pgc.8
        for <stable@vger.kernel.org>; Mon, 05 Sep 2022 09:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=kLOVDYl0oDZmp7kvuLj1oyvR/rzBHR/Ks2Xk95jYpSY=;
        b=ontBQUpQpWMRQZmxgZ2jKnjMqAUG/JKK6Dx03h/1ty5pRqUdBGKRkszLv7o7TdhBfU
         0E9SWf8GbChC3LHjFapOl4w6nQehqkfCDlFKW58ke88kIqkHNLut1cW3cm6zNBD76Cn9
         FLkVQgDegntVDk8P3OLcIjvY3mm3P6sakCNLaKu5n42/Pi9cUM5hJYBxuLel2YolBFCe
         XbntSs6U0a7BSFMayjfTrC3JSQKjE11fE1VbtSs3zjR8gqyS7BBuLkWOyxXGmCMaoWRR
         H1lHn96ATAA5KgdCCNwWPEcoKaSnGuKCABDEnS0zYDBiE2yog+1HWvbnKlQTRsF1J8x/
         O1LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=kLOVDYl0oDZmp7kvuLj1oyvR/rzBHR/Ks2Xk95jYpSY=;
        b=0QSBLboOslqhqIf0R2Ttv7+Hh5hbsedJiSFL5ySnPAw4KbOL7Z++kPI1s/iZ0DVIuN
         JM7ovUKlIptYsUj3wf+j828dFnf1HVMffb9wUJ1+lf5gowbsQgURt3LUY3Pf8zLP1N8/
         JsCsOHIz23+sBO+RZaVW+lYo7xbg4PKmdGSuPpurrrG5ldr1caf1BBl9bTtmdm+/tZJs
         jx/blXKnKQ9RSkyHE2D1H7UP81OJxYncVL0uXSKPYuBPGXmLRgIy2Epuqh1zqStuZbMD
         coOF26OtGFHJ+diCZCl3mUdFzJ/76ZfvmszsvLT+OOeeedeW5gAk//ldAb9BNlzFFTH9
         0nng==
X-Gm-Message-State: ACgBeo0IqZWh/dItrlbi1PPIUwD1mecmbQKvh1zq80L2lZ2ZtJ6Si22t
        /rDYpKIzHZ35MSqqsrDaFoqCvAorONawZ2bnrMo=
X-Google-Smtp-Source: AA6agR6y4bLE1aBstDFAFtGGZWYrNYIDMHC96ycL3Gc4QPOy6JW4of+m7BgCnJLNqK8MmDMWirFwmA==
X-Received: by 2002:a05:6a00:170c:b0:537:27b4:ebfe with SMTP id h12-20020a056a00170c00b0053727b4ebfemr50671754pfc.19.1662394227590;
        Mon, 05 Sep 2022 09:10:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f21-20020aa79695000000b00538405dfe4asm7905781pfk.111.2022.09.05.09.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 09:10:27 -0700 (PDT)
Message-ID: <63161f73.a70a0220.f0b84.bf99@mx.google.com>
Date:   Mon, 05 Sep 2022 09:10:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.65
Subject: stable/linux-5.15.y baseline: 150 runs, 2 regressions (v5.15.65)
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

stable/linux-5.15.y baseline: 150 runs, 2 regressions (v5.15.65)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig        | 1          =

rk3399-gru-kevin   | arm64 | lab-collabora   | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.65/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.65
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      633c3b4c71bb949de771388de213d331c1ebd270 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig        | 1          =


  Details:     https://kernelci.org/test/plan/id/6315e75b594bf7bf16355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.65/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.65/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6315e75b594bf7bf16355=
643
        failing since 4 days (last pass: v5.15.62, first fail: v5.15.64) =

 =



platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
rk3399-gru-kevin   | arm64 | lab-collabora   | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6315ecf3b220df1460355662

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.65/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.65/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6315ecf3b220df1460355688
        failing since 180 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-09-05T12:34:42.602803  <8>[   59.908209] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-09-05T12:34:43.625406  /lava-7189317/1/../bin/lava-test-case   =

 =20
