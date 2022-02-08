Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2B44AE561
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 00:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236243AbiBHXWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 18:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236198AbiBHXWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 18:22:35 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF694C061576
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 15:22:33 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y7so674621plp.2
        for <stable@vger.kernel.org>; Tue, 08 Feb 2022 15:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PhF6rP62WAprFu4F28lGfiPAHTGelXGA+xJpn9sOcqU=;
        b=6uurHKi2axIwlIGbMXmlLphZ0Fewvvaauqo8zWL+VcE55ltc5cs1ZnN/GvotzyvWH1
         3bA0KON3CEpiQ1f3l/poZuVH/rR42YlFpFO+D/+q+B9/GTbd2FcYWfH80K3iKBFGjr47
         9KUmtrb0I8zgfQrXWyXMQVi59q3vRqAD9c04dyas30/0suMKr/26lKZTODBbojF7zr+c
         RsP4SByijaYrFvat6csgPCycc8ahGAVtrlEmBwSRpCIufY25sLV0u1PIA9+MV2pgFCUt
         NvX1MnP9/FqFisDYtvzBhFIqsznheG9oLmsnZcUZ717SRcw4X+sFv1WpEGP2frci56DW
         0bew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PhF6rP62WAprFu4F28lGfiPAHTGelXGA+xJpn9sOcqU=;
        b=O2qJAcZSe5JpsuBD34aAR7eWz1ARv3E178bW94NvrVmYrCWfP+H/vmxvu2W/DAG+w9
         /NYE424DWXE2tcRAFedVo9bd0WBDJjaYAv7zHHZJ9x6YtMBOJeNpKS8FRdZq+vaYDYAh
         95xIZKxJ0okLbMjHYk6BurUW016nZGAcJJ880+Jef7EPdgrSnJdhQU3qSVJ6IeZ0UUSe
         A/SzYHqGrbNJqo3DIMAXqKVPEVwBH2mEL2HFfqwGMIDY/7u84+N6tB3jYPTt9lBxztcX
         oOXYSwafH2qCZoX3hU0pjTkS1OzKkVI0rNCxEv+rufD4im5o5DN5ay25VNmDZGgPW3G0
         jaoA==
X-Gm-Message-State: AOAM530dLMQNfeCJ0b4aQl6xp98wOl9+kTIhypt+ItcxfNqeiXp4pEll
        qBYAheDuT2W+Hha1KR3hIq3dygzCuZmGltKn
X-Google-Smtp-Source: ABdhPJzVofi4gK2aX/glQrb2zPUOV9keAjPs5ZEJPAnP5Vl50c9ZBPs4PeETLwPx9bMDYAddpb7PoA==
X-Received: by 2002:a17:902:f541:: with SMTP id h1mr6902425plf.94.1644362553294;
        Tue, 08 Feb 2022 15:22:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u33sm17250420pfg.195.2022.02.08.15.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 15:22:33 -0800 (PST)
Message-ID: <6202fb39.1c69fb81.21c59.bb11@mx.google.com>
Date:   Tue, 08 Feb 2022 15:22:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.177-44-gd87bb386a4e2
Subject: stable-rc/queue/5.4 baseline: 139 runs,
 12 regressions (v5.4.177-44-gd87bb386a4e2)
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

stable-rc/queue/5.4 baseline: 139 runs, 12 regressions (v5.4.177-44-gd87bb3=
86a4e2)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm-virt-gicv2-uefi   | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config | 1          =

qemu_arm-virt-gicv2-uefi   | arm   | lab-broonie  | gcc-10   | multi_v7_def=
config | 1          =

qemu_arm-virt-gicv3-uefi   | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config | 1          =

qemu_arm-virt-gicv3-uefi   | arm   | lab-broonie  | gcc-10   | multi_v7_def=
config | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.177-44-gd87bb386a4e2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.177-44-gd87bb386a4e2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d87bb386a4e27077af6fc3ff334956edeed044a8 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm-virt-gicv2-uefi   | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/6202c60175e0a84a66c62984

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6202c60175e0a84a66c62=
985
        failing since 54 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm-virt-gicv2-uefi   | arm   | lab-broonie  | gcc-10   | multi_v7_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/6202c5f02f4b17db62c62992

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6202c5f02f4b17db62c62=
993
        failing since 54 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm-virt-gicv3-uefi   | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/6202c63ee9762061d8c62975

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6202c63ee9762061d8c62=
976
        failing since 54 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm-virt-gicv3-uefi   | arm   | lab-broonie  | gcc-10   | multi_v7_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/6202c63e947acdcdecc6297c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6202c63e947acdcdecc62=
97d
        failing since 54 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/6202c4369e9ee4b181c6296f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6202c4369e9ee4b181c62=
970
        new failure (last pass: v5.4.177-44-g60a800bc1417) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/6202c46fcde714ba2ac629f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6202c46fcde714ba2ac62=
9f2
        new failure (last pass: v5.4.177-44-g60a800bc1417) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/6202c438ad9163716dc62970

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6202c438ad9163716dc62=
971
        new failure (last pass: v5.4.177-44-g60a800bc1417) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/6202c471cde714ba2ac629f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6202c471cde714ba2ac62=
9f5
        new failure (last pass: v5.4.177-44-g60a800bc1417) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/6202c4349b0dcaa114c62992

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6202c4349b0dcaa114c62=
993
        new failure (last pass: v5.4.177-44-g60a800bc1417) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/6202c433ad9163716dc6296a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6202c433ad9163716dc62=
96b
        new failure (last pass: v5.4.177-44-g60a800bc1417) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/6202c435ec04fc0625c6299b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6202c435ec04fc0625c62=
99c
        new failure (last pass: v5.4.177-44-g60a800bc1417) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/6202c41fec04fc0625c62970

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-gd87bb386a4e2/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6202c41fec04fc0625c62=
971
        new failure (last pass: v5.4.177-44-g60a800bc1417) =

 =20
