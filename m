Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D53483687
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 19:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiACSBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 13:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiACSBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 13:01:02 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579E8C061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 10:01:02 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso481577pjb.1
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 10:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3irr1VrVWFDlLch0cGH/BiGKnbwzcecxCnCVweGdRE0=;
        b=3iF4o9VV1EdN9L8CtWxWXYt8ONl6ohg1AV7vLlqsK3QY8RXEgV7HvCIOnP4VHFeCs+
         RrwT+9VwxyTBesLLHIUP55M7m6Ke1XraEKFxUAMn9ng4gVWDkiUOOrObofr4osoA/7mC
         ZPoHf5oda+TxqrvrczBiFOEOrPK1Bmf9fbUE09AqmS009RvzN7zt7z9vNejrptfq5eXP
         sMWrsAY7iZbV3T5Kb/XqhMnqxAPd0E5f4cU5Z5Z+TWshTskkzJJS7UIkvtvQcD/w8day
         FFw9JKWhezFUOSFvOISDs+5LkhIOubavAvwsmj0b8eo9Qybkks1oNCPBoxVc8+Vp68yI
         yVcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3irr1VrVWFDlLch0cGH/BiGKnbwzcecxCnCVweGdRE0=;
        b=qOnS38I1LoMz4hC6t67qBsH8uUzHLB2MiwX/Zp38looiLc0GkLIIjbL02vO6aFis2t
         u3c1qww6KY/xk+3C4p+JLRxaqtXFsCDVq0sYyZv9akgBE6W7+WcnEEvUGBru/GUYIHNg
         C8YljLURlr7w4oqQQ8sgJzgT0OXKR5uCQ43fW21MRDcjhj08JTq38LdannQqP7E9/FIi
         bP3Oa6MdvC9hh1ocvJh+nc4yiYn4gTpJPpJEAHjouHpH5Az7uKec/p3BmOFkdfESOFvY
         9vPNu7U3Sn/EFrDMXg6/6NP4MOlmeUnP6XOsv0qp2zpJklxJVILCtRejFlf5Lh33bm5O
         JxKQ==
X-Gm-Message-State: AOAM530k4mk8N0rdrPdE9Yri0mpXWmq9Pactd+OZCXY5j95uJhFshqtL
        QHG11nY/T0AHJxnb6jJY3ujymLJKX8WyF0Nm
X-Google-Smtp-Source: ABdhPJzFH663jBb0AcJ8pdu37uFPTgKVNwIsQlFWTKVkgmr4jXgwKQVjmLwOtkEJyvgbeEgBV/oQ1w==
X-Received: by 2002:a17:902:74c7:b0:149:98f7:962a with SMTP id f7-20020a17090274c700b0014998f7962amr24805624plt.164.1641232861686;
        Mon, 03 Jan 2022 10:01:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t191sm33013122pgd.3.2022.01.03.10.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 10:01:01 -0800 (PST)
Message-ID: <61d339dd.1c69fb81.512d6.a483@mx.google.com>
Date:   Mon, 03 Jan 2022 10:01:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.169-38-g2023b5129d9e
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 136 runs,
 4 regressions (v5.4.169-38-g2023b5129d9e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 136 runs, 4 regressions (v5.4.169-38-g2023b=
5129d9e)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.169-38-g2023b5129d9e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.169-38-g2023b5129d9e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2023b5129d9e349e46adcad6afeb432c119af433 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d300f6c39bd30151ef677e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-38-g2023b5129d9e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-38-g2023b5129d9e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d300f6c39bd30151ef6=
77f
        failing since 18 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d30112dea7b1ab7fef6752

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-38-g2023b5129d9e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-38-g2023b5129d9e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d30112dea7b1ab7fef6=
753
        failing since 18 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d300f72d9c07128def674a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-38-g2023b5129d9e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-38-g2023b5129d9e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d300f72d9c07128def6=
74b
        failing since 18 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d30113d21b488570ef676e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-38-g2023b5129d9e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-38-g2023b5129d9e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d30113d21b488570ef6=
76f
        failing since 18 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
