Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2C31E11FD
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 17:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgEYPnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 11:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgEYPnv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 11:43:51 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4896DC061A0E
        for <stable@vger.kernel.org>; Mon, 25 May 2020 08:43:51 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m7so7611286plt.5
        for <stable@vger.kernel.org>; Mon, 25 May 2020 08:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ClGK3G2AtWmChBAk6lBeHrPAET71N5O+iYRX+SyKA+Y=;
        b=cYpMKBlFYjaCCTfqLaw1XwNVYroGqFSyfRS3SmP6jVekYVy+cgiSmFrDLkl/KI6f27
         XOuhPGPSgjal53ITNoKO/LPyW/MAwBz+31UXFM4t76n/WLOdSkOVif5dIEjTybLXRVIk
         W1+zEypk+K9/sbisCNJcIyIdAIEl0imvQPhkTNvzR6cUF18nOYicJ6pJE1EDE0q7M2J7
         iIEMxETdBIqbUf3O6b/bhmYLfZZXvjQmfJ3LAkSmUeu7/SJpaF1ZWqKYlk7TXIRekkYm
         l2OO4rzklYxHhOWQhMzz7acIoJFIJJqc5o9LAcLzljSeZWvIwjP36Hf34WodbbHzhxha
         wpOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ClGK3G2AtWmChBAk6lBeHrPAET71N5O+iYRX+SyKA+Y=;
        b=O0JeJe6DaUnspxzR41SanHGRgl8L+z+Euyq8br1VCX8drqCSwNDBb9Q93Vlfsc/LhW
         RU6dTFTWt6OeCRNvafW+HqAoT+9VNetP8yV2ZT3un+A22n6Ur+EQp+d3laEzXUK1sBGW
         w63iyRRm7jfWbPB62zYiIYjaG70JNgcHlApxsWugUX+G4IP70R4fk7PT93ihyg4fJdWb
         qSeoFg1gA2FrTziSNRzSII2BUmPa/b4x0Bo+5X8lyylzvd/VwvT6+aJRDrnux6Bld4SI
         3A16KFsc4YeXpT+idU+M1cXWOpiyM7EWvRXxbJ14hDvpjXi4R7IsHN9ZlaaV0tXTbyiT
         iACg==
X-Gm-Message-State: AOAM532Xha7JK/VFsycrtRQnKQ4t/7vnV5YN+c+zKa0ckuLH0t4aYPjY
        f4vq0EOhJamyzLd/K7kuaJuO0XD34qw=
X-Google-Smtp-Source: ABdhPJyCVRMzmzHEpBfpAMRGm011jxeXPQUiNP/uKHrtksZ0ssULdUuIa8szZxXEo0Bk0yEbnuSl7g==
X-Received: by 2002:a17:90b:1101:: with SMTP id gi1mr22324918pjb.117.1590421430461;
        Mon, 25 May 2020 08:43:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b2sm6919350pjw.1.2020.05.25.08.43.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 08:43:49 -0700 (PDT)
Message-ID: <5ecbe7b5.1c69fb81.472ec.334d@mx.google.com>
Date:   Mon, 25 May 2020 08:43:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.42
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y boot: 148 boots: 1 failed,
 137 passed with 7 offline, 3 untried/unknown (v5.4.42)
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
https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kernel/v5.4.42/p=
lan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-5.4.y boot: 148 boots: 1 failed, 137 passed with 7 offline,=
 3 untried/unknown (v5.4.42)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.42/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.42/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.42
Git Commit: 1cdaf895c99d319c0007d0b62818cf85fc4b087f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 95 unique boards, 27 SoC families, 21 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: failing since 6 days (last pass: v5.4.41-2-ged1=
728340b22 - first fail: v5.4.41-148-gcac6eb2794c8)

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v5.4.41-148-gca=
c6eb2794c8)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v5.4.41-148-gca=
c6eb2794c8)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 106 days (last pass: v5.4=
.17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 47 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.41-148-gcac6eb279=
4c8)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
