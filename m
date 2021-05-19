Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C392389247
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 17:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhESPMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 11:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhESPMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 11:12:42 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2874FC06175F
        for <stable@vger.kernel.org>; Wed, 19 May 2021 08:11:20 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id z4so5011070plg.8
        for <stable@vger.kernel.org>; Wed, 19 May 2021 08:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zvIffbozy3q76lD+T8GfJ4dxtebDKbscZJ8ErC/MN3c=;
        b=WrghO79+DuRYyY+swrrxk4t5A1vvIv6MSqnvkACuhP+wboRhrP3ROE5vSnAzqg2YZd
         9o5fB8U5vWyPnYjwmYL69d0n0aWsrESk8Gz+GNgWbFQ3lHcSHqyMh7KSgmrRsSalzqM6
         qcE60mPEDU9XP+ahHINEr5hMf3K3QmUiduBx6ytAb9I23Lj6YOdkzrwodOPP6ofeQcmC
         spadMot19PTaKML1uKTZGCO9gyJfUlM4pWyLe9UHNXkPDMQzzRMlrgftacT9Am4CBlSq
         90RTkjvWx31RSccBsrTqd/rqM9YEBDb8r5UZMHoCX5BAjNydxsPOGf+odEYg5vOT9UNb
         +Ltw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zvIffbozy3q76lD+T8GfJ4dxtebDKbscZJ8ErC/MN3c=;
        b=FZdkaftVUPqYA+zbGQ0esSykHRIg8gVyGiv67HaqKI6LHeSLnlUlkkpM6p8TQsKIf6
         BwcPVPW52LdCehh9rfC/Ihncpr53u/S7sAmrnGwwTr7SluAKF1dkwkmYqWz0hcu/McC2
         uNHckxHE6PRikezukAehySPWwvFlrggvfKgyHSNqA5AZIml59OmXwMLqkmnkY0mUF+na
         ot4pJqjOC+YyXyi6ZEkgqu+yDdlwrTfrXNO4l9Cxhs86B1GEsIenazuPpFIXE3j1WsCr
         hChd0xhZp+wkYY5Eh98YlPVxwU0PUp6oXtYKTi+AUecgZvRU6tQ9fPUSpXM+EU1h2c/Z
         s4og==
X-Gm-Message-State: AOAM530Pj7R0KvZGiNQQYgG8VG/dMmnm9Ln2VcKmVmvp5/0vAeuhAF4m
        jx60nyU1k3c6nzF5O9FlbTyiah54LL8OBA==
X-Google-Smtp-Source: ABdhPJwFagbiYb6LZK4xaEb/gn3fKBn4IqsBWOW3Rx/adrwLE3wWVKR38eY32a/be7xcOeaEVR52Mg==
X-Received: by 2002:a17:90a:7486:: with SMTP id p6mr386952pjk.216.1621437079385;
        Wed, 19 May 2021 08:11:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b17sm15316463pgb.71.2021.05.19.08.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 08:11:19 -0700 (PDT)
Message-ID: <60a52a97.1c69fb81.df639.37d8@mx.google.com>
Date:   Wed, 19 May 2021 08:11:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.37-289-g187a01a57902
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 164 runs,
 4 regressions (v5.10.37-289-g187a01a57902)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 164 runs, 4 regressions (v5.10.37-289-g187a0=
1a57902)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
         | regressions
-----------------------------+-------+---------------+----------+----------=
---------+------------
bcm2837-rpi-3-b-32           | arm   | lab-baylibre  | gcc-8    | bcm2835_d=
efconfig | 1          =

imx8mp-evk                   | arm64 | lab-nxp       | gcc-8    | defconfig=
         | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-8    | defconfig=
         | 1          =

r8a77950-salvator-x          | arm64 | lab-baylibre  | gcc-8    | defconfig=
         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.37-289-g187a01a57902/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.37-289-g187a01a57902
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      187a01a57902720710957177a84a93e8376704ef =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
         | regressions
-----------------------------+-------+---------------+----------+----------=
---------+------------
bcm2837-rpi-3-b-32           | arm   | lab-baylibre  | gcc-8    | bcm2835_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a4f7a4019067d234b3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
289-g187a01a57902/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
289-g187a01a57902/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a4f7a4019067d234b3a=
f99
        failing since 1 day (last pass: v5.10.37-289-gf12d611314b3, first f=
ail: v5.10.37-289-g371f71e1d51b) =

 =



platform                     | arch  | lab           | compiler | defconfig=
         | regressions
-----------------------------+-------+---------------+----------+----------=
---------+------------
imx8mp-evk                   | arm64 | lab-nxp       | gcc-8    | defconfig=
         | 1          =


  Details:     https://kernelci.org/test/plan/id/60a4f93725b5c5c5b8b3afbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
289-g187a01a57902/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
289-g187a01a57902/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a4f93725b5c5c5b8b3a=
fbf
        failing since 1 day (last pass: v5.10.37-260-g2c9127d0fedb, first f=
ail: v5.10.37-289-gf12d611314b3) =

 =



platform                     | arch  | lab           | compiler | defconfig=
         | regressions
-----------------------------+-------+---------------+----------+----------=
---------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-8    | defconfig=
         | 1          =


  Details:     https://kernelci.org/test/plan/id/60a4f8e5f100cf0461b3afcb

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
289-g187a01a57902/arm64/defconfig/gcc-8/lab-collabora/baseline-meson-g12b-a=
311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
289-g187a01a57902/arm64/defconfig/gcc-8/lab-collabora/baseline-meson-g12b-a=
311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a4f8e5f100cf0461b3a=
fcc
        new failure (last pass: v5.10.37-289-g6deaf6c7d6e4) =

 =



platform                     | arch  | lab           | compiler | defconfig=
         | regressions
-----------------------------+-------+---------------+----------+----------=
---------+------------
r8a77950-salvator-x          | arm64 | lab-baylibre  | gcc-8    | defconfig=
         | 1          =


  Details:     https://kernelci.org/test/plan/id/60a4f88136c6e5ec95b3afc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
289-g187a01a57902/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
289-g187a01a57902/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a4f88136c6e5ec95b3a=
fc7
        new failure (last pass: v5.10.37-289-g6deaf6c7d6e4) =

 =20
