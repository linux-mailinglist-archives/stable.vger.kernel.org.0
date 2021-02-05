Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23A831104B
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 19:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbhBERF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233433AbhBERCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 12:02:42 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29573C06174A
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 10:44:25 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id u11so4001312plg.13
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 10:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iw5Ul6mMSQYVcd5YUwWS1eSCIdQAjus5v2by1D7F2Ms=;
        b=yNRFFVZEHlGRMAXjdZxXGmE/PJai/+XVmwCwvDdrunbkFK3lHYUfJW1rbwWsXue7WA
         qh24lsD83kGYkylf/uYQAN1IBAJ6pgYOvGauvj+PhDjcBtH691wVweYj5h8Sbtsl/UTb
         b6rZNYgTQYTnrvqw57g3MLeM5Wy1NRHSpog+UiNShj6Yyl+x1ijaeDEs4irfzOu23oh+
         ccjaDOGk/Y62hso1gSy0sMa1QQdBrGH/+YwRhCeX9xIybXIDrpx0lVKTCB7/81cMkDNS
         5E8PchQqv+WbX15eu/Qd9N9BRBb0zUpAUkwwKj+t7lMFZ7t168NqmUD21l+5rll4GcQN
         KIZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iw5Ul6mMSQYVcd5YUwWS1eSCIdQAjus5v2by1D7F2Ms=;
        b=SDQfICj6rvTHqgBrpsn8GwEuwVMeMObICXHjdLBV3YAVf5okbPD+lsgq2ncN7hdq7K
         2phBUS5/xeEFL6urSDB3qPlxu0WQwavxlKbg/x2WK/140DZ2XRHpzw9W0pnDwzZPTrhE
         3tWbJgXQs0asBh4I+bXTUPpfGMWbpSyBFyr0sV3bdmknaLz6/Q6vIa+anB0oxL+wcwl0
         n8smwvZfdmPm7q0I/SJii19I2BcR06Ic2Vr9gWNBYz6jCcHAZzN2cZym65XlAs+aIsPl
         gDcbOw/sntLIGDuUqH2Kq82C/WwYHFnt/CjD4bOj/mJUioRqOxfkwGb7BfPBDce0gr0g
         zlQQ==
X-Gm-Message-State: AOAM533jLGtUDnAcwSQHb6xFaUyLLKWHMz19tb4UGmoe5QZXN1pu41Yw
        5TIOwDuGBRx89+vjXI/S9E5MclHe2CjQog==
X-Google-Smtp-Source: ABdhPJxeeDJdK3cFA+zlpiq71KgL/KqxJT53NjEkprHCCWyB434KeuPbHkB4HQ8eWXVvEA/ewU2NHw==
X-Received: by 2002:a17:902:e5ce:b029:e1:d1f:525f with SMTP id u14-20020a170902e5ceb02900e10d1f525fmr5378475plf.25.1612550664273;
        Fri, 05 Feb 2021 10:44:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e9sm8293864pfl.82.2021.02.05.10.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 10:44:23 -0800 (PST)
Message-ID: <601d9207.1c69fb81.b54f5.12bd@mx.google.com>
Date:   Fri, 05 Feb 2021 10:44:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.95-33-gda7c9d56bab5
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 154 runs,
 5 regressions (v5.4.95-33-gda7c9d56bab5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 154 runs, 5 regressions (v5.4.95-33-gda7c9d=
56bab5)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.95-33-gda7c9d56bab5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.95-33-gda7c9d56bab5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da7c9d56bab5c4eb00d9d1545fcdc390ce75e001 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/601d5df914943171b23abe77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.95-=
33-gda7c9d56bab5/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.95-=
33-gda7c9d56bab5/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d5df914943171b23ab=
e78
        failing since 77 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/601d5e2d66d0ca10733abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.95-=
33-gda7c9d56bab5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.95-=
33-gda7c9d56bab5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d5e2d66d0ca10733ab=
e63
        failing since 82 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/601d61a7633a10712f3abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.95-=
33-gda7c9d56bab5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.95-=
33-gda7c9d56bab5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d61a7633a10712f3ab=
e63
        failing since 82 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/601d60418e5fe67bfb3abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.95-=
33-gda7c9d56bab5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.95-=
33-gda7c9d56bab5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d60418e5fe67bfb3ab=
e63
        failing since 82 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/601d5ddca97efc33613abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.95-=
33-gda7c9d56bab5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.95-=
33-gda7c9d56bab5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d5ddca97efc33613ab=
e63
        failing since 82 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =20
