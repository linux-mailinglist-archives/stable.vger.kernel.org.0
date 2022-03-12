Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2021F4D6DF8
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 11:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiCLKWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 05:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiCLKWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 05:22:11 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4006A6543
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 02:21:05 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id z3so9678234plg.8
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 02:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9iL+rFYXMrtX3XRyPUQ0rCnBk1R9BwIiRzIF2WJJUQg=;
        b=61LP4Su8xFNZhF/YC/2hLFUekEAo35I7xBoUT1xCI85zWijxR/p+YaChX+H1y69//r
         nrpPct5hr6Dwn8GXpiLP03b/7MHyjGeDqqqLSag4vsf5lXOIpz1w2VbUwMXhaGDrWBVQ
         F45VKWogKbVPmgE5VHkrYMuSo9s/YJp5PCsk+zvsYPGD7AaOoKETzCMMWTL0OVTjjGD4
         A5/HYingYpy85KYJHwMk1HLVhCX9z9TPKMX0Wf+PKUP2WCKH96Sh0YrykkwwqZNJ9A+q
         FyXzhxT63rwKo8wpeajYrZ9izNn1upKMuwdPBsH7IMq00rFnf3ZObkEw3OLQctsalRTf
         ooCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9iL+rFYXMrtX3XRyPUQ0rCnBk1R9BwIiRzIF2WJJUQg=;
        b=MKxTACWBv1Y1MKSe/st9t1I028X0WHW+SumQCSCe7WC7Sw0MKOS4yRCfTrS0Yp5CjK
         pLPmelH8tOXcS1P9TMzecM3G2FTZ0LcUK7gP0TxOO76qJSDhBt3aBPR+pb9rQeebnWi1
         nl2QfIW0kwwlEzzpdeAZlb85FP28E9wiLONwu13Bavlj/bxbtl/HYl7u5k53wpNEX3+r
         SXGpFnhabCNYlbbVcdtjIj7Tdbf3MJCb90Qjbd90lEy/J7mg80csVJ8+T1lknzCjnOdX
         MgyhHe2BYAZJN2XlNaW1AIz67mmYp0EkAyg1080fpeCUC7zPjwXKN8ua3YCI4EPJ2gP4
         pyXw==
X-Gm-Message-State: AOAM531UnwfZFqoDB3o8ee9wwS6HBRWGfwUR8f5WfJ8KnlaZYIqm+MoK
        PXA0LX36xKyITbMFjAkYKi67zjfQ6XrTiE8gaGA=
X-Google-Smtp-Source: ABdhPJwBOhVEVTgZXxKzxZmX70SWeOJn9ezYa46BT91scZ8IAMSuh0VGH6d/GR88Q6tPwPYDY3TMvg==
X-Received: by 2002:a17:903:22d0:b0:151:97f5:db54 with SMTP id y16-20020a17090322d000b0015197f5db54mr15004273plg.58.1647080464607;
        Sat, 12 Mar 2022 02:21:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l18-20020a056a00141200b004f75395b2cesm13550508pfu.150.2022.03.12.02.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 02:21:04 -0800 (PST)
Message-ID: <622c7410.1c69fb81.7f995.33ee@mx.google.com>
Date:   Sat, 12 Mar 2022 02:21:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.104-59-g222eae858936
Subject: stable-rc/linux-5.10.y baseline: 101 runs,
 1 regressions (v5.10.104-59-g222eae858936)
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

stable-rc/linux-5.10.y baseline: 101 runs, 1 regressions (v5.10.104-59-g222=
eae858936)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.104-59-g222eae858936/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.104-59-g222eae858936
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      222eae85893657f02832253fe1c164f7d0b2c88c =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/622c3f091919879fd6c62979

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
04-59-g222eae858936/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
04-59-g222eae858936/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622c3f091919879fd6c62=
97a
        failing since 4 days (last pass: v5.10.103-95-g552e594da6e8, first =
fail: v5.10.103-106-g79bd6348914c) =

 =20
