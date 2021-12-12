Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6C6471EE3
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 00:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhLLX7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 18:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhLLX7K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 18:59:10 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892DDC06173F
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 15:59:10 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso13462563pji.0
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 15:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=l0V1osDVudCt0WfCHcEniZ/QXj1WLjo3l7BfCzplPjQ=;
        b=Fj+o1DiI1fxxKEpUkKyaJHLvsix1DrsE9rBdC4EwLxZBh5jK5esTZhJSCpSOKkirFh
         jURoiv/gQhV5kHpmvGFE/oJMoMeOdpP+Gcg1fhxbnjWsYYn1eeA5jgznwwNYSnIL7iOV
         W8B9yPwrsFx2LUd89nc/AZ3kkNSYYVrtzbSxcdtNN8tITnCyvXTp1FfJ2DemMC2o7+81
         zJZOHqZAQK6ugC+6ePTIMQOtw3+/gKpfCN9h2w5fnpGQnejvA3gCvFKszCaizfADz3r3
         HjATNGpVtVS7GWtHDgsYVmBKZhod2SQ7yLfQddtiBUH3XXJ6/N5GozoOC0NPPfqNW6+6
         cHFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=l0V1osDVudCt0WfCHcEniZ/QXj1WLjo3l7BfCzplPjQ=;
        b=JUmIkbBJT5NIgFLXhJ5EDD6GQ6HCPSgdIKkYCEXTE+J+mbLxd2ZKVs7EeQSs2TLAPt
         fKngP4HOuEalRejIxtth0fh3MitGkMtUNYuvHHb7hN0FHIfsstmxv7aRc7ehnKitEVJm
         +QJYkjWYNqaDbkCcaQ+xiSzNJpLFV/cMPR/C8CZIQ8vAEhNz2ZhiqpveoL8Cm/GOYWQD
         CvazHI9GmkZcM79+5oBQ9/nh2sDBwbB+/23t4cbJQm3E4ux8tBDI3LpmSbPK3f/0NbvG
         9mazTsvnimL6KXK8LxkArooXZolBiSnH4zmLW4Slyde5DOLzCRSd7owYmMr72mlJ0FLD
         Ow6w==
X-Gm-Message-State: AOAM533et+wLVYv+jazFzDSNJRktINPztS64fjREvkOeJkAjiVfqfJiC
        QgxbZ8K295PB3tW1g5d/IhxWoE4m8xZWfXh0
X-Google-Smtp-Source: ABdhPJz6OCa18+NZdc4pt5xJzCBIdxksTppBpblj9fP7NAstDZy/ufvIrSE8EotyFkXH9NhjLROhlg==
X-Received: by 2002:a17:90b:3ec4:: with SMTP id rm4mr39820834pjb.88.1639353549765;
        Sun, 12 Dec 2021 15:59:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oa2sm4946983pjb.53.2021.12.12.15.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 15:59:09 -0800 (PST)
Message-ID: <61b68ccd.1c69fb81.e0b2a.d9e3@mx.google.com>
Date:   Sun, 12 Dec 2021 15:59:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.257-34-g5ece874a0959
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 135 runs,
 1 regressions (v4.14.257-34-g5ece874a0959)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 135 runs, 1 regressions (v4.14.257-34-g5ec=
e874a0959)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.257-34-g5ece874a0959/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.257-34-g5ece874a0959
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5ece874a0959e33dc635e70d295bb783236d98f0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61b6524941f344c03f397131

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
57-34-g5ece874a0959/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
57-34-g5ece874a0959/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b6524941f344c=
03f397134
        failing since 16 days (last pass: v4.14.255-251-gf86517f95e30b, fir=
st fail: v4.14.255-249-g84f842ef3cc1)
        2 lines

    2021-12-12T19:49:12.077027  [   19.788330] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-12T19:49:12.120643  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/93
    2021-12-12T19:49:12.129765  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
