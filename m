Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899784659CA
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 00:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353770AbhLAX3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 18:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353782AbhLAX30 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 18:29:26 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A89C061748
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 15:26:04 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id o4so26157960pfp.13
        for <stable@vger.kernel.org>; Wed, 01 Dec 2021 15:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XQJDAToFkc5kWYpHlOyLkETzyJAanHrX6R+sXD0mhnE=;
        b=sSdOR0fGwG7X3TuTOiAK/JJSYq7ATlL0QJtM5Bf4DkPFSf5B7M9ebo+AY3l38Hhvl7
         WLyQ+kR3NyUgnXlxSDXs4Wg6B0RvJc6/D+FdrUvQa9VucDCWQ7PHFn/sxnkL0V6KkLZj
         LoxVoi++18QjLB6v/2wSrRThhzsV5inhnRggHWnWWLTEw5xd5lzwN4mHaE44xNZAe1xO
         VCTpC86m6lz/A36EvuRqrgHMCIY9YYVUqE/99dsg9D/l2Jb2sIk0WLBZ8xLOyNnIqlrh
         44zi2hPSt8PlIItCA0u7wsfNFaW2O9i7owV/ZCerLOMYf352k1Gw3m3F85Bqx/1n8AFd
         qZ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XQJDAToFkc5kWYpHlOyLkETzyJAanHrX6R+sXD0mhnE=;
        b=HpLMiAXeZkcbX+BNLNDMKBhJ83VuEZHfRef2kugo9n/pejZMN45jSLfSJeXPUJYiud
         nLk7jSXl+0jmnStyAvbM25QT2cotHM0iR+1+Vce1rJLLDWfdXiXBjBc101LzrbFqVTeN
         7UNKsMUNGMvXxZfvWFc2AyD3e2RVhRIah9c82EEzsZSlI1qfMTCe+kFMT7EFuCNkSFoJ
         lGWVcCMpiLV/n8S/tNPYObkPWEGJtC93+EeaOygRkn7JU3K7NBSe3HSBmLxtOOOSxNM8
         HUkLyHxopsaTL7oP+CLJTOn4W9MqXw89j4x4Zjvn3XJUAp2j3OLCpFltx52aDINSrgDo
         vLCQ==
X-Gm-Message-State: AOAM532wrUXw2tSgwGMkYSY9nWCQj+YA+5w+YIp0CoQKRYXTGLl+Zxt2
        VGx6J8N1B/7k6R7SuYkFYmsLSOwt221QLLtj
X-Google-Smtp-Source: ABdhPJw1NVxwi9rtG6+/V36WMjGnvLp1dm+XtKFuRmKmPMq01RjTQrHlVNn6J6t9MSntQW/Msea/Kg==
X-Received: by 2002:a63:2002:: with SMTP id g2mr6996760pgg.114.1638401163722;
        Wed, 01 Dec 2021 15:26:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g10sm950483pfc.180.2021.12.01.15.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 15:26:03 -0800 (PST)
Message-ID: <61a8048b.1c69fb81.b4a99.4708@mx.google.com>
Date:   Wed, 01 Dec 2021 15:26:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256-71-g127727bac26be
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 92 runs,
 1 regressions (v4.14.256-71-g127727bac26be)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 92 runs, 1 regressions (v4.14.256-71-g127727=
bac26be)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.256-71-g127727bac26be/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.256-71-g127727bac26be
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      127727bac26be0d86bc7ec9cf4edb10e49ef4c00 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a76f66fb585166c718f74e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-71-g127727bac26be/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-71-g127727bac26be/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a76f66fb58516=
6c718f754
        failing since 2 days (last pass: v4.14.256-28-g54e5647834e42, first=
 fail: v4.14.256-28-gb75fc63979563)
        2 lines

    2021-12-01T12:49:26.403134  [   20.057403] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-01T12:49:26.444565  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-12-01T12:49:26.454123  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
