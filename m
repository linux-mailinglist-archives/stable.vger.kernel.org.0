Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C273019391C
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 08:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgCZHD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 03:03:57 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42791 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgCZHD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 03:03:57 -0400
Received: by mail-pg1-f196.google.com with SMTP id h8so2415624pgs.9
        for <stable@vger.kernel.org>; Thu, 26 Mar 2020 00:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gINLCiZiV/NtVny6rdul8Jx2dmUCIdaR1c/PjTFAQUo=;
        b=YvpI1s9xyLDvKVaNDjiJGUPeOpLj03zRsr4b1ZkrLWGByWRE9EjeQC4n1go3TqTwSO
         nFeI2tolmICqnla+S5n+3O4+j421v7htLxhjK0qaMdoNnSeSIowrLIbAcVmMFSxI1F0V
         vZlkXfCLvI7FmMx1eqLsbWCT2WKdOpo36ywzkXkPL7H7PN/TX2YUXj8jdwXWCjUGmLYI
         dr7UiVnCCVcAjpYlfjSjHHfD3Yddtu42QTvRzRl4ga2hantuoGI4v227IkL8x0lELFhG
         DhRQ5lYYvFzD7qIhwnWvCWW1M5XqEexuJN6YlfKDydVfwfbKZNrZTd8Kp3/gS49tMFH7
         KoXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gINLCiZiV/NtVny6rdul8Jx2dmUCIdaR1c/PjTFAQUo=;
        b=Lg8idLuiXqOVGxI/7jRFrXuWb3UKTPabF3HE8AWvCYAFvoER7GvWenODfq1YRIJelA
         b6UIMF1phlRMWWdpq83+5rH8KvsR+NzqGXjWKUEARQ0Hm4/Wo29M39xXalysmBLl03pn
         yMYVgWCcJ5kjG+EHyZEJD77tvX2ZfPpEZTV2J76RP+B8/amBzKdvYkXTslFUSh/5S/Gy
         Eoednj2cKnqGWYGajg7sufb0xEuZvvqAkaMvBDN/HCGgKtTjDGSp4Bjvsy/s/EHpZ5Zt
         UANUKl76uzUHXgBNBp2Shpu5OabHr3AkhkDl73lkMjt9b7SswafwmIg7tHEG19bQ53jC
         DGkg==
X-Gm-Message-State: ANhLgQ3CPsTffafC3weJ6ZqDVQBVFS9EhdPwjTFCSYKxuaCCj29aVcJE
        GUO7OZBPWJr4BOCmid/XKsoDSoe6A0w=
X-Google-Smtp-Source: ADFU+vswPkoJ9F1923k9bP1ia05fBwvjuWZZl2cSQYGPvOHGJvPt7ABBkUZedhWNRZ+nnF4HlMaTCg==
X-Received: by 2002:a65:62c7:: with SMTP id m7mr7083978pgv.380.1585206236197;
        Thu, 26 Mar 2020 00:03:56 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x24sm895749pfn.140.2020.03.26.00.03.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 00:03:55 -0700 (PDT)
Message-ID: <5e7c53db.1c69fb81.52343.4230@mx.google.com>
Date:   Thu, 26 Mar 2020 00:03:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.174
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 121 boots: 2 failed,
 109 passed with 4 offline, 5 untried/unknown, 1 conflict (v4.14.174)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 121 boots: 2 failed, 109 passed with 4 offline=
, 5 untried/unknown, 1 conflict (v4.14.174)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.174/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.174/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.174
Git Commit: 01364dad1d4577e27a57729d41053f661bb8a5b9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 21 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.173-155-g=
78d092884075)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 46 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 35 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.173-155-g=
78d092884075)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.14.173-155-g78d09288=
4075)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

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

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
