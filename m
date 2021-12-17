Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6F5478CD4
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 14:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbhLQNxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 08:53:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbhLQNxK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 08:53:10 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D67FC061574
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 05:53:10 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso2837877pjl.3
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 05:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PiYgnI5HhEFGyZA0GCl2Cdew4pjAZ/u9J3isvrOtDgI=;
        b=yFRIWu51+WVYc8JuBVdbLCbf9VSSu/pSb2SraqS3OZVtaryX/n9gdOnRHczxWBu9Dl
         QYgjjpdWRkWbrXO8io15DBWgvsIxMrqZxyKe2HGH0pWGOn+EBF7EGaF2G+ZOjmKI0zB1
         NElyMAB26POlzxRnV1I2xK7CKQWyaF3ht+Zta63e71hwV/Cnx+nXIr3fWqs2MeSCQtoa
         mWto7DoAostv45NId0WCso9NQhySjCs32wPGGhEAHI1AfqcDg+GzmEWBld0StH1tJ3TV
         1oZxRUQxDqnA6OU4IyRnjOHA+60u79dQXYQJlBAXYtkLCRLlQQm93ImQmjAYE+zEab5y
         dx6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PiYgnI5HhEFGyZA0GCl2Cdew4pjAZ/u9J3isvrOtDgI=;
        b=x3v2a2kVeluvYfbLp8I6RdGSxwzUmY8iXDcP0WhUWqiTgzfjQCzffEmlXWZkMGuR1Q
         aPoaUWkQufA5h9776B63h5zD/Wif+JdG5GYcvBo6Lyxf/zCOynudiim/clbLTdMCqy0Z
         CRevbYM5vISDDGnHU2Uysxa6/X7IVhsBwc7A/HoiUPlXoUm/UrpDRsKdTpCWhqwyryGK
         B7akiFeW0KgdXmVwx/iD2v7SKNKyWfgFCiJh4x2qQIKRFUFOnQngt5FxNPg0+X1Od8k8
         qJ3Lr9ZOLV5Xkib6NEKsf9w6A28tlOjCnA6+qBPfujKyRDtg4au3R6gZfSClsXxQCvCt
         yeRA==
X-Gm-Message-State: AOAM532cbH9gTEVW2wQJu100BeuQJUxF4mNkEfPlrz1C20DHFsTJZWAK
        ISBzA3YTfB/n8moT3HY0scSeISM+RjN5166/
X-Google-Smtp-Source: ABdhPJymeFz4lD1YQXer2QWvLxSy0Cvqjc9/9WpKNGi25lwA5ic92E7JJvmWhYH1jmB8qxefVuGFdA==
X-Received: by 2002:a17:902:f689:b0:148:a2e8:2766 with SMTP id l9-20020a170902f68900b00148a2e82766mr3151720plg.109.1639749189678;
        Fri, 17 Dec 2021 05:53:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u22sm10145842pfk.148.2021.12.17.05.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 05:53:09 -0800 (PST)
Message-ID: <61bc9645.1c69fb81.26b68.b4dc@mx.google.com>
Date:   Fri, 17 Dec 2021 05:53:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.293-7-g5deb68112ce0
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 100 runs,
 1 regressions (v4.9.293-7-g5deb68112ce0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 100 runs, 1 regressions (v4.9.293-7-g5deb6811=
2ce0)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.293-7-g5deb68112ce0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.293-7-g5deb68112ce0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5deb68112ce0c1281a12e7e166b06cc5a5cffebf =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61bc5f1def8645d32b39713b

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-7=
-g5deb68112ce0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-7=
-g5deb68112ce0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61bc5f1eef8645d=
32b39713e
        failing since 0 day (last pass: v4.9.293-7-gd89b8545a1fa, first fai=
l: v4.9.293-7-g534f383585ec)
        2 lines

    2021-12-17T09:57:33.050926  [   20.311401] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-17T09:57:33.100520  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2021-12-17T09:57:33.109590  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
