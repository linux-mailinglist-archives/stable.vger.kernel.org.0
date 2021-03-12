Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4831B33970C
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 20:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbhCLTDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 14:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbhCLTDf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 14:03:35 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85721C061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 11:03:35 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so11520687pjv.1
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 11:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hA4Zrhh5IpmLPJMUSIKzyLnMFfFqCg2JxNFmMaDj2Bs=;
        b=BEveGR5xhgQpNpvbWgRL9E4WtPIkx8WzrsShjXlgmthHNc7T9rVAph6JTHPF08WS3D
         xPqZhyx/dpqRhmURvAPfCT/CPg/kT7etVsHBN1LAGxAPJSaYt4RgpBnsuS4qxykECaSE
         4QXkgKlSvHvd+Mc0DoAhGUsI4zJW+nTmnZXU0nJMGmoIePvzK1QzABNA+0hWLCPIQRUd
         WHCB+a450t0AK1jzDHHRfpROzd+5zPz0SWqaG/ozNym9BYabQwBx6+QZblcVIpciHIll
         a3UaFaR+V947/qj4mUflF9/E8HrdgW9wCPSmCmZF/kE2AhQmhg9b4LwiNFKfw2KQz6Gu
         ywng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hA4Zrhh5IpmLPJMUSIKzyLnMFfFqCg2JxNFmMaDj2Bs=;
        b=mGp+a+anr1R7C86a94NFNwv00NcZ136dfi8SQHLayMpWzCO0J4QlMf0zGKWXAN1Hvd
         leY+wNI5uxs+6fAr/Sqvjp8D2d7fhp3YIHuXFNZgcLPaSbuuvvFmM3cScp7ov9GgZpsM
         PFGYdbQHXFV6am4HI5US/YDRAGisbD6jDx/BQuPTJktU9Y+JgE6NmhWkbdSDZZPIeayy
         DexluOU7ANV6bLmUCQjzJinAz7NtXooid+mq1Lq1XQTpuA7SqI1wmuok/JC2KzY6fDHM
         qsKAcOI/adfuF5GpOLDJ5zcGUBuswordReGha66vOXzsKB1bk7FNQVuG99E529XQtulc
         HWWQ==
X-Gm-Message-State: AOAM531b0UjFRDDQ010+mk2K5XH2/i7PYmeJS/AADFwKad9stK+FhtGY
        AN+NjkOND1nrYV3/JL92ouQEKVjhRJ5HaQ==
X-Google-Smtp-Source: ABdhPJx4K272wYNkaJeeWJ2Q2EZH+2I9X32gKFHzTDaLpVVo6or9YxQ8z8kwjB5G/caEGJS3MrFw9g==
X-Received: by 2002:a17:902:9a93:b029:e6:5968:f77a with SMTP id w19-20020a1709029a93b02900e65968f77amr447438plp.77.1615575814912;
        Fri, 12 Mar 2021 11:03:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q11sm5854562pfh.132.2021.03.12.11.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 11:03:34 -0800 (PST)
Message-ID: <604bbb06.1c69fb81.faa0c.f747@mx.google.com>
Date:   Fri, 12 Mar 2021 11:03:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.105-60-ge07ad67f9cf4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 157 runs,
 1 regressions (v5.4.105-60-ge07ad67f9cf4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 157 runs, 1 regressions (v5.4.105-60-ge07ad67=
f9cf4)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.105-60-ge07ad67f9cf4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.105-60-ge07ad67f9cf4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e07ad67f9cf4dfca302a9bae57d8197df1c8d5ed =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/604b9267c0458bbe6baddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.105-6=
0-ge07ad67f9cf4/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.105-6=
0-ge07ad67f9cf4/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b9267c0458bbe6badd=
cb2
        new failure (last pass: v5.4.102-93-geb81dae4b3276) =

 =20
