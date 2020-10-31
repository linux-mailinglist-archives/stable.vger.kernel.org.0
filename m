Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4A02A18A3
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 16:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgJaPyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 11:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728018AbgJaPyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 11:54:45 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E3EC0617A6
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 08:54:44 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 62so137968pgg.12
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 08:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J9LgKZnGFF+1gUmlajgTXr5SlrQ6JOKI4tMJmsCKTj4=;
        b=drhKOi1TRv2Nxcd1GK8XWOxXjldKSq/O/XzW2oTcPLjZGfBQ7wEv7NE+0s5w5dVCw0
         AoE4NnRvN98PoRYy0vmDij9vQ6E8qChrWepdoCuws0bPPajXzcDOcIkhLYgFyS1SJMbE
         zOJDlcIRS/47dRoB3/k9Yoae/7zWEn/glGf0ugaBuKl8HNeFK2SEsDGouLU3c/p0VMHA
         e52cPuaw5wUPjGmWpTFkv5ZG2C+HjJvoh33mutYgj8U55Sa6JClerXXDFaj9fYZBhpEE
         ik2gUhObJr/wvgPrhccxa1lp9Vhkokf3DBqIxktH85CQJ6Yg+/nCRdUrqmPPtg5+BBvU
         VOoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J9LgKZnGFF+1gUmlajgTXr5SlrQ6JOKI4tMJmsCKTj4=;
        b=NB3fu2AadRvaak6etqjImP6fPL5d1eFu5RHuRW/88VZbMa1jNRA+CdrrPvZdfGG/L/
         mk9YLcc558LFuDa5+bg4wI3c+j6CVgXOJDsMSd1wFVWnM8sOXERFFj2HgjvoiiHSblvg
         ewHf2kixsQUEYBZjGSnRO9yZgURZ6xieU3bSvOHdtZOy41HMVXSR3h9E0tAglchTKvE6
         s9EKF7CVUp0aPT/nCYh41rCSTB3whv6PRd50lsHvjmZC6C+ayxCiteRZb64/t29aDnKc
         UDvix1EbZEtm127TVTJllrHf85u7+zQh6JEurSlk2CWkQe8D3ATGQGaNccNoTderVD2a
         8quA==
X-Gm-Message-State: AOAM530yBHxLkeV0SB6LCwrrsj6Zg3j78slhyMgx7xqFEtBRTcB5V6Rb
        f3KSFM6RmHko+9ZIu8jmUNnBH70/QTyfrQ==
X-Google-Smtp-Source: ABdhPJxacGZJc7m7rumXCI3mMQWqK3bsb8roH3oxC7cdIDNdrVEP/Hb+K7VfTpBDKEe3mTsqv2dQsA==
X-Received: by 2002:a62:8fcd:0:b029:163:c70e:ff90 with SMTP id n196-20020a628fcd0000b0290163c70eff90mr14710034pfd.73.1604159683862;
        Sat, 31 Oct 2020 08:54:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lf11sm6713389pjb.57.2020.10.31.08.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 08:54:42 -0700 (PDT)
Message-ID: <5f9d88c2.1c69fb81.333bf.0684@mx.google.com>
Date:   Sat, 31 Oct 2020 08:54:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.203-13-gb2eae82b6b0a
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 142 runs,
 2 regressions (v4.14.203-13-gb2eae82b6b0a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 142 runs, 2 regressions (v4.14.203-13-gb2e=
ae82b6b0a)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.203-13-gb2eae82b6b0a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.203-13-gb2eae82b6b0a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b2eae82b6b0a57e5b95256c2b3577ac682f4b4a7 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9d55df3211dffa9e3fe7ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03-13-gb2eae82b6b0a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03-13-gb2eae82b6b0a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9d55df3211dffa9e3fe=
7ef
        failing since 214 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9d571253ef93a83a3fe7fa

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03-13-gb2eae82b6b0a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03-13-gb2eae82b6b0a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9d571253ef93a=
83a3fe801
        failing since 7 days (last pass: v4.14.202-11-g83970012a2ed, first =
fail: v4.14.202-22-gc247dbbd6699)
        2 lines =

 =20
