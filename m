Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4471468350C
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 19:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbjAaSTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 13:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjAaSTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 13:19:41 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF17537F25
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 10:19:34 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id r8so9092239pls.2
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 10:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=UkoEqmgWg6czWOrtpVgz4zDuVNHXeEiX4bHQN4uRf20=;
        b=Ha6aDoLSQEtCsaZeXj5kD2ilYr8kK2yqFxww9j0Cv/pl2zWSijXNN7w5IZ8KqBKPAu
         5DvLgFxv0oKsyXJHxGHCjuVPUotEsiXHwG+5gUgcooHYAg1JE/uDlkEXM+b5MXqMZmI6
         9s2dDRRuOPOGI0AzBd80SXgoQFS3oRsXypgZC2nUrBGUsb+mJ7nblRU+v0mgzmCVCzg8
         +rjm76LKkuny7d4CYEaWNYNH4uXUtsSKsvRedg4vOMvK7qbDhMNTYzkKe1HxtrzlCQOm
         a5OM1kE/ivBVLGYgQV32smc3cg0u0TfsoTgxia2e3qPz+JqDTfZvvj3ssjBcWDYPvYHo
         tcZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UkoEqmgWg6czWOrtpVgz4zDuVNHXeEiX4bHQN4uRf20=;
        b=pS0mX7zQqGu7MJWV+jgnkHIRBsm/kjzM8P4xIGz9Njh4WDnFX/iE6Sopu4gyA17ZeC
         mlFvf1TLJNOMiWIi1OJG1SqwQWxmDeXkX7AdIoBi1ZC99NUHfL//Itxx+6rbO1x2BgoQ
         sjbsdOrXLz6ae0B3VPNBZzM5+Br2HUCNXOFZ/wqlrLuuTxM0xyhkEa0cvjMXk0MhJUQu
         +Qi+ndnRFrSDe7eWFCmXnU5rL1KqEV+ZYZD/sCONgsxqP7rAB/UEMr4kFqb62cz2HgmQ
         QPz1Lc1UIwYDeQtAC6iEKJjEuJzV0A/EkFDK4LvPQe0xBtoFay7EalJ0NxCdnVbVmixf
         R0Yg==
X-Gm-Message-State: AFqh2kqE+sdx7zAdyQe52D+RQGH/BSs3BfdnMaaH5rIlbap+Tng1gJr2
        ZHN1XvuaVq12b+ShrWPYZCFTTJ1O3zca7C5jlbVd2g==
X-Google-Smtp-Source: AMrXdXvWd0AjMovsZgt9lgnFy5DoHx1s1yFA5iffjOOQbYDBKw/IrZ0t2VK0fNVEKzEJ0ShnNY6PbA==
X-Received: by 2002:a17:902:ebc9:b0:194:85da:16 with SMTP id p9-20020a170902ebc900b0019485da0016mr55807802plg.13.1675189174179;
        Tue, 31 Jan 2023 10:19:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902c10200b0018099c9618esm10057365pli.231.2023.01.31.10.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 10:19:33 -0800 (PST)
Message-ID: <63d95bb5.170a0220.50959.1a30@mx.google.com>
Date:   Tue, 31 Jan 2023 10:19:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.90-203-gea2e94bef77e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 93 runs,
 2 regressions (v5.15.90-203-gea2e94bef77e)
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

stable-rc/queue/5.15 baseline: 93 runs, 2 regressions (v5.15.90-203-gea2e94=
bef77e)

Regressions Summary
-------------------

platform                  | arch | lab             | compiler | defconfig  =
        | regressions
--------------------------+------+-----------------+----------+------------=
--------+------------
imx53-qsrb                | arm  | lab-pengutronix | gcc-10   | multi_v7_de=
fconfig | 1          =

sun8i-h2-plus-orangepi-r1 | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.90-203-gea2e94bef77e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.90-203-gea2e94bef77e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ea2e94bef77ea8406663c21f1d3508fe4ce2f0a9 =



Test Regressions
---------------- =



platform                  | arch | lab             | compiler | defconfig  =
        | regressions
--------------------------+------+-----------------+----------+------------=
--------+------------
imx53-qsrb                | arm  | lab-pengutronix | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d928b6e7ae238fba915ed4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
203-gea2e94bef77e/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
203-gea2e94bef77e/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d928b6e7ae238fba915ed9
        failing since 4 days (last pass: v5.15.81-121-gcb14018a85f6, first =
fail: v5.15.90-146-gbf7101723cc0)

    2023-01-31T14:41:34.614403  + set +x
    2023-01-31T14:41:34.614609  [    9.344515] <LAVA_SIGNAL_ENDRUN 0_dmesg =
892948_1.5.2.3.1>
    2023-01-31T14:41:34.722089  / # #
    2023-01-31T14:41:34.823675  export SHELL=3D/bin/sh
    2023-01-31T14:41:34.824089  #
    2023-01-31T14:41:34.925240  / # export SHELL=3D/bin/sh. /lava-892948/en=
vironment
    2023-01-31T14:41:34.925641  =

    2023-01-31T14:41:35.026849  / # . /lava-892948/environment/lava-892948/=
bin/lava-test-runner /lava-892948/1
    2023-01-31T14:41:35.027418  =

    2023-01-31T14:41:35.030264  / # /lava-892948/bin/lava-test-runner /lava=
-892948/1 =

    ... (12 line(s) more)  =

 =



platform                  | arch | lab             | compiler | defconfig  =
        | regressions
--------------------------+------+-----------------+----------+------------=
--------+------------
sun8i-h2-plus-orangepi-r1 | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d92c616e27e8728d915efa

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
203-gea2e94bef77e/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2=
-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
203-gea2e94bef77e/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2=
-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d92c616e27e8728d915eff
        new failure (last pass: v5.15.82-123-gd03dbdba21ef)

    2023-01-31T14:57:20.224900  <8>[    7.918854] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3253015_1.5.2.4.1>
    2023-01-31T14:57:20.350633  / # #
    2023-01-31T14:57:20.456562  export SHELL=3D/bin/sh
    2023-01-31T14:57:20.458327  #
    2023-01-31T14:57:20.561641  / # export SHELL=3D/bin/sh. /lava-3253015/e=
nvironment
    2023-01-31T14:57:20.563231  =

    2023-01-31T14:57:20.666673  / # . /lava-3253015/environment/lava-325301=
5/bin/lava-test-runner /lava-3253015/1
    2023-01-31T14:57:20.669502  =

    2023-01-31T14:57:20.686026  / # /lava-3253015/bin/lava-test-runner /lav=
a-3253015/1
    2023-01-31T14:57:20.837807  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
