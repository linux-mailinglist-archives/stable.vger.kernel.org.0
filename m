Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086795F59F0
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 20:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiJESfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 14:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiJESfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 14:35:33 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7E37D79A
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 11:35:32 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id i6so16554417pfb.2
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 11:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=kwMWIbOUYkaB1Ld81vwAViYd9boVb0ntO7Y81DwWeBQ=;
        b=A8LgklirG4e3/d88H2IbvFapw7WiyFR6FL/MSE1jn/6aGc90CO48wCcgBybgr1Ycql
         XWkI8hRDHHgj/oXScmZST4Nq28S8GDF4FeGwI/BecZPz1f7LoHRmFm52wZkTH15YC9mf
         Ick5ZNRIYq4zlr69uNHg+bQIm3J5c4DJ1xwP4JYQddd2hOhOekinpPHTakBz3lcZOdCT
         8xiW2bM2AFAAlMAvNNVV5yShwhZFxq3yQlbQ61D+QjWzoRVZDkJZMXu9VSYZrkzovQ0Q
         cIl+9Rwa7OIcNU3RmhPiOZQQvbuCNJI201PPBXTbt9mmwuRizHHAPqPM9IwySCzCGxYu
         9zYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=kwMWIbOUYkaB1Ld81vwAViYd9boVb0ntO7Y81DwWeBQ=;
        b=asltncd1Vqm9XF6SnhbGnf6UhsBO8eLfbKyjVQC6SFb2buwL2NUqeOJYhWLF5rElCz
         c4dMtlbv1YFg8fOyIu/bfbyutMxf6bbL5ng2grSj7WnpAJf9CbkSMLLFMCot/q6ODtn7
         m3DA1yLoGTAZ2jCgsvECCqF6cvesDbfQOOKFY6kUyu3nE6CJ/fh+GxfQjzLCogndCLwm
         EV6cRwKEWKxC5b472To8IsaGiTNqpgnri6rZBBtP93AmIzvW7GFYOxc2CBodgT95PkDn
         1Br2VQBjaS7G7A+WY02hts8sZwuMP/a1lbofUjVWD+5+0MMADHxhdrAA2kU7vUPYgojC
         c3bw==
X-Gm-Message-State: ACrzQf38oGVj6suG1jjEeHICf+hNHt/FvWZ80pdyopmRKZmgYHgnDTzT
        GTtQTHWJenoV39lstBLzDoexn3M9awD2oWwlDDs=
X-Google-Smtp-Source: AMsMyM7ex9OqE3p/a8dbvhByqpOe3GIfXGsEI94Bfnmb5ZhlQc2BH21x2Wm2NeyYSMNlBOQ3Z3aDGA==
X-Received: by 2002:a63:d4f:0:b0:457:2427:eac with SMTP id 15-20020a630d4f000000b0045724270eacmr977243pgn.251.1664994931906;
        Wed, 05 Oct 2022 11:35:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f4-20020a170902ce8400b00178b77b7e71sm10906346plg.188.2022.10.05.11.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 11:35:31 -0700 (PDT)
Message-ID: <633dce73.170a0220.3288b.2d97@mx.google.com>
Date:   Wed, 05 Oct 2022 11:35:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.19.12-114-g34c12937d8e1d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.19 baseline: 138 runs,
 5 regressions (v5.19.12-114-g34c12937d8e1d)
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

stable-rc/queue/5.19 baseline: 138 runs, 5 regressions (v5.19.12-114-g34c12=
937d8e1d)

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

imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig         | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

sun50i-a64-bananapi-m64      | arm64 | lab-clabbe    | gcc-10   | defconfig=
                  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.12-114-g34c12937d8e1d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.12-114-g34c12937d8e1d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      34c12937d8e1dc12778e306a873845a3a688f715 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/633d9c92f12a4a0c5dcab5ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
114-g34c12937d8e1d/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
114-g34c12937d8e1d/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d9c92f12a4a0c5dcab=
5ed
        failing since 2 days (last pass: v5.19.11-208-g633f59cac516, first =
fail: v5.19.12-101-g42662133e9bdb) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/633d9dfaf4c7b44b18cab5fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
114-g34c12937d8e1d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
114-g34c12937d8e1d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d9dfaf4c7b44b18cab=
5ff
        failing since 9 days (last pass: v5.19.11-158-gc8a84e45064d0, first=
 fail: v5.19.11-186-ge96864168d41) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/633d9c92a25e68ed77cab5f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
114-g34c12937d8e1d/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
114-g34c12937d8e1d/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d9c92a25e68ed77cab=
5f5
        failing since 8 days (last pass: v5.19.11-158-gc8a84e45064d0, first=
 fail: v5.19.11-206-g444111497b13) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633d99c7c8989c2bb8cab601

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
114-g34c12937d8e1d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
114-g34c12937d8e1d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d99c7c8989c2bb8cab=
602
        failing since 8 days (last pass: v5.19.11-206-g444111497b13, first =
fail: v5.19.11-207-g5704e94c78ce) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun50i-a64-bananapi-m64      | arm64 | lab-clabbe    | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/633d9ed1681156003ecab5fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
114-g34c12937d8e1d/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
114-g34c12937d8e1d/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d9ed1681156003ecab=
5ff
        failing since 2 days (last pass: v5.19.11-208-ge0d15091986ad, first=
 fail: v5.19.12-101-g42662133e9bdb) =

 =20
