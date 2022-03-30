Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D454EC80E
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 17:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240658AbiC3PWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 11:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236742AbiC3PWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 11:22:08 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5221B190EA0
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 08:20:23 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id y16so8179148pju.4
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 08:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sfnFWCBykgn4+1wqTMi1HsCPsvRNtv6wht9EqtiJ1lo=;
        b=Rv1/vCOrJFI7AvLtU7fNXCOFCdwOFXau+XGqRLAXBog2sYKOQQ+IxRsqjT7bsqwWU0
         uJ4QlPPB88na4dbNRJ+7dnsCR+WCi+5dNeWzcxJQt2m18J1hRiXFzsduUnzCUmrC6Zpw
         2aBBsEeuGztK2lcyOlU7UxD+bkzmKADytqOStFbYqxfwRAcmQ5XiXwlDbsYWHUWGrSjF
         GsC1LmVR9ZvJEEdn4C9mo1+bdqUMIXaKFWFcMvnM67oMEMRARSRjATRCBp1qrxNxwJ7G
         NOXV/TtE6dwkBukyrqRcQ6zzCZVe5kRKF6VWrqfgnXlEQq50UraiuRDUQaW8E5p0/zI/
         SUZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sfnFWCBykgn4+1wqTMi1HsCPsvRNtv6wht9EqtiJ1lo=;
        b=nfiHNrqhDVcBIYzudaONBf4xcvv3JqrQ5Kn42/bmd3QlJtQGC8RJzr0o4n8OEGNkMU
         RDX4vl9SBg3DdURH10UIIaIM8rwyQFNphbZffSBJ8UO3pAu+ERfflaWcY9wDdPAEbmK/
         g9drOZ5u1W1rApOis1mpKVTObVPvwAeu+0G+p68SE6pKHuKUV2EgMxJtqeqtuaZJiXz4
         kR7bu27diQwz6h52dKUtaC8NAH5Zy3y8EkxMzwsVc9faV8EH+r47D8w//bnSXDnZ+leA
         NCO6Si/GTsczq+lS3jkUb1GbGE5OXry4vR0rMyr7GbPNmsY6Nall3pyGj2l3rOgEhSOX
         cjgg==
X-Gm-Message-State: AOAM533tftgkRuTku8tHER0i/Bc5uk5xibZnxuL3voqM068Al1bllhTF
        9S+YbTpDZUYNVeZzDPVZA4nR41G6Uh5yF5JrJVE=
X-Google-Smtp-Source: ABdhPJzQVKz7i2xueaMZoKlsqhTSvHNuPI+h4ZY9puXf6837f7MBCjK/vQu63e1HFr+wIy8xR/71qg==
X-Received: by 2002:a17:90b:3881:b0:1c7:c02b:bcf8 with SMTP id mu1-20020a17090b388100b001c7c02bbcf8mr5721834pjb.131.1648653622547;
        Wed, 30 Mar 2022 08:20:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s2-20020a17090a1c0200b001c994db1960sm7761038pjs.10.2022.03.30.08.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 08:20:22 -0700 (PDT)
Message-ID: <62447536.1c69fb81.e4a14.3420@mx.google.com>
Date:   Wed, 30 Mar 2022 08:20:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.188-15-g525a0fd34ada9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 80 runs,
 4 regressions (v5.4.188-15-g525a0fd34ada9)
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

stable-rc/queue/5.4 baseline: 80 runs, 4 regressions (v5.4.188-15-g525a0fd3=
4ada9)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.188-15-g525a0fd34ada9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.188-15-g525a0fd34ada9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      525a0fd34ada94c77ad072ac3b1cd786cb198227 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/624444492010159437ae06ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
5-g525a0fd34ada9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
5-g525a0fd34ada9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624444492010159437ae0=
6af
        failing since 104 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/624444399c5743e1f7ae06a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
5-g525a0fd34ada9/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
5-g525a0fd34ada9/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624444399c5743e1f7ae0=
6a3
        failing since 104 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6244444a6e60d3105fae0682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
5-g525a0fd34ada9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
5-g525a0fd34ada9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6244444a6e60d3105fae0=
683
        failing since 104 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6244443b9c5743e1f7ae06a5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
5-g525a0fd34ada9/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
5-g525a0fd34ada9/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6244443b9c5743e1f7ae0=
6a6
        failing since 104 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =20
