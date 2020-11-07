Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7522AA66F
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 16:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgKGPv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 10:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgKGPv0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 10:51:26 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC389C0613CF
        for <stable@vger.kernel.org>; Sat,  7 Nov 2020 07:51:24 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id oc3so940160pjb.4
        for <stable@vger.kernel.org>; Sat, 07 Nov 2020 07:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mhloRthoE6lPxMnsx2srdN4zYpcCMSFlWC5sLr7ZEK4=;
        b=eISgPRVfEA6Xylnj9yBLzC28qW6VLYE0L6u/FtxO15MeltQLbXFOpnkFEOyZSjHCoT
         PZE+yXU+AbBNDGMDhqhd9PMBFrjAiCzonYzQ6L4q1GIUa8yxOcp0ffswPyR6yu88FQh/
         dO4CTa15Kd/1ee7myFN9qfFtkjrJrefsfYeV1BUD5wHi04xqD5Eu6s6iyz69LpsVUEU3
         O/HuW5sgMii6WGTna4TVH5uZnaH9UOcMBuQrYH2O/MhRxNJXtd2HzYhXqKg+KwWZScz9
         GI6aMhTAEODUVH+PNTUioHYhCKklClfK3Hkn/yz1oeOikUpOCkka3EYN7HVxY9OVZNsw
         lynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mhloRthoE6lPxMnsx2srdN4zYpcCMSFlWC5sLr7ZEK4=;
        b=Z+lHQ9Szz12RXFug3y3EHhcim5QYevm7OAoikpB5h44qOvqwOop2TJAU69P+c421ia
         +fEhjRxs/5XtzDokoqgGKADDHrT89fEn+w2OjYgDFe7DQoskx0mSaKy+QWYxr1gJ87Tj
         oOdUiUtC4073wMDTNI1z1SIUPha2SQGUDSrhFXyyu8jIJhXSWiaZ0cVx/HjcrCsde/Dz
         IpUh7pahjXOJ/k8SN3uvzmO+8gng5XNNInOkfkt6/b7LNSn/lcDpQNaTyDrdcB2AbXUa
         QQkYQDwunHMDGjOMEzAhPpkSZ8prOGEMZAYu/z4BrfDUP6vy4uyn5nP4dzy/9c/QNl9u
         AdSQ==
X-Gm-Message-State: AOAM533KnHBTY5+w2J8WaZHkWyJsuU6/8E9Ljk+Z3EDafVa7sfxlnSXm
        s4G62ApTCXaeVujZe4kg4rVTycC0ufGp4w==
X-Google-Smtp-Source: ABdhPJx62LmPPNUOR/jzgUh2JbIfzzSpuDKsqowNDr3fzFmMt2BOMvnOTbovAxz7cP7zHh/2hzz/5A==
X-Received: by 2002:a17:90b:2343:: with SMTP id ms3mr4683829pjb.130.1604764284108;
        Sat, 07 Nov 2020 07:51:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i123sm6122203pfc.13.2020.11.07.07.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 07:51:23 -0800 (PST)
Message-ID: <5fa6c27b.1c69fb81.dac51.bb3d@mx.google.com>
Date:   Sat, 07 Nov 2020 07:51:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Kernel: v4.4.241-65-gf1e9f1c7f0b9
Subject: stable-rc/queue/4.4 baseline: 100 runs,
 3 regressions (v4.4.241-65-gf1e9f1c7f0b9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 100 runs, 3 regressions (v4.4.241-65-gf1e9f1c=
7f0b9)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =

qemu_x86_64      | x86_64 | lab-broonie  | gcc-8    | x86_64_defconfig | 1 =
         =

qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-65-gf1e9f1c7f0b9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-65-gf1e9f1c7f0b9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f1e9f1c7f0b930971113e683512a3d4d895313af =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa68a09790fe336ebdb887a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
5-gf1e9f1c7f0b9/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
5-gf1e9f1c7f0b9/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa68a09790fe336ebdb8=
87b
        new failure (last pass: v4.4.241-65-g342f725261e7) =

 =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64      | x86_64 | lab-broonie  | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa68a1e28b602bd72db885d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
5-gf1e9f1c7f0b9/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
5-gf1e9f1c7f0b9/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa68a1e28b602bd72db8=
85e
        new failure (last pass: v4.4.241-65-g342f725261e7) =

 =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa68a2228b602bd72db8862

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
5-gf1e9f1c7f0b9/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
5-gf1e9f1c7f0b9/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa68a2228b602bd72db8=
863
        new failure (last pass: v4.4.241-65-g342f725261e7) =

 =20
