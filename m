Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6A2F1567A8
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 21:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgBHUL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 15:11:59 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40977 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgBHUL7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 15:11:59 -0500
Received: by mail-wr1-f68.google.com with SMTP id c9so2835203wrw.8
        for <stable@vger.kernel.org>; Sat, 08 Feb 2020 12:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HJc9KugCkqaDWhlEsrTr4evWkaQQqSeZkfqwKkZFRIY=;
        b=jfZsz8A4AN8ur/2ZcBLubDTe+ZtzuDitgQLUYpWdrKjgZUnvqG6U19gNB3PvtEo7lI
         5CW4Zi7VKa8qca5sX2vC59QXr7KB+jl9r1lxBZxO12b9/ar9gCmSLM/obfAfeodZF2Wq
         RACsJwexd0tapO4CAtuT7a0RQKpGGsg/wTCfHwO18uXpAqmkSvRZvo/O+LKS2YnzmruK
         JJIUFPv0nJSqfRZZTX3oXE3zVjmYyPhmdGzIoHUzwZwiQnibEIOmLtvC/jRf1qCoQ4xC
         lajkiYPl2muvn7zataJ45EeS8C6rXLkPXy5OI1kJfAPjIigHHBl9oGY13GeDE72BRxlJ
         E/ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HJc9KugCkqaDWhlEsrTr4evWkaQQqSeZkfqwKkZFRIY=;
        b=raFPvmAHZ9tPzb1m+K40H1oiqg0C5a83EE+K/VgHoKvgjJ4RhMUZlEgasIiW0JQbtb
         dEDqFtOyVVVR1ONQLWa9kVUPKGrgymu+tUdym3WGoaYQtwkAH/tvIGTtDkcSAbI2JuX9
         C+cj3LzyDme7OZKxlzVgAGkWcO94lhfxSulXytRystskxMRymsEkQdwF6ik7///uiM/l
         a/p6vNBBSU30KdV0Oxjngt1daZ6xq2akYjh4PYjatKs9Z1ZamMJ4J7JX8eU2wyYPJdMv
         LgpVBJQxGT7UyKgOGAIbn/jb+Vw5Dh3vphb3ArNoVQ/WlnObpJ0BYf1QlSiFFW19rsGA
         oYLw==
X-Gm-Message-State: APjAAAVF5/BLADHtwMelwK1WYQZAoUuf5lAbSKm6Ng7EsJWpbuEkf5zZ
        ERNlOC9Ym914nzJv2gLojag5UBejXJE=
X-Google-Smtp-Source: APXvYqwf3I1pyt8ETrtJdWzcBxqfYwJo8gSXqoxYL6kCv6kA+4t5Gi01Upe+Y473/rlufWFrucsE4A==
X-Received: by 2002:adf:face:: with SMTP id a14mr6511833wrs.284.1581192716203;
        Sat, 08 Feb 2020 12:11:56 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e17sm8463428wrn.62.2020.02.08.12.11.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Feb 2020 12:11:54 -0800 (PST)
Message-ID: <5e3f160a.1c69fb81.bd16a.4a16@mx.google.com>
Date:   Sat, 08 Feb 2020 12:11:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.213-36-g658adae2f5dc
Subject: stable-rc/linux-4.9.y boot: 27 boots: 1 failed,
 24 passed with 2 offline (v4.9.213-36-g658adae2f5dc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 27 boots: 1 failed, 24 passed with 2 offline (v=
4.9.213-36-g658adae2f5dc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.213-36-g658adae2f5dc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.213-36-g658adae2f5dc/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.213-36-g658adae2f5dc
Git Commit: 658adae2f5dc58036e4e62ede5bd7dd4019bfec4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 26 unique boards, 11 SoC families, 10 builds out of 144

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: failing since 1 day (last pass: v4.9.213-37-g86=
0ec95da9ad - first fail: v4.9.213-37-g0c8606b6eeb4)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.21=
3 - first fail: v4.9.213-37-g860ec95da9ad)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab

---
For more info write to <info@kernelci.org>
