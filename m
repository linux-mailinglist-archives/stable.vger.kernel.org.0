Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6BE61A1ED
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 21:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiKDULy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 16:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKDULx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 16:11:53 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FD242997
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 13:11:51 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id b185so5423523pfb.9
        for <stable@vger.kernel.org>; Fri, 04 Nov 2022 13:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Wo44HeO8/0Q+voBpFfj5bDgFGlHgdwwhgklOIGg/Skc=;
        b=rjOx/5lVLm2VkQX9uWlfr8nt3PGMLJZcPU3+BhG8fM00FBpHLF63IRo7n6ezjK/s4q
         /BLk4zT1GjK7x3hJm2ejZ30DW4w/GeHMvn43c4DajalCjeJ9I/FZhd1uTvX1uD4BEu5n
         uZBCDFQ66BdsllhiP6brLNiTmUfJ0oJqkhzrxJVj0nT1RVGQuo3ppx06DEx5mVDK+uWT
         zUgCaQcY2KI0/aormgy8umNTpYT3/VPWwJwpWZwaF/O+y5Kcs4evzNAAT1wXh1nrSPXF
         VbRArHu2pDUHbWqnlxucBkJIjQ8uamWYM/CQTLGCu4XObrawS46xElXhRmYhqFLinrVy
         wvTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wo44HeO8/0Q+voBpFfj5bDgFGlHgdwwhgklOIGg/Skc=;
        b=GKwbNo2PwQY9X/yzw3Hkp1uMoA4e4S1jXc9eiC9rISyOYA4VGe0oGuBbxu+eXp3WV0
         aNfJ/UGOYDdrGVwY3RDVFwBju83MRlELIfX50BOhmypVEiW3Gd9LW43fv9FuIRbhZg1t
         qwLuWJAAA0bkzHj3zz8LBW4/CyBk4jxkHqUu1qGCIVnrYOZCoq0drtmEKok/Y/0bOvmr
         PTFMuzgIFwEuN/1ZzaVj5xTfZ48hofDLn9YdviqB70zg5h3OuHD7/Tz6IF6Q8W404phn
         9jEo7G9mbChfKpXZVcmSQHjbf9WIK0QBJ2i/gt2MovvclY2Z49oXi8uTH9hv7fwkrzBy
         Svpw==
X-Gm-Message-State: ACrzQf03Yi0dYoCzrU0+kWXbS/B0CIMqHdL4kQ7kOn6RPiw2MemmhXtC
        P2ccOZKlQOr38pJaVjIM590DtYfMlp7yK9G6
X-Google-Smtp-Source: AMsMyM6KsA7fMSU7husxH0WE+CIO45Mq9xrXCCMA0jsm9LYffdxD7FKPkUryfttIX1ckReYxhNje0A==
X-Received: by 2002:a65:6b8f:0:b0:46f:c6e0:e259 with SMTP id d15-20020a656b8f000000b0046fc6e0e259mr22859239pgw.521.1667592711031;
        Fri, 04 Nov 2022 13:11:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y5-20020a63e245000000b004582e25a595sm125689pgj.41.2022.11.04.13.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 13:11:50 -0700 (PDT)
Message-ID: <63657206.630a0220.6bd8a.06b1@mx.google.com>
Date:   Fri, 04 Nov 2022 13:11:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.76-148-g47f00ad96c810
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 172 runs,
 6 regressions (v5.15.76-148-g47f00ad96c810)
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

stable-rc/queue/5.15 baseline: 172 runs, 6 regressions (v5.15.76-148-g47f00=
ad96c810)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
bcm2711-rpi-4-b              | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =

sun50i-h6-pine-h64           | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.76-148-g47f00ad96c810/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.76-148-g47f00ad96c810
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      47f00ad96c81065b06ef4b30cbe2d2161fdb1ee3 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
bcm2711-rpi-4-b              | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6365449a2c0e80d5f8e7db60

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.76-=
148-g47f00ad96c810/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-rp=
i-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.76-=
148-g47f00ad96c810/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-rp=
i-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6365449a2c0e80d5f8e7d=
b61
        new failure (last pass: v5.15.76-132-ged6793a62468b) =

 =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6365449bff8e5105d5e7db62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.76-=
148-g47f00ad96c810/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b=
-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.76-=
148-g47f00ad96c810/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b=
-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6365449bff8e5105d5e7d=
b63
        new failure (last pass: v5.15.76-132-ged6793a62468b) =

 =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
qemu_arm64-virt-gicv2        | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6365449675714c3766e7db52

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.76-=
148-g47f00ad96c810/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.76-=
148-g47f00ad96c810/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6365449675714c3766e7d=
b53
        new failure (last pass: v5.15.76-2-ge48d39a364d8) =

 =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6365448f2e0bd3eb47e7db68

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.76-=
148-g47f00ad96c810/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.76-=
148-g47f00ad96c810/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6365448f2e0bd3eb47e7d=
b69
        new failure (last pass: v5.15.75-79-gc1cca05570bf) =

 =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/636544982c0e80d5f8e7db4f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.76-=
148-g47f00ad96c810/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.76-=
148-g47f00ad96c810/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636544982c0e80d5f8e7d=
b50
        new failure (last pass: v5.15.76-126-gf1f82287ab82) =

 =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
sun50i-h6-pine-h64           | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6365449e23020c7a40e7db78

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.76-=
148-g47f00ad96c810/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-=
pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.76-=
148-g47f00ad96c810/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-=
pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6365449e23020c7a40e7d=
b79
        new failure (last pass: v5.15.76-132-ged6793a62468b) =

 =20
