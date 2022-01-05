Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781C04857CA
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 18:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242613AbiAER45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 12:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242617AbiAER4s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 12:56:48 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C9DC061245
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 09:56:47 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id r16-20020a17090a0ad000b001b276aa3aabso5177536pje.0
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 09:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lMnv/NhAk+aSB89wjdohyw6wZ6feew/lyqlZfAC6SEU=;
        b=Ro0l6URq7U96WXxDIO05fBXNBDj2pu5Ah/vJ5UBxNd76mslqVFRZoKdXxVJQMtRCX4
         bmXkiq8dn9+Fvjehx4Yupkc2Wu1mwXl0pcFJs1EEtYLQJ6yMXVhqfyM1mV4fMpsbRZq7
         CCpGIhffnuYHEWLzIMCwgGudBt+sm/JJAz1FGrAHSWbVvlSn70rPv5zSdiidF5xnat9+
         +s70W8AkagTBWLWEkmfQvruHzNQMUGfpA/Hducvw3cTHftpf97b771GpgzOjb4+qc6Zc
         ZBQu3qG9ECoS+8qZl6VreuQ6zsGXAA/stz87blBY12hrdayBA8xxez46plfBhRyGQEhN
         Lexg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lMnv/NhAk+aSB89wjdohyw6wZ6feew/lyqlZfAC6SEU=;
        b=ZHsgn6sjICKrQGBgbzK2CiWyT+1mwgao37HxdqPwOMUTOGE2dO3CF/dO2pFRdT0jDe
         CgHifdv0/31sVdQP1/E0g3L6Xu0+Ds9khguanIiSDu0ZYpWk10wj4+Z8N7qePxVMBRTA
         48/Z7s9vTm9ZeBrhvXUBQDI+9IDYhqFOA5dwjpqMIdeZO5psKsiApX86Lgu/2+xJh2yU
         P4iWhQqWX2pkAAtDh1Wkjl59DN49m3g4dLeW0sNDb7X+HHcpXf9RV+4OGh3ccvUEQayE
         Iz8kpzB7LxPPh8dJEe+O0h9zkoeHxEdvCLOh9rUiBGZYv/5c5qO0ewI8BpZzObASM30B
         rVHg==
X-Gm-Message-State: AOAM530mjtRqsgf05i3d3YINT5GbbCYvb/O2B8IbCBl+FTdgTWIO7OS1
        rP6QSk8qIkSwoGrCEnqNWB8h+ZlXKxGPfkz3
X-Google-Smtp-Source: ABdhPJz0xwHDMUFPJFj4K3Dm9OpRgb/Rdjb7RVnHb/tEfF28/ELbjD+2tBcXd0YrGeSG4S6cMRtlIQ==
X-Received: by 2002:a17:90b:3b4d:: with SMTP id ot13mr5529390pjb.196.1641405407186;
        Wed, 05 Jan 2022 09:56:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 32sm38127621pgs.48.2022.01.05.09.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 09:56:46 -0800 (PST)
Message-ID: <61d5dbde.1c69fb81.c50e0.7112@mx.google.com>
Date:   Wed, 05 Jan 2022 09:56:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.4.298
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y baseline: 140 runs, 1 regressions (v4.4.298)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 140 runs, 1 regressions (v4.4.298)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.298/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.298
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      0dc4b955f01eae10c6923c86234ef9768137797f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d5a85c4550e2dc6aef674e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.298/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.298/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d5a85c4550e2d=
c6aef6751
        failing since 39 days (last pass: v4.4.292, first fail: v4.4.293)
        2 lines

    2022-01-05T14:16:38.883980  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/112
    2022-01-05T14:16:38.892866  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
