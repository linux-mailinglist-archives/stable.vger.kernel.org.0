Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF2445B2A8
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 04:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240214AbhKXDc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 22:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240842AbhKXDc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 22:32:57 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CFBC061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 19:29:47 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id y7so754689plp.0
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 19:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D+FU0whd6DvO+2BFQTaK4qDh8R4FI+fw2MSVSv00lYg=;
        b=BwhzmKvLoLRpb+LWoOXERm7KAsOXSaqCtJUUyf39V1sYloJnauu00mu/my5Wf3Ikhx
         sL1on6WyHRoQCJDDNgDiulatTJnBo0vrZCwRCKT9Y+rBqE4flMTuol9yzBQW4rBL60JM
         BIJrtdBgIjI+LVMYrOy1lvpB9YZn/jKqbqitP5zabMsP0z6vzuZxBJufnI52naeVi3Ch
         58ib5Mjn/JHftnViNkoiXJ2oydV0KO2Bp4XTz5e1nxRk+m1vGWi6IcMf9p3abWDn1S9r
         j8XBTT32+wWWACWrIiblLxCW1ShnodZY2MFrvGfgmDzAyDfeErvnROIH+7Gh+2M4F0RP
         O66A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D+FU0whd6DvO+2BFQTaK4qDh8R4FI+fw2MSVSv00lYg=;
        b=FAziMCVmrTXEoLQy1UPGK+gevVqFcWIj7dmvIxlLWNZNFTdDWbOTttWPuzohWnByxV
         OlxL4/a3g390FlyWr6r/0KPUgrGJbcCnjUUj6k2qsXkeVlv94UKFjlzm+cvfDbBilXzM
         mVqdl5kDPuPEbP22hz0JOXmaqoBrPD1LXIDMKpZazyk+q6RaAJAjhRBRzMMppQyTWDXn
         QXir8rTSgUfqlrOtHPyyZTaNMC96XuA+vaLn9jPcR9hlacefeEXVNd/lFpwFOrnrDZN3
         MgBywt7/Sgef5UaYDHVpEUYN4Ae022cm8Trnj41SegCCEcr4S6sMfk6Imc+3F4k/sHCr
         KDPA==
X-Gm-Message-State: AOAM532SVJ5FbsW3WBb8/ymQMW8pYrES+O10gTq67hwNzXuAc6WT91DB
        VLZflMSOdBV99W8cYsNFa07RYXpQhPLjKlni
X-Google-Smtp-Source: ABdhPJx5eHnrVcE31etRBeLL6px6AT4xObYabzSEIBcjUPghWTiWV9JnnEC1GeekcOSXpNX0JCWiig==
X-Received: by 2002:a17:90a:3b02:: with SMTP id d2mr3802815pjc.159.1637724586522;
        Tue, 23 Nov 2021 19:29:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f1sm15696452pfj.184.2021.11.23.19.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 19:29:46 -0800 (PST)
Message-ID: <619db1aa.1c69fb81.5b6f.a9b8@mx.google.com>
Date:   Tue, 23 Nov 2021 19:29:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.255-248-g9bebb52eb0312
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 133 runs,
 1 regressions (v4.14.255-248-g9bebb52eb0312)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 133 runs, 1 regressions (v4.14.255-248-g9b=
ebb52eb0312)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.255-248-g9bebb52eb0312/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.255-248-g9bebb52eb0312
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9bebb52eb031239ad9ca05e144c2b177e615847f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619d80e90ea379d63ff2efa8

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-248-g9bebb52eb0312/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline=
-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-248-g9bebb52eb0312/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline=
-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619d80e90ea379d=
63ff2efab
        failing since 10 days (last pass: v4.14.255, first fail: v4.14.255-=
54-gb6f4d599e1d3)
        2 lines

    2021-11-24T00:01:27.657089  [   19.899658] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-24T00:01:27.704718  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-11-24T00:01:27.714424  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-24T00:01:27.730128  [   19.974548] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
