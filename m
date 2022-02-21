Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3944BEB33
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 20:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiBUS5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 13:57:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbiBUS5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 13:57:17 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCDFC07
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 10:56:52 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id q8-20020a17090a178800b001bc299b8de1so51833pja.1
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 10:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nIx8u4kbwqXODnCxBZvzCm6R/YGLiT4O+o1eGuHFRTs=;
        b=RlNTkdEqG9Zm6mH0mzVdlGDihP5Q9zl0gwtI1FgCRz/BlJqVrFGMlEv4kAVWx8qFKi
         u15OaL/ef2odUrDqF3slTjTztbLWz2lpMv4uGCOsfQ43Z8Fj947Zrkl84epj8gTBz2Y5
         Hmrh6wK8qQg4S5RTHD6ZjKV65zIQGBvjfvyjdnuExqAfNzy1HguDMwfFf3nAsJV0EMvM
         7ML5PnHNSlln3x6E7X0zQHZY4r20GBm5o9uRFClDrwDhXua07gGN4XCIpPUNt4XLe0bS
         hvr0ZrCwaRJfl3z9V5S+y3cETOhTBFx4ZOSxoFwakYDMyZTxb2l8PZiP4UmB6sNrEjXV
         vvZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nIx8u4kbwqXODnCxBZvzCm6R/YGLiT4O+o1eGuHFRTs=;
        b=wqMMRdfPa7JSmfsuvDJADi5PDxvAhGqtsl2a7z+IxQx0E3M96PwtkVegqLRFCNusGP
         Ud4mYoJbOdf8G3aGE+OZVSeqvY6mI1CadWTnUDoR8FgsZXL+JxyNYkYl+MgRxz7zCWz8
         lg4d2o3PXiV/BWoBLEr5XD1CAmexut/qBI8pyIbB9nt4XOUsb19voOJ/VHCpfp+s32hx
         PPrmxheQT2pTDuvK+D7DCzj0XhJ0Xz31YsDtFjnl7Hz8ec2hiZQVFMBMC0Y5AtHn/kn9
         UufCTikzfE9cdlxaR25qZ0njiK5Zt2HzANGRImFBi8ryvFX0i+KZIhCCNIsrjnCvb2gY
         PhTg==
X-Gm-Message-State: AOAM531uR27MdzpOFms6lTvd8bPPPX5Gc3ypXRj8QhF5igCLeVPkWiDg
        RWErRqr8kz20EPS6G4ZhmfWst5XWV755k906
X-Google-Smtp-Source: ABdhPJybKZLk8ANqlIQ8F4GcJwmV3fF2CkQoIRCtqdKNAsMlzgWzpC44U4DvWnB8W9mlo/DTW2q/HA==
X-Received: by 2002:a17:90b:4a11:b0:1b9:9685:eea4 with SMTP id kk17-20020a17090b4a1100b001b99685eea4mr356897pjb.136.1645469812054;
        Mon, 21 Feb 2022 10:56:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y191sm14383836pfb.78.2022.02.21.10.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 10:56:51 -0800 (PST)
Message-ID: <6213e073.1c69fb81.3b87f.84ff@mx.google.com>
Date:   Mon, 21 Feb 2022 10:56:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.180-81-g04ffc48b9c61
Subject: stable-rc/linux-5.4.y baseline: 97 runs,
 2 regressions (v5.4.180-81-g04ffc48b9c61)
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

stable-rc/linux-5.4.y baseline: 97 runs, 2 regressions (v5.4.180-81-g04ffc4=
8b9c61)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.180-81-g04ffc48b9c61/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.180-81-g04ffc48b9c61
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      04ffc48b9c61bf5eb49daca8b489e326d6aed975 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6213af57e36820fc41c6296a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.180=
-81-g04ffc48b9c61/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.180=
-81-g04ffc48b9c61/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6213af57e36820fc41c62=
96b
        failing since 67 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6213afa7eb894f214fc629b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.180=
-81-g04ffc48b9c61/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.180=
-81-g04ffc48b9c61/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6213afa8eb894f214fc62=
9b7
        failing since 67 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
