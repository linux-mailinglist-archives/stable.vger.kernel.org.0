Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872F9480499
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 21:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhL0Uht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 15:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbhL0Uht (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 15:37:49 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D45C06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 12:37:49 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id l16so30987plg.10
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 12:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q3ciSEwhHkpT23Gi2f+slHgjc6Dvtsnn55Ui7fRMfEc=;
        b=7LCVvmP5CbkSnMvblj4zsa7aekWEoIcI6Djo0z+BVp6QLUJcB4bPdIy1N918bG58MQ
         0bRv92vMoQTJQNJ+0czSi1Jf76uoumRfSLtlH6qJe3aMX4TP0CEFHmdWO6PPhK7PGa5b
         SVGgEOUXf3fUQv4Al6FCOOZcIUbxpmkksu8zzfHERyhDfjMhbox7EMlf4gCYx0AX+1Fe
         QSSVk9rlt6rcAL/OC4I4pzCPl84l2xLayOXHtFHZ8VovmQhfE7r06UDukfldRQL8JCHw
         BxDcgk2SbxJHL6kc/jOGkdkbmV6inVYBJhL9YEN/mCfSr44l3TvYaTb2XTCRXCaYvH/e
         JZsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q3ciSEwhHkpT23Gi2f+slHgjc6Dvtsnn55Ui7fRMfEc=;
        b=XeuWIM7IKVHlz59lbVG0AG2MKX4j+szW0VojjJJkK+tQmT8YC77osvMC76GzTLtpJq
         m/sBP5wEPvyd2gDftqZnR9y8pzafLNhj2O30OFkX1XqI2vT34VCIx/PuvEJ1Jl9gJXLO
         NMi7JDSmeCzYRkMJ3zIOQeSxnxXWcz+M6m49nSLkmL9gvDuikWgomqcJ1b3EPWM77YBD
         WLL/s6XRJGo+7SuMVOP713hw0/PvSU3JJY0EDkP7fw3+maNtUr4At7OLS9cb/Z2eNG/H
         jFZqnnuXxizU938DqeM8U2vjkaW0PtMLQPTo178y76FlLbt4TVEdaToxAlPug3LEXGJH
         YHxw==
X-Gm-Message-State: AOAM533bSoHf+0rIYBozjJTUr1n2+r2lwo+RpFKrGELNpCJFxFxZ7Eyy
        oB1bSmsYvNrPaE5GRVLLD/BXxGQgei5whyd0
X-Google-Smtp-Source: ABdhPJxxgUX6G4MGfppwHEUL7x/ZEro06caUzoxWYyW02numcJFPAXQnl+GI6Ly2QpwGcp1TzeOugQ==
X-Received: by 2002:a17:902:d484:b0:148:e505:7de9 with SMTP id c4-20020a170902d48400b00148e5057de9mr19297851plg.14.1640637468334;
        Mon, 27 Dec 2021 12:37:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id np1sm6343943pjb.42.2021.12.27.12.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 12:37:48 -0800 (PST)
Message-ID: <61ca241c.1c69fb81.f5f3.1b8f@mx.google.com>
Date:   Mon, 27 Dec 2021 12:37:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.296-18-gea28db322a98
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 124 runs,
 2 regressions (v4.4.296-18-gea28db322a98)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 124 runs, 2 regressions (v4.4.296-18-gea28d=
b322a98)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.296-18-gea28db322a98/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.296-18-gea28db322a98
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ea28db322a98fc90032bea9e517d2beec25bf5b6 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:     https://kernelci.org/test/plan/id/61c9eb790993011a49397134

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.296=
-18-gea28db322a98/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.296=
-18-gea28db322a98/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61c9eb790993011a=
49397137
        new failure (last pass: v4.4.296)
        1 lines

    2021-12-27T16:35:51.069553  / # #
    2021-12-27T16:35:51.070122  =

    2021-12-27T16:35:51.172909  / # #
    2021-12-27T16:35:51.173395  =

    2021-12-27T16:35:51.274615  / # #export SHELL=3D/bin/sh
    2021-12-27T16:35:51.274954  =

    2021-12-27T16:35:51.376083  / # export SHELL=3D/bin/sh. /lava-1324099/e=
nvironment
    2021-12-27T16:35:51.376480  =

    2021-12-27T16:35:51.477492  / # . /lava-1324099/environment/lava-132409=
9/bin/lava-test-runner /lava-1324099/0
    2021-12-27T16:35:51.478367   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c9eb790993011=
a49397139
        new failure (last pass: v4.4.296)
        29 lines

    2021-12-27T16:35:51.838937  [   49.230255] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-27T16:35:51.904412  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-12-27T16:35:51.910124  kern  :emerg : Process udevd (pid: 115, sta=
ck limit =3D 0xcb9fa218)
    2021-12-27T16:35:51.914822  kern  :emerg : Stack: (0xcb9fbcf8 to 0xcb9f=
c000)
    2021-12-27T16:35:51.922660  kern  :emerg : bce0:                       =
                                bf02bdc4 60000013
    2021-12-27T16:35:51.931157  kern  :emerg : bd00: bf02bdc8 c06a3cdc 0000=
0001 00000000 bf010250 00000002 60000093 00000002   =

 =20
