Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B903AA64C
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 23:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbhFPVu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 17:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbhFPVu4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 17:50:56 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D159C061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 14:48:48 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id e20so3205177pgg.0
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 14:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZFu/R6Y/vstehHx+bu/+ypPLROntMnIuhXfnawXW3D0=;
        b=tyHBfPIBIkf8qMqsXJz6pqPQE4q5NdVHna3nvxwEz2NN88NILC9K5vDQ4qAF9MqY4B
         3hycryoECJh8Bo/EqgcyycRJr8PKLDU/DdK+g3LzC/c94hnJ0voagb03LgTlcFCi30ib
         7gcEwJZRouqKonijfTFyJCjK7RkU+Cve+qAE6ODoQ5wM9AXamqpPwhfHwqlKQsUPf7Yf
         rqxQakscAEsRVp1pZm3wjRaTWPcKdXc3WDt7oN5MfDywqEPVBWBp0y8CWQ2Flgl+9J/s
         H/7Hvp/xRctbEvOrsAQZxpn48V/cwISnQjHZhwRAg2Xx1FM02VljlHVA7rRIToexZpae
         c5gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZFu/R6Y/vstehHx+bu/+ypPLROntMnIuhXfnawXW3D0=;
        b=YwGf7srKV3LiduFxNA4v8+lGTF2MEJj07S/VLj/t7l9BkGcIGmDPSr9FYpXf1f2wbc
         dgie4YOCn5gmSw3/iA8kN9IF0NlVNmthrUOQHxc3PXHLiT1Q8JloubhbzNiJ4LXLFuLg
         Z3mR8+V5wuTgKTVc3dI33IEPHxrxtWk4vs/ql0CK9dH9VyXzL7Er+b63WdNeJENcwGoc
         mOTjEXYgHw3O6aiirISFYwczFeSgjCN/mSRPXf35ffWsmsMYnTLwqDUOMUCtSU5qjtNU
         EP6RX0dN9GET9J8SeKGq1SU+rJ9DuBbqJc+dRa7+6Lr2ASZjCUm1EQfl1rXtV8qXrzRg
         qMeg==
X-Gm-Message-State: AOAM530AV1vFasFw30wqivH5kyJu/drnnccHN1zNhoh7ccTFPuiiqB+N
        PyEs8xoHHIBdMbUvXt26JkeM8+LdaqT1AzzW
X-Google-Smtp-Source: ABdhPJxda9iSk38QeQkF8ZOR7d4zABNklsdcn74t5twL/Hyn3nthfZ0YKeo9tdkLrshM7ZcCFXg1Nw==
X-Received: by 2002:a63:1308:: with SMTP id i8mr1722247pgl.19.1623880128114;
        Wed, 16 Jun 2021 14:48:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l6sm3303475pga.3.2021.06.16.14.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 14:48:47 -0700 (PDT)
Message-ID: <60ca71bf.1c69fb81.e6f8a.980a@mx.google.com>
Date:   Wed, 16 Jun 2021 14:48:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.273-15-gb45cb54aa780
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 68 runs,
 2 regressions (v4.9.273-15-gb45cb54aa780)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 68 runs, 2 regressions (v4.9.273-15-gb45cb5=
4aa780)

Regressions Summary
-------------------

platform             | arch | lab         | compiler | defconfig           =
| regressions
---------------------+------+-------------+----------+---------------------=
+------------
qemu_arm-versatilepb | arm  | lab-broonie | gcc-8    | versatile_defconfig =
| 1          =

qemu_arm-versatilepb | arm  | lab-cip     | gcc-8    | versatile_defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.273-15-gb45cb54aa780/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.273-15-gb45cb54aa780
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b45cb54aa780457be5e6c818e5698a7590ca8263 =



Test Regressions
---------------- =



platform             | arch | lab         | compiler | defconfig           =
| regressions
---------------------+------+-------------+----------+---------------------=
+------------
qemu_arm-versatilepb | arm  | lab-broonie | gcc-8    | versatile_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60ca52f6807ff1ca4e41328c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-15-gb45cb54aa780/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-15-gb45cb54aa780/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca52f6807ff1ca4e413=
28d
        failing since 214 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab         | compiler | defconfig           =
| regressions
---------------------+------+-------------+----------+---------------------=
+------------
qemu_arm-versatilepb | arm  | lab-cip     | gcc-8    | versatile_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60ca3ecae3b4a57dbc413274

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-15-gb45cb54aa780/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.273=
-15-gb45cb54aa780/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca3ecae3b4a57dbc413=
275
        failing since 214 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
