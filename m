Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B65444CEB
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 02:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhKDBQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 21:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbhKDBQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 21:16:17 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D49C061714
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 18:13:40 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id v20so4515029plo.7
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 18:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=72fxtZ/mZ4g8cH5HVc4AdoQ2JuWZb5RzXFkT7uPrQbc=;
        b=AKaP0ko28r5DJ6SXcU/5lM9uNW9E/jKQCuTbVs9EI6RoPHfbSE86lTO6vZMqQdgWCi
         43zHFRWoFkaYOqWm+1GRPjoQmnlqHEoGdFx2IT1t8k5n5sQOr42FO78skwhhsRsCfS9v
         4HMf5nyQpsFmT6gtBFj3IIOgCFV0ySI+cR4KUOnG1VALYm7PaTKQca84uRf3Ok2LqfYH
         fu27j4DduInFmtSV8QNSzH2qRcjaLUzVjc6cyxp4bDYhEyyOJpFEcZuNbpiR5EDd0IoU
         XdbB1l/sSzCrEe0HgznWex9wTqo91bOVD42T1TLCy7iQ8UWq7VK8T94StXt/FO/RZZI+
         +J3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=72fxtZ/mZ4g8cH5HVc4AdoQ2JuWZb5RzXFkT7uPrQbc=;
        b=RzIWCPQ5ZTsbHfhn1gzK50dUQpyAuFNEtMJi0Wb8fL3VY061c5ohxvBsb69GwnKniA
         /dpaoSgFQ1l+5IGXdgUVmPPsNJISDWnQzCvb4MehNct4U/ReW19YOrRZqXswRn+HRmMj
         naTphphMEM8iUUieBkxFgna3dBGZMtMp7Hc6/xOkHYI164FPuBhJ0fbD8nfrYg1a95RH
         KSSGAjZ0QaXM/oErpSZ4RXnuqryFsOjRRrs7Wg4xWyIdTtIbWyvj9JhJy7llgBSSY8lZ
         L8fiDJFi8SzCz6GTBtAVVW+oSr3Qb+E1M5Qql83uXVMH9Kc+NT4Ha6vJhK3y4bVOnEOi
         wFTA==
X-Gm-Message-State: AOAM532tA+V8k4A6YyT0uUOsIUgNs58YsGJs8/beSlPNOsf2if7Rtxox
        2EaOQ81RIl2PT9FCnQ9pP24j/+18qNQgZppb
X-Google-Smtp-Source: ABdhPJz34EPEYahGSoz7PFLTK4T/6dpMaVLGtfV76rbZaDDRhmno+FTcWaL/Yp+nMHEHHxZh4eoRqA==
X-Received: by 2002:a17:90a:9f93:: with SMTP id o19mr18495995pjp.136.1635988419484;
        Wed, 03 Nov 2021 18:13:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h13sm3780338pfc.140.2021.11.03.18.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 18:13:39 -0700 (PDT)
Message-ID: <618333c3.1c69fb81.5a682.d3e2@mx.google.com>
Date:   Wed, 03 Nov 2021 18:13:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.289-1-gdcbe5fad1cc3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 112 runs,
 1 regressions (v4.9.289-1-gdcbe5fad1cc3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 112 runs, 1 regressions (v4.9.289-1-gdcbe5fad=
1cc3)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.289-1-gdcbe5fad1cc3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.289-1-gdcbe5fad1cc3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dcbe5fad1cc337ba7239e7344154ac8744888236 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61830141988bc46f1b3358e7

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-1=
-gdcbe5fad1cc3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-1=
-gdcbe5fad1cc3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61830141988bc46=
f1b3358ea
        failing since 2 days (last pass: v4.9.288-20-g1a0db32ed119, first f=
ail: v4.9.288-20-g7720b834ad25)
        2 lines

    2021-11-03T21:37:52.169920  [   19.983032] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-03T21:37:52.212410  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2021-11-03T21:37:52.221291  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-03T21:37:52.236759  [   20.051666] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
