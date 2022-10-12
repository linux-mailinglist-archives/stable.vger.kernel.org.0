Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B70F5FC60F
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 15:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiJLNMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 09:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiJLNL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 09:11:56 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF7ECD5DC
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 06:11:40 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id r18so15457572pgr.12
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 06:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Y5O5Owxd7FS933VHaaeC70JsIqqVBvpRKUOcPn7Of24=;
        b=uOG5VGLY+LyNk0Ma/5PikE6txwpP/sr+35JFEk+qSSevpMTswlEldZkBemRV59NPHc
         EApbsYdd82I5daxO3JlPN/4uEkQNqTppToB1S1kpQr4HNC/7A6ZEXqJj0GOWBtJ582qV
         552/xmlwMdlCWCAs0gogbUI3eh5qnu2RVY+jm+7k51odl3OjVBKp9oGMXqDTPXJrPotQ
         DoyIejfS9idv0ck5mfNMTiwxvAyFKL7bvEhaMbveADdj6tnufnck9lxFz+vboqfey1b0
         Kxe5kiRkbnkxZSXrAHYScP+e1mMCU96ZUTdC2PSGRVM/0or6L4oe03ETAK6CCVtmzvY2
         3snA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y5O5Owxd7FS933VHaaeC70JsIqqVBvpRKUOcPn7Of24=;
        b=a62+n7bUqW6NuvsJHLceVPA++pn+cpwkowMZUpsYE6/ZEcgFwdavc29jQYd4ch3EXf
         M9c0K09R6rwqtB8b5xOMNb3RXDwIVDmvOxXk9V1iLEET6HAfaDGaiRFnvlDOZzGGafcn
         seuVshjMFxiF0LVElkjHAIrQ9n2E8MkKGAgZaaJWCDUQl4d6jrNqAxJNAJDR9+PKy/4u
         LK8m+qfTut5ZKhXPI+6MBVVxpMzO18D+ounoNtfccwXf3Y8u3GE0g6tRkL+k6meDeQQ7
         N2cmfXZMqYhEwMNKufOE83DGlVEWN8lG+nmkwHKHHcOf+u7l6VxPS4qdM7ABzz27gTuF
         KTgA==
X-Gm-Message-State: ACrzQf2LJvCmksmU7aFVFarkY6tE7GAtHKPCVD2xHh2yV2q9624NCw8E
        4VnRu4RNPdwxgxzpH0Xo7ozRtI2flnToMVDJW5k=
X-Google-Smtp-Source: AMsMyM5+5yTXMmMpDDpkWJkKJNesjdlpJ6cdz+lhgUoYijvCWQjCxyyF3tZBk7cQrPC6QTj/jk/9uw==
X-Received: by 2002:a63:6b09:0:b0:453:88a9:1d18 with SMTP id g9-20020a636b09000000b0045388a91d18mr25021555pgc.41.1665580298483;
        Wed, 12 Oct 2022 06:11:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z4-20020a170902ccc400b0018003571809sm10298352ple.224.2022.10.12.06.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 06:11:38 -0700 (PDT)
Message-ID: <6346bd0a.170a0220.b8f7e.2225@mx.google.com>
Date:   Wed, 12 Oct 2022 06:11:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.19.15
X-Kernelci-Report-Type: test
Subject: stable/linux-5.19.y baseline: 101 runs, 6 regressions (v5.19.15)
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

stable/linux-5.19.y baseline: 101 runs, 6 regressions (v5.19.15)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

imx7ulp-evk                  | arm    | lab-nxp       | gcc-10   | imx_v6_v=
7_defconfig          | 1          =

imx7ulp-evk                  | arm    | lab-nxp       | gcc-10   | multi_v7=
_defconfig           | 1          =

mt8173-elm-hana              | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm-vexpress-a15        | arm    | lab-collabora | gcc-10   | vexpress=
_defconfig           | 1          =

sc7180-trogdo...zor-limozeen | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.19.y/kernel=
/v5.19.15/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.19.y
  Describe: v5.19.15
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      51dd976781da8c0b47e106ed59a96d7c28972ce4 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63468a58a5e19541f6cab5fb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.15/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C4=
33TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.15/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C4=
33TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.tpm-chip-is-online: https://kernelci.org/test/case/id/6=
3468a58a5e19541f6cab600
        new failure (last pass: v5.19.14)

    2022-10-12T09:35:01.194275  /usr/bin/tpm2_getcap
    2022-10-12T09:35:01.218908  <3>[    9.481221] tpm tpm0: tpm_try_transmi=
t: send(): error -5
    2022-10-12T09:35:01.233474  ERROR:tcti:src/tss2-tcti/tcti-device.c:286:=
tcti_device_receive() Failed to read response from fd 3, got errno 5: Input=
/output error =

    2022-10-12T09:35:01.243999  ERROR:esys:src/tss2-esys/api/Esys_GetCapabi=
lity.c:307:Esys_GetCapability_Finish() Received a non-TPM Error =

    2022-10-12T09:35:01.255539  ERROR:esys:src/tss2-esys/api/Esys_GetCapabi=
lity.c:107:Esys_GetCapability() Esys Finish ErrorCode (0x000a000a) =

    2022-10-12T09:35:01.260918  ERROR: Esys_GetCapability(0xA000A) - tcti:I=
O failure
    2022-10-12T09:35:01.263699  ERROR: Unable to run tpm2_getcap
    2022-10-12T09:35:02.256909  <3>[   10.518686] tpm tpm0: tpm_try_transmi=
t: send(): error -5
    2022-10-12T09:35:02.271212  ERROR:tcti:src/tss2-tcti/tcti-device.c:286:=
tcti_device_receive() Failed to read response from fd 3, got errno 5: Input=
/output error =

    2022-10-12T09:35:02.282576  ERROR:esys:src/tss2-esys/api/Esys_GetCapabi=
lity.c:307:Esys_GetCapability_Finish() Received a non-TPM Error  =

    ... (54 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
imx7ulp-evk                  | arm    | lab-nxp       | gcc-10   | imx_v6_v=
7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63468b25c911999287cab67b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.15/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.15/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63468b25c911999287cab=
67c
        failing since 13 days (last pass: v5.19.10, first fail: v5.19.12) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
imx7ulp-evk                  | arm    | lab-nxp       | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63468df55e5f5a686fcab60e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.15/a=
rm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.15/a=
rm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63468df55e5f5a686fcab=
60f
        failing since 7 days (last pass: v5.19.10, first fail: v5.19.13) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
mt8173-elm-hana              | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/634689e9686491eafdcab5fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.15/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8173-elm-ha=
na.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.15/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8173-elm-ha=
na.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634689e9686491eafdcab=
5fd
        new failure (last pass: v5.19.14) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm-vexpress-a15        | arm    | lab-collabora | gcc-10   | vexpress=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/634688b5f43b857f73cab63f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.15/a=
rm/vexpress_defconfig/gcc-10/lab-collabora/baseline-qemu_arm-vexpress-a15.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.15/a=
rm/vexpress_defconfig/gcc-10/lab-collabora/baseline-qemu_arm-vexpress-a15.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634688b5f43b857f73cab=
640
        new failure (last pass: v5.19.12) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sc7180-trogdo...zor-limozeen | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/634689adff111e7ac6cab5ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.15/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-sc7180-trogdo=
r-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.15/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-sc7180-trogdo=
r-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634689adff111e7ac6cab=
5ed
        new failure (last pass: v5.19.14) =

 =20
