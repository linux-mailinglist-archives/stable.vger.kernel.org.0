Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC8E1E103A
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 16:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390900AbgEYOQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 10:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388714AbgEYOQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 10:16:08 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B343C061A0E
        for <stable@vger.kernel.org>; Mon, 25 May 2020 07:16:08 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id u22so7520803plq.12
        for <stable@vger.kernel.org>; Mon, 25 May 2020 07:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=W1gMjZ/QyGvEEF3NB4k77f6dDoAdiBV8qWLcaql2+Vs=;
        b=rgtgcIx4jkvcDXRjVhfyIrPQb9ZZI1TvYw+BfHm3MCMI4qyLP9UeSw3uBKqF9lSY4G
         CZkA2tS2fEHgLvguxkrhrcYjZYzPbX/aSqKB/kIbz+Qn7NtxfRn55XA8z2GStljS4Gsf
         S+1SIOpopJqHOp6CDjIF7YRkWvNm8DHKbLJ9Ds5E8/Zi555ONjmFUQqF1J06c6aomape
         /lPm/9uJPNoAzNw92nvnfFxWyeW6CDDo9rzuYgpeNpwO0LjH3vHHWiBrSnJY4Owi+mod
         /4oJsTmVOzcf1OtytuCut5bTRnwv3YFd+K7EHvnYlk8Gj2PYf+Rfadi4gzy2Nh/splWV
         KRfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=W1gMjZ/QyGvEEF3NB4k77f6dDoAdiBV8qWLcaql2+Vs=;
        b=C59r2LFluSoAwUeh5GkCtzj8SXtYdVz8252tPM8A5cWGFHX58XgPByyDpvw6LG+3Ra
         blHSfy0y+/cwaaPCOx1udCM29k8pRwMf/hQT5JG+2ObVo9Zbbf0jVK8VCQsYk3YLWrfp
         tYCx+GWskL7LTm+e4ocExOtkLfLVibCSgu7FdeE3oDkL20gvsHPqnJN/RqRtiHV1f9An
         i6VDRnI6+OZn1bdzcDJ2gI6vYhmOAB8tb7zrWu9c9hlG2uMciSvvlzD08vlPrsYWZZlK
         PKzRiKO33+b1G1MsXJzNoxkGyn45DDkPWazXEY9e+GzHry7kadCOogukuMsQ0wGv33Yv
         5zRA==
X-Gm-Message-State: AOAM532U/Fn8MgszTjk+fhv0KJJP7uu/u2j8Kth5UV0WLqe2VhtjMHE/
        QsuKMVxu1ws9HFtDfpt6GE7TiQe4B1U=
X-Google-Smtp-Source: ABdhPJwd26C1yvRnEKTGH8bbapBOnHLBaN40yAgKzntzcuJXvrRej7S4G9RUgfChpN1OLSCeftjiTQ==
X-Received: by 2002:a17:90b:1897:: with SMTP id mn23mr20862824pjb.84.1590416167528;
        Mon, 25 May 2020 07:16:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u20sm13267241pfn.144.2020.05.25.07.16.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 07:16:06 -0700 (PDT)
Message-ID: <5ecbd326.1c69fb81.3091c.4012@mx.google.com>
Date:   Mon, 25 May 2020 07:16:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.224
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 82 boots: 3 failed,
 73 passed with 4 offline, 2 untried/unknown (v4.4.224)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kernel/v4.4.224/=
plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.4.y boot: 82 boots: 3 failed, 73 passed with 4 offline, 2=
 untried/unknown (v4.4.224)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.224/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.224/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.224
Git Commit: d72237c1e00f85e5df1c040280d50561c8a28329
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 18 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 11 days (last pass: v4.4.=
223 - first fail: v4.4.223-36-g32f5ec9b096d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 60 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
