Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5779B2BAA49
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 13:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgKTMhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 07:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbgKTMhB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 07:37:01 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6086AC0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 04:37:01 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id j19so7179068pgg.5
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 04:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AnN+AzmJj/x/BvLo3/yJsYFZnkQ05yyrIFNvBSLL1rQ=;
        b=xDIMLhn7N3w62T1CK0ce9TaeuRI+7mRlFnWZDypqDsfkH2Ir+bNsSGjBF5K8sDmlfj
         mNY4Z3SiBgNEFYXXDRY3zzfg846xWYCDrrbw4pJrRJiN1SJcD3npgsr1hSWv0CA12NIR
         kDd3Y47uCCXNvVeIcAqFaQ2jCA7kfLnDMyxPtHyH3k+D/iiB+ujKTr3VSS9BCmQEySBt
         tpEF4FK/4xI/Guy5dGTOhhU44/TsH7sx1AW4VkZBaYg1nnzD2pgkrQp3ODT+rV/h8ITP
         BtAl4rgUzihD/BTrAq/OElPJhXLRxaOxLM5lZtjWS9M36EgdbVCkKuMb8k5KF/ogs4Bo
         JYTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AnN+AzmJj/x/BvLo3/yJsYFZnkQ05yyrIFNvBSLL1rQ=;
        b=U6vuBRtWMvfEMhSTJ6opHV+jHb1hdF/tgjqkbeODgLFhsXaZP+Mfanam0BdkXqeDng
         W6uscMZIilQHwceb6Yi+LwHLS0H2HbgVbyGuIR29EcKzabkuG9V6kWwzAwe3CO3Q2BO1
         F5zjdGJ5zGSN9iGRjxcMnOpVZakkvswMZhGoVHTH3tP7wNE2OwXatIQvif6gkDS1QdyY
         RcOVWl9m5XioIJbsc1iBwEexzQnOj8HL+EXBrHFtSbYbEXilkX0x6c0eiUnXIThatBE5
         8ZTeVOdyowM2TkM8UbmplJibto8ck2KtR8wT8YSEWBStVtyJKXj+P5OnVHVMfu2PfX7Y
         y2+A==
X-Gm-Message-State: AOAM531eNbNWJQwaSsSrqK7TP04cnhu3JKH5J35386B/J+EVYNuD7Tiz
        A72lD2dhMnnCNoOTqvcV2UCentAJf/oisQ==
X-Google-Smtp-Source: ABdhPJy/IpVZdgafRIhK5FFUinnCHXEblnaSf/evvF/MuC38tfj4M5OhcSVidt7VinEenUOpSgBGZA==
X-Received: by 2002:a17:90a:ca97:: with SMTP id y23mr9533370pjt.186.1605875820534;
        Fri, 20 Nov 2020 04:37:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i11sm3958541pjl.53.2020.11.20.04.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 04:36:59 -0800 (PST)
Message-ID: <5fb7b86b.1c69fb81.74838.73d2@mx.google.com>
Date:   Fri, 20 Nov 2020 04:36:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.78
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 174 runs, 6 regressions (v5.4.78)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 174 runs, 6 regressions (v5.4.78)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =

hifive-unleashed-a00  | riscv | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

stm32mp157c-dk2       | arm   | lab-baylibre  | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.78/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.78
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      315443293a2d0d7c183ca6dd4624d9e4f8a7054a =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb784b1fe64a1fc31d8d924

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb784b1fe64a1fc31d8d=
925
        failing since 222 days (last pass: v5.4.30-54-g6f04e8ca5355, first =
fail: v5.4.30-81-gf163418797b9) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
hifive-unleashed-a00  | riscv | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb78412453b72f047d8d93b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78/=
riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78/=
riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb78412453b72f047d8d=
93c
        new failure (last pass: v5.4.77-152-ga3746663c3479) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7831a09b961680dd8d916

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7831a09b961680dd8d=
917
        failing since 5 days (last pass: v5.4.77-44-g28fe0e171c204, first f=
ail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb783151b3c3b9fb9d8d929

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb783151b3c3b9fb9d8d=
92a
        failing since 5 days (last pass: v5.4.77-44-g28fe0e171c204, first f=
ail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb78316ba231445e8d8d8ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb78316ba231445e8d8d=
900
        failing since 5 days (last pass: v5.4.77-44-g28fe0e171c204, first f=
ail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
stm32mp157c-dk2       | arm   | lab-baylibre  | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7885f9ca1dc06c4d8d91b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7885f9ca1dc06c4d8d=
91c
        failing since 23 days (last pass: v5.4.72-55-g7fa6d77807db, first f=
ail: v5.4.72-409-gab6643bad070) =

 =20
