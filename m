Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DACD3C93E8
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 00:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235267AbhGNWgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 18:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhGNWga (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 18:36:30 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B3EC06175F
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 15:33:38 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id k20so3994148pgg.7
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 15:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IsxizJRkZWrHnnto7Wt0OtIKbcnMV/2C4RyT04VofgU=;
        b=ygbuEIULAInX2NeXPy+JVGS76MzNv3flLiQSRB0ripaKRGyWo16zGHRZJD3f0uUQK0
         uf9KFoE+glx3SR/xTR9q6hRfXZsIENkbpH528BxwVaFIlkJNyP47M9qeRCFI4edJDolL
         7ueTQ8IrIQwwSzHLi6FYIbzW+eZ0bb1HBk3zWRQCS/E0ixvU2BuKPldbDjxxlQl9siC4
         vYSN570q+b9qt06EogCZC8YTxnttK123p06WkkdoS0dpL70M3C4KjGHCrG1iHZY/WfhE
         OdDGryuMvU23yKTEavkEDBmgZqImAzBHnkXu9ibrOFREpUsLi+oTha64i7fnVDuvLdaW
         sNSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IsxizJRkZWrHnnto7Wt0OtIKbcnMV/2C4RyT04VofgU=;
        b=B4m1WfMtSayS8oonTOahakmD8kKZRYtr5Oh3aqXDodZ8CVR7yrJ9RjGmi3xjfjYNrS
         X1klctxhOm85ruXnnLjIcsXIpF3HKLG02gc0I1IPQ0Uy0h8cNkrCIfSKXtAuwWhteTT0
         G6ePFc3QqIuTV7+vNY4GRCS2fHOHXHdZHcErPY2ihU1mOWMIYQB+ytb6rdIpW9dpkc+k
         1I+h68VKeUQqtORtbbIX9hQhSewWuaT4PM2v4+TQdf40Z9LgTxsz3JhaKZCD5u3JvtTp
         San3MTU0yPsVUp2/NgSP7YVBhfToyu/XoKsnCJlFw6vkCerGis3GaSgeAJ4rFpLjSUb8
         mlEQ==
X-Gm-Message-State: AOAM532zINv8fr4h5JMveMZOTH9agMLAhNDcRfqYvbL94xDwOdeT9RZ1
        S3Va8Wimq+5QKj0ehRJFH7hXGpKFNhNKSmfz
X-Google-Smtp-Source: ABdhPJzUKEETcBoDc4p7P9S0rxCka847ZGfIYkt/h4mCtS3xBlEDGGK26GVzXKl2J04LeFSK3J3AEQ==
X-Received: by 2002:a62:5b04:0:b029:308:6fc4:da91 with SMTP id p4-20020a625b040000b02903086fc4da91mr484405pfb.26.1626302018257;
        Wed, 14 Jul 2021 15:33:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c136sm4057517pfc.201.2021.07.14.15.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 15:33:37 -0700 (PDT)
Message-ID: <60ef6641.1c69fb81.b49ce.c960@mx.google.com>
Date:   Wed, 14 Jul 2021 15:33:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Kernel: v5.13.2
Subject: stable/linux-5.13.y baseline: 181 runs, 4 regressions (v5.13.2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.13.y baseline: 181 runs, 4 regressions (v5.13.2)

Regressions Summary
-------------------

platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
bcm2837-rpi-3-b-32  | arm   | lab-baylibre    | gcc-8    | bcm2835_defconfi=
g   | 1          =

imx6ul-pico-hobbit  | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defcon=
fig | 1          =

r8a77950-salvator-x | arm64 | lab-baylibre    | gcc-8    | defconfig       =
    | 1          =

r8a77960-ulcb       | arm64 | lab-baylibre    | gcc-8    | defconfig       =
    | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.13.y/kernel=
/v5.13.2/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.13.y
  Describe: v5.13.2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d6fc894baac777c38a95a31f65343bea8b1a2678 =



Test Regressions
---------------- =



platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
bcm2837-rpi-3-b-32  | arm   | lab-baylibre    | gcc-8    | bcm2835_defconfi=
g   | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef31f969d5e25c3e8a9444

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.2/ar=
m/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.2/ar=
m/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef31f969d5e25c3e8a9=
445
        new failure (last pass: v5.13) =

 =



platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
imx6ul-pico-hobbit  | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef36267096158f408a93be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.2/ar=
m/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.2/ar=
m/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef36267096158f408a9=
3bf
        new failure (last pass: v5.13) =

 =



platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
r8a77950-salvator-x | arm64 | lab-baylibre    | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef37307fc1e25ed18a93a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.2/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.2/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef37307fc1e25ed18a9=
3a3
        new failure (last pass: v5.13) =

 =



platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
r8a77960-ulcb       | arm64 | lab-baylibre    | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef3645fe64b846198a93dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.2/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-ulcb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.2/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-ulcb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef3645fe64b846198a9=
3de
        new failure (last pass: v5.13) =

 =20
