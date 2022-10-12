Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 198DF5FC0FB
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 08:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiJLG54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 02:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiJLG5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 02:57:54 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1FF80F6B
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 23:57:53 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q9so14796057pgq.8
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 23:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=GHcd2T/FVRxSqHtln9T5JPBNyCkMdk5ZpF2XrewtG14=;
        b=NQQM5Vk0h32ZXUrygEjp1QNEWo4wYrWu34afvLpHpAbkKo/3dtYiCPEGgl8HrRNPLx
         Dwx8eqgffRfba+xbV9LMYdgfbAhsg11g09ZWSd9RX7vS5Mmz2mBYUcQuX5LA9qvy/VA6
         zCloi8LYifaSggOZktamQjrkF0ncPpXgfGQlA8CIIY1NPTCJF+qQFb6CscfkKptFeCMM
         jiVYY5FQKPIaW3EewL2BPwduphsE+lcVlwmvTpX2UFZoMM+vOFbQxt6inqMBz7G6XhZ/
         nrcSieaBBNtfUtx9t9G03aseclsQPMv5nUVkZNjEOwEC4NbBYdDsf1ro3w6uM07zLPw0
         zrKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GHcd2T/FVRxSqHtln9T5JPBNyCkMdk5ZpF2XrewtG14=;
        b=genSzQWvSE4T9KRzzsSC4AIGQ/W3n5SKcnyQLYGVR3osr/02zSPWMqomgtnacuPjE1
         o7iNjdDmAwSU3K07prRoIXfZ9MGDuV9uEG+A5F+DOlZ7rG9JyyqNHmW7L8zhYKZmNzty
         ApGyF9uELs5/qnHO/UmxOtMLOQSzDCfNziiFF81UVMrUCiVGhdzYnlr9l+Hnp+dw8ITZ
         KwIoLbflmDTKY354+hcJg8dH1bO+Bt25G4Ge0Bw6hyoLlFS5OZIYkCVMd7Cb0Qwd6eSE
         mTjqQRTxR9aQRN213zLy/n1yt4HVOFtUDc6IIY0HYBZRkzUBCG3zdT8MUO7xsb9YBaMx
         w3Qw==
X-Gm-Message-State: ACrzQf2QFdn+GxIUpOBh96KWVEOmb4SD1cBGVw6eKGU6dRoY0TS0psma
        fvY+H1JPo0CM0IhdtPZHjekhO6kq65otK7GYnCs=
X-Google-Smtp-Source: AMsMyM6eshXTvy60igsFhxLu3Cfyefu1dLGNdiuXwRBdgCCPa7IkEVPV2G9kVsv9tVVjyyAHfRSq4Q==
X-Received: by 2002:a63:e153:0:b0:439:2fa3:74d1 with SMTP id h19-20020a63e153000000b004392fa374d1mr24227380pgk.85.1665557872498;
        Tue, 11 Oct 2022 23:57:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m11-20020a1709026bcb00b001811a197797sm7662751plt.194.2022.10.11.23.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 23:57:52 -0700 (PDT)
Message-ID: <63466570.170a0220.13033.d50a@mx.google.com>
Date:   Tue, 11 Oct 2022 23:57:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.19.14-47-gc70148895c5c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.19 baseline: 166 runs,
 4 regressions (v5.19.14-47-gc70148895c5c)
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

stable-rc/queue/5.19 baseline: 166 runs, 4 regressions (v5.19.14-47-gc70148=
895c5c)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.14-47-gc70148895c5c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.14-47-gc70148895c5c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c70148895c5c90ed5e65e1fc52244527a6a49b2e =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/6346305d3c34b2f47bcab60f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
47-gc70148895c5c/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
47-gc70148895c5c/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6346305d3c34b2f47bcab=
610
        new failure (last pass: v5.19.14-47-g0f2b1a82748ec) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63463b7241c63f8682cab611

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
47-gc70148895c5c/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
47-gc70148895c5c/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63463b7241c63f8682cab=
612
        failing since 16 days (last pass: v5.19.11-158-gc8a84e45064d0, firs=
t fail: v5.19.11-186-ge96864168d41) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63463d67c4dd80e6d5cab60b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
47-gc70148895c5c/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
47-gc70148895c5c/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63463d67c4dd80e6d5cab=
60c
        failing since 15 days (last pass: v5.19.11-158-gc8a84e45064d0, firs=
t fail: v5.19.11-206-g444111497b13) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/634631ce03f128ccbfcab612

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
47-gc70148895c5c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
47-gc70148895c5c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634631ce03f128ccbfcab=
613
        new failure (last pass: v5.19.14-47-g0f2b1a82748ec) =

 =20
