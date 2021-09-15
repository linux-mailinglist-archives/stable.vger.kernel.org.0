Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1782B40C9DC
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 18:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhIOQPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 12:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhIOQPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 12:15:49 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EA4C061574
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 09:14:30 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id m26so3150987pff.3
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 09:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eWKDoC5AwVOHOG2jmwg1CmtyFREvbdfNjQvooaKqy54=;
        b=hXbZ8itFkHDcFy3vmvM3sbmmpPOlH+0o02/9MiTnRauCuo7zLe/y8XD4qTK0ZyIKey
         LqFYPhUWbx22nQiLuJcruvVBxMf+SiQoYS8YwbUyU9jzCckYezKFs6A2nG3MIjNeicYW
         iNclhzAou1BbFG/qZit0RJQ1JxSqiZLy5QSakn7vmqav+kccTukKsKfaNojvVY0cjQZ/
         Crwj7nVR+BrgEsiBwXqaEasfP0HBSMzOe2lpvBadFhGh/idUj8MDR9njVdegLaTi2VRY
         PVjYHpJtQtpGZfzJHKhScYr/KQ/lqK1ydNrMVETBGikH9K4kSpkYBTH91N5B5KugyhJa
         XU7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eWKDoC5AwVOHOG2jmwg1CmtyFREvbdfNjQvooaKqy54=;
        b=YWjU6F+X2+DLatRGvtpJ5a+jwqkLMSfWhX7yQDU9pohdWEkK0VUtSdxujr8yTfyPyG
         MgBBCMkeLWLRqt/F00r7JT1AreYrsEwNLi+ksfxTgSFKj+B905i+5u7nTN5y0JbEsDFH
         o2DPpgMfNWa7NK5npw7d+FwPOFKBj0vHjsGeQlcPyJpFfa/2OREXjop1tB0Uquf7lHG1
         htaJKmAvNZ2c4i5L2IbEzrxQ81AH97YGetSQSXYTxEfoR+fYXdxUIyjbvoEmVL2ij9Ax
         5y23UIwZSNinjneXL7d8/ZNTgX175lr3il2x4njTIrNIetFgVJ56IPuwJua6UJgdSRBc
         im5w==
X-Gm-Message-State: AOAM533ARBc5WzLdVyiCVq1Z7qLK0IZLHAWU3PCAbmyIqPzZZJYyxFQE
        nX2SfROL9gFpqRgAm8pX36VToviq+P/SnwlIGrI=
X-Google-Smtp-Source: ABdhPJwfQmmILd0bQLnoaE/jppQFQOPAt5jcIeRebxEOZUvcka+CGLr3XIz1X0aYdECX8dId0gEtYA==
X-Received: by 2002:a63:f241:: with SMTP id d1mr512097pgk.424.1631722469268;
        Wed, 15 Sep 2021 09:14:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m21sm386044pfa.216.2021.09.15.09.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 09:14:29 -0700 (PDT)
Message-ID: <61421be5.1c69fb81.eca07.1605@mx.google.com>
Date:   Wed, 15 Sep 2021 09:14:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.17-17-ge0578f173e9a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 175 runs,
 1 regressions (v5.13.17-17-ge0578f173e9a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 175 runs, 1 regressions (v5.13.17-17-ge0578f=
173e9a)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.17-17-ge0578f173e9a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.17-17-ge0578f173e9a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e0578f173e9a8648cf49cf1f1f3ab6f8216c7067 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6141e91b95ff28cfb199a2fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.17-=
17-ge0578f173e9a/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.17-=
17-ge0578f173e9a/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6141e91b95ff28cfb199a=
2ff
        failing since 1 day (last pass: v5.13.16-263-g6cdb0b2e1c97, first f=
ail: v5.13.16-300-gcec7fe49ccd1) =

 =20
