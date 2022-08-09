Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A71558E3D7
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 01:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiHIXpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 19:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiHIXpi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 19:45:38 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB267E83C
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 16:45:37 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id f28so12202041pfk.1
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 16:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=xGoS18orAXEgv0Z4Tngzo6rCQlvSdfllSsT6ofPmEuw=;
        b=foFgVAwz6OoJmzKxKARA4cIUmQhsrDkpyX3GLSScSntri0VmyZyw8GvpvfzneLhQx5
         qMcinQUvi3qyaVb+Sp1G2XYBrrZcdgTwX71glyUHogFTJHXrP29X9pF4oeKSE/Q5Nu/X
         D0t9+QzgYduqhK7UtBIlXH7gczs8P20VfXxP1gJTvEmBCxHXtriCYxJRI+TTWlMRWcEk
         bEOMMW6ErCf3gCyRuKBTfOMAKYDqUTdSbIx1tFm3TzEvd2Y9BP5GlYNqEhkPj7OuWVcN
         lmUBW+clIW4OlDdO/xwTahzAXjHD2HeW6jZpEbwLs1xzPv1x/tIey8d0/b+y7IjTiH4o
         wVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=xGoS18orAXEgv0Z4Tngzo6rCQlvSdfllSsT6ofPmEuw=;
        b=eXVikInc4uq8NxveU/nsMQPGheGKo6olP27oSU2QyVcufSaLHoIqruHpdxIdtLpKtg
         gYPWXp4Vz9Araa4x6dXihW4pIXQGQtv6r/WNndbQB+m2m5LX3XcMPAMclL0iQwpCqmC1
         e/rveNZ/K7yB7mISHvojW/m7UeC9XWot76Qsr74ckNr+pJBK/3Eh6vEHUqeY5OtGPReo
         VgfbKuhzvSPHmk3oX6LVLKamwYJ1rqfrbOco2FqurjE5bC6yx+ecnz0GhK0K6YcrdKd6
         0uw3F0jObYcjaUwSkuURKRL3hBzNkSt5pzAALlgGKbPbJu85uqJu+5N0ASZI7mKH+8Gu
         aEAg==
X-Gm-Message-State: ACgBeo0kdSPqVNvCfzkdt2GiFEs+vzGJp4DtkTFH00KsWZIb08Juy9KR
        3kIwuytMV1zcq1VoUpbnfuaTbT0n6qV6qNIySHA=
X-Google-Smtp-Source: AA6agR4+TEkDRoPPSIzBpI1jwdUDUD3Q/9kJtQTEj2EwkJVDcLgABQwYd/YBBV/Iwri08ApvxpZK/w==
X-Received: by 2002:a63:114:0:b0:41b:2017:d243 with SMTP id 20-20020a630114000000b0041b2017d243mr20900569pgb.12.1660088736761;
        Tue, 09 Aug 2022 16:45:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a12-20020a170902710c00b0017091fb84c8sm7636383pll.83.2022.08.09.16.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 16:45:36 -0700 (PDT)
Message-ID: <62f2f1a0.170a0220.39c80.c2e1@mx.google.com>
Date:   Tue, 09 Aug 2022 16:45:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.59-31-g9c5eacc2ad1f6
Subject: stable-rc/linux-5.15.y baseline: 79 runs,
 1 regressions (v5.15.59-31-g9c5eacc2ad1f6)
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

stable-rc/linux-5.15.y baseline: 79 runs, 1 regressions (v5.15.59-31-g9c5ea=
cc2ad1f6)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.59-31-g9c5eacc2ad1f6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.59-31-g9c5eacc2ad1f6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9c5eacc2ad1f605c31c69d9e2436823ada99f1dc =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f2bef958ff775967daf05d

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
9-31-g9c5eacc2ad1f6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
9-31-g9c5eacc2ad1f6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62f2bef958ff775967daf07f
        failing since 154 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-08-09T20:09:10.181065  <8>[   32.585047] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-08-09T20:09:11.204919  /lava-7002754/1/../bin/lava-test-case
    2022-08-09T20:09:11.215833  <8>[   33.620007] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
