Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BECC526A91
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 21:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383891AbiEMTjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 15:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383685AbiEMTjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 15:39:37 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D664CD4D
        for <stable@vger.kernel.org>; Fri, 13 May 2022 12:39:35 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id x52so8502760pfu.11
        for <stable@vger.kernel.org>; Fri, 13 May 2022 12:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FNdYHJ01OmTM5fMBHEJrgn9EDMDYtwx0OPjYaYk71aI=;
        b=o8o5/1enEmVuMAe68ZwWUCJVYpFZ33uHPTm9oGiomb7iukVNwrU4IV2B2W4JlMb6iN
         8gKxaG98h0EesGJGewxSo5KmOqzVD7EjSJAe/SsQEf0BGH3BH50iFlECnM2hgC+gKD5L
         HSnR+/JJxbSvT9vpsVQoA3idMnP19vnbYZ1wyVO+DnT/SYocn4y39w0laspDBA7/R0Qr
         jow+qm2Ga4+Zpqb4lSZE4cXmF/BL4tvnXhTfq/XLJW5CCzPMk6LKC2TNhsUMCSYSNszS
         oExO+VlhrB2+vJcbRR+WNaLJqAiagRcwEJQLgOFlHLANeRCLVWvhmQMggvioYrm9/Eg0
         V0Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FNdYHJ01OmTM5fMBHEJrgn9EDMDYtwx0OPjYaYk71aI=;
        b=cMAj/OW9PpNWnUs+KGAnAVU8Go2ZbZ/Kyq/glP9gXY2FhricF8oFwAL/aHKc06TPD1
         FdqZpJTNYY8txwJ6PC5WMivcVfFpXjw+uhsR6a/lUmwfF/RBNsux8EuRXCjLrVNV9S5L
         rUSBpC2MUGc6W/UlNYuaUkDWYPl1kbhJmGFXUT2I7Dxikj24lpOlx7NQcHrNmBNQ1Twt
         CwewUkjIAxkduTywmGsKLeNifuFrh3sBWaRPLulv8NX+82aqHXRNyIXloe8ZCG4lDgB1
         2dwdP1CDvYgNWBh7TlqV17UeaMoSC86RXhWWwXgDlORByYLdjZ6cPCbvy92xHIKicNvA
         HdBg==
X-Gm-Message-State: AOAM531GjxoOwfll5nICijtQJEBsngSlfaix+/jqoBUnGI0PsNECmWII
        CDJf6ZBfY7LeWi/Dr3MSwjHEKzHAmGvTQCsMkiw=
X-Google-Smtp-Source: ABdhPJzAOuqo9fOi1ladz+4mQn0hJdFmApPs8szuiXwML1GuXGJXWg+hQNGHFjnZ+igG5NpItim6Ng==
X-Received: by 2002:a65:4882:0:b0:3c2:8f35:5d1b with SMTP id n2-20020a654882000000b003c28f355d1bmr5249959pgs.80.1652470774139;
        Fri, 13 May 2022 12:39:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h6-20020a62de06000000b0050dc7628171sm2177258pfg.75.2022.05.13.12.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 12:39:33 -0700 (PDT)
Message-ID: <627eb3f5.1c69fb81.4adc.5914@mx.google.com>
Date:   Fri, 13 May 2022 12:39:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.313
Subject: stable-rc/linux-4.9.y baseline: 47 runs, 17 regressions (v4.9.313)
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

stable-rc/linux-4.9.y baseline: 47 runs, 17 regressions (v4.9.313)

Regressions Summary
-------------------

platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
d2500cc                    | x86_64 | lab-clabbe   | gcc-10   | x86_64_defc=
onfig           | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-baylibre | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-baylibre | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-broonie  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-broonie  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-baylibre | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-baylibre | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-baylibre | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-baylibre | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-broonie  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-broonie  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-baylibre | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-baylibre | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.313/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.313
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ba9e8be3cfa31c2b7c0941e2dd7a11e86ef79672 =



Test Regressions
---------------- =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
d2500cc                    | x86_64 | lab-clabbe   | gcc-10   | x86_64_defc=
onfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/627cfce13d36b8088a8f5717

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/x86_64/x86_64_defconfig/gcc-10/lab-clabbe/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/x86_64/x86_64_defconfig/gcc-10/lab-clabbe/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/x86/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/627cfce13d36b80=
88a8f5720
        new failure (last pass: v4.9.312-67-gbc7a724ac0ce)
        1 lines

    2022-05-12T12:26:00.019002  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2022-05-12T12:26:00.030501  [   12.143435] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2022-05-12T12:26:00.030841  + set +x   =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-baylibre | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/627cfe0b2c7d4a632d8f572d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627cfe0b2c7d4a632d8f5=
72e
        failing since 2 days (last pass: v4.9.312-44-g77a374c13dc5, first f=
ail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-baylibre | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627cfe3239352832ba8f572e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627cfe3239352832ba8f5=
72f
        failing since 2 days (last pass: v4.9.312-36-gbfd3fd9fa677, first f=
ail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-broonie  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/627d0670d150bb1db08f5735

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d0670d150bb1db08f5=
736
        failing since 2 days (last pass: v4.9.312-44-g77a374c13dc5, first f=
ail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-broonie  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627d06fc979848c6f08f572b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d06fc979848c6f08f5=
72c
        failing since 2 days (last pass: v4.9.312-36-gbfd3fd9fa677, first f=
ail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-baylibre | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/627cfe1f2c7d4a632d8f5738

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627cfe1f2c7d4a632d8f5=
739
        failing since 2 days (last pass: v4.9.312-44-g77a374c13dc5, first f=
ail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-baylibre | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627cfe5a0db3564aed8f5741

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627cfe5a0db3564aed8f5=
742
        failing since 2 days (last pass: v4.9.312-36-gbfd3fd9fa677, first f=
ail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/627d06857dbc36243f8f5725

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d06857dbc36243f8f5=
726
        failing since 2 days (last pass: v4.9.312-44-g77a374c13dc5, first f=
ail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627d07db0052da1efb8f573a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d07db0052da1efb8f5=
73b
        failing since 2 days (last pass: v4.9.312-36-gbfd3fd9fa677, first f=
ail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-baylibre | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/627cfe0c217e0e9a9a8f5720

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627cfe0c217e0e9a9a8f5=
721
        failing since 2 days (last pass: v4.9.312-44-g77a374c13dc5, first f=
ail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-baylibre | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627cfe33a5c46b6cfb8f5737

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627cfe33a5c46b6cfb8f5=
738
        failing since 2 days (last pass: v4.9.312-36-gbfd3fd9fa677, first f=
ail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-broonie  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/627d0671d150bb1db08f5738

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d0671d150bb1db08f5=
739
        failing since 2 days (last pass: v4.9.312-44-g77a374c13dc5, first f=
ail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-broonie  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627d07d80052da1efb8f5725

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d07d80052da1efb8f5=
726
        failing since 2 days (last pass: v4.9.312-36-gbfd3fd9fa677, first f=
ail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-baylibre | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/627cfe1e90f94070e58f571b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627cfe1e90f94070e58f5=
71c
        failing since 2 days (last pass: v4.9.312-44-g77a374c13dc5, first f=
ail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-baylibre | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627cfe35a5c46b6cfb8f573a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627cfe35a5c46b6cfb8f5=
73b
        failing since 2 days (last pass: v4.9.312-36-gbfd3fd9fa677, first f=
ail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/627d0673cbd6273fff8f5751

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d0673cbd6273fff8f5=
752
        failing since 2 days (last pass: v4.9.312-44-g77a374c13dc5, first f=
ail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                | regressions
---------------------------+--------+--------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627d07d90052da1efb8f5729

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.313=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d07d90052da1efb8f5=
72a
        failing since 2 days (last pass: v4.9.312-36-gbfd3fd9fa677, first f=
ail: v4.9.312-60-g806e59090c6c) =

 =20
