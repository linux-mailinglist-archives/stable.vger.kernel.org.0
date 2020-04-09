Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 220F71A3B2F
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 22:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgDIUQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 16:16:49 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52423 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbgDIUQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Apr 2020 16:16:48 -0400
Received: by mail-pj1-f67.google.com with SMTP id ng8so1759296pjb.2
        for <stable@vger.kernel.org>; Thu, 09 Apr 2020 13:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ND3yZiXjm4A2FfLP6DZisBTM3Kzd629y6FJwRqFyLuI=;
        b=mnKW6dGXapDgrFT1bQZXD+qxbTjhb3AGXvDQll29ATjWMUfWe+APdQjV0/xyzOcyGv
         NQjASFy/l39ARPivalETg0uv0K6RpVqspVXKgC/7VLFM0uJ4k6e9swpK2wx0/PsMT57Y
         qv5vmLOMI5lKxwW3s78DipW2jlm9HQnDqPq+AKVKhnVnFtlxZAaBjKEGSqsca3/DDDT5
         pR70e5FRBijerRfqRj7FwYm2rDIEP0W05RW4O9s961aCzlCSzQP4Ey2KDDCCejw6qUEl
         kRdj1sR5f675RT+G5anVk8vXXmx9kxewfjQ06mNelov8F+hhH5zvym6/3AkCKlslvVo/
         jJmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ND3yZiXjm4A2FfLP6DZisBTM3Kzd629y6FJwRqFyLuI=;
        b=eEvtFBmSvNvB+8rItgApWcTXEjGlZgQ6XXYx7Qy2+5pnf++q054IMoWo/tfhW7F8JN
         aFtuj4M51VH5XXb0VvuNAHXY+MMiWOSDyFnKR/XLeDWxkwOuxXiSwRgqx9bltVBpXmN/
         zPIwAYqxcp0WNEWTvkaJFVLTnIyAwHMWc4q14EIwnZNH9EcNE/eHgjQ3HF9uvJ5FC7LC
         L6j7QrgNzbsgDyC3sq9p1M3sv9imzRGjmHGozl+gqY1Hwg0qyONEMxlJYTDUrwd4+L9G
         qBSTBIMaDrHhMNNXuyAqX//MZRI4RWh0j3JCZfUNNos3igwz6IdP4ETdGKNkREYPCN92
         guXg==
X-Gm-Message-State: AGi0PubFDAzksbqf0pLPMngD6F62c/k/kK4XVL6KremsvxscVpLcl1IY
        +qvvVLICOJ/VmxERKTHnpprsRdpacrc=
X-Google-Smtp-Source: APiQypJikW7nGQulDLC08o410RLN1OdQINe365405NtrX5CuPNduT9tP8WrFN6IRSg6YJyoWj0dpYQ==
X-Received: by 2002:a17:90a:33e5:: with SMTP id n92mr1350861pjb.39.1586463407698;
        Thu, 09 Apr 2020 13:16:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u3sm25580pjy.9.2020.04.09.13.16.46
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 13:16:46 -0700 (PDT)
Message-ID: <5e8f82ae.1c69fb81.b70c4.012c@mx.google.com>
Date:   Thu, 09 Apr 2020 13:16:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.175-21-g4ff8bc9964b1
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 132 boots: 4 failed,
 121 passed with 2 offline, 5 untried/unknown (v4.14.175-21-g4ff8bc9964b1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 132 boots: 4 failed, 121 passed with 2 offline=
, 5 untried/unknown (v4.14.175-21-g4ff8bc9964b1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.175-21-g4ff8bc9964b1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.175-21-g4ff8bc9964b1/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.175-21-g4ff8bc9964b1
Git Commit: 4ff8bc9964b14e339a424e2ce1c092a94b17a317
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 61 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 49 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.175-16-g34f2709a=
5c8d)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

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
