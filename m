Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0017E19B6F1
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 22:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732350AbgDAU2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 16:28:08 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36257 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732345AbgDAU2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 16:28:08 -0400
Received: by mail-pj1-f68.google.com with SMTP id nu11so570784pjb.1
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 13:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8IaPOlwkmQzZEN0Sh7pDiA2p52P8S07bH9vkYBNXzas=;
        b=Zh6rRJFXFVztZi8GJsa0sHn0op7pNq7eXAaNQDdTUh3PdObXV5WSpmRHg2zUBWcJZZ
         LAvmRJYUJFHCGmXO79ltNU8VopxqR9RXvZatlsZLpZUP/diVHl/Em5GtUJdGbqZkqnY7
         N1YqUNiqMJWBNjKn5PdNWLyunLfL7SYK+DxbJRcDGsFiJGF2cWys//SAufNVDEw65Af6
         BHgYDFSvv4DKSLz334FInM5IgoYse8DPffBhgDcYBBRsByh5bZKDkhK33vhxFoVgNVLv
         E7V3wB/AXJKHjOFalmVkh6qop3VsfWM+xzYSLnBGzPIWvOMZDyuyl2mI3IB9FGGXJwPH
         QzvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8IaPOlwkmQzZEN0Sh7pDiA2p52P8S07bH9vkYBNXzas=;
        b=gB4XiNQlkrwj/Nnt4Sq5v20rklbGpv0AeycggLbDxmfwEZFAbWVKwY0m8c1AAdT/VU
         jw2Hc32NBuHC4V/Lj27p46mv/9ChksCdu55CrDglehSzYaPC1bZ1akq8G6wQKxMxN+7P
         fhwmN0wKcEIB9CLflEaDjgyTN587HMbcBGBDLbwJ9qUZvf4l/Ettm4RPd++ZtOb8x1hO
         gVZ+QDTTi9wxwArOwdRCmPFhfgOEyChNpuPcNwLkduONbGx8DDmInVpAEO9uSjgufAAl
         I+jl1bPcJJamhGiiOSL8fXdSw+51ZLwOQnJmSKqQpAjNX3skEkiD6Ds6E9zhdi+II42Z
         NZqg==
X-Gm-Message-State: AGi0PubR158X3+YPjpYvE1zMa4m3xxuzO10Qp46rsuicc9XFRIA1FXni
        AQBAMQ2CAzmmuk4RBYifEzcSoQk9Gho=
X-Google-Smtp-Source: APiQypKnjzm2KGt3Ojm+Ctw/YY/9OCV6uERfXUD6bNJfRTU5PpPeklxQbXRgrjnUgHLJwFyxCvYeAg==
X-Received: by 2002:a17:90a:23ed:: with SMTP id g100mr6702959pje.93.1585772886891;
        Wed, 01 Apr 2020 13:28:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x4sm2105953pgr.9.2020.04.01.13.28.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 13:28:06 -0700 (PDT)
Message-ID: <5e84f956.1c69fb81.433e9.c142@mx.google.com>
Date:   Wed, 01 Apr 2020 13:28:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.217
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 115 boots: 1 failed,
 104 passed with 4 offline, 5 untried/unknown, 1 conflict (v4.9.217)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 115 boots: 1 failed, 104 passed with 4 offline,=
 5 untried/unknown, 1 conflict (v4.9.217)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.217/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.217/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.217
Git Commit: 10a20903d7ac2be29e0e13d66ad0d74e637b8343
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.9.216-128-ge=
b874cb221b9)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 46 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.9.216-128-ge=
b874cb221b9)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.216-128-geb874cb2=
21b9)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-baylibre: new failure (last pass: v4.9.216-128-geb874cb22=
1b9)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            tegra20-iris-512: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
