Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441A04B3501
	for <lists+stable@lfdr.de>; Sat, 12 Feb 2022 13:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbiBLMqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Feb 2022 07:46:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiBLMqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Feb 2022 07:46:53 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8789425D
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 04:46:48 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id l9so5187085plg.0
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 04:46:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RD+tbZbDMlValPedsLLS0LZQvnotbgJxdKw8cOFsfes=;
        b=yKKJwN4dbvZrORBEzm6BYxxskVRmJ8DIUc5yEmuvvZRm42BG3yqtpRsOf4mxF32Mza
         PCn9p4PEAl+nS8mqnhzoeakqo8x8N7onFc5fGggL2M5CRryTUDgsZM5+sNB18amnIYDW
         nDFhLSFZ5E2uyFYq999P6TE1L8FGOTRm8uNjTdIlL+ZXkahpSpyA6JliLlbCTEEc41w2
         X+cbBqo1eEWnLrF5hHtNMDCz/Tnj0qzeuIdWgpZvHU+6GTgF5DkU8QNbMzRr1+zOLWoq
         1xnAXESpAX1mcYR3g3wXWaJpUuiz4rz/sgvpC3cOU0VNJNQbL8IdhA/oybHoj/bbWn3q
         T19g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RD+tbZbDMlValPedsLLS0LZQvnotbgJxdKw8cOFsfes=;
        b=IpOtXH1GeivjEQ4eTKkmarCQxHvXSs0uE6i5OKw6QDzUEg8U/J46j8iIctWJ3oPDMd
         hgP+K2nnov1sNYE2avAiM3PA2Ao2cAyFKfpGyrbblUkZlZh82ELmw4W8HgtVS2tZY3jQ
         N7QdW0Qy+MTLWDNxWrOl07Qi2fvn3rBZueg4YQDgSAlngSfVqSwvN9dljM/kSU9NiHLv
         TMlRO9xV0wvGOsEXx8C9YOwnGWxKbbGne9+g5OTDOW7YrKe5wmrOcRuoOWBqjNILZS/F
         +yw1m9kUHlQui6zr5zLPqndV+nJgUu8wQ3w9OAnG4ibGwk2l0yszNuniJH4Qimw7yZ25
         tlSA==
X-Gm-Message-State: AOAM532Y47Nrg5UMj5qlDeIE9Wyx/kS1oEbGCb/VoTOP2KWfWfE2Ra8/
        vD3RZ026so8cxy2iaCVjWt6kA8+mT4Vyh4ij
X-Google-Smtp-Source: ABdhPJwxguqAq7XIhZFGrQ7L5HX+nSl7E6O64koTvgHsb9WYqqKp4x1FZAVzrmRK9a/ADaIhj2IB+A==
X-Received: by 2002:a17:90b:3e8e:: with SMTP id rj14mr5029482pjb.112.1644670007775;
        Sat, 12 Feb 2022 04:46:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s10sm31789609pfu.186.2022.02.12.04.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Feb 2022 04:46:47 -0800 (PST)
Message-ID: <6207ac37.1c69fb81.96294.e6fc@mx.google.com>
Date:   Sat, 12 Feb 2022 04:46:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.9-72-gf3bfd09ed60d
Subject: stable-rc/queue/5.16 baseline: 98 runs,
 9 regressions (v5.16.9-72-gf3bfd09ed60d)
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

stable-rc/queue/5.16 baseline: 98 runs, 9 regressions (v5.16.9-72-gf3bfd09e=
d60d)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
meson-gxbb-p200            | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.9-72-gf3bfd09ed60d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.9-72-gf3bfd09ed60d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f3bfd09ed60d0a14055aaacc639d1ff70bfc4750 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
meson-gxbb-p200            | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62079175e887df08eec6296f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.9-7=
2-gf3bfd09ed60d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.9-7=
2-gf3bfd09ed60d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62079175e887df08eec62=
970
        new failure (last pass: v5.16.9-19-g9bd22c78af8e) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62077038c5f1aecb37c62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.9-7=
2-gf3bfd09ed60d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.9-7=
2-gf3bfd09ed60d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62077038c5f1aecb37c62=
969
        failing since 3 days (last pass: v5.16.7-106-g04b8b791e123, first f=
ail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62077037fac0d5ee7dc629d0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.9-7=
2-gf3bfd09ed60d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.9-7=
2-gf3bfd09ed60d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62077037fac0d5ee7dc62=
9d1
        failing since 3 days (last pass: v5.16.7-106-g04b8b791e123, first f=
ail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6207703ac5f1aecb37c6296b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.9-7=
2-gf3bfd09ed60d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.9-7=
2-gf3bfd09ed60d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6207703ac5f1aecb37c62=
96c
        failing since 3 days (last pass: v5.16.7-106-g04b8b791e123, first f=
ail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6207704ba1a957f1d9c6299a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.9-7=
2-gf3bfd09ed60d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.9-7=
2-gf3bfd09ed60d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6207704ba1a957f1d9c62=
99b
        failing since 3 days (last pass: v5.16.7-106-g04b8b791e123, first f=
ail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6207703bc5f1aecb37c62971

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.9-7=
2-gf3bfd09ed60d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.9-7=
2-gf3bfd09ed60d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6207703bc5f1aecb37c62=
972
        failing since 3 days (last pass: v5.16.7-106-g04b8b791e123, first f=
ail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62077038fac0d5ee7dc629d6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.9-7=
2-gf3bfd09ed60d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.9-7=
2-gf3bfd09ed60d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62077038fac0d5ee7dc62=
9d7
        failing since 3 days (last pass: v5.16.7-106-g04b8b791e123, first f=
ail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6207708a0eb446cd33c6298d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.9-7=
2-gf3bfd09ed60d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.9-7=
2-gf3bfd09ed60d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6207708a0eb446cd33c62=
98e
        failing since 3 days (last pass: v5.16.7-106-g04b8b791e123, first f=
ail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6207704da1a957f1d9c6299d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.9-7=
2-gf3bfd09ed60d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.9-7=
2-gf3bfd09ed60d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6207704da1a957f1d9c62=
99e
        failing since 3 days (last pass: v5.16.7-106-g04b8b791e123, first f=
ail: v5.16.7-127-g3b11c0b71857) =

 =20
