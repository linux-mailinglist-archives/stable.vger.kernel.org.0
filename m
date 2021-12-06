Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C182446AC41
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 23:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350882AbhLFWlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 17:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357704AbhLFWlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 17:41:01 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739A8C061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 14:37:32 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id x131so11477688pfc.12
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 14:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=85I2ElcT/UXd2i5tqE9kQ/5shFIHARS3veEHx2OvMhY=;
        b=xtIJ36FQVuuwDQYKpG0iYJ6VnnCG4SXKBqUzEUeOMz3l72YLYAfE5Ck1Pz5jYn93UA
         pfthAopOn++Rkm/b7aJsoQo14C8qzp59q90OS/Tw0c/+6PDLgV7xozQiIokq69wSRqzt
         nx2jbVWqoBhmjuK3lRCRCTtbExXZYz60HM227Mnzyanu9a7sY7NMUKVbkc/jhgYE6Q16
         8tW+KOFVae067/Wd+6qwu5bO9vxA/0CkF0ViVGJWOS0MBk+WadJIVAwIxdCaSDs//ZFC
         ZZUbTo6CUEZlF0s2UEz1oxI0p732H7NjXQXRd3aOkE40KXsZCkYQrSP82kT0sXTjrlYs
         Cgkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=85I2ElcT/UXd2i5tqE9kQ/5shFIHARS3veEHx2OvMhY=;
        b=73QlsOVIXhfSN8/LttkO2e1dY97YusUWANb9pxr24x7ylauTnnh/UK/CU7F80Pq83Z
         XwcFTwufZsi0aHPZI8PnBX9dRhxdLiIxlcX5dr8kTc9CqWj+d9FLgZ2ALDGY/rZhUkgp
         W7wMzbhG4we4ISWbQot6LXvK7Y7rw3xAIBeZaNIgVWmTuGuHB6xYeTmC22R2cT/CN2GX
         c1puceYE8NrxRVa94T48PyCX3a64ZStamxow5BfMr1txIRhvXYYHmoe90yZAE6sGc2ke
         rQg47H1lkPHAX1rkxmEGmDw1PVqoqEukPEMGqr6ZPG+8amDJSRZ2/os038xTLJjDztOc
         HTbg==
X-Gm-Message-State: AOAM533sVD4zQLhoUX3orPH7Lprjf5UwvGfFbDy6mGTLab9x/KRTXlSj
        80Eabsgnyddl//TRPAo6o/BY4gefdppGUCe6
X-Google-Smtp-Source: ABdhPJzktujrHUlAUMLcP4Ln+7SW7/Wkzeqx+uzQLEcEvoqiE9k4O5pv3gG/Fw5/a7iLVYiVhMUrrQ==
X-Received: by 2002:a05:6a00:26e3:b0:49f:c0ca:850e with SMTP id p35-20020a056a0026e300b0049fc0ca850emr39175128pfw.4.1638830251708;
        Mon, 06 Dec 2021 14:37:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id me7sm404628pjb.9.2021.12.06.14.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 14:37:31 -0800 (PST)
Message-ID: <61ae90ab.1c69fb81.f209e.1ae5@mx.google.com>
Date:   Mon, 06 Dec 2021 14:37:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256-107-gbfbeffc30386
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 127 runs,
 1 regressions (v4.14.256-107-gbfbeffc30386)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 127 runs, 1 regressions (v4.14.256-107-gbf=
beffc30386)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.256-107-gbfbeffc30386/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.256-107-gbfbeffc30386
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bfbeffc30386b392c8241764085539f6d8efd78a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ae5700e6cf7f34301a9489

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
56-107-gbfbeffc30386/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
56-107-gbfbeffc30386/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ae5700e6cf7f3=
4301a948c
        failing since 10 days (last pass: v4.14.255-251-gf86517f95e30b, fir=
st fail: v4.14.255-249-g84f842ef3cc1)
        2 lines

    2021-12-06T18:31:09.282972  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-12-06T18:31:09.292059  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
