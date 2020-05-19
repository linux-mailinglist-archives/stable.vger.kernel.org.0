Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857541D923F
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 10:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgESIlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 04:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgESIlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 04:41:20 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93A2C061A0C
        for <stable@vger.kernel.org>; Tue, 19 May 2020 01:41:20 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z26so6074936pfk.12
        for <stable@vger.kernel.org>; Tue, 19 May 2020 01:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uruF/HgUZV002ZMJ4fLEEAIqKW4UtPrd/n9Zf07buxU=;
        b=RHOsnYFSDrEZU3MTcagtgz5uxsiNv2Bhcbi/k7lvUNhkRXp7zkQLJbyHHgQdUDlmlk
         CDJCNm76HqHzmoN8Vw3qnEfFAxPDvrIplCq89nFYsRNjSjUPlA7Q6JbK1BRGEMOfJYAC
         TEzrGYI3ijjOF6cZCnQOC6FsdT7DVp6kHExI0aCawLCaDDO4HOExvf5WFKJVTvvHxkHB
         azeDCqZLYHBAPYSUlckr1TDe6CofojhSGXW9Bbn57aq4qLeM8+Bon4bAUREFVawr+15I
         hctTJ24+Tx/SXGKtoUlRNGkwjRx+aW1zHo0jpG+42wn/qIBv2qw/tqDNgJLOCuIZQxZe
         15ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uruF/HgUZV002ZMJ4fLEEAIqKW4UtPrd/n9Zf07buxU=;
        b=RXCw8yzVvG2iS4TU1JI/M2U/Sl8C4FK54ISc4XY0DQ1XJoHgw1J0nnucRK8uYXCa81
         JIStUllFYbg3cxO6sayg5Hp0MwQTby2vfbkH8w8FUkfPTWzcAQ0YWtRD4aOggl+kC4Zu
         1XwNFjQ//MdML6aFAZ7gctv7JDKDWZo2iy3LzMQgvrv2pYizRYSp4lGhYn4ssgH+7VjJ
         MEMPn/tV6IIdWnRmUqXvZBThW2vVsI8KIBl7eXmfT+mgROlghsDTaxG/4VshPUWWe9NW
         bbJTXUcb6McH0xJ9RIaOS4MLagfkb0FeEH8F3u59TQ9E9eTQfn7LLx8yDX/6Cg6p7SEq
         QAyg==
X-Gm-Message-State: AOAM532Mxmdr1RdzK+mN4VjwHqhveyBK3ETpJyZc0AcWZPwcpoJn/iQB
        xljuy3ueK4LyPsnFPvt9h32UIOSj5p4=
X-Google-Smtp-Source: ABdhPJw0SNgP1uRpbHS8Enmqa2pb/hPOxVL6lEDW2IxYrDDciWk3burHeVv7kCYFSo/3lOJkdBwQxw==
X-Received: by 2002:a63:7f09:: with SMTP id a9mr13076684pgd.400.1589877679970;
        Tue, 19 May 2020 01:41:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e16sm9561714pgg.8.2020.05.19.01.41.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 01:41:18 -0700 (PDT)
Message-ID: <5ec39bae.1c69fb81.18578.9ade@mx.google.com>
Date:   Tue, 19 May 2020 01:41:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.13-195-g4dae52cee3fd
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.6.y
Subject: stable-rc/linux-5.6.y boot: 158 boots: 3 failed,
 145 passed with 5 offline, 5 untried/unknown (v5.6.13-195-g4dae52cee3fd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

******************************************
* WARNING: Boot tests are now deprecated *
******************************************

As kernelci.org is expanding its functional testing capabilities, the conce=
pt
of boot testing is now deprecated.  Boot results are scheduled to be droppe=
d on
*5th June 2020*.  The full schedule for boot tests deprecation is available=
 on
this GitHub issue: https://github.com/kernelci/kernelci-backend/issues/238

The new equivalent is the *baseline* test suite which also runs sanity chec=
ks
using dmesg and bootrr: https://github.com/kernelci/bootrr

See the *baseline results for this kernel revision* on this page:
https://kernelci.org/test/job/stable-rc/branch/linux-5.6.y/kernel/v5.6.13-1=
95-g4dae52cee3fd/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-5.6.y boot: 158 boots: 3 failed, 145 passed with 5 offline,=
 5 untried/unknown (v5.6.13-195-g4dae52cee3fd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.13-195-g4dae52cee3fd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.13-195-g4dae52cee3fd/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.13-195-g4dae52cee3fd
Git Commit: 4dae52cee3fdd5c174027f69eb44c1876f8837ce
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 100 unique boards, 26 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos5422-odroidxu3:
              lab-collabora: new failure (last pass: v5.6.13)

    multi_v7_defconfig:
        gcc-8:
          sun8i-a83t-bananapi-m3:
              lab-clabbe: new failure (last pass: v5.6.13)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.6.13)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos5422-odroidxu3: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
