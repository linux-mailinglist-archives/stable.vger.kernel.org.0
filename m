Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 587EF1842F7
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 09:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgCMIyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 04:54:16 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43679 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgCMIyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 04:54:16 -0400
Received: by mail-pg1-f195.google.com with SMTP id u12so4594589pgb.10
        for <stable@vger.kernel.org>; Fri, 13 Mar 2020 01:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dDX075QRBwsZaBZfOOGiNgs4j3PRQWyaVaHFWbp4/FA=;
        b=AoQSGa9KSntHOfpXS8+ew7D2tjEJxWPM81yfBXtSE1N3rOjgrx1pGdEpaG+ZmI1V9u
         ghyuTwd2kiNQ04nPgLhFzZdt2HVfsEgxA+oeV9KQF2zxKfE828qdZcOqGScFcYQGw6yd
         1lDPWph1g8mf4K+gB06xyUmI6fgmXBK5+OYCDAdc0aNsVMxcMyxofa0m7xrczf3SKIl9
         EEhzFixvJ2aXqCyHhL7ioeiTv5F/dAFR1lEktXPAw+3JmKJ0nHmx01dbkqF7/w6NxVW6
         sSPTQZs/tdrxMv0uYv9wZW4NhQmfs6W5jmjhu8KjpyPhB7nUNWdC+EdqfRIez8ELq2HM
         0+fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dDX075QRBwsZaBZfOOGiNgs4j3PRQWyaVaHFWbp4/FA=;
        b=OEQ9miRwQFiMPjbVKUuk62YvfyWPZZplLB+kz+k9ru6nXnKqx18lEqlP9NW3Wrjmux
         31fmGBYP5RgeLUyvTBBQkaZ7CYGxzcMj8nJJDK0VPWgq8c2U65RHlWHmT5I8HycsQ5R1
         xpMgj+plcRhXJsaZMdfBpmKfheLaZF0/MmSQYIqWQF/rh6mG234NqnyQwWVtv7/nqqqv
         lH0ko24POAF6B5kUCF4gKVd46XEta9yMNETdBf2iVGWDmc01tvJ9Mss/LkB8UYRilU6p
         S6NytK9L5S7W3yNQp45zi6AvnvGr6YLOzacU1cr/l76Y/dNuXat24kRO54MP9qQTOwsS
         X/ug==
X-Gm-Message-State: ANhLgQ2Bnc2cVeI+btcvq2CSsZjlB9CTgIadeKxD5KeFetePBzEuzaHO
        NbAhjzhb0HgGbeEeVpv2kutYZADURiU=
X-Google-Smtp-Source: ADFU+vs0H36S5N9WfwTjTNpRBUsVpOC7n6zXhC5+A/k48x461goUr1cyeDu4SK9ys4acf4EL3Kvsnw==
X-Received: by 2002:a63:2166:: with SMTP id s38mr11383154pgm.83.1584089654931;
        Fri, 13 Mar 2020 01:54:14 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id my6sm12461549pjb.10.2020.03.13.01.54.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 01:54:13 -0700 (PDT)
Message-ID: <5e6b4a35.1c69fb81.a1ae0.748c@mx.google.com>
Date:   Fri, 13 Mar 2020 01:54:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.216
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 72 boots: 3 failed,
 66 passed with 2 offline, 1 untried/unknown (v4.9.216)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 72 boots: 3 failed, 66 passed with 2 offline, 1=
 untried/unknown (v4.9.216)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.216/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.216/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.216
Git Commit: 19c646f01e4ace1e5e5b3de2749de25bc86b79a1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 18 SoC families, 17 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 33 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 28 days (last pass: v4.9.=
213-96-gdf211f742718 - first fail: v4.9.213-117-g41f2460abb3e)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.215-89-g823586b24=
f36)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
