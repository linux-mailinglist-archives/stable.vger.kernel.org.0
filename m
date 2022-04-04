Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD294F1AEC
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379313AbiDDVTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380051AbiDDSrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 14:47:00 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EA42F38D
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 11:45:03 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id q19so9070009pgm.6
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 11:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mqCPzhTuyf3th0kbYJRfqx56+nntg52rU+Jf0qfiBFk=;
        b=Neg/v929kJrZz3CH/eTZ1BIHKG54r+FYPDDIeemsiNZRl2s/Mv30xacaWmaG19wayu
         0tTxJazPxydb7GRFmsRA7hvNtHALdGHohvp0CunvliBqO4+U3nYzGZfauxVpwvzds+/y
         99rylLMY5HWgAcjNjHvBu69/tuE2Cf9vCW+WyOckyHHx7zFEki+/0OeIz9hkrHRpHKk+
         Yvd1mjRNWpJsUo85Xlykys4m2tK/Av45adveiFfijVqESsIuZR7TXHITQyxSOnKFNwgf
         Mkv+tb0In7yVRMHnNyLgB8qzcyhtb7eqnpjotTaMcmP29gcuyr4L4VNZGMC7sqOrZUG+
         51Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mqCPzhTuyf3th0kbYJRfqx56+nntg52rU+Jf0qfiBFk=;
        b=GexefeXZsxb8SWKiZG9E7AyeazYXnp5AmqvFMP41CTgLz0Ed8gFVuzWDx9KUTE1XPc
         qwduPE4cvCRfCFE4/KR5D//oO7N6pUqb+1RoIp2WVLEgxKa77KZ8vfmNKB9O4wIMv8B3
         Un4xbqiIeJmG8VVDMfh4VvPiasYF0u87JrThOMqLhrAKkUzz0gQZY5dJPtcfuqXFGh2m
         hTxuc7tHXiioPwLQ4NWPqSdSTHuUc2aa1ASkzmaf1ACUIFTt4Da2gbSxX4h4x0e01nCL
         EBScrHh6AtVS6U4G/VaMpORGhh3SyfZ4JmMhuYx1+NT/qZXxycpGxBbtPHIgRh2FJOs2
         QX6g==
X-Gm-Message-State: AOAM5330Z8awK8UHuhw/hN859/46CQ82odWkUnW0DVszS6xwL0FGoUp9
        sbCUmsbA6W93ugPLSRFDj5Ra5e8EfGhdyVFR07M=
X-Google-Smtp-Source: ABdhPJzsz4LiPuNiVd3kaOp/hbDtU/vcEmuNVxal4wv1csnRaqdd7SRGUdGjYZNB4ZYg7sd3ZcD9cA==
X-Received: by 2002:a05:6a00:1695:b0:4f7:decc:506b with SMTP id k21-20020a056a00169500b004f7decc506bmr922984pfc.7.1649097902308;
        Mon, 04 Apr 2022 11:45:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j13-20020a17090a840d00b001ca89db9e6esm187544pjn.19.2022.04.04.11.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 11:45:01 -0700 (PDT)
Message-ID: <624b3cad.1c69fb81.1c78.0e95@mx.google.com>
Date:   Mon, 04 Apr 2022 11:45:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.237-257-g4e89415127311
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 50 runs,
 2 regressions (v4.19.237-257-g4e89415127311)
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

stable-rc/linux-4.19.y baseline: 50 runs, 2 regressions (v4.19.237-257-g4e8=
9415127311)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =

tegra124-nyan-big | arm   | lab-collabora | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.237-257-g4e89415127311/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.237-257-g4e89415127311
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4e89415127311b78dfd058c48dd87e92ab4e2c0c =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624b094fbda8e9e3a3ae0685

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-257-g4e89415127311/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-257-g4e89415127311/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624b094fbda8e9e3a3ae06a7
        failing since 29 days (last pass: v4.19.232, first fail: v4.19.232-=
45-g5da8d73687e7)

    2022-04-04T15:05:38.638197  /lava-6017171/1/../bin/lava-test-case   =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
tegra124-nyan-big | arm   | lab-collabora | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/624b2841009df08b81ae06ce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-257-g4e89415127311/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-257-g4e89415127311/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624b2841009df08b81ae0=
6cf
        new failure (last pass: v4.19.237-13-g5afcc2452dc0) =

 =20
