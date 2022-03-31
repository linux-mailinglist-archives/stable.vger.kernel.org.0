Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0464EDC0C
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 16:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbiCaOuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 10:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236576AbiCaOuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 10:50:10 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE16B9FE2
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 07:48:22 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id d30so7188147pjk.0
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 07:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gHjw7hz2tJ9W5CzQUD2L4Yg6rJY1B4dDUnBs9/gjQTQ=;
        b=Iips/CmF0TOzDcsQRV3US2cs9nulCw7k7sSfekVF9iGZzbeOJE42DVnoonFTlkLKY4
         hQx/ZYQ1Fsi29NBlLSNx99OO8JUAih1kGralk3G+N2YQqiKPamHf928kCMkzy1OlI9cX
         1Qg5tnolX4L45gh8DcGRCx20t5Z0do7kOY235R8myPG/A/b8R1LyjNHDeD+GT5k75yLg
         kxPwUqI2dae7dXVELNVB0pLT0+wxOcmMe1k3Op3168coJQi/ceCT21nznxDSXP1ZmPwk
         E0X/sOb2joPHkEYlSkhLFGuCGG2DehYxAQrSsta+Ur9lN3U8YLpMzZ2mOTSnx/uDojVV
         OxnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gHjw7hz2tJ9W5CzQUD2L4Yg6rJY1B4dDUnBs9/gjQTQ=;
        b=x8Bbtn5KQLTTxFfXMfWrSBf795M+XAgRnF2YEc4TA0Y8R94Zumgyx1QXy8tcRADyIR
         MJZOZgkeAR8GN4MoQPEhz6iteahme6tkDVCVWi70L2VDjflz6rCGsx77B9r2Y/pO9Nfv
         Ozsm7upSWZLbcC+wgg6VCFXled9jChbfiGFto3s9rrWdTOi0i80PpZu/iOTo1CI78+rf
         cmIoeXGLZFnVJ6aC/ynX/yMHGd6pSyyTRFAASMDJwCVZOHH+g8Ft9XnLCSZh5g0q+0xo
         nFEmtdT6q2bqSemGzUabMBNMy1uGBz4KAKUkXO2p2Uhc0PwCta7n4qbj8iEw1bL0RlGy
         65Gg==
X-Gm-Message-State: AOAM530RcSCGmaodCiAGAr77mQ4zHrbIbLB/6Fz0ZzSPM45vpHhnv5RH
        NtikVL8GJ0FJsspcxsqMcAh1N9D6pbzwGwTi904=
X-Google-Smtp-Source: ABdhPJxphUkmDLt7mWoxa4oiSzXML2dq0KIQtJHLqu5jUh1lTbqyttbtnAvUS7b5NQcjtT//rB4rsw==
X-Received: by 2002:a17:90a:b10c:b0:1c7:2461:89ff with SMTP id z12-20020a17090ab10c00b001c7246189ffmr6397087pjq.163.1648738102302;
        Thu, 31 Mar 2022 07:48:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ci16-20020a17090afc9000b001c9f9b5e004sm5828035pjb.4.2022.03.31.07.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 07:48:21 -0700 (PDT)
Message-ID: <6245bf35.1c69fb81.9e3f7.d746@mx.google.com>
Date:   Thu, 31 Mar 2022 07:48:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.109-24-gb5ff5731aa65
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 127 runs,
 2 regressions (v5.10.109-24-gb5ff5731aa65)
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

stable-rc/queue/5.10 baseline: 127 runs, 2 regressions (v5.10.109-24-gb5ff5=
731aa65)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =

rk3399-gru-kevin   | arm64  | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.109-24-gb5ff5731aa65/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.109-24-gb5ff5731aa65
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b5ff5731aa6554147f4375d7f97b19e65c5ac839 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62458ab3a58c45c419ae068e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-24-gb5ff5731aa65/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-24-gb5ff5731aa65/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62458ab3a58c45c419ae0=
68f
        new failure (last pass: v5.10.109-22-ge3a27d59f151) =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
rk3399-gru-kevin   | arm64  | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/62458d73d723027bc9ae06a4

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-24-gb5ff5731aa65/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.109=
-24-gb5ff5731aa65/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62458d73d723027bc9ae06c6
        failing since 23 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-03-31T11:15:41.456084  <8>[   33.303899] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-31T11:15:42.476277  /lava-5988111/1/../bin/lava-test-case   =

 =20
