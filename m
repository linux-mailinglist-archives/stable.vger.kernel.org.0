Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61498571AB8
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 14:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiGLM7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 08:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbiGLM7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 08:59:44 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B892AC58
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 05:59:42 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id q82so7495312pgq.6
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 05:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8JJpqw/cHwxiR2o7zK/lDUUQwQyItBbwMoyUPZP03Es=;
        b=RFXilMR5ovbZxV5kJdeforxmIiPYc01JQHPmSMBR+tAV2VxJK65F1uY6Ak7/qj/FJ9
         XhwImLK+8OdTxVUy+AAwyQTdJmVy6w/BTjHxo3dxr5hQf9XfioMdfH+6N9ssTeulv+Np
         t/7MOfpmvmQcLmAmwvwFkRUWCFDM3GTXvTOahYOl9XPFMFiNe4ZR7vnmUG5CAsX5mp7G
         xUuq0JloE1Qp6grhwkBSAWMzYZbqlhFeX5IeZF0Wa8guJCBml0MEpJJMruAbxEKrDCM4
         xjloL60MVXGM9FUeE/7D6gqkHavjikABaIwQWFQQuLouwgm7tHtpByHtxa/TB68lXbxV
         JBUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8JJpqw/cHwxiR2o7zK/lDUUQwQyItBbwMoyUPZP03Es=;
        b=LKv2Y9C+5hqcOGCl+7oe1BYS/WgTg4wjin47jL/KLyQtrFGB/vKJelsV+1jlxIM4Xi
         AhHBikK0aSmm5hqZbUp4CNcVckQUbjRD/Cs/hM1T1ocw7xWqXcnWt68pzM8RL1E7OKPz
         MVZR7PbrkeUYyEUjyTF7kegrLFZGydWgVUz2tTmWbOoV7TIl6UPSVTbR1fxwrJN2G1q/
         PBiMOgXz5USpQd6YMFW+MXIVc2yMbnwsrt1Ug9Bzmxkeb4w2522t1fzH3RlQK6RjisUx
         R21GopDZcqT03jx8zYacpf9mSGgU6voI7O7rpLW/WvNG13wW08vqukLpU9B7DgWS3kTl
         qMYw==
X-Gm-Message-State: AJIora9f29KuNoP4Z5NzkCQp0i7e+qeSUZppNyQRNYrRPL0s9jUg1rgh
        7f7kdKlCh12dQlDMzT49ru5lc1k+qtlnEsfv
X-Google-Smtp-Source: AGRyM1uRZ/NAQpsrjqsTwIkdqIIx+LdPQWjFvyiCiQuLTpncPCX32sR89LpyqDnBIhJW6t3yHrPXHg==
X-Received: by 2002:a05:6a00:812:b0:52a:da89:d201 with SMTP id m18-20020a056a00081200b0052ada89d201mr7122327pfk.57.1657630781217;
        Tue, 12 Jul 2022 05:59:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 63-20020a620542000000b00525373aac7csm6750249pff.26.2022.07.12.05.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 05:59:40 -0700 (PDT)
Message-ID: <62cd703c.1c69fb81.a4e52.9a03@mx.google.com>
Date:   Tue, 12 Jul 2022 05:59:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.251-31-gb728ae810f5d
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 115 runs,
 11 regressions (v4.19.251-31-gb728ae810f5d)
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

stable-rc/queue/4.19 baseline: 115 runs, 11 regressions (v4.19.251-31-gb728=
ae810f5d)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
meson-gxbb-p200              | arm64 | lab-baylibre  | gcc-10   | defconfig=
          | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
          | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
          | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
          | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
          | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
          | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre  | gcc-10   | defconfig=
          | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
          | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
          | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
          | 1          =

tegra124-nyan-big            | arm   | lab-collabora | gcc-10   | multi_v7_=
defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.251-31-gb728ae810f5d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.251-31-gb728ae810f5d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b728ae810f5d168360b0a44f5c774c429b7b7e6a =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
meson-gxbb-p200              | arm64 | lab-baylibre  | gcc-10   | defconfig=
          | 1          =


  Details:     https://kernelci.org/test/plan/id/62cd403751bf30c683a39bdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd403751bf30c683a39=
bde
        new failure (last pass: v4.19.251-7-ga1c8accb5ab1) =

 =



platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
          | 1          =


  Details:     https://kernelci.org/test/plan/id/62cd3aa4bb46993bbba39bf3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd3aa4bb46993bbba39=
bf4
        failing since 84 days (last pass: v4.19.238-22-gb215381f8cf05, firs=
t fail: v4.19.238-32-g4d86c9395c31a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
          | 1          =


  Details:     https://kernelci.org/test/plan/id/62cd3e1f243adba99ea39c23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd3e1f243adba99ea39=
c24
        failing since 63 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
          | 1          =


  Details:     https://kernelci.org/test/plan/id/62cd4291aff6f5e40ca39c2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd4291aff6f5e40ca39=
c2b
        failing since 63 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
          | 1          =


  Details:     https://kernelci.org/test/plan/id/62cd3e371283ea66b0a39bd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd3e371283ea66b0a39=
bd7
        failing since 63 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
          | 1          =


  Details:     https://kernelci.org/test/plan/id/62cd438136de08f471a39be5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd438136de08f471a39=
be6
        failing since 63 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre  | gcc-10   | defconfig=
          | 1          =


  Details:     https://kernelci.org/test/plan/id/62cd3e11243adba99ea39bf0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd3e11243adba99ea39=
bf1
        failing since 63 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
          | 1          =


  Details:     https://kernelci.org/test/plan/id/62cd426aa30ad26d11a39bde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd426aa30ad26d11a39=
bdf
        failing since 63 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
          | 1          =


  Details:     https://kernelci.org/test/plan/id/62cd3e0fab373c7cf5a39bdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd3e0fab373c7cf5a39=
bde
        failing since 63 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
          | 1          =


  Details:     https://kernelci.org/test/plan/id/62cd4269aff6f5e40ca39bf7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd4269aff6f5e40ca39=
bf8
        failing since 63 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
tegra124-nyan-big            | arm   | lab-collabora | gcc-10   | multi_v7_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62cd47fc9fb565561aa39c37

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.251=
-31-gb728ae810f5d/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd47fc9fb565561aa39=
c38
        failing since 21 days (last pass: v4.19.248-223-g5adfc0a345576, fir=
st fail: v4.19.248-223-g2876574ed0069) =

 =20
