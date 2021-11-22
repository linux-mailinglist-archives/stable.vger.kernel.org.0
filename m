Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DF04595BD
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 20:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhKVTrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 14:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbhKVTrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 14:47:32 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCF9C061574
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 11:44:25 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so536857pjj.0
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 11:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=elNn561CLvSzHt3gRS8uJSiqfjKCQBuAd0XnaSCk+V0=;
        b=Jilxx3k5e5kJfK+8o8hYXBh2yVXIVzBV2MIaEaRnGOa02ReDCgshqf/3Pg36kMnO9V
         Bn5yGlUE2NqKPnjoxDNphh1zKUjxifyXln7ozhAIwPi/4UFJZMnZEegZ1+8PUCqNCVM8
         gvisHIIRA7/hBV7RtFp3gKA586il6pn4sxgjlzbS4CiX5osUA/c41hXdNBDro4MbS/gL
         5Gfbm4xlm9hPwo8ORLB1wSkzlkiczZ7tZVbUEjgwQ/OfsXHBac896jn5eOIW+KHDNbz0
         l1hw4D6V1ALp7IrpExqMH/aq4a9CpaFlSnRBcrluGjgXW6vRXDSnIPgnYFRxLQ0dUT6h
         YZ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=elNn561CLvSzHt3gRS8uJSiqfjKCQBuAd0XnaSCk+V0=;
        b=eZjGWeuv56TQpxfrRq/RAJkMrLil2j7ntTKRY98VZeM04iQwvXnAGlSjTk/uCoUa63
         Ag8W3cl4VeP0iNTrz1di7yLNb/Kiy8HwGVHQ5nI9sZBPTaFC6vi30eNl4BBOORR8O8fd
         OxF/CjB5eFTbHNveqiX58ihgG1oj42si96oGzwHNXRDptVVREuyRogYA+oto1bVP2Wl5
         Ev2HZq10JtZrMOLMM73364CylZZC6k/M4ZZCObcIqljv0ALzXcUws8UQ0SBCwjJ2ImN+
         k4bxUW2jB1dUwh3+CJSatrQGvg20mMSYGSVcNIaGYEw59A0eH8aJlFEv0bnGf8vAHI0a
         E++g==
X-Gm-Message-State: AOAM530l0iubsTK60ouZbnGY12EfNf5Bidq5Un4x8P+W2wfs+8RRE2Yd
        akZxmZgRQkm56gSegUPnHR1IFaqY6mjcrK2l
X-Google-Smtp-Source: ABdhPJxNMiLgIKOiuUew+NM9P+vlQlk2+P7ha7+VOY8BjDGGIzTnAV/QGKyGfhw7orAdMW6n2foGdw==
X-Received: by 2002:a17:902:ec8f:b0:142:11b8:eaaa with SMTP id x15-20020a170902ec8f00b0014211b8eaaamr110585862plg.81.1637610264520;
        Mon, 22 Nov 2021 11:44:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q13sm10256483pfk.22.2021.11.22.11.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 11:44:24 -0800 (PST)
Message-ID: <619bf318.1c69fb81.f5c72.cf4a@mx.google.com>
Date:   Mon, 22 Nov 2021 11:44:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.217
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 198 runs, 2 regressions (v4.19.217)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 198 runs, 2 regressions (v4.19.217)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
   | 1          =

panda                | arm   | lab-collabora | gcc-10   | omap2plus_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.217/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.217
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fd8250304dd51bc2c8674af65c102dd8463ee88b =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6196cc13335dc20807e551cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6196cc13335dc20807e55=
1d0
        new failure (last pass: v4.19.217-259-gf3d787ccb5492) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-10   | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/618fb259091576e1613358ec

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618fb259091576e=
1613358ef
        new failure (last pass: v4.19.216-17-gf1ca790424bd)
        2 lines

    2021-11-22T16:00:22.537047  <8>[   21.313720] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-22T16:00:22.584348  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/107
    2021-11-22T16:00:22.594086  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-22T16:00:22.608711  <8>[   21.387084] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
