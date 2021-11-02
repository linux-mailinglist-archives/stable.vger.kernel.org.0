Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5DB4437D6
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 22:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhKBVcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 17:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbhKBVci (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 17:32:38 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDF6C061714
        for <stable@vger.kernel.org>; Tue,  2 Nov 2021 14:30:03 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id u11so910158plf.3
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 14:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n6rhqNHd1nnBMHk25i2f6XMa8Oarqzg/+FBfV2HXcLw=;
        b=2hpeCZLXvAD4h5UbNUaAwl7yB6SsaEX+e2/SMfAniiTJVwSzFgsMGNg0MWLgIWb4Tb
         OZ/oCFg82Qf2YwWTK8eo0BHhok79m+56NkZST4KmMq0omNeJ+sEWRD5dunabvJZECQRm
         fC1c9UY98BhNedGCawRFNnfe06SEdB2WeR9u8LkkKIWNTNO2ZXeBFevM6Ylv2BXu1Rt2
         GROJt4mwgy1+FJdBwp5f3wtp2bif7tajT3yJ2azwwtcOFAUkbPQLu9WhHsyYaiyfTBIJ
         PdZefXpGv22p5tBrH2QZizkBNkwy81cHrH4Ifxqvcj2DLqlrdthktJ1JA88La/EFRSKI
         6ZdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n6rhqNHd1nnBMHk25i2f6XMa8Oarqzg/+FBfV2HXcLw=;
        b=EAnzD6yeu+N79j1GGw4cnk4k28k7ViytnK69ud8CH9+vyvHLlewIWGkVRKkKjm3x4W
         atzD0jj6FvLxEL9iywPCPQoxmPOgSC9i/eD7LsOFC2OiC8AUDg4lImH4jSvRck/OlHAN
         hwMItm+7ie8N/wFUH1TfVElK6ZYYocYfXehvgvv5rzobTcOLXAY2EXEFKRleSLS8qawu
         P7OflJjpn8LkFY9Uw+qpzfZDUkm5SmwOckeijvdUqZ5iI0vwwoRbYvE3/R6RgI5j3NAh
         jZul0K3jJagm1cUeTIe+pLV3tqEtbWO+1a9OxriS4hICoqjw7lMaSZFRjNDUQypIrGnw
         QR7A==
X-Gm-Message-State: AOAM532DM4IR+vnKEdqihUAAlxSGOw5piAiNeYLwUkCWN+dLGUyC4Cwc
        GEGu+0N9k1icHUNOgCjHtGz+xX2o9fk3ZJIv
X-Google-Smtp-Source: ABdhPJwRWjy6x9fBJQouq12nMGlUnfIB1OSRUDLQkSEMbguaoHu1OC9kXxGCgwkbgH2+4xkSAZ8qvw==
X-Received: by 2002:a17:90a:5b0d:: with SMTP id o13mr10309879pji.117.1635888602867;
        Tue, 02 Nov 2021 14:30:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e12sm52972pgv.82.2021.11.02.14.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 14:30:02 -0700 (PDT)
Message-ID: <6181adda.1c69fb81.ce32c.047c@mx.google.com>
Date:   Tue, 02 Nov 2021 14:30:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.289
X-Kernelci-Report-Type: test
Subject: stable/linux-4.9.y baseline: 116 runs, 1 regressions (v4.9.289)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 116 runs, 1 regressions (v4.9.289)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.289/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.289
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      59d4178b517472a1f023886baded2191458a76b5 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61817bb4c51bbb57233358dd

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.289/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.289/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61817bb4c51bbb5=
7233358e0
        new failure (last pass: v4.9.288)
        2 lines

    2021-11-02T17:55:49.192230  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-11-02T17:55:49.201670  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-02T17:55:49.216455  [   20.285278] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
