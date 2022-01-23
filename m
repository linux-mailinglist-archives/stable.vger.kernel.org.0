Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF024975EB
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 23:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240303AbiAWWOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 17:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234697AbiAWWOy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 17:14:54 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8A4C06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:14:54 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id e8so13763947plh.8
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=41JxWFor7MyZdlk6jKCGDkeAjanOWLg42N6VXsqsTqs=;
        b=IeQ8C/bEXAWQGfKUS5Ke//QRvzGhBxqg6jatiTKp/GWZFwi4JhjsFN4CnLiz0u7pSQ
         NdomrD2x0q6X8CkTt+qbntp3Cr060Et46U0aUFEpCtQX+NDoxYdSEDc7dIbnPKylNeeV
         W8WVkBFyz+QcYvrTcLnmR4PkpoeZ/bVSqVxhvOlzRSwOBIPni8TJU8xkuAOp/9QixIoK
         +AyhPpg7d89MjQqPEKbPW+OcZeCVPlimKvvVXEKmY8SfirjE/VMBhCMElfyqMDkYYCbO
         JkvYSk6bi/ifLurD7OCkV6DU1Rib5fvRduI8wainMR1eMq6UmtBOkcx4QWnb3Qog6v4q
         0xeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=41JxWFor7MyZdlk6jKCGDkeAjanOWLg42N6VXsqsTqs=;
        b=xYeZlRAaUgKHd6AYzWqQQtC9tLmIbTgb8emyNRPWWlWlfTOsbOtnF9oiw0aCcyL4kx
         ySEMPuVe0Tezv+7e0hJnnB5VeGlVmZn9xYUrlVMsGvmG/VJbGiCjhvnRhY49haJfNZTh
         S6xjbtYhPZon0eIX0DTpJwkml9Nq6TeH5scMjqcL90DSsGnNDmP35g2+39EuoAW5qhpA
         z1adjXwdh+sNCEPECqVdIi748Ggb21Nctx9Nqlq6Jgt1qPBHjmJfGCgWiDUc/PX2vZr7
         NDc6P7/EHXK2buh6WUbdE3gz1OA5xb76ZzNGhck2563mJgOW9uo5zvnbBwc4nRjTM1vd
         FWaw==
X-Gm-Message-State: AOAM532ERyKUjpTk/iZPj901fXVnKidnY2PQOUWvFt4DiQnNKY5rgaQ8
        aqMoFRkWtTjyANueQeVkxa7ay/Qam1sqYoW2
X-Google-Smtp-Source: ABdhPJxVrDRHtbCNvAS3waXS7ZiPRNgAOkm0ZJT28WVMvltd+q+kHh1tbC5MA98E4zuIotGbA2/Aiw==
X-Received: by 2002:a17:902:be08:b0:14a:ef2e:60e2 with SMTP id r8-20020a170902be0800b0014aef2e60e2mr11871822pls.128.1642976093705;
        Sun, 23 Jan 2022 14:14:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h14sm14648307pfh.95.2022.01.23.14.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 14:14:53 -0800 (PST)
Message-ID: <61edd35d.1c69fb81.21e92.7c41@mx.google.com>
Date:   Sun, 23 Jan 2022 14:14:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.225-201-gc1bcacb76e00
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 149 runs,
 1 regressions (v4.19.225-201-gc1bcacb76e00)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 149 runs, 1 regressions (v4.19.225-201-gc1bc=
acb76e00)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.225-201-gc1bcacb76e00/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.225-201-gc1bcacb76e00
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c1bcacb76e00858da628d9e55dac4a484e0bdade =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ed9ad20b5610cf9eabbd28

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-201-gc1bcacb76e00/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-201-gc1bcacb76e00/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ed9ad20b5610c=
f9eabbd2e
        new failure (last pass: v4.19.225-176-g289f5624c6f1)
        2 lines

    2022-01-23T18:13:21.526523  <8>[   20.912567] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-23T18:13:21.574724  <6>[   20.957641] smsc95xx 3-1.1:1.0 eth0: =
register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet, ca=
:eb:2c:36:1f:16
    2022-01-23T18:13:21.581467  <6>[   20.970275] usbcore: registered new i=
nterface driver smsc95xx
    2022-01-23T18:13:21.590543  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2022-01-23T18:13:21.595996  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-01-23T18:13:21.614885  <8>[   21.001922] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
