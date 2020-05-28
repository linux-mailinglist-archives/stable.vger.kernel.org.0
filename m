Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4E61E70B9
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 01:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437647AbgE1Xsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 19:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437705AbgE1Xsv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 19:48:51 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345EBC014D07
        for <stable@vger.kernel.org>; Thu, 28 May 2020 16:48:51 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x11so237388plv.9
        for <stable@vger.kernel.org>; Thu, 28 May 2020 16:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=brYp6QjrpvbncuXZQ06X/11MijccNsV7WK5uPCNuNRw=;
        b=ewh1FuHJBKKpkKJcbTQvnADQbrkcthC9UTmPxyYljhygq23QJDuVQs0AUIIrO+I/gi
         5qzr7jjW/wX6ygcP2S8RSIEp6Ated4Gsnv1gjv1lNhnk1R/Iig0LJNF0yW5QQyqhqCrj
         I5YIp+46/CV0snI8AgMe5qsoMG3GHMqqXNyuBLmjGG3ScIfaBfSnHcNxyoj1ECJ6nUVP
         KC4M8H8pnPjvKv80iRLirz9VChgRwvTzI5m65Fn7GSP+T8Yix0jdvU8dGUl9aaXetDAk
         2VucygbM6EqGCCTj38Ylf954f/HmGdTmUjUXudlLfCy/I6ihHpw/tNKm1Z0xaFrORq03
         QqMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=brYp6QjrpvbncuXZQ06X/11MijccNsV7WK5uPCNuNRw=;
        b=LGQZyM/AU2y70EUzg3+ygcXFVMEesL7zjhURhs3clsiY47cLDU9vS5adoEOIwCPwNd
         RfFMMJML87iug90SvbyrS0l+ORVsOHMuFxVtBugVBwBPleo7UL6n0R60EqMLJ/7d25mb
         Ff0DJ1402/pN1qVGzD1vuclQ1LK5gxtJ/J3DJOfbTOlAAudLc8Wp/+rAcQ0umYtTUU+6
         T6ktYZyTGVL2ErO1oIUPrbRP1I8xfmPSdtnmfDl0bUYjXjcR2zM2Pbi7vQrHndrC49HV
         xNdL7Yx0xfaDL+zRXEI9bRomCovBY+GL5UwTVY+QYi3/bFP3Cchd57zsjOAVTmDr3/Qv
         qXFQ==
X-Gm-Message-State: AOAM533XDQ11Ak7UmoB4sTKFEWMgH8uI21xHBFOlf4bcJ8yJ/aehd2iP
        ugxNK2GsnVVsig0I3gdrnXmlPwWjPAw=
X-Google-Smtp-Source: ABdhPJz6mV7FWvZL5PLwPmpSgffuPTUJqEGDg3Jg5W+FBDMJHf4Hbw1Bvd+2E0+O6BUrXrDoDmIpqA==
X-Received: by 2002:a17:90a:71c3:: with SMTP id m3mr6446361pjs.17.1590709730353;
        Thu, 28 May 2020 16:48:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m15sm5227098pgv.45.2020.05.28.16.48.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 16:48:49 -0700 (PDT)
Message-ID: <5ed04de1.1c69fb81.f7186.2d81@mx.google.com>
Date:   Thu, 28 May 2020 16:48:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.225
Subject: stable-rc/linux-4.9.y boot: 102 boots: 1 failed,
 89 passed with 7 offline, 5 untried/unknown (v4.9.225)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kernel/v4.9.225/=
plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.9.y boot: 102 boots: 1 failed, 89 passed with 7 offline, =
5 untried/unknown (v4.9.225)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.225/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.225/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.225
Git Commit: 82dddebfe7da9d2670977ab723da2fdac3eff5b0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 58 unique boards, 19 SoC families, 18 builds out of 158

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.9.2=
24 - first fail: v4.9.224-65-g7b44b8e27432)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.9.2=
24 - first fail: v4.9.224-65-g7b44b8e27432)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 15 days (last pass: v4.9.=
223 - first fail: v4.9.223-25-g6dfb25040a46)

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

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
