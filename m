Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484744297DE
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 21:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbhJKT7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 15:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbhJKT7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 15:59:03 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F5BC061570
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 12:57:03 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id x4so12041877pln.5
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 12:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jnPUar4P6QQYXStwnPnOBCtYLkXSvZ4OBG6CW8U/0Lk=;
        b=jAUdO+6AqBKgTFRNHl05hAYTFEDrYySvcThlup77q3te4oK77nDemfrpTPpC1tZqFq
         eD0Kto5N6e9ac39HfW7ZpOgHE28nph77Kw+xf/hQM04IuqMiGSa3DEbdsQGTAiuxzQ7s
         +bezOs7p2cHdq04ffQznEjotSA/KATBUzwrqSxphp2oN7l/Uckw4SSmx6NVsK+AhP6H2
         ERecp38Pvob3RMEegzem0+nigkFqW1JQad/D6XSc3akIWE3QoXiNHoD/Jw5InPt70O/+
         Z+N6HSRnWhRW4kabTIPWmxIqkIEJcw+dvzHRdJUOoeef/4w7VOveKMqKHBBSkflyNs1H
         424Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jnPUar4P6QQYXStwnPnOBCtYLkXSvZ4OBG6CW8U/0Lk=;
        b=URDcs0ZJxA8shj78SlHjkyFklhU1TJ5bBnhvEGTFwfZ90YNr8TFL799SJ/K1AYYik8
         ePexfh+//pUstCbO/m6Ctp3ep3xPqn/2XAQrTf9LNH/wVl3LcDKionhzEqaieS38hPUg
         HvFsnIRIF0jDf2DF+JEG93GQyi65FaEeUIog9O9AczSrixlrGgQD6xkd5b9WhwHzXMp+
         f1EO6Fvw+P7gSVCD5z0jeUPZEZoAC1VIo+c1Ms+iz2Q5eyR0VbkexKMhNCwxeTzagc+i
         IPkg9KhLLPyfjT7MayOUyPPTCMRkXi3xG5kClpVz7EK3lWJx0pgS5he2Kq+mxyZKqz1J
         aZ+Q==
X-Gm-Message-State: AOAM531fqRFfSVHUVyS+ToNwP8txDWw3vMGoa6+KnPSIegZAI/ojOO7e
        Fs5cwWTh7csViIh1dpBPr1IeqJFaDTvTpgtn
X-Google-Smtp-Source: ABdhPJxuwBkmUdivs8sM9r+yP9ov2cezSH58LE0Y53aR4gQq++1teLm98Y3FwqDKniN72yaXYjbAXQ==
X-Received: by 2002:a17:90b:4f48:: with SMTP id pj8mr1108012pjb.246.1633982222979;
        Mon, 11 Oct 2021 12:57:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s14sm8486488pfg.50.2021.10.11.12.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 12:57:02 -0700 (PDT)
Message-ID: <6164970e.1c69fb81.ff342.7b5f@mx.google.com>
Date:   Mon, 11 Oct 2021 12:57:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.210-29-gbf6c58e72541
Subject: stable-rc/linux-4.19.y baseline: 116 runs,
 2 regressions (v4.19.210-29-gbf6c58e72541)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 116 runs, 2 regressions (v4.19.210-29-gbf6=
c58e72541)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig  | 1       =
   =

panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.210-29-gbf6c58e72541/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.210-29-gbf6c58e72541
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bf6c58e72541e21b064bb89eb3256274f8cfeba1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61645ff603c6a5297c90dc99

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
10-29-gbf6c58e72541/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
10-29-gbf6c58e72541/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61645ff603c6a5297c90d=
c9a
        new failure (last pass: v4.19.209-13-g0cf6c1babdb5) =

 =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61645d292da404cbb890dc98

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
10-29-gbf6c58e72541/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
10-29-gbf6c58e72541/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61645d292da404c=
bb890dc9b
        failing since 1 day (last pass: v4.19.209-13-g0cf6c1babdb5, first f=
ail: v4.19.210)
        2 lines

    2021-10-11T15:49:46.361296  <8>[   22.695343] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-11T15:49:46.408665  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2021-10-11T15:49:46.417793  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cf4 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
