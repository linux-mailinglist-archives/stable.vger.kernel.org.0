Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150755296F9
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 03:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiEQByx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 21:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbiEQByq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 21:54:46 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E833F8B8
        for <stable@vger.kernel.org>; Mon, 16 May 2022 18:54:45 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id g184so15727568pgc.1
        for <stable@vger.kernel.org>; Mon, 16 May 2022 18:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=O50JF2U2pIUeD2/FmFQM8QQ+2ECQRk9PoxuNCcVUSAs=;
        b=wYiT+WHU4rpDeY0nrWbVnrspYIMrhNNGOE+nketfAdtJVet51vVc+Dt2LYP+QO3Zjm
         qAs7DDLvvgriSapQTnGAK7l6+05EdONMtyX7rvHDb9zLgRQvXnRbXMdr70sgdLYWyGZf
         QsmLUOuRtEkWRgg+qyPQEIyeTXZC4BfwN56JdmupgPghY+bum1S51mOC7lEJjRkfVFY0
         USaWyhZQsKFye0rkTFU7jjqXQUZNU3pNXbruzysw0w8ASrHHYofXRzIe17jUR0FObbj2
         02Kd/SGn8F/CwN3wDFRwsgWB/3+RRXPwL6mt0/oRwmLGdT78a78UKj6R0dx9QQ7ObagA
         5Uvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=O50JF2U2pIUeD2/FmFQM8QQ+2ECQRk9PoxuNCcVUSAs=;
        b=2AcZTqhuSmxYeRl95tmR0h4/ZI8l3ne52Ij/RUebBlt1RAF5+jLwrwpeYFOPBhzTGJ
         Pt4lX3B2XGl5qg/1q/Vuz0yHUmILo4emisVObJIcf8cRbb1QGplHSh9PzLowXw8DFJDG
         R0xV0ZYnZFiMwsKJh+U2Vpd41iPMVG7twqBJZsedmOE1pD5WFSuElrmlM7aQ/OKWcUzY
         V+QU2VT9sB+jsuE7P7bDbMP2p/rFj6N6c/eU2j3+dDDpWNEqI2NYph3PsKogvGHhUAHU
         2gKXtA1vwEL/R5ciJX19iBk8sVkQR3wdw2Rne8yvGelFtKmcL/ULsoNDxjsiuptiSlA2
         Sq/w==
X-Gm-Message-State: AOAM532H3q+0DtzdSHFGpICge+YDAyHG0UBu8oAtb2/kTcS7Ygo9879f
        hVuAIhjU2xHpE/AlL2QnwvLqT5LrcxumKBRN9gc=
X-Google-Smtp-Source: ABdhPJzSh3b2s8l7UQd6y9b0VqTxqsf1/dfebWkE6y4/2YadjPkiNHVmxemA4ocd6bMMhhHEN8xPqg==
X-Received: by 2002:a05:6a00:c8f:b0:510:60cf:55fa with SMTP id a15-20020a056a000c8f00b0051060cf55famr20160601pfv.37.1652752485135;
        Mon, 16 May 2022 18:54:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v7-20020a1709028d8700b0015e8d4eb1e4sm7691089plo.46.2022.05.16.18.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 18:54:44 -0700 (PDT)
Message-ID: <62830064.1c69fb81.82a80.3b8c@mx.google.com>
Date:   Mon, 16 May 2022 18:54:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.194-44-g25f2e99af01b5
Subject: stable-rc/linux-5.4.y baseline: 90 runs,
 2 regressions (v5.4.194-44-g25f2e99af01b5)
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

stable-rc/linux-5.4.y baseline: 90 runs, 2 regressions (v5.4.194-44-g25f2e9=
9af01b5)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
at91sam9g20ek        | arm   | lab-broonie  | gcc-10   | multi_v5_defconfig=
 | 1          =

hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig         =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.194-44-g25f2e99af01b5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.194-44-g25f2e99af01b5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      25f2e99af01b5b7328f55bbadab563cb26478289 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
at91sam9g20ek        | arm   | lab-broonie  | gcc-10   | multi_v5_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6282cd4fc40f82d0aa8f5717

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-44-g25f2e99af01b5/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-44-g25f2e99af01b5/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6282cd4fc40f82d0aa8f5=
718
        new failure (last pass: v5.4.194) =

 =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6282cc407e6bb064688f5744

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-44-g25f2e99af01b5/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.194=
-44-g25f2e99af01b5/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6282cc407e6bb064688f5=
745
        failing since 40 days (last pass: v5.4.188-371-g48b29a8f8ae0, first=
 fail: v5.4.188-368-ga24be10a1a9ef) =

 =20
