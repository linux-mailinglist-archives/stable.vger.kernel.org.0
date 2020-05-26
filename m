Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D2D1E20F2
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 13:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgEZLfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 07:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgEZLfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 07:35:46 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433B7C03E97E
        for <stable@vger.kernel.org>; Tue, 26 May 2020 04:35:46 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id z15so4734687pjb.0
        for <stable@vger.kernel.org>; Tue, 26 May 2020 04:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FI595couy58ldOP1Jv0OXNYnmsddknEEdimH7ZmvS50=;
        b=KvORCnFSIualZrMVAZXQd+iGInOaN9xHnkdGzAuMRpaIE0hyOCbyYZVv8QGqBje9sv
         Swl4lN4ZxupmpfpjKG7bfv0L7JFwMs92Y8/Eqha0ij7Dk8v7mKx7kqedVVeHzkKsANla
         VbhaWC9zy9AAFtn3oU349npauZv80IOQHK95sFPRypQlVHSLGngUl24QHujT0dJ0YidI
         7GVpMt8T6gHlxa2nRs7LGAi2P/vsNzAPF7SYmM5wohzX1XOz9T7POP0cldI3wseWfeZF
         xZYFMQuPxBewoNSVxwdco6OnaqI5eRkAcCCuOcCwvMXMFu2/yLRNfybXJ4Echc56cBIj
         M8Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FI595couy58ldOP1Jv0OXNYnmsddknEEdimH7ZmvS50=;
        b=rcZMo43sQMlG2p7E85bQb7UyS9hUJNU2qtvXDzcPAkcW0TI9zxpDh3ztoOIZXNyDZK
         GWdcc1EvyovLOkuPBLhcbrXuwUMIaFkusI07VhdcNtMwaHybYnaykZKc5ejTNFoHgUUa
         5Hk6Hcv/7Hf1eg/JaPKiyAqFAJKUt69UevFNTeYClqn3KLCv+53rPbuhmeQ+7f6dir8+
         C5H8f8sCsOb3pCzYr5J0I0UdqLWPr+kWZ0bBMsK+dW1wjW6sWpw3M3yGmjZpu1P+XvDX
         /gyyw6KcbiBw/go0kwFUnvHikN6VwbOCgVEVB83HUDT5ppb1fHEWhjsVohwlWVGgUdDL
         VZdQ==
X-Gm-Message-State: AOAM533Hmy8eavq7qwDWmRYsMbnA+GFmg7/0jxKeJx/lvBHRZusmEoce
        w+DUQLIvF+lbRqws1q1cwweeoT0Kyv8=
X-Google-Smtp-Source: ABdhPJzqT6XnHUpm2qHOV1W8cnpBXuofH0kcKR0zd3/eQuNN3jmfMtFWQbCBj60o3jK4xS/HYOEbpA==
X-Received: by 2002:a17:90a:c7c9:: with SMTP id gf9mr26405855pjb.19.1590492945437;
        Tue, 26 May 2020 04:35:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o14sm15142791pfp.89.2020.05.26.04.35.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 04:35:44 -0700 (PDT)
Message-ID: <5eccff10.1c69fb81.748e8.af5c@mx.google.com>
Date:   Tue, 26 May 2020 04:35:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.181-59-g2c9e54b6ad6a
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 129 boots: 3 failed,
 116 passed with 5 offline, 5 untried/unknown (v4.14.181-59-g2c9e54b6ad6a)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/kernel/v4.14.18=
1-59-g2c9e54b6ad6a/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.14.y boot: 129 boots: 3 failed, 116 passed with 5 offline=
, 5 untried/unknown (v4.14.181-59-g2c9e54b6ad6a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.181-59-g2c9e54b6ad6a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.181-59-g2c9e54b6ad6a/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.181-59-g2c9e54b6ad6a
Git Commit: 2c9e54b6ad6a1307ba4365dae90d882bc31ada04
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 21 SoC families, 17 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 13 days (last pass: v4.14=
.180 - first fail: v4.14.180-37-gad4fc99d1989)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 96 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
