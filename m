Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863691ED872
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 00:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgFCWNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 18:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbgFCWNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 18:13:14 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4C6C08C5C0
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 15:13:13 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x11so1304753plv.9
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 15:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NmUsyQuml4o4c/LNub/sL1c6epYbRXOnyFYNRr2Vg3w=;
        b=wLMor6w+wv1ye9yrDeH5mSYFkZFLH7FV+RuG0l49p0qKgKSE9cfL+h8z+mkeXmuzs5
         AfFD+6lmBoaJGKgwU68fumLaIFfDEG/kUiJz5PCQh4hTk6BkaMV4x2io18dDeDb/kiQA
         DMxjmyw3bhiM+GCHqzROytyMsd/D2BEH1V4XCOMB51pUYwx8RnQR7HIfO2aezzP31MLf
         Mqo2A4i46cnSsbT6rOw0CSMwSB0bBp9sECACq/vDASUa92zYPeUu+F8h8RlOOxRPzMoz
         y5LFYqPSOfl3qTXSBTVn0uXfZdX6bCJXdCU8rebSTOcoyxr9dcTM2W9jVz0VssVbJFII
         XLIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NmUsyQuml4o4c/LNub/sL1c6epYbRXOnyFYNRr2Vg3w=;
        b=FzScYmU8KDZilxky78hFK34GCTzC6UxxzaGG1sYTaRrY5727rZYbrmUgLSCFAMrPBD
         aqIysKsqCkpBc/bDqqZuATfw0HLTulqBMyc0ZeoT/TdhuEPDGUQBooEqgnqYD0YL/N9l
         fGGS4paSE9UlICXLq+5FVI5N/O53BAAr8gHkcuB6csLW7FuXHNn6qsvYKM3Yr7Ndm9iF
         tbcQqiOVk2u4cgrRt//iPWtKWF+Sm/WrU4iHfxviKydir258CKfmtQL913lQ8oiN2W8I
         ZgCb4QLus6su1HoTsh3zK8SRA2zVsDOKJIOOaqNrucfi+hv36plT2rEJYbzCnjVPrx47
         7RDg==
X-Gm-Message-State: AOAM533Cgy0ocFxmNHgEJJseKcck/L4Mv/pLBMJ1QIq8DcTexPUgdnkc
        ucrXhI1oAOmBoVJQJnGs9kkExU95WM4=
X-Google-Smtp-Source: ABdhPJxIsTyZDw8GSdtIMyuH0UIJ0J2SgiGcTeu7iZDQa1tDPrbz0QXwJ6b7TRoRPwRIY2Pl3RUJ5A==
X-Received: by 2002:a17:902:b411:: with SMTP id x17mr1758750plr.272.1591222392436;
        Wed, 03 Jun 2020 15:13:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x7sm2524602pfm.14.2020.06.03.15.13.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 15:13:11 -0700 (PDT)
Message-ID: <5ed82077.1c69fb81.badfa.72b8@mx.google.com>
Date:   Wed, 03 Jun 2020 15:13:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.44
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y boot: 144 boots: 1 failed,
 132 passed with 4 offline, 7 untried/unknown (v5.4.44)
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
https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kernel/v5.4.44/p=
lan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-5.4.y boot: 144 boots: 1 failed, 132 passed with 4 offline,=
 7 untried/unknown (v5.4.44)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.44/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.44/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.44
Git Commit: 55852b3fd146ce90d4d4306b467261f2c4869293
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 100 unique boards, 25 SoC families, 17 builds out of 156

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 116 days (last pass: v5.4=
.17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 56 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.43-140-gf5694d7c4=
27e)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v5.4.43-140-gf5694d7c42=
7e)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

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

---
For more info write to <info@kernelci.org>
