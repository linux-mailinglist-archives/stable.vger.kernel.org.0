Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3EA224427
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 21:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgGQTWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 15:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728183AbgGQTWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 15:22:06 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3ECC0619D2
        for <stable@vger.kernel.org>; Fri, 17 Jul 2020 12:22:05 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id 72so5857290ple.0
        for <stable@vger.kernel.org>; Fri, 17 Jul 2020 12:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rxgXHOT59MZUrpi3n/b4N4L9f9VpyNBzYbNMj5Mk4dw=;
        b=HwqZCVCgF3/pAQaIQ78uTKJSisEiQA+OTaCgYEToNuo27RY//Vkctsw2lonmLLI+V1
         dcy6QXvh7kVhGNSIRHJ0/e5NVGyFnSPyUWEUB3M0Ahq9OXCPDgElXub38tCytCD+Y8Nv
         ZNsdWdt4WlgVvaUFMmVyySknzyCtJG7OjbNekLq5XubBVAGJgHGM93+U3LE2eMaMtzpa
         C/SUuFLPn2XeAWq+M9lDFosB5Zh/M/DKoIx4r4x60sYpibeEyEck1IEwwha+RZs+tzCh
         fAafpOmkPcx5a9+rBpaPatusK8LssmUARdHCFtptA44FQw+y3g/dFtV/LA6r/4oAgsiX
         loGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rxgXHOT59MZUrpi3n/b4N4L9f9VpyNBzYbNMj5Mk4dw=;
        b=WA1kCIdQO7tFAV5cxTwS32pPNf7lybGtcyQdmqLdIKxwmHG3AMF7HdEDv8YAHYcpJI
         umPtxUnlW2swV0tlzZa8akJLTgcEDqvQ5jD5JxBYfaspRBH/J5AGvjdehQG5EOz8wqK0
         HV4dq2fzUdRWFzWAif3rJMXtyF/HCA9atVYTczI/hEp9izzoUaEYlj46InhjFDQ3MRIO
         SswD3AxhFmIQW/fhO/IpPIVDY+DcRiBcoWbrWSN4SexTSIS5sfTRST/7btd3v65Ccqoq
         chSWWZ5BHI6c2XV4jnBdXTDQVFiILO3V646xG/eViA/Qg7G9IrpZOy2lIOn/dsfOOHlg
         mhpQ==
X-Gm-Message-State: AOAM530wFPQeX89EPEhxLN5plN8V+hP+DhFtS9KqD62nGazpflDJnfJJ
        BTAVHKqNH1KJhUMubgy4DmxYmIHhspw=
X-Google-Smtp-Source: ABdhPJwLOYKhPt9vu8eypKCC+uCJmoRXEekdbHeqfE5PULeE8NTgRhBVo9pGc4ZiZ7coOONRqwPsIg==
X-Received: by 2002:a17:90a:362e:: with SMTP id s43mr3439210pjb.217.1595013725054;
        Fri, 17 Jul 2020 12:22:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nv9sm3747574pjb.6.2020.07.17.12.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 12:22:04 -0700 (PDT)
Message-ID: <5f11fa5c.1c69fb81.3b6c8.e025@mx.google.com>
Date:   Fri, 17 Jul 2020 12:22:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.52-30-ge4f3e790ad57
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 104 runs,
 2 regressions (v5.4.52-30-ge4f3e790ad57)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 104 runs, 2 regressions (v5.4.52-30-ge4f3e7=
90ad57)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
at91-sama5d4_xplained        | arm   | lab-baylibre | gcc-8    | sama5_defc=
onfig | 0/1    =

meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre | gcc-8    | defconfig =
      | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.52-30-ge4f3e790ad57/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.52-30-ge4f3e790ad57
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e4f3e790ad574b9b5bf762904e549b8d78190aa1 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
at91-sama5d4_xplained        | arm   | lab-baylibre | gcc-8    | sama5_defc=
onfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f11c73b8b65ca755185bb25

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.52-=
30-ge4f3e790ad57/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.52-=
30-ge4f3e790ad57/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f11c73b8b65ca755185b=
b26
      failing since 96 days (last pass: v5.4.30-54-g6f04e8ca5355, first fai=
l: v5.4.30-81-gf163418797b9) =



platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre | gcc-8    | defconfig =
      | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f11c7b1e1a5068ffc85bb29

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.52-=
30-ge4f3e790ad57/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s805=
x-libretech-ac.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.52-=
30-ge4f3e790ad57/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s805=
x-libretech-ac.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f11c7b1e1a5068=
ffc85bb2e
      new failure (last pass: v5.4.52)
      2 lines =20
