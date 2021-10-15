Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD9F42E627
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 03:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhJOBbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 21:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbhJOBbq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Oct 2021 21:31:46 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C92C061570
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 18:29:40 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 66so7122609pgc.9
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 18:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OKcuBuGRtj0MHgpmG/CfXiHJZs3hR6XD2oS0P0USJjk=;
        b=TAMQZdcBi64U/sa//Ms/e3TWtdNc3Ss93rt84UrSDHMR1qjHqv48okQiM0m9R4XM8b
         K+kYv5h7jm3xJbp+3NLG+LfglCqVLZjVkAwg3vqUJr9RtoaK03HtwytOB2xQmvRGyLDG
         SBqKzoFL73mAyFn58BQBMNttbqHv4jzKt6ZxO3+vk8d86x28gJ8JbYDVO3OEP+v0ZE1q
         iySXUFA8z654Uf+3UNdooTFWQFzjXmxhcH+rhj98BfbO5hR+YeUQ6W7bfP7s2dI6EC+L
         EM0COxa9lvftK7NeKxKGRH2S0c3G17XbbC6Gk+zxwrT5AQFnuVGSMrWU59KG4+4QGIRx
         PxbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OKcuBuGRtj0MHgpmG/CfXiHJZs3hR6XD2oS0P0USJjk=;
        b=nNbciPF1J81goRiIiERUhlzNmffFhsNaHzgGbmKAqHZjKWJOX9JpPBg7rBmggiXS6u
         cmB9wMBd9FB4Gl6dqpNREixO5ataM1udw7QlntyrFvMkHSqffJG3TOuMD4+YLZK5ckCM
         kaURQHLEUWQq1yPf9RAGOuq0IDBAnOmTqm0uMzEpG1lZzqURMHE0F9zLZgcvVxLv3F7Y
         6tDkX9P+6imKp820CwlrE8/I3u2NdLAlu5FIn+r87zeK3bukF0/PQASJCQt91W2ApHG5
         6dTrRMjT8NDzuI/Lrtj6ApPD+tJdTEsu5MWSFa+0VAW2ey+UyNP3oea+awmmtMbPVEjJ
         IJ8A==
X-Gm-Message-State: AOAM533k+oJ6g2x2k+5NzPGI2M1lqAAAS71++GMJceISQ34gPYZcMxYs
        3kzM/TgSuQXkGCguRG48pyuglemJ6R1OVo+KHBY=
X-Google-Smtp-Source: ABdhPJyapVt5hWEw7qgCtgBRgChU6xDcsKejMkhezlA+leSDV7Ex1pK/KraNE2VRGqBemN8cMMmnZg==
X-Received: by 2002:a05:6a00:a23:b0:43d:e856:a3d4 with SMTP id p35-20020a056a000a2300b0043de856a3d4mr8865223pfh.17.1634261380158;
        Thu, 14 Oct 2021 18:29:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m186sm3728965pfb.165.2021.10.14.18.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 18:29:39 -0700 (PDT)
Message-ID: <6168d983.1c69fb81.3c04.c268@mx.google.com>
Date:   Thu, 14 Oct 2021 18:29:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.250-34-gdc0579022db4
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 71 runs,
 3 regressions (v4.14.250-34-gdc0579022db4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 71 runs, 3 regressions (v4.14.250-34-gdc05=
79022db4)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.250-34-gdc0579022db4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.250-34-gdc0579022db4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc0579022db410506fd874cd458c580df7f09db3 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61689aabeb49d398783358e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-34-gdc0579022db4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-34-gdc0579022db4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61689aabeb49d39878335=
8e6
        failing since 334 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61689bc0ec5e339dc63358e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-34-gdc0579022db4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-34-gdc0579022db4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61689bc0ec5e339dc6335=
8e5
        failing since 334 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61689ac47263c2e8793358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-34-gdc0579022db4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-34-gdc0579022db4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61689ac47263c2e879335=
8dd
        failing since 334 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
