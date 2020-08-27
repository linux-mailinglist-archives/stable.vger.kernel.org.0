Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7592545BF
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 15:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgH0NPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 09:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbgH0NOZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 09:14:25 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3785C061264
        for <stable@vger.kernel.org>; Thu, 27 Aug 2020 06:13:59 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id t9so3467035pfq.8
        for <stable@vger.kernel.org>; Thu, 27 Aug 2020 06:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U8dHr0TkgkKblGOfqoe5jlwS9DGdhYE+o41iB2aE3D8=;
        b=Le6zTU52QWorJcuikpLckaKRJk17+E5K/n2uHogc9cEJSscIweS/GD3n7xGDaiP5SF
         PZ2IFweu8dylkfr4Nf1mvB1t/FmPos9utgf+r4VDGwf75W9v7hv+QK2Xro3FPd6uiZ5X
         PMv8i1eY7VIa/dcBEqV6nvr6H88LfKOM8mmqzs7aA91DG07d0Denv+/AiBTFCWwh22uR
         01idrTXVd5C6/e2OPoU8MGkPHP9650mxd0MORUR1dYvbqKyfvoXF1Kb4SwwLuXO1739t
         5+4VM7TKlt1b0KfXOTZOP0yA7TpTLYcuzjp+LAhguiCZJqOB28hEsIunsBNNO4jP7+4t
         IoRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U8dHr0TkgkKblGOfqoe5jlwS9DGdhYE+o41iB2aE3D8=;
        b=oniod6IlishlEYACNSgT3yO6e+rDksCko27Gpd51VlYD/aJqTuCUT2X2lxJiHImM6j
         mA9j/NN2pwdg4MGcNSLcHMYI2zfAZASWooZKSa2lOP0mOSX/QA33cdP21mt0H16XbcZM
         M27u8DhR1csfRbh1KpEfdGckXpRPcvraO78SR3skKDK/IHMtC7mcFCddtl1YpPkb3OLp
         63GSBYUPlx14ctA+aUV1KvAMVnHrKIwRtNxzqgVKb61AsmrZd22MifY5W04WfeDRvM5v
         MHcgY1Y7C/kKLcEkqRkvSrCtTS6etAi7tBb7ipuE/rEwvx9h9ebAcuqfwz8YKSIA5FiR
         c8EA==
X-Gm-Message-State: AOAM5314Bl8isadtkBc3S4ST4qiOxbeGX27b9pkQ+CiAzmruSdcbxlys
        6EJo9kcwk9QD3ZWDjdodO3eAmib2UKJVXQ==
X-Google-Smtp-Source: ABdhPJwSzD5iLiz38G+dazRcMJcfvbirZg8r8CK9rNSoBS31ujgsOQM1dX7qk/QUuw3HYx3cAo2cSg==
X-Received: by 2002:a62:486:: with SMTP id 128mr16583194pfe.163.1598534038890;
        Thu, 27 Aug 2020 06:13:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s67sm2933092pfs.117.2020.08.27.06.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 06:13:57 -0700 (PDT)
Message-ID: <5f47b195.1c69fb81.97198.8c04@mx.google.com>
Date:   Thu, 27 Aug 2020 06:13:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.7.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.7.19
Subject: stable-rc/linux-5.7.y baseline: 169 runs, 4 regressions (v5.7.19)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 169 runs, 4 regressions (v5.7.19)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
 | results
----------------------+------+---------------+----------+------------------=
-+--------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
 | 0/1    =

bcm2837-rpi-3-b       | arm  | lab-baylibre  | gcc-8    | bcm2835_defconfig=
 | 2/4    =

exynos5422-odroidxu3  | arm  | lab-collabora | gcc-8    | exynos_defconfig =
 | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.19/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.19
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b9830fecd4a87d7ebb4d93484fef00f46d0fa0f =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
 | results
----------------------+------+---------------+----------+------------------=
-+--------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f47780891e78939429fb447

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.19/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.19/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f47780891e78939429fb=
448
      failing since 41 days (last pass: v5.7.8-167-gc2fb28a4b6e4, first fai=
l: v5.7.9)  =



platform              | arch | lab           | compiler | defconfig        =
 | results
----------------------+------+---------------+----------+------------------=
-+--------
bcm2837-rpi-3-b       | arm  | lab-baylibre  | gcc-8    | bcm2835_defconfig=
 | 2/4    =


  Details:     https://kernelci.org/test/plan/id/5f47767cf424ef08579fb460

  Results:     2 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.19/=
arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.19/=
arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5f47767cf424ef0=
8579fb465
      new failure (last pass: v5.7.18-16-g6ae4171ed2cd)
      4 lines

    2020-08-27 09:01:35.975000  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000210
    2020-08-27 09:01:35.975000  kern  :alert : pgd =3D c05fae1b
    2020-08-27 09:01:35.976000  kern  :alert : [00000210] *pgd=3D00000000
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f47767cf424=
ef08579fb466
      new failure (last pass: v5.7.18-16-g6ae4171ed2cd)
      26 lines

    2020-08-27 09:01:36.018000  kern  :emerg : Process kworker/0:1H (pid: 5=
0, stack limit =3D 0x3c3bdc87)
    2020-08-27 09:01:36.018000  kern  :emerg : Stack: (0xe8e0bd58 to 0xe8e0=
c000)
    2020-08-27 09:01:36.019000  kern  :emerg : bd40:                       =
                                e8cf5000 e8da52b0
    2020-08-27 09:01:36.021000  kern  :emerg : bd60: e8e0bd6c c05ceb04 c05c=
ad34 c05ceae0 e8cf5000 e8da52b0 00000000 e8da52b0
    2020-08-27 09:01:36.022000  kern  :emerg : bd80: e8e0bdac e8e0bd90 c05c=
afb4 c05cad20 00000000 e8d56c08 e8cf5000 e8da52b0
    2020-08-27 09:01:36.061000  kern  :emerg : bda0: e8e0bdf4 e8e0bdb0 c05d=
e770 c05caf10 e8e0bdd4 e8e0bdc0 c0e04248 c03aafb0
    2020-08-27 09:01:36.062000  kern  :emerg : bdc0: e8da5000 cdd554ea e8e0=
bdf4 e8d56c08 e8da5200 e8d56c10 e8d40800 e8cf5000
    2020-08-27 09:01:36.062000  kern  :emerg : bde0: 00000000 00000002 e8e0=
be24 e8e0bdf8 c05decec c05de16c c05deb68 e8d5a000
    2020-08-27 09:01:36.063000  kern  :emerg : be00: e8e0be84 00000000 0000=
0000 e8da5200 e8da5230 e8d5a010 e8e0be7c e8e0be28
    2020-08-27 09:01:36.064000  kern  :emerg : be20: c03ae908 c05deb74 e8e0=
be54 e8e0be38 00000001 e8d9c000 e8d59980 00000000
    ... (15 line(s) more)
      =



platform              | arch | lab           | compiler | defconfig        =
 | results
----------------------+------+---------------+----------+------------------=
-+--------
exynos5422-odroidxu3  | arm  | lab-collabora | gcc-8    | exynos_defconfig =
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f47870bbabd27a7889fb42b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.19/=
arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5422-odroidxu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.19/=
arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5422-odroidxu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f47870bbabd27a7889fb=
42c
      failing since 6 days (last pass: v5.7.16-99-gc5aad81e7f2d, first fail=
: v5.7.16-205-g7366707e7e99)  =20
