Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0A13E4F4D
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 00:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhHIWeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 18:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbhHIWeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 18:34:02 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186ACC0613D3
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 15:33:41 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id lw7-20020a17090b1807b029017881cc80b7so1318193pjb.3
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 15:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mO9NQFIsjuUtxemPZRxn/PCiBWiyoxM0DA1eHUcAzyQ=;
        b=rwfZjPMx4dySvOVnddzg3LlF/T032BYLviTQfkZdyhXjAIV3buUl0me7bXNmvZ4O20
         rLbG7DFF+ATUm283zean4LDwv1GqmQBWZpI5O1PsGDIBlC2rPa6Qn4ycoxRGxwCKXUm1
         lQNywoASZ/dlXgX3kp2iQVac7VnLuNjWrKV6hA/BCuVDdhLMsnT2AkG5xPVT1S8sAkAb
         Vqno1iBmy/Krf+pC6WzNnt81KqkR5ZB8RfzuGNEGv56v5EvWpU/N6gKmWPk9THF24BGs
         U2/F1jNhMLuknzOvew9qw63IYyGr3QlpWzVrUQohDvxZyzgFCwurmS88qQDgTEJJkQRM
         dbAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mO9NQFIsjuUtxemPZRxn/PCiBWiyoxM0DA1eHUcAzyQ=;
        b=FX73WUZuOJ/9kTxBv/lcqNi0bHw8NhajwVbBVbdUiH1CcdsT04j/DyUpmFA4fWU9Sh
         L7uvcjp+/H8QhGZj6DXFxJNdRJeIx9J7hjaGeOjDXjAAL2mlEDQhKxxNxT77UeMRIrCM
         2YumazwQD4Rj//MllfC45DHTghJwalMFDkVTCR190Cd3wU7GtUqpql/EMNOcATvcXdcg
         BfVLs+hlHrPecp/ULKoQaiGXm/SlHDZAUxtOM+2aTHR07WMWnPulA40Yy//NAr+J8hIm
         AamvSkaqmWiqcFz6UWugTaKA50xSjbTWN1diN4gUYytNp7OeEOq11DtWjhYqnxHtxxDc
         ZmmQ==
X-Gm-Message-State: AOAM532nCSI/+w/hTtnDLeuZh6fCl71TRH+NiE4FE2KYkIjHbqKJ/LdW
        ObJusMzKwLM512B7YLmZyJbzIOc5G3GgKHBC
X-Google-Smtp-Source: ABdhPJyH44MCKKFE290uwr1LX0welhF8fVeEGlqvWh8FQbtOCMTAAHhQWoRBDicXN65hLJbkoDicng==
X-Received: by 2002:a17:902:c20c:b029:12c:ef04:faa3 with SMTP id 12-20020a170902c20cb029012cef04faa3mr16830747pll.44.1628548420376;
        Mon, 09 Aug 2021 15:33:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s5sm20484581pfk.114.2021.08.09.15.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 15:33:40 -0700 (PDT)
Message-ID: <6111ad44.1c69fb81.7d0ea.d016@mx.google.com>
Date:   Mon, 09 Aug 2021 15:33:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.202-48-g491a60cb51d4
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 104 runs,
 4 regressions (v4.19.202-48-g491a60cb51d4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 104 runs, 4 regressions (v4.19.202-48-g491=
a60cb51d4)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.202-48-g491a60cb51d4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.202-48-g491a60cb51d4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      491a60cb51d44f6229d6481d42fa5d058c77e90d =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/611171aa804b0a8bcab13669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-48-g491a60cb51d4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-48-g491a60cb51d4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611171aa804b0a8bcab13=
66a
        failing since 264 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6111719d3904d96787b13681

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-48-g491a60cb51d4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-48-g491a60cb51d4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6111719d3904d96787b13=
682
        failing since 264 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6111714e31237b5d24b1368d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-48-g491a60cb51d4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-48-g491a60cb51d4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6111714e31237b5d24b13=
68e
        failing since 264 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61119aed23907b5d01b13691

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-48-g491a60cb51d4/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-48-g491a60cb51d4/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61119aed23907b5d01b13=
692
        failing since 264 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
