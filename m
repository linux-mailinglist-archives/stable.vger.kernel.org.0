Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7A517860A
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 23:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgCCW6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 17:58:00 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39073 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbgCCW6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 17:58:00 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so88847plp.6
        for <stable@vger.kernel.org>; Tue, 03 Mar 2020 14:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FN8niwMmRJvIOhlmvhvyS8ih8b2umUBCAE+J33BPy6Y=;
        b=bRunBcMN/nOs86JDYCJNzS/daMCXaHYiUrzPypiDb9cGerEI+FwIJslYX73dWJXJpb
         0ihRqpSvYHks/C6fPOl++ZPiw62/T5PNv3D6gmZ/ZyeZztEI9lYVj1nhYXlk1AX9Vpk1
         LOwsIsOrycdXK9EgjZmNSVg1tp6RPYBzJF2Asvo1Bhlh6oLpTFqE+jstmzMZvLuRHSs8
         OJ3eB6BqnB7FoztaEJIwhPfd9K5pET+2lpNy17msPDCw7XJZu3De7XKE+/6aIgnme+iD
         wCVcyxb7quyyTOYR0TH/vRmEU2WrPAXqnbTnRraKpfuQet5hfnmTsr/4h/gm/xoF7EvF
         xSjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FN8niwMmRJvIOhlmvhvyS8ih8b2umUBCAE+J33BPy6Y=;
        b=YCjK04AR1E3pdAu3nxZhe64ncBkzcEFRTY699IWIv+AlcziTj3xfnUakqVyxmxp+Yr
         jn8vgW5dDgKoVl+IsvcKAKigJ/MsdliOo1zmyYSZJzv8VL+bbjFQ8O/brssbUhaT6IVp
         iM7iynCpH4aSbP6cVRgVDe/lS1OFxGZlwu819Ti7W3Nrev21gKM2Z4UxqGV4aHpK1djY
         zmk9V1GTMaJkGHcEAGQ1E6sNsHGtyI93GvbNfFlzsYQ/NxRMBLZX63j4SvvAN9lTIecl
         6Xvra22cbmhed4SVrBm2dyj4h1fRpCYNQyIv4IsEA93nSlZie9UgW4V0ndue/LpK+ERe
         4UfQ==
X-Gm-Message-State: ANhLgQ1ap9ToBYZ0Wr08QYZToL4RnelyneWJZQzowR510nSCukQq9mpp
        VhZ25St0hTgpjwDgco/tI/tRJX1a0rw=
X-Google-Smtp-Source: ADFU+vsPNzUj+V2wDPgjqk6KSnn1Mx5KZZtOlB//8ucWqfYwTrPauTF6MEvkQ2+teqm9FXvP0eDSrw==
X-Received: by 2002:a17:90b:8c9:: with SMTP id ds9mr379593pjb.11.1583276279246;
        Tue, 03 Mar 2020 14:57:59 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e12sm10072194pff.168.2020.03.03.14.57.58
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 14:57:58 -0800 (PST)
Message-ID: <5e5ee0f6.1c69fb81.7a7c6.c374@mx.google.com>
Date:   Tue, 03 Mar 2020 14:57:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.172-62-g8de1005e3cf5
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 49 boots: 2 failed,
 46 passed with 1 untried/unknown (v4.14.172-62-g8de1005e3cf5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 49 boots: 2 failed, 46 passed with 1 untried/u=
nknown (v4.14.172-62-g8de1005e3cf5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.172-62-g8de1005e3cf5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.172-62-g8de1005e3cf5/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.172-62-g8de1005e3cf5
Git Commit: 8de1005e3cf5c96cab4c3820193a0b8a65fa045e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 38 unique boards, 12 SoC families, 12 builds out of 201

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 12 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.172)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
