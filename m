Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16222842DB
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 01:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgJEXO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 19:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbgJEXO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 19:14:57 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE98C0613CE
        for <stable@vger.kernel.org>; Mon,  5 Oct 2020 16:14:56 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id m34so6905582pgl.9
        for <stable@vger.kernel.org>; Mon, 05 Oct 2020 16:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pLK8eE/jfFCioVmGEbQy2eMFmDkQysbpBicjsb5n7Zw=;
        b=B6uKXwoIqw31AtJ0F8IfwKFr/54wUI6mArWh0IP/xwFxFjlMEEn/s4pZr6vBKsBANf
         qNVlCVDoOyWF4LdK1rghkSYMDgZOflQhTpAqyG5tbcRc2GJxoZvT//0bt+1uEl5HoV1B
         sb/Zb37dH0WDEP9qoLwNTZu/kZ+BsLKysVftyLsbk00i4EwFWIbu/mxcoRFUfh10nTQY
         IQwXL1nVueFLAEhfJFGTYgXpXKOWW+SMgGTnVZNaviNt03QnDsW93OLefAm13/CcrKDt
         pbFuYYEqbt8xoWNQXaj3Febvq3xpXs8baMCWXurwMGP6mdeOnUU1lFNbjteMSJOJBcr3
         J1Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pLK8eE/jfFCioVmGEbQy2eMFmDkQysbpBicjsb5n7Zw=;
        b=N1+NjjliDU5RPwxRNaTNUveGzHH2Ln4KmxG9ML2TwIZDYdiV/6MSpmoOUVeorDy2Ck
         iydbc45zjmOuqceOTj0c5NpRIDQuD1REUz7Lrr/ScChHXw0P+loreGf48Xgzf8uVCdCB
         Vj7XA7+aan28mTqSFm9lf0wm947R5WHavHm+V1w0nOM5r/LCJsc5g+wKoH7N2afYvjRU
         Wi83CF5ihp91TKtufO7mud7QjkEmEruNzq4UPlc0cBxMGc7vz7podnma70kcZi8ieiLp
         PzNtvtlO+ozbypTqPT6tYB4iY55FpL7XmTGr5v4/Kq1pEp1M1yObmGAbUTcKg0IejNnK
         rY0g==
X-Gm-Message-State: AOAM530/WC3vVdcSX+gzxk4tJj2UXI6Hhp7afz0VuxDUW1r1kyCkv3Hd
        6kF0Na0nz7LUJC2WSTTOrSz7PgO7kUF3KA==
X-Google-Smtp-Source: ABdhPJz+/YWzO1kSpmuLEomKPNOyoKRhZ5UpVFJn0H2FIeL1O8frtcWgI76Sxs+SDozSwAFw3JSRVg==
X-Received: by 2002:a63:1252:: with SMTP id 18mr1682378pgs.246.1601939695212;
        Mon, 05 Oct 2020 16:14:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v9sm661035pjh.2.2020.10.05.16.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 16:14:54 -0700 (PDT)
Message-ID: <5f7ba8ee.1c69fb81.fb106.1ce5@mx.google.com>
Date:   Mon, 05 Oct 2020 16:14:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.149-39-g204463e611dc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 79 runs,
 3 regressions (v4.19.149-39-g204463e611dc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 79 runs, 3 regressions (v4.19.149-39-g2044=
63e611dc)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
   | results
----------------------+------+---------------+----------+------------------=
---+--------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 0/1    =

hsdk                  | arc  | lab-baylibre  | gcc-8    | hsdk_defconfig   =
   | 0/1    =

panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.149-39-g204463e611dc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.149-39-g204463e611dc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      204463e611dc07092b63dd18658ad7efc3dd1252 =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
   | results
----------------------+------+---------------+----------+------------------=
---+--------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f7b6d91f3a46dc8204ff3e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
49-39-g204463e611dc/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
49-39-g204463e611dc/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f7b6d91f3a46dc8204ff=
3ea
      failing since 111 days (last pass: v4.19.126-55-gf6c346f2d42d, first =
fail: v4.19.126-113-gd694d4388e88)  =



platform              | arch | lab           | compiler | defconfig        =
   | results
----------------------+------+---------------+----------+------------------=
---+--------
hsdk                  | arc  | lab-baylibre  | gcc-8    | hsdk_defconfig   =
   | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f7b6f403aece35c3f4ff401

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
49-39-g204463e611dc/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
49-39-g204463e611dc/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f7b6f403aece35c3f4ff=
402
      failing since 77 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =



platform              | arch | lab           | compiler | defconfig        =
   | results
----------------------+------+---------------+----------+------------------=
---+--------
panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f7b6f79ce8e63039e4ff3e0

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
49-39-g204463e611dc/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
49-39-g204463e611dc/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f7b6f79ce8e630=
39e4ff3e7
      failing since 3 days (last pass: v4.19.148-245-g78ef55ba27c3, first f=
ail: v4.19.149)
      2 lines  =20
