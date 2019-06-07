Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 535A73849C
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 08:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfFGGwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 02:52:54 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:39140 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfFGGwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 02:52:54 -0400
Received: by mail-wr1-f43.google.com with SMTP id x4so955552wrt.6
        for <stable@vger.kernel.org>; Thu, 06 Jun 2019 23:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S3c+M62aKGXOmk1aiwpnFHX0m7JAIendNAEPmuKM/a4=;
        b=00p38/LgW9a9+E4Y/jaI/JCRDk8xTmFjGBT6HQc7HeDUpZiCAGTzEZuGnYk3MPRZIt
         czvPcA2dQhqJ+d1A32bkC3N8SG/H0z38z33MJ4S8CmSGW+aD1Xscmvn7tvmrKMOVa8lx
         25Kx5RqT8vVSjP6XlGRRbgSHUQPMHHLFt09zAdqtZSuggNeGSwMBlLlpjEN+hHiZ1Nlc
         bYinZjEUmW01u2h2wDaYVLJdT+OiELAvke2yccIM/YVG6VlGGtStCFBwDnpxpD6Z5VL9
         kUtlKHcGyjqLGUIqfeyf25Z7zWGh2f1y1qLacwYmYvdQzcsu6BxbYAmhwTI6Mc4agyGj
         6DFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S3c+M62aKGXOmk1aiwpnFHX0m7JAIendNAEPmuKM/a4=;
        b=gHip0u6iiuB2F3BjIdh8axTgYqFhO9E9cP70wfZHtM7zaVLVlzrxqDIW9h2Gc5LX9o
         kqHA7tbj4TYTF3XFPB8Uz4xH23O3ne380dPEgmLPyJk0hnX5ef5b5uBadaA7PplCve5f
         RdB02tX3BFc5ulvpqgyZfIiLV2K3imwzbwxlntRZVlnfrHm4Tf8WEgA+/v75aeXj343d
         vc198GOmryhxV7e6kroY3ST988VVq72iLO8Tz/ovKy5wiwtu94LPYBffvF/JURBTVckK
         C2vCFaZd6aHkiNcO2ryveLTPrcE3byP0q4OEIF3yC0ZTnV0chx+kTPWcdEl+VdC928BI
         kmlA==
X-Gm-Message-State: APjAAAUozccSjCZa2jtSD6DbVDOMN+5J6d59jJibHmwkqUGcpuJC9PPy
        rApKScIr0jxfOVWnoOh9geNTjOprVtqpPA==
X-Google-Smtp-Source: APXvYqw+Ve8DnU5pTo+CUzLpG/CPnKxAHZYDzB/6Tl+RkYMm2LmqMqIZ3vuUAb5vdSosx5lETaxJsQ==
X-Received: by 2002:a05:6000:146:: with SMTP id r6mr18899539wrx.237.1559890372443;
        Thu, 06 Jun 2019 23:52:52 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t140sm3852184wmt.0.2019.06.06.23.52.51
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 23:52:51 -0700 (PDT)
Message-ID: <5cfa09c3.1c69fb81.c38cc.7604@mx.google.com>
Date:   Thu, 06 Jun 2019 23:52:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.180-229-g093d40b46ce9
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 48 boots: 1 failed,
 39 passed with 7 offline, 1 conflict (v4.4.180-229-g093d40b46ce9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 48 boots: 1 failed, 39 passed with 7 offline, 1=
 conflict (v4.4.180-229-g093d40b46ce9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.180-229-g093d40b46ce9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.180-229-g093d40b46ce9/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.180-229-g093d40b46ce9
Git Commit: 093d40b46ce9a5ac6b88629afc3a37686500ad4d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 35 unique boards, 13 SoC families, 13 builds out of 190

Boot Regressions Detected:

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: new failure (last pass: v4.4.180-180-g600dd7440=
a0c)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
