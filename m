Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DE14A315C
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 19:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352989AbiA2Sfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 13:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352959AbiA2Sfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 13:35:50 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F32C061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 10:35:50 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id d187so9130641pfa.10
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 10:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n8ifQ66DS6pDNcEcS/08EMq1a0OUjhwTjs/apw3H/AA=;
        b=P4LpFJyFj6RldkdvaIU7JF+V9MtLJQMxIGfbC/Q5TceQchY2BhaCoGSKF9glWMylll
         TdypXohOCv6WPCPA3EvUmojf2M/n1nR/WsBUHWP6G6Kn2xhBo1hZBVENoz8LMKUYRo1w
         tYd+CQbmh2WqaXQ7xEtORcFb6nqqNV0T/6GjciXXd6M8SlkZ+PHUGEmzkKID2blt8AT8
         vy9LxYFhzSdVYAIyq8saadxSeTnP6QvvkLIQnSurfSxSAzjSKZ1s9QAu346xSKjhwrgi
         VA5Y9e9W6fATQ7kIBGNPUDl8zmTFn1chLqnQZw3tt4hcmVxJj7D/9g0ZdkM7e8dsh/vh
         XonA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n8ifQ66DS6pDNcEcS/08EMq1a0OUjhwTjs/apw3H/AA=;
        b=NbPyw7j4QoCHFlQh1y6Gw63QbUtzH30JGrZ4ipXNi1qdG0S6bxldqivnfsnTb3pgPq
         uJisEVk6u1FN1/f2Z79+DJxUSbVl0tE5YKBkiBhrEDofXNoNGzJlJ60OsktpH+L/xjjZ
         Pj8GXvFxKHSmEdA03ZGfVelexL2AG30nYg1ye6pa5dKkyw+/cyUbYsZfL6EYSfa65AA7
         MKA+Dqs2iMMSaKqAdGJ4rpK+Iq5ma2f6P3NOCieVutkYio2SwG0bxMYaDpcwF2LhQJDC
         PBPOUyRsXYH5umkwTr7n+wefm8GDjajd5Pi80PlYMiv4K2jzwEy7x0kkS904CQRUGOBT
         U4tg==
X-Gm-Message-State: AOAM532017b3BlhQpEQGhbLJie2fsLgJilKi6y9dS9LIoZ0pdVk7fLl8
        +yjbq0OvDLLYvqrT/S2v1e+Di1NFIpYYMUvk
X-Google-Smtp-Source: ABdhPJyfqV/1zyoCRibz3qoz5hwHdMlm9byphq2qWsgFaHrJoo2IE4VRgCkNRlT6j1dl0XAdVZ274w==
X-Received: by 2002:a65:644b:: with SMTP id s11mr4823691pgv.29.1643481349459;
        Sat, 29 Jan 2022 10:35:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nm14sm6156561pjb.32.2022.01.29.10.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 10:35:49 -0800 (PST)
Message-ID: <61f58905.1c69fb81.8fb64.05a2@mx.google.com>
Date:   Sat, 29 Jan 2022 10:35:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.299
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 94 runs, 1 regressions (v4.9.299)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 94 runs, 1 regressions (v4.9.299)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.299/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.299
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      224d99f50f25ec3234b99556c0076a7130e230c6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f5531160f12348e7abbd3a

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.299=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.299=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f5531160f1234=
8e7abbd40
        failing since 26 days (last pass: v4.9.295, first fail: v4.9.295-14=
-g584e15b1cb05)
        2 lines

    2022-01-29T14:45:19.657433  [   20.226806] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-29T14:45:19.700673  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/124
    2022-01-29T14:45:19.709651  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
