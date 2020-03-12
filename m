Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC6401830CC
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 14:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgCLNFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 09:05:46 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:32954 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgCLNFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Mar 2020 09:05:46 -0400
Received: by mail-pj1-f66.google.com with SMTP id dw20so705563pjb.0
        for <stable@vger.kernel.org>; Thu, 12 Mar 2020 06:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XVcQaJz7ijQQDWHP5+/wnbcsXKb8XTncUoURepR0SOA=;
        b=fRitXOxRYVnVtfSagaRetGjS1bV1a+Oq/QsRlH4DAJ70/eJtBDSgLtRwpWgV8drOsk
         vTpXHMt7vY0yOBO+Ku3YnCcUxLpboW0/Kk26gNTgsWRr9bjRD+WNdUVHZkHqeykyFW5C
         PUqEEHugcCvzpTfEuXg6iYi1fk0gpQaNDf67CVa+jNxBKl/uHubnxrKixzF5O3pah7V0
         WtH12c3nKQu+Jdm29f2jAPWKY4DLxYVrIW8rbpOxyjD8WKbzEvZC9W2EXKdOZ1tCe+wP
         SuTBXx5K1XgUmmMAA+TZp7gWUJlCn86q6WNbGX5g5W0OJao1Mx5Jk6jv8MZuJsSteL78
         Uyew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XVcQaJz7ijQQDWHP5+/wnbcsXKb8XTncUoURepR0SOA=;
        b=a+JRnxXpDUFiGRpWhBgYPtg8g5UUv33jlL9PV30RomfPalAw23X2f5IjBx91feDjuu
         koWuwbipNE7sisVpAMyl/H6Olzp+Yy25wwhKtVhAW1DIf/ZGXIvPtFZwhjc/6RnAAsWx
         kHcG9Zr8y4VYxEjrcF9XsRYc5xNxcwxGGM0J2K5WEXztiMeziUGEjVRobH5XxKk814wm
         NiVR6a/X+MP8PLfuVXeAiLjuRbv27k2jqOgbMk2LHBj8QYqCTKFZPM6TD3ZVIet3cbNF
         2cEsRUPDnZNcl4HYMWj3Ok+kQzIhI5UYdNxtb/3rUPk0c8dzV3PYqnVBEYQLJacNx8PG
         uvqw==
X-Gm-Message-State: ANhLgQ1rauN64dnIbMWez4i5lN9ls/do0SRMYhHAi47fgwduiqQ2qOnp
        cd/ekdJ2Xmv0/Fg2wE+Go3viAYkmZZY=
X-Google-Smtp-Source: ADFU+vtUMc0pgEuWvlUqvMzUDaK6INvvPyXPFWVimPyQ1uKU/S/lTHAnl0IV8mRRK1WcOA2apbsKzg==
X-Received: by 2002:a17:90a:1697:: with SMTP id o23mr4058096pja.62.1584018343449;
        Thu, 12 Mar 2020 06:05:43 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g18sm55560038pfi.80.2020.03.12.06.05.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 06:05:42 -0700 (PDT)
Message-ID: <5e6a33a6.1c69fb81.4c5a1.9ed7@mx.google.com>
Date:   Thu, 12 Mar 2020 06:05:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.24-171-gd262b82164a3
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 121 boots: 2 failed,
 113 passed with 3 offline, 3 untried/unknown (v5.4.24-171-gd262b82164a3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 121 boots: 2 failed, 113 passed with 3 offline,=
 3 untried/unknown (v5.4.24-171-gd262b82164a3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.24-171-gd262b82164a3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.24-171-gd262b82164a3/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.24-171-gd262b82164a3
Git Commit: d262b82164a3ad1264012b4041c6c75103fe153a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 89 unique boards, 23 SoC families, 18 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 32 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.4.24=
-169-g01c3b21f542b - first fail: v5.4.24-168-g877097a6286a)
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v5.4.24-170-g98d2a8785f=
3d)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.24-170-g98=
d2a8785f3d)
          meson-gxl-s805x-libretech-ac:
              lab-baylibre: new failure (last pass: v5.4.24-170-g98d2a8785f=
3d)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
