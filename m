Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2913F502D83
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 18:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbiDOQLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 12:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiDOQLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 12:11:03 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5797C9E9CC
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:08:31 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id s14so7435178plk.8
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jWNgXBcazy8DJDFTjOGuuo6Ygx6ZrXGANL+rudj+RVc=;
        b=w1O8pbfbOdbLKCyTVmTSDO0QqDeZ1u6hoPTgpJCaQDEurN8YOl1s+f63juitYq4/cl
         7prQS+XEHo8OU9KFazSlBBBtxCdnguDhmHgjo0RClcyrvcbEt38GZ7EO30fNaeugeR84
         tBVe+1IRnCRaOQL43M6TSaeITHQiDGjhPhKaAabwUa7k1LK6Mr/b+aRiMiqw245B+8iE
         89EUdCrZqNxMmA24MSanmy/KVcpFBR3Dfp/sHG79A63r59CKaP+bFWhm28IT5jU/2tDT
         gkHIgjjAqh1hSzZukorCGSvKHcptn4VCuB3yzPjugQ19RaFMMQ+ZCne1AjccFHUgpXR2
         1PWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jWNgXBcazy8DJDFTjOGuuo6Ygx6ZrXGANL+rudj+RVc=;
        b=LCcJBYUUPzN3Y3d3IGwmXcPOTbZDApCrokcK9f4nBxoToCwfWOktgXSL2hgMF8kqGb
         5r0MycVJE5ckPfXiKK0DevzF1dCsEQhKmIbAQzdtkNqO1qFABBSNHTBBHu0gW1D7Vfd3
         xFtr7eAVH9rLhXZnjoI+U64DNxtmOlBgfNbUhUxc6p83FmhgP9sAhTywoFrN9Xk4ucjP
         qomfBy14xfYZ7O8A6Nhz8RHAUWoT+3ufWaBz0ZCJ9bMXBCXLxs6APpUzPs07efAVqdH5
         gHqcB+P2KiioPkwRciiWnHFBTAqY6gMpu/+/xg0nr+44zY7WMq7HDEElDIjYYqyG+lof
         R38A==
X-Gm-Message-State: AOAM530qbLiPzd4Wqaei67JVOCBJTQyxeW80hLZYN05xrwXED/QnNpyW
        qIUoe/RByrmZJ532j/FFna+5VNku+gcBu7kg
X-Google-Smtp-Source: ABdhPJwwUVZtjEsZ9rv63JFC84cQGXLLuZOetKc8XhB+CkdlcwGbZ3tJmp8MqgW+HFE4eQxfB9P1/w==
X-Received: by 2002:a17:902:70cb:b0:158:424e:a657 with SMTP id l11-20020a17090270cb00b00158424ea657mr29470015plt.6.1650038910691;
        Fri, 15 Apr 2022 09:08:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y9-20020aa78f29000000b005098201d2f5sm3074198pfr.205.2022.04.15.09.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 09:08:30 -0700 (PDT)
Message-ID: <6259987e.1c69fb81.ed84a.8397@mx.google.com>
Date:   Fri, 15 Apr 2022 09:08:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.188-472-g8abb60681fefa
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 128 runs,
 4 regressions (v5.4.188-472-g8abb60681fefa)
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

stable-rc/queue/5.4 baseline: 128 runs, 4 regressions (v5.4.188-472-g8abb60=
681fefa)

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
el/v5.4.188-472-g8abb60681fefa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.188-472-g8abb60681fefa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8abb60681fefafd81e185b9e34b90aed1853de5a =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/625961e91a24eb3c0eae0683

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
72-g8abb60681fefa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
72-g8abb60681fefa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625961e91a24eb3c0eae0=
684
        failing since 120 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/625961e08704c15a49ae067f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
72-g8abb60681fefa/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
72-g8abb60681fefa/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625961e08704c15a49ae0=
680
        failing since 120 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/625961f62826e62f02ae068f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
72-g8abb60681fefa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
72-g8abb60681fefa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625961f62826e62f02ae0=
690
        failing since 120 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/625961deb14cf39625ae0682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
72-g8abb60681fefa/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
72-g8abb60681fefa/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625961deb14cf39625ae0=
683
        failing since 120 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =20
