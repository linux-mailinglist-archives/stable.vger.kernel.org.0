Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7ED946098E
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 21:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhK1UEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 15:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbhK1UCJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 15:02:09 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791B9C061574
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 11:58:53 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so13670464pjb.2
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 11:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PBaVVWIfFUCbmeiiSx2LD3lq0H4xPNmzm3FFGaGYmRc=;
        b=wxBBlP1pdUZTA2uJ8gFyIMbKIVxbSeF9LHoZj2Ei9wR0Y1Lgl+P0eQUsPB8eqWWrwl
         6vKXYwFf6Bn2uEoqL4wX3ABMGrFjBNVjdQ4Prgphi62MLZBjnG+SzICHmtdwNKSsuwZA
         N82A/9YpY+kwXY5jGOUyyC2DRh++bor0mXbiJd5mSNnKWSlxVJ42Be7tBlpzL9wtD7ME
         wBGAHG2/FeCqEc3xyVdWzih47CMV/tsTacP7kmnXrjsFl627gdE1dLd2hbiuSUM7+eyV
         vukNGSBIgRI5t0+QsWv+8TmWsB2I39o06SHtEt8zkskpyhx1cGyAlkZ6Y+VeWeFeSrnj
         4YvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PBaVVWIfFUCbmeiiSx2LD3lq0H4xPNmzm3FFGaGYmRc=;
        b=W7nccTYAV81RSWElRlpqeZ4lVuNI5czRqe4Sif+mXX8qao7Xclfo6ClojHPnHblv6r
         nOLYUqm4ck98Vilw3wcIkUWcABPsujEMyDGMzsgA2Bq0jYSwUh1CePWu1c2vDhCajxu4
         EwazPt6VyCamDj7I7C62dGnBb+QH1wFtYQvaEVYFLeFADcq7dbNLE7vU0xMRKno/lEb2
         yhz9JenBnYyPyWCsVBsmOygYxfDX9yfFwp7STMJM11BCEM9SDKaFNsbGoy6xE0G/RAcw
         ILR52rOZxzRyskN0E42j7d+3674BHQ0D2X6RR8R9FRpWUohIXmvxori7Q5TtcnEQCabr
         SyEQ==
X-Gm-Message-State: AOAM531qO5dgSkDL5N+mIOGBp5lfaadjZnpKn3bi3kZ6sfnwvgJheivj
        dyJ41eS5tZnnMwt04/9Rd6CDgaxhN7cMRE8w
X-Google-Smtp-Source: ABdhPJxf37TiZiWWwVoWKxiPcWAPuGkYqZAunPZlgPorX5NU7AhgY+/R5Ha+KasNjuEPHz+oiGgGZw==
X-Received: by 2002:a17:903:18d:b0:142:8ab:d11f with SMTP id z13-20020a170903018d00b0014208abd11fmr54744229plg.47.1638129532853;
        Sun, 28 Nov 2021 11:58:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o134sm13404017pfg.1.2021.11.28.11.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 11:58:52 -0800 (PST)
Message-ID: <61a3df7c.1c69fb81.79d48.5443@mx.google.com>
Date:   Sun, 28 Nov 2021 11:58:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256-14-g15bd9ff94e6de
Subject: stable-rc/linux-4.14.y baseline: 134 runs,
 1 regressions (v4.14.256-14-g15bd9ff94e6de)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 134 runs, 1 regressions (v4.14.256-14-g15b=
d9ff94e6de)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.256-14-g15bd9ff94e6de/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.256-14-g15bd9ff94e6de
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      15bd9ff94e6de7d9a808194832577e8016a9bcc8 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a3ac889f1082dcda18f706

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
56-14-g15bd9ff94e6de/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
56-14-g15bd9ff94e6de/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a3ac889f1082d=
cda18f70c
        failing since 2 days (last pass: v4.14.255-251-gf86517f95e30b, firs=
t fail: v4.14.255-249-g84f842ef3cc1)
        2 lines

    2021-11-28T16:21:09.809161  [   20.031677] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-28T16:21:09.852520  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/96
    2021-11-28T16:21:09.861880  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
