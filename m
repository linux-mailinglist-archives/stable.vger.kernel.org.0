Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA54C57A67C
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 20:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiGSS1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 14:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiGSS1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 14:27:32 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA36459B8
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 11:27:31 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id b10so4631318pjq.5
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 11:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KSK+KfQgDgBO81SHZHghTv8dzaQwMnGLarsaIpw4WxQ=;
        b=28rlIqVP1nUl7MOz68o5SZ+STO6IFKc+bDypEaXw8ljDxBbGHpGiFsbVzeD4X3+cWw
         0mNYlY5yb5fMVFKkBvV2n5QQn7dAE3zniihWLxgh8DkMemKIdfE8PFUjCbzzuneg+Ln4
         pKxN31DZhXItIr1VvmfqZPAtsEycT6QoDXE2yM5BGEMdmFlueQGF+ubHCBmF4lW8UeG+
         IuSf8Ia8HIuxe1FsR9XFJraminK2Nul2UY2uxLBhuDBAWkDpsdrvzdifC3OTQQqDDoK0
         S/z0SpnfphLbgMLe3BzjoMigZXdBfspLINbSZ6+Dw5lTKKPUTFbhvc0rhyAaonGmDEqM
         pdXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KSK+KfQgDgBO81SHZHghTv8dzaQwMnGLarsaIpw4WxQ=;
        b=r7BFWtPWBxY145iTZ/QGzm4aDph9H0Ebw3uymebxuGDzidPe4IMnEi87+lDR0W3+CE
         GMJ3MTr9rg+fy2jtOkLGG3iHal4dmS13ZuL/6exMlo7zBqz9e4RwekP+gFXr3N0KOjJf
         a821rjJuedjyKCrz6Rg+n9GpAdgGBHlgt1W2L8l2ivhYlN7o3ER6TXnR0N7Ai4+25eRK
         Kx9ojMEC0KzfUYYiM9WWaIluf8yGLqnnvnFcksGruSlw/IlPi8NZI6Mg/g6Xm934Z7zi
         jxzpzKeY2VgSJvwE13o2+VsnWuA76Z7AoaUVX2RgI77DXQuhLrhkkxRQsZXMfuxPxEVB
         VV9g==
X-Gm-Message-State: AJIora8SzgXXNnvOTe37nZ248rxBJ9yapEks3qAUBuyoMczz1xRV517o
        X/8Pz9BBmnBgPGeA4vfCl9k/0WrjvW7i+Nvm
X-Google-Smtp-Source: AGRyM1u8bw5yX8Azsx/VVXlqNq7KAcFIgBhG0Cwi09I86TTI3TPWbb/Oe3RUK7VBjIHSzqGU2qz41w==
X-Received: by 2002:a17:903:40cd:b0:16d:1d6b:d581 with SMTP id t13-20020a17090340cd00b0016d1d6bd581mr285090pld.10.1658255250996;
        Tue, 19 Jul 2022 11:27:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x15-20020a170902ec8f00b0016c3d9ae24esm12154454plg.60.2022.07.19.11.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 11:27:30 -0700 (PDT)
Message-ID: <62d6f792.1c69fb81.c1f24.2239@mx.google.com>
Date:   Tue, 19 Jul 2022 11:27:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.12-231-g7941c709500d
Subject: stable-rc/queue/5.18 baseline: 179 runs,
 2 regressions (v5.18.12-231-g7941c709500d)
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

stable-rc/queue/5.18 baseline: 179 runs, 2 regressions (v5.18.12-231-g7941c=
709500d)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | multi_v7_defconfi=
g | 1          =

kontron-bl-imx8mm  | arm64 | lab-kontron     | gcc-10   | defconfig        =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.12-231-g7941c709500d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.12-231-g7941c709500d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7941c709500dd3c8700c5e0c5ab16d7bce2b8fb1 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62d6c589059119ac64daf05c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.12-=
231-g7941c709500d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.12-=
231-g7941c709500d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6c589059119ac64daf=
05d
        failing since 13 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
kontron-bl-imx8mm  | arm64 | lab-kontron     | gcc-10   | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/62d6c00fe9f71b2220daf074

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.12-=
231-g7941c709500d/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-bl-im=
x8mm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.12-=
231-g7941c709500d/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-bl-im=
x8mm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6c00fe9f71b2220daf=
075
        new failure (last pass: v5.18.12-231-g6fff5045b5f0) =

 =20
