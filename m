Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0545155DF3F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbiF1Bnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 21:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243298AbiF1Bni (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 21:43:38 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A871A07C
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 18:43:37 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id r66so10755220pgr.2
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 18:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TuZxW4ew82hj5U5ctfsJSeGf8iOBrPfeMdVV3kw+Wik=;
        b=O70rPlGCzbNVilzBIZiATdBYQUDfFPtSmYmdTHvieCvlZvufN2rX1sa9Jc23PYUaDd
         b/cdpVJx6GmMvCeIfEhB5yyVTKS0V8NOQKmYA2VIYIKIYJcCKPEZzVWjdN1jz+ED/M4h
         0MrBB0IygkPWOjU2qB5O75lI/LAtI8mfeERLH99M5+U1I7Wty/6HXEDi3zSeLBWpfdPR
         Q8LDFwGNyDOpa17DmmiDkJnTXugXFlgQ+R+ghqVy7m6a6K9kQJ6MJTSp0NeL8g2izE5T
         x2ANLHWY/0WxFPWoZCrTNsjplGE0pBzCqtKqLytXAmQrJjZ4PWGmEHfji/30C8XCB1lV
         NtJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TuZxW4ew82hj5U5ctfsJSeGf8iOBrPfeMdVV3kw+Wik=;
        b=e5jI4LATb2sShoqVBqhEbgEQew+AM4WrMbqy/uWs3NzhAynzd6AHoLB/lolyf/5g8Z
         L/7DlA11h863x5MUzj3LM/djnc1lpJXHJq+J8V97AEcdVEEhzwbtDsbhCbNXOmqMhJeA
         KQrqHFI8f2kNCJvvJ/p8P8eS2pgroC2XtZDGsqKyuRebv/6U2VKSAsBwxEzp0uVh8eBJ
         ly5FxdoNUwxyvZbXITnBWu6SyQmf5o4A2KArBnmtCLrs6QutYvdSj7ly5hWqMgsm6g1h
         ZSOFwP2FbUwNIbKzWKnZhOYjYV22+TZiNNCQsNN9eduymsMiPnvAfPSItDjqw0AFXSum
         B0Tw==
X-Gm-Message-State: AJIora/MeFJ2VnhCi1IqDBpmVgfc0A6jVkAfJ6HdpWlxYEwbuhAl2rME
        aNUC/LczW62/tm3e4w1nclK9bmlDIlskXDtt
X-Google-Smtp-Source: AGRyM1vrJ/bxo6kZvzgvJ4Rq0/TZEjmoCvl8cKJZiiKZj1kxzro3GFFx1ilQ9EWWfb3GiacPM/PLIw==
X-Received: by 2002:a63:a509:0:b0:40d:d4d1:845e with SMTP id n9-20020a63a509000000b0040dd4d1845emr10989643pgf.104.1656380616427;
        Mon, 27 Jun 2022 18:43:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a08c300b001ed1444df67sm9179817pjn.6.2022.06.27.18.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 18:43:35 -0700 (PDT)
Message-ID: <62ba5cc7.1c69fb81.dc824.c9ec@mx.google.com>
Date:   Mon, 27 Jun 2022 18:43:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.7-181-gcfa4d25e33d8
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 190 runs,
 3 regressions (v5.18.7-181-gcfa4d25e33d8)
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

stable-rc/queue/5.18 baseline: 190 runs, 3 regressions (v5.18.7-181-gcfa4d2=
5e33d8)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
jetson-tk1              | arm   | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

r8a77950-salvator-x     | arm64 | lab-baylibre | gcc-10   | defconfig      =
    | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.7-181-gcfa4d25e33d8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.7-181-gcfa4d25e33d8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cfa4d25e33d8fed6112b4e1abd97f7eba6654150 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
jetson-tk1              | arm   | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62ba2c196930679594a39bf1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.7-1=
81-gcfa4d25e33d8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.7-1=
81-gcfa4d25e33d8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ba2c196930679594a39=
bf2
        failing since 7 days (last pass: v5.18.5-115-g6f49e54498800, first =
fail: v5.18.5-141-gd5c7fd7ba94c0) =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
r8a77950-salvator-x     | arm64 | lab-baylibre | gcc-10   | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62ba29bcb2b7000ebda39bf7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.7-1=
81-gcfa4d25e33d8/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.7-1=
81-gcfa4d25e33d8/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ba29bcb2b7000ebda39=
bf8
        new failure (last pass: v5.18.5-141-gd34118475c49a) =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62ba29d2b2b7000ebda39c88

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.7-1=
81-gcfa4d25e33d8/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.7-1=
81-gcfa4d25e33d8/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ba29d2b2b7000ebda39=
c89
        new failure (last pass: v5.18.5-141-gd34118475c49a) =

 =20
