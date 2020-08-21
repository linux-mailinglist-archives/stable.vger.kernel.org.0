Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A39A24DEDC
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgHURsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgHURsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 13:48:21 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342C1C061573
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 10:48:21 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id nv17so1142850pjb.3
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 10:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fThm/gPkme74QO8XnFXnhbd7xGqd64WC5H8o01t6I7c=;
        b=nJHcDLn8tzxc1EpeXFhLYjYSjhH3U2RxqnKTOMobKyVvlHmX6KOci+Htn6GJTrrtRW
         0mDBneryEF2tQYcV4s0vKI280tSAdXloLEq3DfAEaADiSOj+KJyVmD0N+5RwZa/SNcJ6
         NKuUGQI3IHFDt8b7fhNGg4wHyhS96SiCeaOH14xwnEKt3+ghl7MF7XfVLbOlyD+71jZS
         H8COSyGZksgu3tb3rkXFc+z44KN1Nr4pqUJ2lJRZ/br2iuVg+chteoZSMNB/CHWWDOwr
         Va4PiyBo3uq84i2yK8eE4gdm5s832NB3kDhg99EkbiGd3l+RUZlAzGbJaKZcp1f+igpJ
         v5jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fThm/gPkme74QO8XnFXnhbd7xGqd64WC5H8o01t6I7c=;
        b=k38jR5fQ+7mIlm/VKrWKMJ2lDjj03aNsH9v4piAFcKfd6m0M4rd9VB2c6WO+L1O34b
         DozUUeIbW70vRboT23I2s+4+eqfQNXJvGcWxfcAwzkDlz3bdB8sTVpMhJUNZ9dDM+ygS
         yaITEw4va16yWBOy2O3ftXckTv90krexL32IwS4zejZnJ9ApxFzSGcANthiMytVJImRu
         AgYZQOtkgIlWPCkPILfGOnIqRG1IX/LOZW48UWHf6Ak4EScMqw+ebglDwRqyNm9YHUgn
         aCURxkzm7DIK/cE+HTb4zPmxBrWx/M/nUHDID9U9joDiWV0fVZFyvAQAnox0vxl0Z7L8
         1Rxg==
X-Gm-Message-State: AOAM532zT6pX1lt3oj+fjcahmV2URjHgvi50Kbc7FMUqSngDzIGyz+bS
        3mkspSvhdFUk+kiG0XWuGU4sVdCjI92//g==
X-Google-Smtp-Source: ABdhPJwPKz9Mzqoht3+zZC8+nckEyceeLrSUVFq3PicIGiIJ3lrxdyppzmSXHhhS6JH2kTtqBg6T9w==
X-Received: by 2002:a17:90a:9a84:: with SMTP id e4mr3134503pjp.205.1598032099518;
        Fri, 21 Aug 2020 10:48:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h7sm2452452pjc.15.2020.08.21.10.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 10:48:18 -0700 (PDT)
Message-ID: <5f4008e2.1c69fb81.5ffa0.6100@mx.google.com>
Date:   Fri, 21 Aug 2020 10:48:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.141
Subject: stable/linux-4.19.y baseline: 170 runs, 1 regressions (v4.19.141)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 170 runs, 1 regressions (v4.19.141)

Regressions Summary
-------------------

platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.141/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.141
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d18b78abc0c6e7d3119367c931c583e02d466495 =



Test Regressions
---------------- =



platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3fd4e35014b8bb919fb449

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.141/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.141/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3fd4e35014b8bb919fb=
44a
      failing since 36 days (last pass: v4.19.124, first fail: v4.19.133)  =
=20
