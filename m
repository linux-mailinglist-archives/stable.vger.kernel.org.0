Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFF4C18BE45
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 18:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgCSRiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 13:38:16 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39095 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728559AbgCSRiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 13:38:15 -0400
Received: by mail-pj1-f65.google.com with SMTP id ck23so1305543pjb.4
        for <stable@vger.kernel.org>; Thu, 19 Mar 2020 10:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a24chiKSIvnLAG49XFmUCXQrYBV/Qi62MYSEm9g2508=;
        b=nh4uYqvX/Wga8ohIFfoZgAT8hFRVRFTg1WUSTVeEIsZnWnJCJgtirJlFUxKALqSMas
         bt9K1ALVItbqtKy8ynQgj5R562mrjyj24hhKNO1HZYLukXLWAVcKPWmlMnPE/KMk8WtI
         2hpmLv7EEdQTDBvSyi1TLLDaMOsgEYb3P9EmMxIctk9E2wbs2KBJCuyHj00y5IbzR69x
         F4t3DVwH1iRLIJX5fJ7xFyUG82IIqx5KDEx9Zl46Z2Qg0OE8nONA+iItB4lJ0CNSITF4
         ipqgXcd5BJ8tkI7PyNvjoSEB7g6OZdKAZBJj5p5mDqcmTCNGRIqPwtjJbKv0S++Pd18/
         hxdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a24chiKSIvnLAG49XFmUCXQrYBV/Qi62MYSEm9g2508=;
        b=iBzV9ddsiHfOhIIPvFDTLo1HaTW05gCt+kg6TGzVe0CerMhwXNwExhfHAc4rYOdSpS
         bI1GnH/vxqPoNeEeRrSc9at9kdUBVWM3DX2YVyPXZNTIWI7mBJfHurfGo37xW/FxrPSv
         UThmaYeN6vH/eEpCN+iAfaDMPhgxo8JhYAkQahrIWSBR3uicbR23gG+dKaBB1WTTO+Sl
         pwcbHM+3CTapcUX9slWDITeRjng3pVE6TvYq0JNxJM9NLAuO873cPF+3IxavOUmwsIHE
         tqX4L0mOfeyayfjnfwhii8Y73mr4iEqjMA0Xlmhu/Oj8lO/z7YHq3WzuxZ6qG3KpYXcd
         0F/w==
X-Gm-Message-State: ANhLgQ0hhKNGvjRKacR/0h4JfnJVwGpYlvj3HtL7bIHFmrTX4uTL44oS
        WT9NvoFBxDU1N5O9ZlJTnPu9AtZDWeM=
X-Google-Smtp-Source: ADFU+vszeH0R/ivwlfcjRwNUcqOr/4wgGJGlz03KfgxY55VvZvDM+vIVRJcboXwU748SwDkb7NhI1w==
X-Received: by 2002:a17:90a:32c5:: with SMTP id l63mr5174353pjb.47.1584639492791;
        Thu, 19 Mar 2020 10:38:12 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s24sm2964960pgk.14.2020.03.19.10.38.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 10:38:12 -0700 (PDT)
Message-ID: <5e73ae04.1c69fb81.438aa.b049@mx.google.com>
Date:   Thu, 19 Mar 2020 10:38:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.216-94-g2f57fed8dba0
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 94 boots: 4 failed,
 81 passed with 5 offline, 4 untried/unknown (v4.4.216-94-g2f57fed8dba0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 94 boots: 4 failed, 81 passed with 5 offline, 4=
 untried/unknown (v4.4.216-94-g2f57fed8dba0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.216-94-g2f57fed8dba0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.216-94-g2f57fed8dba0/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.216-94-g2f57fed8dba0
Git Commit: 2f57fed8dba0810ba3a6cc7ee0b8018efd4c81ca
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 17 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    imx_v6_v7_defconfig:
        gcc-8:
          imx53-qsrb:
              lab-pengutronix: new failure (last pass: v4.4.216-38-g4173a29=
8f52f)

    multi_v7_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.4.216-38-g41=
73a298f52f)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 40 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.4.216-38-g41=
73a298f52f)

Boot Failures Detected:

arm:
    imx_v6_v7_defconfig:
        gcc-8:
            imx53-qsrb: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            imx6q-wandboard: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
