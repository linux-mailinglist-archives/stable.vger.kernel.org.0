Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D29B440C73
	for <lists+stable@lfdr.de>; Sun, 31 Oct 2021 02:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhJaBgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 21:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhJaBgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Oct 2021 21:36:47 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01759C061570
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 18:34:17 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id t11so9313219plq.11
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 18:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GJS0HJEuR/M/aDWDFJscQ+FGqVREWUmHQqVPizI3OTc=;
        b=a+O8YXYZMYwUgKODxP6FZvliEXgiDGiHWY2y8SuZeAwuDTRWINiteRM2nZFE88f1Ud
         ng9A1BOlHAVzh/vRRQoTREfuz3Cz5H3j9MDKUS0I6REFP5oasy4aGb9Tp8Vw4Ds+wpZC
         hx4njrCf3YrDKuNMgNzYJQfZOc6+gpMz87RiuQRnztxaeBzi+YBKFdRVWvxcVw/WpUgS
         cq5HLNz+bb3xebJTvR3XWnYzbZ7HiyOSLBL8i1jCcuDm7Pj4TjzXz48uEHYXDJxgyQvN
         OrU6d2TezGAM9Y0/+ewfDlD51BX0dJw7T3WkGPWGLXvP7Br31hvGqknOZVsFXHAg1W02
         MmKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GJS0HJEuR/M/aDWDFJscQ+FGqVREWUmHQqVPizI3OTc=;
        b=0BDKlXTCQinM4yf4B55PI98U2ILD/yg+zMUmrBx8rYpOCR7zzQbZA8YBdPvNVe8usC
         1564sDYqhq9LWHDD0sXfYVu/U+7t1Cw3KqsEo46117qwe31FkVHFhu3xlQVPiq/hBuLP
         zyn+NmHButTtkSfegbyZTrEovE+Kf9WlT6xbW5vRfhUkZLXfSktVCGqH3BnJOdToSgBt
         3dvujLCZV8sytUfC+Ne1S+nOkDbzetEn/2G4wgGWHdgZsOt8ViFQ+EX63A/FVogMVuo4
         EpwVP86CqHrLfWSCZfGABDrLQnt+sJSuosROed5lD65zNwLzI7KX5v0He5FbqShhyvuJ
         p1ag==
X-Gm-Message-State: AOAM530o4isKzfb2XoNbvtYBJ0iUgxFuS6gV7Rzsdrf9No+y/bvsqkeg
        Vtz86sVufsGfvcAchlx/kHlTI1fWFAPa9OLk
X-Google-Smtp-Source: ABdhPJyRvlUYbRNlueXfyBtZlLKhuBsBin5xEU2qND4a8d2mOcXnBq2Mp1u/PSJA6bOLDNva2otLuw==
X-Received: by 2002:a17:90a:4586:: with SMTP id v6mr21133794pjg.43.1635644056344;
        Sat, 30 Oct 2021 18:34:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mi11sm14672929pjb.5.2021.10.30.18.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 18:34:16 -0700 (PDT)
Message-ID: <617df298.1c69fb81.9078.84fe@mx.google.com>
Date:   Sat, 30 Oct 2021 18:34:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.214-35-g60f0264e8c0f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 98 runs,
 3 regressions (v4.19.214-35-g60f0264e8c0f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 98 runs, 3 regressions (v4.19.214-35-g60f026=
4e8c0f)

Regressions Summary
-------------------

platform   | arch | lab           | compiler | defconfig             | regr=
essions
-----------+------+---------------+----------+-----------------------+-----=
-------
da850-lcdk | arm  | lab-baylibre  | gcc-10   | davinci_all_defconfig | 2   =
       =

panda      | arm  | lab-collabora | gcc-10   | omap2plus_defconfig   | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.214-35-g60f0264e8c0f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.214-35-g60f0264e8c0f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      60f0264e8c0f0ba267b37ed68eac5636cd27308a =



Test Regressions
---------------- =



platform   | arch | lab           | compiler | defconfig             | regr=
essions
-----------+------+---------------+----------+-----------------------+-----=
-------
da850-lcdk | arm  | lab-baylibre  | gcc-10   | davinci_all_defconfig | 2   =
       =


  Details:     https://kernelci.org/test/plan/id/617dbe8b76e538bec43358f1

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.214=
-35-g60f0264e8c0f/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.214=
-35-g60f0264e8c0f/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/617dbe8b76e538b=
ec43358f5
        new failure (last pass: v4.19.214-30-gc41b589f35b5)
        3 lines

    2021-10-30T21:52:02.349965  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2021-10-30T21:52:02.350173  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2021-10-30T21:52:02.350304  kern  :alert : page dumped because: nonzero=
 mapcount
    2021-10-30T21:52:02.409925  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D3>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617dbe8b76e538b=
ec43358f6
        new failure (last pass: v4.19.214-30-gc41b589f35b5)
        2 lines

    2021-10-30T21:52:02.548756  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2021-10-30T21:52:02.548996  kern  :emerg : flags: 0x0()
    2021-10-30T21:52:02.632552  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-10-30T21:52:02.632747  + set +x
    2021-10-30T21:52:02.632917  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 1006682_1.5.=
2.4.1>   =

 =



platform   | arch | lab           | compiler | defconfig             | regr=
essions
-----------+------+---------------+----------+-----------------------+-----=
-------
panda      | arm  | lab-collabora | gcc-10   | omap2plus_defconfig   | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/617dc13c5e11d6062a3358dc

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.214=
-35-g60f0264e8c0f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.214=
-35-g60f0264e8c0f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617dc13c5e11d60=
62a3358df
        new failure (last pass: v4.19.214-30-gc41b589f35b5)
        2 lines

    2021-10-30T22:03:28.487421  <8>[   21.165618] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-30T22:03:28.532336  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/108
    2021-10-30T22:03:28.543399  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
