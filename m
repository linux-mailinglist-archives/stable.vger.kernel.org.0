Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429AE1E1A2A
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 06:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgEZEQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 00:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgEZEQi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 00:16:38 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41354C061A0E
        for <stable@vger.kernel.org>; Mon, 25 May 2020 21:16:38 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id s69so660336pjb.4
        for <stable@vger.kernel.org>; Mon, 25 May 2020 21:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MxiuBvN4rfyZv+qh/W6A+X83LRqAJPNVRvc12Oz/RYE=;
        b=oveF6kiXOpCLvnoQklNIy4TPpNRwnHwmJX03kfZsEldx7mP/0CLnuKkYL29+8TImvJ
         Zq/mc+t4pHt2CVQtibCPm418ShZNA6Xg2kMpFqe/AtsHXLfHwkA6BI//UBaIZWgLFXox
         2CCBjKs/+ghrX19gCNr/jJzKp4FonG+254Noblj3T0oHb3H+4TL/cgSHYWZ9QzQ3LBNR
         O+WdVYcvlas1CSA4CG1L2iz4hlaCVU02rQM4GgyHuen4d4OCAnfk3yWYxH215ug52dv+
         J1sU1doui2YGj5nndN7/QraTyyV5TgjLXeMMdgU+YFUSPWwlMQ/wpNfMlki053H6BUGE
         hk+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MxiuBvN4rfyZv+qh/W6A+X83LRqAJPNVRvc12Oz/RYE=;
        b=Yg/CBQ+uxZnE1zwJ7CRZ219n5QbAb+hshKzQS7llpad8+dFgoZEWjA5zO8OxmeKHcU
         hu4sL0j0Q1N3qv4kuOnDJdrKlWQU+ShYfI1iKIg6ayymq3uOmsULfIgJ/CNQfW7jGxoW
         GkxJUyxASLQE4pm/hQlgHIoDKxyJm6LI2Cq1EnxrI1Q9s0zpeHW2CNrMSI7dvaMz3zsv
         TEoh4ZC0bQLznR9gwwhVgtgV5gvvwsOokZElRpOci41PUUak9ckLB6tL9Um5Lwd87/po
         FqsX6dvrasw44tpfoxsCE8DmQ087xJ0Kd6LCIeFiewBUnvPC2mR5CP2Pl3Mf2YI2Hmz0
         tlgg==
X-Gm-Message-State: AOAM531lVKXI6vc2AAelH8SFQvpuYdvANA45dAgkvsIkWR30FYpHkXBf
        YBPIcyw/ar9s66KCF8D6xlHt/OdF37o=
X-Google-Smtp-Source: ABdhPJzO9kn29xd6ovJXKOybB/xfj9EsMOu0M7zyY9U4YH+ZIeg6r9wxDFBCSNm0Ao3QKO16KIPZVg==
X-Received: by 2002:a17:90a:4e8c:: with SMTP id o12mr7001900pjh.25.1590466597351;
        Mon, 25 May 2020 21:16:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m12sm12819453pgj.46.2020.05.25.21.16.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 21:16:36 -0700 (PDT)
Message-ID: <5ecc9824.1c69fb81.fc493.0d41@mx.google.com>
Date:   Mon, 25 May 2020 21:16:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.224-65-g7b44b8e27432
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 110 boots: 1 failed,
 95 passed with 7 offline, 6 untried/unknown,
 1 conflict (v4.9.224-65-g7b44b8e27432)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kernel/v4.9.224-=
65-g7b44b8e27432/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.9.y boot: 110 boots: 1 failed, 95 passed with 7 offline, =
6 untried/unknown, 1 conflict (v4.9.224-65-g7b44b8e27432)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.224-65-g7b44b8e27432/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.224-65-g7b44b8e27432/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.224-65-g7b44b8e27432
Git Commit: 7b44b8e27432c38eb9fd9e98eb66b781ed4944ae
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 58 unique boards, 18 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.9.224)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.9.224)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 13 days (last pass: v4.9.=
223 - first fail: v4.9.223-25-g6dfb25040a46)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.9.224)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-baylibre: new failure (last pass: v4.9.224)

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

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
