Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C981E500428
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 04:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbiDNC2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 22:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiDNC2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 22:28:42 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EFC43AEE
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 19:26:19 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id bd13so2901407pfb.7
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 19:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p0mqjJIYQuhWlWiOWaDMpdUoY4Cl4a8aCJEnF1jbFlA=;
        b=hQpqvc/9cBStg2I5ztnUWYMvgLSPHgotxjmc3dYnqttE2PNL3RgmqHzT8O8WP83XCs
         xQyaXlGSqF/VALnBE323afHCU06zNIX30Hn0vbv9cGY83XDcBHnTTY+dXsiraEIcS+HA
         ALAs+03aC2wR/5E/dEAbS35YDrHHuYioPcynLqxmLLKy8h1fapLDhcGxskI8AFlTNxCm
         7/BHZ70JCOYvUcWssMfP0a5jP8AvFVPjqI5lERDJQmc/56xI+WFNR76ReP44NYqiiBYy
         NRJQgBpo8cnx4zFoyLLlpPg0JWCbwwTWrqVlgd6hP69ftOyE6RxoO4r45qQ9HA47CxWc
         UniQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p0mqjJIYQuhWlWiOWaDMpdUoY4Cl4a8aCJEnF1jbFlA=;
        b=4Kvsrd2z7KhPIYEaooXhAia/kYrbdyZ65Tb17GP45CoQYaVsu9QAI1y+xn1jFZfwIu
         Xhk3lPk+jb51Og/yUbfAzRDop5Wj6FmpkCtMd3+GgUPvEUKp4qoTZexKMu9KGXJSijXc
         8kqe3WzekbiQv+Rgaw/tihzY4BPE5CWD6LnzcsZHZ1sBrGRS2Ajf/+lgaslDFnvcuIDr
         xc3uD4H4gNIRaqJ4XJQy/HIluxXTk2bXzF8nwKYBpdk8PKsiB0Qe3bgIfSxc/hSIUdrj
         oiCwpnfjpyxVKchC/EnYY4ey1DVNCMbFBNwZMWVyena62M3eFD0tQODq7R5X4fGKHK7I
         oI1A==
X-Gm-Message-State: AOAM531TPqRWcZbvRRJjVdxf+BIGF6MPUxMlo8VYGn8mJ4aW9RdGfiBe
        tOUOmARXYM8mXxXAuDPsUIzFz4GUz0j3Y8Xo
X-Google-Smtp-Source: ABdhPJw0S3hWeDwLAyh6udjk4Qg7ufKf2jy2Uzj7RBe+dVyq0MBv41D6HauiBmKBal122pUvQG5WAg==
X-Received: by 2002:a05:6a00:14cb:b0:4fb:2c72:1fdc with SMTP id w11-20020a056a0014cb00b004fb2c721fdcmr1673213pfu.55.1649903178693;
        Wed, 13 Apr 2022 19:26:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c74-20020a621c4d000000b00505be1ae39bsm396250pfc.9.2022.04.13.19.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 19:26:18 -0700 (PDT)
Message-ID: <6257864a.1c69fb81.d63a8.1af7@mx.google.com>
Date:   Wed, 13 Apr 2022 19:26:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.188-466-gf97a02b569e2
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 102 runs,
 4 regressions (v5.4.188-466-gf97a02b569e2)
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

stable-rc/queue/5.4 baseline: 102 runs, 4 regressions (v5.4.188-466-gf97a02=
b569e2)

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
el/v5.4.188-466-gf97a02b569e2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.188-466-gf97a02b569e2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f97a02b569e2873c45857f58d104cef21a533bc5 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62575a3d7d8e8026a9ae0698

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
66-gf97a02b569e2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
66-gf97a02b569e2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62575a3d7d8e8026a9ae0=
699
        failing since 119 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/625755a9c3a61bc0daae0686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
66-gf97a02b569e2/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
66-gf97a02b569e2/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625755a9c3a61bc0daae0=
687
        failing since 119 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62575a2851609e2920ae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
66-gf97a02b569e2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
66-gf97a02b569e2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62575a2851609e2920ae0=
67d
        failing since 119 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62575594c3a61bc0daae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
66-gf97a02b569e2/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
66-gf97a02b569e2/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62575594c3a61bc0daae0=
67d
        failing since 119 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =20
