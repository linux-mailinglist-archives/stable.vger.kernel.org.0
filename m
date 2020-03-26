Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0D0F19384F
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 07:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgCZGBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 02:01:37 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38276 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgCZGBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 02:01:37 -0400
Received: by mail-pl1-f193.google.com with SMTP id w3so1739041plz.5
        for <stable@vger.kernel.org>; Wed, 25 Mar 2020 23:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yGjbEMv50bBUEZobYnIa3HrigtHgzjDhVIfUpVDgPMY=;
        b=XgbudN1cbrroy6O6J2QAGHIjXU4S/ImKqkVdx36hBAn57RoMRdC1d8pGdJySLJDlIL
         uscN+huOq9iT6LqXFdBLIE20PRoDK7h2gt5jtOTjGq5NLAPTDJkJGA23EHX6GGsC6PbA
         2gS1ZHjjfXuYY4MFgY2Fa94FUadULA93VCGViM6MKumtokSQ9vpOw9KiNWpKY3pg69ju
         GMqdS3D2f11o43weJj3i++gdW/fCWz6AhmpFLPCAXD/P4/7xhAekE0ugBc28gQWnFQMk
         tfwSsePuWXZHjQyIheJgB2ZRaHpj16yFW4PHVKT3g3xxVpLWIROiyC45qpvrtHTqFXrD
         IVHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yGjbEMv50bBUEZobYnIa3HrigtHgzjDhVIfUpVDgPMY=;
        b=Wq805PnNGXJmEgsMvQuAGQzxs4xRe/6N2jjrM07T+MPHcV/IuuW6T7bs4hZpX62sL0
         IU818l/jFqRimVqdEtM0nHlGu+zkik3MS+0si9EXeboNH4Q7pg3Y7Ya8HZ8u4Rgdpp9+
         y4oRpcdYdi/s8uWPsVGO8TfHXaZdaRFRkuXdSt5HH9/aYBZKY97xS+p6UZDCW/Fwo/vJ
         YLY8a7ayESo1LMgCaD84v53XsTVugBSABtcP8AkzCsgAud9+DRx/d62Ud2gg0GiQPlTV
         VbXPhBfeqmFR7i7CyAG56VjHHHIi75pv6RQIQydKi3T+Dofg7j9V8RqtaQgx5ZZ07Ot2
         uRoA==
X-Gm-Message-State: ANhLgQ1uOeUweC6RPQrqa5+WtmPxDkIS4f3snPXgvW2gNmCxYdPcIHGD
        I9axqpnT/JR3cGB6Q7D87Tw+OcvNEwI=
X-Google-Smtp-Source: ADFU+vsCLA1hL9DjQSSWVHM2jEvAdZOX4PepLsw92I9Rx8+cFV68tHzbhTM43VvZDPpntx/e0u5Lyg==
X-Received: by 2002:a17:902:7d98:: with SMTP id a24mr4788650plm.155.1585202494170;
        Wed, 25 Mar 2020 23:01:34 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w4sm750008pgg.2.2020.03.25.23.01.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 23:01:33 -0700 (PDT)
Message-ID: <5e7c453d.1c69fb81.17d65.386e@mx.google.com>
Date:   Wed, 25 Mar 2020 23:01:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.217
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 111 boots: 1 failed,
 100 passed with 4 offline, 5 untried/unknown, 1 conflict (v4.9.217)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 111 boots: 1 failed, 100 passed with 4 offline,=
 5 untried/unknown, 1 conflict (v4.9.217)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.217/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.217/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.217
Git Commit: 10a20903d7ac2be29e0e13d66ad0d74e637b8343
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 59 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.9.216-128-ge=
b874cb221b9)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 46 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.9.216-128-ge=
b874cb221b9)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.216-128-geb874cb2=
21b9)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-baylibre: new failure (last pass: v4.9.216-128-geb874cb22=
1b9)

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
            qcom-apq8064-cm-qs600: 1 offline lab
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
