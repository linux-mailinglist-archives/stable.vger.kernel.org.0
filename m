Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98959481509
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 17:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236284AbhL2QNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 11:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbhL2QNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 11:13:00 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A52C061574
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 08:13:00 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id z9-20020a17090a7b8900b001b13558eadaso25117074pjc.4
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 08:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y/KD7D1sRMyhVxQzusJjch/ht/xQorKuJg7Vhx5Z98o=;
        b=CAH1HYDclZZHpPytl0+RCiA8USDJxu/fnqirv9z+LhaNU9JD/iaREgbhEAriXogEYI
         +tNJIrQQ8zzHzT6HM4nC6/IyKzUiitBd5mgSzuy5hC/X4gBeuOMAXoudtaDGtHU/IObG
         OJEgggxH8qFzdM0mrN2c94Z+lAMT5kA7nwqR7jD7di7KFHPMY85mOKhBB3OtkoNsfa25
         MXiC9AJw83qt0S9hGycdZ7Z0PB+FNI3tbOrFHbdPn1OubMPzWKVbkQaEwX0dOaXUQcn9
         ZPo+grmuaO91xnkCbZEsX6SIlMAnkbSGyTtxJvQwD8BgBuLk+irk77kgNimhxPdCjGBp
         Nltw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y/KD7D1sRMyhVxQzusJjch/ht/xQorKuJg7Vhx5Z98o=;
        b=RP1GMB8knIiFC9fDnPgxVLs9iM2Rb1BIoE4i8heCPn40c1VEvA+sebFFSVzZpTeIbL
         s4EOj3V9Vm4qoLdPBRovKHNafd63kSAJQq7aFbLL4xpSUlbfiJhA4XzLgYZwCe/3Gkpz
         CbDpt33gOXKXBon1LiZd8wh9nCXxG2qKIR0ymb9FsDb7J3RvWFp2yaiVNzmNZhzsVC/7
         vA2keu3ehv47kmaEgQ4TaBpvX8fP2SLbvZJ/SdUlBgCV2VE8P/qAR6dNFOpsLNdBHbkx
         1vrbFgS9UQv1zMFAsrfScwi4Wq902SSqMUgtNtUk4ShNLhsukIJ3CTWR6KP9x0LA6lQG
         KRfQ==
X-Gm-Message-State: AOAM531z3SVKZ0LjEaSlnz38ytrqqyd0Rcz50QRUotOmJAU0Co6gJ7V8
        DsJE1DlVdH4fAjFLWFAVgKjtTfAbMGkSl24X
X-Google-Smtp-Source: ABdhPJwe4Y4SEs6gUZFTtgu+YlXTScnF2sUmSs05Yn9kPOhw85GMMVPuA52d0cFjiY9AImQzNEt37g==
X-Received: by 2002:a17:90b:350d:: with SMTP id ls13mr32654363pjb.157.1640794379391;
        Wed, 29 Dec 2021 08:12:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t191sm20639232pgd.3.2021.12.29.08.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 08:12:59 -0800 (PST)
Message-ID: <61cc890b.1c69fb81.512d6.ab95@mx.google.com>
Date:   Wed, 29 Dec 2021 08:12:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.260
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 145 runs, 1 regressions (v4.14.260)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 145 runs, 1 regressions (v4.14.260)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.260/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.260
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a6ca7c65b1376f7bb14979cb745d3da73c8de948 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61cc4d52573c697d6eef6741

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.260/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.260/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61cc4d52573c697=
d6eef6744
        failing since 15 days (last pass: v4.14.257, first fail: v4.14.258)
        2 lines

    2021-12-29T11:57:53.111405  [   20.393951] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-29T11:57:53.153707  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2021-12-29T11:57:53.163277  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-29T11:57:53.178133  [   20.460845] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
