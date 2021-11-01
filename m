Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E434422A5
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 22:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhKAVbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 17:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbhKAVbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 17:31:20 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C657C061714
        for <stable@vger.kernel.org>; Mon,  1 Nov 2021 14:28:47 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id v20so12720385plo.7
        for <stable@vger.kernel.org>; Mon, 01 Nov 2021 14:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IRywxEElE/Qjyde4tvqAn7DxpOt3HBzVgUKQZGZc6Mc=;
        b=hfFCpEDwdi4pxOUEuwykQpdwZ50oCuZlqY3bN3sLHrYW2zBmgmJTTPpymHhbVnx5hG
         J8JjcktVnA07dBtBUoU0XlMT3Q1iGz9FHMTupcQ2132xy3P8U2aj66rXue+G71UgvVK4
         LRg/dJKpdiiZTwvQmfVmCIfCr1rpWU9nET8LO01AAAamgstULldvPgttBEat7SyIuHML
         Tit8umhe6qEltLWglaQR8S+Lcld+pJqfD3W8+I7a9tYLsJXDIUIRgSp8/Lffxsmb9h4i
         D0DXNv9AOIJsdC4LIELTbFMw6SU2pIclrgHZT3U9sp4K+lYgj7WD1A+te/FYcl7MjusH
         SLbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IRywxEElE/Qjyde4tvqAn7DxpOt3HBzVgUKQZGZc6Mc=;
        b=Y0iJEDg+MdSjFrVlbyH9CuaUG4OHMwkhAQ6yJyaRJ3PrYKwK7Cwh3i7OgGPtrCF2ye
         +N20QjBVGeUgyQ3QuSpjT/7HmaSHDlU0YCBVXi+vfRNlmpbphlHpZJXb3OjfgyxLI8w9
         nvydROu1mG4AnJmLFIsa9UrLId1Y2+rjasSJUk8DhAEQqJYZgcX4oCXLZWeW3PAyaf7b
         7JA0BhHCbLGXqU3dusY59Udl5dBe7WRnkMQUH8Fx+4iZ06+KLS7Dq389emHCFGnxICsN
         qLGiGF0BYzAyZVwiF43usMct9GatOjER9MyosVn16ocn2kXNgOos9swiuMUkl1C7NBic
         Mmdg==
X-Gm-Message-State: AOAM533RRlrC8WD5Al7kzFHx83dL3UrStsOKfu6iDA2FUiJ6oASW7gr9
        ElP+4GRMjvkyDgCVaq/CtSHFqgEAdkNHap1J
X-Google-Smtp-Source: ABdhPJzNGWVxhk2bSAzO9oQtktTpzT1/gsIx/dZNve7VNlso7670Bl58tO1tQgNBXQ1ipLAEXjaCxw==
X-Received: by 2002:a17:90a:c85:: with SMTP id v5mr1675357pja.47.1635802126523;
        Mon, 01 Nov 2021 14:28:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j5sm356834pjs.2.2021.11.01.14.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 14:28:46 -0700 (PDT)
Message-ID: <61805c0e.1c69fb81.fc040.1d64@mx.google.com>
Date:   Mon, 01 Nov 2021 14:28:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.214-36-ga75679fb6ddb
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 127 runs,
 2 regressions (v4.19.214-36-ga75679fb6ddb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 127 runs, 2 regressions (v4.19.214-36-ga75=
679fb6ddb)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig             | regre=
ssions
-----------+------+--------------+----------+-----------------------+------=
------
da850-lcdk | arm  | lab-baylibre | gcc-10   | davinci_all_defconfig | 2    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.214-36-ga75679fb6ddb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.214-36-ga75679fb6ddb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a75679fb6ddbcf7814a3f96f09dcf0d89b430956 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig             | regre=
ssions
-----------+------+--------------+----------+-----------------------+------=
------
da850-lcdk | arm  | lab-baylibre | gcc-10   | davinci_all_defconfig | 2    =
      =


  Details:     https://kernelci.org/test/plan/id/61802747509a32e50e33590d

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
14-36-ga75679fb6ddb/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-=
da850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
14-36-ga75679fb6ddb/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-=
da850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61802747509a32e=
50e335911
        new failure (last pass: v4.19.214)
        3 lines

    2021-11-01T17:43:24.498348  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2021-11-01T17:43:24.498618  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2021-11-01T17:43:24.498952  kern  :alert : page dumped because: nonzero=
 mapcount
    2021-11-01T17:43:24.556081  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D3>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61802747509a32e=
50e335912
        new failure (last pass: v4.19.214)
        2 lines

    2021-11-01T17:43:24.693017  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2021-11-01T17:43:24.693305  kern  :emerg : flags: 0x0()
    2021-11-01T17:43:24.775502  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-11-01T17:43:24.775750  + set +x
    2021-11-01T17:43:24.775890  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 1010593_1.5.=
2.4.1>   =

 =20
