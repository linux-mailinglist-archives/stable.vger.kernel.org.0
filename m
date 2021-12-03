Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCEB467ABC
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 17:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbhLCQFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 11:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234430AbhLCQFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 11:05:50 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9ADCC061751
        for <stable@vger.kernel.org>; Fri,  3 Dec 2021 08:02:26 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id o4so3277546pfp.13
        for <stable@vger.kernel.org>; Fri, 03 Dec 2021 08:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Oos/IME3KL2qyshJdcIGnhDP5Le6vR3aJH3u0zMIBVw=;
        b=w2VZQiPG1KPrMeeqIsyGVGpyQ5sxkVjCVBpGGUwH5ZqMLsC+qI+OcYVux6R/BOVMoG
         Pd6tHWMMxwRBQriPD7JzJ9Y32Sf1jSkVd3IwNEjiHBBS1W+/LdrzxWmlIaGnX5ITFgru
         cNOh7p/Pf5++WCKo7kRseU+XVxMF6HPtdpD67jJ5tAf5cM6NbPNzPeT5yT5/ugRsrS86
         IE/p9i59vh/i6e0O236bJyHjhXJKuCzQqthMVCXRNCOUGeWjEl7uNrAuveVWmpxo4pdx
         C9HNuXAn4om5jI/eDw22PeHdB3Edx3lvHjW8NxNHgJm9AS5POaY52KIIKVNWra1cIUCr
         LUjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Oos/IME3KL2qyshJdcIGnhDP5Le6vR3aJH3u0zMIBVw=;
        b=mFnxBVT/fMrxVQ0MiKLZ2ChVEG0jSIxtN4pCxzQREyzgP0rBapA2FNM+sE5+ZAAEUj
         V1jJzM69aqihpCuQvWhUU45IHaahW8gXmQNryeo8oKtOauQULkixhLjwek5TblRyoMyT
         sedhZ6UsyGx2pUyDBB+M16RGtNuLyhNDNGT2wL8Y8xDM1U//9uzoaTjX4Se/mD2nOkKE
         vZkbSXYBtXXde3vUBmRjOl5CcSoaLRfAS0nanjYAGvolVwiT0Bt8maIfppkwMnKqHAzR
         5vfATDw2MnAc1c1dHNJZRxWhZE9nd61P/2Ad3s9P+ViXCtggWkptrlbFRADjpxADic8v
         bLqQ==
X-Gm-Message-State: AOAM531mW8jbwcX4DMyyyFaZTnvyg848nOi8GDfaBerUqi3smP5WSG2n
        //LytOcFmWs/wGK0YqduNW7jqNhj1ydP3NkH
X-Google-Smtp-Source: ABdhPJx2L33Sh1Nrx6dhe8uTkmyQC+g9Hk8l/L//HFnRmAMydmiJL2FHUJBhocXZc4o3Tbtg30Yvwg==
X-Received: by 2002:a63:2a97:: with SMTP id q145mr4976101pgq.217.1638547346114;
        Fri, 03 Dec 2021 08:02:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b6sm3766505pfm.170.2021.12.03.08.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 08:02:25 -0800 (PST)
Message-ID: <61aa3f91.1c69fb81.2cbdd.b14d@mx.google.com>
Date:   Fri, 03 Dec 2021 08:02:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.219-3-g04afdf3600b5e
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 135 runs,
 1 regressions (v4.19.219-3-g04afdf3600b5e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 135 runs, 1 regressions (v4.19.219-3-g04afdf=
3600b5e)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.219-3-g04afdf3600b5e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.219-3-g04afdf3600b5e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      04afdf3600b5e66f7dedd6c00fd9c0f2969c3d8c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61aa0e9651a6b703d21a949c

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-3-g04afdf3600b5e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-3-g04afdf3600b5e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61aa0e9651a6b70=
3d21a949f
        new failure (last pass: v4.19.219-3-g91f80b6b7a49a)
        2 lines

    2021-12-03T12:33:03.552923  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-12-03T12:33:03.562366  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
