Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B1D5B7C68
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 22:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiIMU6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 16:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiIMU5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 16:57:50 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DA55FF47
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 13:57:48 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q9so3320507pgq.8
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 13:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=ohRVUgFkCvQ0TlDeZcg7reB0V/RqwDLt+UcWGzNR0Rw=;
        b=LFCmkGwoNzg/hBHg82kMgVmnL7EKovqp8XKN2H/u6grz0yvx/5k2jzkUPVFbqFxe4M
         bGGQH7gkwthjvOFyfRYdTjlSad2B6EF2tu8HRTzl06ed99nIscBCld3cajeyL/FXdyPr
         vZLjAu6WwzxWRYL3Pn+PJVfN7HRQrloVJ10ZhRjxv3Tre0bVpu17aGqXbQ2s4LPPoLkI
         ldWscIyHijPOs14EbmSFwBRPzSVmHJ0E+8iTtdp+DAqtvSXV7YL4KnK/DZ9eJQ3ux+3F
         zWuIUil/LCIhTCgrQWOVSzylg/E86JEWlC4DK75MYaRfA9kTjswhs2PbJtygiQYbF7n1
         Y4tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=ohRVUgFkCvQ0TlDeZcg7reB0V/RqwDLt+UcWGzNR0Rw=;
        b=dTNL/hFaoscd6/F27FxqDLqn/S7lJAJk0MMCr4pw3Ji/S+kVBO0GH3R686OU84If/P
         /qhSMYKtGYc8PFJb64CxXk6dd0jKMHFn26yfHDNOTRV/4JiwNvxpPyJpJ4JAxwk037kP
         mXB7RjcgAdeuobL7JaG76INmxaSgnen6fbQrlGDVYN7YUtqdYL4SdbcbpXxbrx92l+Zv
         ivzhMGa7dggkdr9FCWykGmCPgXtpS1oQNRnW89PAAtMc2g2AJ9BEeVPhQOuTN0Cgvdhu
         PgfONUHGvtVF6Yed/SMO/XFm5uyxmevq+ZN3DbsYPFzu7DDqJnABVKtUEcFxuxAd6met
         zUeA==
X-Gm-Message-State: ACgBeo3BMD28Zi1A56g4dWHIEwmIK+xz3vRVMfZg9yfV+UkpsIncY1T8
        Rc8/WRqGRyTnQ7dwhbIRi3XBOZ+BH2RQyMIafBo=
X-Google-Smtp-Source: AA6agR70c7neOjzvOMorgphyS8dXfCc7i8N8PQj8UZddZAhYBy/0C45mV/iX67yb6xQa5Si+E6eK0Q==
X-Received: by 2002:a63:9042:0:b0:438:8ef2:2476 with SMTP id a63-20020a639042000000b004388ef22476mr19409598pge.55.1663102667325;
        Tue, 13 Sep 2022 13:57:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bd7-20020a656e07000000b0041c35462316sm8023778pgb.26.2022.09.13.13.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 13:57:46 -0700 (PDT)
Message-ID: <6320eeca.650a0220.e32f8.d083@mx.google.com>
Date:   Tue, 13 Sep 2022 13:57:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.8-193-g5cd198d0e2b18
Subject: stable-rc/linux-5.19.y baseline: 175 runs,
 4 regressions (v5.19.8-193-g5cd198d0e2b18)
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

stable-rc/linux-5.19.y baseline: 175 runs, 4 regressions (v5.19.8-193-g5cd1=
98d0e2b18)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

imx7d-sdb            | arm   | lab-nxp       | gcc-10   | imx_v6_v7_defconf=
ig        | 1          =

imx8mn-ddr4-evk      | arm64 | lab-nxp       | gcc-10   | defconfig        =
          | 1          =

mt8173-elm-hana      | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.19.y/ker=
nel/v5.19.8-193-g5cd198d0e2b18/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.19.y
  Describe: v5.19.8-193-g5cd198d0e2b18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5cd198d0e2b1825ce4ad599bfd3c2e839a5b8a4f =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/6320b9c58ad14095d8355657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.8=
-193-g5cd198d0e2b18/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unl=
eashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.8=
-193-g5cd198d0e2b18/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unl=
eashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320b9c58ad14095d8355=
658
        failing since 0 day (last pass: v5.19.8, first fail: v5.19.8-193-g3=
acd07a8c4dd8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
imx7d-sdb            | arm   | lab-nxp       | gcc-10   | imx_v6_v7_defconf=
ig        | 1          =


  Details:     https://kernelci.org/test/plan/id/6320bd65ef484df60e35565c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.8=
-193-g5cd198d0e2b18/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-s=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.8=
-193-g5cd198d0e2b18/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-s=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320bd65ef484df60e355=
65d
        failing since 0 day (last pass: v5.19.8, first fail: v5.19.8-193-g3=
acd07a8c4dd8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
imx8mn-ddr4-evk      | arm64 | lab-nxp       | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/6320b9e0f3f6af274f355668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.8=
-193-g5cd198d0e2b18/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.8=
-193-g5cd198d0e2b18/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320b9e0f3f6af274f355=
669
        new failure (last pass: v5.19.8-193-g3acd07a8c4dd8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
mt8173-elm-hana      | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6320be30dfeed2f83335568d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.8=
-193-g5cd198d0e2b18/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-mt8173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.8=
-193-g5cd198d0e2b18/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-mt8173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320be30dfeed2f833355=
68e
        new failure (last pass: v5.19.8-193-g3acd07a8c4dd8) =

 =20
