Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28BA61939B1
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 08:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgCZHmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 03:42:06 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38002 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgCZHmG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 03:42:06 -0400
Received: by mail-pl1-f195.google.com with SMTP id w3so1821115plz.5
        for <stable@vger.kernel.org>; Thu, 26 Mar 2020 00:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cUXq9Y8/qNmzo8SjDEuBk4U9JU6zu/VPWR6lszkl8Ic=;
        b=G5vdEqT/DcvBeZ8X0zqyThmu27W/9UjZHaA2n/4FkyfnSaTPmMe6J5lug55JhFV6yk
         MRjul5vjWgfOHszqlcwoAGH2xhSwK9SViu1wkP1wLxUtkyG4h6LmX0y1m7wKrXuoK2b4
         zH4akbZPU3W/PD5XU612KfomipOfNjAkxPMJPAI1pjqHRMF0p5L4Vx0KfqEL1J/fydFn
         u5fetVTophGUbP3Ztz/zZpU5EH2EJOe3JlYw64COP/n45HylS49sKjeuwVYMQnbJz7xE
         F4gc7+vQ/y6YWfuUkDXMYNNdn8anBXU9mJycs6lk+h7qYi1Ow9Aw/cR7TXmgVwllwW0h
         ntAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cUXq9Y8/qNmzo8SjDEuBk4U9JU6zu/VPWR6lszkl8Ic=;
        b=Ih3yln3glnjeDm4AtMSFoJTyT7NEJbr1dX7pkLIud8xG/1WHwk4jKRLNpBg5Jfx8Zz
         78KrPXCbkYmRHMTQFjt8aImWKbGXx7ZMElJFjdMzcxaa62vqm20odGe0hdXZPA/YbN6r
         0TmKkY2PmZxjBrHdwdRz3oj2ruD626Dy9ONCvQW5WSQFYjbjaLPvw2BBaji+LqwEBtTL
         3HBt2E+z1vlR/42qbjcNk9kwledgR9A63sQ+7Vw4+2iO6BdfRI334Sccg8ofpCe4M0/e
         gXrOMi+rrzJN7XU9VNC064wqLtTNXxW5V4fzqhGffTmeJzgB+RWly7KzA+W71gi3nNft
         Ajyw==
X-Gm-Message-State: ANhLgQ0e4EWh9/39gZ9I3sTpIJEB3hcshE+/x1Qjs5pSomxZALIy4YV9
        cILSMR1LAdlCk1zTU852EWoMixsNbbQ=
X-Google-Smtp-Source: ADFU+vucGPSsSjMCxb0JveNZzQu7AD8QRjGHFk8T4WJlbYrPIhieXgqsxY6x3Uns2HyY8l03DQrmEw==
X-Received: by 2002:a17:902:8b8a:: with SMTP id ay10mr7075887plb.288.1585208523118;
        Thu, 26 Mar 2020 00:42:03 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 1sm996961pjc.32.2020.03.26.00.42.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 00:42:02 -0700 (PDT)
Message-ID: <5e7c5cca.1c69fb81.129ff.4497@mx.google.com>
Date:   Thu, 26 Mar 2020 00:42:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.217
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 95 boots: 3 failed,
 86 passed with 2 offline, 4 untried/unknown (v4.4.217)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 95 boots: 3 failed, 86 passed with 2 offline, 4=
 untried/unknown (v4.4.217)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.217/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.217/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.217
Git Commit: 3b41c631678a15390920ffc1e72470e83db73ac8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 18 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 46 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: new failure (last pass: v4.4.216-127-g955137020=
949)

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

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
