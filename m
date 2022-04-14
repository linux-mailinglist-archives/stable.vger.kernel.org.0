Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90EC4501963
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 19:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241739AbiDNRDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 13:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245149AbiDNRCt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 13:02:49 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D2D20BD1
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 09:38:51 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 32so5227395pgl.4
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 09:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sJ+MvmKe7fT4Uvho7fHs2CvsqpdomKVO+/H3XJOUDL8=;
        b=6WbwYhzA80ZZvBoAWvGoE/VB9gXcULa4TuuwaTmtvkr8mfqUuopiNZjE3omCi23vsX
         LMivbZuIFOvRIbVJXxOQLST9gxx2R3+AtX7WFKzS+5/V9KVw+mskVG5M6NsIt+Lo4mKY
         HyTL0w4AhVR4HpvWx2jJvxhlRhFtLkwycaE1q4wx+rExv7ZQZJ3Yl10qsADfdUFakX/w
         ++E7I9NovzLvgK/NRSTtjP2AsRIKAkJbPACllL3GW5LUeK68wYcbNYWiwHWaDDD2a5qz
         EfmySWCt5sMYX7HND5mw5d5Nuzo7C8rbBRam2Nvo8c89aTRoOA/LFPqo9gbFIrK4mmJ9
         IKYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sJ+MvmKe7fT4Uvho7fHs2CvsqpdomKVO+/H3XJOUDL8=;
        b=GhlLtmDUUaeonKgojfH/8q5lhbsP4FRMDXyioCc3V0o4ZNeHSr3OSnlHjQuVJS16d7
         QiR/BwTJVJuKQeF6JXBTAJCoegnKhJ/NioInuzgdc9xTC94ujC5zZ68xcnqpwOFt1/0n
         lzne+cfVN3dG0bqXdUOVtavKddy50MU7lb35scBrDOjgGEBM6UPau0xqW1maI5uYeTOH
         cSOJ3ds1Rr2pkW77O36Na9oiE4Edoomx/F6mkIHh0TcmBd/tnnJsM1SE3yJS1tQpx22a
         XL7Eb3YimRTikhcqb1B6D2+40Ry8VHuHRAj+cKR1xTEbeUAC/TTG8Ku2SG2RkfHyWWGs
         uIkw==
X-Gm-Message-State: AOAM5304uUJg6X5kraEUTbxm3mn2NXYhNMKCOt1QZD7PxLyJ4jVe8FAa
        7t+ZbRJspg3RwMshCFoNfCcMDowslJByMJWQ
X-Google-Smtp-Source: ABdhPJziHMMjJK6duG9t8iTQBClK3saqBNt57afqo+WS5wZ6Uw2EJhl0lsG0vOwb9LezYpKNiqOkmA==
X-Received: by 2002:a05:6a00:1955:b0:505:7902:36d3 with SMTP id s21-20020a056a00195500b00505790236d3mr4649027pfk.77.1649954330702;
        Thu, 14 Apr 2022 09:38:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ml1-20020a17090b360100b001cd40539cd9sm2409022pjb.1.2022.04.14.09.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 09:38:50 -0700 (PDT)
Message-ID: <62584e1a.1c69fb81.bead3.6654@mx.google.com>
Date:   Thu, 14 Apr 2022 09:38:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.237-339-g3f08640122e30
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 67 runs,
 2 regressions (v4.19.237-339-g3f08640122e30)
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

stable-rc/linux-4.19.y baseline: 67 runs, 2 regressions (v4.19.237-339-g3f0=
8640122e30)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =

meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.237-339-g3f08640122e30/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.237-339-g3f08640122e30
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3f08640122e30667d6aa2e90e4fa57f3d9f48ceb =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/62581cddec00924459ae06af

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-339-g3f08640122e30/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
bb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-339-g3f08640122e30/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
bb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62581cddec00924459ae0=
6b0
        failing since 8 days (last pass: v4.19.235-23-g354b947849d2, first =
fail: v4.19.235-58-ga78343b23cae) =

 =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/62581e08528f0fc69aae06a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-339-g3f08640122e30/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
l-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37-339-g3f08640122e30/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
l-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62581e08528f0fc69aae0=
6a2
        failing since 2 days (last pass: v4.19.234-30-g4401d649cac2, first =
fail: v4.19.237) =

 =20
