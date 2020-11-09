Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99B82AC178
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 17:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbgKIQzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 11:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730149AbgKIQzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 11:55:06 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5165C0613CF
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 08:55:06 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id t22so5013433plr.9
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 08:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=E2B/3KJwRbfihJCJrrdkWi5UmsNPw1Ae5w3Jt1xeez4=;
        b=PNHpB/xfHwnEj/voYFyJIs9//yZOUluuzDptDlHecFoh3w908OO3rbMRyjRADjHwFl
         NSA2HLM4GKSLdW/lgHO2/3MbTQmPAqsxPRSWtuNEUgkbJWPhIMvVlNyR0dQKM4ACqyi0
         NWac63yXk9rfyjhwaDUOXeXkq1O6EQLtBQehyFGSAvv1O2cVWnG3n8l/k6N5cdLg8S9C
         2U/AOx+BBAL0IrvdEGKMdDlbqyfs/Fk/TRy/2Xk0UG53KNFJ4pM1kUCiENuvu/uUmv45
         ctUq/8KOWIDcBFNXMuc4ZVr9DEcUuREYN+GOKqJWGtnrwGovslfEjXQX+9c/NV0n8OrN
         UIxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=E2B/3KJwRbfihJCJrrdkWi5UmsNPw1Ae5w3Jt1xeez4=;
        b=RcQaN5NVmVeAbP9yc8chgGaB4wiaQJjtePt/393cSnMpPmIa5L6I0IrS3fRV13rkDt
         Tom+CmSGQhnhYqM/tcSTphy5tdV+Cp/Z9cJgnmznzbFPGhNqD/Z8H6TCVktpRMyh/iyh
         cADJAHt4pC1/fq25oxh/vG+t9VKWLRVsXfP/bo8jeCyX4vpoxc14l9zT88D9VKCA7x4+
         vy1f5MgQrwY+hY4Cn/x/3/j/NmSOCoRqIBE6qcfMROh5QCoLdlwDdjMxiLy/aBvJ6qPE
         BktaxhnPf4UISymV8PseRrn3LU7lNPiaW+nxbPc4i2tpApVUooFRR5QtkEAetb4JalxY
         /4Rg==
X-Gm-Message-State: AOAM530jjY7fe3i9nuRHyTNosU5nj6SD0yPTZzcc2m3Kwl0vdpgeduCs
        87z05NYzgpedjRD1LksiHYVd+iDXqmIdpA==
X-Google-Smtp-Source: ABdhPJyXfJy9RRZLgNLOIQOrPya0PSM2ByqrMeSgVrXgwCAvLaq8bdXB9mjT3AT+e9xMXwKS6DaixQ==
X-Received: by 2002:a17:902:ab94:b029:d6:9c3:e99e with SMTP id f20-20020a170902ab94b02900d609c3e99emr13307411plr.68.1604940905461;
        Mon, 09 Nov 2020 08:55:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w131sm11590120pfd.14.2020.11.09.08.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 08:55:04 -0800 (PST)
Message-ID: <5fa97468.1c69fb81.d5a6a.8ec1@mx.google.com>
Date:   Mon, 09 Nov 2020 08:55:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
X-Kernelci-Kernel: v5.8.18-26-g1bfb85c48918
Subject: stable-rc/queue/5.8 baseline: 150 runs,
 3 regressions (v5.8.18-26-g1bfb85c48918)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 150 runs, 3 regressions (v5.8.18-26-g1bfb85c4=
8918)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b    | arm64 | lab-baylibre | gcc-8    | defconfig         | =
1          =

bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.18-26-g1bfb85c48918/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.18-26-g1bfb85c48918
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1bfb85c489183b525740034743fb01971ef72127 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b    | arm64 | lab-baylibre | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa943f65065e370f1db8870

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-26=
-g1bfb85c48918/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-26=
-g1bfb85c48918/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa943f65065e370f1db8=
871
        new failure (last pass: v5.8.18-26-g348ca36c1eb0) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa94234a1e90d80a7db886d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-26=
-g1bfb85c48918/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-26=
-g1bfb85c48918/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa94234a1e90d80a7db8=
86e
        new failure (last pass: v5.8.18-26-g2f46df01d254e) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa944a1d1988680ffdb8884

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-26=
-g1bfb85c48918/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-26=
-g1bfb85c48918/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa944a1d1988680ffdb8=
885
        new failure (last pass: v5.8.18-26-g2f46df01d254e) =

 =20
