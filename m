Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A509A3E1
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 01:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfHVXgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 19:36:24 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45185 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfHVXgY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 19:36:24 -0400
Received: by mail-wr1-f66.google.com with SMTP id q12so6906379wrj.12
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 16:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+rOw6KzzhIZ31rHyzDWILDLYKcUANpJvv690xQAsLvs=;
        b=DBwFrlypJz6/D9L25QEIy1jYQn73b+G3FkNgvP6a521eiCRFWR9oZNtVK1tyt2qngh
         kBCXv3qgVc0w72XbfkfzSjDHKc8oFdAP08c7kNFz4oGhgwNv7v8iLC4UVVS1ewM7mCIN
         Nsl6RPgIuvRDbb7j0/SY3s+YGfl4s/OM+JzE5KmZ77TU2rQMu/0zuGhWosAY8pSdeg31
         xWWEXmKlFV5oZfuQ06l1rgUPW6Oe2souI/P9zJzPoq6G4FOw08Jp9DqjRrh2dYrNSfGz
         ZOvJ8wua7+KrDH2sw3GCZZGjbEYJotX39zapTcWG6iZfkYVBnbieORs5a9RNEq1WNX/d
         zTjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+rOw6KzzhIZ31rHyzDWILDLYKcUANpJvv690xQAsLvs=;
        b=LhOVgVwn5qIm0WYqPl/mbYz6MIX95RsUpNdaKAIpw0IlSJabeshnZrGuwK0eFkY58p
         9SVLskMsg7I6bsjgj61N4EoJZeug7dSHl0ZXkjSSzGVvBObj2r5Usd+XNH8zxCsHV225
         OcMFbPoSf4vpJDIK1tzePasNgs8qW7CEScPoji1OZWKhEnv8KUoIgXeU0Wwh3MSeLAUc
         tWe92WC4TO9bGf+kA3wAhzPq2tZ+YffKFwOhgRb60Ib7+aCD2aAAbkIFugizQGK8ba0V
         KJuaCy/qpNo/Tob5yU4KLAf5p2c8sRGU4FON3sdK5WMVVOFNrx+lKvl4J+UAXUKRhKlD
         chRw==
X-Gm-Message-State: APjAAAWuOj0qC579M7HQEqCKawvXTPt3OOaHK+ELh4HyXpP24pkmVRte
        q1fEv66ad3RFXwqo0Guf2CSp8xcx+o5tjA==
X-Google-Smtp-Source: APXvYqzqrpmVAsGbTTP0LVh/8qtuGNSYiAvEm5pFGoGjt4Te/YAWDk9/VuhqVGKiCHLOGEgkItLPpg==
X-Received: by 2002:adf:e74c:: with SMTP id c12mr1234731wrn.173.1566516981888;
        Thu, 22 Aug 2019 16:36:21 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j20sm2831391wre.65.2019.08.22.16.36.20
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 16:36:21 -0700 (PDT)
Message-ID: <5d5f26f5.1c69fb81.901b6.da40@mx.google.com>
Date:   Thu, 22 Aug 2019 16:36:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.139-72-gc62e7b28b99c
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 128 boots: 1 failed,
 117 passed with 9 offline, 1 untried/unknown (v4.14.139-72-gc62e7b28b99c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 128 boots: 1 failed, 117 passed with 9 offline=
, 1 untried/unknown (v4.14.139-72-gc62e7b28b99c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.139-72-gc62e7b28b99c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.139-72-gc62e7b28b99c/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.139-72-gc62e7b28b99c
Git Commit: c62e7b28b99c68e465814b56bc02089022f90fc1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 25 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 8 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 8 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
