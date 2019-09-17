Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76961B457E
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 04:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbfIQCZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 22:25:56 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35971 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728639AbfIQCZ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 22:25:56 -0400
Received: by mail-wr1-f65.google.com with SMTP id y19so1394792wrd.3
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 19:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aooPz/s9PSI22wNufZQ5QEhxgcLUGPcX/qWu5DI4ySI=;
        b=LHekHH2r8XlAT59pczW785meJ1qx0nB2KNul5MjlFSY945iklLHfgvjyRgg+1hMTL6
         /WvjxxMow5zIc8HByNqNLCV2lgZ7M77rM/rfsUQyvHzGZNRlfDE3t/lE4h/7M8UfDZac
         fKjSDBHKMs9WFuYfmRFfRkwoQ8mmoa+AeBaMuSDnahleXp235aKmwOMNym/zOU4/SXlU
         OwZ8vzm7yEPzMwguyYI2OJNoRKEaGeLkWG/Jm3Zjr6pgbXDuZnwmVtWNJehS1GlnLhsI
         u/GWH0OfxXlBurFdWkJC5BgKEr4rfAowdieftNnFJiGCqa9RD01aUBDUy9UoPldmShHL
         AtzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aooPz/s9PSI22wNufZQ5QEhxgcLUGPcX/qWu5DI4ySI=;
        b=DotccJXdeLLeFuPWtJvXXjjjUNsq21YZhSPfe3ZY2Tc7E0bwkvQOQFfOk0VQg8fkC5
         IuU0vWhgxfGFrfVPet0TkioNlfCbPIiOHvTRcDjc8EZbN7zKTWf18M5T5N1kQgKpM4a6
         +cH7QCi4ftTx2u5Y4Ah42zwvpVQI/UHRRCSFlgh4Sxfm81sZF0BhD9536Ue3Qv4n+pHg
         OxQMawtFJ5sNiZx57/1Vcux5kCDh0yUmnge7yFLMaOxGRxyEC8xJ3y+Cc/Tcyb+njm54
         OFVY3dcgxbwx4NLKx8p+FcgTzQBNdgoTQPJDBAlAyWkHy+CUn27SKW7luzcamPv0Zzri
         nn3w==
X-Gm-Message-State: APjAAAWZGaiVirT+euxBoNql0ctkwXs0BCBUz5DOmj53+oAOdr9zrqcq
        O/wN3SbK2LK8vkyH6aihow6fpYUNYjXtTg==
X-Google-Smtp-Source: APXvYqw/rWLKLgH9JDempzdgIWj/2H/qGePI+VXwMXDQIO4S4cVNQsFc4uZWKXLfV05+sl/cUNh2tw==
X-Received: by 2002:adf:dc03:: with SMTP id t3mr116011wri.27.1568687154789;
        Mon, 16 Sep 2019 19:25:54 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d9sm836232wrf.62.2019.09.16.19.25.53
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 19:25:53 -0700 (PDT)
Message-ID: <5d804431.1c69fb81.1d272.364e@mx.google.com>
Date:   Mon, 16 Sep 2019 19:25:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.193-18-g8cf87db9cf54
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 101 boots: 2 failed,
 87 passed with 11 offline, 1 conflict (v4.4.193-18-g8cf87db9cf54)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 101 boots: 2 failed, 87 passed with 11 offline,=
 1 conflict (v4.4.193-18-g8cf87db9cf54)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.193-18-g8cf87db9cf54/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.193-18-g8cf87db9cf54/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.193-18-g8cf87db9cf54
Git Commit: 8cf87db9cf54cf6dfec1f630cebd7980bc5750e1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 18 SoC families, 13 builds out of 190

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.4.193)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.4.193)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    davinci_all_defconfig:
        gcc-8:
            da850-evm: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    exynos_defconfig:
        exynos5422-odroidxu3:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
