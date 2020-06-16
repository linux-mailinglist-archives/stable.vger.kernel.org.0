Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F9E1FC109
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 23:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbgFPVe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 17:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgFPVe0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 17:34:26 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D345EC061573
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 14:34:24 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id 35so3665469ple.0
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 14:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0ErZeOCH38mn9inPdsCk4TrImlsWYxGiosI0rzoVnP4=;
        b=EUnJzoTgB118W7lmOAT/4qe6S7USVXxeBC5tFPaQJcbTMeJphX2S6b3CvJh5acsqxW
         o3VIqc0H9UabWeSdnuxI/9oTsiT1SwCDfULO2C7lEkssmaULXPdqtn683H5foUk+7+ca
         s9VxH8SfHPU3MKrjsn+QY5a76MGAtDivFmnvem/Vc8bSAoDF1lUQd940OXH/MIXKSMcC
         oCbU5dele/l4LXzEtijkKkkEIA93oNnaRfyFgcGSrT1KrkeM14nuSyRCwXuUfE5HLDHJ
         lwOuII23IamTuezrZAJ9qUidNx97Cz0skUqpoDrs0/tI/z7Bic+diuVoITfQIBAns8u2
         iePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0ErZeOCH38mn9inPdsCk4TrImlsWYxGiosI0rzoVnP4=;
        b=pMSMQzDoRQaWUEWP/SPHgnfkhP01I3m/nRxMb8rzX2A/Jo8gj0ymplDj15cAoZsJDV
         MV4qO8obR/u9OL2Jftec0trMVaa5n+LHkbUSNy8cES+9uuQvfpFxq6zeptC6Mj8D4pGH
         pS7BGBubMk4M2MZZdltcI80I8OgbevuW60A2j+Xx+65TDskZcLe1TnPkNYu4K1vDs6aQ
         qQ15lg8vYLv943cSq+KMapXmnXREwJ77XyQrCcY09Jlw/Q7sINZOj4vdhMkOubh7RncR
         KD0sR0Gj7sum+Fw7vWa6DMRVQyMEY8tB/LzAsHU2ROPabzIL0bEIQFSJSJTSzF+Puhul
         /RwQ==
X-Gm-Message-State: AOAM530NXwoTrmyALj7juZlwPVinR4kCB/hxylZ2AK31tqJAVF9NFaBp
        EoF7GoBkSFfsq9Il28rsWw5IZRLH/pw=
X-Google-Smtp-Source: ABdhPJyPyOsx0vt8VSX9cMygkHkpew4CLurwop3vrVPrnxRXplPtTMfuIOp28XZdZcfM3VDSZ1mhNQ==
X-Received: by 2002:a17:902:a585:: with SMTP id az5mr3686607plb.207.1592343263214;
        Tue, 16 Jun 2020 14:34:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n64sm15394042pga.38.2020.06.16.14.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 14:34:22 -0700 (PDT)
Message-ID: <5ee93ade.1c69fb81.12f92.07c0@mx.google.com>
Date:   Tue, 16 Jun 2020 14:34:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.126-148-g9301a9b9c27d
Subject: stable-rc/linux-4.19.y baseline: 75 runs,
 2 regressions (v4.19.126-148-g9301a9b9c27d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 75 runs, 2 regressions (v4.19.126-148-g930=
1a9b9c27d)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.126-148-g9301a9b9c27d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.126-148-g9301a9b9c27d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9301a9b9c27d4cceb0092e65c9ad0844333a146a =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee901edd92b0148da97bf14

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-148-g9301a9b9c27d/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-148-g9301a9b9c27d/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee901edd92b0148da97b=
f15
      failing since 0 day (last pass: v4.19.126-55-gf6c346f2d42d, first fai=
l: v4.19.126-113-gd694d4388e88) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:     https://kernelci.org/test/plan/id/5ee909a2d30c39a72497bf09

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-148-g9301a9b9c27d/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-148-g9301a9b9c27d/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5ee909a2d30c39a7=
2497bf0c
      new failure (last pass: v4.19.126-113-gd694d4388e88)
      2 lines =20
