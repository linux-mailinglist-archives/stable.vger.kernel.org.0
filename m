Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC601D8F95
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 07:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgESFsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 01:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728374AbgESFsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 01:48:53 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3A8C061A0C
        for <stable@vger.kernel.org>; Mon, 18 May 2020 22:48:52 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id w19so3380605ply.11
        for <stable@vger.kernel.org>; Mon, 18 May 2020 22:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v0i4SoTNOetxv1TXQohw3BAMTxHV/xX29DYqCh6nNok=;
        b=BiAh6qN6rXj+DP6zny6iwHi4xUGnjFEEXq3HBK/50r7vZTeK/jDhMaiK8posA1N7Tu
         kkafipfmwxPLW4sRV5DAjLGoFz36wPeX/dovGuQyarHVNU6oemrD4v+G5p7YZCl1WKqR
         FJUjTm+3ylcQXDqzn49RZMOd+T5wFMkhuweUxt/TkGGppmwdUxwQ5VAtUpdyIPM106XB
         fxJAIz+xtoOqEWDpk288Fie177VMO8aLvBkIWXeMfdwpZp+46gkk8egbPySV8QpXCFND
         SevC+/yqT2WEcEIzrde9QJNTfAKxQ6mk1zBXe6wb4eeBz6sjPPUgm+YreE6Q3So1EiCz
         x9aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v0i4SoTNOetxv1TXQohw3BAMTxHV/xX29DYqCh6nNok=;
        b=Jfqj4X1YDtJpeRNLPs3eHwqToUrlO8xB4ve/7AeeixisvfTtD/oCBwprBZJ0sdMvzo
         PlFWyNm3deb2Jr+qgSgovlGPEGn9NSe06yyqHVtf1ijEqSBXlMwRxSRzs0czFEYCc6Cs
         iFRwEFLS47fpBt9Rhl9NkjA6toK9vaERixr6iks6SYF9VwcoNzHY+IEC7ROO9Haa9Vbf
         wuEWyOfaE9yZMO6qW5DmYZpze7hoczt83s8CgAAFBChU+l6DaFJM02CxrJiTVuCCkDib
         ImUWmXgy/wXW5ciGL/u18wBWuiFtc+TAVLPYtnMdx3nIzLP+5IofZiOc0PkRSEY3mL8+
         39Tw==
X-Gm-Message-State: AOAM532HwL5NdPTcxLAxqI2fkS+9MYltOClFj/Gq6cOE6pLNBYVhc5Bw
        j8JPfAALKoLrV+7UgPShJKH7sFoxWd4=
X-Google-Smtp-Source: ABdhPJyzRXCZTZWBR2aCFH9gSxnYReCmVt9oDSyD3KTRnCxLeD8snOX+Chd+J+NqyUvrOwV/sv5s7A==
X-Received: by 2002:a17:90b:d8a:: with SMTP id bg10mr3234503pjb.103.1589867331432;
        Mon, 18 May 2020 22:48:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c2sm9129626pgj.93.2020.05.18.22.48.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 22:48:50 -0700 (PDT)
Message-ID: <5ec37342.1c69fb81.cb660.9f10@mx.google.com>
Date:   Mon, 18 May 2020 22:48:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.223-87-g5614224b8432
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 96 boots: 3 failed,
 81 passed with 6 offline, 4 untried/unknown,
 2 conflicts (v4.4.223-87-g5614224b8432)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kernel/v4.4.223-=
87-g5614224b8432/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.4.y boot: 96 boots: 3 failed, 81 passed with 6 offline, 4=
 untried/unknown, 2 conflicts (v4.4.223-87-g5614224b8432)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.223-87-g5614224b8432/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.223-87-g5614224b8432/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.223-87-g5614224b8432
Git Commit: 5614224b8432edc87094945490727479494da465
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 18 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.4.223-36-gce=
b6b0b3f45d)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.4.223-36-gce=
b6b0b3f45d)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.4.2=
23 - first fail: v4.4.223-36-g32f5ec9b096d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 53 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

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

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
