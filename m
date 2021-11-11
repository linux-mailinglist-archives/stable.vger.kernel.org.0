Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E30944CEC4
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 02:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhKKBce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 20:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbhKKBcc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 20:32:32 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7A4C061766
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 17:29:44 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id b11so4410749pld.12
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 17:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pwkK2aG+1Rw/ObCd+cmjWK030B/TXE9nulx9jQUXydQ=;
        b=Ob7nTTbBaBeFfxpeTP+oXL0LeHbHl5n21R+GuIuVIsDiRHIo+iO2xGmbz5WhMeFvVc
         Le/3WcRRTJOwxBjE0npNfYoRnbOWcy/M/MJIk8/ME0GUTsB1XhXQ8EkIMx+Zh7ENh5M4
         F1PMgiJsZWT+h9H7d7xoee2N3lmhGVdETIsa1xcmyhelkqwDGIdlWIP6FJ7aAku34BPK
         0QlATPuZY4Oz+5SgS1tfH4iPUMSuO0qQaKekQi0nmLrcJy13tndj5Y/ZBzM90BXizjBr
         0FjvFEkCy3wi9SwW4cTbMqzYEpKlBM4MHV3zPM/kzjaQPpGzyfDbgQxvR1RElcke4TsP
         lD8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pwkK2aG+1Rw/ObCd+cmjWK030B/TXE9nulx9jQUXydQ=;
        b=aTXW8hVQE3gEWIm/y+hUeOGe3O5s+QmESgEDiYr4LE7Ohk+HlMiPsgm6sPhJ5hfp6G
         qdzX+9En6oO2P3khh5AlU4sdAsF62qigGAuHxXXKQtWB3OKdsNsnl64VHvNO2iIZL9Tr
         32TYPclNJKhl64KJGwqepSHGXlxKKrV+FyzEkmUgDZAC0XT5cPJddi2gnV9vgK1N56bw
         8H8ytZdhYOpHMuPUMSqFiMuSAkYUDEfBBkL61Dksduz6HxXHElKRbk3Xk7I9rjrpt8t8
         tjvwejT3/3CL/V8AO8G7E8pRx3WV+P7Nrvh/7qmhCtpN6d7yNRNp3vG0PkAfpWTdSSBD
         Eitw==
X-Gm-Message-State: AOAM533EwEBVLtHO7WFy4oQ4LWI9Sxn40YbU3eOt/GmgufoXHPe/H32+
        DGZSLo6OKlLO6j/NEO1d8gxiX2IAN6mzduhFBeg=
X-Google-Smtp-Source: ABdhPJye1Q0teB3TLmA+uchqypkkPCatveR7zKzMZFB3roXjczXx3hOvuDLPmo7EW0i4BmxS5AY5Dw==
X-Received: by 2002:a17:90a:db02:: with SMTP id g2mr21968583pjv.76.1636594183655;
        Wed, 10 Nov 2021 17:29:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r8sm384520pgs.50.2021.11.10.17.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 17:29:43 -0800 (PST)
Message-ID: <618c7207.1c69fb81.f24d6.1cd2@mx.google.com>
Date:   Wed, 10 Nov 2021 17:29:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.291-20-g17cdd7c2c6dc
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.4.y baseline: 98 runs,
 1 regressions (v4.4.291-20-g17cdd7c2c6dc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 98 runs, 1 regressions (v4.4.291-20-g17cdd7=
c2c6dc)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.291-20-g17cdd7c2c6dc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.291-20-g17cdd7c2c6dc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      17cdd7c2c6dc2863ed141af8f99ff09851164bc6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618c366b15ad3a1df03358ec

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.291=
-20-g17cdd7c2c6dc/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.291=
-20-g17cdd7c2c6dc/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618c366b15ad3a1=
df03358ef
        failing since 6 days (last pass: v4.4.291, first fail: v4.4.291-3-g=
59c6c12a4647)
        2 lines

    2021-11-10T21:15:03.717438  [   19.332183] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-10T21:15:03.761656  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-11-10T21:15:03.770606  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
