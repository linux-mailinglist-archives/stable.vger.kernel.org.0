Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF95480553
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 01:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbhL1APZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 19:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhL1APZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 19:15:25 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688C1C06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 16:15:25 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 205so14818022pfu.0
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 16:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3zDOC+Bwi/VNHcKmHTfinK4Kjtn43238N5HLDGsD590=;
        b=RGdYpcVV89tvTZJYIpMQUIdjQcUzCn7TL1MDGy+0LBAIm8daZUb3EstiAm/hLVxN5t
         lcHfWrJ08M6goW/Nvce93lNftZCRDY0onmFKHewvJZUI8u//HbL0CNtOhTMWLbwHf9BU
         uB4g+OaxApO+30F/NhWyi4y+RRz0I5kcfupp/euF3oylfzumJEyFQb4R59oUnDg8ANLW
         NC7YxdhztG6o3egUenpslkOmOWi8UIu6zDmeBoMD0+8Ct0kk0pTdpWnIBs2pGanERQbm
         5XRUgWZzI/3FyZ+ge/tcN6mSyPBKLRfJqSiGrkV0k/OzB6ytYqk/LiZZHtdjnCnJrkoV
         fpKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3zDOC+Bwi/VNHcKmHTfinK4Kjtn43238N5HLDGsD590=;
        b=vBrb85R6ZPoFhlUcuADGQGYyLF4FWLFXxOvNcoF6tSHy7a/gxUbJfXdyCzezwsmk7x
         eKuo86n33ZuUchcdqKn5WM9Uk2uIng/pwPS+jjLplCXCzV5qZZvGJIXPdeAmqV/M1rTe
         6XDF8VP+BnJA/09498zH+wRiFPM/fsEBHECgM9iS1zG1F4sezN62ZsHQxwBHc244vt6B
         cNQ+X5oteYzZ/OLb0dcbL1KkgdjItzWbTL7B5VS357CaTmLx2OawKdWDGTeBPT+uwjVq
         Fa1qhtAfOoawN1CNR3XHp3q5RMw4bBNPhDScM6Bu7g7TJwa6V1IxxWlwFDbachVonAk8
         wRWg==
X-Gm-Message-State: AOAM532TI0fhzqhJTZOjwkj602m/4AQicDURdzfvLqa8P7jRJ9q1gvE2
        bpKKQdBvd2zGddwAbEIVScwDDPy0iOFdjkTE
X-Google-Smtp-Source: ABdhPJxDSrBSkP5DWCkYYP9rWDm2IBBiQ5erQBX1gjCtGWOpjzYkkYCvxykpyaQCa56H4JMTfAYaSg==
X-Received: by 2002:a65:508b:: with SMTP id r11mr17417447pgp.200.1640650524866;
        Mon, 27 Dec 2021 16:15:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q2sm18723099pfu.66.2021.12.27.16.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 16:15:24 -0800 (PST)
Message-ID: <61ca571c.1c69fb81.44bf0.5590@mx.google.com>
Date:   Mon, 27 Dec 2021 16:15:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.294-18-gaa81ab4e03f9
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 99 runs,
 1 regressions (v4.9.294-18-gaa81ab4e03f9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 99 runs, 1 regressions (v4.9.294-18-gaa81ab4e=
03f9)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.294-18-gaa81ab4e03f9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.294-18-gaa81ab4e03f9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aa81ab4e03f901185a226114c39ef6795d7faed4 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ca1cb0f0d441b971397127

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.294-1=
8-gaa81ab4e03f9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.294-1=
8-gaa81ab4e03f9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ca1cb0f0d441b=
97139712a
        new failure (last pass: v4.9.294-8-gdf4b9763cd1e)
        2 lines

    2021-12-27T20:05:49.082318  [   20.076507] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-27T20:05:49.125222  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/127
    2021-12-27T20:05:49.134455  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
