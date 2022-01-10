Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33E0489CED
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 16:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbiAJP6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 10:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236654AbiAJP63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 10:58:29 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2011C06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 07:58:29 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id 59-20020a17090a09c100b001b34a13745eso16221509pjo.5
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 07:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wYEyK1bXfr8r0ppjD/QjPRBt4/+EWqG2MpJ7FI3nz9U=;
        b=g1xauh2lpCfI6UdiBO/o1EL10f0G2N5WD50RxaJfzfqfecFQsGMHRYQIeTiqvSKiQi
         T4TkgL7Bzdo2/51i3K7nMLJLp/mifdoIsE5L6CQXuhzxzG3IyudTNfEmqObrg5Vyoq22
         QI1kXcSPQ5d+rvw81dzcFHeo7hUA5hatx50igH16b3CmeDhk9tCVmchSjczqyZq0G0zg
         sDKXGLrs9zVX6m484GfuFoy8VfHvZKrgEAkGMm+nN5mLkKqLvycWehWu4jH1BOiVXYjF
         1EkW4cpwhc90h3EvNxQ3vMgXCURfq2UdbuuBxrWpmu09BmuE/VbjHACpD5Ya11+UCBzX
         4kAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wYEyK1bXfr8r0ppjD/QjPRBt4/+EWqG2MpJ7FI3nz9U=;
        b=LeNdYthribGABVliQJJQbFfK5TMFhOAT1AmZmLorI2yIb0ZcRrh7nXmRhNGopWRPMt
         UN47AppaVFaRnBKPc7cm6ribocRc25NwewLY2BMJoRuCiU7D50f3jTbe3zYkNooEFujB
         v6GRuzQsdW9f+1mFh49pvR7LjWdvpki+VVVg5EXD/l44405SmjW+pcUiVkFQmNci/nHd
         F2dtF+Xm7IQf/ck6P9QjnArv4qGgvc/ImcAGWt0yePw0K78ZC8mdC3FSc4+mbhornmM5
         5zjIKMWzSs5GlXenQ6a7Mt30Kd9nvY+ixcLaLmiUmhMplw+nzwS1hZLrupTkYJQnCbz+
         dSwA==
X-Gm-Message-State: AOAM531KIS3i5CBzrinDohEzp2bRSzMALKYqoqK37bDH04QPSVDKC4bf
        7Z4sq4AWJf/gLkej04UMemRZ9T+5hgYxC5Yn
X-Google-Smtp-Source: ABdhPJwsRKQQh5OwZQ1aYU+r3MOJVtRSzIDKaCQIXczo9ePDflOR5ekF25AWKh4G8MP5wkep+CHqaw==
X-Received: by 2002:a17:90a:ce18:: with SMTP id f24mr365664pju.98.1641830308666;
        Mon, 10 Jan 2022 07:58:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y64sm5920432pgy.12.2022.01.10.07.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 07:58:28 -0800 (PST)
Message-ID: <61dc57a4.1c69fb81.b6662.e61c@mx.google.com>
Date:   Mon, 10 Jan 2022 07:58:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.298-14-gb6ad06e22d88
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 90 runs,
 1 regressions (v4.4.298-14-gb6ad06e22d88)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 90 runs, 1 regressions (v4.4.298-14-gb6ad06e2=
2d88)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.298-14-gb6ad06e22d88/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.298-14-gb6ad06e22d88
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b6ad06e22d8838dfae475c908eeb94db84d1e882 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61dc2575564519c271ef6745

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.298-1=
4-gb6ad06e22d88/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.298-1=
4-gb6ad06e22d88/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61dc2575564519c=
271ef6748
        failing since 20 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-10T12:24:00.889045  [   19.561553] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-10T12:24:00.941253  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2022-01-10T12:24:00.949191  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
