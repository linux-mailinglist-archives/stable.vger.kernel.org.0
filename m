Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B0A45F7D1
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 02:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344634AbhK0BSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 20:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344445AbhK0BQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 20:16:20 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2920C06173E
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 17:13:06 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id gt5so8183973pjb.1
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 17:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q2TFcz6OcKgu/9dATwmiG2IwIqcxQZuyR6tjjNswcdM=;
        b=0nvh997YyrWjixlswLbSwJHIelC5ve9nuQJ7QOOGHdp1kVENs4MpBn+fglEQOuDVWn
         kkRajhH7giyK64nnKOUFi1ii31CPyeJTxo2qK4kYyPlgleTJPJvER3oPz0qYOg2aLamm
         UPTOsTTmIBaEBwDJkM6rkqkjmLkvjKLqHyJBfRnWA2ZZ8+GDn+tG/dpLOxH7XeZXc2JX
         Jwsht5nkAQYXn/mekbYbnfnfiF8sEcUNoXx1xo07o4WaqeAtlmp99eRuw6fgOvck+Lp3
         0USom06+qgbpvtF60eTCU9HJTRQN4NZhMqvsb5z5Br9W0Yn7vOaxsEN9N8pvIOPwgxha
         5mzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q2TFcz6OcKgu/9dATwmiG2IwIqcxQZuyR6tjjNswcdM=;
        b=zhF9HYVvT74M/5oxdI6Grhbwp6LuPGeqDK7NAAnSaos3UHfcjw40fYCiwD5jAshWsG
         htZ5i43/Vl0xaWpFx7gde/MsGqlBBMp4cA9XfO5hHFVdB0ROkumFOQSigrVHQvV/A/St
         tueStQPsg9xOP3eudJO0CB602hubOFYVGRZBn2NejJ6dpju/qH7dpMwlWbOnSwa2egLt
         yo+If6OoRb+UZhaEiRxPd22bQS6gPJBuXCCRgmCcoIbKYagdtYMlTzeX1gpaA/rORUbM
         WVkIz1DvciFzAI0105EECqR1+1p1HPLTjaR3mHlR/J/GX2lHbFndpW/CZ1Uds6wgysoA
         q5eA==
X-Gm-Message-State: AOAM531++cGmd1zmcrf7K2k46I/yoV1EVTPB3pmKERglu4YC0PKHhRiW
        GAsxqkIkGUgHvg5ELr+Kp2GSDv2hkb2fhQX9
X-Google-Smtp-Source: ABdhPJw9axgqmy/oBVM7pJq6lyhvvgZPa7NQIvOifNSLe8iW4oWp0CVcGmgIgPJW6inJBv1A/9ruiw==
X-Received: by 2002:a17:90a:be0c:: with SMTP id a12mr19957813pjs.204.1637975586177;
        Fri, 26 Nov 2021 17:13:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a26sm7901579pfh.161.2021.11.26.17.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 17:13:05 -0800 (PST)
Message-ID: <61a18621.1c69fb81.dd1f.7134@mx.google.com>
Date:   Fri, 26 Nov 2021 17:13:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293
Subject: stable/linux-4.4.y baseline: 87 runs, 1 regressions (v4.4.293)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 87 runs, 1 regressions (v4.4.293)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.293/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.293
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ae6f8ce9b7496a4ffd3ba545f824b44cdb217149 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a14b5846bf10ffb718f6d1

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.293/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.293/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a14b5846bf10f=
fb718f6d7
        new failure (last pass: v4.4.292)
        2 lines

    2021-11-26T21:01:57.369622  [   19.265441] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-26T21:01:57.412658  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/115
    2021-11-26T21:01:57.421715  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
