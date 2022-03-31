Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E1D4ED51B
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 10:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbiCaIDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 04:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiCaIDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 04:03:32 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83721DAFCB
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 01:01:46 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id bx5so23300283pjb.3
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 01:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F1avMCz7a4u1DXyy9mda6y86tWPvXY2h8pniDmwM0rQ=;
        b=Yn7IrHKEUBIwRwQogsRMuWdkLeD2uKWRHABhrU7wG/o43J9aAexhWTJFuqtl6hbCFc
         CpyoEfdGZ/nmWJRrcN0xNiDymc4C5MB9Uy+j2RrXSKCX+YyzzCgcE0ZW1vFnf1pbsp8g
         87kKETai1VgO2jcoWwn6DuFeAnVSVyRjzxjGadFb6sBZ4KK2I/VCtLCCefTKZUTdgMzO
         NGCe/I0XTJpWTLcppNtYz3py7bS733Y+H4d72pmP0XZDShzYaB+b194KsIderhZMOeRT
         vPPW6W7GEShfByVXMlXMPdtycoySlyK14fNrVXWDMKytPp8LRs6aNlRH8SuB+L1JrcaE
         MIbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F1avMCz7a4u1DXyy9mda6y86tWPvXY2h8pniDmwM0rQ=;
        b=TiuYK2MvSqtRCNzWuvSYdeV/GOl73lRrMLafQ1OHsc8bLdoHm4BGbYtPskL/cNw6pc
         7mGnFZtNCJOh8bfcINS13wVf5D9v7aSRFn028JqH3i3gYyTSKMcmoLllBIiGgI1aJBFQ
         FxjWgndbBW6BcxDL1PLkb0x5r6q9jzUKuNr8UocFQGrYwcp/H/6hMU/xqA82VPdFE0jw
         1qkoSsahsIPNTzPfDuoSuq31cY2QliF+W6U0EFkPaaK0rPlAF/9SGExh/9t0OsZcFlYI
         U7tlAq2DTenjMp4hekBWWWiKcIjNkcebTtRL2h2aTGwUIedJ/boBMXy/5EtlxU/Wy/8u
         gSAg==
X-Gm-Message-State: AOAM531x440STRULIXLO4u2lG4ySYSMRxh6ymmttgC4cQKFYF8frSNdx
        vvSsVL+1oqkH8sJNsIzT2xGbiGuoWljwpyzjun4=
X-Google-Smtp-Source: ABdhPJzO1h+CPlsAk1WGYkURfhJxkjp5olmu5r9OPE5GWnp0KKnRmKFDNwNRa3VKHpNHvRq+Uxmajw==
X-Received: by 2002:a17:902:684e:b0:154:3b94:e30c with SMTP id f14-20020a170902684e00b001543b94e30cmr4149672pln.89.1648713705845;
        Thu, 31 Mar 2022 01:01:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g5-20020a056a0023c500b004fae15ab86dsm27455739pfc.52.2022.03.31.01.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 01:01:45 -0700 (PDT)
Message-ID: <62455fe9.1c69fb81.12246.64ed@mx.google.com>
Date:   Thu, 31 Mar 2022 01:01:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.109-23-g09422778fc8c
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 114 runs,
 1 regressions (v5.10.109-23-g09422778fc8c)
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

stable-rc/linux-5.10.y baseline: 114 runs, 1 regressions (v5.10.109-23-g094=
22778fc8c)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.109-23-g09422778fc8c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.109-23-g09422778fc8c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      09422778fc8ca3a1132208cd8e957242be79eda6 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624529440a560c1ccbae06a6

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
09-23-g09422778fc8c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
09-23-g09422778fc8c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624529440a560c1ccbae06c8
        failing since 23 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-03-31T04:08:24.243901  <8>[   32.988984] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-31T04:08:25.265779  /lava-5985817/1/../bin/lava-test-case
    2022-03-31T04:08:25.276978  <8>[   34.023320] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
