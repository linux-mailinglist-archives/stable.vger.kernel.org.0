Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAA44B91F7
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 20:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbiBPT7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 14:59:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiBPT7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 14:59:15 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6FA224964
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 11:59:02 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id d9-20020a17090a498900b001b8bb1d00e7so3390066pjh.3
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 11:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DSQl8vdCAKVMHFuyG438tWRm/g8TGFwxhJ3ENBJH2Mc=;
        b=otYWYV/Rc3w5i4jzHeuVtq/1u3LyrdX9Jvy9BJ6FUmsvdIARYsO/Q84CnExQi4dop4
         pn6EKrdQHXgY1/zWuq0h7++l2D3JAi+0cLbNZCBphZqL92SGDPFE+DLpt8k2WNKIw0hG
         VgMwX298HVKQBH16y34J6qsMSTawIFXivgMXxcdjXic5oADae46ZDmxHHuQ59eZe9gQu
         jp0hugNp0mos7JbV2o0tQsjhztTBNhK9nkQy/VUIyBAuLXFyFDaaL5xD0ViRmwlkOTyw
         ynGhqhdbqUlNF52NH+jL59KM2mLu6fixvApa/vp0L2e9JOFki5n5fW9SoNWpc8sL/lzk
         K2mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DSQl8vdCAKVMHFuyG438tWRm/g8TGFwxhJ3ENBJH2Mc=;
        b=zDXfn+x4xuCHdNtHZ4lnbnMLOaMNTpOZ7114iGJEm5+xfOzMmoS/gQxiY8E3z2EC2V
         b5unCWY6rEsmUK/LRc7FaPtUsRy/I8UeEY1kaSVTubqcWlQBOJsX+tOjcPeA6L6U5r+g
         p8c6jxHaIfHaf5eU90oMNuUdHVRyKVHuhYSrZOSQu62msUme5EidupHfmF6PPFgLKsT5
         XBUqAyflDpYslELl4CfxS6//Wx5Ne9i+ugVPTLTZz0o4VNmwN0DvBEZBNb2iDgJN0IYi
         eKEnF9HZ+s4iIQjmfMuN+Jk3oLZOVlJKBibr/eKGfO7W1Z6kO9rvN1wlRfHIZXZ1vkKA
         p+yA==
X-Gm-Message-State: AOAM530ofLXNuMgt3Bj5THgWNqoDqzwNm/K3/dUI4uxizF2z95KBmJQx
        qFba+sBHMFdh6/MMKNm+8ZzwxXcttDdIsuv7
X-Google-Smtp-Source: ABdhPJyf+X39FVTRAXAGhVbtY5+av3Wpdd7OwL52NF24O/WZZubRKzRNUJiyKgeM+oJdouy7Vq+JtQ==
X-Received: by 2002:a17:90b:390d:b0:1b9:c042:3b30 with SMTP id ob13-20020a17090b390d00b001b9c0423b30mr3612764pjb.195.1645041541310;
        Wed, 16 Feb 2022 11:59:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 20sm20668554pjf.15.2022.02.16.11.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 11:59:01 -0800 (PST)
Message-ID: <620d5785.1c69fb81.57f3.3df9@mx.google.com>
Date:   Wed, 16 Feb 2022 11:59:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.24
Subject: stable/linux-5.15.y baseline: 84 runs, 8 regressions (v5.15.24)
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

stable/linux-5.15.y baseline: 84 runs, 8 regressions (v5.15.24)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.24/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.24
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a0ebea480bb319a3ad408c99db91262dbc696b76 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620d20bd358ffaf385c629e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.24/a=
rm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.24/a=
rm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620d20bd358ffaf385c62=
9e4
        failing since 7 days (last pass: v5.15.20, first fail: v5.15.22) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620d20c33aa6c30239c6296b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.24/a=
rm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.24/a=
rm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620d20c33aa6c30239c62=
96c
        failing since 7 days (last pass: v5.15.20, first fail: v5.15.22) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620d20b949bf48eb4ac6296c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.24/a=
rm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.24/a=
rm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620d20b949bf48eb4ac62=
96d
        failing since 7 days (last pass: v5.15.20, first fail: v5.15.22) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620d20d30f3fe8e374c62984

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.24/a=
rm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.24/a=
rm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620d20d30f3fe8e374c62=
985
        failing since 7 days (last pass: v5.15.20, first fail: v5.15.22) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620d20bb0f3fe8e374c6296e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.24/a=
rm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.24/a=
rm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620d20bb0f3fe8e374c62=
96f
        failing since 7 days (last pass: v5.15.20, first fail: v5.15.22) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620d20c097e55c8cd4c62978

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.24/a=
rm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.24/a=
rm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620d20c097e55c8cd4c62=
979
        failing since 7 days (last pass: v5.15.20, first fail: v5.15.22) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620d20bc97e55c8cd4c62974

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.24/a=
rm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.24/a=
rm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620d20bc97e55c8cd4c62=
975
        failing since 7 days (last pass: v5.15.20, first fail: v5.15.22) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620d20c20f3fe8e374c62978

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.24/a=
rm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.24/a=
rm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620d20c20f3fe8e374c62=
979
        failing since 7 days (last pass: v5.15.20, first fail: v5.15.22) =

 =20
