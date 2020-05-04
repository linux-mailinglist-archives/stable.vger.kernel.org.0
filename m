Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24E11C4945
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 23:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgEDV4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 17:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726334AbgEDV4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 17:56:00 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5647AC061A0E
        for <stable@vger.kernel.org>; Mon,  4 May 2020 14:56:00 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id h11so321037plr.11
        for <stable@vger.kernel.org>; Mon, 04 May 2020 14:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RnwNTAGeNMUDj4I+9VfZnHbjUXx1ha6n9WvQxdyTBQg=;
        b=1YeERAT6ZEeEGKaqHMiqUUBW9deFUS7GTDrvpbWuGFOApNi7LpZXJO7IjHTIiUlZxx
         z55rKk0xUcxm6w9Tplh/Mohb0i/DVyJbZdI8mUXcscp3HdGfjsh3ab8ZCdY0AwXGqtzR
         olJxJogyy5IfKNA2RAWWH4wzLVRFPE/b1WY5f/F9wtJJuDD/+d1dT5EAGJSMas14DS/F
         D3GUCwtGaMC9oDt4qFnkxPajGZj2MJbWZGd0ifnGnfnfHUN2nLcNDi0VkMJs77nJ4Je7
         AJyEpeqGdljug8nL1WMFCMeujkigwk4MhTHHU7I68ZqQ8H1EQMZatm7JCaC2gS45fAxx
         wyqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RnwNTAGeNMUDj4I+9VfZnHbjUXx1ha6n9WvQxdyTBQg=;
        b=A1SQm18RLuUJsgXUUMKcnLBymMfK0lqzMwPv1/ljZ6NJhU8MPw+hdk8m3x1XcbA+Iz
         UWKzuSuAzujlWi8R8xbJ94d4+tRKXusPz6wF4XVoOkf6hcIYO08UZ38zISAkTWTlAUGJ
         Mjt72MaLF6G5ozgPzAqVz6IIR4P6dIFAkUp/FR/faJQ1rfu9xU6770sZ2fhBVZ1w9woq
         i/jwsbbc2nT3HJTgalxnkKzTcOqeiTj08Eb50wYEciKcMTaIqitojiAR9hEq5niLlFCs
         AsHJnYVUbj8Ko5loNMMY4O2mKdbBYWE3mGK84lzD0McMxn/G0pL3ymed7FqMgUbiU5qO
         qRNQ==
X-Gm-Message-State: AGi0PuaxtBwegngR2jkN76X45M4G6hLSVcsPatkwSEVkTAqwWc5eBF+D
        koq7AdOglS2t0IYP4cStDrSajgTPEMg=
X-Google-Smtp-Source: APiQypLO6tu5VyHmfM95/tgUJxWpkvFs9vSV4+EeriRUThr1skzi4bv9Gv01d+56SRIQsA9o4DMPIQ==
X-Received: by 2002:a17:902:7444:: with SMTP id e4mr39323plt.258.1588629359454;
        Mon, 04 May 2020 14:55:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l6sm49320pfl.128.2020.05.04.14.55.58
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 14:55:58 -0700 (PDT)
Message-ID: <5eb08f6e.1c69fb81.4b727.034b@mx.google.com>
Date:   Mon, 04 May 2020 14:55:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.221-19-g2f5149253281
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 91 boots: 4 failed,
 79 passed with 4 offline, 4 untried/unknown (v4.4.221-19-g2f5149253281)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 91 boots: 4 failed, 79 passed with 4 offline, 4=
 untried/unknown (v4.4.221-19-g2f5149253281)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.221-19-g2f5149253281/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.221-19-g2f5149253281/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.221-19-g2f5149253281
Git Commit: 2f5149253281f474194117c5fa97972cf76c84ce
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 17 SoC families, 16 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 86 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

Boot Failures Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 2 failed labs

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
