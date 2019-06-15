Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15E2A471F0
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 21:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725535AbfFOTjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 15:39:32 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:32942 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbfFOTjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 15:39:32 -0400
Received: by mail-wm1-f52.google.com with SMTP id h19so1703018wme.0
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 12:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KMpT903NnMn7WxElbBDBlCFF+p/l4eV0AFkMG+FTso4=;
        b=EKPzHCZ/4DmmjruMS9oxkkuHHBQqAPav4buqazaTJA1iZppSqYJPkRzrFSaJ1NFD8o
         s6gA6Vce/GJdl5mPW8T5q70B/fgaIgL3juE7Azt//Fy2Y7zdWGupSHnvQbwRAsfobZhh
         jUhg+XVurdtkXGIwhKPKDRlR3clDGvHVgpKn0+bfIYTho9tCZ1XDblckcfqb+mNdUP7U
         JdtWBufMM55/K2vH8zczXGSeFPSv87WQ4hsdRkvX7AP1DovZ0j3VyQF0ENXWDc9xEzJH
         DGpRYywDVcO8f0qq8UOhZWT5/OZF9B4ROGG4Yf7DKxd9FQBM196U5IUujI3ArdEC1TK7
         0Uuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KMpT903NnMn7WxElbBDBlCFF+p/l4eV0AFkMG+FTso4=;
        b=tLPYc2zayPIU9ZjWnZYJqKlyRzzIt2NOixrpFbBDFvJSHk8FY2r6cD4Gsw5oAUzfIa
         DwNTATuLR3N/K8rSOzkq7or2ZCApk7j4xPpWX/nfIo1Ae61C2qKV/i+2n94odJD1zO7D
         VejEe34MduCQNlA1KcO2yCzJwrQjBwRaXp+twk9PPBWzzqF0vIWTHkWTpqAvsTvQIWx/
         mhMrR37gznEf+C/7iZdWYBLAOW+CMF7bOzX3Y4dSIUFX5ZNlU5/A5Q6BmWgN5UYS0xQe
         dwJ+kV9HADV8CmXr07EvcKoI5OifM5rCUykYT6P2gm8StjCsfG61WzlwAIG3FSInf8rD
         akwg==
X-Gm-Message-State: APjAAAWS7QURKFKcGuR/F9Bd3sE7JTlYH7/bFP3BbzEWkpheg+GUpZzf
        +mxs38kMUQk2hdcQmo1CDndnifnchbeO3g==
X-Google-Smtp-Source: APXvYqwtIZtU/SsA9hZPsDTmUfghOOJyAOHhEmi5Zk4K5oyiKLj+kf1tjsLWNsZNXHe5rPxk0BieMw==
X-Received: by 2002:a1c:7217:: with SMTP id n23mr12712153wmc.47.1560627569572;
        Sat, 15 Jun 2019 12:39:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l12sm20362261wrb.81.2019.06.15.12.39.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 12:39:29 -0700 (PDT)
Message-ID: <5d054971.1c69fb81.31beb.be01@mx.google.com>
Date:   Sat, 15 Jun 2019 12:39:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.10
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 118 boots: 1 failed,
 101 passed with 16 offline (v5.1.10)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 118 boots: 1 failed, 101 passed with 16 offline=
 (v5.1.10)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.10/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.10/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.10
Git Commit: 7e1bdd68ffeecb9ef476f87b791b61910e8c853c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 24 SoC families, 15 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-axg-s400: 1 offline lab
            meson-g12a-u200: 1 offline lab
            meson-g12a-x96-max: 1 offline lab
            meson-gxl-s905x-libretech-cc: 1 offline lab
            mt7622-rfb1: 1 offline lab

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

---
For more info write to <info@kernelci.org>
