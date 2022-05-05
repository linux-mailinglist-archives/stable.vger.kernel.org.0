Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4D251B616
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 04:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239859AbiEECu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 22:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239845AbiEECuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 22:50:55 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3C628E0B
        for <stable@vger.kernel.org>; Wed,  4 May 2022 19:47:18 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so6784582pjb.5
        for <stable@vger.kernel.org>; Wed, 04 May 2022 19:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HbxEAlC7pJpMSRVns7qcyidtkj1cvoLY1kZTz/bcI5s=;
        b=ypdoqShbIKWwxMYXeL7Ye3uQ+vFsGaCoX2X5oTxYUZSJXKTGqeicqMGBjSJY8Vb2td
         p/nR1cJOTkpzBPtqFVjHYxOyFAksJNZzNzE7cA6EFv6RJxmlVofBv1lauZpVIYUedEWM
         ALrodkS8ejHGasct1SuhRyc1d11vaH+SNBF5hI4RPMxxwT4mf+JsSE8V5Hld8tNScnzV
         5hA9qwn+BJ4in2IZHJ89Wfu+jMbNAUdMbhEE3xLbk0aXREscDJntX81kpx4ugWyRhOnp
         Kv3oBWxTtLlgolUJDuie9C7/io4g7YeAii9xgy+zsf5rGGuN6/OlZEHIu/LMzSrcT4nP
         knGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HbxEAlC7pJpMSRVns7qcyidtkj1cvoLY1kZTz/bcI5s=;
        b=m1LEE8O0u7McS/UPjQWvK58sWNpKfPzqxh8ENB8xVMCwCGfjYxbdwFH/+hIrE0h/RP
         BjkpFMlXN1X6egpaapUCAXbwY71d2UaRKezi1JUy8WjPD+8DWF8QzdytTo2kZugM9kXL
         JCOWRGfTrCA9SN1T63Q1lPKDcLp2XIWySpo59GHsLrpwW0wf9eiFrD+lgpytIbjTFsXT
         vhoU1rNbbRT4v65GK2PU40yz8b78AP6g2or/bZx+OpAyfJ7ex7QZRJMmsgS+OXvbnQVu
         VuKIdebpXJFIO6vIAxqJCFU5VroZT2I1FaLGghoBCpkmK7+LG/Xuse2OChnRPoDFaCOV
         uslQ==
X-Gm-Message-State: AOAM530ev95Zt9rRITIORwM1Ay5rnlrN7sDk3kJDDzyH8IlXJyTSNdWl
        Ef2yhShaqrW0d8u5TF1agUIcP6na4ZOk5mZuK88=
X-Google-Smtp-Source: ABdhPJyLPmMghxKvpchKGrH/pgokWpk3Sx5wP0hfeMjVPmE/J1+CHGgt8htvEFIzKbNmr3XuGFvw/g==
X-Received: by 2002:a17:903:2281:b0:15e:95f7:37d1 with SMTP id b1-20020a170903228100b0015e95f737d1mr22052864plh.18.1651718837483;
        Wed, 04 May 2022 19:47:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u2-20020a170902e80200b0015e8d4eb1casm234093plg.20.2022.05.04.19.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 19:47:17 -0700 (PDT)
Message-ID: <62733ab5.1c69fb81.e65a7.0e49@mx.google.com>
Date:   Wed, 04 May 2022 19:47:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.191-84-g56ce42d78d96
Subject: stable-rc/queue/5.4 baseline: 98 runs,
 4 regressions (v5.4.191-84-g56ce42d78d96)
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

stable-rc/queue/5.4 baseline: 98 runs, 4 regressions (v5.4.191-84-g56ce42d7=
8d96)

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
el/v5.4.191-84-g56ce42d78d96/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.191-84-g56ce42d78d96
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      56ce42d78d9673f94834dbd41a514eb0f887ecc7 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6273072946dafb7d028f5717

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
4-g56ce42d78d96/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
4-g56ce42d78d96/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6273072946dafb7d028f5=
718
        failing since 140 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/627306ed270284b4388f573c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
4-g56ce42d78d96/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
4-g56ce42d78d96/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627306ed270284b4388f5=
73d
        failing since 140 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/627307015145a28c328f571b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
4-g56ce42d78d96/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
4-g56ce42d78d96/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627307015145a28c328f5=
71c
        failing since 140 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/627306d91c3717b9b88f5770

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
4-g56ce42d78d96/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
4-g56ce42d78d96/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627306d91c3717b9b88f5=
771
        failing since 140 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =20
