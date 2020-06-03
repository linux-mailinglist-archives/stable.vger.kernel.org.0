Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F641ED732
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 22:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgFCUEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 16:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgFCUEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 16:04:44 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CDBC08C5C0
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 13:04:44 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id v24so1191982plo.6
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 13:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BhraYu3+6O2Ri+fNEECXTmznpRvDM/JemQ/tYxF0RUU=;
        b=kmyydJwuxibM5zeQ+8TP8GS9Zp8NDMFiNeibwV01wLejDHtdubUkhZd1Gb5tSL58Sv
         IGFhNZdnArEO1/CiXG2JTWXEQMRnRjAKmzqLnNpJv61iy9yakROnLa0nu7ldoggnQjzT
         kaJzOG8Pq9PoNkEqhxRnc75aeD5DcxqL/mdZP8k2EGwC7sBwUUI1jH+/zmuA8G4mzden
         bUu55XubIKutMBgLDvfl+2fySPvELsRC6f7r0afyl2agBlgZlZwGn2BDC1PIx6vmI0U8
         tXNaRMtt6ihyHF04VBOjbHL3i2Fhp6nutGZFVsipmWyDm0rVOdtmWY5HxpzlGK8sapo8
         fStA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BhraYu3+6O2Ri+fNEECXTmznpRvDM/JemQ/tYxF0RUU=;
        b=MgrCLvunywp09Y3yaP94fVS8aIGwNHaWzLB36Uc7d0ky08clT2AJACCUf9A3ox/8dM
         7u8D2mDhRNID+i/R932VosoLcjgo+dM+5b40cfowDtqKyBnEKk9PW8cIRF/EBUPg9LNY
         BZWI/ymfNVn8QudzgESDUtram2qSIumDwjcHw8noCCikrAJ6VWtfpjYhZN2QQNWbr5+A
         KtWNu4Z13J0cEj8beo8MbV+PRhGLMn1nPTnb/pSvRJnooh8/ojjKtscxDV4KfyaCy7pH
         dRVE4Svp4v97qE0XfQkgtLe0/5fjUNZb9TdXJok+NzQr5rZCtNX1IIORx+LoeJMojIpH
         uZ2g==
X-Gm-Message-State: AOAM531TH+A5NfEU+THJI2nhWO9Ur/9VQpx+nTfZ8VxoBvpuoxp5dS9C
        N0Q6UxreJuuCvmaBwtB0Eb6A0krUBKM=
X-Google-Smtp-Source: ABdhPJyZMG071SxFfIpcFq63iQkBd2qXdUVjFxdQ4jxT9TWhbdLMfj2+lJZ3DHkPeJFkkCYcLhFpwg==
X-Received: by 2002:a17:90a:ce11:: with SMTP id f17mr1758559pju.123.1591214683494;
        Wed, 03 Jun 2020 13:04:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n24sm3232581pjt.47.2020.06.03.13.04.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 13:04:42 -0700 (PDT)
Message-ID: <5ed8025a.1c69fb81.ade78.8756@mx.google.com>
Date:   Wed, 03 Jun 2020 13:04:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.226
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 89 boots: 1 failed,
 81 passed with 5 offline, 2 untried/unknown (v4.9.226)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kernel/v4.9.226/=
plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.9.y boot: 89 boots: 1 failed, 81 passed with 5 offline, 2=
 untried/unknown (v4.9.226)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.226/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.226/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.226
Git Commit: af5595c4ae50545abbcc14515e5b15f823fb9b01
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 54 unique boards, 18 SoC families, 18 builds out of 159

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 21 days (last pass: v4.9.=
223 - first fail: v4.9.223-25-g6dfb25040a46)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
