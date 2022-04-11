Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67D54FC61F
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 22:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbiDKUvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 16:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237273AbiDKUvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 16:51:12 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595DA13D5D
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 13:48:57 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id ll10so7926436pjb.5
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 13:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KwiJNlfX86HCZA8ekhvZ1JQ1q1dnWparryagPc5hOME=;
        b=DbPon5avroiTuxYd2pxc25quiD1p3T2HPixEO87Trt2z0mywzER/cZwXPAj678a71P
         cWwUFVzVkspNAfQfgD1vktxWSOCwK2AbSsItzpwLemu8+Y0AMG3qMKSq8cwx+YDQilrj
         qdGoSDL3snvb/AIEhxMD9uk1WNLtCzlPvg/ZUdtIUY6Sk3mfqU8VuVs5O8gUFfceALLF
         9IX8FtmmSwfhsewn/ZFRAHc2fzsIME/wuWdk8MzQDcDATIV6yJBEkZb8zPUcnXsXIHRG
         KBoSExX2ItbkuWsAD/EjzzIi8LCZ2+zYU/BfvQXPvrCnHllEAMiPNow8bv3NUyvlsoY+
         b6sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KwiJNlfX86HCZA8ekhvZ1JQ1q1dnWparryagPc5hOME=;
        b=4xOcHYNZrwCsLoB7LsOt9FmYidAp2VF7/GKtHmDeBImloFqFRu9E9OW4s6rPmtM7y+
         t8t0B+PbD5FrvRnipdwJC4LH+rgvzgo3R3B35eTUv6z/mViJw1s6mZeB2qSdWdIyXk1W
         U5aWeiwMcvg/3gT1RjJ47Q2vQw+EjFT0aQQndjVQ0VvjT7iVBJGqvf4Sttdgsg+a9nAc
         u6Y6EFzy4bTCqKNiAAmmwoOf8i1gjrBZ5mDrWIbBKtHklxWcpxj1lFqsjPmA9cbqUU+3
         cG81FTqFdW3rnUfP2cFmXT89VuR5EFnJ8yRk2Q3cHm4n3oSclb/304to/iTvzD5ms05E
         jC4w==
X-Gm-Message-State: AOAM533zCmD+eJH6vrthnnup1ZC+kqrimjY29X94O2PDKOUIYycURKtn
        JN2vrdWN813xAarzQnHAIg8/Qa0nrcEqcPTI
X-Google-Smtp-Source: ABdhPJwTQXqP+ef2wcYfsK5XNn9sNN4yrnRq8dix/G15JL1sQNegt/2uoH3Rc5hIXLQmoaeQ0RMR8g==
X-Received: by 2002:a17:90b:1bc2:b0:1c9:9cd1:a4fe with SMTP id oa2-20020a17090b1bc200b001c99cd1a4femr1111053pjb.136.1649710136520;
        Mon, 11 Apr 2022 13:48:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c11-20020a056a000acb00b004f35ee129bbsm39501236pfl.140.2022.04.11.13.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 13:48:56 -0700 (PDT)
Message-ID: <62549438.1c69fb81.f4fe3.5ba2@mx.google.com>
Date:   Mon, 11 Apr 2022 13:48:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.237
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 215 runs, 4 regressions (v4.19.237)
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

stable-rc/linux-4.19.y baseline: 215 runs, 4 regressions (v4.19.237)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
da850-lcdk           | arm   | lab-baylibre  | gcc-10   | davinci_all_defco=
nfig      | 2          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.237/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.237
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6e4a1818efa77621b27b5055cea85873b5e1f83 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
da850-lcdk           | arm   | lab-baylibre  | gcc-10   | davinci_all_defco=
nfig      | 2          =


  Details:     https://kernelci.org/test/plan/id/625460152a5cd68de4ae0691

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/625460152a5cd68=
de4ae0698
        new failure (last pass: v4.19.237-257-g4e89415127311)
        4 lines

    2022-04-11T17:06:22.721414  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-04-11T17:06:22.721681  kern  :emerg : flags: 0x0()
    2022-04-11T17:06:22.721844  kern  :emerg : page:c6f59000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-04-11T17:06:22.721962  kern  :emerg : flags: 0x0()
    2022-04-11T17:06:22.791216  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2022-04-11T17:06:22.791438  + set +x
    2022-04-11T17:06:22.791575  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 1803989_1.5.=
2.4.1>   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/625460152a5cd68=
de4ae0699
        new failure (last pass: v4.19.237-257-g4e89415127311)
        6 lines

    2022-04-11T17:06:22.545874  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2022-04-11T17:06:22.546162  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-04-11T17:06:22.546352  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-04-11T17:06:22.546479  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3800
    2022-04-11T17:06:22.546594  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-04-11T17:06:22.546740  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-04-11T17:06:22.584485  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D6>   =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/62546481ca6e0ff3c0ae06bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62546481ca6e0ff3c0ae0=
6be
        new failure (last pass: v4.19.234-30-g4401d649cac2) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625461e29d0a100e15ae06ae

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625461e29d0a100e15ae06d0
        failing since 36 days (last pass: v4.19.232, first fail: v4.19.232-=
45-g5da8d73687e7)

    2022-04-11T17:13:57.233610  /lava-6064210/1/../bin/lava-test-case
    2022-04-11T17:13:57.241352  <8>[   36.741625] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
