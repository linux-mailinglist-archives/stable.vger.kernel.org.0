Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D641EB2AB
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 02:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725804AbgFBAXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 20:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgFBAXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 20:23:44 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6644C061A0E
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 17:23:43 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id n9so612851plk.1
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 17:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Hk5mMNgOZdhCCY02pS5uXeaGLXV/CNfHYOAtuiCcj+c=;
        b=nSTxAfuGsEwvjlXq4stEkYK3CK89g0RjFXrD5tatrf/ixSL86+OVQ5WC/MozBQyqp+
         1tsNSQ2srt1E4ubgfFeXI1fipJS0taPMWTjuXJILEUtwziX3HriGoO5tADq/Oam7ZWF9
         xZ5odHz8JcBUXQk7vo6y43D17fRFhy73ewZopIXc9+ydFoqUwa0M/IM7Tn8b1hFXBMio
         rbgOMZCkiWkdg7V2W3fvPJ+VHOP25Suc08310vTLSA96krMcNODjsPYv3pAA1EQRByUk
         HvbDqA/Hvt64/7RBC1Nw685hVmbIR1mQsngECyzwwiDzpppFrMxInOOhn9iPxhLecpSa
         HjCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Hk5mMNgOZdhCCY02pS5uXeaGLXV/CNfHYOAtuiCcj+c=;
        b=JGH6mlZmw0OX8oaxxhZwAkxW78B354dnUTIQaVkqGJXzE51qdYR49n72xG9w7gZJWP
         KKb5fYc6cZp4EmHwxg9Y4WYeHq8wOf+pi5rvKaTKA8p9zbLGxUakMrjbWsl1Rr4WhCrl
         BGu+kaPqjjFKs0fSpF9tnt3Gfcc+/dlSXZASziXxGQFUzfp+OrdSTU6CJJVyqCW/QpoH
         ESAJh4E4nLoRma15AGjfwXieBUj8ufYhqae46OUQv4jHKztsE2JnaQLkJdgPoizB3E5v
         sYpf6JKJZp5wKGjW3YfDLBrdzEOn6//z9i1WF+n11dZwsVA3sjwSvLgWJpovcyZJGZw6
         l+eQ==
X-Gm-Message-State: AOAM533Hw09m7QDGVPLDI2VY35EFpInZXtTX9jKyblQ3Oq9wI39yAzHC
        QTb4idIToR2624qZLwoeWu2xSCRGKTI=
X-Google-Smtp-Source: ABdhPJxEE9n7pYdbpC7EuAB2FaI4yQ5Q0duJqXlu/tU0aqakgWtvcWLgmQ6KtnjRTmcO/53yOjtBew==
X-Received: by 2002:a17:902:b68f:: with SMTP id c15mr23077994pls.303.1591057422870;
        Mon, 01 Jun 2020 17:23:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t201sm507082pfc.104.2020.06.01.17.23.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 17:23:42 -0700 (PDT)
Message-ID: <5ed59c0e.1c69fb81.a4719.22c7@mx.google.com>
Date:   Mon, 01 Jun 2020 17:23:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.225-49-gdc230329b026
Subject: stable-rc/linux-4.4.y boot: 88 boots: 5 failed,
 75 passed with 3 offline, 4 untried/unknown,
 1 conflict (v4.4.225-49-gdc230329b026)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kernel/v4.4.225-=
49-gdc230329b026/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.4.y boot: 88 boots: 5 failed, 75 passed with 3 offline, 4=
 untried/unknown, 1 conflict (v4.4.225-49-gdc230329b026)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.225-49-gdc230329b026/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.225-49-gdc230329b026/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.225-49-gdc230329b026
Git Commit: dc230329b026cacfc8ecbb46f6f25630bb09388e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 18 SoC families, 16 builds out of 150

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.4.225-39-g04192ccac1=
74)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 67 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

Boot Failures Detected:

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    mxs_defconfig:
        gcc-8:
            imx28-duckbill: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
