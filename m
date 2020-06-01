Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CD11EB18C
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 00:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgFAWNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 18:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgFAWNp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 18:13:45 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675E7C061A0E
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 15:13:45 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z64so4100932pfb.1
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 15:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=K/eVUGRDv7BTFwNt7tPoUcfALAncGM6GriFGx7iKwIQ=;
        b=Rfysqx9OnCBHwVhR0Wg9QvM85nbU0HIhPuQFcHYlv0THp4QHhLwepZRoStJjmbM1+/
         G+PVzu5jBtI7lJNCg5fZRv52/3MJaWn2GiBvhcOe7W59g2+6Sa8OIM8VW0MwQVbw89oA
         oov71loobludM7jtSvZSTRGRYhBjd3iOiRvOkw3Vrx7Zp0efUXlk3xpM//aKB4TAjWqa
         Ujag01fiwO5eZ3N3dS4054RRXhHIqwr3Skn+7wc8MStGlkRcIfrkKPMb1HZzgPAZksCw
         IiXPbGzZ30tGjR/XHkkINpVatEJkqCdsS8zXeJm8SrMp/S4kMOGElg/bJYrZmE8MSnfJ
         r9sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=K/eVUGRDv7BTFwNt7tPoUcfALAncGM6GriFGx7iKwIQ=;
        b=WZzpg9UMTWpE1cohbQwVN4BG0J7U/N0IGBG443c4YO8voYUFZAsWIAvKKdBy08lA2R
         QUrMFd0nqYH3nj4SThraPFNxHUbo3A9kZvXwnboYHjvpHNF1Yy2TFX+rieM2udOmc7sR
         0JI75ztP6AslXKP4//72yr2vFfROrAoPz2yM6NXJVhRCBhMcCCLEPq2ZRGE2an87dmT1
         9/vQum12R/FBvh7GU0L7ECJqRpsjoJ8D71NSE2GdRI1xp/q1ttSlIGbqtgJ13ZqGuZx7
         Ppw4YsSXeaj1wHiHV3jTsdRzvIxewzGmUH/1xs2lzKlHqB9abmAeG8EeB5RofpWnbk5b
         wuUA==
X-Gm-Message-State: AOAM531bXat8tPxJ5vgDGtYCY8s2mLlCCZgzYr9LgHCyi70a3F7IDWoU
        V/UX8SX5vyEkE4AIjGjK2b7ZgG1rdNw=
X-Google-Smtp-Source: ABdhPJzTnXnTg3uKH/7TtjtadfsTrvtUkVSCJyqYp+KaZtvH/XmlQw1RHQZVUK9thh2kFJUOVvlFXg==
X-Received: by 2002:a63:b904:: with SMTP id z4mr21533964pge.25.1591049624584;
        Mon, 01 Jun 2020 15:13:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 2sm358434pfz.39.2020.06.01.15.13.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 15:13:43 -0700 (PDT)
Message-ID: <5ed57d97.1c69fb81.94d84.15d3@mx.google.com>
Date:   Mon, 01 Jun 2020 15:13:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.225-39-g04192ccac174
Subject: stable-rc/linux-4.4.y boot: 88 boots: 3 failed,
 77 passed with 4 offline, 4 untried/unknown (v4.4.225-39-g04192ccac174)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kernel/v4.4.225-=
39-g04192ccac174/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.4.y boot: 88 boots: 3 failed, 77 passed with 4 offline, 4=
 untried/unknown (v4.4.225-39-g04192ccac174)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.225-39-g04192ccac174/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.225-39-g04192ccac174/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.225-39-g04192ccac174
Git Commit: 04192ccac17413ef4b8969b054c12eaae27ea194
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 18 SoC families, 14 builds out of 151

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 19 days (last pass: v4.4.=
223 - first fail: v4.4.223-36-g32f5ec9b096d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 67 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

Boot Failures Detected:

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
