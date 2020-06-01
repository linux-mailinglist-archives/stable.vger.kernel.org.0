Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657A71EB21A
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 01:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgFAXUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 19:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgFAXUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 19:20:09 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C72C05BD43
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 16:20:08 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q24so526433pjd.1
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 16:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pTU7FtkjGbvPN1jT8GofnUWWwY0IIip3SSNuM+pV2+I=;
        b=rb3SZZN+ZXMEiENzdBnugh8EOJBYmMtNVy1euYqS9thiHMxaaTIOVFmYdJ8LH8gJah
         blhMWCgl3GJoYN+1zgFrZPH8/iTy3BGjPb/lzDREJkLXJRpx/dsKb0osBVJxnC//rNWU
         qPC6FTu0C0Ri0Kq7JXzN3dHGMy8wGQ8L5j0bfxuKYFH2sr7NcsUS4x08RVzxl/QodyPL
         ZrpERq2jMn+RUr17ip6+TcG0kbav9f6pV6jnrQsShReeZamqt1JKw3f/7V7htzJ25F48
         QQXUR3ybHv1LtI5+VWwR60blFzIEwwU1mJRzSf3R0EQeTEeMoamzbXJ5XZCfE058ALHz
         Kalw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pTU7FtkjGbvPN1jT8GofnUWWwY0IIip3SSNuM+pV2+I=;
        b=edlt2MLHVvXfq+7vWoW7ZBd/k88RGMYetXocbfATtDSMlIteXQB4ALn37I0oAzTt63
         iPK+KuGWCPGtSqkZH0PHuN8T0ZOHrd23Hu8BkUwejIEDdfzTWaccPDBBDVANcwaGIOGw
         JDkKZ57jxqeZzLmnv2WRkr2Ob6Js6qHOu5xjdrEXSYmAZV8PZHd2jXmVSkWuKELjEhzo
         xUX9CxHo+sNIfLXZrK/QLrhIoxpC1bloZOiGMq0m3vipEL66Ouc11Jw53eA+7EXzmVOP
         RHAhii2yQ8b8bVskztaMSdr5MuIpkbO3NgPEvnRnhjlHKOuznYbhIkb80f6/PSM6JeKi
         9q8g==
X-Gm-Message-State: AOAM530UOocF7Y0HZ2C+f8gTBA+/EAP/h3haFxOayy56WOh6LnIALsE5
        9VIdx4br1ktJCmSJLuUqTPavRJlhdsU=
X-Google-Smtp-Source: ABdhPJwjhD8AAQVWNxoj1Xrnm+NB60JBUXV7oeEpvkaS3lpOQVCoZ6N+jtkSlILGEEJV60xFo1uRJg==
X-Received: by 2002:a17:90a:5d06:: with SMTP id s6mr2128931pji.88.1591053607992;
        Mon, 01 Jun 2020 16:20:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z8sm451292pgc.80.2020.06.01.16.20.06
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 16:20:06 -0700 (PDT)
Message-ID: <5ed58d26.1c69fb81.27d9b.1c3b@mx.google.com>
Date:   Mon, 01 Jun 2020 16:20:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.125-96-g47f49ba00628
Subject: stable-rc/linux-4.19.y boot: 140 boots: 1 failed,
 130 passed with 5 offline, 4 untried/unknown (v4.19.125-96-g47f49ba00628)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

******************************************
* WARNING: Boot tests are now deprecated *
******************************************

As kernelci.org is expanding its functional testing capabilities, the conce=
pt
of boot testing is now deprecated.  Boot results are scheduled to be droppe=
d on
*5th June 2020*.  The full schedule for boot tests deprecation is available=
 on
this GitHub issue: https://github.com/kernelci/kernelci-backend/issues/238

The new equivalent is the *baseline* test suite which also runs sanity chec=
ks
using dmesg and bootrr: https://github.com/kernelci/bootrr

See the *baseline results for this kernel revision* on this page:
https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/kernel/v4.19.12=
5-96-g47f49ba00628/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.19.y boot: 140 boots: 1 failed, 130 passed with 5 offline=
, 4 untried/unknown (v4.19.125-96-g47f49ba00628)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.125-96-g47f49ba00628/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.125-96-g47f49ba00628/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.125-96-g47f49ba00628
Git Commit: 47f49ba00628e7ce16eda75304e947f7ddb149d1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 82 unique boards, 21 SoC families, 19 builds out of 161

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 19 days (last pass: v4.19=
.122 - first fail: v4.19.122-48-g92ba0b6b33ad)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 80 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
