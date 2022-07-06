Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D6D567C8F
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 05:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiGFDeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 23:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiGFDef (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 23:34:35 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2BF65AB
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 20:34:33 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id w185so9524665pfb.4
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 20:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+jZcTLd0uhnPTsp/RWeXfIm6MxH1xo2fh8ug+vRFmwc=;
        b=b5xuSjChqgFH1d3h5fK9PPoO89bjqEQSq9Mv0q25lykxeAgvYPwSNLMUGY9ofI2i7+
         b1lrEp9Wr8/o0BgIjRryzuFtskvVSbn3yjXn6U8RG75UutXfESLQvcgsCRRr+uzwGz5h
         VUSqvTcP7s8Q+e3ZFk1frJLi/z3SDIiPL87IToFn07nrs3pSj1WCGDCYxqzHiQzuHkdy
         T9ZyhicziCoDUIg8kMvJHCzDJaXZ4zPTy7AEM7Kpc8Sr2mIytb9VbGfHn1yoN+2dbhwu
         u+/UjFLsNJEdsKN6SDvvCBZ7jnG4x2Ys7NS6lORkscyiNPe5EWAdfmAjiYKO/lriFYtf
         WQZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+jZcTLd0uhnPTsp/RWeXfIm6MxH1xo2fh8ug+vRFmwc=;
        b=Sbqi/2z2NmbNu1Rypuvy5xA4dxUYWRVbTAXmwBRuncpJOEf+ItrAvVK1ONQq+ESil+
         DX7M2ewMasxZIQur5qIwnUNpzpsLqlFX0KkDs6mJmBtn/XxRUT08h+7REKW9Q4oRqUdV
         B/P+c3vMCXsXEI6A3/LXQbLrWT9SJZkZEd1nAEiBCDM6Cx6wgZ1egUhdi60tFwzsD0vm
         4IGa/vaa5nins1f5O60tuSFtUZ4mF95X0NieppRmB0ytGEzvX9LaYJO2oDFHqlS41OTI
         3+hdGMDqyONX7pWJq1ERCRPuxN1fMDn2kqkMB0sHTAcrW6RBssWRqNktdhyWuVveHbOR
         nuHQ==
X-Gm-Message-State: AJIora/OYy63jLLnhw5ys4LeAEKkXWjlgGYbpS2meQPRuOp2tPWl7HWS
        u+Si59ZwgpP2TZGKFw+4FIpFd4iOLBQLMnF4
X-Google-Smtp-Source: AGRyM1sQCx0hOJ3q6l6w202dReF2nwXFkpnIHpGUx86hFmQBeSG1pQ5GL2MxxzdIpQhHsj7uYLoZXA==
X-Received: by 2002:a63:2c89:0:b0:411:66bf:9efc with SMTP id s131-20020a632c89000000b0041166bf9efcmr31961331pgs.589.1657078473141;
        Tue, 05 Jul 2022 20:34:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t17-20020a170902e85100b00162529828aesm24489033plg.109.2022.07.05.20.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 20:34:32 -0700 (PDT)
Message-ID: <62c502c8.1c69fb81.3cc52.3ceb@mx.google.com>
Date:   Tue, 05 Jul 2022 20:34:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.52-98-g46dd125f577c
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 106 runs,
 2 regressions (v5.15.52-98-g46dd125f577c)
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

stable-rc/queue/5.15 baseline: 106 runs, 2 regressions (v5.15.52-98-g46dd12=
5f577c)

Regressions Summary
-------------------

platform                | arch  | lab         | compiler | defconfig       =
   | regressions
------------------------+-------+-------------+----------+-----------------=
---+------------
at91sam9g20ek           | arm   | lab-broonie | gcc-10   | multi_v5_defconf=
ig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe  | gcc-10   | defconfig       =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.52-98-g46dd125f577c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.52-98-g46dd125f577c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      46dd125f577c06dad24210e06632b12e76cb14fc =



Test Regressions
---------------- =



platform                | arch  | lab         | compiler | defconfig       =
   | regressions
------------------------+-------+-------------+----------+-----------------=
---+------------
at91sam9g20ek           | arm   | lab-broonie | gcc-10   | multi_v5_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/62c4ca368046284b04a39c2e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
98-g46dd125f577c/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
98-g46dd125f577c/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c4ca368046284b04a39=
c2f
        new failure (last pass: v5.15.52-98-gc89c3559309a) =

 =



platform                | arch  | lab         | compiler | defconfig       =
   | regressions
------------------------+-------+-------------+----------+-----------------=
---+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe  | gcc-10   | defconfig       =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/62c4cd5b552bc62b05a39c00

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
98-g46dd125f577c/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.52-=
98-g46dd125f577c/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c4cd5b552bc62b05a39=
c01
        new failure (last pass: v5.15.52-98-gc89c3559309a) =

 =20
