Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317435F2FFF
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 14:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbiJCMBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 08:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiJCMBM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 08:01:12 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824D71C12C
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 05:01:10 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id lx7so9733418pjb.0
        for <stable@vger.kernel.org>; Mon, 03 Oct 2022 05:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=FjcT4e926cdHCgRiMCdX6FbNuYiGNMo7Vr1jVHr4JHQ=;
        b=idKyUvK4PE2PrHxKl2rdIvEVEYk+EQT9GBDk1G9/zIHIKUOzqpLANJrCaSZwSNRrNN
         kOvJEVI/D61grwdu6flIRM2DlGkUtT6fAG9UViVhH6rh4OJhYmerr6LhmxsbD1DRzOgj
         poSz0jGwIAAG6pbrh0CCKEt8G8uZCM5pSjvlEkrUZ1KPc8UT/I3CoqV29tmys0Mp5sqv
         z+GSCNPCdQAIHy4VY8RFF714gCWCJuDrVw6WyKAiJoopBXA/Q4uGf2gO6bsr3yr/AOUZ
         pvj7ZTvlsFNF91GxdPVhYv54DvwNplJkCVOl1wdbKY3/IM3hTSDiQaIIi8yTnm5xzsWz
         eCMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=FjcT4e926cdHCgRiMCdX6FbNuYiGNMo7Vr1jVHr4JHQ=;
        b=RMX6aD3ZLfTs2HpSDT/1aRgRWc09yt3c6Bg/cr4eWtaA9iFz3Dg44RkJv4nOS4FtC/
         swsIikRSe4fHu3188kgXBYoeHX9U87JsQJ1jU7N59vMnnEeQtoJT26Zow8TGVH4EFXHQ
         3SK6uYzZhtCie8V8qQ5CelsNv2ikI0+psWiZ5PiQSt7prtq7aHO1uRacE9MGzBMQkrGT
         RyBQ2Ic99PJ19E+zwB+zNgVtngIZwGQibYVg1kIt0+GxhQb4SMRkABb0f9XplEukIRxW
         J7uZNuDKLGt74x/6m1pIrjCrmDXeFW1PBubeSczRydW5c35LM9MHlTr7kbirr6717EiH
         bn/g==
X-Gm-Message-State: ACrzQf0eWWcwrg/LFut9NSZ6pRIsLp2xNXzzN88l0uEV5flf2Ikpo5KV
        6tqudgZEfUsegwGX64WtKQdV2iuZwID+a7BT3Ts=
X-Google-Smtp-Source: AMsMyM5aT99cGPep2o/yz4PEm0wpWLu2B+IwkpfvKr7uxVg5daClchLvkEXzSy/bFDlK8YzRyK25Yg==
X-Received: by 2002:a17:903:240b:b0:178:a475:6644 with SMTP id e11-20020a170903240b00b00178a4756644mr22032034plo.96.1664798469371;
        Mon, 03 Oct 2022 05:01:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 8-20020a621908000000b0053651308a1csm7228179pfz.195.2022.10.03.05.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 05:01:08 -0700 (PDT)
Message-ID: <633acf04.620a0220.ab715.ba4c@mx.google.com>
Date:   Mon, 03 Oct 2022 05:01:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.12-101-g42662133e9bdb
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.19 baseline: 139 runs,
 5 regressions (v5.19.12-101-g42662133e9bdb)
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

stable-rc/queue/5.19 baseline: 139 runs, 5 regressions (v5.19.12-101-g42662=
133e9bdb)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

mt8173-elm-hana              | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

sun50i-a64-bananapi-m64      | arm64 | lab-clabbe    | gcc-10   | defconfig=
                  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.12-101-g42662133e9bdb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.12-101-g42662133e9bdb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      42662133e9bdb2b990a67d448467c12e0c74bfe4 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/633a9a37d7c315a21aec4ecc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
101-g42662133e9bdb/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
101-g42662133e9bdb/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633a9a37d7c315a21aec4=
ecd
        new failure (last pass: v5.19.11-208-g633f59cac516) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/633a9b43140857ad62ec4ea7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
101-g42662133e9bdb/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
101-g42662133e9bdb/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633a9b43140857ad62ec4=
ea8
        failing since 7 days (last pass: v5.19.11-158-gc8a84e45064d0, first=
 fail: v5.19.11-186-ge96864168d41) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8173-elm-hana              | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633aa101f433dda63cec4eaa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
101-g42662133e9bdb/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-mt8173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
101-g42662133e9bdb/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-mt8173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633aa101f433dda63cec4=
eab
        new failure (last pass: v5.19.11-208-g633f59cac516) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633a9e3f51cab4135bec4ed2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
101-g42662133e9bdb/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
101-g42662133e9bdb/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633a9e3f51cab4135bec4=
ed3
        failing since 5 days (last pass: v5.19.11-206-g444111497b13, first =
fail: v5.19.11-207-g5704e94c78ce) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun50i-a64-bananapi-m64      | arm64 | lab-clabbe    | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/633aa00fb48c168bc0ec4f04

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
101-g42662133e9bdb/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
101-g42662133e9bdb/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633aa00fb48c168bc0ec4=
f05
        new failure (last pass: v5.19.11-208-ge0d15091986ad) =

 =20
