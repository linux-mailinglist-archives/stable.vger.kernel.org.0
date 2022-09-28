Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0747F5EE25E
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 18:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbiI1Q4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 12:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234067AbiI1Q4H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 12:56:07 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B420167FA
        for <stable@vger.kernel.org>; Wed, 28 Sep 2022 09:56:05 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id v186so13023456pfv.11
        for <stable@vger.kernel.org>; Wed, 28 Sep 2022 09:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=DdptRQoqyUCjL/0qFhY0YjKSj/edMN2himLXyREpG1Y=;
        b=5dU+z/+bAOZI8XPC6rsiALys2xe32HCRLH5u/7+pWjWdpbuqB9+6WZld1/QgE7fp84
         NLxF0lcEgDaXTM0YYYcQq9y9tWtVWm28cpMK+4j+O7hRAl7un5WGCE/vGKR3BU8fkw/R
         UF9q+BkMTaMEqj1ZYhUcdIZI1TAvZBIiQwobuaUXdr/8gpjeosGMOO9E7Ua9pmsu6LJD
         10y+6eDQZn2ht7i+Km2QyQ22ZKFMwzR0DgPC47TRDmgwgCWDi1QIquOpDoqpvn/xlLKj
         a6d2LwibxsyPRucgBtuUwnFiYWK6n3sJrw6ChOQdUc99TkxWlNkxAB/4WTo0OKz2RWiK
         9VjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=DdptRQoqyUCjL/0qFhY0YjKSj/edMN2himLXyREpG1Y=;
        b=6RvvZa/zGT0/Q4VcyRN2x2YSjs4CXxCSnGqEZYZ6U/eTFP7iUwFQi5MUd7TS4SdRaU
         LN3Fp0fjQmlsXX08v/CRi2UrAwjcTlUhgXarRFrl1vM5rzhEFTevTe3uniAGv0bHFV1r
         qEYHcOiw/cHhMjRu1QFfWpdBDFExQmh1lrk7AAH2xntVB8/hfeJDUyllNID1pxozDgz5
         5NvrZZnlDxwZTgFjj6qcy0ZALW5/UtGIexFZfXTSaszEJuGgSdkgISS7FqvktFIaYI1f
         aop5aGTJAfuO9UdCV0T+9xGrwG6VTs95dm5erPinoTPGi2cwKEMkMSPCKMxtpPlUvVn4
         5Yog==
X-Gm-Message-State: ACrzQf0+jGyDaKk+muUxuQPj5hqVNNMGHrRF3M4LtWTMAGdbDlRtogE5
        AHbaUNMgj1FO/9BvmhoZYKErcGATnMH4vHnH
X-Google-Smtp-Source: AMsMyM5oVfszjIPtVDt+iOxIssiTMu9wnwC8woVAevpxziLYDOFNfMRQ6lDDBX6T00lYOFZXYuRfhw==
X-Received: by 2002:a63:8143:0:b0:43d:c6cc:ef48 with SMTP id t64-20020a638143000000b0043dc6ccef48mr8403031pgd.468.1664384164449;
        Wed, 28 Sep 2022 09:56:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mq3-20020a17090b380300b001fdbb2e38acsm1861921pjb.5.2022.09.28.09.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 09:56:03 -0700 (PDT)
Message-ID: <63347ca3.170a0220.51a6d.2ead@mx.google.com>
Date:   Wed, 28 Sep 2022 09:56:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.12
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.19.y baseline: 138 runs, 3 regressions (v5.19.12)
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

stable/linux-5.19.y baseline: 138 runs, 3 regressions (v5.19.12)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.19.y/kernel=
/v5.19.12/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.19.y
  Describe: v5.19.12
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      58df6af8cea3c5377c0220d9fb47cbf85a216f54 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63344bb3fe4d958c75ec4ec2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.12/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.12/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63344bb3fe4d958c75ec4=
ec3
        new failure (last pass: v5.19.10) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63344f8d1db42276deec4ece

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.12/a=
rm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.12/a=
rm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63344f8d1db42276deec4=
ecf
        new failure (last pass: v5.19.11) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63344770e69f710067ec4fce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.12/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-sc7180-trogdo=
r-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.12/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-sc7180-trogdo=
r-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63344770e69f710067ec4=
fcf
        failing since 7 days (last pass: v5.19.9, first fail: v5.19.10) =

 =20
