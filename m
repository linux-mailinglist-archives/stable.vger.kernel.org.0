Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645EA4780F8
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 00:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhLPXyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 18:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbhLPXyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 18:54:14 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29030C061574
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 15:54:14 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id b13so352177plg.2
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 15:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DfErZedRJxrJx+iKBf01FgkwaASlWVXl4H6SP1vkAjM=;
        b=Zw2igyufiW5GWZtWl42aWNC2ckBQGPkgfZ1B+1x+0EhEyYcG7l/3CY76Ybwk3txHxn
         RyRaW2rv2Lnf16Q+ksx6pL/aNyKkYr8aRQ8hEBanWD6ZmXa+lU8/NWFw+wckOdPIME1G
         9XwakanI+gQHDCtxdB0CTkC23IVxNDYkHIlKg+/+ycEK8eyXW4Xi7hLguWKWZxVxvUdd
         UzM5LRtgWXPJkVntN2C6b0+KJklLL8dN1/ns25edYDukgThs9iM03cGUaWdj8Sg7wufn
         QB2yeOIRpYB0ZFfskk3TMF+zUVvGlxKBsZ9f68t5nzl1sSEJKsoyTb/Siof8Md3OTzL4
         7TQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DfErZedRJxrJx+iKBf01FgkwaASlWVXl4H6SP1vkAjM=;
        b=P07YhhOf6pIXt61fn3TpOm/Z/VTOwxVoBDUTtzXLZXtrWJCkss/xsPxto3DdaVKUTC
         zc9wosfacQpXdDmNZds4ASQaCtZ8hJzNB/5wKSC2+fa0hidWesWeUJnPOZqw1qE3PwLb
         qv35+V/Tg8yRMyoRAfcUDWRgLzrq+pbsEVuT1KLQMX9goyHLJPBYZFgzGlqyLuQ9Gnkl
         BnL8Rsl7P6DSnOGIq86kz/WIObGKhnYC753YmByUcItzL2elHcRkVGomr+Z9lPVuAusX
         8RfPkWjP3MkyO67HuRBI0Wf+Fa7GbtipJAGMKKvly0KddmImuNxrDo/ip65d9gv8luYK
         +FEw==
X-Gm-Message-State: AOAM533vnG5OTir/sFd2zdLTEsoKIX598YggoISUNEJdXr5ljCZMY9Q0
        cxYWFMzx4BacHlCV3RVKNLeHfxTLQNtWw+S7
X-Google-Smtp-Source: ABdhPJwXrZ6ItFWlk6MMiRI4NhzAS2tMEnFHcQdmEOCF89cgRxmEmVe3vxIY846a7vVZlOx9JR6eww==
X-Received: by 2002:a17:90b:380d:: with SMTP id mq13mr611970pjb.110.1639698853541;
        Thu, 16 Dec 2021 15:54:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pc1sm11660325pjb.5.2021.12.16.15.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 15:54:13 -0800 (PST)
Message-ID: <61bbd1a5.1c69fb81.9f655.0d7f@mx.google.com>
Date:   Thu, 16 Dec 2021 15:54:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.221-9-gf48d5f004d75
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 148 runs,
 1 regressions (v4.19.221-9-gf48d5f004d75)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 148 runs, 1 regressions (v4.19.221-9-gf48d5f=
004d75)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.221-9-gf48d5f004d75/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.221-9-gf48d5f004d75
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f48d5f004d7535d1a65553fa9f592289a682ff77 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61bb9a7e925b13bf0039713e

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-9-gf48d5f004d75/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-9-gf48d5f004d75/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61bb9a7e925b13b=
f00397143
        new failure (last pass: v4.19.221-9-ge98226372348)
        2 lines

    2021-12-16T19:58:39.622302  <8>[   21.483459] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-16T19:58:39.669664  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-12-16T19:58:39.679029  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
