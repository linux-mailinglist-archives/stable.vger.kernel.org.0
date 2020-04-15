Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244A51AB27B
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 22:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438080AbgDOU2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 16:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438082AbgDOU2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 16:28:13 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F720C061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 13:28:09 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ng8so338256pjb.2
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 13:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZUxfCcSYcuSeoMN2EHV01aCTbNE17DF/X8RELAeIWWk=;
        b=k2dPDBRk/0SjE6Mf+zCIxvQl5zV27rNTqHJ2LQI7s77JGUc2fOfJH5xY0DcXal+1fy
         yBZk9VfevVuSDs5yRdCaky8z9ozTnrBEXE9kgl+k90ydah8vLXxu1MfgRTjYMTZRFhGm
         cU7J1Buhe8FwH/gCT1TaQSi7QpKrEFgQ4ZnHwJ98Ue75eTBAQwXQsusztB8PDUDf0Cxn
         JfNNHXKyPAzYaowD3XJ7VbYajZL5sQ0QCObOQpRt5H9R7ctvGN8lr4T7XtnLLoIpx1pn
         QN9nZTiZGkXVWyXo3KKzCQmfuzYGgpNYlyFY46xqDZyzcECQ+txzf7fJ/1CTG8vpJwet
         G9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZUxfCcSYcuSeoMN2EHV01aCTbNE17DF/X8RELAeIWWk=;
        b=JXdckoMcvpFkavqHu9tTT8e3JL29ZIMOQdMdeHI32kUakihVRjd0IGvQy2wwttbORZ
         NruXKIWx5qQvuAe+8LzXUmqX8W2kRxN+r6O29GxduuWz7jOOOEKHekNxrfXZq2G+orH/
         C6s7ZOJxIhjAl6h2ntvqawwSbqe87oOlWXiPGUdPvU8m2rIHAD8SR6DmPrRrwDXYm3Li
         2zLnCeAVVKq8/YwZMn6I27HZ05iAEVMolS3KO8ZvnGsVyGN4pX7CyEdmukHjF9apK2YT
         z37sPjPRCQrH7EVatdDGFlBSuODemWW87v3abOU/6JJzhMJ1WmxY+Qrurj3wYuKfTnPI
         47jQ==
X-Gm-Message-State: AGi0PuZsvG/qBAGqMp4kbDgkn3jZP9zIRuSDlg6q3aUlj5s6xe0HzYEB
        nhrM90QX5EwmVEZtQ8F7bRqoSCHhiL8=
X-Google-Smtp-Source: APiQypIxVU9v6T95IQNzRBoRyEOwDWfZPLOXMPtZq1k1UH9k24DPQHI2Qv2lvJOLMhq6bu9RADfaoQ==
X-Received: by 2002:a17:902:dc83:: with SMTP id n3mr6506614pld.133.1586982488546;
        Wed, 15 Apr 2020 13:28:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j62sm14072089pfg.192.2020.04.15.13.28.07
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 13:28:07 -0700 (PDT)
Message-ID: <5e976e57.1c69fb81.e0b24.f300@mx.google.com>
Date:   Wed, 15 Apr 2020 13:28:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.218-93-g8271444878fc
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 113 boots: 1 failed,
 102 passed with 5 offline, 5 untried/unknown (v4.9.218-93-g8271444878fc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 113 boots: 1 failed, 102 passed with 5 offline,=
 5 untried/unknown (v4.9.218-93-g8271444878fc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.218-93-g8271444878fc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.218-93-g8271444878fc/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.218-93-g8271444878fc
Git Commit: 8271444878fce9641951fd7307102c255d8f83e2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.9.218-33-ged=
218652c6a6)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.9.218-33-ged=
218652c6a6)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 67 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.218-92-g79de6a233=
fba)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
