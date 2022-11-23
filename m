Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3D66361E3
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 15:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236185AbiKWOcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 09:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238859AbiKWObz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 09:31:55 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B331719C0F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 06:31:18 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id v3so16909690pgh.4
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 06:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=sbC1GoOjrWlIkABwvg4cHNjdrbdOEEGHXCfTBJkC79Q=;
        b=KeEcOKmHk+HSmG5y5n/4c8QRn0bQHcsfZPEzPQrN+W580bgM5WNixPAPF3E4oWJtB2
         JsVMOt8jqFO16moKNyYYXtZra8wuMDBkwNDyA9vrRixsviRHTwwEA0FwqjuQY7BEgbSl
         qu5TmCHi+BQ9jIKiPx0Dmhyfqq0eZ1olMA05Fc5DaKBdBEfB5jvYfM6qV6re6tSryhXI
         8N4Pe2eLG9I2mmSeYjpf981PpbDYEN6GoQc7QudAs5mkFeam5w0i3I+Y3Cf3E3yK3no3
         cWJWMGoR0mn4GdBnCFka3z8XftkVBZ1AcOh1f4srF3AmaRw/6nTnsZt4dXhj/KW8C1rJ
         3Qqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sbC1GoOjrWlIkABwvg4cHNjdrbdOEEGHXCfTBJkC79Q=;
        b=afkOh3ZIdOphvAdjvgI/mS+Icc40bXaYys1SUJSrbhfBC9uCgiIpactbRnS2l/JguY
         Cc5lh0JHVuIul+I6+sgFDG4AnNbOD5i2Sfv5pu77xMfIkLi4BnpeKJjWV6yvKWr81Eq4
         l4Izg65SNH0sWg0Qrq1Svg4t6bQO35bAeadog1RTxCNDy8jVhJ+hsdZ3y5g/vT6Mfqa6
         OTcgiJvDSAkv35s3fSpUbgF0zgfgjNe6Yt1C49cTzdVMa91XutkIVR6UG1TwwJTIDzat
         girPVQ6UJnuiEdJzD2pafKTHUjFq2zcMrF3b4Fkp0UudCPDXW6Hc+FOszeXugL9JN56v
         q61A==
X-Gm-Message-State: ANoB5plVnOhq4E5kSoTYZCkkzLB9s7DsGyWYGg6ipqM95Uvav0Dq5Qkn
        RmoxYQgv1gu6yxnaMz1yk8CIFZFsGcc9rBry
X-Google-Smtp-Source: AA0mqf6KxgAyNO04g/FgaNUHN9se4d+6k4dDkNcbfleIPKoxQalcTBu8K4G+onDpjjPUSv34dQ+WDA==
X-Received: by 2002:a62:1582:0:b0:563:f32:2c9d with SMTP id 124-20020a621582000000b005630f322c9dmr8929532pfv.32.1669213877523;
        Wed, 23 Nov 2022 06:31:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g4-20020aa796a4000000b00573a1f0589bsm6805153pfk.186.2022.11.23.06.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 06:31:16 -0800 (PST)
Message-ID: <637e2eb4.a70a0220.7b852.b25b@mx.google.com>
Date:   Wed, 23 Nov 2022 06:31:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.155-150-g38866e257e18
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 133 runs,
 1 regressions (v5.10.155-150-g38866e257e18)
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

stable-rc/linux-5.10.y baseline: 133 runs, 1 regressions (v5.10.155-150-g38=
866e257e18)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.155-150-g38866e257e18/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.155-150-g38866e257e18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      38866e257e18dbc209f4c355fe57123b0c2e0e4a =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/637df9ab16ad2823a42abd11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
55-150-g38866e257e18/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
55-150-g38866e257e18/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637df9ab16ad2823a42ab=
d12
        failing since 8 days (last pass: v5.10.154, first fail: v5.10.154-9=
6-gd59f46a55fcd) =

 =20
