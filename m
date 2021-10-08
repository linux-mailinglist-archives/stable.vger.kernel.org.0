Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1973427276
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 22:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhJHUr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 16:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbhJHUr5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 16:47:57 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E17C061755
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 13:46:01 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so10197517pjb.1
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 13:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TwfEgjYFl4sV876R1yftp8OryFrek68EF/IzGvGUiNA=;
        b=mPBJWGzlAXQaQvhYsaGrsgiyIaf3TLGelZKjXJXW0Rk0RGmtmE+f4hOnObHASjSE5N
         SFRZeIEIUCOFTKcmWSbb3TAl6em5GE6Mx9p8pHasU+dJMSnLKx16t7ji14y47PTlakzk
         5r/d2Xp9HUSNTLsO4G0U/vt6CsWb4GVEsrvwCvxXF8cUR1HN1nLmQxpOD2htzb0U8daN
         l5wuOdmhfykV8gIFpuK5n7tBRb1djSket8TdghTX8d74/3uyWlQQhyDda8wDM4Pki6OW
         lNp0iKfMswcQxQ1jKRUwLSaptELVUZPP2FZ6VrHi7n2gA2S+9uaQDQ1gc51i9/CNNeY4
         ldCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TwfEgjYFl4sV876R1yftp8OryFrek68EF/IzGvGUiNA=;
        b=8B2KjgoLXmMXQxnSw0iLJyhJ9zfL5hM5jJCPfIGf8srES+5aVjAig5AAUpD4Z18/Ga
         1IsDYVZGs29IXcrobtTThTRPyo8nqnKXb44J5P6kQkQ5nqzAX18q1QXdP5x6T6L/+sc8
         6Csd8FY3OyroZvmVQKn8VQhrUtLaplUqjYKTIh8YrtdUzperhRx6D1QvSB1K7pFsx1vT
         ZS0zTIbXHXaFmirkON+dTVCgon+mXrRMqDglCr8/jzrVcACB0lBSby+iKHkeue64Idp5
         HO/+0V9dsrPbyXza+JH2/2V7LtZCv6fo2XZyf2Ta5oF+AuYChMNI6miIsvrsd+mOKTmc
         VHiw==
X-Gm-Message-State: AOAM532d/+o9VO5mbUQDS9MuJkfD9ngoS97j9OUc/YVhXGsvuVo41U6S
        enHgkHs0yeYyYs13ucHpRPReaKkbkq7cGpnk
X-Google-Smtp-Source: ABdhPJxiDATrsdS/pppQjqe1vfUKGBEtfgzrR4I0zbMsdV/gyL3eRkYJSZEI2NSFGo7Wdu3sKDXOQw==
X-Received: by 2002:a17:90a:191c:: with SMTP id 28mr13999580pjg.121.1633725961159;
        Fri, 08 Oct 2021 13:46:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d6sm208293pfa.39.2021.10.08.13.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:46:00 -0700 (PDT)
Message-ID: <6160ae08.1c69fb81.b33d6.0edb@mx.google.com>
Date:   Fri, 08 Oct 2021 13:46:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.10-48-g292b9f8998a9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 171 runs,
 4 regressions (v5.14.10-48-g292b9f8998a9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 171 runs, 4 regressions (v5.14.10-48-g292b9f=
8998a9)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.10-48-g292b9f8998a9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.10-48-g292b9f8998a9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      292b9f8998a9fc3f7ad62545daf878f9bf83983a =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/61607a6abbf524fe5a99a2f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.10-=
48-g292b9f8998a9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.10-=
48-g292b9f8998a9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61607a6abbf524fe5a99a=
2f5
        new failure (last pass: v5.14.10-44-gcee0088c496d) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61607a07b1dffbc4c999a31f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.10-=
48-g292b9f8998a9/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.10-=
48-g292b9f8998a9/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61607a07b1dffbc4c999a=
320
        new failure (last pass: v5.14.10-44-gcee0088c496d) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61607bfd416fbaf6a699a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.10-=
48-g292b9f8998a9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.10-=
48-g292b9f8998a9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61607bfd416fbaf6a699a=
2dc
        failing since 3 days (last pass: v5.14.9-73-gb9d08ffadf94, first fa=
il: v5.14.9-172-gb2bc50ae5dd9) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61607b2490428ee29099a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.10-=
48-g292b9f8998a9/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.10-=
48-g292b9f8998a9/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61607b2490428ee29099a=
2ed
        failing since 0 day (last pass: v5.14.10-44-g08b40de697db, first fa=
il: v5.14.10-44-gcee0088c496d) =

 =20
