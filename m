Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98258586D04
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 16:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbiHAOkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 10:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiHAOkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 10:40:19 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6088114F
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 07:40:18 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id x2-20020a17090ab00200b001f4da5cdc9cso5403242pjq.0
        for <stable@vger.kernel.org>; Mon, 01 Aug 2022 07:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TXZRLR9Nu+S/3WFqxk1Ypn4WQReTQor8mG/9CtRCHSM=;
        b=ClxdI+kHGGD42zeENlStvDkN2xrnc3h/22Ag+ydHZuvW5rzV1cJp4jiRlMjFGtAy9y
         sboAUaJDnIaaYSM9NJ+2Li2CcvCyXCz6gCc4ibGTt4vkxDRjfEZFWdD5Y8//Vplwiv2a
         ouffz1xCr2XUq5bmtZKPsscSHEsOUmzhT13iMYTrJ0usrEr5tnJCbGqZD9RTnOzUFxRP
         dmVD1DT5teLaG5OE+G3Veym5csmB0zUf5mSI92uYurdkhs8A0QJwVqPtZ+/KcKh8Cgjd
         V1WH//oLcEE23nENNJfrhm9m1JEMj/8SBhTJ/W1ej+P8Hw4a8PPaCL/2vkVyjbxjvCZ5
         iTbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TXZRLR9Nu+S/3WFqxk1Ypn4WQReTQor8mG/9CtRCHSM=;
        b=ceaWltTnDfCyuCSujpwJoo9uYacnZ8wIWM4BhmhGulGy1N/IrcWRLttoRWH+TSjC8A
         Dr271zT1S+6YgvrUU4r5Q5xnscOGSEiQa216qohM5EOfWT65l8RTZeREQyCrg5F33QUx
         zJ3w1H7EH7LxppkYOFmdYI1S9Y6xNBkUPvZ+EywSrDrtuifaEPosf0mjGx+s3Un+gr7z
         zV6HgQwfjUn35b1HxjItnv8tZYE38fIbR4F7S3/J3kf4WyJbdggRPf0nsBKHB11rKNuo
         qJ0RTi1QHGJzC8N3gVYgTy0k7SVJGu9z4pCet75WRlZU8ZKSJJlPWDcA9w/5hhY7jAQg
         r+rw==
X-Gm-Message-State: ACgBeo1tc23zBgh77uEtTTBfpKIWvgRmnzs/wXw9y4QPpQLihsTu7iUV
        WDLOOfcvEH8TfglBs+u+Sbfg1wVWKQmf87rCL2Y=
X-Google-Smtp-Source: AA6agR4Ik7kEi1szhzPqbl0HpZnXVlERU5MF2fNr7sk41StovOgxt5EjsjYAWd0fRh+mE/qBPXpLfA==
X-Received: by 2002:a17:903:2301:b0:16e:f916:22b4 with SMTP id d1-20020a170903230100b0016ef91622b4mr2170732plh.52.1659364818129;
        Mon, 01 Aug 2022 07:40:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kk15-20020a17090b4a0f00b001f51903e03fsm416425pjb.32.2022.08.01.07.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 07:40:17 -0700 (PDT)
Message-ID: <62e7e5d1.170a0220.1e75c.096e@mx.google.com>
Date:   Mon, 01 Aug 2022 07:40:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.207-122-gcdd4fb2783c6
Subject: stable-rc/queue/5.4 baseline: 48 runs,
 4 regressions (v5.4.207-122-gcdd4fb2783c6)
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

stable-rc/queue/5.4 baseline: 48 runs, 4 regressions (v5.4.207-122-gcdd4fb2=
783c6)

Regressions Summary
-------------------

platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.207-122-gcdd4fb2783c6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.207-122-gcdd4fb2783c6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cdd4fb2783c6a6a1bc26b2a3bf8561126c24b01f =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e7b52945b15bde9edaf061

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-gcdd4fb2783c6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-gcdd4fb2783c6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e7b52945b15bde9edaf=
062
        failing since 83 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e7b52ad5208e157adaf057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-gcdd4fb2783c6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-gcdd4fb2783c6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e7b52ad5208e157adaf=
058
        failing since 83 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e7b5125cd77736b2daf059

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-gcdd4fb2783c6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-gcdd4fb2783c6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e7b5125cd77736b2daf=
05a
        failing since 83 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e7b526e1af97e2f2daf06e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-gcdd4fb2783c6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-1=
22-gcdd4fb2783c6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e7b526e1af97e2f2daf=
06f
        failing since 83 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =20
