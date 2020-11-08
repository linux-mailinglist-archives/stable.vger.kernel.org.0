Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6219F2AAE5F
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 00:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgKHXrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 18:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgKHXrj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Nov 2020 18:47:39 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F047AC0613CF
        for <stable@vger.kernel.org>; Sun,  8 Nov 2020 15:47:38 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id w11so3709307pll.8
        for <stable@vger.kernel.org>; Sun, 08 Nov 2020 15:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QkDINdRmPY2xBfhGOD1EaLxLCBqRR0xkKFRpHKk42FA=;
        b=EGUMUKHcG4XTVHk1mgosOMrmwajfXpJ9K0zdGjpxZYj/cUAEBEmCJbUs66onm2iTf6
         qoWVKf3VK5bfCt1DsxnvildnJE1sQDPTuuMOmDxXidxO7SnNVcLX4K62CGdcp+Rivoqg
         dCQWGIMH/2LZjE8WeLcdGjMwisB/99+EF0LbsZZgAySEH+OOdnNhZqVM9C7Np0TDjsM0
         +xTJIs3Ak7wyoY0lVQ+am0QJhh8jOrIW2PMAi5qghlqHCNqNQf+i0XhP2dWsBVn94laE
         da6w5USBpkMJndDtdWfwL0DRGMK8xEDf+tHVyCFvgw69FX/uaSbN2sUdAQUXEM3Zm8wp
         7Kog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QkDINdRmPY2xBfhGOD1EaLxLCBqRR0xkKFRpHKk42FA=;
        b=t/5rUQI+bzB5Air0YL2I0BdYeNp95j13UUMzsa4bI7imUILWhzhH2oE2YAYZi+AxVS
         83zUXNRpbNI0TJRhj59UpCg0YC4m4fjZ5Mly5u3+d4G9QdcMsfLJcKXlYZBokonYCad4
         ymihnmyLO7nphY4WM/lQQb6t1GiepB6KQM0P5+t3OiMgrJRhwlrBZA5gNpocLnxO4bxc
         4CKK1Whtb/uZR+mrPpycY0KlVUpTgsDlGEANwmkPxy02HD4WmvPZNN5T4OhTKYFQepLp
         J6RNDoo8AFFz03TDJfOFXrnqX9saNuriQLL6WAyau4HQTxB8/AsbMSKjqb2k7aMt/QeZ
         lwiA==
X-Gm-Message-State: AOAM530366da8+VmRfhUNooycBVPl8szw8QFU61/GtzebHM3JUZiD+oB
        kusepshZGJWcQ62XUz67q2JkSiPBVCPB+g==
X-Google-Smtp-Source: ABdhPJy0C4oc7IJzJPylhtOHWbvIwz/TfpP5rEhExFILhc0uRFAq0CjyEvHdstUN/fIrxpvTeo7NlA==
X-Received: by 2002:a17:902:a589:b029:d6:856a:2978 with SMTP id az9-20020a170902a589b02900d6856a2978mr10060373plb.67.1604879258203;
        Sun, 08 Nov 2020 15:47:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r12sm9171756pfh.213.2020.11.08.15.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 15:47:37 -0800 (PST)
Message-ID: <5fa88399.1c69fb81.31cd6.3664@mx.google.com>
Date:   Sun, 08 Nov 2020 15:47:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.241-101-ge8d0a6534ab3
Subject: stable-rc/queue/4.9 baseline: 130 runs,
 3 regressions (v4.9.241-101-ge8d0a6534ab3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 130 runs, 3 regressions (v4.9.241-101-ge8d0a6=
534ab3)

Regressions Summary
-------------------

platform       | arch | lab           | compiler | defconfig           | re=
gressions
---------------+------+---------------+----------+---------------------+---=
---------
panda          | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1 =
         =

qemu_i386      | i386 | lab-baylibre  | gcc-8    | i386_defconfig      | 1 =
         =

qemu_i386-uefi | i386 | lab-baylibre  | gcc-8    | i386_defconfig      | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-101-ge8d0a6534ab3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-101-ge8d0a6534ab3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e8d0a6534ab3050285987118d34695bed57dd45e =



Test Regressions
---------------- =



platform       | arch | lab           | compiler | defconfig           | re=
gressions
---------------+------+---------------+----------+---------------------+---=
---------
panda          | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa84d018a0a317fb7db8856

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
01-ge8d0a6534ab3/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
01-ge8d0a6534ab3/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa84d018a0a317=
fb7db885b
        new failure (last pass: v4.9.241-98-gbb5ddb48abfd8)
        2 lines =

 =



platform       | arch | lab           | compiler | defconfig           | re=
gressions
---------------+------+---------------+----------+---------------------+---=
---------
qemu_i386      | i386 | lab-baylibre  | gcc-8    | i386_defconfig      | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa84abb825b7a5d9adb8883

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
01-ge8d0a6534ab3/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
01-ge8d0a6534ab3/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa84abb825b7a5d9adb8=
884
        new failure (last pass: v4.9.241-98-gbb5ddb48abfd8) =

 =



platform       | arch | lab           | compiler | defconfig           | re=
gressions
---------------+------+---------------+----------+---------------------+---=
---------
qemu_i386-uefi | i386 | lab-baylibre  | gcc-8    | i386_defconfig      | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa84abfd149341e8edb885a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
01-ge8d0a6534ab3/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
01-ge8d0a6534ab3/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa84abfd149341e8edb8=
85b
        new failure (last pass: v4.9.241-98-gbb5ddb48abfd8) =

 =20
