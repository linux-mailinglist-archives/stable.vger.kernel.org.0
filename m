Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D135B2340
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 18:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiIHQNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 12:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbiIHQNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 12:13:10 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1A9E9006
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 09:12:33 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c198so8534470pfc.13
        for <stable@vger.kernel.org>; Thu, 08 Sep 2022 09:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=DNUHAuJSiNw/UKJuK/Ql/Fq25s+VH3R8ewcYH2qBSl0=;
        b=YiShzNaqgwgfSt7EU8nmKI7TCd7fSzBWz38vy47OQAr57fQBnc5l8akapUM7JhDDiH
         xDn1jcNeTwoBxWv+hVLWLr5k1JVdFtPsfg90R2SCOF9gPUrz7rhwOkvy/2K1FTlkhQEM
         u2fnIfyKLIRiA1VC0y7bRADh7XQ366HTRjICrPx63PYAkNEKbaymf3LWFyGrZ9wvx3Fh
         EMFn1HQpXx7ZHrAZExozvwcg4MR0nMOkVxWOKAtuNC6qm0D2YoV0On+LfKZyVzKa9vrQ
         QXCG/ogdLeqLNnU+rTJhOkwZYra5e2kTu3ZqNNHb4BrCBLS/Of6RMuTBm4A+VaV0444x
         22NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=DNUHAuJSiNw/UKJuK/Ql/Fq25s+VH3R8ewcYH2qBSl0=;
        b=Jm5NUYY7189hZmskDLYz8uU6PkzNpz6YxUhKTg8rhXg78Dx502lsHvgT+T0DwbItKO
         0kJI9R+r5maxbqNgysVMFrEdC8T/nH826hfx8MUA7QVgAg1Gg/I9rrUdDyRPGAnHzq/G
         z2jLbvc1joTqMfN2HSn6bttHSnID+8Dq8ITCWoqAx6ZoiP9iqnPQlcQcXEQhbphLBW2D
         sACczigSV/3Wyzlk6aSGCUdFonpXCv+Zpv1hsKb1MQ3tX1mxNVCcwyg8OyCWB1fEI5U2
         X1e/muJhI8yV89WB3FQsJqMHY5TmLWX5gvP1Ro5/uvYFsBWvQu6WfQk13bsySP9bvDhC
         2aGA==
X-Gm-Message-State: ACgBeo0iPPK7/wk7EUfxwD0awjMNsde6PDY/wbOstMH78nDDv9Jmx4R2
        y8EXfigETcTuYrFa75vZ9zvrIUTx7vNv4dS/Oq4=
X-Google-Smtp-Source: AA6agR42ix+cYXlBFP6OOk5k4KiUjozVtQ/TUdxQHneqvtX624OjAgaR9LcJxHng6E0yZY7DFOOd/Q==
X-Received: by 2002:a63:d1f:0:b0:422:7774:1969 with SMTP id c31-20020a630d1f000000b0042277741969mr8382085pgl.88.1662653552117;
        Thu, 08 Sep 2022 09:12:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v188-20020a6261c5000000b0053e8368ec34sm3915341pfb.32.2022.09.08.09.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 09:12:31 -0700 (PDT)
Message-ID: <631a146f.620a0220.c663f.6e4c@mx.google.com>
Date:   Thu, 08 Sep 2022 09:12:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.142
Subject: stable-rc/linux-5.10.y baseline: 176 runs, 4 regressions (v5.10.142)
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

stable-rc/linux-5.10.y baseline: 176 runs, 4 regressions (v5.10.142)

Regressions Summary
-------------------

platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.142/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.142
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      281e81a5e2b211e2ecdca7362330acf9b238a1a6 =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6319e3cb7a4a304d0835564d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
42/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
42/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319e3cb7a4a304d08355=
64e
        failing since 121 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6319e3b7a4ace70b06355753

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
42/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
42/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319e3b7a4ace70b06355=
754
        failing since 121 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6319e443a00d94fe1e355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
42/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
42/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319e443a00d94fe1e355=
644
        failing since 121 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6319e38ff9798e02e73556ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
42/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
42/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319e38ff9798e02e7355=
6ac
        failing since 121 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =20
