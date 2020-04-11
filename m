Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E93231A52E3
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 18:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgDKQc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 12:32:29 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41030 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgDKQc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Apr 2020 12:32:29 -0400
Received: by mail-pg1-f195.google.com with SMTP id m13so2372984pgd.8
        for <stable@vger.kernel.org>; Sat, 11 Apr 2020 09:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ysZfCr69WmAmZDk5/BXN6HYMYTj+bzVCI1+k2QBSP7I=;
        b=Bn961+/5Q6kOtu55PitMu9Y+I0AI5QWRmTWadTbGHhtktNyAiMLE0Di1TmtQkL82yz
         kEFb852Sl21CsrMrxADt4fyFY0zgbsFRMi7l45LYeWBGFXBO3gE79rhfToW2mjTPKuBe
         e2Ej7aEuqFxLQL0u83P0s8OpG8pTiPjbjjcrZX4VG/xYY97zgJ/tf3Ho+ng+3foyKrmV
         X0FHT9wzTPAJ9pts2dAAof6JMMPIzMjU/Wo0NWasyDhvZT8qypFKPZitMolLeIao0jFL
         1vlogtbnOa1aV0F0EYOOTK3woPqRYl5NXpLxWbwv3Oy+57odfd6L6MLKI+vDRXNZB+7k
         00yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ysZfCr69WmAmZDk5/BXN6HYMYTj+bzVCI1+k2QBSP7I=;
        b=dLruN1WRIbMh6OSp1lvRh09WjvrHD7OBEhHQ3/WB67BOoCloTk7rGp7B2ywCqPrHMu
         6XjoCLTaW8f1DIgl7X5hW74XluIXoRrAHC8a5KUr+iuAykDQjPh/zTDO1pR3Fs8IZvjA
         z6/ya1RzLGdN6AA3EyUQvk6oBDVR0ZVKJBiMqvETiowe8J1XWiIj2n6+hOEeyrDqMO2n
         lcuP/Cwur5UUA1BSIJV3j+3nWZizb70f1ifnalRQvNp/Am0rwawjE7pch18QE+s2fttM
         odx+wmPs3K472cbJVQl4h+n9MqQNRvixIZMrYdMkqrOzhBqLyGjTPB4MW5SM6d6ECLUg
         WQqA==
X-Gm-Message-State: AGi0PuYVWyq+JNGBw2+0y5yNICnFMLJj3lJc9eTeKrG2zX7YREnis712
        9ZAJz4l+5Pl3hOB85ADH56QEL2f0YVk=
X-Google-Smtp-Source: APiQypLOLTv7YEK+Y8XHhBU9vKQzTc6mDyc87tQIsXDWp8AtE70pDjK8XAEY7qUZzBnE6duKmh061g==
X-Received: by 2002:a63:9d8c:: with SMTP id i134mr1280125pgd.152.1586622747123;
        Sat, 11 Apr 2020 09:32:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id iq14sm4619872pjb.43.2020.04.11.09.32.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2020 09:32:26 -0700 (PDT)
Message-ID: <5e91f11a.1c69fb81.2b9a7.e4f3@mx.google.com>
Date:   Sat, 11 Apr 2020 09:32:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.218-30-g8cd74c57ff4a
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 96 boots: 3 failed,
 87 passed with 2 offline, 4 untried/unknown (v4.4.218-30-g8cd74c57ff4a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 96 boots: 3 failed, 87 passed with 2 offline, 4=
 untried/unknown (v4.4.218-30-g8cd74c57ff4a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.218-30-g8cd74c57ff4a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.218-30-g8cd74c57ff4a/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.218-30-g8cd74c57ff4a
Git Commit: 8cd74c57ff4a364d0a753e448ce5eab18cc5bb75
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 18 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 63 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 16 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

Boot Failures Detected:

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
