Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF605FBC53
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 22:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiJKUnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 16:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiJKUne (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 16:43:34 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D96F7268E
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 13:43:33 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id h13so13168424pfr.7
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 13:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Tp2YChV0mjrjZpeDGcg82JBD/nBr4nEZVyD7vtYV9JM=;
        b=KG8ZicsT9qc7fFJsFPyLg2937bG4eBnYTiy0E1W/7GWh+davFtuqWHkP0BeFgjRymD
         ycS00S8Si2ibMEfN9CSLZFxUur0qqNwDquKZxkg7sKfh46seJoTq6geE/GO/hHfanMY0
         ofpfAnZv2NQkYmzanrRKAVvVJgnhGaGOMv8ahVW+2zH6CRQND0aUIAiefdWJBw1CRb2b
         1vmQbsKzWvKwMwliOWX3gtEt1ZP/QDFf7S6mTtb5Ts1QpvHkKAYZN8ejnMy2VKRWHPvo
         CKUwKy3+LsXmXR04zVJXu+3wenASTN3rDNtV8BZBdcS19ktysIMj5eBAbcLZXqfo1FV4
         8DKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tp2YChV0mjrjZpeDGcg82JBD/nBr4nEZVyD7vtYV9JM=;
        b=Oz5xxGRirfJRe8HRjoOQ+LTOZ7SDc2HL4M++nOxmFRoVOcMkgPgDeio8NmVj1kccHf
         nsGBrfJQwPAzeXDIUkmdWzdmLidolXs5v+melIeSMwKWG8BvaS0SFNsxBFTD8aaBAt9i
         bvcpv9ghiBNbHCSNSeGMEAXZR/gmP693crHy8jydPOy2/JZSDqmb/LehgluVq9HPgQsD
         H9AqsG0KumRSHw2/PkzSIAlxtD/VCPA65IfHK/kug79mhIVWVx8e6vPBRrN3hLPhFsFg
         KtMRxlwNPz2A/lWudmbpjfylnsDBXLM9vb/HD+R7IC90Kt7mfB+ICjFFCyO5Tbj70TX6
         YXVA==
X-Gm-Message-State: ACrzQf2qVnMap/5me89daea6t8NPzD2b6uIjbpqTb2V+c/2KWQem607r
        zb4oCD5ku5dpWPXMEVWpQF0bHGgHlYQRdBoUFsI=
X-Google-Smtp-Source: AMsMyM6T5HekC4kUMsJi36G/Q2GHWwZPwnVqowDwgHbmzmcGdQloBBmX4TM8fHTF98FVGrqr35XLUw==
X-Received: by 2002:a63:2143:0:b0:462:48b5:fcd4 with SMTP id s3-20020a632143000000b0046248b5fcd4mr11091343pgm.150.1665521012569;
        Tue, 11 Oct 2022 13:43:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g12-20020a170902868c00b0017f7f8bb718sm8981208plo.232.2022.10.11.13.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 13:43:32 -0700 (PDT)
Message-ID: <6345d574.170a0220.fcf3c.f807@mx.google.com>
Date:   Tue, 11 Oct 2022 13:43:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.19.14-47-g0f2b1a82748ec
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.19 baseline: 151 runs,
 2 regressions (v5.19.14-47-g0f2b1a82748ec)
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

stable-rc/queue/5.19 baseline: 151 runs, 2 regressions (v5.19.14-47-g0f2b1a=
82748ec)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig             =
     | regressions
----------------+-------+---------------+----------+-----------------------=
-----+------------
imx7ulp-evk     | arm   | lab-nxp       | gcc-10   | multi_v7_defconfig    =
     | 1          =

mt8173-elm-hana | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrome=
book | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.14-47-g0f2b1a82748ec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.14-47-g0f2b1a82748ec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0f2b1a82748ec4e3eea4e03114ba56e1e1cdad16 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig             =
     | regressions
----------------+-------+---------------+----------+-----------------------=
-----+------------
imx7ulp-evk     | arm   | lab-nxp       | gcc-10   | multi_v7_defconfig    =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6345a28c57cef58d4ecab64a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
47-g0f2b1a82748ec/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
47-g0f2b1a82748ec/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6345a28c57cef58d4ecab=
64b
        failing since 14 days (last pass: v5.19.11-158-gc8a84e45064d0, firs=
t fail: v5.19.11-206-g444111497b13) =

 =



platform        | arch  | lab           | compiler | defconfig             =
     | regressions
----------------+-------+---------------+----------+-----------------------=
-----+------------
mt8173-elm-hana | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrome=
book | 1          =


  Details:     https://kernelci.org/test/plan/id/6345a5b015fc723317cab5ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
47-g0f2b1a82748ec/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
47-g0f2b1a82748ec/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6345a5b015fc723317cab=
5ed
        failing since 1 day (last pass: v5.19.14-7-gf73a6cd88959d, first fa=
il: v5.19.14-39-g57fa2dcf24d2) =

 =20
