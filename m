Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D14959CE53
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 04:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239449AbiHWCIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 22:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbiHWCIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 22:08:38 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29841EAED
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 19:08:37 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id q9so1977366pgq.6
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 19:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=EMgtO9s+90Knh8d7sQwLpR/W3GiWVVDQqoHlAa9WiZY=;
        b=o3SF4FISQXM5hu+bmYXQsA5sE6YLHuSmq2u39rR2xTjzXmT43HAeIuNNHmV11Du75C
         uumjuzTp4UZh/lgRywbCexuNqWv0sW6oWuspETGepynZvXqBHPB8P9oqtBRF8mYRDTFM
         53uBdVNO+NkNj7rxTFIqKDuX+/wUao6uYjYhQv+g3CryB1w6Xk9dMQBXa3FI+rqxhVnk
         OBCi6YvgO5+6ajaEpQQifa/TOOVwv1yPmLcfSIP98vC/puNLZZbeR97kQj31szyDrcXJ
         JtfwbZnhY844FBgzWUehCG0N84pRvThiDYqJMy0MqGrIaIlKF8YQkSKGJODDYj8jQK5y
         F5QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=EMgtO9s+90Knh8d7sQwLpR/W3GiWVVDQqoHlAa9WiZY=;
        b=tEF95tmp4wgmAkvsT0QkMglA1ll9Y2TTfqopemNq86N1jqs86vofUX8xEEsmCkDLsL
         MBO26gsGPfq7HRENZ0B4AlnKPHR/nsjlPV/qrXrJuevphR4V9BYMlvJqKLwIzxiTtF8s
         G6Jj5UIN+ZGTUONpfvLuhtrTapGYloDCPIgB3LBw/mDtm0QyIl+Lcm6nZj+76iJ/99fJ
         m4KyM1j8yYgrHgtaYBsO7Yj1NlFgzar/+NAP7/CpPQ601PFTIvvdIDaNfE+Wjkv9ZSEo
         OM6AcSvczEd/s2ofZ5bTkiXh1fRq3ABjld7e3MHkKpXF4xi8cj2zbOY8R/3UJ2cOolo8
         jYmw==
X-Gm-Message-State: ACgBeo1eOUBVCL2qvFvGMBivDR8JUNV8BLvyTavZmpAXoFplInKI4kgu
        N1HJEGiD3X8pJNBTpSznrLlcWnXHMl6FWmep
X-Google-Smtp-Source: AA6agR6Vy+m2x842hGuo17xD9eT1OO8P6Sws3iuNQwdCKL6jAZOhviVCfzjFPWfX+quvszuv/Hfmxg==
X-Received: by 2002:a05:6a00:1741:b0:536:baed:52ee with SMTP id j1-20020a056a00174100b00536baed52eemr5865489pfc.68.1661220517248;
        Mon, 22 Aug 2022 19:08:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h18-20020a170902f71200b0016909be39e5sm220752plo.177.2022.08.22.19.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 19:08:36 -0700 (PDT)
Message-ID: <630436a4.170a0220.2e45d.0a0a@mx.google.com>
Date:   Mon, 22 Aug 2022 19:08:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.137
Subject: stable/linux-5.10.y baseline: 131 runs, 4 regressions (v5.10.137)
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

stable/linux-5.10.y baseline: 131 runs, 4 regressions (v5.10.137)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.137/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.137
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      74ded189e5e4df83aaa1478f7a021f904105c8dc =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/63040d3f4e7798f8af355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.137/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.137/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63040d3f4e7798f8af355=
649
        failing since 105 days (last pass: v5.10.112, first fail: v5.10.114=
) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/63040d16faafe7450d355653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.137/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.137/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63040d16faafe7450d355=
654
        failing since 105 days (last pass: v5.10.112, first fail: v5.10.114=
) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/63040d52b6beeed561355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.137/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.137/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63040d52b6beeed561355=
643
        failing since 105 days (last pass: v5.10.112, first fail: v5.10.114=
) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/63040d2a4580086c3c3556e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.137/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.137/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63040d2a4580086c3c355=
6e2
        failing since 105 days (last pass: v5.10.112, first fail: v5.10.114=
) =

 =20
