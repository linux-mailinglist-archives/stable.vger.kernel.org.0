Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C853A4FFAB6
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 17:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbiDMP40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 11:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiDMP4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 11:56:25 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48ED76622F
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 08:54:04 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id h23-20020a17090a051700b001c9c1dd3acbso2676899pjh.3
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 08:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yyisvaiuk/4BhvB1fLqTes3QQChlFiZ4TZOZjqzo/eU=;
        b=Kt9hXexc6TnsgRyIDc+rDJDmGyYo42H+qME84+8IQQB/rKMDBUZOF8AocQQaJEFqy8
         pXfgHwCdArH1JNDouJWj2+pMDHjM+SbJAaZET5epYO3To8m7BNxy0nZLHcpWd6igNRWG
         A5y0sZIRsWL0BVzy9T4+wYxz4P/sXifT4oIk+iW++qyRW7RWWzoB0xFdB2MnEkPxHXna
         XBZnR7fLlU4izHP5xuwbEUcJ6y5jmuMeOIqS2Wrjl9QTKvW1RDeS13oxTXU4KiYjHY28
         H1+QbMp5PlbiWhXyYqmv11vooyTYTYf6VYH660bdMsylrO4UUUyOYSid7IYqI6/pZrtv
         1kWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yyisvaiuk/4BhvB1fLqTes3QQChlFiZ4TZOZjqzo/eU=;
        b=3dCiZvmaxOFIDRJZs3Z+HikrAPIunOvlwXChiDPRyA5/x/2NWQgaRn45xviT2zyKpI
         ZdlchT8GOo+YRZ2sBbEok4EWjeFY77Wy/VzKpmPspHV+8y44YVTakCJVNjkgytzOwWyJ
         U/ogynBGpbz1qtOj6wvRHMTX/QSrlxBAzr+HazAJVS84SR7+1thiWXWdT1lcHMjCyTOQ
         628EPWVouaOsUGY2vaC4fQsA9UQc/mnma7LtHzUrL29+FNgiT6hA6ghJKqp7TBoSw5hj
         pg6J+kzdLahC8CVadoFI0g/j4hXBFRtEVBbnOuVOl2rNTP09PNlsGLSDPaREY2tvV5NT
         H6nQ==
X-Gm-Message-State: AOAM531akmHAvRhsMDTUeOwLY3oycQmloQSziJR6L2AzV+TVG2+nu6kD
        SzHjgp4NdAHWp+1iZj9GyKYs4js/HSiKH4/r
X-Google-Smtp-Source: ABdhPJx7poN7io8gpObAdXV9hCF8DZFNNln5XQJS5+csbYYrriVC6CSK9yQ/yDLQ/i0dR8Q8bzr6FA==
X-Received: by 2002:a17:90a:8595:b0:1bf:4592:a819 with SMTP id m21-20020a17090a859500b001bf4592a819mr11511366pjn.183.1649865243589;
        Wed, 13 Apr 2022 08:54:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i2-20020a17090ac40200b001bd0e552d27sm3218184pjt.11.2022.04.13.08.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 08:54:03 -0700 (PDT)
Message-ID: <6256f21b.1c69fb81.cdd22.84c9@mx.google.com>
Date:   Wed, 13 Apr 2022 08:54:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.33-277-g69e75a559069
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 92 runs,
 3 regressions (v5.15.33-277-g69e75a559069)
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

stable-rc/queue/5.15 baseline: 92 runs, 3 regressions (v5.15.33-277-g69e75a=
559069)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
beagle-xm            | arm   | lab-baylibre | gcc-10   | omap2plus_defconfi=
g | 1          =

meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-10   | defconfig         =
  | 1          =

r8a77950-salvator-x  | arm64 | lab-baylibre | gcc-10   | defconfig         =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.33-277-g69e75a559069/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.33-277-g69e75a559069
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      69e75a55906938ded8282e375dd43edbb8d17066 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
beagle-xm            | arm   | lab-baylibre | gcc-10   | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6256c69851d472f347ae0686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.33-=
277-g69e75a559069/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.33-=
277-g69e75a559069/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6256c69851d472f347ae0=
687
        failing since 13 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-10   | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6256c47b0fcb5c7293ae0682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.33-=
277-g69e75a559069/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-o=
droid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.33-=
277-g69e75a559069/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-o=
droid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6256c47b0fcb5c7293ae0=
683
        new failure (last pass: v5.15.33-277-g0ad89ff00683) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
r8a77950-salvator-x  | arm64 | lab-baylibre | gcc-10   | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6256ca567d00195459ae06a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.33-=
277-g69e75a559069/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.33-=
277-g69e75a559069/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6256ca567d00195459ae0=
6a5
        new failure (last pass: v5.15.33-277-g0ad89ff00683) =

 =20
