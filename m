Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E283948037C
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 19:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhL0S6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 13:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhL0S6F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 13:58:05 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB2DC06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 10:58:04 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id j13so11975063plx.4
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 10:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M/R4BFYMG6sQEMyqeN39a1alB5U3RNObx8SRMg08oKE=;
        b=q70aWPOnXrXMAok+hyQ+LLioxeEUJhrUxurnLjEwtX8XNXcbzI4/925O6LVnz6b3ek
         BNNGo0ARYhtHxo6ac2ska4QobMvs230VA3AlV0B0SqlAU1vpB7oA2fK0SCBWH7TxUCPD
         7kifNys4aK8K5zSI7mJ34UYW5A/eT36SB8KqSK+V1vI3Kb0v84lGxVxtlZuamw6YZEzR
         MrsO3q6m1YKCwSUkwvkvY7i7LltA+mH0yXjwHTPEESm7hNwzT3TBrHovQk9ue4TBBpGB
         rDb0NslvJ4sCnUrux69gAOTxFFzNLKYSeem4sF+tWyPtcgJyntZqVBtkl+jJcJgbh1xf
         PZTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M/R4BFYMG6sQEMyqeN39a1alB5U3RNObx8SRMg08oKE=;
        b=zznKIkjwvZwOYVkooHDHiRfP4TqXN914QHo0aIO+L5lJWu9sasb6w4FjcnSzSumRr3
         UIiwPWGjurIb9iO9QrkzB0+6vTYMiJMDXIVQgdnIshGpo8yrFbubLk+dr8auLDTrjqdL
         I9MC5MKu1rs+Daksre5hc8oVkUUwMOcqoVvqaQRyppRj/S9LEhWzk6kc2ZY/2fnQCvRy
         klPpeiuzvfijOSMsJP7PcYcXl7lnR9xBbTvUFgAabvfOpSXvLVNht4zNZ5EzZ45uZqb5
         n92s7GLTI2jNPXxS/rhZMkAErsVE3WCjcS8dqoan3OegvRhbTmeTWxNlHkufUiHqvEKB
         /1oA==
X-Gm-Message-State: AOAM530xoasGlUgc488TWsixPVSNbS9gKhOvbwXzwHZr5pOeK0bXrSgz
        921MfV3wsR3ux+/iV1s8ho/2yIjwboiKRaI/
X-Google-Smtp-Source: ABdhPJwgjpEoBVmSWiNJv6OPvnftd3txrMjkl7lqvcdVFsIB0911Vx7Jd+Xu5Kf8MvohlBwv07rZig==
X-Received: by 2002:a17:90b:1d10:: with SMTP id on16mr22761660pjb.196.1640631484234;
        Mon, 27 Dec 2021 10:58:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k6sm18918389pff.106.2021.12.27.10.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 10:58:03 -0800 (PST)
Message-ID: <61ca0cbb.1c69fb81.77805.484a@mx.google.com>
Date:   Mon, 27 Dec 2021 10:58:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.294-14-g41b0aa70113e
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 119 runs,
 1 regressions (v4.9.294-14-g41b0aa70113e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 119 runs, 1 regressions (v4.9.294-14-g41b0a=
a70113e)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.294-14-g41b0aa70113e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.294-14-g41b0aa70113e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      41b0aa70113e1f1442f4e0809fef0121f80fb871 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61c9d27a619ceb48b1397158

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.294=
-14-g41b0aa70113e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.294=
-14-g41b0aa70113e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c9d27a619ceb4=
8b139715b
        failing since 14 days (last pass: v4.9.292-29-gdefac0f99886, first =
fail: v4.9.292-43-gad074ba3bae9)
        2 lines

    2021-12-27T14:49:13.153569  [   20.441802] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-27T14:49:13.197432  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/128
    2021-12-27T14:49:13.207005  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
