Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA5445E300
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 23:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237025AbhKYWfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 17:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbhKYWd3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 17:33:29 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04512C061574
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 14:30:18 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id r138so6345404pgr.13
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 14:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9FEUZoKX35faDAfXrpM6IFei7xFjPXAeLV4k+GBJGik=;
        b=R7809E0rG4i70nkNqP4xdia2XPnfA2M5tybffrYaJx9hchrniqMLNR8eVjlMLcGqvd
         ELm+5ECDhjktAGcqqgIWqZsa2xaOJcbhD3RRAcNOniqL0SyJepNWUSHUOrrg9cpMIHxb
         aGSoKOBKrCco/RYa4pdppHwBuEZye37yQKcMD2mpLMySpSgcJuYxYgCwb/2u1o7fXHbj
         1xXU6lnxulAdlMpKM2adW5Q9YxXfJ1c2AJycMlv5TrO8r9Fb1AlzXgrwgBWSzQ2gKdvs
         nZSvSO2nB0A8O74S6G/MYlgmrUHV6CYlCPtWg7zduYeo+Bhepsn4ZUOHEKILsNPxVygl
         ILaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9FEUZoKX35faDAfXrpM6IFei7xFjPXAeLV4k+GBJGik=;
        b=CQKPDQHTvjoqykz0gTmkPo/U3fOQcKaE7pY4xk+XKq5J//AOZe4WpznPM6zdmHlHDV
         7/X33DslFMEBmD5itTgGrruz78h7IAnJmd04l/ZLgxA4uYX9pxdSuSwGDeVsEAxxDDL7
         CuMT2i9YxN+kAujHGdaAUmZ/hSDIODe+WSjUpoWLYfPoeu/5BNi+8VMIlHExQKZ+ia9w
         Q5orTVnDRhzD/FYhSuonAarqWlvSKEOfEgbU9tiW3RDfPzAHYBFHq/9+gw3HXIAf+WVx
         RrFBx83/9hu19Dw06J5OuH55hEa6WA1G5zMJxPsDBlB5rIf1cFvzdF3pCkG0aVaGfHoh
         GKRQ==
X-Gm-Message-State: AOAM5324SD4RjLmfqm/mqO3uAPp5IS0YKzevx/Jr7jo22qXk1r5G/3H6
        j8cq+6Yqu8CGW5ZwNnWKieAUxl5hp7i+rcj4xmo=
X-Google-Smtp-Source: ABdhPJx0pJ9o4mcGQlydCw7VFlTtk6la4tq3ydSqW9JH2ff8rWS9r/WhxKLDf8cjHe4fIb1A4Ne8/w==
X-Received: by 2002:a63:9141:: with SMTP id l62mr18326372pge.30.1637879416538;
        Thu, 25 Nov 2021 14:30:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i5sm3269368pgo.36.2021.11.25.14.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 14:30:16 -0800 (PST)
Message-ID: <61a00e78.1c69fb81.86c23.8fb0@mx.google.com>
Date:   Thu, 25 Nov 2021 14:30:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.290-205-g54bc9d253e82
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 118 runs,
 1 regressions (v4.9.290-205-g54bc9d253e82)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 118 runs, 1 regressions (v4.9.290-205-g54bc=
9d253e82)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.290-205-g54bc9d253e82/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.290-205-g54bc9d253e82
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      54bc9d253e82bcebc83659627f196a0a8890a558 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619fd3a46cabd64810f2efa1

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
-205-g54bc9d253e82/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
-205-g54bc9d253e82/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619fd3a46cabd64=
810f2efa4
        failing since 12 days (last pass: v4.9.289-23-g6ecf94b5fd89, first =
fail: v4.9.290)
        2 lines

    2021-11-25T18:18:48.972810  [   19.786193] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-25T18:18:49.015279  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/125
    2021-11-25T18:18:49.023049  kern[   19.836547] usb 3-1.1: New USB devic=
e found, idVendor=3D0424, idProduct=3Dec00
    2021-11-25T18:18:49.034362    :emerg :  lock: emif_lock+0x0/0xfffff230 =
[emif[   19.847290] usb 3-1.1: New USB device strings: Mfr=3D0, Product=3D0=
, SerialNumber=3D0   =

 =20
