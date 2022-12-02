Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4DD3641195
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 00:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbiLBXkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 18:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233308AbiLBXkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 18:40:43 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8952BECA21
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 15:40:41 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id b11so6322325pjp.2
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 15:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=OrkEEQzFgByP9XsJX0EyddwqJEmPzqnihZghi3xvZ0w=;
        b=fxTj9lnPUoUOlK+jY0ZOBmA5NOJBhR1PLMtp7DZuXG416skTpVDmI1MbbyWgRMVI/x
         HtTEE4Y2HaFWTi+FOBiWQQRqSwqCV1xAiR5udJGO14Jk4SwxewQwKqdPs5HGiwanyqJw
         lrvzZO7+d8Xv1uWGDDrmcJ9Zz2PWHytMw95KWuC0pmH0SjKOe+Q3FZL0ElWK7SeiAWsL
         kgBzAVnr5EuhhNvs8xaR1ekZgzL7VdFw2msQeF5MSGOT2dbSGex27pxOiDSRuzO0rRbk
         Pbj5myAk8a3M02Km8kl99i7m18V+K02aXh+NmOaunIWZ4MxZQGw/S4AwUe0iDoki7SaL
         jPkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OrkEEQzFgByP9XsJX0EyddwqJEmPzqnihZghi3xvZ0w=;
        b=KzqlaX/TzgrxPmriAStfLtvW54fFBmGvk4rHh717LOiaZMZNhcoSZdPmfmVwLRJAsQ
         GnjG6o09OOQt/b9sAnM9L+u9guHG/qjJvGPNOzfSr4bRTpoDOoF9MCLEZTqzGbHZG0dX
         HDS6Zxoc7xakZ0x5bmWLF0vwh2ITnrPrMVUZ0jNf75DWJmX8yLYMXUBVxpBf5CJ7eRJ6
         cJRszH0rsGBKFABBjg00AbXu8c1JVIaeCB3B/+m0BdheRyzbfzUtCXzDNN59w3ZMESfm
         GicNhE/m2oKFxwBNHCjUwdC6QuNppQwBGVeHlqscGqKWB6E63KHZ/wL6zddd5znE9Gz+
         WzTg==
X-Gm-Message-State: ANoB5pkYbUmRjKcNeN/ogPlGKd/16U713QFEbmQnQtK9gH6A6VDn21wN
        WLwxeIZlOHUqeAjV0G7nvQZEx/P2rIJGfZC5tyIVPw==
X-Google-Smtp-Source: AA0mqf6e/BBZ+lnqfou3R07zAsze6BI/t6ewbSm3IcONrEln4cyPHX6Y0lWDsZUDrdkod73o/0St9g==
X-Received: by 2002:a17:902:9695:b0:189:93d4:db5 with SMTP id n21-20020a170902969500b0018993d40db5mr24262366plp.44.1670024440749;
        Fri, 02 Dec 2022 15:40:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b001745662d568sm6075269plg.278.2022.12.02.15.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 15:40:40 -0800 (PST)
Message-ID: <638a8cf8.170a0220.51075.d000@mx.google.com>
Date:   Fri, 02 Dec 2022 15:40:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.157
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 110 runs, 2 regressions (v5.10.157)
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

stable/linux-5.10.y baseline: 110 runs, 2 regressions (v5.10.157)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
r8a7743-iwg20d-q7 | arm   | lab-cip       | gcc-10   | shmobile_defconfig  =
       | 1          =

rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.157/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.157
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f4245f05389c29c0d556fea359b2fcfd8dce7bdb =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
r8a7743-iwg20d-q7 | arm   | lab-cip       | gcc-10   | shmobile_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/638a56d67110589bbf2abcfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.157/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.157/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638a56d67110589bbf2ab=
cfb
        failing since 7 days (last pass: v5.10.155, first fail: v5.10.156) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =


  Details:     https://kernelci.org/test/plan/id/638a5ce34008082a412abd26

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.157/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.157/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/638a5ce34008082a412abd48
        failing since 268 days (last pass: v5.10.102, first fail: v5.10.104)

    2022-12-02T20:15:05.267748  /lava-8213787/1/../bin/lava-test-case
    2022-12-02T20:15:05.277686  <8>[   61.045701] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
