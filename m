Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27443337E33
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 20:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhCKTaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 14:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhCKT3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 14:29:47 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36410C061574
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 11:29:47 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id c16so10742497ply.0
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 11:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rhZ6uPJJA/iLaIVEC/XDpklAvNgoZ8G8Etl3dH7BGhg=;
        b=bie03EXsrWLfwY2rr8Rhlc+LViIcaG3ziK1aYCjFXn+GMKQzHJAj4tlTjL/jdKYAwh
         i+JIn//XNv5U+L2IHmO/rdpzVKug9trEPZzCBVMT+uJMDt2v9NK+vSYL0yiiJU8bWP7Z
         m/1wUXSOXofXcVJFugzZeyBpkhimKHxPbjP9d8AcQKXnCIjL8cbOt9gPJXTmUKojdw2Q
         vbDguLiblbt3T43KEYhbMu0c0Aex+5RZpswZIkVV3yW5WKhHS22cWs5U4v4Qtq9zMp2M
         aO1qwsnMKuMVQx2fhY9It6ERj7CK3oTcWQPz7soYWXkL90FAOmfUw7JK9rtCT342E/mB
         g+og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rhZ6uPJJA/iLaIVEC/XDpklAvNgoZ8G8Etl3dH7BGhg=;
        b=pn5T9tQSXgvIzSM4ND9/aWcxNDU4Nq4xejIcfs+ue8INwqnFtNKl9SNpRA0P80hzyo
         M4a327BcEVJa4xhF4WpxSVFBEzmMmgNhoflJHkxf4Xui5ZDgitW4VrwwYij+LfklOSLd
         e6PurzBEyRLlXvb3s1luo3Kr2z1en+x6M3vlEk9cjyPonYFNVPlHOKN3cHUUNHE8OGJ/
         ZM96xeaxe9Hi/u80Ko1ONJecV0OvtdzpYc5N0XsTkmsSpNRKbzB2KSfJMXy0tfL4VGoa
         T5smrHKdI15Us4Hq/qtbYCIxp3GcQMuwzHzrM7ESf5oLznmj6/M5Ap+fKHzwUTfDQVAE
         hZTg==
X-Gm-Message-State: AOAM530/wKBroFkLgr9IvRq8TGnl5eAz/KOKnDyOBc5nwVZ5R5ZzF2ae
        VoT8TqG/wyHS9QxVN4g8uze9OKAPj8DZ7Pi7
X-Google-Smtp-Source: ABdhPJz4d/wylMqx5SassHetp4qMB+jiTEDMYPAF52xP02de9EQs3s0zgxp9WZRwmSyHHHVdc2oKfw==
X-Received: by 2002:a17:90a:bb91:: with SMTP id v17mr10020989pjr.24.1615490986555;
        Thu, 11 Mar 2021 11:29:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q15sm3385366pje.28.2021.03.11.11.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 11:29:46 -0800 (PST)
Message-ID: <604a6faa.1c69fb81.c5acd.93a7@mx.google.com>
Date:   Thu, 11 Mar 2021 11:29:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.22-47-g51b40d4c8a7f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 88 runs,
 1 regressions (v5.10.22-47-g51b40d4c8a7f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 88 runs, 1 regressions (v5.10.22-47-g51b40d4=
c8a7f)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.22-47-g51b40d4c8a7f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.22-47-g51b40d4c8a7f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      51b40d4c8a7f0abeb7f14ae69243668d4a1fa22f =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604a408ee62a44147caddcc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.22-=
47-g51b40d4c8a7f/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.22-=
47-g51b40d4c8a7f/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a408fe62a44147cadd=
cc1
        failing since 0 day (last pass: v5.10.22-1-g3a720b3b47d5e, first fa=
il: v5.10.22-47-gf4bf7bd9b1cb7) =

 =20
