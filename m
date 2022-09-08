Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9C15B22DA
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 17:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbiIHPwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 11:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiIHPwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 11:52:47 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBBEF9106
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 08:52:41 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 78so17133101pgb.13
        for <stable@vger.kernel.org>; Thu, 08 Sep 2022 08:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=gOIvhKGk05sljTpGwp0m2F0ftq0in3ZUTkZJK21K620=;
        b=ouFkEacxOlyqZPBDpMdS+ViF5F9aL1h2yAGP/2S1gzCcPaPCykW/TEBZ1RKHkhhc8M
         wGWwvctEHo9vq/MJFLysKbklJIaouoa3tAR4bubECuEh/9ctJRfE6OR4MwvtBA5RRqLe
         4la/tujW+LtzJOcz/JxvI3lGX9zmPC9U390+kgymGnwvbjAkr7V3DjjB0GyNXtsQVfzv
         iAmgCgY42bG5jsXdUkIeJ3HwMsYwcIhAwPo0ecAMb0VLjdgNDVYbKIDTLsGMIIMsopkL
         FBibMDWQbWO9aulAtOLd2xzOkcuNmg2LQX9YWnZfCRQZoac6eDE2SDis+bI0zfqfKbgI
         T5pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=gOIvhKGk05sljTpGwp0m2F0ftq0in3ZUTkZJK21K620=;
        b=1PJZv5L7Ots9Tjzkq9XFub/vff41kH1urWjvkL55REYS/lCIZPJWTZ9EXAPghVNDzF
         xqA95Dx9Mfs8WyWnhX7Y8XDEMZn4zscQ6NbCuZXljlkRvplGzHDUK68K1JSPRKHcfg24
         WfH6965vtn2EUOx2sid64MrNmkwEbQpYJa2j+ahhan3CQM+H14cg0rCQxX4fTSgnAKau
         oLHHZUKlMc/OF90WyqUalaqiuBQZHMVQZMNELqvV6fWsi3DEdCTXS6iYq4booDqyd0AB
         m6PJZ5MPz8iejyYlSs37Yf9rPghUgiGv7CYr10iP6aDq4ZpIk4IpCpn62eby1DKrLpq1
         B+6Q==
X-Gm-Message-State: ACgBeo1kRr73sVvlCcmDDYgOqbgKCaUxkoIsO5ExtLevi8Yo/0SdkNqS
        8jxf7FTcE+VSXh/+2aeeexw3s9bbo3s5rWFKvrs=
X-Google-Smtp-Source: AA6agR64uFuUefjRl71bIg+0LS/+lyaGC6RnXF6tfUTigdPcWOxCONtQyjbUl58Myc1hQt+LCXXFaw==
X-Received: by 2002:a05:6a00:9a5:b0:538:73c:bf8f with SMTP id u37-20020a056a0009a500b00538073cbf8fmr9763648pfg.9.1662652360731;
        Thu, 08 Sep 2022 08:52:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b9-20020a170902d50900b0016c0b0fe1c6sm14856436plg.73.2022.09.08.08.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 08:52:39 -0700 (PDT)
Message-ID: <631a0fc7.170a0220.b4039.75a5@mx.google.com>
Date:   Thu, 08 Sep 2022 08:52:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.67
Subject: stable-rc/linux-5.15.y baseline: 171 runs, 2 regressions (v5.15.67)
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

stable-rc/linux-5.15.y baseline: 171 runs, 2 regressions (v5.15.67)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.67/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.67
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e1ad7a011591d4a508a08e180ae0471224fcc17c =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6319e12234167a5891355671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
7/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
7/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319e12234167a5891355=
672
        failing since 118 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6319e02d3b3afdf153355682

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6319e02d3b3afdf1533556a8
        failing since 184 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-09-08T12:29:10.962403  /lava-7212578/1/../bin/lava-test-case
    2022-09-08T12:29:10.973295  <8>[   33.669823] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
