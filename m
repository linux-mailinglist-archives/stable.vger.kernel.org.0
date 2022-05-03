Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6671518C9D
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 20:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235501AbiECSzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 14:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234488AbiECSzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 14:55:06 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F013B01E
        for <stable@vger.kernel.org>; Tue,  3 May 2022 11:51:32 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id fv2so16111455pjb.4
        for <stable@vger.kernel.org>; Tue, 03 May 2022 11:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VxjEyW43LtKyVdjWubu556ERRXzUTnucdzmYQwBMx6s=;
        b=lvTOWhJIPHxiqZvZ9KSajY4w8OUzwTyIc7Ejh5IWJ41ie5UyP2gWrZjWva54TX2lWs
         EV/+tUDhNF6rcIADPOtUHBeSD60+1OhUH+JtlCldomhIGY4BwNdJC0l+Rf8tLGWj5Kbd
         tpTJ37ftvIy5BXHSWc3YkEhxqrR0a4S56f6VhwIyXqOVxqzuw+a/9q2TSCQtCSA3Bw6b
         SL4C1NHm9p5Hn5A0wSPbK19+2GAkmokEAjUq8YgeaQcybFHI7NSuhxa9BwBv8O48DilM
         2GrjZun8rYzESZ9uEM09xu+uvfdrmhSAXTsCWszEKg2wZsaTxztts3wlq9fKv57U84IF
         ywzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VxjEyW43LtKyVdjWubu556ERRXzUTnucdzmYQwBMx6s=;
        b=k5LchB0cxlOt8L8+yuPCNZBUdwJujYQ2FQhHo5IKyPCkJ/kFnRzsHVkGLOnyC+X4SJ
         7ukZki77LHgJ3j8k/ZPJBnweqciAeIXONDq4iT2TmbsQlnf/o3Oi/BowFFkMTnDLRUEE
         I0E8gPC5UV3zQz0tJBWd6bfiPU086Hha7HG7jYBA63+VCLpfunCGoP14mPFXWB1erFJv
         iZtwyJlaMF+Iu6bgZI4QnVXiARFG3CvLh68WiUtex1Z6U9pmyD+zjuRJexY2wUgtE23V
         0wjeyaFHyGBRrCUMwxTDN19vNd72bcDkfPUa7L4D0PFb8FKyRgHMmcvQqF4dVip2i0Sk
         mB8w==
X-Gm-Message-State: AOAM530D8Z4oDG2i5AzBTUVuAk5ReRv9S4jHFueYGErAiZUxI/Fpa8qt
        tgGuTVFuD7rEpAb110x1kWJNzfsBI/LBzDcKC3M=
X-Google-Smtp-Source: ABdhPJyufhsqxWBY3PYpdRiHzVqx4rTbTI1213DSjzRE0Ln64CURlJ1Ua/HYBFsy9WaLyxD3y/dCZQ==
X-Received: by 2002:a17:90b:352:b0:1c6:77e:a4f7 with SMTP id fh18-20020a17090b035200b001c6077ea4f7mr6190037pjb.77.1651603891995;
        Tue, 03 May 2022 11:51:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i10-20020a170902c94a00b0015e8d4eb278sm298047pla.194.2022.05.03.11.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 11:51:31 -0700 (PDT)
Message-ID: <627179b3.1c69fb81.8e758.0dbb@mx.google.com>
Date:   Tue, 03 May 2022 11:51:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.37-172-g0797d89caf40
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 121 runs,
 2 regressions (v5.15.37-172-g0797d89caf40)
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

stable-rc/queue/5.15 baseline: 121 runs, 2 regressions (v5.15.37-172-g0797d=
89caf40)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.37-172-g0797d89caf40/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.37-172-g0797d89caf40
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0797d89caf40fcfa1f7b4bbc496dbf2324a97a57 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6271446e5ff9976ae2dc7b34

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
172-g0797d89caf40/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
172-g0797d89caf40/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6271446e5ff9976ae2dc7=
b35
        failing since 33 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6271477cf69712fc91dc7bb4

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
172-g0797d89caf40/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
172-g0797d89caf40/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6271477cf69712fc91dc7bda
        failing since 56 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-05-03T15:16:54.551516  /lava-6251192/1/../bin/lava-test-case   =

 =20
