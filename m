Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326EB5E5746
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 02:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiIVAXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 20:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiIVAXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 20:23:16 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C968A6C23
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 17:23:15 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y136so7658532pfb.3
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 17:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=Cjeffx4SKmyymVIzpM11+bj1tins9PZsSYhKRze8jxo=;
        b=rDhNGKtaSureGDSAbcXy2Q85OPWG0DS8QcY4fcYT39b4ymBHDiBimBqgMNZB5pRAwU
         wUQt93cjAsCk+6wa1LCzpstXWt4/mwXc6wcgpcHw2ljD3rSWrDlfTi6xhdAfbEfAfKak
         c92KA8ZDErSs4ueEKe6++qnDS7r0yyD2pYh2IDbZdDtoSSYMzV3p/TnKbtZg5Dck5NzG
         ATHH5alWONr4NDV6ut4o+TkP9bPYg5iBy9z/o9ortKKJ3WstpV7O+JFoGt2049kPdp7+
         EPCBPsAfFqEyIE9rZVvI4F0SKPzcL6mb+eIANRnNCNxcl5Bvqu1cEgkTvAagZzdAaHLJ
         4P8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=Cjeffx4SKmyymVIzpM11+bj1tins9PZsSYhKRze8jxo=;
        b=F6V1vZItx704U4mEvAFVA9+AlgNEIgSGQUvh+cG+0UYve9uAzpRXqhDvgW8ATEBYTu
         r4UeYrpm39aQZe0krA64yjBbsNfyHAeRnTU1WdepKVYFjRFrMAs4dTM0Bqz5/mZXTwxM
         0aWHpf8G4iyE/O1aaX8I79NBRQveNTayqrjwzrXy6kfrjMZ/a5Hw7Utvje9lEYaB3qA/
         TtbWvzS93+Ha7sDFWh21F6nOlbv3vB16VR/OvEa54Ut5nOTgqChi2531NMPaPzMZtu80
         Wgk2FsDMMFv8dO/jJF6WeIrJXzMo6xP/7i8O1dvdOqHEU9HNKgz3QHf/c1Ab37v/VpwT
         TEmg==
X-Gm-Message-State: ACrzQf0UA+cOaPBczWGpjTGzefp19gqnutKlXnpNrSPUbMqldEcdY/C5
        ehZ/BzDkNqYcz4FNHWDPcP/q+BQW5DHw4PSNOUg=
X-Google-Smtp-Source: AMsMyM44lDqF1pzWJPTVzw4VdwPWBd41wspWGIgU53C83cND/1nVM8q2ZnZs/pkAvfwRWlUBKJ6aSA==
X-Received: by 2002:a05:6a00:a82:b0:547:d660:c077 with SMTP id b2-20020a056a000a8200b00547d660c077mr853122pfl.38.1663806194429;
        Wed, 21 Sep 2022 17:23:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p15-20020a170902780f00b001728d7c831asm2597165pll.142.2022.09.21.17.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 17:23:14 -0700 (PDT)
Message-ID: <632baaf2.170a0220.3509e.5d1f@mx.google.com>
Date:   Wed, 21 Sep 2022 17:23:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.294-15-gfa1a41adff7a
Subject: stable-rc/queue/4.14 baseline: 64 runs,
 4 regressions (v4.14.294-15-gfa1a41adff7a)
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

stable-rc/queue/4.14 baseline: 64 runs, 4 regressions (v4.14.294-15-gfa1a41=
adff7a)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.294-15-gfa1a41adff7a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.294-15-gfa1a41adff7a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fa1a41adff7af179b513706d80170e5dea81859f =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/632b8061be94420407355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.294=
-15-gfa1a41adff7a/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.294=
-15-gfa1a41adff7a/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632b8061be94420407355=
645
        failing since 57 days (last pass: v4.14.267-41-g23609abc0d54, first=
 fail: v4.14.289-19-g8ed326806c84) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/632b802f4f273f334835565c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.294=
-15-gfa1a41adff7a/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.294=
-15-gfa1a41adff7a/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632b802f4f273f3348355=
65d
        failing since 57 days (last pass: v4.14.267-41-g23609abc0d54, first=
 fail: v4.14.289-19-g8ed326806c84) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/632b810b3031bf92a2355647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.294=
-15-gfa1a41adff7a/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.294=
-15-gfa1a41adff7a/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632b810b3031bf92a2355=
648
        failing since 57 days (last pass: v4.14.267-41-g23609abc0d54, first=
 fail: v4.14.289-19-g8ed326806c84) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/632b81337da78b31b8355652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.294=
-15-gfa1a41adff7a/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.294=
-15-gfa1a41adff7a/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632b81337da78b31b8355=
653
        failing since 57 days (last pass: v4.14.267-41-g23609abc0d54, first=
 fail: v4.14.289-19-g8ed326806c84) =

 =20
