Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC55443A925
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 02:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbhJZARN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 20:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbhJZARN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 20:17:13 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DB4C061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 17:14:50 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id o133so12499586pfg.7
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 17:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YziJNKZPYKiuMZ6/msCJcvFJzTR8tDS0yfLXYtfKzu8=;
        b=nWPvfCTrYsRrvfn4/Yu8toZe0Polc5b4eV+hWIUKC5dnQkaA8zyWZ9oZR8kXoSlIB4
         ACz+YBFHW1dbP4gnW67Bf5zN7vPE1uG4YwmvHThv+5rrEQ00PsZAjyYlf7VFoAPa9ULQ
         sgdgH5u5zYwsxOA8J2ZhEDAjKK+IOlhBZI816D1jxm6+v7F1AghNKABKkd2ANv1bWVG7
         S0KoK/ArU9qITLrrjDtRzCXz9uAE8g641kXUSpS5HPkUVEiN12A8XpyWTNdoXJwo6MrN
         TsqkkeFDm3mBiDFxTVBSgYyA1lMGyWeT8iyX4eJ+8F1ObbFb6HJ7eBG5+xcJb1k2OpSa
         yj8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YziJNKZPYKiuMZ6/msCJcvFJzTR8tDS0yfLXYtfKzu8=;
        b=IKRAkIsA+3tpVkW657oE3YAVtQie+ZWoD+8DgimK6VGJlOH3MEaEVXQ3zLCGDKBmwl
         wg7nmB1kZUsjoF7X62dFWrzq5aef3h+cl9zbfgrMh0secDP5DVoYeXFtQLCxpYuw1Rxf
         3i3hM7mvXhvUoTYmFhes9+Ln7VsQvZg0iucGCA14V8BZJ6S/iHd2lLaEC/KhhVgPlW+J
         rFuMTLH717Xcst8oGjDtd/avdWGqql9vXAfcS2FvqhccOxNl2w/4dxrEmBRpr1/W/aQ/
         AUbS5qmLzGww1150cBEFGshWZom3UTWKfqA5rYAGEr1TtQR+mIUCY8lE+RevIN347Lph
         UxNA==
X-Gm-Message-State: AOAM530HpfmwqVApJP5FsMX4XoPzoGC5s2m0dsbwZLhEYX4sZg5dyNmd
        HvMU5F08TKvemN1ZlUb9N2wfCgZklNr53w==
X-Google-Smtp-Source: ABdhPJzvuh6J975aVeEm81EqmCFl/qkdf++DgTMUnI7DaTv7KX4JG1TBxfXyojHsJcJYanRmE0qLZw==
X-Received: by 2002:aa7:808b:0:b0:47b:f51d:e238 with SMTP id v11-20020aa7808b000000b0047bf51de238mr7899871pff.43.1635207289652;
        Mon, 25 Oct 2021 17:14:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nv5sm21840825pjb.10.2021.10.25.17.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 17:14:48 -0700 (PDT)
Message-ID: <61774878.1c69fb81.315d6.7a38@mx.google.com>
Date:   Mon, 25 Oct 2021 17:14:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.14-169-g753f4d2e9054
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 141 runs,
 3 regressions (v5.14.14-169-g753f4d2e9054)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 141 runs, 3 regressions (v5.14.14-169-g753f4=
d2e9054)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
beagle-xm             | arm   | lab-baylibre | gcc-10   | omap2plus_defconf=
ig | 1          =

kontron-kbox-a-230-ls | arm64 | lab-kontron  | gcc-10   | defconfig        =
   | 1          =

kontron-pitx-imx8m    | arm64 | lab-kontron  | gcc-10   | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.14-169-g753f4d2e9054/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.14-169-g753f4d2e9054
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      753f4d2e90548c078cfab393c4365c0ce53b6a88 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
beagle-xm             | arm   | lab-baylibre | gcc-10   | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/617717e601934cbef53358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
169-g753f4d2e9054/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
169-g753f4d2e9054/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/617717e601934cbef5335=
8dd
        failing since 1 day (last pass: v5.14.14-64-gb66eb77f69e4, first fa=
il: v5.14.14-124-g710e5bbf51e3) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
kontron-kbox-a-230-ls | arm64 | lab-kontron  | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/617716d2d56df444fc3358f4

  Results:     92 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
169-g753f4d2e9054/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-kbox-=
a-230-ls.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
169-g753f4d2e9054/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-kbox-=
a-230-ls.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.bootrr.all-cpus-are-online: https://kernelci.org/test/case/id/=
617716d2d56df444fc3358fc
        new failure (last pass: v5.14.14-163-gcb95282425cc)

    2021-10-25T20:42:35.258003  /lava-53600/1/../bin/lava-test-case
    2021-10-25T20:42:35.258542  <8>[   15.013946] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dall-cpus-are-online RESULT=3Dfail>
    2021-10-25T20:42:35.258723  /lava-53600/1/../bin/lava-test-case
    2021-10-25T20:42:35.258876  <8>[   15.032852] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dfsl_enetc-driver-present RESULT=3Dpass>
    2021-10-25T20:42:35.259024  /lava-53600/1/../bin/lava-test-case
    2021-10-25T20:42:35.259166  <8>[   15.048439] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dfsl_enetc-enetc2-probed RESULT=3Dpass>
    2021-10-25T20:42:35.259311  /lava-53600/1/../bin/lava-test-case   =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
kontron-pitx-imx8m    | arm64 | lab-kontron  | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6177175d4af62b1058335911

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
169-g753f4d2e9054/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
169-g753f4d2e9054/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6177175d4af62b1058335=
912
        new failure (last pass: v5.14.14-163-gcb95282425cc) =

 =20
