Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4964D5FDF1D
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJMRh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJMRhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:37:55 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292CF2F021
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 10:37:54 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y1so2584513pfr.3
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 10:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=vpOGx/s6Jl2VhzZMhlHU6zEUXbAAGUKpOO2rF4vvnZc=;
        b=UcxtPZ9dlCL+OwJ7TX1Z8JSxsAQjy54gvE6eNNZcFQOpr5zeSzeHjTAkURbjirsHsp
         SYevVptYGW6H2l6Hy6tpUVRTZY0TknrnCkX0kBFN+U3UN2Cd4qS1d7lYJTo9rdwJnCnJ
         rMFFBdS9BfGMwlzE7uVjDMs/8KFeXNmZ/BkZHFUPVAT0iY/X4LDG3y+XwK6AuQt0Y143
         0AqpFtMIa+uy5Spuhbd2Y0eIsSM98nv+BcQhY8exbZYXLT8tlv31QW9md374eCVsS1D5
         nkuJNvPezUPDH+ZEDpXeDDsW7ZOe/7OORArgNQKZwD3dADSybysJuWnGxcgpGedU4zsN
         UGMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vpOGx/s6Jl2VhzZMhlHU6zEUXbAAGUKpOO2rF4vvnZc=;
        b=SxfX/Ngpbye04pL2lh4CDpwStjiTrLL/PPQqwUnCo9mAokL5meLUNuucrbtsNJHX6r
         GhGpP+Ntt1SJcQnc//3BSToouHVftnxRk0gzt9bXjej/BZc5yEmFIv8QosfMfqGjNyGx
         2nwi0IbYHK65sVZyvHYOPUlmDeCHA6Q+JVEPAt7v+PQ8Qt7ceEcIMpsQLZIQ3Zudk2Ms
         OOQau5iU+ddk7CDMjK6FaKvS/gmudYndsXQ6RHtFVXfCa4819Zw/LT5OLi3gVcKePNVS
         0sm4uIF5VVK36UskXZoedca2Q7A3BtgsVJEgBg7wWG1imDXDXLZyeU2x5voD5yVeFgh1
         zqGQ==
X-Gm-Message-State: ACrzQf15Q8DX+33tssdRqh1EQgSLjF5FEJuk53I1d8wfBXqEIDMZvkkI
        2MRHr6+SWPkXFqpAaRizC1xqo4KZ4dtUwjH3wwI=
X-Google-Smtp-Source: AMsMyM6TnP4wPzSs1z+lY2tp/ZIOL24O747zloWZAdFRU8CzAbw6XFEl2rq/iNj7du9mLxuJizplYA==
X-Received: by 2002:a63:6b83:0:b0:460:c07c:553b with SMTP id g125-20020a636b83000000b00460c07c553bmr845814pgc.209.1665682673438;
        Thu, 13 Oct 2022 10:37:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 7-20020a620507000000b00540f96b7936sm2299063pff.30.2022.10.13.10.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 10:37:52 -0700 (PDT)
Message-ID: <63484cf0.620a0220.2474c.4fd3@mx.google.com>
Date:   Thu, 13 Oct 2022 10:37:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.147-34-g8752b44adb0a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 125 runs,
 4 regressions (v5.10.147-34-g8752b44adb0a)
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

stable-rc/queue/5.10 baseline: 125 runs, 4 regressions (v5.10.147-34-g8752b=
44adb0a)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.147-34-g8752b44adb0a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.147-34-g8752b44adb0a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8752b44adb0a1bfbfa310fde2a3db83a3ec7a01a =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/63481cf695e7c72987cab615

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.147=
-34-g8752b44adb0a/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.147=
-34-g8752b44adb0a/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63481cf695e7c72987cab=
616
        failing since 78 days (last pass: v5.10.101-110-ge437828b3a54, firs=
t fail: v5.10.133-85-g4c4562ba4bd5) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/63481d0b95e7c72987cab665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.147=
-34-g8752b44adb0a/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.147=
-34-g8752b44adb0a/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63481d0b95e7c72987cab=
666
        failing since 78 days (last pass: v5.10.101-110-ge437828b3a54, firs=
t fail: v5.10.133-85-g4c4562ba4bd5) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/63481cf895e7c72987cab61b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.147=
-34-g8752b44adb0a/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.147=
-34-g8752b44adb0a/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63481cf895e7c72987cab=
61c
        failing since 78 days (last pass: v5.10.101-110-ge437828b3a54, firs=
t fail: v5.10.133-85-g4c4562ba4bd5) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/63481cf795e7c72987cab618

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.147=
-34-g8752b44adb0a/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.147=
-34-g8752b44adb0a/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63481cf795e7c72987cab=
619
        failing since 78 days (last pass: v5.10.101-110-ge437828b3a54, firs=
t fail: v5.10.133-85-g4c4562ba4bd5) =

 =20
