Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6881028C585
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 02:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgJMAD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 20:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727891AbgJMAD6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 20:03:58 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E018CC0613D0
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 17:03:57 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id w21so6876502plq.3
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 17:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RAWa3nCHmybr/GXiOMd4+ES/Pcv7Gj3GBMbH0MQM/Wo=;
        b=EbGKPCUPS82HwyHpu4F1ROpGEhTn7tPqwgsRScQr2Uvlg5j3BJX2cfvof7+vPFaDGD
         NZ0y6fNzJaLVZwgoVoECCqNa+BOMVe12q3jKMhyTXLAa94gmADTNKhC3DRxwUMdrnoDq
         ql0V3jLzoc++U74jXjKLcUDLY3Qd2bghyrYWUoXnZWkiRf/EpLGc5TQwEN1BgyR03wgE
         LVo1Aa2r4l18XZetq33rYFfp8XWpXpzlkm9Q7dLozCO68ugd9fWj1mPA/2iwrjhgkRMu
         STQP8Kkuv23hYzU1icLbe7S2zSfOtTsOK2YHDhtv0ZloV/+o5zxr9jLIub3C44huNrp7
         3Xvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RAWa3nCHmybr/GXiOMd4+ES/Pcv7Gj3GBMbH0MQM/Wo=;
        b=NdbPZs5gXK7UpObmfMivs9tJU6ijm3WRgv/72CCLLW4q/e3D+3VWl3q4OEiWWspqxC
         4nmeU0C6/E0JDXwzCdxMVW06FFlU02BAG3jUYL/DEtabReQBcPKv68h8do76iY/n4AvC
         iG89LncngVHR8w/cbx51UF67/yUqQNYRmpcZQkhb1Nrn85RS/pq2MWFQn/vmi9Nf1D9Q
         6WRUAe0FiGYRcn/6pBvpWmrgBUhEf9fp49EIHBHcKzxR5FjEJNcJsLop2+M0p4Kkh5Pq
         3ebjivPr69BuRMP4/uGsx7FX2W7dj2VSH3zAZnVmieiiVjbNHtGypDUS/spRG1zJ1cB8
         3Bhw==
X-Gm-Message-State: AOAM533T/2EcOWizO6OjjGI1u1F3EacTAv+uR3pS3eCDvk9eF5M/KD7C
        Gt+HMpxV8jxMwRoNtWGBoiacar+F5AOLNg==
X-Google-Smtp-Source: ABdhPJx2BiQ41YtW8AP44azQr1mlnon5oKHK/WtWy6WtrEMO/04DUSwkdXFY3d8pRNRel8IM9xOpKg==
X-Received: by 2002:a17:902:aa44:b029:d3:8b4f:5083 with SMTP id c4-20020a170902aa44b02900d38b4f5083mr24901299plr.78.1602547436928;
        Mon, 12 Oct 2020 17:03:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b4sm18210667pjz.51.2020.10.12.17.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 17:03:56 -0700 (PDT)
Message-ID: <5f84eeec.1c69fb81.36b22.37ed@mx.google.com>
Date:   Mon, 12 Oct 2020 17:03:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.200-71-gaf37e8ff299b
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 98 runs,
 3 regressions (v4.14.200-71-gaf37e8ff299b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 98 runs, 3 regressions (v4.14.200-71-gaf37=
e8ff299b)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 0/1    =

meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 0/1    =

panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.200-71-gaf37e8ff299b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.200-71-gaf37e8ff299b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      af37e8ff299b6807fa85fde68b814a94f56a76b6 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f84aba3f03a39c9c64ff415

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-71-gaf37e8ff299b/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-71-gaf37e8ff299b/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f84aba3f03a39c9c64ff=
416
      failing since 80 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f8498f89ac8d509854ff3e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-71-gaf37e8ff299b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-71-gaf37e8ff299b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f8498f99ac8d509854ff=
3e1
      failing since 195 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =



platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f84b48be8ee38cdd94ff3f8

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-71-gaf37e8ff299b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-71-gaf37e8ff299b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f84b48be8ee38c=
dd94ff3ff
      new failure (last pass: v4.14.200-69-gc6bda4c1748c)
      2 lines

    2020-10-12 19:54:47.694000  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
      =20
