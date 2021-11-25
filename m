Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628EF45D178
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 01:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245300AbhKYADy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 19:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244870AbhKYADx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 19:03:53 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E6FC061574
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 16:00:43 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id v19so3156856plo.7
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 16:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ni+MXqnwx8xi5TOWuXW6HcarHzcNuGFyupaWfJC26VU=;
        b=em8rassOXPGINCzPGehtBolQBQPfttIVcyAwdpepbLxMFliQYSjT6dAkmF6utQ+lXP
         CG68GhpCV4Jz/Z2jBqwPXSFG6A7aEFHkdk4HuteaBFSpewgS7sV6fLwnN32GwYq+fk/J
         Uh306Y+kszImEn0ZMAfXzze/Yy2SUpHNEnynFOz9uKeLp718kcCQZQxHm1CcpDVllN4z
         Aad/kwZIIImh98OQgecJ3s1aVW+KU2JWveypHx/zFuQmR+YxX0K9yVLI3ZS+DXtMaVmP
         IPfovaNKKsEZBQbqWE6Z0goLrqJgRmcdCXgsvqscIR0cjKUE5H0E8fl+0N0H1WCz8DGk
         s30g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ni+MXqnwx8xi5TOWuXW6HcarHzcNuGFyupaWfJC26VU=;
        b=ggDBpAtUNmGVEHObDGuJS5e5GO/DU+phs2mEXENpm6VtmXX743ckURgbERhFaRWGrT
         RXi6Ljrd0DPI0yC51jzlZ33ctHf+XrU+VFXqpOPZ+v5JATaEJ5YyrLFH0ofwYZKQcxkY
         B+9Zx6dwO2B/JT+ipcqbdiENz6aLGlMuZiT/Ac6E1Ou59y3Z8ZxkrYEE3bq9ds235Ttx
         y2x8emk870zBOKXcjpSOFITJ55CGprT0INwP+IHTo3i4bBFrorLDsaoIU5GYBc7HAFar
         GIEzcAixU2/HYodFukKmDGqJ14wsOtR91rE0yEPXvvackH8mL8+CokrKHpHj6o5cMbY6
         whkA==
X-Gm-Message-State: AOAM532yBsHE61irDnI++/K47az/RenOAmCmu1uZB9jr2Ti+GGfXROYJ
        yHwja2WJ/t8yeMI7em2NKQIGaMK5n6fuIi/5/lU=
X-Google-Smtp-Source: ABdhPJz6cFhkJwxxz76mfOknz4R+CDIras1kVK4ncJLW++o45Ml6hEm754jq3efu0SU0IViJjPif8w==
X-Received: by 2002:a17:903:186:b0:141:eda2:d5fa with SMTP id z6-20020a170903018600b00141eda2d5famr24285192plg.63.1637798442080;
        Wed, 24 Nov 2021 16:00:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 66sm624372pgg.63.2021.11.24.16.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 16:00:41 -0800 (PST)
Message-ID: <619ed229.1c69fb81.f49fc.260c@mx.google.com>
Date:   Wed, 24 Nov 2021 16:00:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.292-160-ga0e342c5dc0e
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 103 runs,
 1 regressions (v4.4.292-160-ga0e342c5dc0e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 103 runs, 1 regressions (v4.4.292-160-ga0e342=
c5dc0e)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-160-ga0e342c5dc0e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-160-ga0e342c5dc0e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a0e342c5dc0e6f6cb053acf5d5843e17f13f933c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619e984ad47ab568d3f2efb6

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
60-ga0e342c5dc0e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
60-ga0e342c5dc0e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619e984ad47ab56=
8d3f2efb9
        new failure (last pass: v4.4.292-161-g719b6ae9e13f)
        2 lines

    2021-11-24T19:53:25.501652  [   19.631896] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-24T19:53:25.545068  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/114
    2021-11-24T19:53:25.553982  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
