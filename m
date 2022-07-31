Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A175586000
	for <lists+stable@lfdr.de>; Sun, 31 Jul 2022 18:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbiGaQzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jul 2022 12:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiGaQzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jul 2022 12:55:20 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5F663F2
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 09:55:19 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c139so8594446pfc.2
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 09:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FaYVSu/Cv312PZgX8qlllIawfMaNp1gAkCFfq3QcLu4=;
        b=pvOXkOhGnUoaDN9b+CMyv7rj3e2nsCNc/MkINGjTRjFt+opPwW0eLxldWEjXxX6drb
         MAXSW/0jvmB7qg7XARMDm9WcCKh+XqQvIWW39MC7waN48H2mcTZCyfvezsiAPgKmzBgj
         t26SgdXtn5zZwd1ZYd5YpnwRnoYzn8TfeQh9lmssFtHaSUlim7OiUkrcTknhwCJOuamr
         G5NGTGwXExqHutiXYQBv3fK162G029S+IPbNMNrZwzXqXcxtoU4MN0AYhlosb0wCNXQg
         RYUaRlhqj5KJsngfyZWve64FxNisteHN+bw8PxNw7+IQZzee9D7dtzJBICv4h5MQ5r2I
         USrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FaYVSu/Cv312PZgX8qlllIawfMaNp1gAkCFfq3QcLu4=;
        b=eQD+GPoQfUtuqRALUJydcJ2BAhPACHBkeSa8Dc53jv4YZ1fA+VN7p7CSoQNqTGvltQ
         uXbYuGoYb8NC3caXWVkLocHlO9njz+ep1siT/eNzene1LxZp+/LEe0ePv0WfKXRaiZU7
         faz/CTkiM9hDDf3HET7cbs8A7p0B6cfOFr91l+35vxdHoKG5Hd8WMw3kDtJ+mBFUNpSX
         TAeN+OPltQFS+gj//qUGcSJzDF1y0pnFO1oBM8+DPhUMJg2xbnuaBDEHJdHxZXvAJxI9
         Rpq5vMal97m/X/OvNBJnVSW8QVrRBDqpTXCXpaLxSLit+6tpv1QJW8QApNgV3z4PHgK8
         dbiA==
X-Gm-Message-State: AJIora+nKKtXsYPK5W5Ahkl7MlcI4Xp2FIad1Ytk7SfE7WnNh1w6D5gt
        0paggAxTgJJtHxaZqmMXah78rPwYeyho48WajC0=
X-Google-Smtp-Source: AGRyM1vuo5K02blRBkMNHAMp5W0mkgsC5lAzdH5aLWUfBMUnIUPFXrm8fXoo4+z98v7nW0swD+f/LA==
X-Received: by 2002:a63:6902:0:b0:41a:3743:c768 with SMTP id e2-20020a636902000000b0041a3743c768mr10414655pgc.512.1659286518750;
        Sun, 31 Jul 2022 09:55:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s4-20020aa78bc4000000b00528ce53a4a6sm6647712pfd.196.2022.07.31.09.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jul 2022 09:55:18 -0700 (PDT)
Message-ID: <62e6b3f6.a70a0220.9e8e1.a47c@mx.google.com>
Date:   Sun, 31 Jul 2022 09:55:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.207-121-g813475eed1019
Subject: stable-rc/queue/5.4 baseline: 81 runs,
 5 regressions (v5.4.207-121-g813475eed1019)
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

stable-rc/queue/5.4 baseline: 81 runs, 5 regressions (v5.4.207-121-g813475e=
ed1019)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
odroid-xu3                 | arm   | lab-collabora | gcc-10   | multi_v7_de=
fconfig | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.207-121-g813475eed1019/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.207-121-g813475eed1019
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      813475eed10194c9bc4058b30edbfdd04ebe0bb2 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
odroid-xu3                 | arm   | lab-collabora | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62e67fd3c022879748daf095

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
21-g813475eed1019/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
21-g813475eed1019/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e67fd3c022879748daf=
096
        new failure (last pass: v5.4.207-120-g2159441a1068) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62e680efca1d40f394daf057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
21-g813475eed1019/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
21-g813475eed1019/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e680efca1d40f394daf=
058
        failing since 82 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62e680eb24e7a1f278daf089

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
21-g813475eed1019/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
21-g813475eed1019/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e680eb24e7a1f278daf=
08a
        failing since 82 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62e680eec42c67393bdaf059

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
21-g813475eed1019/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
21-g813475eed1019/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e680eec42c67393bdaf=
05a
        failing since 82 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62e680ecc42c67393bdaf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
21-g813475eed1019/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
21-g813475eed1019/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e680ecc42c67393bdaf=
057
        failing since 82 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =20
