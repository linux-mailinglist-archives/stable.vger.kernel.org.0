Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50D26156AA5
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbgBINi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:38:28 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35266 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727340AbgBINi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:38:28 -0500
Received: by mail-wr1-f68.google.com with SMTP id w12so4280868wrt.2
        for <stable@vger.kernel.org>; Sun, 09 Feb 2020 05:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9r1+mVgV44d6e/tamyv6BA1kctskFn3unz58xi71VOE=;
        b=D/5BPAI++gzvO5NLEHQtr+CL68Ckzp3zgKH00/q4g69aS8Wgud90C2zMYwQ3Azuvc8
         1AJyDurHGCPP2MxOcIg0n2fGNGCXp+wV5wqnyKbUI0ZhW/AZCYS8LS0QJ9KwYUnMa5cO
         elwsRQCbWin1/6atmdb+fyiSTSlhbzYI6qsnFgmGYJyHU/ErS/dgQxYT7u4CYXM73hO5
         /wgOWxQ6QCtThtVJS/+eBMecoyD9BpLypfJ+euqOCrlH0XQ+ABr7XhUegjwOrc6oi3J4
         NlWKWR9zbtVFjhJZl6hoxq5Nnh4D+UlL64n6v8UfCYGxdtAv5f0vZnsAao16ZS1VOnUs
         JIBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9r1+mVgV44d6e/tamyv6BA1kctskFn3unz58xi71VOE=;
        b=t0sf5B7aChqJDd94bUBhppAFd/VY75nDRpXaOvT+zfR0UE2qfUoXLHMIdoiQiqOUFh
         m/IQZa7MgddDzIi+GHQGIlx5l/1GOaKT/Vszv7Y+NTgwHU8cMLGgq0vSt0nF/87667Eo
         rWwLVuLGJ7NB83wnVrDb9WZN6eFL3ItNTA7TwY3j8h9BtAdpSUgGEUD15+VQxL0IQeMZ
         1aJ/WvBF+TvhhwW5q+wXQf0ubemvw1MDUzq2iEjZHw9cPYAzqi+I98mf1S2EL7EnJu5e
         nhy8oBEnSQe93k2u180IzVdXtKm+t8TMkIEPqwDJsVrmBpB1vWB24M8FyHKcLwKDGdjl
         KANg==
X-Gm-Message-State: APjAAAWzAFy3LtuLs0+L3t8bE4DJePAbhPe8RVRn7IkO2xsJpYG836qb
        xFhkIciINTCJK0VIiW4Y0Pjti7Oxf68=
X-Google-Smtp-Source: APXvYqwafqnXO2B3yW4vfVsBITWzC4jnzQZP6RqGUoXjuR1r7R6VLEkUh5JHuV9Nlc8jc+6U0VGiGQ==
X-Received: by 2002:adf:82ee:: with SMTP id 101mr11102587wrc.130.1581255506278;
        Sun, 09 Feb 2020 05:38:26 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k8sm11856229wrq.67.2020.02.09.05.38.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 05:38:25 -0800 (PST)
Message-ID: <5e400b51.1c69fb81.faf76.1cde@mx.google.com>
Date:   Sun, 09 Feb 2020 05:38:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.102-102-g77b07d6abbd2
Subject: stable-rc/linux-4.19.y boot: 82 boots: 4 failed,
 73 passed with 5 offline (v4.19.102-102-g77b07d6abbd2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 82 boots: 4 failed, 73 passed with 5 offline (=
v4.19.102-102-g77b07d6abbd2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.102-102-g77b07d6abbd2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.102-102-g77b07d6abbd2/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.102-102-g77b07d6abbd2
Git Commit: 77b07d6abbd2c34ac34c3a3b49ff66ce28c72649
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 20 SoC families, 17 builds out of 168

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.1=
01 - first fail: v4.19.102-96-g0632821fe218)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 4 days (last pass: v4.19.=
101 - first fail: v4.19.101-74-g32591972abd8)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.102-96-g0=
632821fe218)
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v4.19.102-96-g0632821fe=
218)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-p241: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
