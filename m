Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C79C597671
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 21:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiHQT3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 15:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238248AbiHQT3a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 15:29:30 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69602F3B2
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 12:29:28 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so2869130pjf.2
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 12:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=62qW30VH1v+FP6S978UwW60pg548rhR6y3Ort76saZI=;
        b=brmPfNhxL1a6E/jFcW0K51RIYz1DtkBvASf0G+dPJY0ygG7/5cQyMrSPr01hkcUlXt
         U7pGbP55GAnUyyzKRm73BbZcc8V/vQVnbV4PaoZiUqAst2Q7/a6fCAKwA5h3zCGejoVz
         2f40LhklXWKcCwBGCP7CWNVR0FhZ/LVPIscKi5+d7J/dWQ2C631GINGdh1oJlvH20z1P
         f/Vn3Hi4LFAVs5i2jI3tE00Q+MBtrGzc8T0wCLEMP0xvG4gbzuUWr89UUlEV1NmJrQIT
         FGDoltLUOkNozKwyIto+bpzE3k+BDaOiMoNOPvMZcbTq0HA6aKQ+PsXC93ErMBiEapOr
         VHwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=62qW30VH1v+FP6S978UwW60pg548rhR6y3Ort76saZI=;
        b=d5AdQcqrPG7MaEVBmDb88o94+gpau098O6rPS5memVRnoz31FWCNdaTeC0DagHfnN6
         bGFjPx2oOcx87dWyts2EP7KmHT2asMws/PWBq79El6zpat1GVYFor0JY8/BNdYrttKfn
         TdAfETYtjehiJrFlwsh8UoZyhIEsxlLQxcRFwZdkDIPzMWozg3nzXDvEgvRmNXBPJDcU
         duZyxKuByw1cQ8nLyTbOS9hBcPIM3fZCVPfG+6XRFrN5W/8yLP51OU2DIdN5wcDFFBNa
         K933cpXwjQ9ZuY6PrEzkwiJYjNYrycTE4WN4HQVVphYhxat3NHOXimEj4RCS4PXFYKEW
         5kjA==
X-Gm-Message-State: ACgBeo2WwCZ+BiG7y7+CCfVUhv7oEoC7I2eQG80Y9xQwCFOjAOgeC7u0
        WcHImzrpFy4FhiGgtKB6XBAFIKXK8u/Bmzs8
X-Google-Smtp-Source: AA6agR4JlvCpK4XetWWtIR8Q106fw5wh/E30VIAvj289tPGCoPVlrJ/s9NN8qJldmjRlq2Z+DanglQ==
X-Received: by 2002:a17:90b:198d:b0:1f3:f72:cfdc with SMTP id mv13-20020a17090b198d00b001f30f72cfdcmr5215722pjb.237.1660764568247;
        Wed, 17 Aug 2022 12:29:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f20-20020a170902f39400b001729baf331esm262665ple.271.2022.08.17.12.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 12:29:27 -0700 (PDT)
Message-ID: <62fd4197.170a0220.40a2a.0b0b@mx.google.com>
Date:   Wed, 17 Aug 2022 12:29:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.2
Subject: stable/linux-5.19.y baseline: 103 runs, 2 regressions (v5.19.2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.19.y baseline: 103 runs, 2 regressions (v5.19.2)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =

qemu_mips-malta    | mips | lab-collabora   | gcc-10   | malta_defconfig   =
  | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.19.y/kernel=
/v5.19.2/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.19.y
  Describe: v5.19.2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d49914ee4ec93d58d90a12275a814415c189059c =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd0b98d6d4085ed2355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.2/ar=
m/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.2/ar=
m/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd0b98d6d4085ed2355=
645
        new failure (last pass: v5.19.1) =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
qemu_mips-malta    | mips | lab-collabora   | gcc-10   | malta_defconfig   =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd0bf1e7037194de355654

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.2/mi=
ps/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.2/mi=
ps/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/62fd0bf1e703719=
4de35565c
        new failure (last pass: v5.19.1)
        1 lines

    2022-08-17T15:40:13.665347  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 00e9ee20, epc =3D=3D 80201978, ra =3D=
=3D 80201968
    2022-08-17T15:40:13.698575  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =20
