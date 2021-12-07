Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C84846BCCD
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 14:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbhLGNrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 08:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbhLGNry (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 08:47:54 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96E0C061574
        for <stable@vger.kernel.org>; Tue,  7 Dec 2021 05:44:23 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id iq11so10330839pjb.3
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 05:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ioJ0fIC9nMqDhSwRIKVFw2ieuOP+mwmW7zOW40kjoqw=;
        b=ALcg7gwJs+KrkaK9eZRSihH8/sqFl7jbFprG0BD8aAB95ChI1Mmb+djFc58Tw/Z7sx
         Jee0TfBzHCShLiagOa3ZhrhiFcRxILo+n+Z75TZcY8tiiZ6GTjbgQnPcxDA37fao/Us3
         bj1yA8abKoFUvuPnpz9EUWW0zx4+lEiZzY9nsswJYWD4apmj9lcuHKazlSi7y7okfjCp
         zlGMFsYEZjhv3qvbeROTsZ7l3WG7Q8D4iCxHX6HevJKpRw8nhe59QFck161CuunhZp37
         CGxpZLIqDhCB3VCvNa/hTM2hfkFNLgNblkzpPIcHx2Zb0HKZkfwmqrDipaQQIKhv/FKi
         AKZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ioJ0fIC9nMqDhSwRIKVFw2ieuOP+mwmW7zOW40kjoqw=;
        b=Y+7/1XTiA2njncAIsCI/I1XZJxThymVH8IvT8LlgqVfGyhePJLWf8ueUDOUAyW5ziC
         GhnwvP+QHVlrsrtzdiWsOUm9uI0fsyhp+kA1PQhF5kDKp9E++pKPBBIawKR5wq/dzPz4
         a3a+klL/yPnuzBqyUZG3QeJVkjUkN0Mvtx/asragfY+mTnW1Q71l/gVhdS6NzHU1aVou
         TyBMORq49VHbPTrZMmp81IbHjgaaHp/cOqP8TrvYzBm29jwlx4kbfH2IP3kwdT+3THO8
         nW5Tki80YnSY8xbTOX9D5IAkYyUPE14FSR5MTBfvQRrHCkCUdu6XdzLPzncvpLZ6Dj9S
         7DRQ==
X-Gm-Message-State: AOAM532ahJyZ2+aRAnbuzHP7cqgrJrVF9uaboWjpiMBQ9DPdhTTgj5oP
        9fC0UxE3B9QUlgtXsGEfO6qTJBt2ZYhLFTMI
X-Google-Smtp-Source: ABdhPJx9GeeAea8lf0xQrTgu99jv11LKVp7qU31HKzFJUfAaU6e0sxgG5f+bTImRocb0JbsGwgaGDw==
X-Received: by 2002:a17:90b:4c02:: with SMTP id na2mr6849054pjb.94.1638884663119;
        Tue, 07 Dec 2021 05:44:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fw21sm2862121pjb.25.2021.12.07.05.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 05:44:22 -0800 (PST)
Message-ID: <61af6536.1c69fb81.9cd9f.8001@mx.google.com>
Date:   Tue, 07 Dec 2021 05:44:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256-106-gdcd74d7b3f01
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 146 runs,
 1 regressions (v4.14.256-106-gdcd74d7b3f01)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 146 runs, 1 regressions (v4.14.256-106-gdcd7=
4d7b3f01)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.256-106-gdcd74d7b3f01/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.256-106-gdcd74d7b3f01
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dcd74d7b3f0145ae68e21f64b4d836df2e380af4 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61af32d3920ad856341a94b0

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-106-gdcd74d7b3f01/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-106-gdcd74d7b3f01/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61af32d3920ad85=
6341a94b3
        failing since 1 day (last pass: v4.14.256-86-gce5b7722e4968, first =
fail: v4.14.256-96-g0a8417bc52507)
        2 lines

    2021-12-07T10:09:06.036579  [   20.182434] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-07T10:09:06.078182  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/95
    2021-12-07T10:09:06.087084  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
