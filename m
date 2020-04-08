Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD191A1923
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 02:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgDHAKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 20:10:42 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:39219 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgDHAKm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 20:10:42 -0400
Received: by mail-pj1-f68.google.com with SMTP id z3so431275pjr.4
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 17:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+kRNsI1CRfjSqG6p3dccojwhxGFScUzxmHkf7qqLnN4=;
        b=SbOhOqWfjUnqBpR55b9HBzDLE/S69wSvpTokai+5l2s3bQPNpy4M8WJr8Myr7x3FQT
         TB5esZEHyAxdbJy3dhA+JK57XdtNGVpKVomGJKIEydHkxTenxSxfkpLaOVebEqwOG6GU
         eOo7ra2YPvWlUV0zVJWZqtRYAxpM17aPdzY+T/RQ6cvwc7SawI5aDKXK69kyR1aurRTP
         7LfXgWcZ/1UXLe+wSb9DKRZ67lBdEcoMSshyDOKYbOxlNudjbfzGZA0HcRT5loPYIS9q
         dwpFkaSyz65/fiLIB9nkDxXy1Ge+uSI8AXKXy3ZN/nDzT9g7HhCc1IwYT3jeb6dOxQMC
         XKIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+kRNsI1CRfjSqG6p3dccojwhxGFScUzxmHkf7qqLnN4=;
        b=UCmF1QEt2intuR58i9CHf45N9/3H0ZosXqcNCruPRAEEdAux2Z/H/pLxE4/hZehROK
         OE89jRdF2TWI1ULSzB6fqlPNbL+KHmbRxm/bGztRlqdYAlz/iIumRpe3b3NR4xRs+X+X
         ocElnQ3Z49bpW8B0pmFmjqnU1wwzzCA/u2VaBCQP86z8Jf3Sh7HHPaqITBMbxejqb4ge
         djQ6++NUuqZJ/KWSCTPueo4pw6nncgKmLo2vOgvNSPhqjEQQaKnwt7ZUcLy2JZcaTglt
         NJ7abM/qBZL4TPYzcoeKC5cNF0PU6JYcoDK3jNMGKpP5PDOqtWr//Pv5FHvnnNGdezga
         BSjw==
X-Gm-Message-State: AGi0PuZzd7W9JBxi8yuhNYQH/UUBfRfF+1nFgRi203bduptT6ZERKX4Z
        M/pyw7ggnquEoNWv3jm3F1blXhSYJb8=
X-Google-Smtp-Source: APiQypIMFSS+buM5VpBJGBe7AEzJZC70r4pZvqDz7fTaS9xGAcTWz4Tbf61w+yKKF97mvr+Emg/P7Q==
X-Received: by 2002:a17:90a:240e:: with SMTP id h14mr2058716pje.5.1586304641535;
        Tue, 07 Apr 2020 17:10:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i14sm14176488pgh.47.2020.04.07.17.10.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 17:10:40 -0700 (PDT)
Message-ID: <5e8d1680.1c69fb81.3a450.f845@mx.google.com>
Date:   Tue, 07 Apr 2020 17:10:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.114-29-g4b947bfa2cba
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 145 boots: 1 failed,
 136 passed with 3 offline, 5 untried/unknown (v4.19.114-29-g4b947bfa2cba)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 145 boots: 1 failed, 136 passed with 3 offline=
, 5 untried/unknown (v4.19.114-29-g4b947bfa2cba)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.114-29-g4b947bfa2cba/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.114-29-g4b947bfa2cba/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.114-29-g4b947bfa2cba
Git Commit: 4b947bfa2cbae18c6fe052e9ca43c83f567fde2e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 84 unique boards, 22 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 59 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 25 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.114-25-g1afec3f9=
643a)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.114-25-g1=
afec3f9643a)

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

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
