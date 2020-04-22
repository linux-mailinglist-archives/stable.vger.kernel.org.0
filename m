Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759591B4CFC
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 21:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgDVTEc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 15:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgDVTEb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 15:04:31 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7973AC03C1A9
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 12:04:30 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id w65so1569956pfc.12
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 12:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s+aLsxdiBGbiXPHoTUHIyhNLEa5rKjiTvku+maOUW1s=;
        b=ME1ZIHGFG7M/rLqtzX8/fJ0HDm+E+ameeazwaUgC2kNQ8U1vedixZp6j6Fl868DYsN
         S4gH12+0mlwzaGaeBUUVAHkrfYCT8lIQ31FBIFErQLgwnfQjrOIZRSY5q9oP9m7yy9Fd
         GTJBkDO282TsItFKLfT8uJ3g6fjYe00kmj5w+rhFZaybnuZbBRcXiFjL6r0ZfT8f4TGe
         B8xD9btSV1GnFuqah9ZB/36HlBS07RyHwRXtfTyR1ez/UooIn5hPu4ASzzUfl7jboYAG
         Mq2E1HZRulpoZqS5ji/nNBnPdyjznAqng/fyAdkg1qEeVpr9O0Re+rH63OZC1lVPA5bS
         BhTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s+aLsxdiBGbiXPHoTUHIyhNLEa5rKjiTvku+maOUW1s=;
        b=faycjDNNdH7CYRVp7f8ddAAh7ZLpj9+tIPM+uAuQTJoaaKzSDe3xYgboGF/sIfwKWo
         y7Oe4nun//iXo08/jLl0Lhfcwtnoi94s7sGh9u/pVNBA8dmZ/HkLd2Vy2Pp4D1cWILmA
         6mT0cnwvemjIbdEsrJ7vaB7S8ImE104irqzbNYKl3W+JGIuNc3wG1JleObQvSUy7wnTJ
         c5SKACuCYBfD5B43JXd83yUBxujGEoKouHKPV0xDy8E3SnrketfG8G7xRd5rzBwzgW61
         JngbZE/QOK7Uwv9t+2GwfpceETGowiUgMhe83aLbQ78bn3cPelqdSAbml8sPt4j/UmfQ
         Yi7A==
X-Gm-Message-State: AGi0PuaQ2LbdHT9kodcjvfvQym2VM4vRn6gxFSXIy8L3mI7E5T8nx/zR
        mwINxH13L9kxRvslI3UEb1k0Fqis2Bc=
X-Google-Smtp-Source: APiQypKGitlKtr89p8wj1adrgOAI+iXsGZo+MHwnos5VU6tPNszywGYCU2zOUt3o56hEWo0uNFwwFA==
X-Received: by 2002:a63:7884:: with SMTP id t126mr485197pgc.45.1587582269256;
        Wed, 22 Apr 2020 12:04:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o11sm5822618pgh.78.2020.04.22.12.04.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 12:04:26 -0700 (PDT)
Message-ID: <5ea0953a.1c69fb81.1b0cc.267e@mx.google.com>
Date:   Wed, 22 Apr 2020 12:04:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.219-126-gf6cef26090da
Subject: stable-rc/linux-4.9.y boot: 53 boots: 0 failed,
 47 passed with 6 offline (v4.9.219-126-gf6cef26090da)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 53 boots: 0 failed, 47 passed with 6 offline (v=
4.9.219-126-gf6cef26090da)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.219-126-gf6cef26090da/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.219-126-gf6cef26090da/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.219-126-gf6cef26090da
Git Commit: f6cef26090da1763de1a7fc87205c8442d57bc80
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 31 unique boards, 14 SoC families, 13 builds out of 197

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.9.219-101-g4=
46e04a0359b)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.9.219-101-g4=
46e04a0359b)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 74 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

Offline Platforms:

arm:

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

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
