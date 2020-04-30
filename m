Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAFC1BEE9C
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 05:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgD3DTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 23:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726357AbgD3DTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 23:19:03 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13910C035494
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 20:19:03 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id s20so1716736plp.6
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 20:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PL99mbuJ4EYEaZMuSXzBHinAaPpIVgOIO1SivY/6bVs=;
        b=Gyw2fa6weCWTaADxvSsAJ3V7O36eHUvRKOCxH/Feq8QqBtvjILGH28ZRXMU74ImreN
         2xSz/hyWCBzd/Pgu5ov0rdEoQpN7jIsx8IyaBp4xBhOY8REtHSqBacEY9/QcgMoPd93f
         dgtZJqVHcq4KmysFBPR9MHvzCEKWP/s2UfZfBSCHfTAcT7dDguMWegAJjNxMVGQe9+XG
         fP1T+ODRikwL9PYyluZuHMUInmosxRj/rn3Yf9FskSQy/gL3maoT1Lr9y8teCAbB6v1j
         Yp0/EjctJFYGjaMPxSQXRCmLa62akn/9xqFKZo3EWtGG152/sl/k8/lK45sGbHGbrgZ3
         0dEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PL99mbuJ4EYEaZMuSXzBHinAaPpIVgOIO1SivY/6bVs=;
        b=WHXBwvRZF6/3gjUBTmaDkkEBRuIOHoux+QBnhBbWEftx6XzFo/4az9bn9c3hV09fMi
         Zxx1fDjmmXz/ydM05r+SoveBe8o4+N3Cfyed0Fko/8S6w4WzEh6SGopD8micJwxCRdMm
         6HudYmdM3+7t+C5n4Jr0pk0ZwIG5VhCos07YdeAiCL45QFMPE6CLKukNrl8t65lmO9yR
         FzDXklEZIv5wRt5wcj2gHMGOk2fHZs5chCsD4gDBvbO607CnkRfMJpIA0BxK6IbFGsKo
         HuGZFrPX62oGZTZGNtDH7//phqIFojNNc3c+jefz0QL/MQclSV5bI2s1coqiMBMGFwyJ
         muog==
X-Gm-Message-State: AGi0PuYOuzNjY4f206vS7agb3WRNjkmEjPJSGEIAN7aWKs7lm5fHOg9B
        99BCcfuzrTxPExMaciAq0ppCHC3SonA=
X-Google-Smtp-Source: APiQypIbMwiGYXmfNE1d8vILYCnz6rvEnSAQ7Wy4vU/eokrcmqpduSqFxs4ELkdOs1MXdVUW8t6jag==
X-Received: by 2002:a17:902:c181:: with SMTP id d1mr1677543pld.80.1588216742170;
        Wed, 29 Apr 2020 20:19:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q64sm2200749pfc.112.2020.04.29.20.19.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 20:19:01 -0700 (PDT)
Message-ID: <5eaa43a5.1c69fb81.1cec9.834a@mx.google.com>
Date:   Wed, 29 Apr 2020 20:19:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.220
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 96 boots: 3 failed,
 83 passed with 6 offline, 4 untried/unknown (v4.4.220)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 96 boots: 3 failed, 83 passed with 6 offline, 4=
 untried/unknown (v4.4.220)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.220/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.220/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.220
Git Commit: 5efe91c00c98c72cbe8475caa6e72c520199e32b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 18 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.4.2=
19-83-g20fbd20eb91a - first fail: v4.4.219-101-gacb152478366)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.4.2=
19-83-g20fbd20eb91a - first fail: v4.4.219-101-gacb152478366)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 77 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 30 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-baylibre: new failure (last pass: v4.4.219-101-gacb152478=
366)

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

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

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
