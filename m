Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4CA4F3D98
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbiDEOpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 10:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355029AbiDEOmM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 10:42:12 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A942911150
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 06:19:03 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso2512505pju.1
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 06:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Qw8CFqhAXIWVIh4SmlHGI51XmrKMNsXD3MWZLHAiG+M=;
        b=yXQ6P2Wl4ldhw2wuCF7EP2Sp6RX/w3IUVeWic0Nr/vAsDWKy1pu5Rz1sEDdVrZ3OHf
         3koQZFwwU75lAFpyavmXbMqGRgMeaZ1JO4x/7wJMRbmoiaiUr7FL41xt9AAua2CNjH5M
         LcHHFuKCzPq9niC/ixqtxKog49tPoRfMBRaeT0zDDoAZR1915rK6KhdG3I28n2xlvMPd
         xwA3LMdyGGl1mrkLptMnrYejHAi1nJj+JT/ryH7gqpXQbm0XymNFg1XrktVbY3ILiT/m
         HqIVcz1mCr+XAeMgZ2d4GNp6X9UZo87uxCMF2/4kW+8hXjXLI6o+nsRUa9a95NU2Ukup
         AC6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Qw8CFqhAXIWVIh4SmlHGI51XmrKMNsXD3MWZLHAiG+M=;
        b=FC/iF7zopuhVGaxRRkcerrXDsZY5HYjxcyg9yY6fP/seAQgMbYmp3QK1abz853NOBT
         U6/5zuXWBIU6nnTkxI7sjfKAwtJnRusHMllYO+iZ+g9iv8X42RPZG+57PVrmXvOrXHY8
         UzBTnLDm9Loz/xRQ2bU7aI77Yx1MzMk+tKQqqxXEL1xOCzyy6jTxhFyTAOka6cl0i5tV
         kIPRMH/snNJONjfKFD5MXaumUjqU0YNQL62KhvQ+tr9v17tYDY9JjZOuHdlIoN/VtfBK
         Xdt/jPDQrokaXTxORIigcFbWDG7t/8ewNk4CN3Pz+SDSiv+JRiFVijGyz58HpXgypb/F
         hCTA==
X-Gm-Message-State: AOAM531V6glfOWsJWQoB/+LqjpGtz04XmY2m9Gr7rv7du1Un80iS5TTL
        KjDu0PxPfHfk/uPtG7IT/4BHFcRTA/gISjeu8cc=
X-Google-Smtp-Source: ABdhPJyU+MzHxaSXNTXaTlfSykurkD/gM4PXhJASSVC2hs0yGdlFmkZjFPaCR0X1NDYUUVLg7zqS+g==
X-Received: by 2002:a17:902:f702:b0:156:aaa8:7479 with SMTP id h2-20020a170902f70200b00156aaa87479mr3532450plo.161.1649164742756;
        Tue, 05 Apr 2022 06:19:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x18-20020a63b212000000b00398f0e07c91sm10636765pge.29.2022.04.05.06.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:19:02 -0700 (PDT)
Message-ID: <624c41c6.1c69fb81.70309.b151@mx.google.com>
Date:   Tue, 05 Apr 2022 06:19:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.188-370-gacb94d0ea63d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 47 runs,
 3 regressions (v5.4.188-370-gacb94d0ea63d)
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

stable-rc/queue/5.4 baseline: 47 runs, 3 regressions (v5.4.188-370-gacb94d0=
ea63d)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.188-370-gacb94d0ea63d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.188-370-gacb94d0ea63d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      acb94d0ea63d24093c25e3ee06374217ad85f92e =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/624c0af32a0ec45153ae069e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
70-gacb94d0ea63d/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
70-gacb94d0ea63d/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624c0af32a0ec45153ae0=
69f
        failing since 110 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/624c0adbbd07bf0ea6ae067d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
70-gacb94d0ea63d/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
70-gacb94d0ea63d/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624c0adbbd07bf0ea6ae0=
67e
        failing since 110 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624c12ec2ba39b3f10ae06de

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
70-gacb94d0ea63d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
70-gacb94d0ea63d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624c12ec2ba39b3f10ae0700
        failing since 30 days (last pass: v5.4.182-30-g45ccd59cc16f, first =
fail: v5.4.182-53-ge31c0b084082)

    2022-04-05T09:58:49.695003  <8>[   32.060551] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-05T09:58:50.705864  /lava-6025367/1/../bin/lava-test-case
    2022-04-05T09:58:50.714318  <8>[   33.080923] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
