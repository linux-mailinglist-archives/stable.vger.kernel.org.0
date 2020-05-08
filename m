Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89EC1CB98D
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 23:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgEHVMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 17:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgEHVMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 17:12:48 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1A9C061A0C
        for <stable@vger.kernel.org>; Fri,  8 May 2020 14:12:48 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mq3so4865258pjb.1
        for <stable@vger.kernel.org>; Fri, 08 May 2020 14:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=53sd7XgEYzXkikxgELSzYfHGUXt+1h07d4esnwQDjNM=;
        b=jqZVYAi63FBxSE+LrsqhdD2OpuJMuHczUliDfb62y3zLgizXlgKAFJp4lzme/AmcdF
         k2a7d8lRaW/UhzOo0vFaZd9E5IW3CaA0bZP4ca/MW+K3j5+dFp6ZFEkKjrE4sdv6KUoi
         6mC0JWJlPoYJM7wNS1EyviyyKNXA0YXDRyw9CFd1j5gIJbFe5g64DMnCApnErBvB5g51
         DcUy/2ygaQJQI1z8ETETSPfUZyrYzhM5c439Gv3KEextL8f8a+Ra9FNZLU04SXDrA9sS
         ewywJ79EQAclwcymUl34mZ90kbui62dHgSgU7PS0WNpTB+noX3Swq8Zvc3nAJaIVlzRZ
         YZiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=53sd7XgEYzXkikxgELSzYfHGUXt+1h07d4esnwQDjNM=;
        b=g6Orhg9gG245v3zhG5p+CfVErGm147i2l1DimZX62bbiV0lSFTSOs1MQ4OnsNa3Jed
         DN/uO7xmOf4ofKSF+GmzF67NoyN+5LFewzDI3jlmFl1WINUIHc74o0hI/1TBQ4r8kNke
         Pt9p74j+7L55v11AZQqzBfJrg2kr93dpitSkOvAP+F+Dpm3qWUNY9TArJ2XJRGxNkywX
         2/02KOJICzzqZORdP14csjXbQ6ZdcwdCcM3kmIvHw9DqvOFvA+f/Uo47tACYYF78hc0E
         yfkLqGSMGX/dDXm6A0ekbXi4VxC+3rc4B/hTXU8ULWmhGPURN9Gxlx1fYnuBdxiIj2to
         S59A==
X-Gm-Message-State: AGi0PubHq2n1PoDniK6MuvBNlJoZ2Tv0xWBifQFJ5wX+u1/QuM6silwl
        tkQ07gzDKt1ZLLMwZRZ1aE2bZyZ7r9A=
X-Google-Smtp-Source: APiQypKuJDTS57Lw26mEsADY7+yUzH74HE7Z6tE0ibhtfX6U90Znz/v5sK9dE0r3s/Hu3SuV88oGbg==
X-Received: by 2002:a17:90a:7a83:: with SMTP id q3mr8311054pjf.162.1588972367014;
        Fri, 08 May 2020 14:12:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v133sm2606221pfc.113.2020.05.08.14.12.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 14:12:45 -0700 (PDT)
Message-ID: <5eb5cb4d.1c69fb81.bd624.9d43@mx.google.com>
Date:   Fri, 08 May 2020 14:12:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.179-23-g3b9862300234
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 95 boots: 2 failed,
 85 passed with 6 offline, 2 untried/unknown (v4.14.179-23-g3b9862300234)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 95 boots: 2 failed, 85 passed with 6 offline, =
2 untried/unknown (v4.14.179-23-g3b9862300234)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.179-23-g3b9862300234/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.179-23-g3b9862300234/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.179-23-g3b9862300234
Git Commit: 3b98623002348651d84865b1576cdc13caed64ed
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 17 SoC families, 17 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 90 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

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
