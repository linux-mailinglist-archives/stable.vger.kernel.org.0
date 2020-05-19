Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E311D96BE
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 14:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgESMyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 08:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbgESMyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 08:54:12 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1938DC08C5C0
        for <stable@vger.kernel.org>; Tue, 19 May 2020 05:54:12 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id u22so5577456plq.12
        for <stable@vger.kernel.org>; Tue, 19 May 2020 05:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yqHgzaPkChvj6Op7XNmbN+COhQ5lZX3kk8+/XTrJ51o=;
        b=TmldYH9dhWtlK6PiDgZLPlXZ0Sk/zgRfZFjybjsCLlqACSyGkYCMGqYEUZIxReFybG
         aplZcbIsW2X9st8M0dXazW6jH4xK6e++t7utZSe9J8PJs99RV3GG841V/eZ22Zr0egCH
         aRApximHHY/2gs8aigUIkA/ZpIeC6bx3HzPs/Ty5sZ5F951L+eoR/gEifIOiTY3IDh5j
         HCfTheOVwjhc8r2AjjOn/T2EJOKbcqXr/JNgbiWlOI0abP0gEuA+SUCvSQAcPyzR7Aaf
         16CCNiLEOSJt7CQGSNEKwC1KeK1D+3uykEepC6ayNJKswNN9sv+GQSwYBFM1ytTGSXrO
         FoUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yqHgzaPkChvj6Op7XNmbN+COhQ5lZX3kk8+/XTrJ51o=;
        b=kfjiwkLDUbGL+pCgVtkLERs25C+3nPG/mK/LD+6V9aBcREOCIHOWao3AhM08R57+E1
         lbrLfVebgNZhPFsE+fWOLmNxbPHLiXusmvhjZ5A/c8XfvYpioxynfpvQrKeGeA8nXSpb
         I59qm/4bTcsUZCZT94b0QutCx8RKGFDQQERPA6TFyM793bs8ozWFzEEYKrz41tYKrb6h
         QVlv60nS86ArU7U58ecmPcl5lb1xBJOsZzjc86criWX4wF3tBUyDbSd4HhRcj10hoTrq
         pgIERt252Gs7XbbDpZyEWXFz7t3irl+ODa6coE2dQzx0m2V0CDQfyJwaqhqypfQdnnXN
         +HeQ==
X-Gm-Message-State: AOAM530EkHVyEwVbxuxfZUe+rHhjQhq2P8l9pJdtvFE+0g8nLlV92xrs
        amlNCI6UsZGVodg4IGjRVdjME7hApW8=
X-Google-Smtp-Source: ABdhPJy7KJPwsqZ3dAnsmNLGSjgjOHR8xpYeBoHaSYBI7+EJFdpLzU+6f91auDy5rhvfyt1f0KTocg==
X-Received: by 2002:a17:90a:4497:: with SMTP id t23mr5006693pjg.88.1589892851244;
        Tue, 19 May 2020 05:54:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 141sm11496654pfz.171.2020.05.19.05.54.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 05:54:10 -0700 (PDT)
Message-ID: <5ec3d6f2.1c69fb81.a7e1a.391d@mx.google.com>
Date:   Tue, 19 May 2020 05:54:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.13-193-g67346f550ad8
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.6.y
Subject: stable-rc/linux-5.6.y boot: 163 boots: 3 failed,
 148 passed with 5 offline, 6 untried/unknown,
 1 conflict (v5.6.13-193-g67346f550ad8)
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
https://kernelci.org/test/job/stable-rc/branch/linux-5.6.y/kernel/v5.6.13-1=
93-g67346f550ad8/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-5.6.y boot: 163 boots: 3 failed, 148 passed with 5 offline,=
 6 untried/unknown, 1 conflict (v5.6.13-193-g67346f550ad8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.13-193-g67346f550ad8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.13-193-g67346f550ad8/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.13-193-g67346f550ad8
Git Commit: 67346f550ad85f9ddd257856e32049416df51616
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 99 unique boards, 26 SoC families, 21 builds out of 200

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos5422-odroidxu3:
              lab-collabora: failing since 1 day (last pass: v5.6.13 - firs=
t fail: v5.6.13-195-g4dae52cee3fd)

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v5.6.13-195-g4dae52cee3=
fd)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.6.13-195-g4dae52cee=
3fd)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos5422-odroidxu3: 1 failed lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        sun7i-a20-cubieboard2:
            lab-clabbe: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
