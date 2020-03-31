Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D87EE199CAA
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 19:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbgCaROk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 13:14:40 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42113 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCaROj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 13:14:39 -0400
Received: by mail-pg1-f195.google.com with SMTP id h8so10613434pgs.9
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 10:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NCqrZTG2fIv6akK/K0AV+ocFDdqFhlfj5q/crQnuPtc=;
        b=zPJXyz2aOlt2hG1LqTFj1z4KHSMzn2QFLoMb1gi0EcFBe43s1rZUXx1as0c6E92ylv
         mkThpZ7fIsqm+70u64brjn3sgu+NbQDShSHkCFhyI+SiLFittQKvnPVKsPXoxoavfUF0
         qvsZYychCQlMXjaKB1QvsY1KRkl4iytIfnUa2HjlM0bwqezJa0KQ676e8G8wYubTjN8Z
         c2dXQJyOEQ1hfLCcTTQouYbzofcY3v9vrgyrL1WCcv2QVd66yliNddp6vKblVGZ0ZsPq
         z71OUkOnCPXDY9NqqikzQ77E5GQT4O2pXJjeSQElt+Z5wEiyi951olWvwcuLKhfwcj0T
         zFmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NCqrZTG2fIv6akK/K0AV+ocFDdqFhlfj5q/crQnuPtc=;
        b=lRisUKyqftY1feE305GQ39m/rJa0GpRym47ufsCFiQKEj5mSEmpr8VJaBay7uEbBIv
         9662cCoi4wCUmEyHZHcvABqC1GolVnkZXsKEZNvknIVTyFfAu0gIJe3VAWrRBp853oIZ
         JzsEtYtAvPmQTFXo2j3DpOgQc9ZM/e5/wcI940j/WmwLAOvcwHas5JgeM9B9jduWR2su
         U1jj1EUupTzhR43lZL6hMvPRdnI73bIFmZhZ2Fl75ZZa6gRTsU4EwXHzXBnK3bNoqJw6
         1JZgMiL7v0mA9hF8MSzP5flhUlvKlp1goVelJ61Z0I/xHLlWtVrtFCrqf3xMtgOf7hPH
         6gkw==
X-Gm-Message-State: ANhLgQ1AvtbGbL1crN/oEKlnjAg5g+3fKX9mQJsuHE72UkiVAFkTK9u/
        FFUJRN2f+H96oi9q+7L0rvh9CNZGilQ=
X-Google-Smtp-Source: ADFU+vv3K46yerfU2X7TnJ5dCETSN4b42o/54Jzdl0cdo1oHXROn1iPoR8RcaEgBXYekSD5+JXUj9w==
X-Received: by 2002:a63:5ec6:: with SMTP id s189mr19482499pgb.374.1585674878024;
        Tue, 31 Mar 2020 10:14:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 144sm12102582pgd.29.2020.03.31.10.14.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 10:14:37 -0700 (PDT)
Message-ID: <5e837a7d.1c69fb81.fc9c0.5ac6@mx.google.com>
Date:   Tue, 31 Mar 2020 10:14:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.174-131-g234ce78cac23
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 124 boots: 3 failed,
 117 passed with 2 offline, 2 untried/unknown (v4.14.174-131-g234ce78cac23)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 124 boots: 3 failed, 117 passed with 2 offline=
, 2 untried/unknown (v4.14.174-131-g234ce78cac23)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.174-131-g234ce78cac23/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.174-131-g234ce78cac23/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.174-131-g234ce78cac23
Git Commit: 234ce78cac2388466ad8e70048940d5c1033bece
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 21 SoC families, 18 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 52 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 40 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.14.172-114-g734382e2=
d26e)

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
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
