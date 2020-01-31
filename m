Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A02A114EF60
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 16:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgAaPQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 10:16:38 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42825 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728971AbgAaPQi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 10:16:38 -0500
Received: by mail-wr1-f65.google.com with SMTP id k11so9004242wrd.9
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 07:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YolZg8tB4uFkKfdLwxW4pG3XwAYyySNpuaq7Pu6hciM=;
        b=quuFLHs+ewDRvUvldGOXKIwtylrWsYRSEG+0fv/VixX6ImdK5dnSvjYvZLDnx7BRHf
         l0ZhvxkCZUS2va8iEgVzrHSUiQvambom9V7ukcexIb9TJdiuuTjJdNHEGHxdRB6RHx7P
         I/r48BXs6smbEx8MSHm7Tr9X1ajMk6uvlhTZaVTP0Ywp7V53jaQOyyih4n60g8vT/Sg8
         3c7S2EJhipkIfzxZzjCfW7BLp+uxs5BvJCZt3ukm7SIkq8M9KJyzEgMrAtj+Aavq5wVl
         ereUm1G7nTZh+xOyIE3XLy43iQbrPTHDoLWTonOe2gzjPtTw79z3tgggXgwPQymX4JCx
         rFQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YolZg8tB4uFkKfdLwxW4pG3XwAYyySNpuaq7Pu6hciM=;
        b=siHqbYT4NB0Y1x4RXR6J/dWLN827/xE92lzFW6vOJLvzMy9p7Uf/MZM3szX0iLr60r
         +bU1SXkNWp8wry3vsrsipOCYtW0d/QB9iIhHxcIb4W+FTPnRhrrSFp1Wl8rSQaNy7acf
         kpz9k2aBj10H1TnNa0vpVqAop04KKTW9gkftI2rKBK2SE4NaICChip4aqQD/DNszb6uA
         GSN1xhoXf+YCMrafBTvzJ5YY0wjKlDcRQF4tMfWr0WuFBsc1pzhCw1g/GKDBmxWW21WH
         3KhgiNiXrhPIjdiUDfBJbicccAaUg44qgmacf4tdtjdRQSBM4AJWH86HvaqmCwdl3df9
         6zGg==
X-Gm-Message-State: APjAAAUNrr9GvU/9pbjgMOPhG6P6kYVsTxvXm/IkFuIq7EjuyciUsGwU
        H3ompKo7/09P/ohGszQWVUHg4zv23SNAVA==
X-Google-Smtp-Source: APXvYqxXVZ6OLPn3+PhKzF2umFjumnuKsMTOph+vvIWCwl/xgdV6A5xhkJRdcZ+nhc0Z3Jb+P86T+Q==
X-Received: by 2002:adf:f28c:: with SMTP id k12mr13238306wro.360.1580483796733;
        Fri, 31 Jan 2020 07:16:36 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k7sm10888857wmi.19.2020.01.31.07.16.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 07:16:36 -0800 (PST)
Message-ID: <5e3444d4.1c69fb81.232b7.1804@mx.google.com>
Date:   Fri, 31 Jan 2020 07:16:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.100-56-g985d20b62b7c
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 93 boots: 2 failed,
 85 passed with 6 offline (v4.19.100-56-g985d20b62b7c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 93 boots: 2 failed, 85 passed with 6 offline (=
v4.19.100-56-g985d20b62b7c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.100-56-g985d20b62b7c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.100-56-g985d20b62b7c/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.100-56-g985d20b62b7c
Git Commit: 985d20b62b7cab0f7e2cf0e9253560f494e1a572
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 59 unique boards, 18 SoC families, 12 builds out of 176

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.19.100)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.9=
8-640-gd521598bed24 - first fail: v4.19.100)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.9=
8-640-gd521598bed24 - first fail: v4.19.100)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.100)
          sun50i-a64-bananapi-m64:
              lab-clabbe: new failure (last pass: v4.19.100)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
