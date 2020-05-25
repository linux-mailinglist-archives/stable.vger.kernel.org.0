Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0DF1E1320
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 19:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbgEYRBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 13:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgEYRBt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 13:01:49 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F30C061A0E
        for <stable@vger.kernel.org>; Mon, 25 May 2020 10:01:49 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id v2so3943765pfv.7
        for <stable@vger.kernel.org>; Mon, 25 May 2020 10:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qsMIDT6BW2yoTstI1VlHyaJn/dsqc/0W8kOeDEjocnE=;
        b=S2hchqfkLvR8LqBXSVO3fSM33k3pNrAsDb43SoKCiWt7kaPMAdHAaNiY07baNLbzUE
         GlNw5mmvLrwWPrHmwJgzLnedQAnS1VvTgDsyF1fufefhCpvk414bVmIMaatSVbUk7Vql
         v1OaKbGxw/PsSjlMe9Sg06pqJM+EGuSGQ5WfP07IjuiYC8CMItb0fkGnIOpHYTCMAa9H
         SatEpQJLOtraRJuEIBxQWlzMyKTSkun8bpOKIo/0SrAp39lNmH5lldEgtqDieCTo3v0N
         eXehLoYPCrB43EO+DkoALgnsjz90I26jsEsHqCK3h78Ej4iHYMezPYbuVh6w1lLLEcAF
         hsOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qsMIDT6BW2yoTstI1VlHyaJn/dsqc/0W8kOeDEjocnE=;
        b=nhdd1wxw3GR5Y1qkKzHrvoaIygrDhjBpAzbZpwpvS9CcHddz9sCXCRfWCNB98Vh/1l
         vTEKpCEnVfFyxZewiY10yLDrygc+WVHXhn9dAb57w7taVQtJYRuE1J6S3yNiKv61Pzg9
         Ki8Mm9OnSUQnWf9Bb1F6LoSZQCbTCI0WwpfUQ0MYjbHHgszetIGjRHkCrkFji2Z6pIfk
         BSU19wBy3yGO25ueLeF8x/Bj6JnwPb1ROy39ZFGY+86wjJVoZT0kAvogdVrqYUYydI5k
         v5YBgIf3WRO6ZTxIqguYcYRszBpNOHkBSFgMjb+2ED1c+wHJqoi9nTHg816eZcb96t/x
         DA0w==
X-Gm-Message-State: AOAM533sSfoeD+xoFvqP73mAgZRok4euFNx52Q9pOVf/qPDpxbVXFe0Q
        4OXTMdoj57IeNLCij+HQebn7LnkCvcU=
X-Google-Smtp-Source: ABdhPJyuwK13+89rPVNPhCNu/AlH31bLcfZ5In9lrcsGtv5p+TAa3HKSlTb2OgxSNgQAfv6ACzmVOg==
X-Received: by 2002:a63:a062:: with SMTP id u34mr27947202pgn.62.1590426108398;
        Mon, 25 May 2020 10:01:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q15sm13259282pfh.188.2020.05.25.10.01.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 10:01:47 -0700 (PDT)
Message-ID: <5ecbf9fb.1c69fb81.2e77c.5656@mx.google.com>
Date:   Mon, 25 May 2020 10:01:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.14
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.6.y
Subject: stable-rc/linux-5.6.y boot: 122 boots: 1 failed,
 112 passed with 6 offline, 3 untried/unknown (v5.6.14)
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
https://kernelci.org/test/job/stable-rc/branch/linux-5.6.y/kernel/v5.6.14/p=
lan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-5.6.y boot: 122 boots: 1 failed, 112 passed with 6 offline,=
 3 untried/unknown (v5.6.14)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.14/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.14/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.14
Git Commit: e3ac9117b18596b7363d5b7904ab03a7d782b40c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 79 unique boards, 23 SoC families, 17 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.6.13-193-g67346f550a=
d8)

arm64:

    defconfig:
        gcc-8:
          meson-g12a-sei510:
              lab-baylibre: failing since 11 days (last pass: v5.6.12 - fir=
st fail: v5.6.12-119-gf1d28d1c7608)

riscv:

    defconfig:
        gcc-8:
          hifive-unleashed-a00:
              lab-baylibre: new failure (last pass: v5.6.13-193-g67346f550a=
d8)

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

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
