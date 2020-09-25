Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0256D278B07
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 16:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgIYOg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 10:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728888AbgIYOg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 10:36:57 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1E5C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 07:36:57 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id bw23so1953519pjb.2
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 07:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KPHrcUkVWb+k2OBiEyzForw0tZ5Lun/HXkFZSWVJ1KU=;
        b=Jdqui34f0aRxs9xTp87rmICwc2tUHqxd7VfXH6ASjIqOIl9QR8EPiXnq5HdxGmvmKX
         fCgEbgMAppZos1FFmmH8LmkvBLicmmQyFjvmAanwT08T4YJ15Kx5IHWhlyh7zBQOD/6W
         j1Um2+ffztON73gzichsf4XsiDkCiHDaAvDJ4ClZPRA8RXlYi5oUxFmpsynmTmueFMKC
         u5rYBzPiaSvBXnHJVKXWNe16Nftiu4Th+S0G6xJklr49aKu7MDByIqys5ac3Mjh8cxNC
         X2027b3qfELdq4aq6aMj7eIvfFQKza9v7vAJ7PV9Zl83ih1BUg2ac2eMoYk2jRc0Kf1j
         mp+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KPHrcUkVWb+k2OBiEyzForw0tZ5Lun/HXkFZSWVJ1KU=;
        b=esjK+3U81JCPVpQ1K6LJf5H/M86xHzLzSdKIe7tINq4rsCwFDBCccaalXX7NyGCYv1
         mYgaHX8XBsPq1unJNR4UkCFY93Jx+bSX1/CQMgfkaWLcvw+9Dj5pLbF/20a6r4UlZwIT
         17GVq9xfW6kaO0SuV6YxV50GsMmf8EKTVGOouB4OiedDxTtGjYmaLHC+6JvPpsEBDHr+
         +AY1VhAVXOrhYUDw9W/feHzz+MSIp7iUzN2r6xXBgqKqe1EinuA+z4g7CdVDuXI3BgRH
         etmBG7fQorNJvkBsqrCtfI7Jq3PGvV8Jz0zmEZUcw9HA9tIvDI24zLQ3IH1AWMCvU1Bd
         iDWA==
X-Gm-Message-State: AOAM532JAtKKdZwxlONT+JjoBzktX5lZ68V1GKRdGPRz6Ec6ZYZqOZqh
        le9f4lkWaILo+E0HmcU9uKQJrxfzWN4eNw==
X-Google-Smtp-Source: ABdhPJwigcdQyhqOWVOO7EngpQj7IOk1kyrWted28YDIz82xBOwf2dvztsXIxjvB1S7lOnIyf4frqA==
X-Received: by 2002:a17:90a:c798:: with SMTP id gn24mr596507pjb.49.1601044616862;
        Fri, 25 Sep 2020 07:36:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 126sm2905643pfg.192.2020.09.25.07.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 07:36:55 -0700 (PDT)
Message-ID: <5f6e0087.1c69fb81.9810e.7dd5@mx.google.com>
Date:   Fri, 25 Sep 2020 07:36:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
X-Kernelci-Kernel: v5.8.11-56-g01a94ace543c
Subject: stable-rc/queue/5.8 baseline: 179 runs,
 1 regressions (v5.8.11-56-g01a94ace543c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 179 runs, 1 regressions (v5.8.11-56-g01a94ace=
543c)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
esults
-------------------+------+--------------+----------+-------------------+--=
------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.11-56-g01a94ace543c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.11-56-g01a94ace543c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      01a94ace543c5c141cce4825e8f4bc2ec8e87d29 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
esults
-------------------+------+--------------+----------+-------------------+--=
------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
/4    =


  Details:     https://kernelci.org/test/plan/id/5f6dc5fb5f0ec704b3bf9db6

  Results:     2 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.11-56=
-g01a94ace543c/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.11-56=
-g01a94ace543c/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5f6dc5fb5f0ec70=
4b3bf9dbb
      new failure (last pass: v5.8.11-2-g52fb84070999)
      4 lines

    2020-09-25 10:26:56.559000  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address fffffa9d
    2020-09-25 10:26:56.559000  kern  :alert : pgd =3D d54fcccd
    2020-09-25 10:26:56.560000  kern  :alert : [fffffa9d] *pgd=3D2f0de841, =
*pte=3D00000000, *ppte=3D00000000
      =20
