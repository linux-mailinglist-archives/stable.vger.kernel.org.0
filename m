Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D351EB32F
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 04:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbgFBCBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 22:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgFBCBt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 22:01:49 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E819BC061A0E
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 19:01:48 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d66so4319811pfd.6
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 19:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Wm1bnmqhxcnfr746cYQIDKPLi4lrvbs4PHOsoYFUPbE=;
        b=VS0m6tpgpqHEyuPnOOAISGKqp0QaggKxkGtNEVGH73iIkiSxmaXuw4C6+7DFR7bEJl
         TeeVnMW5w3Hla5sO88xMLRGW0koNcx4b+eDS8jE90vbk/ZEv3XnB6gN0tS+EPDSVXbaD
         hRDvAzgQgyR2XwZsKxr2+GuPLBWjuOZh/u6bgkuN48jugezkK60OhGpJbUkHBYuAcCqz
         SDkR3QzkHnwPbvA/FHC48+DJRhuGUM+dki4Tr7BqDuMRRDkc+rTXpPebhP3IUW2R/QIu
         1q+TyVEzVVrFMduAgpxWaQ5z9DGhZymG6cy81RmbuCVrpqKa+1202ODrWAXl09iDV0pR
         SSuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Wm1bnmqhxcnfr746cYQIDKPLi4lrvbs4PHOsoYFUPbE=;
        b=dZWcfQQrGmQM91MO5o2HzhC/DtoivQfGPJuPxfQ3RlRxxo7RpHRnDvcG1HFDnUpyE9
         JPHZG9/I1nR4AcAMZGqh1QuZV67JvI9Cio8jR346WfgcgKOY31s9Os91AHHejO2Dfsje
         ah7McbS+5kEKp4gUGy1PGcB1YsN2L3/udiGTFJdOlx6267BC4sBQeh47zpHD+/hUvsgs
         5R42HOLJqpnk520b2Jsm5YEsShVrfZGXw+qMmRA+jXKoXtcfhCOnbRv6UIBxorIei9tq
         1Ow8xWggmSfYzi4Nf7zLepYm2DTPKKKcMOZOqOVoCGsrStqLDB51Ml5gWfuNEkv3T7Go
         6siQ==
X-Gm-Message-State: AOAM531FQ+9yaA4HAH5uBpDBhjmSAG08xzb4DniNZhLKKH2fF9nJ7Dm7
        tI4JbRkR1H3Tru21jFO2QsM9UiqCx1w=
X-Google-Smtp-Source: ABdhPJyChCNp7eFhqfSYI0Sp29Iu5+1DqnrrxxH7nAdITyEmlA5lE71hpoMF9v/fTdqM2QGz4A/BTQ==
X-Received: by 2002:a63:ab0b:: with SMTP id p11mr20962107pgf.278.1591063307814;
        Mon, 01 Jun 2020 19:01:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p190sm580446pfp.207.2020.06.01.19.01.46
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 19:01:47 -0700 (PDT)
Message-ID: <5ed5b30b.1c69fb81.1ca3f.29fc@mx.google.com>
Date:   Mon, 01 Jun 2020 19:01:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.6.15-178-gc72fcbc7d224
Subject: stable-rc/linux-5.6.y boot: 143 boots: 3 failed,
 130 passed with 5 offline, 5 untried/unknown (v5.6.15-178-gc72fcbc7d224)
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
https://kernelci.org/test/job/stable-rc/branch/linux-5.6.y/kernel/v5.6.15-1=
78-gc72fcbc7d224/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-5.6.y boot: 143 boots: 3 failed, 130 passed with 5 offline,=
 5 untried/unknown (v5.6.15-178-gc72fcbc7d224)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.15-178-gc72fcbc7d224/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.15-178-gc72fcbc7d224/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.15-178-gc72fcbc7d224
Git Commit: c72fcbc7d224903b8241afc1202a414575c1e557
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 96 unique boards, 24 SoC families, 16 builds out of 160

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.6.15-178-g1c16267b1=
e40)

arm64:

    defconfig:
        gcc-8:
          meson-gxm-q200:
              lab-baylibre: new failure (last pass: v5.6.15-178-g1c16267b1e=
40)
          sun50i-a64-bananapi-m64:
              lab-clabbe: new failure (last pass: v5.6.15-178-g1c16267b1e40)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab
            sun50i-a64-bananapi-m64: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
