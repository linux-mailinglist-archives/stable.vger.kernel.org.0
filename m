Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5AD51BC75B
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgD1SA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbgD1SA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 14:00:56 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1769C03C1AB
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 11:00:56 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id n24so8692193plp.13
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 11:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nZZ3iPyQeyku5zOIFSENmQ20EcsdsOSEm4HTVgED6nY=;
        b=XDTXcTWCh+tlScF01xw+ZMulE+XjCOlnPDDFQoBu6367QGv+n889vhCj4iocRc6eJ5
         snAnfv/Ae8I9DTWxcJqwOnQVyknPLqblQtC76+3migkLWAXA2sdmkFGEMzKTAOIj03iv
         yq9Hty2vu5DmNsBnPTln/P3N2iJI3vNp4rD/9qXVJNH8NXNQL0SLWKDV3MjyjbXH0K5Z
         y8Gz/JtOGplCXJZjMnw1jJvDmDvJDJFRkgrcI0Yqpr23G+BaLGbXheVoE9yewkpdBR72
         Z6rE3q4lj5JfkkRdS69JdeesMKlHGvyx4CT1Ez84B0eJmvPpmhXeRRQDF9JNT7O52tDC
         cKmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nZZ3iPyQeyku5zOIFSENmQ20EcsdsOSEm4HTVgED6nY=;
        b=KgUMex2jEwoHfYXjrSLrbwWQRwwzh1hJaSBj+SMcGl8Sb21qjmUzLvpdrJz9RroExf
         zUexX4y8Ludv3tKGhhp2gSlVIGsG2nFYZivcbiCajKja3IsPV+gmcCLgWK7nfX+6BhZ4
         XIZV2pInGPKWL8JsYdI4hO6Nv3CxwtnLJRYupRLw0nafYDcfuwaG07tKGDH45gFhZpJr
         X7rv95ebmzbOIK4hTJ1E5ocOnj05N/T1mKG1Lq114J8b0xvE/n1Z5fIPKCTyFRWn24ia
         Pq/C2bUqT8ndcxERcDHnJV1HAVJ1/EvHU3lAxpjadEhON3StjZ5DYiGbeZw2CFZ5TEiC
         LRIg==
X-Gm-Message-State: AGi0PuZ6A/dcQVnayYjcMND8Kfs3npgcHOpj7U+lIYdy6pILip2oc5Ea
        PVIemGLJuMNAXi67N7ftWWCTx6w6LBg=
X-Google-Smtp-Source: APiQypK/Y1PQlVAIwj83eoIrBeVnd3S62j0q4l4ZADHjg/EVk588rWxGaB99/Xggh/wr+z3lbw7IgA==
X-Received: by 2002:a17:90a:7349:: with SMTP id j9mr6545118pjs.196.1588096853998;
        Tue, 28 Apr 2020 11:00:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id go21sm2778115pjb.45.2020.04.28.11.00.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 11:00:53 -0700 (PDT)
Message-ID: <5ea86f55.1c69fb81.36946.9466@mx.google.com>
Date:   Tue, 28 Apr 2020 11:00:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.220-54-g00dcb2acee8d
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 43 boots: 3 failed,
 31 passed with 4 offline, 4 untried/unknown,
 1 conflict (v4.4.220-54-g00dcb2acee8d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 43 boots: 3 failed, 31 passed with 4 offline, 4=
 untried/unknown, 1 conflict (v4.4.220-54-g00dcb2acee8d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.220-54-g00dcb2acee8d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.220-54-g00dcb2acee8d/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.220-54-g00dcb2acee8d
Git Commit: 00dcb2acee8d389b18592b943f6cb0a7453530f7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 32 unique boards, 11 SoC families, 15 builds out of 174

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.4.2=
19-83-g20fbd20eb91a - first fail: v4.4.219-101-gacb152478366)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.4.2=
19-83-g20fbd20eb91a - first fail: v4.4.219-101-gacb152478366)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 80 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 33 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
