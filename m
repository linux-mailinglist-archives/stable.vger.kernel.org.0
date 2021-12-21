Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22AA47B853
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbhLUCTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 21:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhLUCTu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 21:19:50 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84E2C061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 18:19:50 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 8so10338900pfo.4
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 18:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WvBfvf4dRhIg5hBPNrLDV5n481gMPbp+AwclGksSsOY=;
        b=ncQTA8KDNKn0SVrYAzBOPeGwV3WAb2lB8J7/4rkSdTQFVJjAWi95p6mDyOVUFlvy6L
         7ePXaGCQ6PcMJuSQSZ0IP3vC/LBpR+Pd5OFhtMycqKDkhuaVIM4fHdPNnsE8n6L1BLkX
         WzP39VpDeTvSpKt+W1abyt8ai87PVW15/YDRtG5VmXoYy3TiRWo0ufxcX8sXvczblZRz
         fnncDrLgN4rygZsbCLe/PsnGKH6td7RChiFVoWR0TIdMK4h/X2SXnFsL00cK0TALPDMd
         8oKsx1SaR1iin1EU+XMRUzpnrZZLI0tRlDGpXtqe2DK64IiOxNUSHAPB12ozAoxC7D3l
         4TEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WvBfvf4dRhIg5hBPNrLDV5n481gMPbp+AwclGksSsOY=;
        b=NOKdM0tvH7wHD07Mm7TY2tU5rLSJ7ql33XaIPsZd/cGAdybkrbbOuRnHMN0EwIZm/Y
         SUWWvjZORN1YBu6NGAQmZfGEIFQIQvGTmQYCtt/LYtN2hcBLtTGHfrtl5mKGAMFpRSa/
         cA/TA1wvr1RV4dX9wo6W82AulkwoXANqS5kukKSOGVFApVL00p+74J3P3MnkU7cM9DG5
         drZiBTokyCNXIauB+f6u2yzVZ1nMqb0yD1W3QWd/2WPWFNXfXTtGJ5kYc0hBsAM3WcPE
         Yu1+98qiEsXVvg+9H6PE5arKU/oPW2QKZ1C9ajniV2mi9w3E/nUH29WGC2+9Z4MxNSbi
         GCEg==
X-Gm-Message-State: AOAM531PEoao08qv8ZdnQ/0Fl0VweQH1wrptnbtsVBT/6R1eX68SAU+2
        nu9exrLKBJ/C7TAkeKxm3+28Zh9cnRGqmfWT
X-Google-Smtp-Source: ABdhPJw1XqyWU+1rYNycvGZcJlxHMIP4fA2XbUJ/7UoB8VW2iT7eoyMuLHVYEe/r8BdkVOe7WlxL8A==
X-Received: by 2002:a63:8441:: with SMTP id k62mr949988pgd.152.1640053190027;
        Mon, 20 Dec 2021 18:19:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n34sm7655729pfv.129.2021.12.20.18.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 18:19:49 -0800 (PST)
Message-ID: <61c139c5.1c69fb81.19187.613c@mx.google.com>
Date:   Mon, 20 Dec 2021 18:19:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.167-72-g13335f539c37
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 184 runs,
 5 regressions (v5.4.167-72-g13335f539c37)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 184 runs, 5 regressions (v5.4.167-72-g13335=
f539c37)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
       | regressions
-------------------------+--------+---------------+----------+-------------=
-------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig   | 1          =

qemu_arm-virt-gicv2-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config | 1          =

qemu_arm-virt-gicv2-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config | 1          =

qemu_arm-virt-gicv3-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config | 1          =

qemu_arm-virt-gicv3-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.167-72-g13335f539c37/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.167-72-g13335f539c37
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      13335f539c375b976ffe3a79116239de6a54645e =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
       | regressions
-------------------------+--------+---------------+----------+-------------=
-------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/61c101eb75a1dabcc4397132

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.167=
-72-g13335f539c37/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.167=
-72-g13335f539c37/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c101eb75a1dabcc4397=
133
        new failure (last pass: v5.4.164-89-g0896ccf90364) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
       | regressions
-------------------------+--------+---------------+----------+-------------=
-------+------------
qemu_arm-virt-gicv2-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/61c0ff300d7fe24e4c397134

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.167=
-72-g13335f539c37/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.167=
-72-g13335f539c37/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c0ff300d7fe24e4c397=
135
        failing since 5 days (last pass: v5.4.165, first fail: v5.4.165-19-=
gb780ab989d60) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
       | regressions
-------------------------+--------+---------------+----------+-------------=
-------+------------
qemu_arm-virt-gicv2-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/61c0ff4a449371040a397143

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.167=
-72-g13335f539c37/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.167=
-72-g13335f539c37/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c0ff4a449371040a397=
144
        failing since 5 days (last pass: v5.4.165, first fail: v5.4.165-19-=
gb780ab989d60) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
       | regressions
-------------------------+--------+---------------+----------+-------------=
-------+------------
qemu_arm-virt-gicv3-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/61c0ff2f449371040a397123

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.167=
-72-g13335f539c37/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.167=
-72-g13335f539c37/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c0ff2f449371040a397=
124
        failing since 5 days (last pass: v5.4.165, first fail: v5.4.165-19-=
gb780ab989d60) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
       | regressions
-------------------------+--------+---------------+----------+-------------=
-------+------------
qemu_arm-virt-gicv3-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/61c0ff490d7fe24e4c39713d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.167=
-72-g13335f539c37/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.167=
-72-g13335f539c37/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c0ff490d7fe24e4c397=
13e
        failing since 5 days (last pass: v5.4.165, first fail: v5.4.165-19-=
gb780ab989d60) =

 =20
