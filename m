Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC65357602
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 22:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356116AbhDGU2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 16:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbhDGU1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 16:27:48 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4817AC061765
        for <stable@vger.kernel.org>; Wed,  7 Apr 2021 13:27:38 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so102659pjg.5
        for <stable@vger.kernel.org>; Wed, 07 Apr 2021 13:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZHkiZcJi3if+ZrrRNn8XjcBefl2YTWxUK60APFdP/6k=;
        b=GuMT4jL3TtylSuWD0XVtTX7r0mkaui7ajqqMWJ1SKilT/NXQP3FSxnh6A2Cb7POIPn
         ViGb2TX9br8nfsiCwiyU37y3fMsAEN90tvVsEm7ovTRDPZCHMOfV3/SuUkioRc5emez8
         IgFFzL8juzU+KeXh9iaMiA4R1vAkY1D2li7RbiDeeABGdzyyXaXXhu6huL/Yss5C9/rC
         wT5zyC43Uduhda7/APEtvZ+LCnjIo9pLg4Xdz1GEw1G1CNLCelRSKBRbithU4g0NIthz
         wClq1rLaVeal20WQX6qH4JnYcncpjlvQ+KHKXB7QUI348c1DqhCnCpvllnCkFQYhh/CY
         VB8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZHkiZcJi3if+ZrrRNn8XjcBefl2YTWxUK60APFdP/6k=;
        b=iV2eNbzGrAMz4f6OoXL0yUReLauR9rTsXKY1WBpQ9Bnaj+StnRSZyapI8yFVC6rkKZ
         yAwn3zITBtu/dbuJO207wc4RnIE96KuuFRmE8NKdzcrPa+tphGI1W7zCCYUDPk+kkcKn
         Gd49z8VN4rKia9F3FB6nUNb4bwH3INebsYCbEz3bREHswyWPgZOF+SAG7J/ZHt0SdmGP
         EcX7RFG67bCiCv21rkKeDiNp8zI5wUCdF8D413Ekn2IGSSGybVO4S7XCrG0sKRxPiQxt
         iY1gm0xcGuWd8JOh6BjiS0gs36SV+s2k2nvxvj9VyAtL7XujLTCcjRFzGkd03RhUTgMc
         WK2Q==
X-Gm-Message-State: AOAM533xE0fdhtmWW62jxmnjR5nSuV3DIgds/mMsoSsxYy9uWa9hlwYp
        a4vynl/kuMyki9Z1XNpRcOy8oJ6W6tzF0A/P
X-Google-Smtp-Source: ABdhPJwWp6NIXYPit9NdN7JO5+YExNwrvvMDgJ7RDR53Llgw7KmIU5FWmyQ9knksM8b1UhyBEFtBMw==
X-Received: by 2002:a17:902:c40e:b029:e9:3fb8:872f with SMTP id k14-20020a170902c40eb02900e93fb8872fmr4672183plk.74.1617827257688;
        Wed, 07 Apr 2021 13:27:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x69sm22582924pfd.161.2021.04.07.13.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 13:27:37 -0700 (PDT)
Message-ID: <606e15b9.1c69fb81.20ab7.85f4@mx.google.com>
Date:   Wed, 07 Apr 2021 13:27:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.27-109-g62509e249d802
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 119 runs,
 1 regressions (v5.10.27-109-g62509e249d802)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 119 runs, 1 regressions (v5.10.27-109-g62509=
e249d802)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.27-109-g62509e249d802/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.27-109-g62509e249d802
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      62509e249d8025256ccad8e23b58d4110ba6ab54 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/606dddb27209eae8a7dac6cb

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.27-=
109-g62509e249d802/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.27-=
109-g62509e249d802/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/606dddb27209eae=
8a7dac6d1
        new failure (last pass: v5.10.27-109-gba0af7445cc12)
        1 lines

    2021-04-07 16:28:11.617000+00:00  <8>[   13.559885] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =20
