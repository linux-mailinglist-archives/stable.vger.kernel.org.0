Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94F25F4CF6
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 02:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJEAQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 20:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJEAQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 20:16:37 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37226F24A
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 17:16:35 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id x1so14053685plv.5
        for <stable@vger.kernel.org>; Tue, 04 Oct 2022 17:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=nnr5aGCC4ctDNhbYTwtE1uAakK62x1QLGqWeOCwN5Po=;
        b=6NJKNljdN3kNl/gKxNnMygJ8jrR9O62wHBKjKSpsPgbFkmZhLbFQvJ5niqwlwpL/qm
         DhWh0MNYZIRYP5mFBuzn+7u2zUE8lFIFyvLvCT1OyG/pbngTU/EliyLO1JzH/mv8LuqF
         1KeNLfs8B4ddtfdDaBPlnJqxVUGie3sqV8kvE6yXYnC0atNgxB716eIoGNT3IDgosZrY
         F21UpOsM6XYkIrF110jyt39exbe0mJVRVDQHXPVTxl/NyoXKn+4JMTkYRs2oCOI9wsI8
         Itn2OFYIgoDkrBQ2CinmjL7SgXu7gHwzvUTsWSzaHAgZRrSFkuhY/+0VJQjANNXcfg11
         4IUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=nnr5aGCC4ctDNhbYTwtE1uAakK62x1QLGqWeOCwN5Po=;
        b=sm1btuWzJcZ9kfnX+K57YJNPdpC6m/OAOOktEq1KflS2/hQABpTKtqa169OB8Yw4fe
         Rp3m+tpz15cfmXvyWdFbgo8bgJz550SNEXOqqM+q2jxzO9KU3P0e5AH+PX1cAqVo4pSF
         KEchMvLo63HaVGQn9j1HUt054aU9I2iirlFcW4d+6Rpbqk3TjsXWg8YmTNgYrfPvRJEw
         vtXbo+9v4uVN+4o8h2sB069v1aFVVMbfX801BrnQ/GlgvZS1fcf5cdia8PuLrrVEWqyP
         U2ZQAnKf0mSU5gVoFq2VdRokE/UULq32JilNWrWO5key4xg4sk0vQ9UN7Z4o3JrWSIsG
         Pz/A==
X-Gm-Message-State: ACrzQf08FOKvtnkT4qHDh/6f0KMRWtUVRsEtVX3/4e4xJzrUBxeMPkpK
        /JId+W4O/VN6kTEME7VPoWaUUP7GhHOtzuy55J0=
X-Google-Smtp-Source: AMsMyM5buJJKp53vX1gZbGofOnd4Xr5Dl6Ra1T3Cg+0+J/BtN9pmkYtYXEU+5tXQH0JD5d1yCmX3dg==
X-Received: by 2002:a17:90b:4b8b:b0:203:203:3365 with SMTP id lr11-20020a17090b4b8b00b0020302033365mr2217287pjb.19.1664928995283;
        Tue, 04 Oct 2022 17:16:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o5-20020a62cd05000000b005615c8a660csm5105711pfg.65.2022.10.04.17.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 17:16:34 -0700 (PDT)
Message-ID: <633ccce2.620a0220.ea8b.8f0d@mx.google.com>
Date:   Tue, 04 Oct 2022 17:16:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.260-25-gab084b4c6bb1f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 93 runs,
 5 regressions (v4.19.260-25-gab084b4c6bb1f)
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

stable-rc/queue/4.19 baseline: 93 runs, 5 regressions (v4.19.260-25-gab084b=
4c6bb1f)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
 | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.260-25-gab084b4c6bb1f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.260-25-gab084b4c6bb1f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab084b4c6bb1fcdfc4d7961a3e63e3d4b5fa7070 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/633c98801ffa0fa473cab615

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-gab084b4c6bb1f/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-gab084b4c6bb1f/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c98801ffa0fa473cab=
616
        failing since 168 days (last pass: v4.19.238-22-gb215381f8cf05, fir=
st fail: v4.19.238-32-g4d86c9395c31a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
qemu_arm64-virt-gicv2        | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/633c993b24d679ff22cab5f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-gab084b4c6bb1f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-gab084b4c6bb1f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c993b24d679ff22cab=
5f2
        failing since 70 days (last pass: v4.19.230-58-gbd840138c177, first=
 fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/633c98d9a02915d2d8cab626

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-gab084b4c6bb1f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-gab084b4c6bb1f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c98d9a02915d2d8cab=
627
        failing since 70 days (last pass: v4.19.230-58-gbd840138c177, first=
 fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/633c988bef183de19bcab5fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-gab084b4c6bb1f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-gab084b4c6bb1f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c988bef183de19bcab=
5ff
        failing since 70 days (last pass: v4.19.230-58-gbd840138c177, first=
 fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/633c98c9a02915d2d8cab618

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-gab084b4c6bb1f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.260=
-25-gab084b4c6bb1f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c98c9a02915d2d8cab=
619
        failing since 70 days (last pass: v4.19.230-58-gbd840138c177, first=
 fail: v4.19.253-43-g91137b502cfbd) =

 =20
