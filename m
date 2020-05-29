Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3821E73A8
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 05:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436688AbgE2Dfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 23:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436574AbgE2Dfh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 23:35:37 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1DEC08C5C6
        for <stable@vger.kernel.org>; Thu, 28 May 2020 20:35:36 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id bh7so479957plb.11
        for <stable@vger.kernel.org>; Thu, 28 May 2020 20:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1rZ/RarZyY/SyP35F8MQqG2sfF41umU4eOg9obtWa4E=;
        b=juv/BejboplEzBTC5E/BMEznlYGo5IOYSByMP1mZWjExfUwv0gWmUQT5CEj9gCWV7F
         Do41JNhJ/FhpBCNVhTUgN33KT8R4MAsOmk3q+QAvbg3JsiR1z+KOlO6lrt5qWvjhTg1T
         PPfHcpUNG6K0IHagqn+KK5+Kshb9d/FSgs1vZ76PE6R2qj+1WCFAv84HG5LbWx+YEbAO
         /qnFBbJQghw/3hSWwk5mZ3viXMy6LN8iVkeHQL3zDqNgwq22ovVAQAZbeiflVAmnGJbS
         o3ASszylnmtpGoYKIXxcQ7Z3kv7fS+srsuiLi43FOhR5wdczjtkq6OilAVV3EkllXqAT
         tQkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1rZ/RarZyY/SyP35F8MQqG2sfF41umU4eOg9obtWa4E=;
        b=sLgkBtDxhwJG3eTN61eQKGGQL+C6om1RE9txZfCEJcowndvw+IuTvow6TT20vYe7fB
         zYJkFX4cUfK3Yx9c5LviyCZMmzxUrhlBc+308emuXO4yJzW3+TuDM9gvMqseNHKMQxp7
         oh3zKMJWqQ2nI071b91YOr3wtfx13D8FPF2y8RDZ7zRcpRDlVRLr4P31yIqf5ZM89/Oy
         sjIyHtgheK65fyWXdDPqdBKk6OCrSGJGm+KFGxit488kaee6STfoDTuUWJnx+mTcmyFY
         DwoCVhHG/dmq7UQbQdTq2JaQWR94jAMTQK62/o57ROaiGdzysiigZ/IfZqKHRKzhmean
         ElzA==
X-Gm-Message-State: AOAM532ATvUqsOrgMiqUbPFekhesP6EFmBWRY32c9GvHpLdqmlbSiHfN
        1zM0A2uG7afGim2ESTSJDvxDqPIYApY=
X-Google-Smtp-Source: ABdhPJyJHu0bAN6pZbKs57rRmBJdIeq9/VJLZ+ubISP7tJ59MRIHB56e6TyqTAevL59g+AR+63XcMw==
X-Received: by 2002:a17:902:525:: with SMTP id 34mr6757897plf.289.1590723335644;
        Thu, 28 May 2020 20:35:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jx10sm6273825pjb.46.2020.05.28.20.35.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 20:35:34 -0700 (PDT)
Message-ID: <5ed08306.1c69fb81.9c15c.525e@mx.google.com>
Date:   Thu, 28 May 2020 20:35:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.4.43
Subject: stable-rc/linux-5.4.y boot: 138 boots: 2 failed,
 125 passed with 8 offline, 3 untried/unknown (v5.4.43)
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
https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kernel/v5.4.43/p=
lan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-5.4.y boot: 138 boots: 2 failed, 125 passed with 8 offline,=
 3 untried/unknown (v5.4.43)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.43/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.43/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.43
Git Commit: e0d81ce760044efd3f26004aa32821c34968512a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 96 unique boards, 26 SoC families, 16 builds out of 163

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: failing since 2 days (last pass: v5.4.42 - firs=
t fail: v5.4.42-105-g3cb79944b65a)

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v5.4.42-112-g00=
dd3347ad64)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v5.4.42-112-g00=
dd3347ad64)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 110 days (last pass: v5.4=
.17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 51 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

riscv:

    defconfig:
        gcc-8:
          sifive_fu540:
              lab-baylibre-seattle: new failure (last pass: v5.4.42-112-g00=
dd3347ad64)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxm-nexbox-a1: 1 offline lab

riscv:

    defconfig:
        gcc-8
            sifive_fu540: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
