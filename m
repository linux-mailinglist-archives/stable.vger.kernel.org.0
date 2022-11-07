Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271D461F776
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 16:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbiKGPUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 10:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbiKGPUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 10:20:48 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111A0289
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 07:20:48 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id r18so10712401pgr.12
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 07:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=RDhAcBcD/yhik3yehuX16GOouoMpDftAogiGu0E3uMQ=;
        b=acCGcBbUXwi4kV/3lWtOyCD0IAczZZEYUz3heEnGfh0B9JEtd4YMhmhEo7iNuh6qTK
         9mOWHfyz+18H8vBuR2yyFASkb5XrJWq/HI6IufpxQUPwEGEocUFxVjGPwDeRpdAdVx5+
         nlOW6FbUt5U9BagMd3A21qdwBY0fRGnJ9OMjUSY5J4fi6PUZE18KXSivx2AL2jiogoxG
         qkiF+rouy1bJvbxzYmLcDWj0BvB5HxBfrw6IvayB3awtmv/OttDX8BqHx3mm3scwBTGE
         ai5gLErVD98OT7Usi03AqH1shFWfd1elb+cLozj1K1fvCnoyAhDg6yHWcI2gUbZcSqzW
         wLWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RDhAcBcD/yhik3yehuX16GOouoMpDftAogiGu0E3uMQ=;
        b=3P3ObWb2QceJX2Nm/2LcEZ1DHnAvKC3KVwuuZfqZKxiLlqw43p5Kt5XnbzRwFlm+7l
         a5bRWNdX3Q8V11EGfjH9JoKFvYdF8+V1kaGeKAaGDsrjG4aEoUmZ4LU+jNPxMLf/Tkmy
         LVtiKKh6CwP+uaLy/5dFC/uRkks6gbGs4t8kZVqbHu1hzqWAxvcaMqSETyQbxr5NkotP
         at/ZMosgg4AdZW37+XMSDNGXn8uK5cfB/Ku8Hc/Oh6Rk7Hz7nShvbk/RnOggTPR4N+QQ
         EkV2rpyPsjVo0ebQU7ErHOnNPpb2TcWL72zuwdiAmW5oasUnGD4J1padgY8R810PkzXN
         6Nqw==
X-Gm-Message-State: ACrzQf1Do+9CqoM5mgKxPPsv9hFBiX21pkr79BNUc/3mHo16MWOcaRr/
        U2PJWDgTPLscIL94N9FeiYxr3f3XdON7vA==
X-Google-Smtp-Source: AMsMyM4ZQFbMwxy2bA6D24JjgmrZqYu2v7G2UESMP3p5IHxlmGgdvoztOSYoacgEM5SIMF1VRI+a1Q==
X-Received: by 2002:a05:6a00:1742:b0:56d:6b01:822f with SMTP id j2-20020a056a00174200b0056d6b01822fmr42374074pfc.8.1667834447454;
        Mon, 07 Nov 2022 07:20:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f7-20020a170902ce8700b0018691ce1696sm5165438plg.131.2022.11.07.07.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 07:20:47 -0800 (PST)
Message-ID: <6369224f.170a0220.f2e97.7b95@mx.google.com>
Date:   Mon, 07 Nov 2022 07:20:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.77-98-g28acaf0ffa33
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 91 runs,
 2 regressions (v5.15.77-98-g28acaf0ffa33)
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

stable-rc/linux-5.15.y baseline: 91 runs, 2 regressions (v5.15.77-98-g28aca=
f0ffa33)

Regressions Summary
-------------------

platform           | arch  | lab         | compiler | defconfig          | =
regressions
-------------------+-------+-------------+----------+--------------------+-=
-----------
imx7ulp-evk        | arm   | lab-nxp     | gcc-10   | multi_v7_defconfig | =
1          =

kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig          | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.77-98-g28acaf0ffa33/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.77-98-g28acaf0ffa33
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      28acaf0ffa3320ec75f882902642836326f33196 =



Test Regressions
---------------- =



platform           | arch  | lab         | compiler | defconfig          | =
regressions
-------------------+-------+-------------+----------+--------------------+-=
-----------
imx7ulp-evk        | arm   | lab-nxp     | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6368da67381a666b37e7db4f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
7-98-g28acaf0ffa33/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
7-98-g28acaf0ffa33/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6368da67381a666b37e7d=
b50
        failing since 41 days (last pass: v5.15.70, first fail: v5.15.70-14=
4-g0b09b5df445f9) =

 =



platform           | arch  | lab         | compiler | defconfig          | =
regressions
-------------------+-------+-------------+----------+--------------------+-=
-----------
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig          | =
1          =


  Details:     https://kernelci.org/test/plan/id/6368d97e313a037047e7dba4

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
7-98-g28acaf0ffa33/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
7-98-g28acaf0ffa33/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/636=
8d97e313a037047e7dbb7
        new failure (last pass: v5.15.76-127-g1abef673fdb0)

    2022-11-07T10:10:00.642850  /lava-199569/1/../bin/lava-test-case
    2022-11-07T10:10:00.643250  <8>[   14.549718] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-11-07T10:10:00.643498  /lava-199569/1/../bin/lava-test-case   =

 =20
